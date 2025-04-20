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
import java.util.List;
import model.CartItem;

/**
 *
 * @author Dell
 */
@WebServlet("/ClearCartController")
public class ClearCartController extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        boolean isAjax = "XMLHttpRequest".equals(request.getHeader("X-Requested-With"));
        
        if (isAjax) {
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            
            try {
                if (clearCart(request)) {
                    out.print("{\"status\":\"success\",\"message\":\"Cart cleared successfully\",\"itemCount\":0}");
                } else {
                    out.print("{\"status\":\"error\",\"message\":\"Failed to clear cart\"}");
                }
            } catch (Exception e) {
                out.print("{\"status\":\"error\",\"message\":\"Server error: " + e.getMessage() + "\"}");
            }
        } else {
            try {
                if (clearCart(request)) {
                    request.getSession().setAttribute("message", "Cart cleared successfully");
                } else {
                    request.getSession().setAttribute("error", "Failed to clear cart");
                }
                response.sendRedirect("CartController?action=view");
            } catch (Exception e) {
                request.getSession().setAttribute("error", "Error: " + e.getMessage());
                response.sendRedirect("CartController?action=view");
            }
        }
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
    
    private boolean clearCart(HttpServletRequest request) {
        try {
            HttpSession session = request.getSession();
            List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
            
            if (cart != null) {
                // Return all quantities to inventory
                for (CartItem item : cart) {
                    ProductDAO.updateProductQuantity(item.getProduct().getId(), item.getQuantity());
                }
                
                cart.clear();
                return true;
            }
            return false;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}