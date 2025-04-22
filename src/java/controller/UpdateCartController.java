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

@WebServlet("/UpdateCartController")
public class UpdateCartController extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        try {
            String action = request.getParameter("action");
            if (action == null) {
                action = "update"; // Default action
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
                    updateCartItem(cart, productId, newQuantity, session, out);
                    break;
                case "remove":
                    removeCartItem(cart, productId, session, out);
                    break;
                case "clear":
                    clearCart(cart, session, out);
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

    private void updateCartItem(List<CartItem> cart, int productId, int newQuantity, HttpSession session, PrintWriter out) {
        for (CartItem item : cart) {
            if (item.getProduct().getId() == productId) {
                int oldQuantity = item.getQuantity();
                int quantityDifference = newQuantity - oldQuantity;

                if (newQuantity <= 0) {
                    out.print("{\"status\":\"error\",\"message\":\"Quantity must be positive\"}");
                    return;
                }

                if (!ProductDAO.updateProductQuantity(productId, -quantityDifference)) {
                    out.print("{\"status\":\"error\",\"message\":\"Not enough stock available\"}");
                    return;
                }

                item.setQuantity(newQuantity);

                // Update cartCount after quantity change
                updateCartCount(session, cart);

                out.print("{\"status\":\"success\",\"message\":\"Quantity updated\"}");
                return;
            }
        }
        out.print("{\"status\":\"error\",\"message\":\"Product not found in cart\"}");
    }

    private void removeCartItem(List<CartItem> cart, int productId, HttpSession session, PrintWriter out) {
        Iterator<CartItem> iterator = cart.iterator();
        while (iterator.hasNext()) {
            CartItem item = iterator.next();
            if (item.getProduct().getId() == productId) {
                if (!ProductDAO.updateProductQuantity(productId, item.getQuantity())) {
                    out.print("{\"status\":\"error\",\"message\":\"Failed to update stock\"}");
                    return;
                }

                iterator.remove();

                // Update cartCount after item removal
                updateCartCount(session, cart);

                out.print("{\"status\":\"success\",\"message\":\"Item removed from cart\"}");
                return;
            }
        }
        out.print("{\"status\":\"error\",\"message\":\"Product not found in cart\"}");
    }

    private void clearCart(List<CartItem> cart, HttpSession session, PrintWriter out) {
        try {
            for (CartItem item : cart) {
                ProductDAO.updateProductQuantity(item.getProduct().getId(), item.getQuantity());
            }

            cart.clear();

            // Update cartCount to 0
            session.setAttribute("cartCount", 0);

            out.print("{\"status\":\"success\",\"message\":\"Cart cleared\"}");
        } catch (Exception e) {
            out.print("{\"status\":\"error\",\"message\":\"Failed to clear cart: " + e.getMessage() + "\"}");
        }
    }

    private void updateCartCount(HttpSession session, List<CartItem> cart) {
        int totalItems = 0;
        for (CartItem item : cart) {
            totalItems += item.getQuantity();
        }
        session.setAttribute("cartCount", totalItems);
    }
}
