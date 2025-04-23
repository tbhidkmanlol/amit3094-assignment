package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Random;
import model.CartItem;

@WebServlet("/ProcessPaymentServlet")
public class ProcessPaymentServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get session
        HttpSession session = request.getSession();
        
        // Retrieve cart items
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        
        // Get form parameters
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String address = request.getParameter("address");
        String city = request.getParameter("city");
        String state = request.getParameter("state");
        String postal = request.getParameter("postal");
        String country = request.getParameter("country");
        
        // Get payment details
        String paymentMethod = request.getParameter("method");
        String cardType = request.getParameter("cardType");
        String cardName = request.getParameter("cardName");
        String cardNumber = request.getParameter("cardNumber");
        String expiry = request.getParameter("expiry");
        String cvv = request.getParameter("cvv");
        String walletType = request.getParameter("walletType");
        
        // Get financial values
        double merchandiseSubtotal = Double.parseDouble(request.getParameter("merchandiseSubtotal"));
        double shippingSubtotal = Double.parseDouble(request.getParameter("shippingSubtotal"));
        double shippingSST = Double.parseDouble(request.getParameter("shippingSST"));
        double deliveryFee = Double.parseDouble(request.getParameter("deliveryFee"));
        double totalPayment = Double.parseDouble(request.getParameter("totalPayment"));
        
        // Generate transaction/order number (Current timestamp + random 4 digits)
        String orderNumber = generateOrderNumber();
        
        // Generate current date and estimated delivery date (7 days from now)
        SimpleDateFormat dateFormat = new SimpleDateFormat("dd MMM yyyy");
        Date currentDate = new Date();
        String orderDate = dateFormat.format(currentDate);
        
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(currentDate);
        calendar.add(Calendar.DATE, 7); // Add 7 days
        String estimatedDeliveryDate = dateFormat.format(calendar.getTime());
        
        // Mask card number if credit/debit card payment
        if ("creditCard".equals(paymentMethod) || "debitCard".equals(paymentMethod)) {
            if (cardNumber != null && cardNumber.length() >= 16) {
                // Keep only last 4 digits visible, mask the rest
                cardNumber = "**** **** **** " + cardNumber.substring(cardNumber.length() - 4);
            }
        }
        
        // Set all attributes for confirmation page
        request.setAttribute("orderNumber", orderNumber);
        request.setAttribute("orderDate", orderDate);
        request.setAttribute("estimatedDeliveryDate", estimatedDeliveryDate);
        
        request.setAttribute("firstName", firstName);
        request.setAttribute("lastName", lastName);
        request.setAttribute("email", email);
        request.setAttribute("address", address);
        request.setAttribute("district", city);
        request.setAttribute("state", state);
        request.setAttribute("postal", postal);
        request.setAttribute("country", country);
        
        request.setAttribute("paymentMethod", paymentMethod);
        request.setAttribute("cardType", cardType);
        request.setAttribute("cardName", cardName);
        request.setAttribute("cardNumber", cardNumber);
        request.setAttribute("walletType", walletType);
        
        request.setAttribute("merchandiseSubtotal", String.format("%.2f", merchandiseSubtotal));
        request.setAttribute("shippingSubtotal", String.format("%.2f", shippingSubtotal));
        request.setAttribute("shippingSST", String.format("%.2f", shippingSST));
        request.setAttribute("deliveryFee", deliveryFee);
        request.setAttribute("totalPayment", String.format("%.2f", totalPayment));
        
        // Pass the cart items to be displayed in the confirmation page
        request.setAttribute("confirmedCart", cart);
        
        // In a real application, you would:
        // 1. Save the order to the database
        // 2. Process the payment with a payment gateway
        // 3. Clear the cart once payment is successful
        // 4. Send confirmation email to customer
        
        // For now, just forward to confirmation page
        session.removeAttribute("cart"); // Clear the cart after successful order
        
        // Forward to confirmation page
        request.getRequestDispatcher("confirmation.jsp").forward(request, response);
    }
    
    // Helper method to generate a unique order number
    private String generateOrderNumber() {
        long timestamp = System.currentTimeMillis();
        Random random = new Random();
        int randomDigits = random.nextInt(10000); // Random 4-digit number
        return "TX" + timestamp + String.format("%04d", randomDigits);
    }
}