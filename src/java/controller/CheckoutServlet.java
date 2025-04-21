/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

/**
 *
 * @author wonghx
 */

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.CartItem;
import model.User;

@WebServlet("/CheckoutServlet")
public class CheckoutServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        // Check if user is logged in
        User user = (User) session.getAttribute("user");
        if (user == null) {
            // User is not logged in, redirect to login page with a message
            session.setAttribute("redirectAfterLogin", "CheckoutServlet");
            response.sendRedirect("login.jsp?checkout=1");
            return;
        }
        
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        
        if (cart == null || cart.isEmpty()) {
            response.sendRedirect("cart.jsp");
            return;
        }
        
        // Calculate total
        double total = 0;
        for (CartItem item : cart) {
            total += item.getProduct().getPrice() * item.getQuantity();
        }
        
         // Get shipping option from session or default
        String shippingOption = (String) session.getAttribute("shippingOption");
        if (shippingOption == null) {
            shippingOption = "nextDay";
            session.setAttribute("shippingOption", shippingOption);
        }
        
        request.setAttribute("cartItems", cart);
        request.setAttribute("total", total);
        request.getRequestDispatcher("Checkout.jsp").forward(request, response);
    }
}