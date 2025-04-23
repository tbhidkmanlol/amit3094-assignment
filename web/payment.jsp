<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, model.Product, dao.ProductDAO, model.CartItem" %>
<%
    // Get cart and payment information from session
    List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
    
    // Default values
    double merchandiseSubtotal = 0.0;
    double shippingSubtotal = 0.0;
    double shippingSST = 0.30; // Default SST
    double totalPayment = 0.0;
    String shippingOption = "";
    
    // Get values from request parameters if available
    if (request.getParameter("merchandiseSubtotal") != null) {
        merchandiseSubtotal = Double.parseDouble(request.getParameter("merchandiseSubtotal"));
    }
    if (request.getParameter("shippingSubtotal") != null) {
        shippingSubtotal = Double.parseDouble(request.getParameter("shippingSubtotal"));
    }
    if (request.getParameter("shippingSST") != null) {
        shippingSST = Double.parseDouble(request.getParameter("shippingSST"));
    }
    if (request.getParameter("totalPayment") != null) {
        totalPayment = Double.parseDouble(request.getParameter("totalPayment"));
    }
    
    // Calculate delivery fee based on subtotal amount
    double deliveryFee = (merchandiseSubtotal >= 1000) ? 0.0 : 25.0;
    
    // Update totalPayment to include the new delivery fee
    totalPayment = merchandiseSubtotal + shippingSubtotal + shippingSST + deliveryFee;
    
    // Get billing/shipping info if available
    String firstName = request.getParameter("firstName") != null ? request.getParameter("firstName") : "";
    String lastName = request.getParameter("lastName") != null ? request.getParameter("lastName") : "";
    String email = request.getParameter("email") != null ? request.getParameter("email") : "";
    String address = request.getParameter("address") != null ? request.getParameter("address") : "";
    String city = request.getParameter("city") != null ? request.getParameter("city") : "";
    String state = request.getParameter("state") != null ? request.getParameter("state") : "";
    String postalCode = request.getParameter("postalCode") != null ? request.getParameter("postalCode") : "";
    String country = request.getParameter("country") != null ? request.getParameter("country") : "Malaysia";
    
    // Combine names for display
    String fullName = firstName + " " + lastName;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Payment Page</title> 
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="payment.css">
</head>
<body>
    <!-- Theme Toggle Button -->
    <button class="theme-toggle" id="theme-toggle" title="Toggle light/dark mode">
        <i class="fas fa-sun"></i>
    </button>
    
    <div class="payment-wrapper">
        <!-- LEFT SIDE: Payment Information -->
        <div class="payment-container">
            <h2>Payment Information</h2>

            <form action="ProcessPaymentServlet" method="post" id="paymentForm">
                <!-- Hidden fields to carry forward checkout data -->
                <input type="hidden" name="firstName" value="<%= firstName %>">
                <input type="hidden" name="lastName" value="<%= lastName %>">
                <input type="hidden" name="email" value="<%= email %>">
                <input type="hidden" name="address" value="<%= address %>">
                <input type="hidden" name="city" value="<%= city %>">
                <input type="hidden" name="state" value="<%= state %>">
                <input type="hidden" name="postalCode" value="<%= postalCode %>">
                <input type="hidden" name="country" value="<%= country %>">
                <input type="hidden" name="merchandiseSubtotal" value="<%= merchandiseSubtotal %>">
                <input type="hidden" name="shippingSubtotal" value="<%= shippingSubtotal %>">
                <input type="hidden" name="shippingSST" value="<%= shippingSST %>">
                <input type="hidden" name="deliveryFee" value="<%= deliveryFee %>">
                <input type="hidden" name="totalPayment" value="<%= totalPayment %>">

                <!-- Billing Address Section -->
                <div class="shipping-address-section">
                    <h3><i class="fas fa-map-marker-alt"></i> Billing Address</h3>
                    <div class="shipping-address-content">
                        <div class="address-header">
                            <span class="recipient-name"><%= fullName %></span>
                            <span class="address-label">Default</span>
                        </div>
                        <div class="address-details">
                            <%= address %><br>
                            <%= city %>, <%= state %>, <%= postalCode %><br>
                            <%= country %>
                        </div>
                        <div class="address-phone">
                            <% if (email != null && !email.isEmpty()) { %>
                                Email: <%= email %>
                            <% } %>
                        </div>
                    </div>
                </div>

                <!-- Payment Method -->
                <div class="method-title"><i class="fas fa-credit-card"></i> Payment Method</div>
                <div class="payment-method-buttons">
                    <div class="payment-option" data-method="cash">
                        <i class="fas fa-money-bill-wave"></i>
                        <span>Cash</span>
                    </div>
                    <div class="payment-option" data-method="creditCard">
                        <i class="fas fa-credit-card"></i>
                        <span>Credit Card</span>
                    </div>
                    <div class="payment-option" data-method="ewallet">
                        <i class="fas fa-wallet"></i>
                        <span>E-Wallet</span>
                    </div>
                </div>
                <input type="hidden" id="method" name="method" required>
                <div class="validation-message" id="method-validation">Please select a payment method.</div>

                <!-- Card Details Section - Initially Hidden -->
                <div id="cardDetails">
                    <label for="cardType">Card Type</label>
                    <select id="cardType" name="cardType">
                        <option value="visa">Visa</option>
                        <option value="mastercard">MasterCard</option>
                        <option value="amex">American Express</option>
                    </select>
                   
                    <label for="cardName">Cardholder Name</label>
                    <input type="text" id="cardName" name="cardName" placeholder="Name on card">
                    <div class="validation-message" id="cardName-validation">Please enter the name as it appears on the card.</div>

                    <label for="cardNumber">Card Number</label>
                    <input type="text" id="cardNumber" name="cardNumber" placeholder="0000 0000 0000 0000" maxlength="19" oninput="formatCardNumber(this)">
                    <div class="validation-message" id="cardNumber-validation">Please enter a valid 16-digit card number.</div>

                    <div class="card-row">
                        <div class="card-col">
                            <label for="expiry">Expiry Date</label>
                            <input type="text" id="expiry" name="expiry" placeholder="MM/YY" maxlength="5" oninput="formatExpiry(this)">
                            <div class="validation-message" id="expiry-validation">Please enter a valid expiry date.</div>
                        </div>
                        <div class="card-col">
                            <label for="cvv">CVV</label>
                            <input type="text" id="cvv" name="cvv" placeholder="123" maxlength="3" oninput="validateNumeric(this)">
                            <div class="validation-message" id="cvv-validation">Invalid Security Code</div>
                        </div>
                    </div>
                </div>
                
                <!-- E-Wallet Section - Initially Hidden -->
                <div id="ewalletDetails">
                    <label for="walletType">E-Wallet Provider</label>
                    <select id="walletType" name="walletType">
                        <option value="grabpay">GrabPay</option>
                        <option value="tng">Touch 'n Go eWallet</option>
                        <option value="boost">Boost</option>
                        <option value="shopeepay">ShopeePay</option>
                    </select>
                    <div class="wallet-info">
                        <p>You will be redirected to complete your payment after order confirmation.</p>
                        <p>Make sure you have sufficient balance in your selected e-wallet account.</p>
                    </div>
                </div>
                
                <!-- Cash Section - Initially Hidden -->
                <div id="cashDetails">
                    <div class="cash-info">
                        <p>Please prepare exact amount for cash on delivery.</p>
                        <p>Our delivery personnel will collect payment upon delivery of your items.</p>
                    </div>
                </div>
                
                <div class="button-container">
                    <a href="Checkout.jsp" class="btn-back"><i class="fas fa-arrow-left"></i> Return to checkout</a>
                </div>
        </div>

        <!-- RIGHT SIDE: Order Summary -->
        <div class="order-summary">
            <h3>Order Summary</h3>
            
            <!-- Cart Items -->
            <% if (cart != null && !cart.isEmpty()) { %>
                <% for (CartItem item : cart) { %>
                <div class="cart-item">
                    <img src="<%= request.getContextPath() + "/" + item.getProduct().getImage() %>" 
                         alt="<%= item.getProduct().getName() %>" class="product-img">
                    <div>
                        <p class="product-name"><%= item.getProduct().getName() %></p>
                        <p>Quantity: <%= item.getQuantity() %></p>
                        <p>RM <%= String.format("%.2f", item.getProduct().getPrice() * item.getQuantity()) %></p>
                    </div>
                </div>
                <% } %>
            <% } else { %>
                <p>No items in cart</p>
            <% } %>

            <!-- Order Summary Section -->
            <div class="summary-section">
                <p>Merchandise Subtotal: <span>RM <%= String.format("%.2f", merchandiseSubtotal) %></span></p>
                <p>Shipping: <span>RM <%= String.format("%.2f", shippingSubtotal) %></span></p>
                <p>SST: <span>RM <%= String.format("%.2f", shippingSST) %></span></p>
                
                <% if (merchandiseSubtotal >= 1000) { %>
                <p>Delivery Fee: <span class="free-delivery">FREE</span></p>
                <small class="free-delivery-note">Free delivery for orders above RM 1,000</small>
                <% } else { %>
                <p>Delivery Fee: <span>RM <%= String.format("%.2f", deliveryFee) %></span></p>
                <small class="delivery-note">Free delivery for orders above RM 1,000</small>
                <% } %>
                
                <div class="total-section">
                    <h4>Total: <span id="total-payment">RM <%= String.format("%.2f", totalPayment) %></span></h4>
                </div>
            </div>
            
            <button type="submit" class="confirm-order-btn">Confirm Order</button>
            </form>
        </div>
    </div>
    
    <!-- JavaScript -->
    <script src="payment.js"></script>
    <script>
        // Theme toggle functionality
        const themeToggle = document.getElementById('theme-toggle');
        const themeIcon = themeToggle.querySelector('i');
            
        // Check if user has a previously saved theme preference
        const savedTheme = localStorage.getItem('theme');
        // Apply theme based on saved preference or default to dark
        if (savedTheme === 'light') {
            document.documentElement.classList.add('light-theme');
            themeIcon.className = 'fas fa-moon';
        } else {
            // Ensure dark theme is applied as default
            document.documentElement.classList.remove('light-theme');
            themeIcon.className = 'fas fa-sun';
            localStorage.setItem('theme', 'dark');
        }
        
        // Theme toggle click handler
        themeToggle.addEventListener('click', function() {
            // Toggle theme class
            document.documentElement.classList.toggle('light-theme');
            
            // Update button icon and save preference
            if (document.documentElement.classList.contains('light-theme')) {
                themeIcon.className = 'fas fa-moon';
                localStorage.setItem('theme', 'light');
            } else {
                themeIcon.className = 'fas fa-sun'; 
                localStorage.setItem('theme', 'dark');
            }
            
            // Force page refresh to ensure all styles are applied correctly
            location.reload();
        });
    
        // Payment method selection
        const paymentOptions = document.querySelectorAll('.payment-option');
        const methodInput = document.getElementById('method');
        
        paymentOptions.forEach(option => {
            option.addEventListener('click', function() {
                // Remove active class from all options
                paymentOptions.forEach(opt => {
                    opt.classList.remove('active');
                    // Reset icon color to default
                    opt.querySelector('i').style.color = '';
                });
                
                // Add active class to selected option
                this.classList.add('active');
                
                // Set icon color to primary color (blue)
                this.querySelector('i').style.color = getComputedStyle(document.documentElement).getPropertyValue('--primary-color');
                
                // Set hidden input value
                const method = this.dataset.method;
                methodInput.value = method;
                
                // Show relevant payment details
                togglePaymentDetails(method);
            });
        });
    
        // Function to toggle payment method details sections
        function togglePaymentDetails(method) {
            // Hide all payment details sections first
            document.getElementById('cardDetails').style.display = 'none';
            document.getElementById('ewalletDetails').style.display = 'none';
            document.getElementById('cashDetails').style.display = 'none';
            
            // Show the appropriate section based on selection
            if (method === 'creditCard') {
                document.getElementById('cardDetails').style.display = 'block';
            } else if (method === 'ewallet') {
                document.getElementById('ewalletDetails').style.display = 'block';
            } else if (method === 'cash') {
                document.getElementById('cashDetails').style.display = 'block';
            }
            
            // Reset validation message
            document.getElementById('method-validation').classList.remove('show');
        }
        
        // Function to format card number with spaces after every 4 digits
        function formatCardNumber(input) {
            // Remove all non-digit characters
            let value = input.value.replace(/\D/g, '');
            
            // Add spaces after every 4 digits
            value = value.replace(/(\d{4})(?=\d)/g, '$1 ');
            
            // Update the input value
            input.value = value;
            
            // Validate card number
            validateCardNumber(input);
        }
        
        // Function to validate card number
        function validateCardNumber(input) {
            const cardNumber = input.value.replace(/\s/g, '');
            const validationMsg = document.getElementById('cardNumber-validation');
            
            if (cardNumber.length < 16) {
                validationMsg.classList.add('show');
                input.classList.add('error');
            } else {
                validationMsg.classList.remove('show');
                input.classList.remove('error');
            }
        }
        
        // Function to format expiry date as MM/YY
        function formatExpiry(input) {
            let value = input.value.replace(/\D/g, '');
            
            // Check if the first digit is greater than 1, prepend a 0
            if (value.length === 1 && parseInt(value, 10) > 1) {
                value = '0' + value;
            }
            
            // Ensure the month is between 01-12
            if (value.length === 2) {
                const month = parseInt(value, 10);
                if (month < 1) {
                    value = '01';
                } else if (month > 12) {
                    value = '12';
                }
            }
            
            if (value.length > 2) {
                value = value.substring(0, 2) + '/' + value.substring(2, 4);
            }
            
            input.value = value;
            
            // Validate expiry date
            validateExpiry(input);
        }
        
        // Function to validate expiry date
        function validateExpiry(input) {
            const value = input.value;
            const validationMsg = document.getElementById('expiry-validation');
            
            if (!/^\d{2}\/\d{2}$/.test(value)) {
                validationMsg.classList.add('show');
                input.classList.add('error');
                return;
            }
            
            const [month, year] = value.split('/');
            const inputMonth = parseInt(month, 10);
            
            // Check if month is valid (1-12)
            if (inputMonth < 1 || inputMonth > 12) {
                validationMsg.classList.add('show');
                input.classList.add('error');
                return;
            }
            
            // We're no longer checking if card is expired as requested
            
            validationMsg.textContent = 'Please enter a valid expiry date.';
            validationMsg.classList.remove('show');
            input.classList.remove('error');
        }
        
        // Function to validate numeric input (for CVV)
        function validateNumeric(input) {
            input.value = input.value.replace(/\D/g, '');
            
            const validationMsg = document.getElementById('cvv-validation');
            if (input.value.length < 3) {
                validationMsg.classList.add('show');
                input.classList.add('error');
            } else {
                validationMsg.classList.remove('show');
                input.classList.remove('error');
            }
        }
        
        // Form validation
        document.getElementById('paymentForm').addEventListener('submit', function(e) {
            let isValid = true;
            const paymentMethod = document.getElementById('method').value;
            
            if (!paymentMethod) {
                document.getElementById('method-validation').classList.add('show');
                isValid = false;
            }
            
            // Validate card details if credit/debit card is selected
            if (paymentMethod === 'creditCard') {
                const cardName = document.getElementById('cardName');
                const cardNumber = document.getElementById('cardNumber');
                const expiry = document.getElementById('expiry');
                const cvv = document.getElementById('cvv');
                
                if (!cardName.value.trim()) {
                    document.getElementById('cardName-validation').classList.add('show');
                    cardName.classList.add('error');
                    isValid = false;
                }
                
                const cardNumberValue = cardNumber.value.replace(/\s/g, '');
                if (cardNumberValue.length < 16) {
                    document.getElementById('cardNumber-validation').classList.add('show');
                    cardNumber.classList.add('error');
                    isValid = false;
                }
                
                if (!/^\d{2}\/\d{2}$/.test(expiry.value)) {
                    document.getElementById('expiry-validation').classList.add('show');
                    expiry.classList.add('error');
                    isValid = false;
                }
                
                if (cvv.value.length < 3) {
                    document.getElementById('cvv-validation').classList.add('show');
                    cvv.classList.add('error');
                    isValid = false;
                }
            }
            
            if (!isValid) {
                e.preventDefault(); // Prevent form submission if validation fails
            }
        });
    </script>
</body>
</html>
