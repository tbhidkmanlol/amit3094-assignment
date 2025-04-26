package payment;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.RequestDispatcher;
import java.util.List;
import model.CartItem;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
// Import necessary classes for order creation
import model.Order;
import model.OrderItem;
import dao.OrderDAO;
import model.User;

@WebServlet("/processPayment")
public class PaymentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Get Billing Address Info
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String email = request.getParameter("email");
            String address = request.getParameter("address");
            String city = request.getParameter("city");
            String state = request.getParameter("state");
            String postalCode = request.getParameter("postalCode");
            String country = request.getParameter("country");

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

            // Get order summary information - safely parse with defaults if parameters are missing
            double merchandiseSubtotal = parseDoubleParameter(request, "merchandiseSubtotal", 0.0);
            double deliveryFee = parseDoubleParameter(request, "deliveryFee", 0.0);
            double totalPayment = parseDoubleParameter(request, "totalPayment", 0.0);

            // Get the cart from session
            HttpSession session = request.getSession();
            List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

            // Generate order confirmation information
            String orderNumber = generateOrderNumber();
            LocalDateTime orderDate = LocalDateTime.now();
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
            String formattedDate = orderDate.format(formatter);
            
            // Calculate estimated delivery date (7 days from now)
            LocalDateTime deliveryDate = orderDate.plusDays(7);
            String formattedDeliveryDate = deliveryDate.format(DateTimeFormatter.ofPattern("dd MMM yyyy"));

            // Set attributes for order confirmation page
            request.setAttribute("orderNumber", orderNumber);
            request.setAttribute("orderDate", formattedDate);
            request.setAttribute("estimatedDeliveryDate", formattedDeliveryDate);
            request.setAttribute("firstName", firstName);
            request.setAttribute("lastName", lastName);
            request.setAttribute("email", email);
            request.setAttribute("address", address);
            request.setAttribute("city", city);
            request.setAttribute("state", state);
            request.setAttribute("postalCode", postalCode);
            request.setAttribute("country", country);
            request.setAttribute("method", method);
            
            // For card payments, mask the card number for security
            if ("creditCard".equals(method)) {
                String maskedCardNumber = maskCardNumber(cardNumber);
                request.setAttribute("cardType", cardType);
                request.setAttribute("cardName", cardName);
                request.setAttribute("cardNumber", maskedCardNumber);
            } else if ("ewallet".equals(method)) {
                request.setAttribute("walletType", walletType);
            }
            
            request.setAttribute("merchandiseSubtotal", merchandiseSubtotal);
            request.setAttribute("deliveryFee", deliveryFee);
            request.setAttribute("totalPayment", totalPayment);
            
            // Store cart items for display on confirmation page
            request.setAttribute("confirmedCart", cart);
            
            // NEW CODE: Create order record in the database for sales reporting
            if (cart != null && !cart.isEmpty()) {
                Order order = new Order();
                
                // Set order details
                order.setOrderNumber(orderNumber);
                // Get user ID if user is logged in
                User user = (User) session.getAttribute("user");
                if (user != null) {
                    order.setCustomerId(user.getId());
                }
                
                // Format full address for billing and shipping
                String fullAddress = address + ", " + city + ", " + state + ", " + postalCode + ", " + country;
                
                order.setTotalAmount(totalPayment);
                order.setShippingFee(deliveryFee);
                order.setTaxAmount(0.0); // Set tax if applicable
                order.setPaymentMethod(method);
                order.setPaymentStatus("Completed"); // Assuming payment is successful
                order.setShippingStatus("Processing");
                order.setBillingAddress(fullAddress);
                order.setShippingAddress(fullAddress);
                order.setCustomerEmail(email);
                // You can add phone if available
                order.setCustomerPhone("");
                
                // Create order items from cart
                List<OrderItem> orderItems = order.getOrderItems(); // Initialize the list
                if (orderItems == null) {
                    // If the list is not initialized in the Order constructor, create it
                    orderItems = new java.util.ArrayList<>();
                    order.setOrderItems(orderItems);
                }
                
                // Add cart items to order
                for (CartItem cartItem : cart) {
                    OrderItem item = new OrderItem();
                    item.setProductId(cartItem.getProduct().getId());
                    item.setQuantity(cartItem.getQuantity());
                    item.setPricePerUnit(cartItem.getProduct().getPrice());
                    item.setSubtotal(cartItem.getQuantity() * cartItem.getProduct().getPrice());
                    orderItems.add(item);
                }
                
                // Save the order to the database
                int orderId = OrderDAO.createOrder(order);
                if (orderId > 0) {
                    System.out.println("Order created successfully with ID: " + orderId);
                } else {
                    System.err.println("Failed to create order in the database.");
                }
            }
            
            // Clear the cart after successful order
            session.removeAttribute("cart");
            session.setAttribute("cartCount", 0);
            
            // Forward to confirmation page
            RequestDispatcher dispatcher = request.getRequestDispatcher("confirmation.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            // Log the error
            e.printStackTrace();
            
            // Set error message and forward to an error page
            request.setAttribute("errorMessage", "There was a problem processing your payment: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("payment.jsp");
            dispatcher.forward(request, response);
        }
    }
    
    // Helper method to safely parse double parameters
    private double parseDoubleParameter(HttpServletRequest request, String paramName, double defaultValue) {
        String paramValue = request.getParameter(paramName);
        if (paramValue != null && !paramValue.trim().isEmpty()) {
            try {
                return Double.parseDouble(paramValue);
            } catch (NumberFormatException e) {
                return defaultValue;
            }
        }
        return defaultValue;
    }
    
    private String generateOrderNumber() {
        // Generate a random order number based on timestamp
        long timestamp = System.currentTimeMillis();
        int random = (int)(Math.random() * 1000);
        return "PG" + timestamp + "-" + random;
    }
    
    private String maskCardNumber(String cardNumber) {
        if (cardNumber == null || cardNumber.isEmpty()) {
            return "xxxx xxxx xxxx xxxx";
        }
        
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
        
        // Return masked version if invalid
        return "xxxx xxxx xxxx xxxx";
    }
}
