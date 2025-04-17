<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Shopping Cart</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
    </head>
    <body>
        <div class="container">
            <header>
                <h1>PocketGadget</h1>
                <nav class="navbar">
                    <ul>
                        <li><a href="${pageContext.request.contextPath}/products">Products</a></li>
                        <li><a href="${pageContext.request.contextPath}/cart">
                                Cart (<c:out value="${not empty sessionScope.cart ? sessionScope.cart.itemCount : 0}"/>)
                            </a></li>
                    </ul>
                </nav>
            </header>

            <main>
                <h2>Your Shopping Cart</h2>

                <c:choose>
                    <c:when test="${empty sessionScope.cart.items}">
                        <div class="empty-cart">
                            <p>Your cart is currently empty.</p>
                            <a href="${pageContext.request.contextPath}/products" class="continue-shopping">
                                Continue Shopping
                            </a>
                        </div>
                    </c:when>

                    <c:otherwise>
                        <div class="cart-items">
                            <table class="cart-table">
                                <thead>
                                    <tr>
                                        <th>Product</th>
                                        <th>Price</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="product" items="${sessionScope.cart.items}">
                                        <tr>
                                            <td class="product-info">
                                                <img src="${pageContext.request.contextPath}/customer/img/${product.image}" 
                                                     alt="${product.name}">
                                                class="cart-product-image">
                                                <div class="product-details">
                                                    <h4>${product.name}</h4>
                                                    <p>ID: ${product.id}</p>
                                                </div>
                                            </td>
                                            <td class="price">
                                                $<fmt:formatNumber value="${product.price}" pattern="#,##0.00"/>
                                            </td>
                                            <td class="actions">
                                                <form action="${pageContext.request.contextPath}/cart" method="post">
                                                    <input type="hidden" name="action" value="remove">
                                                    <input type="hidden" name="productId" value="${product.id}">
                                                    <button type="submit" class="remove-btn">Remove</button>
                                                </form>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>

                            <div class="cart-actions">
                                <a href="${pageContext.request.contextPath}/products" class="continue-shopping">
                                    Continue Shopping
                                </a>
                                <form action="${pageContext.request.contextPath}/checkout" method="post">
                                    <button type="submit" class="checkout-btn">Proceed to Checkout</button>
                                </form>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </main>

            <footer>
                <p>&copy; 2025 PocketGadget. All rights reserved.</p>
            </footer>
        </div>
    </body>
</html>