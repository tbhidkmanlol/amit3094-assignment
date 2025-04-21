<%@ page import="dao.ProductDAO, dao.ReviewDAO, model.Product, model.Review, java.util.List" %>
<%
    int productId = Integer.parseInt(request.getParameter("id"));
    Product product = ProductDAO.getProductById(productId);
    List<Review> reviews = ReviewDAO.getReviewsByProduct(productId);
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title><%= product.getName() %> - Reviews</title>
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <link href="ProductDetails.css" rel="stylesheet">
    </head>
    <body>

        <div class="container">
            <div class="header">
                <div class="headerLeft">
                    <h1 class="page-title">Rating and Comments</h1>
                    <p class="page-subtitle">Please leave a comment to let us know - we'll respond shortly</p>
                </div>
                <div class="headerRight">
                    <a href="CartController" class="back-btn">Back To Product Page</a>
                </div>
            </div>

            <div class="product-header">
                <img src="<%= product.getImage() %>" alt="<%= product.getName() %>" class="product-image">
                <div class="product-info">
                    <h1 class="product-title"><%= product.getName() %></h1>
                    <div class="product-price">RM <%= String.format("%.2f", product.getPrice()) %></div>
                    <p class="product-description"><%= product.getDescription() %></p>
                    <div class="product-stock">Available: <%= product.getQuantity() %> in stock</div>
                </div>
            </div>

            <h2 class="section-title">Customer Reviews</h2>

            <div class="reviews-container">
                <% if (reviews.isEmpty()) { %>
                <div class="no-reviews">
                    <i class="far fa-comment-dots" style="font-size: 48px; margin-bottom: 15px; opacity: 0.3;"></i>
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
                                <input type="radio" id="star5" name="rating" value="5" required>
                                <label for="star5"><i class="fas fa-star"></i></label>
                                <input type="radio" id="star4" name="rating" value="4">
                                <label for="star4"><i class="fas fa-star"></i></label>
                                <input type="radio" id="star3" name="rating" value="3">
                                <label for="star3"><i class="fas fa-star"></i></label>
                                <input type="radio" id="star2" name="rating" value="2">
                                <label for="star2"><i class="fas fa-star"></i></label>
                                <input type="radio" id="star1" name="rating" value="1">
                                <label for="star1"><i class="fas fa-star"></i></label>
                            </div>
                            <span id="rating-value">Select rating</span>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="comment" class="form-label">Your Review</label>
                        <textarea id="comment" name="comment" class="form-control" required placeholder="Share your thoughts about this product..."></textarea>
                    </div>

                    <button type="submit" class="btn btn-block">
                        <i class="fas fa-paper-plane"></i> Submit Review
                    </button>
                </form>
            </div>

            <a href="CartContrller" class="back-link">
                <i class="fas fa-arrow-left"></i> Back to Products
            </a>
        </div>

        <script>
            // Star rating interaction
            const stars = document.querySelectorAll('.star-rating input');
            const ratingValue = document.getElementById('rating-value');

            stars.forEach(star => {
                star.addEventListener('change', function () {
                    ratingValue.textContent = `${this.value} star${this.value > 1 ? 's' : ''}`;
                            });
                        });

                        // Form validation
                        function validateFo     () {
                            const name = document.getElementById('customerName').value.trim();
                            const rating = document.querySelector('input[name="rating"]:checked');
                            const comment = document.getElementById('comment').value.trim();

                            if (!name || !rating || !comment) {
                                alert('Please fill in all fields');
                                return false;
                            }
                            return true;
                        }
        </script>
    </body>
</html>