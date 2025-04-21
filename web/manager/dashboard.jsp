<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.User" %>
<!DOCTYPE html>
<html>
<head>
    <title>Manager Dashboard</title>
    <style>
        body { font-family: Arial, sans-serif; }
        .dashboard { width: 500px; margin: 50px auto; padding: 20px; border: 1px solid #ddd; }
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
    
    <div class="dashboard">
        <h1>Welcome, Manager!</h1>
        <h3>Admin Management</h3>
        <p><a href="create-admin.jsp">Create New Admin Account</a></p>
        <p><a href="${pageContext.request.contextPath}/auth/logout">Logout</a></p>
    </div>
</body>
</html>