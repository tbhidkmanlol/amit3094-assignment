<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, model.CartItem" %>
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
                        <span class="info-value">${orderNumber}</span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Order Date:</span>
                        <span class="info-value">${orderDate}</span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Estimated Delivery:</span>
                        <span class="info-value">${estimatedDeliveryDate}</span>
                    </div>
                </div>
                
                <div class="info-group">
                    <h2>Shipping Information</h2>
                    <div class="info-row">
                        <span class="info-label">Name:</span>
                        <span class="info-value">${firstName} ${lastName}</span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Email:</span>
                        <span class="info-value">${email}</span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Address:</span>
                        <span class="info-value">${address}</span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Location:</span>
                        <span class="info-value">${district}, ${state}, ${postal}</span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Country:</span>
                        <span class="info-value">${country}</span>
                    </div>
                </div>
                
                <div class="info-group">
                    <h2>Payment Information</h2>
                    <div class="info-row">
                        <span class="info-label">Payment Method:</span>
                        <span class="info-value">
                            <%
                                String method = (String)request.getAttribute("paymentMethod");
                                if ("creditCard".equals(method)) {
                                    out.print("Credit Card");
                                } else if ("debitCard".equals(method)) {
                                    out.print("Debit Card");
                                } else if ("cash".equals(method)) {
                                    out.print("Cash on Delivery");
                                } else if ("ewallet".equals(method)) {
                                    out.print("E-Wallet");
                                }
                            %>
                        </span>
                    </div>
                    
                    <% if ("creditCard".equals(method) || "debitCard".equals(method)) { %>
                    <div class="info-row">
                        <span class="info-label">Card Type:</span>
                        <span class="info-value">
                            <%= request.getAttribute("cardType") %>
                        </span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Card Holder:</span>
                        <span class="info-value">
                            <%= request.getAttribute("cardName") %>
                        </span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Card Number:</span>
                        <span class="info-value">
                            <%= request.getAttribute("cardNumber") %>
                        </span>
                    </div>
                    <% } else if ("ewallet".equals(method)) { %>
                    <div class="info-row">
                        <span class="info-label">E-Wallet Provider:</span>
                        <span class="info-value">
                            <% 
                                String wallet = (String)request.getAttribute("walletType");
                                if ("grabpay".equals(wallet)) {
                                    out.print("GrabPay");
                                } else if ("tng".equals(wallet)) {
                                    out.print("Touch 'n Go eWallet");
                                } else if ("boost".equals(wallet)) {
                                    out.print("Boost");
                                } else if ("shopeepay".equals(wallet)) {
                                    out.print("ShopeePay");
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
                        List<CartItem> confirmedCart = (List<CartItem>)request.getAttribute("confirmedCart");
                        if (confirmedCart != null && !confirmedCart.isEmpty()) {
                            for (CartItem item : confirmedCart) {
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
                        } 
                    %>
                </div>
                
                <div class="price-summary">
                    <div class="price-row">
                        <span class="price-label">Merchandise Subtotal:</span>
                        <span class="price-value">RM ${merchandiseSubtotal}</span>
                    </div>
                    <div class="price-row">
                        <span class="price-label">Shipping Fee:</span>
                        <span class="price-value">RM ${shippingSubtotal}</span>
                    </div>
                    <div class="price-row">
                        <span class="price-label">Shipping SST:</span>
                        <span class="price-value">RM ${shippingSST}</span>
                    </div>
                    <div class="price-row">
                        <span class="price-label">Delivery Fee:</span>
                        <span class="price-value">
                            <% 
                                double deliveryFee = (Double)request.getAttribute("deliveryFee");
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
                        <span class="price-value">RM ${totalPayment}</span>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="next-steps">
            <p>A confirmation email has been sent to <strong>${email}</strong>.</p>
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
