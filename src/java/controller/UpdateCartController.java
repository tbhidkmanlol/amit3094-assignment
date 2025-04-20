/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import dao.ProductDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Iterator;
import java.util.List;
import model.CartItem;

/**
 *
 * @author Dell
 */
@WebServlet("/UpdateCartController")
public class UpdateCartController extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        try {
            String action = request.getParameter("action");
            if (action == null) {
                action = "update"; // Default action for backward compatibility
            }
            
            int productId = Integer.parseInt(request.getParameter("productId"));
            HttpSession session = request.getSession();
            List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
            
            if (cart == null) {
                out.print("{\"status\":\"error\",\"message\":\"Cart not found\"}");
                return;
            }
            
            // Handle different actions
            switch (action) {
                case "update":
                    int newQuantity = Integer.parseInt(request.getParameter("quantity"));
                    updateCartItem(cart, productId, newQuantity, out);
                    break;
                case "remove":
                    removeCartItem(cart, productId, out);
                    break;
                case "clear":
                    clearCart(cart, out);
                    break;
                default:
                    out.print("{\"status\":\"error\",\"message\":\"Invalid action\"}");
            }
        } catch (NumberFormatException e) {
            out.print("{\"status\":\"error\",\"message\":\"Invalid number format\"}");
        } catch (Exception e) {
            out.print("{\"status\":\"error\",\"message\":\"" + e.getMessage() + "\"}");
        }
    }
    
    private void updateCartItem(List<CartItem> cart, int productId, int newQuantity, PrintWriter out) {
        for (CartItem item : cart) {
            if (item.getProduct().getId() == productId) {
                int oldQuantity = item.getQuantity();
                int quantityDifference = newQuantity - oldQuantity;
                
                // Validate new quantity
                if (newQuantity <= 0) {
                    out.print("{\"status\":\"error\",\"message\":\"Quantity must be positive\"}");
                    return;
                }
                
                // Update database quantity
                if (!ProductDAO.updateProductQuantity(productId, -quantityDifference)) {
                    out.print("{\"status\":\"error\",\"message\":\"Not enough stock available\"}");
                    return;
                }

                item.setQuantity(newQuantity);
                out.print("{\"status\":\"success\",\"message\":\"Quantity updated\"}");
                return;
            }
        }
        
        out.print("{\"status\":\"error\",\"message\":\"Product not found in cart\"}");
    }
    
    private void removeCartItem(List<CartItem> cart, int productId, PrintWriter out) {
        Iterator<CartItem> iterator = cart.iterator();
        while (iterator.hasNext()) {
            CartItem item = iterator.next();
            if (item.getProduct().getId() == productId) {
                // Return quantity to stock
                if (!ProductDAO.updateProductQuantity(productId, item.getQuantity())) {
                    out.print("{\"status\":\"error\",\"message\":\"Failed to update stock\"}");
                    return;
                }
                
                iterator.remove();
                out.print("{\"status\":\"success\",\"message\":\"Item removed from cart\"}");
                return;
            }
        }
        
        out.print("{\"status\":\"error\",\"message\":\"Product not found in cart\"}");
    }
    
    private void clearCart(List<CartItem> cart, PrintWriter out) {
        try {
            // Return all quantities to inventory
            for (CartItem item : cart) {
                ProductDAO.updateProductQuantity(item.getProduct().getId(), item.getQuantity());
            }
            
            cart.clear();
            out.print("{\"status\":\"success\",\"message\":\"Cart cleared\"}");
        } catch (Exception e) {
            out.print("{\"status\":\"error\",\"message\":\"Failed to clear cart: " + e.getMessage() + "\"}");
        }
    }
}
