<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Product List</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/home.css" />
</head>
<body>

<!-- Header copied from home.jsp -->
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

<!-- Main page content -->
<div class="mainpage">
    <h2>Product List</h2>
    <!-- Example product -->
    <div class="product">
        <h3>Awesome Gadget</h3>
        <p>Only RM99.99</p>
    </div>
</div>

<!-- Footer copied from home.jsp -->
<footer>
    <p>© 2025 PocketGadget. All rights reserved.</p>
</footer>

</body>
</html>
