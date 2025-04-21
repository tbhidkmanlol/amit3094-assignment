<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Order Confirmation</title>
    <style>
        body {
            font-family: 'Quicksand', sans-serif;
            background-color: #f5f5f5;
            text-align: center;
            padding: 2rem;
        }
        .confirmation-container {
            max-width: 600px;
            margin: 2rem auto;
            background: white;
            padding: 2rem;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        h1 {
            color: #40c9a2;
            margin-bottom: 1rem;
        }
        p {
            margin-bottom: 1.5rem;
            color: #666;
        }
        .btn {
            display: inline-block;
            padding: 0.8rem 1.5rem;
            background: #40c9a2;
            color: white;
            text-decoration: none;
            border-radius: 4px;
            margin-top: 1rem;
        }
    </style>
</head>
<body>
    <div class="confirmation-container">
        <h1>Thank you for your order!</h1>
        <p>Your order has been received and is being processed.</p>
        <p>We've sent a confirmation email to your registered email address.</p>
        <a href="CartController" class="btn">Continue Shopping</a>
    </div>
</body>
</html>