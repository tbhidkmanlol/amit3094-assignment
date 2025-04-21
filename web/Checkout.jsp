<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List, model.CartItem, java.util.ArrayList, model.User"%>
<%
    // Initialize variables with default values
    List<CartItem> cart = (List<CartItem>) request.getAttribute("cartItems");
    if (cart == null) {
        cart = new ArrayList<CartItem>(); // Initialize empty cart if null
    }
    double subtotal = 0.0;
    double shippingSST = 0.30; // Fixed SST fee
    double shippingSubtotal = 0.0;
    double totalPayment = 0.0;

    // Safely get subtotal from request
    if (request.getAttribute("total") != null) {
        subtotal = (Double) request.getAttribute("total");
    }

    // Determine shipping option (default to nextDay if none selected)
    String shippingOption = request.getParameter("shippingOption");
    if (shippingOption == null || shippingOption.isEmpty()) {
        shippingOption = "nextDay";
    }

    // Calculate shipping costs based on selection
    if (shippingOption.equals("nextDay")) {
        shippingSubtotal = 4.89; // 5.19 total - 0.30 SST
    } else if (shippingOption.equals("selfCollection")) {
        shippingSubtotal = 2.35; // 2.65 total - 0.30 SST
    }

    // Calculate final total
    totalPayment = subtotal + shippingSubtotal + shippingSST;
    
    // Get user information if logged in
    User user = (User) session.getAttribute("user");
    String userEmail = "";
    
    if (user != null) {
        userEmail = user.getUsername(); // In a real app, you might have the email stored
    }
%>
<!DOCTYPE html>
<html>
    <style>
        .quantity-controls {
            display: flex;
            align-items: center;
            margin-right: 12px;
        }

        .quantity-btn {
            width: 25px;
            height: 25px;
            border: 1px solid #ddd;
            background: #f8f8f8;
            cursor: pointer;
            font-size: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .quantity-btn:hover {
            background: #e8e8e8;
        }

        .quantity {
            margin: 0 10px;
            min-width: 20px;
            text-align: center;
        }

        .payment-btn {
            width: 30%;
            padding: 14px;
            background-color: #3dd1a1;
            color: white;
            font-weight: bold;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 16px;
            margin-top: 10px;
        }
        
        .error-field {
            border-color: #f72585 !important;
            box-shadow: 0 0 0 1px #f72585 !important;
        }
        
        .validation-message {
            color: #f72585;
            font-size: 12px;
            margin-top: 5px;
            display: none;
        }
        
        .validation-message.show {
            display: block;
        }
        
        /* Theme toggle button */
        .theme-toggle {
            position: fixed;
            top: 20px;
            right: 20px;
            background-color: #16213e;
            color: #ffffff;
            border: none;
            border-radius: 50%;
            width: 50px;
            height: 50px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            font-size: 1.5rem;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s, background-color 0.3s;
            z-index: 100;
        }
        
        .theme-toggle:hover {
            transform: scale(1.1);
        }
        
        /* Dark theme styles */
        html.dark-theme {
            --bg-color: #1a1a2e;
            --text-color: #f0f0f0;
            --card-bg: #272640;
            --border-color: #3a3a55;
            --header-color: #4cc9f0;
            --btn-bg: #4361ee;
            --btn-text: #f0f0f0;
        }
    </style>
    <head>
        <title>Checkout</title>
        <link rel="stylesheet" href="Checkout.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    </head>
    <body>
        <!-- Theme Toggle Button -->
        <button class="theme-toggle" id="theme-toggle" title="Toggle light/dark mode">
            <i class="fas fa-moon"></i>
        </button>
        
        <div class="checkout-container">
            <div class="checkout-left">
                <h1 class="logo">Checkout</h1>

                <div class="checkout-steps">
                    <div class="step active">
                        <div class="step-number">1</div>
                        <div class="step-label">Your Cart</div>
                    </div>
                    <div class="step">
                        <div class="step-number">2</div>
                        <div class="step-label">Details</div>
                    </div>
                    <div class="step">
                        <div class="step-number">3</div>
                        <div class="step-label">Shipping</div>
                    </div>
                    <div class="step">
                        <div class="step-number">4</div>
                        <div class="step-label">Payment</div>
                    </div>
                    <div class="step">
                        <div class="step-number">5</div>
                        <div class="step-label">Complete</div>
                    </div>
                </div>

                <div class="express-checkout">
                    <h4>Express checkout</h4>
                    <div class="payment-buttons">
                        <button class="payment-button shop-pay">Shop Pay</button>
                        <button class="payment-button google-pay">G Pay</button>
                    </div>
                </div>

                <div class="divider">
                    <span class="divider-text">OR</span>
                </div>

                <form id="checkoutForm" action="ProcessCheckoutServlet" method="post">
                    <h3>Contact information</h3>
                    <div class="form-group">
                        <input type="email" class="form-control" name="email" placeholder="Email" value="<%= userEmail %>" required>
                        <div class="validation-message" id="email-validation">Please enter a valid email address.</div>
                    </div>

                    <div class="checkbox-container">
                        <input type="checkbox" id="newsletter" name="newsletter">
                        <label for="newsletter">Email me with news and offers</label>
                    </div>

                    <h3>Shipping address</h3>
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
                                <input type="text" class="form-control" name="postalCode" placeholder="Postal code" required pattern="[0-9]{5}">
                                <div class="validation-message" id="postalCode-validation">Please enter a valid 5-digit postal code.</div>
                            </div>
                        </div>
                    </div>

                    <h3>Shipping Option</h3>
                    <div class="shipping-option">
                        <div class="option-card">
                            <label class="option-content">
                                <input type="radio" name="shippingOption" value="nextDay" required
                                       <%= shippingOption.equals("nextDay") ? "checked" : ""%>>
                                <div class="option-details">
                                    <div class="option-header">
                                        <span class="option-title">Next Day Delivery</span>
                                        <span class="option-price">RM5.19</span>
                                    </div>
                                    <div class="option-description">
                                        Guaranteed to get by 21 Apr<br>
                                        Get a RM5.00 voucher if not attempted by 21 Apr 2025.<br>
                                        Order before 12PM to receive the next day (excl. weekends and public holidays)
                                    </div>
                                </div>
                            </label>
                        </div>

                        <div class="option-card">
                            <label class="option-content">
                                <input type="radio" name="shippingOption" value="selfCollection" required
                                       <%= shippingOption.equals("selfCollection") ? "checked" : ""%>>
                                <div class="option-details">
                                    <div class="option-header">
                                        <span class="option-title">Self Collection Point</span>
                                        <span class="option-price">RM2.65</span>
                                    </div>
                                    <div class="option-description">
                                        Get a RM5.00 voucher if not attempted by 21 Apr 2025.<br>
                                        Collect your parcel from Collection Point within 7 days. For orders up to RM80.<br>
                                        <a href="#">Select Collection Point ›</a>
                                    </div>
                                </div>
                            </label>
                        </div>
                    </div>
                    
                    <!-- Hidden fields for cart information -->
                    <input type="hidden" name="merchandiseSubtotal" value="<%= String.format("%.2f", subtotal)%>">
                    <input type="hidden" name="shippingSubtotal" value="<%= String.format("%.2f", shippingSubtotal)%>">
                    <input type="hidden" name="shippingSST" value="<%= String.format("%.2f", shippingSST)%>">
                    <input type="hidden" name="totalPayment" value="<%= String.format("%.2f", totalPayment)%>">
                    
                    <!-- Payment Button -->
                    <button type="submit" class="payment-btn">
                        Payment
                    </button>
                </form>

                <div class="button-container">
                    <a href="cart.jsp" class="btn btn-back">‹ Return to cart</a>
                </div>

                <div class="policy-links">
                    <a href="#">Refund policy</a>
                    <a href="#">Shipping policy</a>
                    <a href="#">Privacy policy</a>
                    <a href="#">Terms of service</a>
                    <a href="#">Purchase options cancellation policy</a>
                </div>
            </div>
            <div class="checkout-right">
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

                <div class="summary-row">
                    <div>Merchandise Subtotal</div>
                    <div>RM<%= String.format("%.2f", subtotal)%></div>
                </div>

                <div class="summary-row">
                    <div>Shipping Subtotal (excl. SST)</div>
                    <div>RM<%= String.format("%.2f", shippingSubtotal)%></div>
                </div>

                <div class="summary-row">
                    <div>Shipping Fee SST</div>
                    <div>RM<%= String.format("%.2f", shippingSST)%></div>
                </div>

                <div class="summary-row total">
                    <div>Total Payment</div>
                    <div>RM<%= String.format("%.2f", totalPayment)%></div>
                </div>

                <button type="button" class="btn-continue" onclick="document.getElementById('checkoutForm').submit()">Place Order</button>
            </div>
        </div>

        <script>
            // Theme toggle functionality
            const themeToggle = document.getElementById('theme-toggle');
            const themeIcon = themeToggle.querySelector('i');
                
            // Check if user has a previously saved theme preference
            const savedTheme = localStorage.getItem('theme');
            if (savedTheme === 'dark') {
                document.documentElement.classList.add('dark-theme');
                themeIcon.className = 'fas fa-sun';
            }
            
            // Theme toggle click handler
            themeToggle.addEventListener('click', function() {
                document.documentElement.classList.toggle('dark-theme');
                
                // Update button icon
                if (document.documentElement.classList.contains('dark-theme')) {
                    themeIcon.className = 'fas fa-sun';
                    localStorage.setItem('theme', 'dark');
                } else {
                    themeIcon.className = 'fas fa-moon';
                    localStorage.setItem('theme', 'light');
                }
            });
            
            // Form validation
            document.getElementById('checkoutForm').addEventListener('submit', function(e) {
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
                    e.preventDefault();
                    alert('Please fill in all required fields correctly before proceeding to payment.');
                    
                    // Scroll to the first error
                    const firstError = document.querySelector('.error-field');
                    if (firstError) {
                        firstError.scrollIntoView({ behavior: 'smooth', block: 'center' });
                        firstError.focus();
                    }
                }
            });

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

                    // Get shipping costs
                    const shippingOptionEl = document.querySelector('input[name="shippingOption"]:checked');
                    if (!shippingOptionEl)
                        return; // Exit if shipping option not found

                    const shippingOption = shippingOptionEl.value;
                    let shippingSubtotal = 0;
                    const shippingSST = 0.30;

                    // Set shipping subtotal based on option
                    if (shippingOption === "nextDay") {
                        shippingSubtotal = 4.89;
                    } else if (shippingOption === "selfCollection") {
                        shippingSubtotal = 2.35;
                    }

                    // Calculate total payment
                    const totalPayment = subtotal + shippingSubtotal + shippingSST;

                    // Update the display elements - Using more specific selectors to ensure correct updating
                    const summaryRows = document.querySelectorAll('.summary-row');
                    if (summaryRows.length >= 1) {
                        const subtotalEl = summaryRows[0].querySelector('div:last-child');
                        if (subtotalEl) {
                            subtotalEl.textContent = 'RM' + subtotal.toFixed(2);
                        }
                    }

                    if (summaryRows.length >= 2) {
                        const shippingSubtotalEl = summaryRows[1].querySelector('div:last-child');
                        if (shippingSubtotalEl) {
                            shippingSubtotalEl.textContent = 'RM' + shippingSubtotal.toFixed(2);
                        }
                    }

                    if (summaryRows.length >= 3) {
                        const shippingSST_El = summaryRows[2].querySelector('div:last-child');
                        if (shippingSST_El) {
                            shippingSST_El.textContent = 'RM' + shippingSST.toFixed(2);
                        }
                    }

                    const totalPaymentEl = document.querySelector('.summary-row.total div:last-child');
                    if (totalPaymentEl) {
                        totalPaymentEl.textContent = 'RM' + totalPayment.toFixed(2);
                    }

                    // Update hidden form fields
                    document.querySelector('input[name="merchandiseSubtotal"]').value = subtotal.toFixed(2);
                    document.querySelector('input[name="shippingSubtotal"]').value = shippingSubtotal.toFixed(2);
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

            // Add listener for shipping option changes
            document.querySelectorAll('input[name="shippingOption"]').forEach(radio => {
                radio.addEventListener('change', function () {
                    updateTotals();
                });
            });

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