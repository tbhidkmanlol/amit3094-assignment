package controller;

import dao.ProductDAO;
import model.Product;
import model.CartItem;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.*;

@WebServlet("/add-to-cart")
public class AddToCartController extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Support both redirects and AJAX requests
        boolean isAjax = "XMLHttpRequest".equals(request.getHeader("X-Requested-With"));
        
        if (isAjax) {
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            
            try {
                // Process cart addition
                CartResult result = processAddToCart(request);
                
                // Return JSON response
                out.print("{\"status\":\"success\",\"message\":\"" + result.message + "\",\"itemCount\":" + result.itemCount + "}");
            } catch (Exception e) {
                out.print("{\"status\":\"error\",\"message\":\"" + e.getMessage() + "\"}");
            }
        } else {
            try {
                // Process cart addition
                processAddToCart(request);
                
                // Redirect to cart page for non-AJAX requests
                response.sendRedirect("cart.jsp");
            } catch (Exception e) {
                e.printStackTrace();
                request.getSession().setAttribute("error", "Error adding to cart: " + e.getMessage());
                response.sendRedirect("CartController");
            }
        }
    }
    
    private CartResult processAddToCart(HttpServletRequest request) throws Exception {
        // 1. Get parameters
        int productId = Integer.parseInt(request.getParameter("productId"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        
        // 2. Validate quantity
        if (quantity <= 0) {
            throw new Exception("Quantity must be positive");
        }
        
        // 3. Get product from database
        Product product = ProductDAO.getProductById(productId);
        if (product == null) {
            throw new Exception("Product not found");
        }
        
        // 4. Check available quantity
        if (product.getQuantity() < quantity) {
            throw new Exception("Not enough stock available. Only " + product.getQuantity() + " left.");
        }
        
        // 5. Deduct quantity from database FIRST
        if (!ProductDAO.deductProductQuantity(productId, quantity)) {
            throw new Exception("Failed to reserve product quantity");
        }
        
        // 6. Then add to cart
        HttpSession session = request.getSession();
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        
        if (cart == null) {
            cart = new ArrayList<>();
            session.setAttribute("cart", cart);
        }
        
        // 7. Check if product already in cart
        boolean found = false;
        for (CartItem item : cart) {
            if (item.getProduct().getId() == productId) {
                item.setQuantity(item.getQuantity() + quantity);
                found = true;
                break;
            }
        }
        
        if (!found) {
            cart.add(new CartItem(product, quantity));
        }
        
        // Calculate total items in cart
        int totalItems = 0;
        for (CartItem item : cart) {
            totalItems += item.getQuantity();
        }
        
        String message = quantity + " " + product.getName() + (quantity > 1 ? "s" : "") + " added to cart";
        return new CartResult(message, totalItems);
    }
    
    // Helper class for returning cart operation results
    private static class CartResult {
        public String message;
        public int itemCount;
        
        public CartResult(String message, int itemCount) {
            this.message = message;
            this.itemCount = itemCount;
        }
    }
}