/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import controller.ProductDAO;
import entity.Product;
import entity.ShoppingCart;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {
    
    private ProductDAO productDAO;
    
    @Override
    public void init() {
        productDAO = new ProductDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        ShoppingCart cart = (ShoppingCart) session.getAttribute("cart");
        
        if (cart == null) {
            cart = new ShoppingCart();
            session.setAttribute("cart", cart);
        }
        
        request.getRequestDispatcher("/WEB-INF/views/cart.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }
        
        HttpSession session = request.getSession();
        ShoppingCart cart = (ShoppingCart) session.getAttribute("cart");
        
        if (cart == null) {
            cart = new ShoppingCart();
            session.setAttribute("cart", cart);
        }
        
        switch (action) {
            case "add":
                addToCart(request, cart);
                break;
            case "update":
                updateCart(request, cart);
                break;
            case "remove":
                removeFromCart(request, cart);
                break;
            default:
                break;
        }
        
        String referer = request.getHeader("Referer");
        if (referer != null && !referer.contains("/cart") && action.equals("add")) {
            // If adding to cart from a product page, redirect back to that page
            response.sendRedirect(referer);
        } else {
            // Otherwise go to the cart page
            response.sendRedirect(request.getContextPath() + "/cart");
        }
    }
    
    private void addToCart(HttpServletRequest request, ShoppingCart cart) {
        int productId = Integer.parseInt(request.getParameter("productId"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        
        if (quantity > 0) {
            Product product = productDAO.getProductById(productId);
            if (product != null) {
                cart.addItem(product, quantity);
            }
        }
    }
    
    private void updateCart(HttpServletRequest request, ShoppingCart cart) {
        int productId = Integer.parseInt(request.getParameter("productId"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        
        cart.updateQuantity(productId, quantity);
    }
    
    private void removeFromCart(HttpServletRequest request, ShoppingCart cart) {
        int productId = Integer.parseInt(request.getParameter("productId"));
        cart.removeItem(productId);
    }
}
