package controller;

import dao.ProductDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/admin/delete-product")
public class DeleteProductController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Get productId from form submission
            int productId = Integer.parseInt(request.getParameter("productId"));
            
            // Delete product
            boolean success = ProductDAO.deleteProduct(productId);
            
            if (success) {
                request.getSession().setAttribute("adminMessage", "Product deleted successfully");
            } else {
                request.getSession().setAttribute("adminError", "Failed to delete product. It may no longer exist.");
            }
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("adminError", "Invalid product ID format");
        } catch (Exception e) {
            request.getSession().setAttribute("adminError", "Error: " + e.getMessage());
        }
        
        // Redirect back to admin product page
        response.sendRedirect("../admin-product.jsp");
    }
    
    // Don't allow GET requests to delete products
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("../admin-product.jsp");
    }
}