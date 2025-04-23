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

@WebServlet("/updateCustomer")
public class UpdateCustomerServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        // Security check - only manager can update customers
        if (currentUser == null || !"MANAGER".equals(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=unauthorized");
            return;
        }
        
        // Get customer ID and other data from request
        String customerIdParam = request.getParameter("customerId");
        String username = request.getParameter("username");
        String customerName = request.getParameter("customerName");
        String contactNumber = request.getParameter("contactNumber");
        String email = request.getParameter("email");
        String password = request.getParameter("password"); // May be empty if not changing
        
        if (customerIdParam == null || customerIdParam.isEmpty() || username == null || username.isEmpty() ||
            customerName == null || customerName.isEmpty() || contactNumber == null || contactNumber.isEmpty() ||
            email == null || email.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/manager/dashboard.jsp?error=missing_data&section=customers");
            return;
        }
        
        try {
            int customerId = Integer.parseInt(customerIdParam);
            UserDAO userDAO = new UserDAO();
            
            // Get the existing customer data
            User customer = userDAO.getUserById(customerId);
            
            // Check if customer exists and is actually a CUSTOMER
            if (customer == null || !"CUSTOMER".equals(customer.getRole())) {
                response.sendRedirect(request.getContextPath() + "/manager/dashboard.jsp?error=invalid_customer&section=customers");
                return;
            }
            
            // Update customer data
            customer.setUsername(username);
            customer.setCustomerName(customerName);
            customer.setContactNumber(contactNumber);
            customer.setEmail(email);
            
            // Update password if provided
            if (password != null && !password.isEmpty()) {
                customer.setPassword(password);
            }
            
            // Save the updates
            boolean success;
            if (password != null && !password.isEmpty()) {
                success = userDAO.updateCustomer(customer);
            } else {
                // If no password change, ensure the current password is maintained
                customer.setPassword(userDAO.getUserById(customerId).getPassword());
                success = userDAO.updateCustomer(customer);
            }
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/manager/dashboard.jsp?success=user_updated&section=customers");
            } else {
                response.sendRedirect(request.getContextPath() + "/manager/dashboard.jsp?error=update_failed&section=customers");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/manager/dashboard.jsp?error=invalid_id&section=customers");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/manager/dashboard.jsp?error=system&section=customers");
        }
    }
}