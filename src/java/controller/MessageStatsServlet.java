package controller;

import dao.MessageDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import model.Messages;

@WebServlet("/view-messages")
public class MessageStatsServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            MessageDAO dao = new MessageDAO();
            
            // Get filter parameters
            String search = request.getParameter("search");
            String statusFilter = request.getParameter("statusFilter");
            String sortOrder = request.getParameter("sortOrder");
            
            // Get messages with filters
            List<Messages> messages = dao.getMessages(search, statusFilter, sortOrder);
            
            // Set request attributes
            request.setAttribute("messages", messages);
            request.setAttribute("totalMessages", dao.countAllMessages());
            request.setAttribute("unreadMessages", dao.countMessagesByStatus("unread"));
            request.setAttribute("pendingMessages", dao.countPendingMessages());
            request.setAttribute("completedMessages", dao.countMessagesByRespondedStatus("responded"));
            
            // Forward to the JSP page
            request.getRequestDispatcher("/manager/view-messages.jsp").forward(request, response);
            
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}