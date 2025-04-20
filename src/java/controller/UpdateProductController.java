package controller;

import dao.ProductDAO;
import dao.ImageDAO;
import model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Paths;

@WebServlet("/admin/update-product")
@MultipartConfig
public class UpdateProductController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Reference to image directory for fallback only
        String uploadPath = getServletContext().getRealPath("/Images");
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
        
        try {
            // Get form data
            int productId = Integer.parseInt(request.getParameter("productId"));
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
            
            // Validate inputs
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
                description = category;
            } else if (!description.toLowerCase().contains(category.toLowerCase())) {
                description = category + " - " + description;
            }
            
            // Get the current product
            Product product = ProductDAO.getProductById(productId);
            if (product == null) {
                throw new Exception("Product not found");
            }
            
            // Update product properties
            product.setName(name);
            product.setPrice(price);
            product.setQuantity(quantity);
            product.setDescription(description);
            
            // Process image upload if provided
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                
                // Store image in database - PRIMARY STORAGE METHOD
                int imageId = ImageDAO.storeImage(filePart.getInputStream(), fileName);
                
                if (imageId > 0) {
                    // Set the image path to our image servlet URL
                    product.setImage("image/" + imageId);
                    System.out.println("Image stored in database with ID: " + imageId);
                } else {
                    // Fallback to file system if database storage failed
                    System.err.println("WARNING: Database storage failed, falling back to filesystem");
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
                    System.out.println("Image saved to filesystem as fallback: " + uniqueFileName);
                }
            }
            // Note: If no new image is provided, we keep the existing image path in the product object
            
            // Update the product in the database
            boolean success = ProductDAO.updateProduct(product);
            
            if (success) {
                request.getSession().setAttribute("adminMessage", "Product updated successfully");
            } else {
                request.getSession().setAttribute("adminError", "Failed to update product");
            }
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("adminError", "Invalid number format");
        } catch (Exception e) {
            e.printStackTrace(); // Log full stack trace
            request.getSession().setAttribute("adminError", "Error: " + e.getMessage());
        }
        
        // Redirect back to admin product page
        response.sendRedirect("../admin-product.jsp");
    }
}