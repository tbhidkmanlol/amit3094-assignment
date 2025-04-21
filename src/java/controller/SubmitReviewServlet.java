// SubmitReviewServlet.java
package controller;

import dao.ProductDAO;
import dao.ReviewDAO;
import model.Review;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.sql.SQLException;
import model.Product;

@WebServlet("/SubmitReview")
public class SubmitReviewServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Set character encoding first
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        System.out.println("=== Review Submission Started ===");
        
        try {
            // Get and log all parameters
            int productId = Integer.parseInt(request.getParameter("productId"));
            String customerName = request.getParameter("customerName");
            int rating = Integer.parseInt(request.getParameter("rating"));
            String comment = request.getParameter("comment");
            
            System.out.println("Received review data:");
            System.out.println("Product ID: " + productId);
            System.out.println("Customer Name: " + customerName);
            System.out.println("Rating: " + rating);
            System.out.println("Comment: " + comment);

            // Verify product exists
            Product product = ProductDAO.getProductById(productId);
            if (product == null) {
                System.out.println("Error: Invalid product ID");
                response.sendRedirect("error.jsp?message=Invalid product ID");
                return;
            }

            // Create review object
            Review review = new Review();
            review.setProductId(productId);
            review.setCustomerName(customerName);
            review.setRating(rating);
            review.setComment(comment);

            // Attempt to save
            System.out.println("Attempting to save review...");
            boolean success = ReviewDAO.addReview(review);
            
            if (success) {
                System.out.println("Review saved successfully!");
                response.sendRedirect("ProductDetails.jsp?id=" + productId + "&reviewSuccess=1");
            } else {
                System.out.println("Failed to save review");
                response.sendRedirect("ProductDetails.jsp?id=" + productId + "&reviewError=1");
            }
            
        } catch (NumberFormatException e) {
            System.out.println("Number format error: " + e.getMessage());
            response.sendRedirect("error.jsp?message=Invalid rating format");
        } catch (SQLException e) {
            System.out.println("SQL Error:");
            e.printStackTrace();
            response.sendRedirect("error.jsp?message=Database error");
        } catch (Exception e) {
            System.out.println("Unexpected error:");
            e.printStackTrace();
            response.sendRedirect("error.jsp?message=Server error");
        } finally {
            System.out.println("=== Review Submission Ended ===");
        }
    }
}