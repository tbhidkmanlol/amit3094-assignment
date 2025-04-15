<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Shopping Cart - Tech Gadgets & Accessories</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
    </head>
    <body>
        <div class="container">
            <header>
                <h1>Tech Gadgets & Accessories</h1>
                <div class="header-right">
                    <div class="search-box">
                        <form action="${pageContext.request.contextPath}/products" method="get">
                            <input type="hidden" name="action" value="search">
                            <input type="text" name="keyword" placeholder="Search products...">
                            <button type="submit">Search</button>
                        </form>
                    </div>
                </div>
            </header>

            <main>
                <h2>Shopping Cart</h2>

                <c:choose>
                    <c:when test="${empty sessionScope.cart.items}">
                        <div class="empty-cart">
                            <p>Your cart is empty.</p>
                            <a href="${pageContext.request.contextPath}/products" class="continue-shopping">Continue Shopping</a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="cart-contents">
                            <table class="cart-table">
                                <thead>
                                    <tr>
                                        <th>Product</th>
                                        <th>Price</th>
                                        <th>Quantity</th>
                                        <th>Subtotal</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="item" items="${sessionScope.cart.items}">
                                        <tr>
                                            <td class="product-cell">
                                                <div class="cart-product-info">
                                                    <img src="${pageContext.request.contextPath}/${item.product.imageUrl}" alt="${item.product.name}">
                                                    <div>
                                                        <h4>${item.product.name}</h4>
                                                        <p>Product ID: ${item.product.id}</p>
                                                    </div>
                                            </td>
                                            <td class="price-cell">
                                                $<fmt:formatNumber value="${item.product.price}" pattern="#,##0.00"/>
                                            </td>
                                            <td class="quantity-cell">
                                                <form action="${pageContext.request.contextPath}/cart" method="post" class="update-quantity-form">
                                                    <input type="hidden" name="action" value="update">
                                                    <input type="hidden" name="productId" value="${item.product.id}">
                                                    <input type="number" name="quantity" value="${item.quantity}" min="1" max="${item.product.stockQuantity}" onchange="this.form.submit()">
                                                </form>
                                            </td>
                                            <td class="subtotal-cell">
                                                $<fmt:formatNumber value="${item.subtotal}" pattern="#,##0.00"/>
                                            </td>
                                            <td class="actions-cell">
                                                <form action="${pageContext.request.contextPath}/cart" method="post">
                                                    <input type="hidden" name="action" value="remove">
                                                    <input type="hidden" name="productId" value="${item.product.id}">
                                                    <button type="submit" class="remove-btn">Remove</button>
                                                </form>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>

                            <div class="cart-summary">
                                <div class="cart-totals">
                                    <div class="total-row">
                                        <span>Subtotal:</span>
                                        <span>$<fmt:formatNumber value="${sessionScope.cart.subtotal}" pattern="#,##0.00"/></span>
                                    </div>
                                    <div class="total-row">
                                        <span>Sales Tax (7%):</span>
                                        <span>$<fmt:formatNumber value="${sessionScope.cart.tax}" pattern="#,##0.00"/></span>
                                    </div>
                                    <div class="total-row">
                                        <span>Shipping:</span>
                                        <c:choose>
                                            <c:when test="${sessionScope.cart.shippingCost > 0}">
                                                <span>$<fmt:formatNumber value="${sessionScope.cart.shippingCost}" pattern="#,##0.00"/></span>
                                            </c:when>
                                            <c:otherwise>
                                                <span>FREE</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="total-row grand-total">
                                        <span>Total:</span>
                                        <span>$<fmt:formatNumber value="${sessionScope.cart.total}" pattern="#,##0.00"/></span>
                                    </div>
                                </div>

                                <div class="cart-actions">
                                    <a href="${pageContext.request.contextPath}/products" class="continue-shopping">Continue Shopping</a>
                                    <button class="checkout-btn">Proceed to Checkout</button>
                                </div>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </main>

            <footer>
                <p>&copy; 2025 PocketGadget. All rights reserved.</p>
            </footer>
        </div>

        <script>
            // Optional JavaScript for cart functionality
            document.addEventListener('DOMContentLoaded', function () {
                // You can add additional client-side functionality here if needed
            });
        </script>
    </body>
</html>
