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

@WebServlet("/RemoveFromCartController")
public class RemoveFromCartController extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        try {
            int productId = Integer.parseInt(request.getParameter("productId"));

            HttpSession session = request.getSession();
            List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

            if (cart != null) {
                Iterator<CartItem> iterator = cart.iterator();
                while (iterator.hasNext()) {
                    CartItem item = iterator.next();
                    if (item.getProduct().getId() == productId) {
                        // Return quantity to stock
                        if (!ProductDAO.updateProductQuantity(productId, item.getQuantity())) {
                            out.print("{\"status\":\"error\",\"message\":\"Failed to update stock\"}");
                            return;
                        }

                        String productName = item.getProduct().getName();
                        iterator.remove();

                        // Calculate total items remaining in cart
                        int totalItems = 0;
                        for (CartItem cartItem : cart) {
                            totalItems += cartItem.getQuantity();
                        }

                        // Update cartCount session
                        session.setAttribute("cartCount", totalItems);

                        out.print("{\"status\":\"success\",\"message\":\"" + productName + " removed from cart\",\"itemCount\":" + totalItems + "}");
                        return;
                    }
                }

                out.print("{\"status\":\"error\",\"message\":\"Product not found in cart\"}");
                return;
            }

            out.print("{\"status\":\"error\",\"message\":\"Cart not found\"}");
        } catch (NumberFormatException e) {
            out.print("{\"status\":\"error\",\"message\":\"Invalid product ID format\"}");
        } catch (Exception e) {
            out.print("{\"status\":\"error\",\"message\":\"Server error: " + e.getMessage() + "\"}");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int productId = Integer.parseInt(request.getParameter("productId"));

            HttpSession session = request.getSession();
            List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

            if (cart != null) {
                Iterator<CartItem> iterator = cart.iterator();
                while (iterator.hasNext()) {
                    CartItem item = iterator.next();
                    if (item.getProduct().getId() == productId) {
                        // Return quantity to stock
                        ProductDAO.updateProductQuantity(productId, item.getQuantity());
                        iterator.remove();

                        // Calculate and update cartCount session
                        int totalItems = 0;
                        for (CartItem cartItem : cart) {
                            totalItems += cartItem.getQuantity();
                        }
                        session.setAttribute("cartCount", totalItems);

                        session.setAttribute("message", "Item removed from cart");
                        response.sendRedirect("CartController?action=view");
                        return;
                    }
                }
            }

            session.setAttribute("error", "Could not remove item from cart");
            response.sendRedirect("CartController?action=view");

        } catch (Exception e) {
            request.getSession().setAttribute("error", "Error: " + e.getMessage());
            response.sendRedirect("CartController?action=view");
        }
    }
}
