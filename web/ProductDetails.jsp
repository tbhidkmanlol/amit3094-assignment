<%@ page import="dao.ProductDAO, dao.ReviewDAO, model.Product, model.Review, java.util.List" %>
<%
    int productId = Integer.parseInt(request.getParameter("id"));
    Product product = ProductDAO.getProductById(productId);
    List<Review> reviews = ReviewDAO.getReviewsByProduct(productId);
%>
<!DOCTYPE html>
<html class="dark-theme">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title><%= product.getName() %> - Product Details</title>
        <link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@500&display=swap" rel="stylesheet">
        <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <link rel="stylesheet" href="Product.css">
        <link rel="stylesheet" href="ProductDetails.css">
        <script src="theme.js" defer></script>
    </head>
    <body>
        <!-- Header Section with theme-specific data attribute -->
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
                <li><a href="AboutUs.jsp">About Us</a></li>
                <li><a href="contactus.jsp">Contact Us</a></li>
                
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
            <div class="breadcrumb">
                <a href="CartController">Products</a> &gt; <%= product.getName() %>
            </div>

            <div class="product-detail-container">
                <div class="product-detail-left">
                    <div class="product-image-container">
                        <img src="<%= product.getImage() %>" alt="<%= product.getName() %>" class="product-detail-image">
                    </div>
                </div>
                
                <div class="product-detail-right">
                    <h1 class="product-detail-title"><%= product.getName() %></h1>
                    <div class="product-detail-price">RM <%= String.format("%.2f", product.getPrice()) %></div>
                    
                    <div class="product-detail-availability">
                        <% if (product.getQuantity() > 10) { %>
                            <span class="availability in-stock">
                                <i class="fas fa-check-circle"></i> In Stock: <%= product.getQuantity() %> available
                            </span>
                        <% } else if (product.getQuantity() > 0) { %>
                            <span class="availability limited-stock">
                                <i class="fas fa-exclamation-circle"></i> Limited Stock: Only <%= product.getQuantity() %> left
                            </span>
                        <% } else { %>
                            <span class="availability out-of-stock">
                                <i class="fas fa-times-circle"></i> Out of Stock
                            </span>
                        <% } %>
                    </div>
                    
                    <div class="product-detail-description">
                        <%= product.getDescription() %>
                    </div>
                    
                    <div class="product-detail-actions">
                        <form method="post" action="add-to-cart" class="cart-form">
                            <input type="hidden" name="productId" value="<%= product.getId() %>">
                            <div class="quantity-control">
                                <button type="button" class="quantity-btn minus-btn" onclick="decreaseQuantity()">
                                    <i class="fas fa-minus"></i>
                                </button>
                                <input type="number" name="quantity" min="1" max="<%= product.getQuantity() %>" 
                                       value="1" class="quantity-input" id="quantity-input">
                                <button type="button" class="quantity-btn plus-btn" onclick="increaseQuantity(<%= product.getQuantity() %>)">
                                    <i class="fas fa-plus"></i>
                                </button>
                            </div>
                            <button type="submit" class="add-to-cart-btn" <%= product.getQuantity() == 0 ? "disabled" : "" %>>
                                <i class="fas fa-shopping-cart"></i> Add to Cart
                            </button>
                        </form>
                    </div>
                </div>
            </div>

            <div class="reviews-section">
                <h2 class="section-title">Customer Reviews</h2>

                <div class="reviews-container">
                    <% if (reviews.isEmpty()) { %>
                    <div class="no-reviews">
                        <i class="far fa-comment-dots"></i>
                        <p>No reviews yet. Be the first to review this product!</p>
                    </div>
                    <% } else { 
                    for (Review review : reviews) { %>
                    <div class="review-card">
                        <div class="review-avatar"><%= review.getCustomerName().charAt(0) %></div>
                        <div class="review-content">
                            <div class="review-header">
                                <div class="review-author"><%= review.getCustomerName() %></div>
                                <div class="review-date"><%= review.getReviewDate() %></div>
                            </div>
                            <div class="review-rating">
                                <% for (int i = 1; i <= 5; i++) { %>
                                <i class="fas fa-star<%= i > review.getRating() ? "-empty" : "" %>"></i>
                                <% } %>
                                <span>(<%= review.getRating() %>/5)</span>
                            </div>
                            <div class="review-text">
                                <%= review.getComment() %>
                            </div>

                            <% if (review.getAdminReply() != null) { %>
                            <div class="admin-reply">
                                <div class="admin-reply-header">
                                    <span class="admin-badge">ADMIN</span>
                                    <span class="review-date"><%= review.getReplyDate() %></span>
                                </div>
                                <p><%= review.getAdminReply() %></p>
                            </div>
                            <% } %>
                        </div>
                    </div>
                    <%   }
                   } %>
                </div>

                <% if (request.getParameter("reviewSuccess") != null) { %>
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i> Thank you! Your review has been submitted.
                </div>
                <% } else if (request.getParameter("reviewError") != null) { %>
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-circle"></i> Error submitting review. Please try again.
                </div>
                <% } %>

                <div class="review-form">
                    <h3 class="section-title">Write a Review</h3>
                    <form action="SubmitReview" method="post" onsubmit="return validateForm()">
                        <input type="hidden" name="productId" value="<%= productId %>">

                        <div class="form-group">
                            <label for="customerName" class="form-label">Your Name</label>
                            <input type="text" id="customerName" name="customerName" class="form-control" required>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Rating</label>
                            <div class="rating-select">
                                <div class="star-rating">
                                    <input type="radio" id="star1" name="rating" value="5" required>
                                    <label for="star1"><i class="fas fa-star"></i></label>
                                    <input type="radio" id="star2" name="rating" value="4">
                                    <label for="star2"><i class="fas fa-star"></i></label>
                                    <input type="radio" id="star3" name="rating" value="3">
                                    <label for="star3"><i class="fas fa-star"></i></label>
                                    <input type="radio" id="star4" name="rating" value="2">
                                    <label for="star4"><i class="fas fa-star"></i></label>
                                    <input type="radio" id="star5" name="rating" value="1">
                                    <label for="star5"><i class="fas fa-star"></i></label>
                                </div>
                                <span id="rating-value">Select rating</span>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="comment" class="form-label">Your Review</label>
                            <textarea id="comment" name="comment" class="form-control" required placeholder="Share your thoughts about this product..."></textarea>
                        </div>

                        <button type="submit" class="submit-review-btn">
                            <i class="fas fa-paper-plane"></i> Submit Review
                        </button>
                    </form>
                </div>
            </div>
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

        <script>
            // Star rating interaction
            const stars = document.querySelectorAll('.star-rating input');
            const ratingValue = document.getElementById('rating-value');

            stars.forEach(star => {
                star.addEventListener('change', function() {
                    ratingValue.textContent = `${this.value} star${this.value > 1 ? 's' : ''}`;
                });
            });

            // Form validation
            function validateForm() {
                const name = document.getElementById('customerName').value.trim();
                const rating = document.querySelector('input[name="rating"]:checked');
                const comment = document.getElementById('comment').value.trim();

                if (!name || !rating || !comment) {
                    alert('Please fill in all fields');
                    return false;
                }
                return true;
            }
            
            // Quantity control functions
            function decreaseQuantity() {
                const input = document.getElementById('quantity-input');
                const currentValue = parseInt(input.value);
                if (currentValue > 1) {
                    input.value = currentValue - 1;
                }
            }
            
            function increaseQuantity(maxQuantity) {
                const input = document.getElementById('quantity-input');
                const currentValue = parseInt(input.value);
                if (currentValue < maxQuantity) {
                    input.value = currentValue + 1;
                }
            }
        </script>
    </body>
</html>