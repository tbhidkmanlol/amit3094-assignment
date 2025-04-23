package payment;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.RequestDispatcher;
import java.util.List;
import model.CartItem;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@WebServlet("/processPayment")
public class PaymentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get Billing Address Info
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String country = request.getParameter("country");
        String state = request.getParameter("state");
        String district = request.getParameter("district");
        String postal = request.getParameter("postal");
        String address = request.getParameter("address");

        // Get Payment Method
        String method = request.getParameter("method");

        // Card Payment Info (may be null if not selected)
        String cardType = request.getParameter("cardType");
        String cardName = request.getParameter("cardName");
        String cardNumber = request.getParameter("cardNumber");
        String expiry = request.getParameter("expiry");
        String cvv = request.getParameter("cvv");
        
        // E-Wallet Payment Info (may be null if not selected)
        String walletType = request.getParameter("walletType");

        // Get order summary information
        double merchandiseSubtotal = Double.parseDouble(request.getParameter("merchandiseSubtotal"));
        double shippingSubtotal = Double.parseDouble(request.getParameter("shippingSubtotal"));
        double shippingSST = Double.parseDouble(request.getParameter("shippingSST"));
        double deliveryFee = Double.parseDouble(request.getParameter("deliveryFee"));
        double totalPayment = Double.parseDouble(request.getParameter("totalPayment"));

        // Get the cart from session
        HttpSession session = request.getSession();
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

        // Generate order confirmation information
        String orderNumber = generateOrderNumber();
        LocalDateTime orderDate = LocalDateTime.now();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        String formattedDate = orderDate.format(formatter);
        
        // Calculate estimated delivery date (3 days from now)
        LocalDateTime deliveryDate = orderDate.plusDays(3);
        String formattedDeliveryDate = deliveryDate.format(DateTimeFormatter.ofPattern("dd MMM yyyy"));

        // Set attributes for order confirmation page
        request.setAttribute("orderNumber", orderNumber);
        request.setAttribute("orderDate", formattedDate);
        request.setAttribute("estimatedDeliveryDate", formattedDeliveryDate);
        request.setAttribute("firstName", firstName);
        request.setAttribute("lastName", lastName);
        request.setAttribute("email", email);
        request.setAttribute("address", address);
        request.setAttribute("district", district);
        request.setAttribute("state", state);
        request.setAttribute("postal", postal);
        request.setAttribute("country", country);
        request.setAttribute("paymentMethod", method);
        
        // For card payments, mask the card number for security
        if (method.equals("creditCard") || method.equals("debitCard")) {
            String maskedCardNumber = maskCardNumber(cardNumber);
            request.setAttribute("cardType", cardType);
            request.setAttribute("cardName", cardName);
            request.setAttribute("cardNumber", maskedCardNumber);
        } else if (method.equals("ewallet")) {
            request.setAttribute("walletType", walletType);
        }
        
        request.setAttribute("merchandiseSubtotal", merchandiseSubtotal);
        request.setAttribute("shippingSubtotal", shippingSubtotal);
        request.setAttribute("shippingSST", shippingSST);
        request.setAttribute("deliveryFee", deliveryFee);
        request.setAttribute("totalPayment", totalPayment);
        
        // Store cart items for display on confirmation page
        request.setAttribute("confirmedCart", cart);
        
        // In a real application, here you would:
        // 1. Process payment through a payment gateway
        // 2. Create an order record in your database
        // 3. Update inventory levels
        // 4. Send confirmation email to customer
        
        // Clear the cart after successful order
        session.removeAttribute("cart");
        session.setAttribute("cartCount", 0);
        
        // Forward to confirmation page
        RequestDispatcher dispatcher = request.getRequestDispatcher("confirmation.jsp");
        dispatcher.forward(request, response);
    }
    
    private String generateOrderNumber() {
        // Generate a random order number based on timestamp
        long timestamp = System.currentTimeMillis();
        int random = (int)(Math.random() * 1000);
        return "PG" + timestamp + "-" + random;
    }
    
    private String maskCardNumber(String cardNumber) {
        // Remove any spaces or non-digit characters
        String cleanNumber = cardNumber.replaceAll("\\D", "");
        
        // If the card number is valid (at least 13 digits)
        if (cleanNumber.length() >= 13) {
            // Keep first 4 and last 4 digits, mask the rest
            String firstFour = cleanNumber.substring(0, 4);
            String lastFour = cleanNumber.substring(cleanNumber.length() - 4);
            
            // Create masked portion
            StringBuilder masked = new StringBuilder();
            for (int i = 0; i < cleanNumber.length() - 8; i++) {
                masked.append("*");
            }
            
            // Format with spaces for readability
            return firstFour + " " + masked.toString() + " " + lastFour;
        }
        
        // Return original if invalid
        return cardNumber;
    }
}
