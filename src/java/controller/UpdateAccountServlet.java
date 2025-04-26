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
            redirectToErrorPage(response, "Required data is missing");
            return;
        }
        
        // Check if new password matches confirmation
        if (!newPassword.equals(confirmPassword)) {
            redirectToErrorPage(response, "New password and confirmation do not match");
            return;
        }
        
        try {
            UserDAO userDAO = new UserDAO();
            
            // Verify current password is correct
            User verifiedUser = userDAO.authenticate(currentUser.getUsername(), currentPassword);
            if (verifiedUser == null) {
                redirectToErrorPage(response, "Current password is incorrect");
                return;
            }
            
            // Update password
            boolean success = userDAO.updatePassword(currentUser.getId(), newPassword);
            
            if (success) {
                // Update the session's user object with the new password
                currentUser.setPassword(newPassword);
                session.setAttribute("user", currentUser);
                
                // 重定向到密码更改成功页面
                response.sendRedirect(response.encodeRedirectURL("password-change-success.jsp"));
            } else {
                redirectToErrorPage(response, "Password update failed. Please try again later");
            }
        } catch (Exception e) {
            e.printStackTrace();
            redirectToErrorPage(response, "System error: " + e.getMessage());
        }
    }
    
    // 重定向到错误页面的辅助方法
    private void redirectToErrorPage(HttpServletResponse response, String errorMessage) 
            throws IOException {
        response.sendRedirect(response.encodeRedirectURL("password-change-error.jsp?error=" + errorMessage));
    }
    
    // 以下方法保留，但不再使用
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