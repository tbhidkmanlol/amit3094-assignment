package controller;

import dao.ProductDAO;
import model.Product;
import model.CartItem;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

@WebServlet("/CartController")
public class CartController extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("view".equals(action)) {
            // Display cart contents
            displayCart(request, response);
        } else {
            // Default action - display products
            displayProducts(request, response);
        }
    }
    
    private void displayProducts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get filter parameters
            String category = request.getParameter("category");
            String sortBy = request.getParameter("sortBy");
            String search = request.getParameter("search");
            
            List<Product> productList;
            
            // Apply filters if present
            if (category != null && !category.isEmpty()) {
                productList = ProductDAO.getProductsByCategory(category);
            } else if (search != null && !search.isEmpty()) {
                productList = ProductDAO.searchProducts(search);
            } else {
                productList = ProductDAO.getAllProducts();
            }
            
            // Sort products if requested
            if (sortBy != null) {
                switch(sortBy) {
                    case "priceAsc":
                        productList.sort((p1, p2) -> Double.compare(p1.getPrice(), p2.getPrice()));
                        break;
                    case "priceDesc":
                        productList.sort((p1, p2) -> Double.compare(p2.getPrice(), p1.getPrice()));
                        break;
                    case "nameAsc":
                        productList.sort((p1, p2) -> p1.getName().compareToIgnoreCase(p2.getName()));
                        break;
                    case "nameDesc":
                        productList.sort((p1, p2) -> p2.getName().compareToIgnoreCase(p1.getName()));
                        break;
                }
            }
            
            // Get available categories for the filter menu
            List<String> categories = ProductDAO.getAllCategories();
            
            request.setAttribute("products", productList);
            request.setAttribute("categories", categories);
            request.setAttribute("selectedCategory", category);
            request.setAttribute("selectedSort", sortBy);
            request.setAttribute("searchQuery", search);
            
            // Debug output
            System.out.println("Number of products loaded: " + productList.size());
            
            request.getRequestDispatcher("Product.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading products: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }
    
    private void displayCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
            
            // Calculate cart totals
            double subtotal = 0.0;
            int totalItems = 0;
            
            if (cart != null && !cart.isEmpty()) {
                for (CartItem item : cart) {
                    subtotal += item.getProduct().getPrice() * item.getQuantity();
                    totalItems += item.getQuantity();
                    
                    // Verify stock availability for each item
                    Product freshProduct = ProductDAO.getProductById(item.getProduct().getId());
                    if (freshProduct != null && freshProduct.getQuantity() < item.getQuantity()) {
                        request.setAttribute("stockWarning", "Some items in your cart may have limited stock.");
                        break;
                    }
                }
            } else {
                request.setAttribute("emptyCart", true);
            }
            
            // Calculate tax and shipping
            double tax = subtotal * 0.07; // 7% tax
            double shipping = subtotal > 100 ? 0 : 10; // Free shipping over $100
            double total = subtotal + tax + shipping;
            
            // Set attributes for the view
            request.setAttribute("cart", cart);
            request.setAttribute("subtotal", subtotal);
            request.setAttribute("tax", tax);
            request.setAttribute("shipping", shipping);
            request.setAttribute("total", total);
            request.setAttribute("totalItems", totalItems);
            
            request.getRequestDispatcher("cart.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error displaying cart: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }
}