/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import dao.ProductDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/admin/decrease-quantity")
public class DecreaseQuantityController extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // 1. Get parameters
            int productId = Integer.parseInt(request.getParameter("productId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            
            // 2. Validate inputs
            if (quantity <= 0) {
                throw new Exception("Quantity must be positive");
            }
            
            // 3. Check current quantity
            int currentQty = ProductDAO.getProductQuantity(productId);
            if (currentQty < 0) {
                throw new Exception("Product not found");
            }
            if (currentQty < quantity) {
                throw new Exception("Cannot decrease. Current stock: " + currentQty);
            }
            
            // 4. Update quantity
            if (!ProductDAO.reduceProductQuantity(productId, quantity)) {
                throw new Exception("Failed to update quantity");
            }
            
            // 5. Success message
            request.getSession().setAttribute("adminMessage", 
                "Decreased quantity by " + quantity + ". New stock: " + (currentQty - quantity));
            
        } catch (Exception e) {
            request.getSession().setAttribute("adminError", "Error: " + e.getMessage());
        }
        
        response.sendRedirect("../admin-product.jsp");
    }
}