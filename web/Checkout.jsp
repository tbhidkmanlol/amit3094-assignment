<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List, model.CartItem, java.util.ArrayList, model.User"%>
<%
    // Initialize variables with default values
    List<CartItem> cart = (List<CartItem>) request.getAttribute("cartItems");
    if (cart == null) {
        cart = new ArrayList<CartItem>(); // Initialize empty cart if null
    }
    double subtotal = 0.0;
    double totalPayment = 0.0;

    // Safely get subtotal from request
    if (request.getAttribute("total") != null) {
        subtotal = (Double) request.getAttribute("total");
    }
    
    // Calculate delivery fee based on subtotal amount
    double deliveryFee = (subtotal >= 1000) ? 0.0 : 25.0;
    
    // Calculate final total
    totalPayment = subtotal + deliveryFee;
    
    // Get user information if logged in
    User user = (User) session.getAttribute("user");
    String userEmail = "";
    
    if (user != null) {
        userEmail = user.getUsername(); // In a real app, you might have the email stored
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Checkout</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <link rel="stylesheet" href="Checkout.css">
    </head>
    <body>
        <!-- Theme Toggle Button -->
        <button class="theme-toggle" id="theme-toggle" title="Toggle light/dark mode">
            <i class="fas fa-sun"></i>
        </button>
        
        <div class="checkout-container">
            <div class="checkout-left">
                <h1>Checkout</h1>

                <form id="checkoutForm" action="ProcessCheckoutServlet" method="post">
                    <h3><i class="fas fa-envelope"></i> Contact Information</h3>
                    <div class="form-group">
                        <input type="email" class="form-control" name="email" placeholder="Email" value="<%= userEmail %>" required>
                        <div class="validation-message" id="email-validation">Please enter a valid email address.</div>
                    </div>

                    <div class="checkbox-container">
                        <input type="checkbox" id="newsletter" name="newsletter">
                        <label for="newsletter">Email me with news and offers</label>
                    </div>

                    <h3><i class="fas fa-map-marker-alt"></i> Shipping Address</h3>
                    <div class="form-group">
                        <div class="select-wrapper">
                            <select class="form-control" name="country" required>
                                <option value="Malaysia">Malaysia</option>
                            </select>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col">
                            <div class="form-group">
                                <input type="text" class="form-control" name="firstName" placeholder="First name" required>
                                <div class="validation-message" id="firstName-validation">Please enter your first name.</div>
                            </div>
                        </div>
                        <div class="col">
                            <div class="form-group">
                                <input type="text" class="form-control" name="lastName" placeholder="Last name" required>
                                <div class="validation-message" id="lastName-validation">Please enter your last name.</div>
                            </div>
                        </div>
                    </div>

                    <div class="form-group">
                        <input type="text" class="form-control" name="address" placeholder="Address" required>
                        <div class="validation-message" id="address-validation">Please enter your address.</div>
                    </div>

                    <div class="form-group">
                        <input type="text" class="form-control" name="apartment" placeholder="Apartment, suite, etc. (optional)">
                    </div>

                    <div class="row">
                        <div class="col">
                            <div class="form-group">
                                <input type="text" class="form-control" name="city" placeholder="City" required>
                                <div class="validation-message" id="city-validation">Please enter your city.</div>
                            </div>
                        </div>
                        <div class="col">
                            <div class="select-wrapper">
                                <select class="form-control" name="state" required>
                                    <option value="">Select state</option>
                                    <option value="Perak">Perak</option>
                                    <option value="Johor">Johor</option>
                                    <option value="Kedah">Kedah</option>
                                    <option value="Kuantan">Kuantan</option>
                                    <option value="Melaka">Melaka</option>
                                    <option value="Negeri Sembilan">Negeri Sembilan</option>
                                    <option value="Penang">Penang</option>
                                    <option value="Kuala Lumpur">Kuala Lumpur(federal territory)</option>
                                    <option value="Terengganu">Terengganu</option>
                                    <option value="Selangor">Selangor</option>
                                    <option value="Sabah">Sabah</option>
                                    <option value="Sarawak">Sarawak</option>
                                </select>
                                <div class="validation-message" id="state-validation">Please select a state.</div>
                            </div>
                        </div>
                        <div class="col">
                            <div class="form-group">
                                <input type="text" class="form-control" name="postalCode" placeholder="Postal code" required pattern="[0-9]{5}" maxlength="5" oninput="this.value = this.value.replace(/[^0-9]/g, '')">
                                <div class="validation-message" id="postalCode-validation">Please enter a valid 5-digit postal code.</div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Hidden fields for cart information -->
                    <input type="hidden" name="merchandiseSubtotal" value="<%= String.format("%.2f", subtotal)%>">
                    <input type="hidden" name="deliveryFee" value="<%= String.format("%.2f", deliveryFee)%>">
                    <input type="hidden" name="totalPayment" value="<%= String.format("%.2f", totalPayment)%>">
                    <input type="hidden" name="shippingOption" value="nextDay">
                    
                    <div class="button-container">
                        <a href="cart.jsp" class="btn-back"><i class="fas fa-arrow-left"></i> Return to cart</a>
                    </div>
                </form>
            </div>
            <div class="checkout-right">
                <h3>Order Summary</h3>
                
                <% for (CartItem item : cart) {%>
                <div class="cart-item" data-product-id="<%= item.getProduct().getId()%>">
                    <div class="cart-image">
                        <div class="item-count"><%= item.getQuantity()%></div>
                        <img src="<%= request.getContextPath() + "/" + item.getProduct().getImage()%>" 
                             alt="<%= item.getProduct().getName()%>">
                    </div>
                    <div class="cart-item-details">
                        <h4 class="item-name"><%= item.getProduct().getName()%></h4>
                        <div class="item-type">Product</div>
                    </div>
                    <div class="quantity-controls">
                        <button class="quantity-btn minus" onclick="updateQuantity(this, -1)">-</button>
                        <span class="quantity"><%= item.getQuantity()%></span>
                        <button class="quantity-btn plus" onclick="updateQuantity(this, 1)">+</button>
                    </div>
                    <div class="item-price">RM<%= String.format("%.2f", item.getProduct().getPrice() * item.getQuantity())%></div>
                </div>
                <% }%>

                <div class="promo-code">
                    <input type="text" class="promo-input" placeholder="Gift card or offer code">
                    <button class="promo-button">Apply</button>
                </div>

                <div class="summary-section">
                    <div class="summary-row total">
                        <div>Total Payment</div>
                        <div>RM<%= String.format("%.2f", subtotal)%></div>
                    </div>
                </div>

                <button type="button" class="btn-continue" id="proceedToPaymentBtn">Proceed to Payment</button>
            </div>
        </div>

        <script>
            // Theme toggle functionality
            const themeToggle = document.getElementById('theme-toggle');
            const themeIcon = themeToggle.querySelector('i');
            
            // Define theme-specific CSS variables
            const lightThemeVars = {
                '--text-color': '#333',
                '--background-color': '#f5f5f5',
                '--card-background': '#ffffff',
                '--input-background': '#f9f9f9',
                '--border-color': '#ddd'
            };
            
            const darkThemeVars = {
                '--text-color': '#f5f5f5',
                '--background-color': '#121212',
                '--card-background': '#1e1e1e',
                '--input-background': '#2d2d2d',
                '--border-color': '#444'
            };
                
            // Check if user has a previously saved theme preference
            const savedTheme = localStorage.getItem('theme');
            if (savedTheme === 'light') {
                applyTheme('light');
                themeIcon.className = 'fas fa-moon';
            } else {
                // Default is dark theme
                applyTheme('dark');
                themeIcon.className = 'fas fa-sun';
                localStorage.setItem('theme', 'dark');
            }
            
            // Theme toggle click handler
            themeToggle.addEventListener('click', function() {
                const isLightTheme = document.documentElement.classList.contains('light-theme');
                
                if (isLightTheme) {
                    // Switch to dark theme
                    applyTheme('dark');
                    themeIcon.className = 'fas fa-sun';
                    localStorage.setItem('theme', 'dark');
                } else {
                    // Switch to light theme
                    applyTheme('light');
                    themeIcon.className = 'fas fa-moon';
                    localStorage.setItem('theme', 'light');
                }
            });
            
            // Function to apply theme without page refresh
            function applyTheme(theme) {
                const root = document.documentElement;
                
                if (theme === 'light') {
                    document.documentElement.classList.add('light-theme');
                    // Apply light theme variables
                    for (const [property, value] of Object.entries(lightThemeVars)) {
                        root.style.setProperty(property, value);
                    }
                } else {
                    document.documentElement.classList.remove('light-theme');
                    // Apply dark theme variables
                    for (const [property, value] of Object.entries(darkThemeVars)) {
                        root.style.setProperty(property, value);
                    }
                }
            }
            
            // Form validation
            document.getElementById('checkoutForm').addEventListener('submit', function(e) {
                // Prevent default form submission to handle it with our custom logic
                e.preventDefault();
                
                if (validateForm()) {
                    // Only submit if validation passes
                    this.submit();
                }
            });

            // Add click handler for the "Proceed to Payment" button
            document.getElementById('proceedToPaymentBtn').addEventListener('click', function() {
                if (validateForm()) {
                    document.getElementById('checkoutForm').submit();
                }
            });
            
            // Comprehensive form validation function
            function validateForm() {
                let isValid = true;
                
                // Reset validation
                const inputs = document.querySelectorAll('.form-control[required]');
                inputs.forEach(input => {
                    input.classList.remove('error-field');
                    const validationMsg = document.getElementById(input.name + '-validation');
                    if (validationMsg) {
                        validationMsg.classList.remove('show');
                    }
                });
                
                // Validate required fields
                inputs.forEach(input => {
                    if (!input.value.trim()) {
                        input.classList.add('error-field');
                        const validationMsg = document.getElementById(input.name + '-validation');
                        if (validationMsg) {
                            validationMsg.classList.add('show');
                        }
                        isValid = false;
                    }
                    
                    // Email validation
                    if (input.name === 'email' && input.value.trim()) {
                        const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                        if (!emailPattern.test(input.value)) {
                            input.classList.add('error-field');
                            document.getElementById('email-validation').classList.add('show');
                            isValid = false;
                        }
                    }
                    
                    // Postal code validation
                    if (input.name === 'postalCode' && input.value.trim()) {
                        const postalPattern = /^\d{5}$/;
                        if (!postalPattern.test(input.value)) {
                            input.classList.add('error-field');
                            document.getElementById('postalCode-validation').classList.add('show');
                            isValid = false;
                        }
                    }
                });
                
                // Also validate select fields
                const selects = document.querySelectorAll('select[required]');
                selects.forEach(select => {
                    if (!select.value) {
                        select.classList.add('error-field');
                        const validationMsg = document.getElementById(select.name + '-validation');
                        if (validationMsg) {
                            validationMsg.classList.add('show');
                        }
                        isValid = false;
                    }
                });
                
                if (!isValid) {
                    alert('Please fill in all required fields correctly before proceeding to payment.');
                    
                    // Scroll to the first error
                    const firstError = document.querySelector('.error-field');
                    if (firstError) {
                        firstError.scrollIntoView({ behavior: 'smooth', block: 'center' });
                        firstError.focus();
                    }
                    return false;
                }
                
                return true;
            }

            // Add click handler for return to cart button
            document.querySelector('.btn-back').addEventListener('click', function () {
                window.location.href = 'cart.jsp';
            });

            // Function to update quantity
            function updateQuantity(button, change) {
                const cartItem = button.closest('.cart-item');
                const productId = cartItem.dataset.productId;
                console.log('Product ID for update:', productId);

                const quantityElement = cartItem.querySelector('.quantity');
                const itemCountElement = cartItem.querySelector('.item-count');
                const priceElement = cartItem.querySelector('.item-price');

                // Get current quantity as number
                let currentQuantity = parseInt(quantityElement.textContent) || 1;
                // Calculate price per item correctly
                const currentPrice = parseFloat(priceElement.textContent.replace('RM', ''));
                const pricePerItem = currentPrice / currentQuantity;

                let newQuantity = currentQuantity + change;

                // Ensure quantity doesn't go below 1
                if (newQuantity < 1)
                    newQuantity = 1;

                // Update the quantity display
                quantityElement.textContent = newQuantity;
                itemCountElement.textContent = newQuantity;

                // Update the item price
                const newItemPrice = pricePerItem * newQuantity;
                priceElement.textContent = 'RM' + newItemPrice.toFixed(2);

                // Update the totals immediately for a responsive UI
                updateTotals();

                // Send AJAX request to update cart on server
                updateCartOnServer(productId, newQuantity);
            }

            // Function to update totals after cart changes
            function updateTotals() {
                try {
                    // Calculate subtotal from all cart items
                    let subtotal = 0;
                    const items = document.querySelectorAll('.cart-item');

                    items.forEach((item) => {
                        const priceElement = item.querySelector('.item-price');
                        if (priceElement) {
                            const priceText = priceElement.textContent;
                            const price = parseFloat(priceText.replace('RM', ''));
                            if (!isNaN(price)) {
                                subtotal += price;
                            }
                        }
                    });

                    // For hidden fields - keep the full calculation for backend processing
                    // Fixed costs
                    const deliveryFee = (subtotal >= 1000) ? 0 : 25.0;
                    const totalPayment = subtotal + deliveryFee;
                    
                    // Update the total display to show only merchandise subtotal
                    const summaryRow = document.querySelector('.summary-row.total');
                    if (summaryRow) {
                        const totalEl = summaryRow.querySelector('div:last-child');
                        if (totalEl) {
                            totalEl.textContent = 'RM' + subtotal.toFixed(2);
                        }
                    }

                    // Update hidden form fields with full calculation for server
                    document.querySelector('input[name="merchandiseSubtotal"]').value = subtotal.toFixed(2);
                    document.querySelector('input[name="deliveryFee"]').value = deliveryFee.toFixed(2);
                    document.querySelector('input[name="totalPayment"]').value = totalPayment.toFixed(2);
                } catch (error) {
                    console.error('Error in updateTotals:', error);
                }
            }

            // Function to update cart on server via AJAX
            function updateCartOnServer(productId, quantity) {
                // Ensure quantity is a valid number
                quantity = parseInt(quantity);
                if (isNaN(quantity) || quantity < 1) {
                    console.error('Invalid quantity:', quantity);
                    return;
                }

                // Make sure the productId is properly trimmed
                if (productId) {
                    productId = productId.trim();
                }

                // Format the data properly for x-www-form-urlencoded
                const formData = new URLSearchParams();
                formData.append('productId', productId);
                formData.append('quantity', quantity);

                fetch('UpdateCCartServlet', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    },
                    body: formData.toString()
                })
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Network response was not ok');
                    }
                    return response.json();
                })
                .then(data => {
                    if (!data.success) {
                        console.error('Failed to update cart on server:', data.error);
                    }
                })
                .catch(error => {
                    console.error('Error updating cart:', error);
                });
            }

            // Initialize form validation - add event listeners for real-time feedback
            const requiredInputs = document.querySelectorAll('.form-control[required]');
            requiredInputs.forEach(input => {
                input.addEventListener('blur', function() {
                    validateField(this);
                });
                
                input.addEventListener('input', function() {
                    if (this.classList.contains('error-field')) {
                        validateField(this);
                    }
                });
            });
            
            function validateField(field) {
                const validationMsg = document.getElementById(field.name + '-validation');
                
                if (!field.value.trim()) {
                    field.classList.add('error-field');
                    if (validationMsg) validationMsg.classList.add('show');
                    return false;
                } 
                
                // Email validation
                if (field.name === 'email') {
                    const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                    if (!emailPattern.test(field.value)) {
                        field.classList.add('error-field');
                        if (validationMsg) validationMsg.classList.add('show');
                        return false;
                    }
                }
                
                // Postal code validation
                if (field.name === 'postalCode') {
                    const postalPattern = /^\d{5}$/;
                    if (!postalPattern.test(field.value)) {
                        field.classList.add('error-field');
                        if (validationMsg) validationMsg.classList.add('show');
                        return false;
                    }
                }
                
                field.classList.remove('error-field');
                if (validationMsg) validationMsg.classList.remove('show');
                return true;
            }

            // Initialize totals when page loads
            document.addEventListener('DOMContentLoaded', function () {
                updateTotals();
            });
        </script>
    </body>
</html>