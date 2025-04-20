<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Order Confirmation</title>
    <link rel="stylesheet" type="text/css" href="confirmation.css">
</head>
<body>
    <div class="confirmation-wrapper">
        <h2>Order Confirmation</h2>

        <h3>Billing Information</h3>
        <p>Country: ${country}</p>
        <p>State: ${state}</p>
        <p>District: ${district}</p>
        <p>Postal Code: ${postal}</p>

        <h3>Payment Method</h3>
        <p>Method: ${method}</p>
        <c:if test="${method == 'card'}">
            <p>Cardholder Name: ${cardName}</p>
            <p>Card Number: ${cardNumber}</p>
            <p>Expiry: ${expiry}</p>
        </c:if>

        <h3>Order Summary</h3>
        <p>Item: ${item}</p>
        <p>Original Price: ${originalPrice}</p>
        <p>Coupon Code: ${coupon}</p>
        <p>Discount Applied: ${discount}</p>
        <h4>Total Paid: ${total}</h4>

        <p>Thank you for your purchase! Your order has been confirmed.</p>
        <a href="home.jsp">Return to Home</a>
    </div>
</body>
</html>
