<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, model.CartItem, java.time.LocalDate, java.time.format.DateTimeFormatter" %>
<%
    // Get cart from session
    List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
    List<CartItem> confirmedCart = (List<CartItem>) request.getAttribute("confirmedCart");
    
    // Get order details from request attributes, fall back to parameters if needed
    String firstName = request.getAttribute("firstName") != null ? 
        (String) request.getAttribute("firstName") : 
        request.getParameter("firstName") != null ? request.getParameter("firstName") : "";
    
    String lastName = request.getAttribute("lastName") != null ? 
        (String) request.getAttribute("lastName") : 
        request.getParameter("lastName") != null ? request.getParameter("lastName") : "";
    
    String email = request.getAttribute("email") != null ? 
        (String) request.getAttribute("email") : 
        request.getParameter("email") != null ? request.getParameter("email") : "";
    
    String address = request.getAttribute("address") != null ? 
        (String) request.getAttribute("address") : 
        request.getParameter("address") != null ? request.getParameter("address") : "";
    
    String apartment = request.getAttribute("apartment") != null ? 
        (String) request.getAttribute("apartment") : 
        request.getParameter("apartment") != null ? request.getParameter("apartment") : "";
    
    String city = request.getAttribute("city") != null ? 
        (String) request.getAttribute("city") : 
        request.getParameter("city") != null ? request.getParameter("city") : "";
    
    String state = request.getAttribute("state") != null ? 
        (String) request.getAttribute("state") : 
        request.getParameter("state") != null ? request.getParameter("state") : "";
    
    String postalCode = request.getAttribute("postalCode") != null ? 
        (String) request.getAttribute("postalCode") : 
        request.getParameter("postalCode") != null ? request.getParameter("postalCode") : "";
    
    String country = request.getAttribute("country") != null ? 
        (String) request.getAttribute("country") : 
        request.getParameter("country") != null ? request.getParameter("country") : "Malaysia";
    
    // Payment details
    String paymentMethod = request.getAttribute("method") != null ? 
        (String) request.getAttribute("method") : 
        request.getParameter("method") != null ? request.getParameter("method") : "";
    
    String cardType = request.getAttribute("cardType") != null ? 
        (String) request.getAttribute("cardType") : 
        request.getParameter("cardType") != null ? request.getParameter("cardType") : "";
    
    String cardName = request.getAttribute("cardName") != null ? 
        (String) request.getAttribute("cardName") : 
        request.getParameter("cardName") != null ? request.getParameter("cardName") : "";
    
    String cardNumber = request.getAttribute("cardNumber") != null ? 
        (String) request.getAttribute("cardNumber") : 
        request.getParameter("cardNumber") != null ? request.getParameter("cardNumber") : "";
    
    String walletType = request.getAttribute("walletType") != null ? 
        (String) request.getAttribute("walletType") : 
        request.getParameter("walletType") != null ? request.getParameter("walletType") : "";
    
    // Financial calculations
    double merchandiseSubtotal = 0.0;
    double deliveryFee = 0.0;
    double totalPayment = 0.0;
    
    try {
        if (request.getAttribute("merchandiseSubtotal") != null) {
            merchandiseSubtotal = (Double) request.getAttribute("merchandiseSubtotal");
        } else if (request.getParameter("merchandiseSubtotal") != null) {
            merchandiseSubtotal = Double.parseDouble(request.getParameter("merchandiseSubtotal"));
        }
        
        if (request.getAttribute("deliveryFee") != null) {
            deliveryFee = (Double) request.getAttribute("deliveryFee");
        } else if (request.getParameter("deliveryFee") != null) {
            deliveryFee = Double.parseDouble(request.getParameter("deliveryFee"));
        }
        
        if (request.getAttribute("totalPayment") != null) {
            totalPayment = (Double) request.getAttribute("totalPayment");
        } else if (request.getParameter("totalPayment") != null) {
            totalPayment = Double.parseDouble(request.getParameter("totalPayment"));
        }
    } catch (Exception e) {
        // Set default values if parsing fails
        merchandiseSubtotal = 0.0;
        deliveryFee = 0.0;
        totalPayment = 0.0;
    }

    // Get order number and dates from attributes first, then generate if not available
    String orderNumber = request.getAttribute("orderNumber") != null ? 
        (String) request.getAttribute("orderNumber") : 
        "ORD" + System.currentTimeMillis();
    
    String orderDate = request.getAttribute("orderDate") != null ? 
        (String) request.getAttribute("orderDate") : 
        LocalDate.now().format(DateTimeFormatter.ofPattern("dd-MM-yyyy"));
    
    String estimatedDeliveryDate = request.getAttribute("estimatedDeliveryDate") != null ? 
        (String) request.getAttribute("estimatedDeliveryDate") : 
        LocalDate.now().plusDays(7).format(DateTimeFormatter.ofPattern("dd-MM-yyyy"));
    
    // Clear the cart after successful order
    session.removeAttribute("cart");
    session.removeAttribute("cartCount");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Order Confirmation</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" type="text/css" href="confirmation.css">
    <link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@500&display=swap" rel="stylesheet">
</head>
<body>
    <!-- Theme Toggle Button -->
    <button class="theme-toggle" id="theme-toggle" title="Toggle light/dark mode">
        <i class="fas fa-moon"></i>
    </button>
    
    <div class="confirmation-container">
        <div class="confirmation-header">
            <div class="success-icon">
                <i class="fas fa-check-circle"></i>
            </div>
            <h1>Thank You for Your Order!</h1>
            <p>Your order has been successfully placed.</p>
        </div>
        
        <div class="order-details">
            <div class="order-info">
                <div class="info-group">
                    <h2>Order Information</h2>
                    <div class="info-row">
                        <span class="info-label">Order Number:</span>
                        <span class="info-value"><%= orderNumber %></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Order Date:</span>
                        <span class="info-value"><%= orderDate %></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Estimated Delivery:</span>
                        <span class="info-value"><%= estimatedDeliveryDate %></span>
                    </div>
                </div>
                
                <div class="info-group">
                    <h2>Shipping Information</h2>
                    <div class="info-row">
                        <span class="info-label">Name:</span>
                        <span class="info-value"><%= firstName %> <%= lastName %></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Email:</span>
                        <span class="info-value"><%= email %></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Address:</span>
                        <span class="info-value"><%= address %></span>
                    </div>
                    <% if (apartment != null && !apartment.isEmpty()) { %>
                    <div class="info-row">
                        <span class="info-label">Apartment/Suite:</span>
                        <span class="info-value"><%= apartment %></span>
                    </div>
                    <% } %>
                    <div class="info-row">
                        <span class="info-label">Location:</span>
                        <span class="info-value"><%= city %>, <%= state %>, <%= postalCode %></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Country:</span>
                        <span class="info-value"><%= country %></span>
                    </div>
                </div>
                
                <div class="info-group">
                    <h2>Payment Information</h2>
                    <div class="info-row">
                        <span class="info-label">Payment Method:</span>
                        <span class="info-value">
                            <%
                                if ("creditCard".equals(paymentMethod) || "debitCard".equals(paymentMethod)) {
                                    out.print(cardType != null && !cardType.isEmpty() ? 
                                             cardType.substring(0, 1).toUpperCase() + cardType.substring(1) + " Card" : 
                                             "Credit Card");
                                } else if ("cash".equals(paymentMethod)) {
                                    out.print("Cash on Delivery");
                                } else if ("ewallet".equals(paymentMethod)) {
                                    out.print("E-Wallet");
                                } else {
                                    out.print(paymentMethod);
                                }
                            %>
                        </span>
                    </div>
                    
                    <% if ("creditCard".equals(paymentMethod) || "debitCard".equals(paymentMethod)) { %>
                    <div class="info-row">
                        <span class="info-label">Card Holder:</span>
                        <span class="info-value"><%= cardName %></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Card Number:</span>
                        <span class="info-value">
                            <% 
                                // Display only last 4 digits for security
                                if (cardNumber != null && cardNumber.length() >= 4) {
                                    String masked = "xxxx xxxx xxxx " + cardNumber.substring(cardNumber.length() - 4);
                                    out.print(masked);
                                } else {
                                    out.print("xxxx xxxx xxxx xxxx");
                                }
                            %>
                        </span>
                    </div>
                    <% } else if ("ewallet".equals(paymentMethod)) { %>
                    <div class="info-row">
                        <span class="info-label">E-Wallet Provider:</span>
                        <span class="info-value">
                            <% 
                                if ("grabpay".equals(walletType)) {
                                    out.print("GrabPay");
                                } else if ("tng".equals(walletType)) {
                                    out.print("Touch 'n Go eWallet");
                                } else if ("boost".equals(walletType)) {
                                    out.print("Boost");
                                } else if ("shopeepay".equals(walletType)) {
                                    out.print("ShopeePay");
                                } else {
                                    out.print(walletType);
                                }
                            %>
                        </span>
                    </div>
                    <% } %>
                </div>
            </div>
            
            <div class="order-summary">
                <h2>Order Summary</h2>
                
                <div class="product-list">
                    <% 
                        // Use cart from request attribute, then session if not available
                        List<CartItem> displayCart = confirmedCart != null ? confirmedCart : cart;
                        
                        if (displayCart != null && !displayCart.isEmpty()) {
                            for (CartItem item : displayCart) {
                    %>
                    <div class="product-item">
                        <img src="<%= request.getContextPath() + "/" + item.getProduct().getImage() %>" 
                             alt="<%= item.getProduct().getName() %>" class="product-img">
                        <div class="product-details">
                            <h3 class="product-name"><%= item.getProduct().getName() %></h3>
                            <p class="product-meta">Quantity: <%= item.getQuantity() %></p>
                            <p class="product-price">RM <%= String.format("%.2f", item.getProduct().getPrice() * item.getQuantity()) %></p>
                        </div>
                    </div>
                    <% 
                            }
                        } else {
                    %>
                    <p>No items in order</p>
                    <% } %>
                </div>
                
                <div class="price-summary">
                    <div class="price-row">
                        <span class="price-label">Merchandise Subtotal:</span>
                        <span class="price-value">RM <%= String.format("%.2f", merchandiseSubtotal) %></span>
                    </div>
                    <div class="price-row">
                        <span class="price-label">Delivery Fee:</span>
                        <span class="price-value">
                            <% 
                                if (deliveryFee == 0) {
                                    out.print("<span class='free-delivery'>FREE</span>");
                                } else {
                                    out.print("RM " + String.format("%.2f", deliveryFee));
                                }
                            %>
                        </span>
                    </div>
                    <div class="price-row total">
                        <span class="price-label">Total Payment:</span>
                        <span class="price-value">RM <%= String.format("%.2f", totalPayment) %></span>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="next-steps">
            <p>A confirmation email has been sent to <strong><%= email %></strong>.</p>
            <p>Your items will be shipped to your address soon.</p>
        </div>
        
        <div class="action-buttons">
            <a href="home.jsp" class="btn primary-btn">
                <i class="fas fa-home"></i> Return to Homepage
            </a>
            <a href="#" class="btn secondary-btn" onclick="window.print()">
                <i class="fas fa-print"></i> Print Receipt
            </a>
        </div>
        
        <div class="contact-support">
            <p>Need help? Contact our customer support team at <strong>support@pocketgadget.com</strong></p>
        </div>
    </div>
    
    <script>
        // Theme toggle functionality
        const themeToggle = document.getElementById('theme-toggle');
        const themeIcon = themeToggle.querySelector('i');
            
        // Check if user has a previously saved theme preference
        const savedTheme = localStorage.getItem('theme');
        // Default theme is dark (black background), use light-theme class for light mode
        if (savedTheme === 'light') {
            document.documentElement.classList.add('light-theme');
            themeIcon.className = 'fas fa-moon';
        }
        
        // Theme toggle click handler
        themeToggle.addEventListener('click', function() {
            document.documentElement.classList.toggle('light-theme');
            
            // Update button icon
            if (document.documentElement.classList.contains('light-theme')) {
                themeIcon.className = 'fas fa-moon';
                localStorage.setItem('theme', 'light');
            } else {
                themeIcon.className = 'fas fa-sun'; 
                localStorage.setItem('theme', 'dark');
            }
        });
    </script>
</body>
</html>
