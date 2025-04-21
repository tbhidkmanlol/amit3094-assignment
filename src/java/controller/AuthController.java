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
                    // PROPERLY DECLARE username and password first
                    String username = request.getParameter("username");
                    String password = request.getParameter("password");

                    User user = userDao.authenticate(username, password);

                    if (user != null) {
                        HttpSession session = request.getSession();
                        session.setAttribute("user", user);

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
                    // PROPERLY CREATE newUser object
                    User newUser = new User(
                            request.getParameter("username"),
                            request.getParameter("password"),
                            "CUSTOMER"
                    );

                    if (userDao.registerCustomer(newUser)) {
                        response.sendRedirect("../login.jsp?registered=1");
                    } else {
                        response.sendRedirect("../register.jsp?error=1");
                    }
                    break;

                case "/create-admin":
                    HttpSession session = request.getSession();
                    // PROPERLY GET manager from session
                    User manager = (User) session.getAttribute("user");

                    if (manager == null || !"MANAGER".equals(manager.getRole())) {
                        response.sendRedirect("../login.jsp?error=unauthorized");
                        return;
                    }

                    // PROPERLY CREATE newAdmin object
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
            }
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        } catch (Exception ex) {
            Logger.getLogger(AuthController.class.getName()).log(Level.SEVERE, null, ex);
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
