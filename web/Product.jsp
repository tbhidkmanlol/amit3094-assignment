<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List, model.Product"%>
<!DOCTYPE html>
<html class="dark-theme">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <title>Product List - PocketGadget</title>
        <link rel="stylesheet" href="Product.css">
        <link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@500&display=swap" rel="stylesheet">
        <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
        <script src="theme.js" defer></script>
    </head>
    <body>
        <!-- Header Section with theme-specific data attribute -->
        <header class="header" data-theme-target="header">
            <div class="left-section">
                <div class="logo">
                    <img src="Images/logo.png" alt="Logo" />
                </div>
                <div class="brand">
                    <h1>PocketGadget</h1>
                </div>
            </div>

            <nav class="navbar">
                <ul>
                    <li><a href="CartController">Products</a></li>
                    <li><a href="cart.jsp">Cart</a></li>
                    <li><a href="#">About Us</a></li>
                    <li><a href="#">Contact Us</a></li>
                    <li><a href="#">Login / Register</a></li>
                    <li><a href="#">Account</a></li>
                    <li><a href="#"><i class="bx bx-search"></i></a></li>
                    <li>
                        <button id="theme-toggle" class="theme-toggle">
                            <i class="bx bx-moon"></i>
                            <span class="theme-text">Light Mode</span>
                        </button>
                    </li>
                </ul>
            </nav>
        </header>

        <div class="content-container">
            <div class="product-header">
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
        
        <!-- FOOTER -->
        <div class="footer">
          <div class="contain">
            <div class="col">
              <h1>Company</h1>
              <ul>
                <li>About</li>
                <li>Mission</li>
                <li>Services</li>
                <li>Social</li>
                <li>Get in touch</li>
              </ul>
            </div>
            <div class="col">
              <h1>Products</h1>
              <ul>
                <li>About</li>
                <li>Mission</li>
                <li>Services</li>
                <li>Social</li>
                <li>Get in touch</li>
              </ul>
            </div>
            <div class="col">
              <h1>Accounts</h1>
              <ul>
                <li>About</li>
                <li>Mission</li>
                <li>Services</li>
                <li>Social</li>
                <li>Get in touch</li>
              </ul>
            </div>
            <div class="col">
              <h1>Resources</h1>
              <ul>
                <li>Webmail</li>
                <li>Redeem code</li>
                <li>WHOIS lookup</li>
                <li>Site map</li>
                <li>Web templates</li>
                <li>Email templates</li>
              </ul>
            </div>
            <div class="col">
              <h1>Support</h1>
              <ul>
                <li>Contact us</li>
              </ul>
            </div>
            <div class="col social">
              <h1>Social</h1>
              <ul>
                <li>
                  <a href="https://www.instagram.com/">
                    <img src="Images/IG.png" width="32" style="width: 25px; border-radius: 40%;">
                  </a>
                </li>       
                <li>
                  <a href="https://www.facebook.com/">
                    <img src="Images/FB.png" width="32" style="width: 25px; border-radius: 40%;">
                  </a>
                </li>
              </ul>
            </div>
            <div class="clearfix"></div>
            <footer>
              <p>&copy;2025 PocketGadget. All rights reserved.</p>
            </footer>
          </div>
        </div>
    </body>
</html>
