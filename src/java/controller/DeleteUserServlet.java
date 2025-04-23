package controller;

import dao.UserDAO;
import model.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/deleteUser")
public class DeleteUserServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        // Security check - only manager can delete users
        if (currentUser == null || !"MANAGER".equals(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=unauthorized");
            return;
        }
        
        // Get the user ID to delete
        String userIdParam = request.getParameter("userId");
        if (userIdParam == null || userIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/manager/dashboard.jsp?error=invalid_id");
            return;
        }
        
        try {
            int userId = Integer.parseInt(userIdParam);
            UserDAO userDAO = new UserDAO();
            
            // Prevent deleting own account
            if (userId == currentUser.getId()) {
                response.sendRedirect(request.getContextPath() + "/manager/dashboard.jsp?error=cannot_delete_self");
                return;
            }
            
            boolean success = userDAO.deleteUser(userId);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/manager/dashboard.jsp?success=user_deleted");
            } else {
                response.sendRedirect(request.getContextPath() + "/manager/dashboard.jsp?error=delete_failed");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/manager/dashboard.jsp?error=invalid_id");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/manager/dashboard.jsp?error=system");
        }
    }
}