package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.PrintWriter;
import model.CartItem;
import java.util.List;

@WebServlet("/UpdateCCartServlet")
public class UpdateCCartServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        try {
            String productId = request.getParameter("productId");
            int quantity = Integer.parseInt(request.getParameter("quantity"));

            // Log information for debugging
            System.out.println("UpdateCCartServlet: Received product ID: " + productId);
            System.out.println("UpdateCCartServlet: Received quantity: " + quantity);

            HttpSession session = request.getSession();
            List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

            if (cart != null) {
                boolean found = false;

                // Debug cart content
                System.out.println("Cart has " + cart.size() + " items");
                for (int i = 0; i < cart.size(); i++) {
                    CartItem item = cart.get(i);
                    if (item != null && item.getProduct() != null) {
                        int idInt = item.getProduct().getId();
                        String id = String.valueOf(idInt);
                        System.out.println("Cart item " + i + " has product ID: [" + id + "]");

                        // Compare with received ID using equals method and trim both strings
                        if (productId != null && productId.trim().equals(id.trim())) {
                            System.out.println("Match found! Updating quantity to: " + quantity);
                            item.setQuantity(quantity);
                            found = true;
                            break;
                        }
                    }
                }

                if (found) {
                    session.setAttribute("cart", cart);
                    out.write("{\"success\": true}");
                    System.out.println("Cart updated successfully");
                } else {
                    out.write("{\"success\": false, \"error\": \"Product not found in cart\"}");
                    System.out.println("Product not found in cart: " + productId);
                }
            } else {
                out.write("{\"success\": false, \"error\": \"Cart is empty\"}");
                System.out.println("Cart is null or empty");
            }

        } catch (NumberFormatException e) {
            out.write("{\"success\": false, \"error\": \"Invalid quantity format\"}");
            System.out.println("NumberFormatException: " + e.getMessage());
        } catch (Exception e) {
            out.write("{\"success\": false, \"error\": \"" + e.getMessage() + "\"}");
            System.out.println("Exception in UpdateCCartServlet: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
