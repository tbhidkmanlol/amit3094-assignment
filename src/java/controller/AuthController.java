package controller;

import dao.UserDAO;
import model.User;
import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/auth/*")
public class AuthController extends HttpServlet {

    private UserDAO userDao = new UserDAO();

    @Override
    public void init() throws ServletException {
        try {
            userDao.createDefaultManager();
        } catch (SQLException e) {
            throw new ServletException("Failed to create default manager", e);
        } catch (Exception ex) {
            Logger.getLogger(AuthController.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getPathInfo();

        try {
            switch (action) {
                case "/login":
                    // Get login details
                    String username = request.getParameter("username");
                    String password = request.getParameter("password");

                    User user = userDao.authenticate(username, password);

                    if (user != null) {
                        HttpSession session = request.getSession();
                        session.setAttribute("user", user);
                        session.setAttribute("username", user.getUsername());
                        session.setAttribute("role", user.getRole());
                        session.setAttribute("userId", user.getId());
                        
                        // Check if there's a redirect destination after login
                        String redirectDestination = (String) session.getAttribute("redirectAfterLogin");
                        if (redirectDestination != null && !redirectDestination.isEmpty()) {
                            session.removeAttribute("redirectAfterLogin");
                            response.sendRedirect("../" + redirectDestination);
                            return;
                        }

                        // Otherwise proceed with normal role-based redirection
                        switch (user.getRole()) {
                            case "MANAGER":
                                response.sendRedirect("../manager/dashboard.jsp");
                                break;
                            case "ADMIN":
                                response.sendRedirect("../admin/dashboard.jsp");
                                break;
                            default:
                                response.sendRedirect("../customer/dashboard.jsp");
                        }
                    } else {
                        response.sendRedirect("../login.jsp?error=1");
                    }
                    break;

                case "/register":
                    // Validate user input before registration
                    String regUsername = request.getParameter("username");
                    String regPassword = request.getParameter("password");
                    String customerName = request.getParameter("fullName");
                    String contactNumber = request.getParameter("phone");
                    String email = request.getParameter("email");
                    
                    // Check if username already exists
                    if (userDao.usernameExists(regUsername)) {
                        response.sendRedirect("../login.jsp?error=username_taken");
                        return;
                    }
                    
                    // Create new user object with customer details
                    User newUser = new User(
                            regUsername,
                            regPassword,
                            "CUSTOMER",
                            customerName,
                            contactNumber,
                            email
                    );

                    if (userDao.registerCustomer(newUser)) {
                        // Check if there's a redirect destination after registration
                        HttpSession session = request.getSession();
                        String redirectDestination = (String) session.getAttribute("redirectAfterLogin");
                        
                        if (redirectDestination != null && !redirectDestination.isEmpty()) {
                            // Auto-login the user after registration
                            User registeredUser = userDao.authenticate(
                                regUsername,
                                regPassword
                            );
                            
                            if (registeredUser != null) {
                                session.setAttribute("user", registeredUser);
                                session.setAttribute("username", registeredUser.getUsername());
                                session.setAttribute("role", registeredUser.getRole());
                                session.setAttribute("userId", registeredUser.getId());
                                session.removeAttribute("redirectAfterLogin");
                                response.sendRedirect("../" + redirectDestination);
                                return;
                            }
                        }
                        
                        // Default registration success flow
                        response.sendRedirect("../login.jsp?registered=1");
                    } else {
                        response.sendRedirect("../login.jsp?error=registration");
                    }
                    break;

                case "/create-admin":
                    HttpSession session = request.getSession();
                    // Get manager from session
                    User manager = (User) session.getAttribute("user");

                    if (manager == null || !"MANAGER".equals(manager.getRole())) {
                        response.sendRedirect("../login.jsp?error=unauthorized");
                        return;
                    }

                    // Create new admin user
                    User newAdmin = new User(
                            request.getParameter("username"),
                            request.getParameter("password"),
                            "ADMIN"
                    );

                    if (userDao.createAdminAccount(newAdmin, manager)) {
                        response.sendRedirect("../manager/dashboard.jsp?success=admin_created");
                    } else {
                        response.sendRedirect("../manager/create-admin.jsp?error=1");
                    }
                    break;
                    
                case "/update-password":
                    HttpSession passwordSession = request.getSession();
                    User currentUser = (User) passwordSession.getAttribute("user");
                    
                    if (currentUser == null) {
                        response.sendRedirect("../login.jsp");
                        return;
                    }
                    
                    String newPassword = request.getParameter("newPassword");
                    if (userDao.updatePassword(currentUser.getId(), newPassword)) {
                        // Update session with new password
                        currentUser.setPassword(newPassword);
                        passwordSession.setAttribute("user", currentUser);
                        
                        // Redirect based on role
                        switch (currentUser.getRole()) {
                            case "MANAGER":
                                response.sendRedirect("../manager/dashboard.jsp?success=password_changed");
                                break;
                            case "ADMIN":
                                response.sendRedirect("../admin/dashboard.jsp?success=password_changed");
                                break;
                            default:
                                response.sendRedirect("../customer/dashboard.jsp?success=password_changed");
                        }
                    } else {
                        // Redirect based on role with error
                        switch (currentUser.getRole()) {
                            case "MANAGER":
                                response.sendRedirect("../manager/dashboard.jsp?error=password_update");
                                break;
                            case "ADMIN":
                                response.sendRedirect("../admin/dashboard.jsp?error=password_update");
                                break;
                            default:
                                response.sendRedirect("../customer/dashboard.jsp?error=password_update");
                        }
                    }
                    break;
            }
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        } catch (Exception ex) {
            Logger.getLogger(AuthController.class.getName()).log(Level.SEVERE, null, ex);
            response.sendRedirect("../login.jsp?error=system");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getPathInfo();

        if ("/logout".equals(action)) {
            request.getSession().invalidate();
            response.sendRedirect(request.getContextPath() + "/login.jsp?logout=1");
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
}
