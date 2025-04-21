<%-- 
    Document   : dashboard
    Created on : Apr 21, 2025, 1:58:08 AM
    Author     : Dell
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Authentication check
    Object userObj = session.getAttribute("user");
    model.User user = (userObj != null) ? (model.User)userObj : null;
    
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Customer Page</title>
    </head>
    <body>
        <h1>Hello Customer</h1>
        <p><a href="${pageContext.request.contextPath}/auth/logout">Logout</a></p>
    </body>
</html>
