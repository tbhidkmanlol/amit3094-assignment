<%@ page import="dao.ProductDAO, model.Product, java.util.List" %>
<%
    List<Product> products = ProductDAO.getAllProducts();
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Select a Product to Review</title>
        <link href="ProductSelection.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    </head>

    <body>
        <div class="container">
            <div class="header">
                <div class="headerLeft">
                    <h1 class="page-title">Product Reviews</h1>
                    <p class="page-subtitle">Select a product to view or submit reviews</p>
                </div>
                <div class="headerRight">
                    <a href="CartController" class="back-btn">Back To Product Page</a>
                </div>
            </div>

            <div class="selection-options">
                <div class="option-section">
                    <h2 class="section-title">
                        <i class="fas fa-th-large"></i>
                        Browse Products
                    </h2>
                    <div class="product-grid">
                        <% for (Product product : products) { %>
                        <a href="ProductDetails.jsp?id=<%= product.getId() %>" class="product-card">
                            <div class="product-image-container">
                                <img src="<%= product.getImage() %>" alt="<%= product.getName() %>" class="product-image">
                            </div>
                            <div class="product-info">
                                <h3 class="product-name"><%= product.getName() %></h3>
                                <div class="product-price">RM <%= String.format("%.2f", product.getPrice()) %></div>
                            </div>
                        </a>
                        <% } %>
                    </div>
                </div>

                <div class="option-section">
                    <h2 class="section-title">
                        <i class="fas fa-search"></i>
                        Quick Selection
                    </h2>
                    <form action="ProductDetails.jsp" method="get" class="dropdown-form">
                        <select name="id" class="form-select" required>
                            <option value="">-- Select Product --</option>
                            <% for (Product product : products) { %>
                            <option value="<%= product.getId() %>">
                                <%= product.getName() %> (RM<%= String.format("%.2f", product.getPrice()) %>)
                            </option>
                            <% } %>
                        </select>
                        <button type="submit" class="btn">
                            <i class="fas fa-arrow-right"></i> Go to Reviews
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </body>
</html>