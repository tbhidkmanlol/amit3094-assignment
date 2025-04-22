package controller;

import dao.ProductDAO;
import model.Product;
import model.CartItem;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.*;

@WebServlet("/add-to-cart")
public class AddToCartController extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
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

            // 5. Deduct quantity from database
            if (!ProductDAO.deductProductQuantity(productId, quantity)) {
                throw new Exception("Failed to reserve product quantity");
            }

            // 6. Add to session cart
            HttpSession session = request.getSession();
            List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
            if (cart == null) {
                cart = new ArrayList<>();
                session.setAttribute("cart", cart);
            }

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

            // 7. Calculate total cart quantity
            int totalQuantity = 0;
            for (CartItem item : cart) {
                totalQuantity += item.getQuantity();
            }
            session.setAttribute("cartCount", totalQuantity);

            // 8. Redirect to cart page
            response.sendRedirect("cart.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Error adding to cart: " + e.getMessage());
            response.sendRedirect("CartController");
        }
    }
}
