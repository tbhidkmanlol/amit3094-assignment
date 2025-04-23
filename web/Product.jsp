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
        <header class="header" data-theme-target="header">
            <div class="left-section">
              <div class="logo">
                <a href="home.jsp" style="display: block;">
                  <img src="Images/logo.png" alt="Logo" />
                </a>
              </div>
              <div class="brand">
                <h1><a href="home.jsp" style="text-decoration: none; color: inherit;">PocketGadget</a></h1>
              </div>
            </div>
        
            <nav class="navbar">
              <ul>
                <li><a href="CartController">Products</a></li>
                <li><a href="cart.jsp" style="position: relative;">Cart
                        <% 
                            // Only show cart badge for regular users who are logged in
                            if (session.getAttribute("user") != null && "USER".equals(session.getAttribute("role"))) { 
                                Integer navCartCount = (Integer) session.getAttribute("cartCount");
                                if (navCartCount != null && navCartCount > 0) { 
                        %>
                            <span class="cart-badge"><%= navCartCount %></span>
                        <% 
                                }
                            } 
                        %>
                    </a>
                </li>
                <li><a href="#">About Us</a></li>
                <li><a href="#">Contact Us</a></li>
                
                <!-- Account Dropdown - Changes based on login status -->
                <li class="account-dropdown">
                  <% if (session.getAttribute("user") != null) { 
                       String username = (String)session.getAttribute("username");
                       String role = (String)session.getAttribute("role");
                  %>
                    <a href="#" class="dropdown-trigger">
                      <i class="bx bx-user-circle"></i> Welcome, <%= username %> <i class="bx bx-chevron-down"></i>
                    </a>
                    <div class="dropdown-content">
                      <% if ("ADMIN".equals(role)) { %>
                        <a href="home.jsp"><i class="bx bx-home"></i> Home</a>
                        <a href="admin/dashboard.jsp"><i class="bx bx-tachometer"></i> Admin Dashboard</a>
                        <a href="admin/dashboard.jsp?section=settings"><i class="bx bx-cog"></i> Settings</a>
                      <% } else if ("MANAGER".equals(role)) { %>
                        <a href="home.jsp"><i class="bx bx-home"></i> Home</a>
                        <a href="manager/dashboard.jsp"><i class="bx bx-tachometer"></i> Manager Dashboard</a>
                        <a href="manager/dashboard.jsp?section=settings"><i class="bx bx-cog"></i> Settings</a>
                      <% } else { %>
                        <a href="home.jsp"><i class="bx bx-home"></i> Home</a>
                        <a href="customer/dashboard.jsp"><i class="bx bx-user"></i> My Account</a>
                        <a href="#"><i class="bx bx-package"></i> My Orders</a>
                        <a href="customer/dashboard.jsp?section=settings"><i class="bx bx-cog"></i> Settings</a>
                      <% } %>
                      <a href="auth/logout" class="logout-link"><i class="bx bx-log-out"></i> Sign Out</a>
                    </div>
                  <% } else { %>
                    <a href="#" class="dropdown-trigger">
                      <i class="bx bx-user"></i> Account <i class="bx bx-chevron-down"></i>
                    </a>
                    <div class="dropdown-content">
                      <a href="login.jsp"><i class="bx bx-log-in"></i> Login</a>
                      <a href="login.jsp#register"><i class="bx bx-user-plus"></i> Register</a>
                    </div>
                  <% } %>
                </li>
                
                <li><a href="#"><i class="bx bx-search"></i></a></li>
                <li>
                  <button id="theme-toggle" class="theme-toggle">
                    <i class="bx bx-moon"></i>
                    <span class="theme-text">Switch Theme</span>
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
                        <button type="submit" class="search-btn">
                            <i class="fas fa-search"></i> Search
                        </button>
                    </form>
                </div>
                <a href="cart.jsp" class="cart-link">
                    <i class="fas fa-shopping-cart"></i>
                    <% 
                        Integer cartCount = (Integer) session.getAttribute("cartCount");
                        if (cartCount != null && cartCount > 0) { 
                    %>
                        <span class="cart-badge"><%= cartCount %></span>
                    <% } %>
                </a>
            </div>

            <% if (request.getParameter("searchTerm") != null && !request.getParameter("searchTerm").isEmpty()) {%>
            <div class="search-results-message">
                Showing results for: "<%= request.getParameter("searchTerm")%>"
                <a href="CartController" class="clear-search">(Clear search)</a>
            </div>
            <% }%>

            <!-- Category Filter Section -->
            <div class="category-filter">
                <h3>Categories</h3>
                <div class="category-list">
                    <a href="CartController" class="category-item <%= request.getParameter("category") == null ? "active" : ""%>">All Products</a>
                    <%
                        List<String> categories = (List<String>) request.getAttribute("categories");
                        if (categories != null) {
                            for (String category : categories) {
                                boolean isActive = category.equals(request.getParameter("category"));
                    %>
                    <a href="CartController?category=<%= category%>" 
                       class="category-item <%= isActive ? "active" : ""%>"><%= category%></a>
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
                    <a href="CartController?sortBy=priceAsc<%= categoryParam%>" 
                       class="sort-option <%= "priceAsc".equals(selectedSort) ? "active" : ""%>">Price: Low to High</a>
                    <a href="CartController?sortBy=priceDesc<%= categoryParam%>" 
                       class="sort-option <%= "priceDesc".equals(selectedSort) ? "active" : ""%>">Price: High to Low</a>
                    <a href="CartController?sortBy=nameAsc<%= categoryParam%>" 
                       class="sort-option <%= "nameAsc".equals(selectedSort) ? "active" : ""%>">Name: A to Z</a>
                    <a href="CartController?sortBy=nameDesc<%= categoryParam%>" 
                       class="sort-option <%= "nameDesc".equals(selectedSort) ? "active" : ""%>">Name: Z to A</a>
                </div>
            </div>

            <%
                List<Product> products = (List<Product>) request.getAttribute("products");

                // Show current category if selected
                String categoryTitle = request.getParameter("category");
                if (categoryTitle != null && !categoryTitle.isEmpty()) {
            %>
            <div class="category-title">
                <h2><%= categoryTitle%></h2>
            </div>
            <% } %>

            <% if (products != null && !products.isEmpty()) { %>
            <div class="product-grid">
                <% for (Product p : products) {%>
                <div class="product-card">
                    <a href="ProductDetails.jsp?id=<%= p.getId()%>" class="product-link">
                        <div class="product-image-container">
                            <img src="<%= request.getContextPath() + "/" + p.getImage()%>" 
                                 alt="<%= p.getName()%>" class="product-image">
                            <!-- New overlay description that shows on hover -->
                            <div class="image-overlay">
                                <div class="overlay-content">
                                    <div class="overlay-title"><%= p.getName()%></div>
                                    <%= p.getDescription()%>
                                </div>
                            </div>
                        </div>
                        <div class="product-info">
                            <h3 class="product-title"><%= p.getName()%></h3>
                            <div class="product-price">RM <%= String.format("%.2f", p.getPrice())%></div>
                            <div class="product-quantity">Available: <%= p.getQuantity()%></div>
                        </div>
                    </a>
                    <div class="product-actions">
                        <form method="post" action="add-to-cart">
                            <input type="hidden" name="productId" value="<%= p.getId()%>">
                            <input type="number" name="quantity" min="1" max="<%= p.getQuantity()%>" 
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
            <% }%>
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

        <!-- JavaScript for product description modals -->
        <script>
            // Put all product descriptions in a single global variable
            const productDescriptions = {};
            
            <% if (products != null && !products.isEmpty()) {
                for (Product p : products) { %>
                    // Store each product description separately
                    productDescriptions['<%= p.getId() %>'] = {
                        id: '<%= p.getId() %>',
                        name: '<%= p.getName() %>',
                        description: '<%= p.getDescription().replace("'", "\\'").replace("\n", " ") %>'
                    };
            <% } 
            } %>
            
            // Setup modal once on page load
            document.addEventListener('DOMContentLoaded', function() {
                // Create a single modal for all products
                const modalTemplate = `
                    <div id="product-description-modal" class="product-description-modal" style="display:none">
                        <div class="description-content">
                            <h3 id="modal-title" class="description-title"></h3>
                            <div id="modal-text" class="description-text"></div>
                            <button id="close-modal" class="close-description">
                                <i class="fas fa-times"></i>
                            </button>
                        </div>
                    </div>
                `;
                
                // Add modal to body
                document.body.insertAdjacentHTML('beforeend', modalTemplate);
                
                // Get modal elements
                const modal = document.getElementById('product-description-modal');
                const modalTitle = document.getElementById('modal-title');
                const modalText = document.getElementById('modal-text');
                const closeBtn = document.getElementById('close-modal');
                
                // Setup click handlers for all description buttons
                document.querySelectorAll('.description-btn').forEach(btn => {
                    btn.addEventListener('click', function(e) {
                        e.preventDefault();
                        e.stopPropagation();
                        
                        const productId = this.getAttribute('data-product-id');
                        const product = productDescriptions[productId];
                        
                        if (product) {
                            // Populate and show modal
                            modalTitle.textContent = product.name;
                            modalText.textContent = product.description;
                            modal.style.display = 'flex';
                            document.body.style.overflow = 'hidden';
                        }
                    });
                });
                
                // Close modal on button click
                closeBtn.addEventListener('click', function() {
                    modal.style.display = 'none';
                    document.body.style.overflow = '';
                });
                
                // Close modal when clicking outside content
                modal.addEventListener('click', function(e) {
                    if (e.target === modal) {
                        modal.style.display = 'none';
                        document.body.style.overflow = '';
                    }
                });
                
                // Close modal with Escape key
                document.addEventListener('keydown', function(e) {
                    if (e.key === 'Escape' && modal.style.display === 'flex') {
                        modal.style.display = 'none';
                        document.body.style.overflow = '';
                    }
                });
            });
        </script>
    </body>
</html>
