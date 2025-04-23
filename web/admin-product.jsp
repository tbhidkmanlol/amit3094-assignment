<%-- 
    Document   : admin-product
    Created on : Apr 18, 2025, 1:59:10 AM
    Author     : Dell
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="dao.ProductDAO, model.Product, java.util.List, model.User"%>
<!DOCTYPE html>
<html>
<head>
    <title>Product Management</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="admin-product.css">
</head>
<body>
    <%
        // Authentication check
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null || (!("ADMIN".equals(currentUser.getRole()) || "MANAGER".equals(currentUser.getRole())))) {
            response.sendRedirect("login.jsp?error=unauthorized");
            return;
        }
        
        // Determine the return link based on user role
        String returnLink = "ADMIN".equals(currentUser.getRole()) ? "admin/dashboard.jsp" : "manager/dashboard.jsp";
    %>
    <div class="container">
        <div class="header">
            <h1><i class="fas fa-box-open"></i> Product Management</h1>
            <div class="header-actions">
                <a href="<%= returnLink %>" class="btn btn-outline"><i class="fas fa-arrow-left"></i> Back to Dashboard</a>
                <a href="CartController" class="btn"><i class="fas fa-external-link-alt"></i> View Store</a>
            </div>
        </div>
        
        <%-- Display messages --%>
        <% if (session.getAttribute("adminMessage") != null) { %>
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i> <%= session.getAttribute("adminMessage") %>
            </div>
            <% session.removeAttribute("adminMessage"); %>
        <% } %>
        
        <% if (session.getAttribute("adminError") != null) { %>
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle"></i> <%= session.getAttribute("adminError") %>
            </div>
            <% session.removeAttribute("adminError"); %>
        <% } %>
        
        <div class="card">
            <h2 class="card-title"><i class="fas fa-plus-circle"></i> Add New Product</h2>
            <form action="admin/add-product" method="post" enctype="multipart/form-data">
                <div class="form-row">
                    <div class="form-group">
                        <label for="name">Product Name</label>
                        <input type="text" id="name" name="name" required placeholder="Enter product name">
                    </div>
                    
                    <div class="form-group">
                        <label for="price">Price (RM)</label>
                        <input type="number" id="price" name="price" step="0.01" min="0.01" required placeholder="0.00">
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="quantity">Initial Stock Quantity</label>
                        <input type="number" id="quantity" name="quantity" min="0" required placeholder="100">
                    </div>
                    
                    <div class="form-group">
                        <label for="category">Product Category</label>
                        <select id="category" name="category" required>
                            <option value="">Select a category</option>
                            <option value="Phone Case">Phone Case</option>
                            <option value="Cable">Cable</option>
                            <option value="Charger">Charger</option>
                            <option value="Power Bank">Power Bank</option>
                            <option value="Screen Protector">Screen Protector</option>
                            <option value="Earphone">Earphone</option>
                            <option value="Keyboard">Keyboard</option>
                            <option value="Holder">Holder</option>
                            <option value="Extension">Extension</option>
                            <option value="Wallpaper">Wallpaper</option>
                            <option value="Other">Other</option>
                        </select>
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="image">Product Image</label>
                        <div class="file-upload">
                            <input type="file" id="image" name="image" accept="image/*" required>
                            <label for="image" class="file-label"><i class="fas fa-cloud-upload-alt"></i> Choose Image</label>
                        </div>
                        <small>Recommended size: 500x500 pixels</small>
                    </div>
                    
                    <div class="form-group">
                        <label for="customCategory" id="customCategoryLabel" style="display: none;">Custom Category</label>
                        <input type="text" id="customCategory" name="customCategory" placeholder="Enter custom category" style="display: none;">
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="description">Description</label>
                    <textarea id="description" name="description" required placeholder="Enter product description"></textarea>
                </div>
                
                <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Add Product</button>
            </form>
        </div>
        
        <div class="card collapsible">
            <div class="card-header">
                <h2 class="card-title"><i class="fas fa-boxes"></i> Inventory Management</h2>
                <button class="toggle-btn"><i class="fas fa-chevron-down"></i></button>
            </div>
            <div class="card-content">
                <div class="inventory-actions">
                    <div class="inventory-action">
                        <h3><i class="fas fa-arrow-up"></i> Restock Product</h3>
                        <form action="admin/restock-product" method="post" class="compact-form">
                            <div class="form-group">
                                <label for="productId">Product</label>
                                <select id="productId" name="productId" required>
                                    <option value="">Select a product</option>
                                    <% for (Product p : ProductDAO.getAllProducts()) { %>
                                        <option value="<%= p.getId() %>">
                                            <%= p.getName() %> (Current: <%= p.getQuantity() %>)
                                        </option>
                                    <% } %>
                                </select>
                            </div>
                            
                            <div class="form-row">
                                <div class="form-group">
                                    <label for="restockQuantity">Quantity to Add</label>
                                    <input type="number" id="restockQuantity" name="quantity" min="1" required placeholder="50">
                                </div>
                                <button type="submit" class="btn btn-success"><i class="fas fa-plus"></i> Restock</button>
                            </div>
                        </form>
                    </div>
                    
                    <div class="divider"></div>
                    
                    <div class="inventory-action">
                        <h3><i class="fas fa-arrow-down"></i> Decrease Stock</h3>
                        <form action="admin/decrease-quantity" method="post" class="compact-form">
                            <div class="form-group">
                                <label>Product:</label>
                                <select name="productId" required>
                                    <option value="">-- Select Product --</option>
                                    <% for (Product p : ProductDAO.getAllProducts()) { %>
                                        <option value="<%= p.getId() %>">
                                            <%= p.getName() %> (Stock: <%= p.getQuantity() %>)
                                        </option>
                                    <% } %>
                                </select>
                            </div>
                            
                            <div class="form-row">
                                <div class="form-group">
                                    <label>Amount to Decrease:</label>
                                    <input type="number" name="quantity" min="1" required>
                                </div>
                                <button type="submit" class="btn btn-warning"><i class="fas fa-minus"></i> Decrease</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="card">
            <h2 class="card-title"><i class="fas fa-list"></i> Product Catalog</h2>
            <div class="table-responsive">
                <table class="product-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Price</th>
                            <th>Stock</th>
                            <th>Description</th> 
                            <th>Image</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                        List<Product> products = ProductDAO.getAllProducts();
                        for (Product p : products) { 
                        %>
                            <tr>
                                <td><%= p.getId() %></td>
                                <td><%= p.getName() %></td>
                                <td class="price">RM <%= String.format("%.2f", p.getPrice()) %></td>
                                <td class="stock <%= p.getQuantity() < 10 ? "low-stock" : "" %>">
                                    <%= p.getQuantity() %>
                                    <% if (p.getQuantity() < 10) { %>
                                        <span class="stock-warning"><i class="fas fa-exclamation-triangle"></i></span>
                                    <% } %>
                                </td>
                                <td><%= p.getDescription() != null ? p.getDescription() : "N/A" %></td>
                                <td><img src="${pageContext.request.contextPath}/<%= p.getImage() %>" class="product-img" alt="<%= p.getName() %>"></td>
                                <td class="actions">
                                    <button class="btn-icon edit-btn" data-id="<%= p.getId() %>" title="Edit Product">
                                        <i class="fas fa-edit"></i>
                                    </button>
                                    <form action="admin/delete-product" method="post" class="delete-form" onsubmit="return confirm('Are you sure you want to delete this product?')">
                                        <input type="hidden" name="productId" value="<%= p.getId() %>">
                                        <button type="submit" class="btn-icon delete-btn" title="Delete Product">
                                            <i class="fas fa-trash-alt"></i>
                                        </button>
                                    </form>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Edit Product Modal -->
    <div class="modal" id="editProductModal">
        <div class="modal-content">
            <div class="modal-header">
                <h3><i class="fas fa-edit"></i> Edit Product</h3>
                <button class="close-btn">&times;</button>
            </div>
            <div class="modal-body">
                <form action="admin/update-product" method="post" enctype="multipart/form-data">
                    <input type="hidden" id="edit-id" name="productId">
                    
                    <div class="form-group">
                        <label for="edit-name">Product Name</label>
                        <input type="text" id="edit-name" name="name" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="edit-price">Price (RM)</label>
                        <input type="number" id="edit-price" name="price" step="0.01" min="0.01" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="edit-quantity">Stock Quantity</label>
                        <input type="number" id="edit-quantity" name="quantity" min="0" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="edit-category">Category</label>
                        <select id="edit-category" name="category" required>
                            <option value="">Select a category</option>
                            <option value="Phone Case">Phone Case</option>
                            <option value="Cable">Cable</option>
                            <option value="Charger">Charger</option>
                            <option value="Power Bank">Power Bank</option>
                            <option value="Screen Protector">Screen Protector</option>
                            <option value="Earphone">Earphone</option>
                            <option value="Keyboard">Keyboard</option>
                            <option value="Holder">Holder</option>
                            <option value="Extension">Extension</option>
                            <option value="Wallpaper">Wallpaper</option>
                            <option value="Other">Other</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="edit-customCategory" id="edit-customCategoryLabel" style="display: none;">Custom Category</label>
                        <input type="text" id="edit-customCategory" name="customCategory" placeholder="Enter custom category" style="display: none;">
                    </div>
                    
                    <div class="form-group">
                        <label for="edit-description">Description</label>
                        <textarea id="edit-description" name="description" required></textarea>
                    </div>
                    
                    <div class="form-group">
                        <label>Current Image</label>
                        <div class="current-image-container">
                            <img id="current-image" src="" alt="Current Product Image">
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="edit-image">Change Image (optional)</label>
                        <div class="file-upload">
                            <input type="file" id="edit-image" name="image" accept="image/*">
                            <label for="edit-image" class="file-label"><i class="fas fa-cloud-upload-alt"></i> Choose New Image</label>
                        </div>
                        <small>Leave empty to keep current image</small>
                    </div>
                    
                    <div class="form-actions">
                        <button type="button" class="btn btn-outline modal-cancel">Cancel</button>
                        <button type="submit" class="btn btn-primary">Save Changes</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        // Collapsible functionality
        document.querySelectorAll('.collapsible .toggle-btn').forEach(button => {
            button.addEventListener('click', () => {
                const card = button.closest('.collapsible');
                const content = card.querySelector('.card-content');
                const icon = button.querySelector('i');
                
                content.style.display = content.style.display === 'none' ? 'block' : 'none';
                icon.classList.toggle('fa-chevron-down');
                icon.classList.toggle('fa-chevron-up');
                card.classList.toggle('collapsed');
            });
        });

        // Initialize collapsible state
        document.querySelectorAll('.collapsible').forEach(card => {
            const content = card.querySelector('.card-content');
            content.style.display = 'block'; // Default to expanded
        });

        // File upload styling
        document.querySelectorAll('input[type="file"]').forEach(input => {
            input.addEventListener('change', function() {
                const label = this.nextElementSibling;
                if (this.files.length > 0) {
                    label.textContent = this.files[0].name;
                    label.classList.add('has-file');
                } else {
                    label.innerHTML = '<i class="fas fa-cloud-upload-alt"></i> Choose Image';
                    label.classList.remove('has-file');
                }
            });
        });
        
        // Show/hide custom category field when "Other" is selected
        document.getElementById('category').addEventListener('change', function() {
            const customCategoryField = document.getElementById('customCategory');
            const customCategoryLabel = document.getElementById('customCategoryLabel');
            
            if (this.value === 'Other') {
                customCategoryField.style.display = 'block';
                customCategoryLabel.style.display = 'block';
                customCategoryField.required = true;
            } else {
                customCategoryField.style.display = 'none';
                customCategoryLabel.style.display = 'none';
                customCategoryField.required = false;
            }
        });
        
        // Edit modal functionality
        const modal = document.getElementById('editProductModal');
        const closeBtn = modal.querySelector('.close-btn');
        const cancelBtn = modal.querySelector('.modal-cancel');
        const editBtns = document.querySelectorAll('.edit-btn');
        
        // Product data for edit modal
        const productData = {
            <% for (Product p : products) { %>
                '<%= p.getId() %>': {
                    name: '<%= p.getName().replace("'", "\\'") %>',
                    price: <%= p.getPrice() %>,
                    quantity: <%= p.getQuantity() %>,
                    description: '<%= p.getDescription() != null ? p.getDescription().replace("'", "\\'") : "" %>',
                    image: '<%= request.getContextPath() + "/" + p.getImage() %>',
                    category: '<%= p.getDescription() != null ? extractCategory(p.getDescription()) : "" %>'
                },
            <% } %>
        };
        
        // Function to extract category from description
        function extractCategory(description) {
            const categories = ["Phone Case", "Cable", "Charger", "Power Bank", 
                              "Screen Protector", "Earphone", "Keyboard", "Holder", 
                              "Extension", "Wallpaper"];
            
            for (const cat of categories) {
                if (description.toLowerCase().includes(cat.toLowerCase())) {
                    return cat;
                }
            }
            return "Other";
        }
        
        // Open edit modal
        editBtns.forEach(btn => {
            btn.addEventListener('click', function() {
                const productId = this.getAttribute('data-id');
                const product = productData[productId];
                
                document.getElementById('edit-id').value = productId;
                document.getElementById('edit-name').value = product.name;
                document.getElementById('edit-price').value = product.price;
                document.getElementById('edit-quantity').value = product.quantity;
                document.getElementById('edit-description').value = product.description;
                document.getElementById('current-image').src = product.image;
                
                // Set category
                const categorySelect = document.getElementById('edit-category');
                const customCategoryField = document.getElementById('edit-customCategory');
                const customCategoryLabel = document.getElementById('edit-customCategoryLabel');
                
                if (categories.includes(product.category)) {
                    categorySelect.value = product.category;
                    customCategoryField.style.display = 'none';
                    customCategoryLabel.style.display = 'none';
                    customCategoryField.required = false;
                } else {
                    categorySelect.value = 'Other';
                    customCategoryField.style.display = 'block';
                    customCategoryLabel.style.display = 'block';
                    customCategoryField.required = true;
                    customCategoryField.value = product.category;
                }
                
                modal.style.display = 'flex';
            });
        });
        
        // Close modal
        function closeModal() {
            modal.style.display = 'none';
        }
        
        closeBtn.addEventListener('click', closeModal);
        cancelBtn.addEventListener('click', closeModal);
        
        // Close modal when clicking outside
        window.addEventListener('click', function(event) {
            if (event.target === modal) {
                closeModal();
            }
        });
        
        // Edit modal custom category handling
        document.getElementById('edit-category').addEventListener('change', function() {
            const customCategoryField = document.getElementById('edit-customCategory');
            const customCategoryLabel = document.getElementById('edit-customCategoryLabel');
            
            if (this.value === 'Other') {
                customCategoryField.style.display = 'block';
                customCategoryLabel.style.display = 'block';
                customCategoryField.required = true;
            } else {
                customCategoryField.style.display = 'none';
                customCategoryLabel.style.display = 'none';
                customCategoryField.required = false;
            }
        });
        
        // JavaScript function to extract categories
        const categories = ["Phone Case", "Cable", "Charger", "Power Bank", 
                          "Screen Protector", "Earphone", "Keyboard", "Holder", 
                          "Extension", "Wallpaper"];
    </script>
</body>
</html>

<%!
// JSP function to extract category from description
private String extractCategory(String description) {
    if (description == null) return "";
    
    String[] categories = {"Phone Case", "Cable", "Charger", "Power Bank", 
                         "Screen Protector", "Earphone", "Keyboard", "Holder", 
                         "Extension", "Wallpaper"};
    
    for (String cat : categories) {
        if (description.toLowerCase().contains(cat.toLowerCase())) {
            return cat;
        }
    }
    return "Other";
}
%>