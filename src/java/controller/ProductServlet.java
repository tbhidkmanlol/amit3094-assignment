/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
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

@WebServlet("/homepage/customer/product-list.jsp")
public class ProductServlet extends HttpServlet {

    private ProductDAO productDAO;

    @Override
    public void init() {
        productDAO = new ProductDAO();
        productDAO.initializeDatabase();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "view":
                viewProduct(request, response);
                break;
            case "search":
                searchProducts(request, response);
                break;
            default:
                listProducts(request, response);
                break;
        }
        System.out.println("Servlet called with action: " + action); //debug
    }

    private void listProducts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Product> products = productDAO.getAllProducts();
        request.setAttribute("products", products);
        request.getRequestDispatcher("/customer/product-list.jsp").forward(request, response);
    }

    private void viewProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int productId = Integer.parseInt(request.getParameter("id"));
        Product product = productDAO.getProductById(productId);

        if (product != null) {
            request.setAttribute("product", product);
            request.getRequestDispatcher("/customer/product-list.jsp").forward(request, response);
        } else {
            request.setAttribute("errorMessage", "Product not found");
            listProducts(request, response);
        }
    }

    private void searchProducts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");

        if (keyword != null && !keyword.trim().isEmpty()) {
            List<Product> products = productDAO.searchProducts(keyword);
            request.setAttribute("products", products);
            request.setAttribute("keyword", keyword);
        } else {
            request.setAttribute("errorMessage", "Please enter a search keyword");
            listProducts(request, response);
            return;
        }

        request.getRequestDispatcher("/customer/product-list.jsp").forward(request, response);
    }
}
