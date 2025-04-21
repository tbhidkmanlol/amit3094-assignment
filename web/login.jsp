<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Login</title>
    <style>
        body { font-family: Arial, sans-serif; }
        .auth-box { width: 300px; margin: 50px auto; padding: 20px; border: 1px solid #ddd; }
        .form-group { margin-bottom: 15px; }
        input { width: 100%; padding: 8px; }
        button { padding: 8px 15px; }
        .error { color: red; }
    </style>
</head>
<body>
    <div class="auth-box">
        <h2>Login</h2>
        
        <% if (request.getParameter("error") != null) { %>
            <p class="error">Invalid credentials!</p>
        <% } %>
        
        <form action="${pageContext.request.contextPath}/auth/login" method="post">
            <div class="form-group">
                <input type="text" name="username" placeholder="Username" required>
            </div>
            <div class="form-group">
                <input type="password" name="password" placeholder="Password" required>
            </div>
            <button type="submit">Login</button>
        </form>
        
        <p>Customer? <a href="<%=request.getContextPath()%>/register.jsp">Register here</a> or <button onclick="window.location.href='register.jsp'">Register with button</button></p>
    </div>
</body>
</html>