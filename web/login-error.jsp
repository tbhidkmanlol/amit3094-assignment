<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Login Failed</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
        }
        .error-container {
            width: 400px;
            margin: 100px auto;
            padding: 30px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 0 15px rgba(0,0,0,0.1);
            text-align: center;
            border-left: 5px solid #dc3545;
        }
        .error-icon {
            color: #dc3545;
            font-size: 50px;
            margin-bottom: 20px;
        }
        .btn-retry {
            background-color: #dc3545;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            margin-top: 20px;
        }
        .btn-retry:hover {
            background-color: #c82333;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="error-icon">✕</div>
        <h2>Login Failed</h2>
        
        <%-- Display specific error message --%>
        <% String error = request.getParameter("error"); %>
        <p>
            <% if("invalid".equals(error)) { %>
                Invalid username or password. Please try again.
            <% } else if("locked".equals(error)) { %>
                Account temporarily locked. Try again in 15 minutes.
            <% } else if("expired".equals(error)) { %>
                Your session has expired. Please login again.
            <% } else { %>
                An error occurred during login. Please try again.
            <% } %>
        </p>
        
        <a href="login.jsp" class="btn-retry">Return to Login</a>
        
        <div style="margin-top: 30px; font-size: 14px; color: #6c757d;">
            <p>Need help? <a href="mailto:support@yourdomain.com">Contact support</a></p>
        </div>
    </div>
</body>
</html>