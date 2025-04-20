package controller;

import dao.ProductDAO;
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
        
        // Create uploads directory if it doesn't exist
        String uploadPath = getServletContext().getRealPath("") + File.separator + "images";
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

            // Save image
            String fileName = Paths.get(imagePart.getSubmittedFileName()).getFileName().toString();
            String uniqueFileName = System.currentTimeMillis() + "_" + fileName;
            imagePart.write(uploadPath + File.separator + uniqueFileName);

            // Format description to include category (if not already there)
            if (description == null || description.trim().isEmpty()) {
                description = category; // Use category as description if none provided
            } else if (!description.toLowerCase().contains(category.toLowerCase())) {
                // Prepend category to description if not already included
                description = category + " - " + description;
            }

            // Create and save product
            Product product = new Product();
            product.setName(name);
            product.setPrice(price);
            product.setQuantity(quantity);
            product.setDescription(description);
            product.setImage("images/" + uniqueFileName);
            
            if (!ProductDAO.addProduct(product)) {
                throw new Exception("Database error");
            }

            // Set success message
            request.getSession().setAttribute("adminMessage", "Product added successfully!");
            
        } catch (Exception e) {
            request.getSession().setAttribute("adminError", "Error: " + e.getMessage());
        }
        
        // Redirect back to admin product page
        response.sendRedirect("admin-product.jsp");
    }
}