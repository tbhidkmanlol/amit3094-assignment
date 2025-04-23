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

@WebServlet("/createStaff")
public class CreateStaffServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        // Security check - only manager can create staff
        if (currentUser == null || !"MANAGER".equals(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=unauthorized");
            return;
        }
        
        // Get parameters
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        if (username == null || username.isEmpty() || password == null || password.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/manager/dashboard.jsp?error=missing_data&section=staff");
            return;
        }
        
        try {
            UserDAO userDAO = new UserDAO();
            
            // Check if username already exists
            if (userDAO.usernameExists(username)) {
                response.sendRedirect(request.getContextPath() + "/manager/dashboard.jsp?error=username_taken&section=staff");
                return;
            }
            
            // Create the staff account (ADMIN role)
            boolean success = userDAO.createStaffAccount(username, password);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/manager/dashboard.jsp?success=user_created&section=staff");
            } else {
                response.sendRedirect(request.getContextPath() + "/manager/dashboard.jsp?error=creation_failed&section=staff");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/manager/dashboard.jsp?error=system&section=staff");
        }
    }
}