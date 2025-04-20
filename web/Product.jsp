<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List, model.Product"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Product List - Phone Accessories</title>
        <link rel="stylesheet" href="Product.css">
    </head>
    <body>
        <div class="container">
            <div class="header">
                <h1>Our Gadgets</h1>
                <div class="search-container">
                    <form method="get" action="ProductSearchController">
                        <input type="text" name="searchTerm" placeholder="Search by ID or Name...">
                        <button type="submit" class="search-btn">Search</button>
                    </form>
                </div>
                <a href="cart.jsp" class="cart-link">Check Cart</a>
            </div>

            <% if (request.getParameter("searchTerm") != null && !request.getParameter("searchTerm").isEmpty()) { %>
            <div class="search-results-message">
                Showing results for: "<%= request.getParameter("searchTerm") %>"
                <a href="CartController" class="clear-search">(Clear search)</a>
            </div>
            <% } %>
            
            <!-- Category Filter Section -->
            <div class="category-filter">
                <h3>Categories</h3>
                <div class="category-list">
                    <a href="CartController" class="category-item <%= request.getParameter("category") == null ? "active" : "" %>">All Products</a>
                    <% 
                    List<String> categories = (List<String>) request.getAttribute("categories");
                    if (categories != null) {
                        for (String category : categories) {
                            boolean isActive = category.equals(request.getParameter("category"));
                    %>
                    <a href="CartController?category=<%= category %>" 
                       class="category-item <%= isActive ? "active" : "" %>"><%= category %></a>
                    <% 
                        }
                    } 
                    %>
                </div>
                
                <!-- Sort Options -->
                <h3>Sort By</h3>
                <div class="sort-options">
                    <% 
                    String currentCategory = request.getParameter("category");
                    String categoryParam = currentCategory != null ? "&category=" + currentCategory : "";
                    String selectedSort = (String) request.getAttribute("selectedSort");
                    %>
                    <a href="CartController?sortBy=priceAsc<%= categoryParam %>" 
                       class="sort-option <%= "priceAsc".equals(selectedSort) ? "active" : "" %>">Price: Low to High</a>
                    <a href="CartController?sortBy=priceDesc<%= categoryParam %>" 
                       class="sort-option <%= "priceDesc".equals(selectedSort) ? "active" : "" %>">Price: High to Low</a>
                    <a href="CartController?sortBy=nameAsc<%= categoryParam %>" 
                       class="sort-option <%= "nameAsc".equals(selectedSort) ? "active" : "" %>">Name: A to Z</a>
                    <a href="CartController?sortBy=nameDesc<%= categoryParam %>" 
                       class="sort-option <%= "nameDesc".equals(selectedSort) ? "active" : "" %>">Name: Z to A</a>
                </div>
            </div>

            <% 
            // 从请求中获取传递的产品列表
            List<Product> products = (List<Product>) request.getAttribute("products");
            
            // Show current category if selected
            String categoryTitle = request.getParameter("category");
            if (categoryTitle != null && !categoryTitle.isEmpty()) {
            %>
                <div class="category-title">
                    <h2><%= categoryTitle %></h2>
                </div>
            <% } %>
        
            <% if (products != null && !products.isEmpty()) { %>
            <div class="product-grid">
                <% for (Product p : products) { %>
                <div class="product-card">
                    <img src="<%= request.getContextPath() + "/" + p.getImage() %>" 
                         alt="<%= p.getName() %>" class="product-image">
                    <div class="product-info">
                        <h3 class="product-title"><%= p.getName() %></h3>
                        <div class="product-price">RM <%= String.format("%.2f", p.getPrice()) %></div>
                        <div class="product-quantity">Available: <%= p.getQuantity() %></div>
                        <div class="product-description"><%= p.getDescription() %></div>
                        <form method="post" action="add-to-cart">
                            <input type="hidden" name="productId" value="<%= p.getId() %>">
                            <input type="number" name="quantity" min="1" max="<%= p.getQuantity() %>" 
                                   value="1" class="quantity-input">
                            <button type="submit" class="add-to-cart">Add to Cart</button>
                        </form>
                    </div>
                </div>
                <% } %>
            </div>
            <% } else { %>
            <div class="empty-message">
                <p>No product information</p>
                <p>Please try again or contact the administrator</p>
            </div>
            <% } %>
        </div>
    </body>
</html>
