package controller;

import dao.ProductDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/admin/restock-product")
public class RestockController extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            
            if (quantity <= 0) {
                throw new Exception("Quantity must be positive");
            }
            
            if (!ProductDAO.restockProduct(productId, quantity)) {
                throw new Exception("Failed to update product quantity");
            }
            
            request.getSession().setAttribute("adminMessage", "Product restocked successfully!");
            
        } catch (Exception e) {
            request.getSession().setAttribute("adminError", "Error: " + e.getMessage());
        }
        
        response.sendRedirect("../admin-product.jsp");
    }
}