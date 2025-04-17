package controller;

import controller.ProductDAO;
import entity.Product;
import entity.Cart;
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

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null) {
            cart = new Cart();
        }

        String action = request.getParameter("action");
        int productId = Integer.parseInt(request.getParameter("productId"));

        if ("add".equals(action)) {
            Product product = productDAO.getProductById(productId);
            if (product != null) {
                cart.addProduct(product);
            }
        } else if ("remove".equals(action)) {
            cart.removeProduct(productId);
        }

        session.setAttribute("cart", cart);
        response.sendRedirect(request.getContextPath() + "/cart");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/cart.jsp").forward(request, response);
    }

}
