<%-- 
    Document   : dashboard
    Created on : Apr 21, 2025, 1:58:37 AM
    Author     : Dell
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Authentication check
    Object userObj = session.getAttribute("user");
    model.User user = (userObj != null) ? (model.User)userObj : null;
    
    if (user == null || !"ADMIN".equalsIgnoreCase(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Admin Page</title>
    </head>
    <body>
        <h1>Hello Admin</h1>|
        <p><a href="${pageContext.request.contextPath}/auth/logout">Logout</a></p>
    </body>
</html>
