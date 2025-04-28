package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import dao.MessageDAO;
import model.Messages;

public class ContactUs extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get parameters safely
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String message = request.getParameter("message");

        // Construct the message object
        Messages contactMessage = new Messages();
        contactMessage.setFirstName(firstName);
        contactMessage.setLastName(lastName);
        contactMessage.setEmail(email);
        contactMessage.setPhone(phone);
        contactMessage.setMessage(message);

        try {
            // Store in database
            boolean success = MessageDAO.storeMessage(contactMessage);

            if (success) {
                request.setAttribute("contactMessage", "Thanks! Your message has been sent.");
            } else {
                request.setAttribute("contactError", "Message could not be saved.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("contactError", "Internal error: " + e.getMessage());
        }
        // Forward to contactus.jsp in all cases
        request.getRequestDispatcher("contactus.jsp").forward(request, response);
    }
}
