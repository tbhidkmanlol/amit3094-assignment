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

        // Keep a reference to the Images directory for fallback
        String uploadPath = getServletContext().getRealPath("/Images");
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs(); // Create Images folder if it doesn't exist
        }

        try {
            // Get form data
            String name = request.getParameter("name");
            double price = Double.parseDouble(request.getParameter("price"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            String description = request.getParameter("description");
            Part filePart = request.getPart("image");

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

            // Initialize product object
            Product product = new Product();
            product.setName(name.trim());
            product.setPrice(price);
            product.setQuantity(quantity);
            product.setDescription(description);

            // Process image upload if provided
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                
                // Store image in database
                int imageId = ImageDAO.storeImage(filePart.getInputStream(), fileName);
                
                if (imageId > 0) {
                    // Set the image path to our image servlet URL
                    product.setImage("image/" + imageId);
                    System.out.println("Image stored in database with ID: " + imageId);
                } else {
                    // Fallback to file system if database storage failed
                    System.out.println("Database storage failed, falling back to file system");
                    String safeFileName = fileName.replaceAll("[^a-zA-Z0-9.\\-]", "_");
                    String uniqueFileName = System.currentTimeMillis() + "_" + safeFileName;
                    
                    File targetFile = new File(uploadDir, uniqueFileName);
                    try (InputStream input = filePart.getInputStream();
                         FileOutputStream output = new FileOutputStream(targetFile)) {
                        byte[] buffer = new byte[1024];
                        int length;
                        while ((length = input.read(buffer)) > 0) {
                            output.write(buffer, 0, length);
                        }
                    }
                    
                    product.setImage("Images/" + uniqueFileName);
                }
            } else {
                product.setImage("Images/default.jpg"); // Fallback to default image
            }

            // Save product using DAO
            if (!ProductDAO.addProduct(product)) {
                throw new Exception("Failed to save product to database");
            }

            request.getSession().setAttribute("adminMessage", "Product added successfully!");

        } catch (Exception e) {
            request.getSession().setAttribute("adminError", "Error: " + e.getMessage());
        }

        response.sendRedirect("../admin-product.jsp");
    }
}
