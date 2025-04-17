<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Product List</title>
        <link rel="stylesheet" href="styles.css">
    </head>
    <body>
        <div class="container">
            <header>
                <div class="left-section">
                    <div class="logo">
                        <img src="${pageContext.request.contextPath}/images/logo.png" alt="Logo" />
                    </div>
                    <div class="brand">
                        <h1>PocketGadget</h1>
                    </div>
                </div>

                <nav class="navbar">
                    <ul>
                        <li><a href="${pageContext.request.contextPath}/products">Products</a></li>
                        <li><a href="${pageContext.request.contextPath}/cart">
                                Cart (${not empty sessionScope.cart ? sessionScope.cart.itemCount : 0})
                            </a></li>
                    </ul>
                </nav>
            </header>

            <main>
                <div class="product-grid">
                    <c:if test="${empty products}">
                        <div class="no-products">
                            <p>No products available or products not loaded properly.</p>
                            <p>Try accessing via <a href="${pageContext.request.contextPath}/products">Products Servlet</a></p>
                        </div>
                    </c:if>

                    <c:forEach items="${products}" var="product">
                        <!-- Your existing product card code -->
                    </c:forEach>
                </div>
            </main>

            <footer>
                <p>© 2025 PocketGadget. All rights reserved.</p>
            </footer>
        </div>
    </body>
</html>