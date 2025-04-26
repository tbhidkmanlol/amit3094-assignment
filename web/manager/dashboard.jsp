<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.User, dao.UserDAO, java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <title>Manager Dashboard</title>
    <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
    <link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@500&display=swap" rel="stylesheet">
    <style>
        body { 
            font-family: 'Orbitron', sans-serif;
            background-color: #121212;
            color: #ffffff;
            margin: 0;
            padding: 0;
        }
        
        .navbar {
            background-color: #1a1a1a;
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 0 10px rgba(255, 0, 0, 0.3);
            border-bottom: 1px solid rgba(255, 70, 70, 0.3);
        }
        
        .navbar h2 {
            margin: 0;
            color: #ffffff;
            text-shadow: 0 0 5px #ff0000, 0 0 10px #ff4500;
        }
        
        .navbar .links {
            display: flex;
            gap: 20px;
        }
        
        .navbar a {
            color: #ffffff;
            text-decoration: none;
            padding: 8px 15px;
            border-radius: 5px;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 5px;
        }
        
        .navbar a:hover {
            background: rgba(255, 0, 0, 0.2);
            box-shadow: 0 0 10px rgba(255, 0, 0, 0.5);
        }
        
        .dashboard {
            width: 90%;
            max-width: 1200px;
            margin: 30px auto;
            padding: 25px;
            border: 1px solid rgba(255, 70, 70, 0.3);
            border-radius: 10px;
            background: rgba(20, 20, 20, 0.8);
            box-shadow: 0 0 15px rgba(255, 0, 0, 0.3);
        }
        
        h1, h3 {
            color: #ffffff;
            text-shadow: 0 0 5px #ff0000, 0 0 10px #ff4500;
            border-bottom: 1px solid rgba(255, 70, 70, 0.3);
            padding-bottom: 10px;
        }
        
        .dashboard-section {
            margin-bottom: 30px;
        }
        
        .btn {
            display: inline-block;
            padding: 10px 20px;
            background: linear-gradient(90deg, #ff0000, #ff4500);
            color: white;
            text-decoration: none;
            border-radius: 5px;
            font-family: 'Orbitron', sans-serif;
            font-weight: bold;
            font-size: 14px;
            transition: all 0.3s;
            border: none;
            margin: 5px 0;
            cursor: pointer;
            box-shadow: 0 0 5px rgba(255, 0, 0, 0.3);
            text-shadow: 0 0 3px rgba(0, 0, 0, 0.5);
        }
        
        .btn:hover {
            background: linear-gradient(90deg, #ff4500, #ff0000);
            box-shadow: 0 0 10px rgba(255, 0, 0, 0.8);
            transform: translateY(-2px);
        }
        
        .btn i {
            margin-right: 5px;
        }
        
        .tab-nav {
            display: flex;
            border-bottom: 1px solid rgba(255, 70, 70, 0.3);
            margin-bottom: 20px;
        }
        
        .tab-nav a {
            padding: 10px 20px;
            text-decoration: none;
            color: #ffffff;
            border-bottom: 2px solid transparent;
            margin-right: 10px;
            transition: all 0.3s;
        }
        
        .tab-nav a.active {
            border-bottom: 2px solid #ff4500;
            color: #ff4500;
        }
        
        .tab-content {
            display: none;
        }
        
        .tab-content.active {
            display: block;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 5px;
            color: #cccccc;
        }
        
        .form-group input, .form-group select {
            width: 100%;
            padding: 10px;
            border: 1px solid rgba(255, 70, 70, 0.3);
            background: rgba(30, 30, 30, 0.8);
            border-radius: 5px;
            color: white;
            font-family: 'Orbitron', sans-serif;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            color: #ffffff;
        }
        
        th, td {
            border: 1px solid rgba(255, 70, 70, 0.3);
            padding: 10px;
            text-align: left;
        }
        
        th {
            background-color: rgba(40, 40, 40, 0.8);
            color: #ff4500;
        }
        
        tr:nth-child(even) {
            background-color: rgba(30, 30, 30, 0.5);
        }
        
        tr:hover {
            background-color: rgba(50, 50, 50, 0.8);
        }
        
        .action-buttons {
            display: flex;
            gap: 5px;
        }
        
        .edit-btn, .delete-btn {
            padding: 5px 10px;
            cursor: pointer;
            border: none;
            border-radius: 3px;
            color: white;
            font-size: 12px;
        }
        
        .edit-btn {
            background-color: #2196F3;
        }
        
        .delete-btn {
            background-color: #F44336;
        }
        
        .modal {
            display: none;
            position: fixed;
            z-index: 1;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0, 0, 0, 0.8);
        }
        
        .modal-content {
            background-color: #1a1a1a;
            margin: 10% auto;
            padding: 20px;
            border: 1px solid rgba(255, 70, 70, 0.3);
            border-radius: 10px;
            width: 50%;
            box-shadow: 0 0 15px rgba(255, 0, 0, 0.5);
        }
        
        .close {
            color: #aaa;
            float: right;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
        }
        
        .close:hover {
            color: #ff4500;
        }
        
        .notice {
            padding: 15px;
            margin: 10px 0;
            border-radius: 5px;
            color: white;
            text-align: center;
        }
        
        .success {
            background-color: rgba(40, 167, 69, 0.2);
            border: 1px solid rgba(40, 167, 69, 0.5);
        }
        
        .error {
            background-color: rgba(220, 53, 69, 0.2);
            border: 1px solid rgba(220, 53, 69, 0.5);
        }
    </style>
</head>
<body>
    <%
        // Authentication check
        User user = (User) session.getAttribute("user");
        if (user == null || !"MANAGER".equals(user.getRole())) {
            response.sendRedirect("../login.jsp?error=unauthorized");
            return;
        }
        
        // Create UserDAO instance to fetch data
        UserDAO userDAO = new UserDAO();
        List<User> customers = null;
        List<User> adminMembers = null;
        
        try {
            customers = userDAO.getAllCustomers();
            adminMembers = userDAO.getAllAdmins();
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        // Get the section parameter
        String section = request.getParameter("section");
        boolean showSettings = "settings".equals(section);
        boolean showCustomers = "customers".equals(section);
        boolean showProducts = "products".equals(section);
        
        // Default to admin management if no section specified
        if (section == null) {
            showSettings = false;
            showCustomers = false;
            showProducts = false;
        }

        // Password change status parameter
        String passwordChangeStatus = request.getParameter("password_status");
    %>
    
    <!-- Navigation Bar -->
    <div class="navbar">
        <h2>Manager Dashboard</h2>
        <div class="links">
            <a href="../home.jsp"><i class='bx bx-home'></i> Back to Home</a>
            <a href="${pageContext.request.contextPath}/auth/logout"><i class='bx bx-log-out'></i> Logout</a>
        </div>
    </div>
    
    <div class="dashboard">
        <h1>Welcome, <%= user.getUsername() %>!</h1>
        
        <!-- Success or error messages -->
        <% if (request.getParameter("success") != null) { %>
            <div class="notice success">
                <% String successMessage = "Operation completed successfully"; 
                   if ("admin_created".equals(request.getParameter("success"))) {
                       successMessage = "Admin account created successfully";
                   } else if ("password_changed".equals(request.getParameter("success"))) {
                       successMessage = "Password changed successfully";
                   } else if ("user_updated".equals(request.getParameter("success"))) {
                       successMessage = "User information updated successfully";
                   } else if ("user_deleted".equals(request.getParameter("success"))) {
                       successMessage = "User deleted successfully";
                   }
                %>
                <i class='bx bx-check-circle'></i> <%= successMessage %>
            </div>
        <% } %>
        
        <% if (request.getParameter("error") != null) { %>
            <div class="notice error">
                <% String errorMessage = "An error occurred. Please try again."; 
                   if ("password_update".equals(request.getParameter("error"))) {
                       errorMessage = "Failed to update password. Please try again.";
                   }
                %>
                <i class='bx bx-error-circle'></i> <%= errorMessage %>
            </div>
        <% } %>

        <!-- Password change success or failure message -->
        <% if (passwordChangeStatus != null) { %>
            <% if ("success".equals(passwordChangeStatus)) { %>
                <div class="notice success">
                    <i class='bx bx-check-circle'></i> Password changed successfully!
                </div>
            <% } else if ("error".equals(passwordChangeStatus)) { %>
                <div class="notice error">
                    <i class='bx bx-error-circle'></i> Password change failed. Please verify your current password.
                </div>
            <% } else if ("mismatch".equals(passwordChangeStatus)) { %>
                <div class="notice error">
                    <i class='bx bx-error-circle'></i> New password and confirmation do not match. Please try again.
                </div>
            <% } %>
        <% } %>
        
        <!-- Navigation Tabs -->
        <div class="tab-nav">
            <a href="dashboard.jsp" class="<%= !showSettings && !showCustomers && !showProducts ? "active" : "" %>">Admin Management</a>
            <a href="?section=customers" class="<%= showCustomers ? "active" : "" %>">Customer Management</a>
            <a href="?section=products" class="<%= showProducts ? "active" : "" %>">Product Management</a>
            <a href="?section=settings" class="<%= showSettings ? "active" : "" %>">Settings</a>
        </div>
        
        <!-- Admin Management Section -->
        <div class="tab-content <%= !showSettings && !showCustomers && !showProducts ? "active" : "" %>" id="admin-management">
            <div class="dashboard-section">
                <h3>Admin Management</h3>
                <p>Create and manage admin accounts for your e-commerce platform.</p>
                <div class="action-buttons" style="margin-bottom: 20px;">
                    <a href="create-admin.jsp" class="btn"><i class='bx bx-user-plus'></i> Create New Admin Account</a>
                    <a href="../AdminReviews.jsp" class="btn"><i class='bx bx-star'></i> Manage Reviews</a>
                    <a href="sales-report.jsp" class="btn"><i class='bx bx-chart'></i> Sales Reports</a>
                </div>
                
                <!-- Admin Accounts Table -->
                <h4 style="margin-top: 30px;">Admin Accounts</h4>
                <% if (adminMembers != null && !adminMembers.isEmpty()) { %>
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Username</th>
                                <th>Role</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (User admin : adminMembers) { %>
                                <tr>
                                    <td><%= admin.getId() %></td>
                                    <td><%= admin.getUsername() %></td>
                                    <td><%= admin.getRole() %></td>
                                    <td class="action-buttons">
                                        <button class="edit-btn" onclick="openEditAdminModal(<%= admin.getId() %>, '<%= admin.getUsername() %>')">
                                            <i class='bx bx-edit'></i> Edit
                                        </button>
                                        <form method="post" action="../deleteUser" style="display:inline" onsubmit="return confirm('Are you sure you want to delete this administrator?');">
                                            <input type="hidden" name="userId" value="<%= admin.getId() %>">
                                            <button type="submit" class="delete-btn"><i class='bx bx-trash'></i> Delete</button>
                                        </form>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                <% } else { %>
                    <p>No admin accounts found in the system.</p>
                <% } %>
            </div>
        </div>
        
        <!-- Customer Management Section -->
        <div class="tab-content <%= showCustomers ? "active" : "" %>" id="customer-management">
            <div class="dashboard-section">
                <h3>Customer Management</h3>
                <p>View, edit, and manage customer accounts.</p>
                
                <% if (customers != null && !customers.isEmpty()) { %>
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Username</th>
                                <th>Full Name</th>
                                <th>Contact Number</th>
                                <th>Email</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (User customer : customers) { %>
                                <tr>
                                    <td><%= customer.getId() %></td>
                                    <td><%= customer.getUsername() %></td>
                                    <td><%= customer.getCustomerName() != null ? customer.getCustomerName() : "N/A" %></td>
                                    <td><%= customer.getContactNumber() != null ? customer.getContactNumber() : "N/A" %></td>
                                    <td><%= customer.getEmail() != null ? customer.getEmail() : "N/A" %></td>
                                    <td class="action-buttons">
                                        <button class="edit-btn" onclick="openEditCustomerModal(<%= customer.getId() %>, '<%= customer.getUsername() %>', '<%= customer.getCustomerName() != null ? customer.getCustomerName() : "" %>', '<%= customer.getContactNumber() != null ? customer.getContactNumber() : "" %>', '<%= customer.getEmail() != null ? customer.getEmail() : "" %>')">
                                            <i class='bx bx-edit'></i> Edit
                                        </button>
                                        <form method="post" action="../deleteUser" style="display:inline" onsubmit="return confirm('Are you sure you want to delete this customer?');">
                                            <input type="hidden" name="userId" value="<%= customer.getId() %>">
                                            <button type="submit" class="delete-btn"><i class='bx bx-trash'></i> Delete</button>
                                        </form>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                <% } else { %>
                    <p>No customers found in the system.</p>
                <% } %>
            </div>
        </div>
        
        <!-- Product Management Section -->
        <div class="tab-content <%= showProducts ? "active" : "" %>" id="product-management">
            <div class="dashboard-section">
                <h3>Product Management</h3>
                <p>Access the product management system to add, edit, and manage products.</p>
                <a href="../admin-product.jsp" class="btn"><i class='bx bx-package'></i> Manage Products</a>
            </div>
        </div>
        
        <!-- Settings Section -->
        <div class="tab-content <%= showSettings ? "active" : "" %>" id="settings">
            <div class="dashboard-section">
                <h3>Account Settings</h3>
                <form action="../auth/update-password" method="post">
                    <div class="form-group">
                        <label for="username">Username</label>
                        <input type="text" id="username" name="username" value="<%= user.getUsername() %>" disabled>
                    </div>
                    <div class="form-group">
                        <label for="currentPassword">Current Password</label>
                        <input type="password" id="currentPassword" name="currentPassword" required>
                    </div>
                    <div class="form-group">
                        <label for="newPassword">New Password</label>
                        <input type="password" id="newPassword" name="newPassword" required>
                    </div>
                    <div class="form-group">
                        <label for="confirmPassword">Confirm New Password</label>
                        <input type="password" id="confirmPassword" name="confirmPassword" required>
                    </div>
                    <button type="submit" class="btn"><i class='bx bx-save'></i> Update Password</button>
                </form>
            </div>
        </div>
    </div>
    
    <!-- Edit Customer Modal -->
    <div id="editCustomerModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeEditCustomerModal()">&times;</span>
            <h3>Edit Customer</h3>
            <form action="../updateCustomer" method="post" id="editCustomerForm">
                <input type="hidden" id="editCustomerId" name="customerId">
                <div class="form-group">
                    <label for="editCustomerUsername">Username</label>
                    <input type="text" id="editCustomerUsername" name="username" required>
                </div>
                <div class="form-group">
                    <label for="editCustomerName">Full Name</label>
                    <input type="text" id="editCustomerName" name="customerName" required>
                </div>
                <div class="form-group">
                    <label for="editCustomerContact">Contact Number</label>
                    <input type="tel" id="editCustomerContact" name="contactNumber" pattern="[0-9]{10,15}" title="Phone number should be between 10-15 digits" required>
                </div>
                <div class="form-group">
                    <label for="editCustomerEmail">Email Address</label>
                    <input type="email" id="editCustomerEmail" name="email" required>
                </div>
                <div class="form-group">
                    <label for="editCustomerPassword">New Password (leave blank to keep current)</label>
                    <input type="password" id="editCustomerPassword" name="password">
                </div>
                <button type="submit" class="btn"><i class='bx bx-save'></i> Save Changes</button>
            </form>
        </div>
    </div>
    
    <!-- Edit Admin Modal -->
    <div id="editAdminModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeEditAdminModal()">&times;</span>
            <h3>Edit Administrator</h3>
            <form action="../updateAdmin" method="post" id="editAdminForm">
                <input type="hidden" id="editAdminId" name="adminId">
                <div class="form-group">
                    <label for="editAdminUsername">Username</label>
                    <input type="text" id="editAdminUsername" name="username" required>
                </div>
                <div class="form-group">
                    <label for="editAdminPassword">New Password (leave blank to keep current)</label>
                    <input type="password" id="editAdminPassword" name="password">
                </div>
                <button type="submit" class="btn"><i class='bx bx-save'></i> Save Changes</button>
            </form>
        </div>
    </div>

    <script>
        // Password confirmation check
        document.querySelector('form').addEventListener('submit', function(event) {
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            if (newPassword && newPassword !== confirmPassword) {
                alert('New password and confirmation do not match!');
                event.preventDefault();
            }
        });
        
        // Customer Modal Functions
        function openEditCustomerModal(id, username, customerName, contactNumber, email) {
            document.getElementById('editCustomerId').value = id;
            document.getElementById('editCustomerUsername').value = username;
            document.getElementById('editCustomerName').value = customerName;
            document.getElementById('editCustomerContact').value = contactNumber;
            document.getElementById('editCustomerEmail').value = email;
            document.getElementById('editCustomerPassword').value = '';
            document.getElementById('editCustomerModal').style.display = 'block';
        }
        
        function closeEditCustomerModal() {
            document.getElementById('editCustomerModal').style.display = 'none';
        }
        
        // Admin Modal Functions
        function openEditAdminModal(id, username) {
            document.getElementById('editAdminId').value = id;
            document.getElementById('editAdminUsername').value = username;
            document.getElementById('editAdminPassword').value = '';
            document.getElementById('editAdminModal').style.display = 'block';
        }
        
        function closeEditAdminModal() {
            document.getElementById('editAdminModal').style.display = 'none';
        }
        
        // Close modals when clicking outside
        window.onclick = function(event) {
            const customerModal = document.getElementById('editCustomerModal');
            const adminModal = document.getElementById('editAdminModal');
            
            if (event.target == customerModal) {
                customerModal.style.display = 'none';
            }
            
            if (event.target == adminModal) {
                adminModal.style.display = 'none';
            }
        }
    </script>
</body>
</html>