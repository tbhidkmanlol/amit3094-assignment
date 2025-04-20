package controller;

import dao.ProductDAO;
import dao.ImageDAO;
import model.Product;
import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;
import java.io.*;
import java.nio.file.*;

@WebServlet("/admin/add-product")
@MultipartConfig
public class AdminProductController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Reference to Images directory for fallback only
        String uploadPath = getServletContext().getRealPath("/Images");
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        try {
            // Get form data
            String name = request.getParameter("name");
            double price = Double.parseDouble(request.getParameter("price"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            String description = request.getParameter("description");
            String category = request.getParameter("category");
            Part filePart = request.getPart("image");
            
            // Handle custom category if selected
            if ("Other".equals(category)) {
                String customCategory = request.getParameter("customCategory");
                if (customCategory != null && !customCategory.trim().isEmpty()) {
                    category = customCategory;
                }
            }

            // Validate form inputs
            if (name == null || name.trim().isEmpty()) {
                throw new Exception("Product name cannot be empty");
            }
            if (price <= 0) {
                throw new Exception("Price must be positive");
            }
            if (quantity < 0) {
                throw new Exception("Quantity cannot be negative");
            }
            
            // Format description to include category (if not already there)
            if (description == null || description.trim().isEmpty()) {
                description = category; // Use category as description if none provided
            } else if (!description.toLowerCase().contains(category.toLowerCase())) {
                description = category + " - " + description;
            }

            // Initialize product object
            Product product = new Product();
            product.setName(name.trim());
            product.setPrice(price);
            product.setQuantity(quantity);
            product.setDescription(description);

            // Process image upload if provided
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                
                // Store image in database - PRIMARY METHOD
                int imageId = ImageDAO.storeImage(filePart.getInputStream(), fileName);
                
                if (imageId > 0) {
                    // Set the image path to our servlet URL format
                    product.setImage("image/" + imageId);
                    System.out.println("Image successfully stored in database with ID: " + imageId);
                } else {
                    // Fallback to filesystem ONLY if database storage fails
                    System.err.println("WARNING: Database storage failed, falling back to filesystem");
                    String safeFileName = fileName.replaceAll("[^a-zA-Z0-9.\\-]", "_");
                    String uniqueFileName = System.currentTimeMillis() + "_" + safeFileName;
                    
                    // Reset the input stream for the second attempt
                    filePart.write(uploadPath + File.separator + uniqueFileName);
                    product.setImage("Images/" + uniqueFileName);
                    System.out.println("Image saved to filesystem as fallback: " + uniqueFileName);
                }
            } else {
                product.setImage("Images/default.jpg"); // Default image
                System.out.println("No image provided, using default image");
            }

            // Save product using DAO
            if (!ProductDAO.addProduct(product)) {
                throw new Exception("Failed to save product to database");
            }

            request.getSession().setAttribute("adminMessage", "Product added successfully!");

        } catch (Exception e) {
            e.printStackTrace(); // Log the full stack trace
            request.getSession().setAttribute("adminError", "Error: " + e.getMessage());
        }

        response.sendRedirect("../admin-product.jsp");
    }
}
