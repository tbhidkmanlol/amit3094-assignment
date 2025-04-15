<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Product List</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/home.css" />
</head>
<body>

<header>
    <div class="left-section">
        <div class="logo">
            <img src="${pageContext.request.contextPath}/images/logo.png" alt="Logo" />
        </div>
        <div class="brand">
            <h1>PocketGadget</h1>
            <p>Tech for the Future</p>
        </div>
    </div>

    <nav class="navbar">
        <ul>
            <li><a href="${pageContext.request.contextPath}/home.jsp">Home</a></li>
            <li><a href="#">Products</a></li>
            <li><a href="#">Cart</a></li>
        </ul>
    </nav>
</header>


<footer>
    <p>© 2025 PocketGadget. All rights reserved.</p>
</footer>

</body>
</html>
