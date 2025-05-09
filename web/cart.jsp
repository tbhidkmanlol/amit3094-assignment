<%@ page import="java.util.*, model.Product, dao.ProductDAO, model.CartItem" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%

    List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
    if (cart == null) {
        cart = new ArrayList<>();
    }
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>My Shopping Cart</title>
        <link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@500&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <link rel="stylesheet" href="cart.css">
    </head>
    <% if (session.getAttribute("error") != null) { %>
    <div class="error-message">
        <%= session.getAttribute("error") %>
    </div>
    <% session.removeAttribute("error"); %>
<% } %>

    <body>
        <!-- Theme Toggle Button -->
        <button class="theme-toggle" id="theme-toggle" title="Toggle light/dark mode">
            <i class="fas fa-moon"></i>
        </button>
        
        <div class="container">
            <div class="header">
                <h1><i class="fas fa-shopping-cart"></i> Shopping Cart</h1>
                <a href="CartController" class="back-btn">
                    <i class="fas fa-arrow-left"></i> Back to Products
                </a>
            </div>

            <% if (cart.isEmpty()) { %>
            <div class="cart-empty">
                <i class="fas fa-shopping-cart"></i>
                <h2>Your cart is empty</h2>
                <p>Looks like you haven't added any items to your cart yet.</p>
                <a href="CartController" class="back-btn">
                    <i class="fas fa-arrow-left"></i> Continue Shopping
                </a>
            </div>
            <% } else { %>
            <table class="cart-table">
                <thead>
                    <tr>
                        <th>Product</th>
                        <th>Price</th>
                        <th>Quantity</th>
                        <th>Available</th> 
                        <th>Subtotal</th>
                    </tr>
                </thead>
                <tbody>
    <% 
    double total = 0;
    for (CartItem item : cart) { 
        double subtotal = item.getProduct().getPrice() * item.getQuantity();
        total += subtotal;
    %>
    <tr data-product-id="<%= item.getProduct().getId() %>">
        <td data-label="Product">
            <div class="product-cell">
                <img src="<%= request.getContextPath() + "/" + item.getProduct().getImage() %>" 
                     alt="<%= item.getProduct().getName() %>" class="product-img">
                <span class="product-name"><%= item.getProduct().getName() %></span>
            </div>
        </td>
        <td data-label="Price">RM <%= String.format("%.2f", item.getProduct().getPrice()) %></td>
        <td data-label="Quantity">
            <div class="quantity-control">
    <button class="quantity-btn minus-btn">-</button>
    <input type="number" class="quantity-input" 
           value="<%= item.getQuantity() %>" 
           min="1" 
           max="<%= ProductDAO.getProductById(item.getProduct().getId()).getQuantity() + item.getQuantity() %>">
    <button class="quantity-btn plus-btn">+</button>
    <button class="remove-btn" title="Remove item">
        <i class="fas fa-trash-alt"></i>
    </button>
</div>
        </td>
        <td data-label="Available">
    <span class="available-quantity"><%= ProductDAO.getProductById(item.getProduct().getId()).getQuantity() %></span>
</td>
        <td data-label="Subtotal">RM <%= String.format("%.2f", subtotal) %></td>
    </tr>
    <% } %>
</tbody>
            </table>

            <div class="cart-summary">
                <div class="summary-card">
                    <div class="summary-row">
                        <span>Subtotal:</span>
                        <span id="cart-subtotal">RM <%= String.format("%.2f", total) %></span>
                    </div>
                    <div class="summary-row">
                        <span>Shipping:</span>
                        <span>Free</span>
                    </div>
                    <div class="summary-row summary-total">
                        <span>Total:</span>
                        <span id="cart-total">RM <%= String.format("%.2f", total) %></span>
                    </div>
                        <a href="CheckoutServlet" class="checkout-btn">
                        Proceed to Checkout <i class="fas fa-arrow-right"></i>
                        </a>
                </div>
            </div>
            <% } %>
        </div>

        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script>
            $(document).ready(function () {
                // Theme toggle functionality
                const themeToggle = document.getElementById('theme-toggle');
                const themeIcon = themeToggle.querySelector('i');
                
                // Check if user has a previously saved theme preference
                const savedTheme = localStorage.getItem('theme');
                if (savedTheme === 'dark') {
                    document.documentElement.classList.add('dark-theme');
                    themeIcon.className = 'fas fa-sun';
                } else if (savedTheme === 'light') {
                    document.documentElement.classList.add('light-theme');
                    themeIcon.className = 'fas fa-moon';
                }
                
                // Theme toggle click handler
                themeToggle.addEventListener('click', function() {
                    document.documentElement.classList.toggle('dark-theme');
                    document.documentElement.classList.toggle('light-theme');
                    
                    // Update button icon
                    if (document.documentElement.classList.contains('dark-theme')) {
                        themeIcon.className = 'fas fa-sun';
                        localStorage.setItem('theme', 'dark');
                    } else {
                        themeIcon.className = 'fas fa-moon';
                        localStorage.setItem('theme', 'light');
                    }
                });
                
                // Function to update total price
                function updateTotal() {
                    let subtotal = 0;
                    $('tbody tr').each(function () {
                        const price = parseFloat($(this).find('td[data-label="Price"]').text().replace('RM ', ''));
                        const quantity = parseInt($(this).find('.quantity-input').val());
                        const rowSubtotal = price * quantity;
                        $(this).find('td[data-label="Subtotal"]').text('RM ' + rowSubtotal.toFixed(2));
                        subtotal += rowSubtotal;
                    });

                    $('#cart-subtotal').text('RM ' + subtotal.toFixed(2));
                    $('#cart-total').text('RM ' + subtotal.toFixed(2));
                }

                // Quantity increase/decrease buttons
                $('.quantity-btn').click(function () {
    const input = $(this).siblings('.quantity-input');
    let value = parseInt(input.val());
    const max = parseInt(input.attr('max'));
    const availableSpan = $(this).closest('tr').find('.available-quantity');
    const currentAvailable = parseInt(availableSpan.text());
    
    if ($(this).hasClass('plus-btn')) {
        if (value < max) {
            input.val(value + 1);
            availableSpan.text(currentAvailable - 1);
        } else {
            alert(`Only ${currentAvailable} items available in stock`);
            return;
        }
    } else if ($(this).hasClass('minus-btn') && value > 1) {
        input.val(value - 1);
        availableSpan.text(currentAvailable + 1);
    }
    
    updateTotal();
    updateCartOnServer($(this).closest('tr').data('product-id'), input.val());
});

$('.quantity-input').on('change', function() {
    const max = parseInt($(this).attr('max'));
    const value = parseInt($(this).val());
    const availableSpan = $(this).closest('tr').find('.available-quantity');
    const currentAvailable = parseInt(availableSpan.text());
    const oldValue = parseInt($(this).data('old-value') || value);
    
    if (value > max) {
        alert(`Cannot order more than ${max} items`);
        $(this).val(max);
        return;
    }
    
    // Update available inventory display
    const diff = oldValue - value;
    availableSpan.text(currentAvailable + diff);
    
    // Save current value as old value for next time
    $(this).data('old-value', value);
    
    updateTotal();
    updateCartOnServer($(this).closest('tr').data('product-id'), value);
});

                // Delete item
                // Modify delete button event handler
                $('.remove-btn').click(function (e) {
    e.preventDefault();
    const row = $(this).closest('tr');
    const productId = row.data('product-id');
    
    if (confirm('Are you sure you want to remove this item?')) {
        $(this).html('<i class="fas fa-spinner fa-spin"></i>');
        
        $.post('RemoveFromCartController', {
            productId: productId
        }, function(response) {
            if (response.status === 'success') {
                row.fadeOut(300, function() {
                    $(this).remove();
                    updateTotal();
                    
                    // Check if cart is empty after removing item
                    if ($('tbody tr').length === 0) {
                        window.location.reload(); // Reload to show empty cart message
                    }
                });
            } else {
                alert('Error removing item');
                $(this).html('<i class="fas fa-trash-alt"></i>');
            }
        }, 'json').fail(function() {
            alert('Network error');
            $(this).html('<i class="fas fa-trash-alt"></i>');
        });
    }
});

                // Update cart on server
                function updateCartOnServer(productId, quantity) {
                    $.post('UpdateCartController', {
                        productId: productId,
                        quantity: quantity
                    }).fail(function () {
                        alert('Failed to update cart. Please refresh the page.');
                    });
                }

                // Remove item from server
                function removeFromCartOnServer(productId, callback) {
                    $.post('RemoveFromCartController', {
                        productId: productId
                    }).done(callback).fail(function () {
                        alert('Failed to remove item. Please refresh the page.');
                    });
                }

                // Initialize total price
                updateTotal();
            });
        </script>
    </body>
</html>