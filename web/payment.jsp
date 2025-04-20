<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Payment Page</title> 
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" type="text/css" href="payment.css"> <!-- Added cache buster -->
</head>
<body>
    <div class="payment-wrapper">
        
        <!-- LEFT SIDE: Billing & Payment -->
        <div class="payment-container">
            <h2>Checkout</h2>

            <!-- Billing Address -->
            <h3>Billing Address</h3>
            <form action="processPayment" method="post">

                <div class="billing-address-grid">
                    <div>
                        <label for="country">Country</label>
                        <input type="text" id="country" name="country">
                    </div>
                    <div>
                        <label for="state">State</label>
                        <input type="text" id="state" name="state">
                    </div>
                    <div>
                        <label for="district">District</label>
                        <input type="text" id="district" name="district">
                    </div>
                    <div>
                        <label for="postal">Postal Code</label>
                        <input type="text" id="postal" name="postal" maxlength="5">
                    </div>
                </div>

                <!-- Payment Method -->
                <label for="method">Payment Method</label>
                <select id="method" name="method" onchange="togglePayment(this.value)" required>
                    <option value="cash">Cash</option>
                    <option value="card">Credit / Debit Card</option>
                    <option value="ewallet">E-Wallet</option>
                </select>

                <div id="cardDetails" style="display: none;">
                   
                    <label for="cardName">Cardholder Name</label>
                    <input type="text" id="cardName" name="cardName" placeholder="Name on card">

                    <label for="cardNumber">Card Number</label>
                    <input type="text" id="cardNumber" name="cardNumber" placeholder="0000 0000 0000 0000" oninput="formatCardNumber(this)">

                    <label for="expiry">Expiry Date (MM/YY)</label>
                    <input type="text" id="expiry" name="expiry" placeholder="MM/YY" maxlength="5">

                    <label for="cvv">CVV</label>
                    <input type="text" id="cvv" name="cvv" placeholder="123" maxlength="3">
                </div>

        </div>

        <!-- RIGHT SIDE: Order Summary -->
        <div class="order-summary">
            <h3>Order Summary</h3>
            <img src="your-product-image.png" alt="Product" style="width: 100px; height: auto;">
            <p><strong>Item:</strong> PG Program in Data Analytics and Data Science</p>

            <label for="coupon">Coupon Code:</label>
            <input type="text" id="coupon" name="coupon" placeholder="Enter coupon code">
            <button type="button">Apply</button>

            <p>Original Price: <span>$135.5</span></p>
            <p>Coupon Discounts: <span>$0</span></p>
            <p>Discounts: <span>$35.5</span></p>
            <h4>Total: <span>$100</span></h4>
            
            <input type="submit" value="Proceed to Checkout">
            
        </div>
      </form>
    </div>
    
    <script src="payment.js"></script>
</body>
</html>
