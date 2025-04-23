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

@WebServlet("/update-account")
public class UpdateAccountServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        // Security check - user must be logged in
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=not_logged_in");
            return;
        }
        
        // Get form parameters
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        // Validate request parameters
        if (currentPassword == null || newPassword == null || confirmPassword == null || 
            currentPassword.isEmpty() || newPassword.isEmpty() || confirmPassword.isEmpty()) {
            redirectToUserDashboard(response, currentUser, "missing_data");
            return;
        }
        
        // Check if new password matches confirmation
        if (!newPassword.equals(confirmPassword)) {
            redirectToUserDashboard(response, currentUser, "password_mismatch");
            return;
        }
        
        try {
            UserDAO userDAO = new UserDAO();
            
            // Verify current password is correct
            User verifiedUser = userDAO.authenticate(currentUser.getUsername(), currentPassword);
            if (verifiedUser == null) {
                redirectToUserDashboard(response, currentUser, "wrong_password");
                return;
            }
            
            // Update password
            boolean success = userDAO.updatePassword(currentUser.getId(), newPassword);
            
            if (success) {
                // Update the session's user object with the new password
                currentUser.setPassword(newPassword);
                session.setAttribute("user", currentUser);
                
                redirectToUserDashboard(response, currentUser, "success=password_changed");
            } else {
                redirectToUserDashboard(response, currentUser, "update_failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            redirectToUserDashboard(response, currentUser, "system");
        }
    }
    
    // Helper method to redirect users to their respective dashboards with status message
    private void redirectToUserDashboard(HttpServletResponse response, User user, String status) 
            throws IOException {
        
        String prefix = status.startsWith("success") ? "" : "error=";
        if (!status.startsWith("success")) {
            status = prefix + status;
        }
        
        String targetPage;
        switch (user.getRole()) {
            case "MANAGER":
                targetPage = "/manager/dashboard.jsp?" + status + "&section=settings";
                break;
            case "ADMIN":
                targetPage = "/admin/dashboard.jsp?" + status + "&section=settings";
                break;
            default: // CUSTOMER
                targetPage = "/customer/dashboard.jsp?" + status + "&section=settings";
                break;
        }
        
        response.sendRedirect(response.encodeRedirectURL(targetPage));
    }
}