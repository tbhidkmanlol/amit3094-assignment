package payment;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.RequestDispatcher;

@WebServlet("/processPayment")
public class PaymentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        // Get Billing Address Info
        String country = request.getParameter("country");
        String state = request.getParameter("state");
        String district = request.getParameter("district");
        String postal = request.getParameter("postal");

        // Get Payment Method
        String method = request.getParameter("method");

        // Card Payment Info (may be null if not selected)
        String cardName = request.getParameter("cardName");
        String cardNumber = request.getParameter("cardNumber");
        String expiry = request.getParameter("expiry");
        String cvv = request.getParameter("cvv");

        // Order Summary
        String coupon = request.getParameter("coupon");
        String item = "PG Program in Data Analytics and Data Science"; // static in JSP
        String originalPrice = "$135.5";
        String discount = "$35.5";
        String total = "$100";

        // Set request attributes to pass to confirmation.jsp
        request.setAttribute("country", country);
        request.setAttribute("state", state);
        request.setAttribute("district", district);
        request.setAttribute("postal", postal);
        request.setAttribute("method", method);
        request.setAttribute("cardName", cardName);
        request.setAttribute("cardNumber", cardNumber);
        request.setAttribute("expiry", expiry);
        request.setAttribute("cvv", cvv);
        request.setAttribute("coupon", coupon);
        request.setAttribute("item", item);
        request.setAttribute("originalPrice", originalPrice);
        request.setAttribute("discount", discount);
        request.setAttribute("total", total);

        // Forward to confirmation.jsp
        RequestDispatcher dispatcher = request.getRequestDispatcher("confirmation.jsp");
        dispatcher.forward(request, response);
    }
}
