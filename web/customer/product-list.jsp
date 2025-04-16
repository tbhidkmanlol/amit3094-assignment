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

<main>
    <c:if test="${not empty errorMessage}">
        <div class="error-message">${errorMessage}</div>
    </c:if>

    <div class="product-grid">
        <c:forEach var="product" items="${products}">
            <div class="product-card">
                <div class="product-image">
                    <img src="${pageContext.request.contextPath}/${product.imageUrl}" alt="${product.name}">
                </div>
                <div class="product-info">
                    <h3>${product.name}</h3>
                    <p class="product-price">$<fmt:formatNumber value="${product.price}" pattern="#,##0.00"/></p>
                    <a href="${pageContext.request.contextPath}/products?action=view&id=${product.id}">View Details</a>
                </div>
                <div class="product-actions">
                    <form action="${pageContext.request.contextPath}/cart" method="post">
                        <input type="hidden" name="action" value="add">
                        <input type="hidden" name="productId" value="${product.id}">
                        <button type="submit" class="add-to-cart-btn" ${product.stockQuantity <= 0 ? 'disabled' : ''}>
                            Add to Cart
                        </button>
                    </form>
                </div>
            </div>
        </c:forEach>
        <c:if test="${empty products}">
            <div class="no-products">No products found.</div>
        </c:if>
    </div>
</main>
<footer>
    <p>© 2025 PocketGadget. All rights reserved.</p>
</footer>

</body>
</html>
