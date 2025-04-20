package controller;

import dao.ProductDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.List;
import model.Product;

@WebServlet("/ProductSearchController")
public class ProductSearchController extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String searchTerm = request.getParameter("searchTerm");
        List<Product> products;
        
        if (searchTerm == null || searchTerm.trim().isEmpty()) {
            // If search term is empty, show all products
            products = ProductDAO.getAllProducts();
        } else {
            try {
                // Try to parse as ID first
                int id = Integer.parseInt(searchTerm);
                Product product = ProductDAO.getProductById(id);
                products = product != null ? List.of(product) : List.of();
            } catch (NumberFormatException e) {
                // If not a number, search by name
                products = ProductDAO.searchProductsByName(searchTerm);
            }
        }
        
        request.setAttribute("products", products);
        request.getRequestDispatcher("Product.jsp").forward(request, response);
    }
}