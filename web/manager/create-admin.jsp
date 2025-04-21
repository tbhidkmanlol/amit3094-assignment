<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.User" %>
<!DOCTYPE html>
<html>
<head>
    <title>Create Admin Account</title>
    <style>
        body { font-family: Arial, sans-serif; }
        .auth-box { width: 300px; margin: 50px auto; padding: 20px; border: 1px solid #ddd; }
        .form-group { margin-bottom: 15px; }
        input { width: 100%; padding: 8px; }
        button { padding: 8px 15px; }
        .error { color: red; }
        .success { color: green; }
    </style>
</head>
<body>
    <%
        User user = (User) session.getAttribute("user");
        if (user == null || !"MANAGER".equals(user.getRole())) {
            response.sendRedirect("../login.jsp?error=unauthorized");
            return;
        }
    %>
    
    <div class="auth-box">
        <h2>Create Admin Account</h2>
        
        <% if (request.getParameter("error") != null) { %>
            <p class="error">Failed to create admin account!</p>
        <% } %>
        <% if (request.getParameter("success") != null) { %>
            <p class="success">Admin account created successfully!</p>
        <% } %>
        
        <form action="${pageContext.request.contextPath}/auth/create-admin" method="post">
            <div class="form-group">
                <input type="text" name="username" placeholder="Admin Username" required>
            </div>
            <div class="form-group">
                <input type="password" name="password" placeholder="Password" required>
            </div>
            <button type="submit">Create Admin</button>
        </form>
        
        <p><a href="../manager/dashboard.jsp">Back to Dashboard</a></p>
    </div>
</body>
</html>