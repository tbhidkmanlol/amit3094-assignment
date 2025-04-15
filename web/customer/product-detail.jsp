<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>PocketGadget</title>
        <link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@500&display=swap" rel="stylesheet">
        <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
        <link rel="stylesheet" href="../home.css" />
        <link rel="stylesheet" href="styles.css">
    </head>
    <body>
        <div class="container">
            <header>
                <div class="left-section">
                    <div class="logo">
                        <img src="logo.png" alt="Logo" />
                    </div>
                    <div class="brand">
                        <h1>PocketGadget</h1>
                    </div>
                </div>
                <div class="header-right">
                    <div class="search-box">
                        <form action="${pageContext.request.contextPath}/products" method="get">
                            <input type="hidden" name="action" value="search">
                            <input type="text" name="keyword" placeholder="Search products...">
                            <button type="submit">Search</button>
                        </form>
                    </div>
                    <div class="cart-icon">
                        <a href="${pageContext.request.contextPath}/cart">
                            <img src="${pageContext.request.contextPath}/images/cart-icon.png" alt="Cart">
                            <span class="cart-count">
                                <c:out value="${sessionScope.cart.itemCount}" default="0"/>
                            </span>
                        </a>
                    </div>
                </div>
            </header>

            <main>
                <div class="product-detail">
                    <div class="product-detail-left">
                        <div class="product-detail-image">
                            <img src="${pageContext.request.contextPath}/${product.imageUrl}" alt="${product.name}">
                        </div>
                    </div>

                    <div class="product-detail-right">
                        <h2>${product.name}</h2>
                        <p class="product-id">Product ID: ${product.id}</p>
                        <p class="product-detail-price">$<fmt:formatNumber value="${product.price}" pattern="#,##0.00"/></p>

                        <div class="product-description">
                            <h3>Description</h3>
                            <p>${product.description}</p>
                        </div>

                        <div class="product-stock">
                            <c:choose>
                                <c:when test="${product.stockQuantity > 0}">
                                    <p class="in-stock">In Stock (${product.stockQuantity} available)</p>
                                </c:when>
                                <c:otherwise>
                                    <p class="out-of-stock">Out of Stock</p>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="product-actions">
                            <form action="${pageContext.request.contextPath}/cart" method="post">
                                <input type="hidden" name="action" value="add">
                                <input type="hidden" name="productId" value="${product.id}">

                                <div class="quantity-selector">
                                    <label for="quantity">Quantity:</label>
                                    <input type="number" id="quantity" name="quantity" value="1" min="1" max="${product.stockQuantity}">
                                </div>

                                <button type="submit" class="add-to-cart-btn" ${product.stockQuantity <= 0 ? 'disabled' : ''}>
                                    Add to Cart
                                </button>
                            </form>
                        </div>
                    </div>
                </div>

                <div class="back-to-products">
                    <a href="${pageContext.request.contextPath}/products">Back to Products</a>
                </div>
            </main>

            <footer>
                <p>&copy; 2025 Tech Gadgets & Accessories. All rights reserved.</p>
            </footer>
        </div>
    </body>
</html>