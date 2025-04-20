package controller;

import dao.ProductDAO;
import dao.ImageDAO;
import model.Product;
import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;
import java.io.*;
import java.nio.file.*;

@WebServlet("/AddProductController")
@MultipartConfig
public class AddProductController extends HttpServlet {
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Keep Images directory for fallback only
        String uploadPath = getServletContext().getRealPath("") + File.separator + "Images";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdir();

        try {
            // Get form data
            String name = request.getParameter("name");
            double price = Double.parseDouble(request.getParameter("price"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            String category = request.getParameter("category");
            Part imagePart = request.getPart("image");
            String description = request.getParameter("description");
            
            // Handle custom category if selected
            if ("Other".equals(category)) {
                String customCategory = request.getParameter("customCategory");
                if (customCategory != null && !customCategory.trim().isEmpty()) {
                    category = customCategory;
                }
            }
            
            // Validate
            if (name == null || name.trim().isEmpty() || price <= 0 || 
                category == null || category.trim().isEmpty() || imagePart == null) {
                throw new Exception("Invalid product data");
            }

            // Format description to include category (if not already there)
            if (description == null || description.trim().isEmpty()) {
                description = category; // Use category as description if none provided
            } else if (!description.toLowerCase().contains(category.toLowerCase())) {
                // Prepend category to description if not already included
                description = category + " - " + description;
            }

            // Create product object
            Product product = new Product();
            product.setName(name);
            product.setPrice(price);
            product.setQuantity(quantity);
            product.setDescription(description);
            
            // Process image upload if provided
            if (imagePart != null && imagePart.getSize() > 0) {
                String fileName = Paths.get(imagePart.getSubmittedFileName()).getFileName().toString();
                
                // Store image in database - PRIMARY STORAGE METHOD
                int imageId = ImageDAO.storeImage(imagePart.getInputStream(), fileName);
                
                if (imageId > 0) {
                    // Set the image path to our image servlet URL
                    product.setImage("image/" + imageId);
                    System.out.println("Image stored in database with ID: " + imageId);
                } else {
                    // Fallback to file system ONLY if database storage fails
                    System.err.println("WARNING: Database storage failed, falling back to filesystem");
                    String safeFileName = fileName.replaceAll("[^a-zA-Z0-9.\\-]", "_");
                    String uniqueFileName = System.currentTimeMillis() + "_" + safeFileName;
                    
                    imagePart.write(uploadPath + File.separator + uniqueFileName);
                    product.setImage("Images/" + uniqueFileName);
                    System.out.println("Image saved to filesystem as fallback: " + uniqueFileName);
                }
            } else {
                product.setImage("Images/default.jpg"); // Fallback to default image
            }
            
            if (!ProductDAO.addProduct(product)) {
                throw new Exception("Database error");
            }

            // Set success message
            request.getSession().setAttribute("adminMessage", "Product added successfully!");
            
        } catch (Exception e) {
            request.getSession().setAttribute("adminError", "Error: " + e.getMessage());
            e.printStackTrace(); // Log full stack trace
        }
        
        // Redirect back to admin product page
        response.sendRedirect("admin-product.jsp");
    }
}