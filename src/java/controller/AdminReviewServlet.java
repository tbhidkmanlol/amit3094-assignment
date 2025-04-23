// AdminReviewServlet.java
package controller;

import dao.ReviewDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import model.User;

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
            
            // Get the current user's role from the session
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            String responderRole = "Admin"; // Default
            
            if (user != null) {
                // Use the actual role of the current user
                responderRole = user.getRole().equalsIgnoreCase("MANAGER") ? "Manager" : "Admin";
            }
            
            // Save the reply with the appropriate role
            boolean success = ReviewDAO.addAdminReply(reviewId, reply, responderRole);
            
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