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

@WebServlet(name = "UpdateAdminServlet", urlPatterns = {"/updateAdmin"})
public class UpdateAdminServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        // Security check - only manager can update admins
        if (currentUser == null || !"MANAGER".equals(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=unauthorized");
            return;
        }
        
        // Get admin ID and other data from request
        String adminIdParam = request.getParameter("adminId");
        String username = request.getParameter("username");
        String password = request.getParameter("password"); // May be empty if not changing
        
        if (adminIdParam == null || adminIdParam.isEmpty() || username == null || username.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/manager/dashboard.jsp?error=missing_data");
            return;
        }
        
        try {
            int adminId = Integer.parseInt(adminIdParam);
            UserDAO userDAO = new UserDAO();
            
            // Get the existing admin data
            User admin = userDAO.getUserById(adminId);
            
            // Check if admin exists and is actually an ADMIN
            if (admin == null || !"ADMIN".equals(admin.getRole())) {
                response.sendRedirect(request.getContextPath() + "/manager/dashboard.jsp?error=invalid_admin");
                return;
            }
            
            // Update admin data
            admin.setUsername(username);
            
            // Update password if provided
            if (password != null && !password.isEmpty()) {
                admin.setPassword(password);
            }
            
            // Save the updates
            boolean success;
            if (password != null && !password.isEmpty()) {
                success = userDAO.updateAdmin(admin);
            } else {
                // If no password change, ensure the current password is maintained
                admin.setPassword(userDAO.getUserById(adminId).getPassword());
                success = userDAO.updateAdmin(admin);
            }
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/manager/dashboard.jsp?success=user_updated");
            } else {
                response.sendRedirect(request.getContextPath() + "/manager/dashboard.jsp?error=update_failed");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/manager/dashboard.jsp?error=invalid_id");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/manager/dashboard.jsp?error=system");
        }
    }
}