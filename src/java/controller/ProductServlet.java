package controller;

import controller.ProductDAO;
import entity.Product;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/products")
public class ProductServlet extends HttpServlet {
    private ProductDAO productDAO;

    @Override
    public void init() {
        productDAO = new ProductDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Check if a specific product is requested
        System.out.println("DEBUG: ProductServlet doGet method called");
        String productId = request.getParameter("id");
        
        if (productId != null && !productId.isEmpty()) {
            // Show details for a single product
            showProductDetails(request, response);
        } else {
            // List all products
            listProducts(request, response);
        }
    }

    private void listProducts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Product> products = productDAO.getAllProducts();
        System.out.println("DEBUG: Servlet retrieved " + products.size() + " products");
        request.setAttribute("products", products);
        // Update the path to the correct location
        request.getRequestDispatcher("/customer/product-list.jsp").forward(request, response);
    }

    private void showProductDetails(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int productId = Integer.parseInt(request.getParameter("id"));
        Product product = productDAO.getProductById(productId);
        
        if (product != null) {
            request.setAttribute("product", product);
            // Update the path to the correct location
            request.getRequestDispatcher("/customer/product-details.jsp").forward(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Product not found");
        }
    }
}