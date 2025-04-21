// AdminReviewServlet.java
package controller;

import dao.ReviewDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;

@WebServlet("/AdminReviews")
public class AdminReviewServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            request.setAttribute("reviews", ReviewDAO.getAllReviews());
            request.getRequestDispatcher("AdminReviews.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading reviews");
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int reviewId = Integer.parseInt(request.getParameter("reviewId"));
            String reply = request.getParameter("reply");
            
            boolean success = ReviewDAO.addAdminReply(reviewId, reply);
            
            if (success) {
                response.sendRedirect("AdminReviews.jsp?replySuccess=true");
            } else {
                response.sendRedirect("AdminReviews.jsp?replyError=true");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }
}