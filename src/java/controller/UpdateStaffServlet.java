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

@WebServlet("/updateStaff")
public class UpdateStaffServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        // Security check - only manager can update staff
        if (currentUser == null || !"MANAGER".equals(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=unauthorized");
            return;
        }
        
        // Get staff ID from request
        String staffIdParam = request.getParameter("staffId");
        String username = request.getParameter("username");
        String password = request.getParameter("password"); // May be empty if not changing
        
        if (staffIdParam == null || staffIdParam.isEmpty() || username == null || username.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/manager/dashboard.jsp?error=missing_data&section=staff");
            return;
        }
        
        try {
            int staffId = Integer.parseInt(staffIdParam);
            UserDAO userDAO = new UserDAO();
            
            // Get the existing staff data
            User staff = userDAO.getUserById(staffId);
            
            // Check if staff exists and is actually an ADMIN
            if (staff == null || !"ADMIN".equals(staff.getRole())) {
                response.sendRedirect(request.getContextPath() + "/manager/dashboard.jsp?error=invalid_staff&section=staff");
                return;
            }
            
            // Update staff username
            staff.setUsername(username);
            
            // Update password if provided
            if (password != null && !password.isEmpty()) {
                staff.setPassword(password);
            }
            
            // Save the updates
            boolean success;
            if (password != null && !password.isEmpty()) {
                // If password is being changed
                success = userDAO.updatePassword(staffId, password);
            } else {
                // Otherwise just update the username
                success = userDAO.updateUsername(staffId, username);
            }
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/manager/dashboard.jsp?success=user_updated&section=staff");
            } else {
                response.sendRedirect(request.getContextPath() + "/manager/dashboard.jsp?error=update_failed&section=staff");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/manager/dashboard.jsp?error=invalid_id&section=staff");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/manager/dashboard.jsp?error=system&section=staff");
        }
    }
}