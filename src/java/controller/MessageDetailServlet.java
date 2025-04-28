package controller;

import dao.MessageDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import model.Messages;

@WebServlet(urlPatterns = {"/manager/getMessageDetails", "/manager/markAsRead", "/manager/sendResponse"})
public class MessageDetailServlet extends HttpServlet {
    
@Override
protected void doGet(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
    
    System.out.println("=== MessageDetailServlet doGet ===");
    System.out.println("ServletPath: " + request.getServletPath());
    System.out.println("RequestURI: " + request.getRequestURI());
    System.out.println("ContextPath: " + request.getContextPath());
    
    String path = request.getServletPath();
    String idParam = request.getParameter("id");
    
    System.out.println("ID Parameter: " + idParam);
        
        if (idParam == null || idParam.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Message ID is required");
            return;
        }
        
        int messageId;
        try {
            messageId = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid message ID format");
            return;
        }
        
        try {
            MessageDAO dao = new MessageDAO();
            
            if ("/getMessageDetails".equals(path)) {
                Messages message = dao.getMessageById(messageId);
                if (message == null) {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Message not found");
                    return;
                }
                
// Improved date formatting and JSON creation
SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
String formattedDate = "";
if (message.getSubmissionDate() != null) {
    formattedDate = dateFormat.format(message.getSubmissionDate());
}

// Create JSON with more robust approach
StringBuilder jsonBuilder = new StringBuilder();
jsonBuilder.append("{");
jsonBuilder.append("\"id\":").append(message.getId()).append(",");
jsonBuilder.append("\"firstName\":\"").append(escapeJsonString(message.getFirstName())).append("\",");
jsonBuilder.append("\"lastName\":\"").append(escapeJsonString(message.getLastName())).append("\",");
jsonBuilder.append("\"email\":\"").append(escapeJsonString(message.getEmail())).append("\",");
jsonBuilder.append("\"phone\":\"").append(escapeJsonString(message.getPhone())).append("\",");
jsonBuilder.append("\"message\":\"").append(escapeJsonString(message.getMessage())).append("\",");
jsonBuilder.append("\"submissionDate\":\"").append(formattedDate).append("\",");
jsonBuilder.append("\"read\":").append(message.isRead()).append(",");
jsonBuilder.append("\"responded\":").append(message.isResponded());
jsonBuilder.append("}");

String jsonResponse = jsonBuilder.toString();
                
                response.setContentType("application/json");
                PrintWriter out = response.getWriter();
                out.print(jsonResponse);
                out.flush();
                
            } else if ("/markAsRead".equals(path)) {
                dao.markAsRead(messageId);
                response.setStatus(HttpServletResponse.SC_OK);
                
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
            
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }
    
@Override
protected void doPost(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
    
    System.out.println("=== MessageDetailServlet doPost ===");
    System.out.println("ServletPath: " + request.getServletPath());
    System.out.println("RequestURI: " + request.getRequestURI());
        
        if ("/sendResponse".equals(request.getServletPath())) {
            String messageIdParam = request.getParameter("id");
            String responseText = request.getParameter("response");
            
            if (messageIdParam == null || responseText == null) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Message ID and response are required");
                return;
            }
            
            try {
                int messageId = Integer.parseInt(messageIdParam);
                MessageDAO dao = new MessageDAO();
                dao.sendResponse(messageId, responseText);
                response.setStatus(HttpServletResponse.SC_OK);
                
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid message ID format");
            } catch (SQLException e) {
                throw new ServletException("Database error", e);
            }
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    // Helper method to escape JSON strings
    private String escapeJsonString(String input) {
        if (input == null) {
            return "";
        }
        
        StringBuilder result = new StringBuilder();
        for (int i = 0; i < input.length(); i++) {
            char c = input.charAt(i);
            switch (c) {
                case '\\':
                case '"':
                    result.append('\\').append(c);
                    break;
                case '\b':
                    result.append("\\b");
                    break;
                case '\f':
                    result.append("\\f");
                    break;
                case '\n':
                    result.append("\\n");
                    break;
                case '\r':
                    result.append("\\r");
                    break;
                case '\t':
                    result.append("\\t");
                    break;
                default:
                    if (c < ' ') {
                        String hex = Integer.toHexString(c);
                        result.append("\\u");
                        for (int j = 0; j < 4 - hex.length(); j++) {
                            result.append('0');
                        }
                        result.append(hex);
                    } else {
                        result.append(c);
                    }
            }
        }
        return result.toString();
    }
}