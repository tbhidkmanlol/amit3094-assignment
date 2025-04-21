<%@ page import="dao.ReviewDAO, dao.ProductDAO, model.Review, model.Product, java.util.List" %>
<%
    // Authentication check
    Object userObj = session.getAttribute("user");
    model.User user = (userObj != null) ? (model.User)userObj : null;
    
    if (user == null || !"ADMIN".equalsIgnoreCase(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    List<Review> reviews = ReviewDAO.getAllReviews();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin - Product Reviews</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="AdminReviews.css" rel="stylesheet">
</head>
<body>
    <div class="admin-container">
        <div class="admin-header">
            <h1 class="page-title">
                <i class="fas fa-comments"></i> Product Reviews
            </h1>
            <span class="review-count">
                <%= reviews.size() %> <%= reviews.size() == 1 ? "Review" : "Reviews" %>
            </span>
        </div>
        
        <% if (request.getParameter("replySuccess") != null) { %>
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i> Reply submitted successfully!
            </div>
        <% } else if (request.getParameter("replyError") != null) { %>
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle"></i> Error submitting reply. Please try again.
            </div>
        <% } %>
        
        <table class="reviews-table">
            <thead>
                <tr>
                    <th>Product</th>
                    <th>Customer</th>
                    <th>Rating</th>
                    <th>Comment</th>
                    <th>Date</th>
                    <th>Admin Reply</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <% for (Review review : reviews) { 
                    Product product = ProductDAO.getProductById(review.getProductId());
                %>
                    <tr>
                        <td class="product-cell">
                            <%= product.getName() %>
                        </td>
                        <td>
                            <div class="customer-cell">
                                <div class="customer-avatar">
                                    <%= review.getCustomerName().charAt(0) %>
                                </div>
                                <%= review.getCustomerName() %>
                            </div>
                        </td>
                        <td class="rating-cell">
                            <% for (int i = 1; i <= 5; i++) { %>
                                <i class="fas fa-star<%= i > review.getRating() ? "-empty" : "" %>"></i>
                            <% } %>
                            <span>(<%= review.getRating() %>)</span>
                        </td>
                        <td class="comment-cell">
                            <%= review.getComment() %>
                        </td>
                        <td class="date-cell">
                            <%= review.getReviewDate() %>
                        </td>
                        <td class="reply-cell">
                            <% if (review.getAdminReply() != null) { %>
                                <div class="existing-reply">
                                    <div class="admin-reply">
                                        <strong><i class="fas fa-shield-alt"></i> Admin:</strong> 
                                        <%= review.getAdminReply() %>
                                    </div>
                                    <div class="reply-date">
                                        Replied on <%= review.getReplyDate() %>
                                    </div>
                                </div>
                            <% } else { %>
                                <div class="no-replies">
                                    No reply yet
                                </div>
                            <% } %>
                        </td>
                        <td>
                            <form class="reply-form" action="AdminReviews" method="post">
                                <input type="hidden" name="reviewId" value="<%= review.getReviewId() %>">
                                <textarea 
                                    class="reply-textarea" 
                                    name="reply" 
                                    placeholder="Type your reply here..."
                                    required></textarea>
                                <button type="submit" class="reply-submit">
                                    <i class="fas fa-paper-plane"></i> Send Reply
                                </button>
                            </form>
                        </td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</body>
</html>