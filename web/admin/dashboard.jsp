<%-- 
    Document   : dashboard
    Created on : Apr 21, 2025, 1:58:37 AM
    Author     : Dell
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.User" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>
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
            max-width: 800px;
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
    </style>
</head>
<body>
    <%
        // Authentication check
        Object userObj = session.getAttribute("user");
        User user = (userObj != null) ? (User)userObj : null;
        
        if (user == null || !"ADMIN".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        // Get the section parameter
        String section = request.getParameter("section");
        boolean showSettings = "settings".equals(section);
        boolean showProducts = "products".equals(section);
    %>
    
    <!-- Navigation Bar -->
    <div class="navbar">
        <h2>Admin Dashboard</h2>
        <div class="links">
            <a href="../home.jsp"><i class='bx bx-home'></i> Back to Home</a>
            <a href="${pageContext.request.contextPath}/auth/logout"><i class='bx bx-log-out'></i> Logout</a>
        </div>
    </div>
    
    <div class="dashboard">
        <h1>Welcome, <%= user.getUsername() %>!</h1>
        
        <div class="tab-nav">
            <a href="?section=dashboard" class="<%= (!showSettings && !showProducts) ? "active" : "" %>">Dashboard</a>
            <a href="?section=products" class="<%= showProducts ? "active" : "" %>">Products</a>
            <a href="?section=settings" class="<%= showSettings ? "active" : "" %>">Settings</a>
        </div>
        
        <!-- Dashboard Section -->
        <div class="tab-content <%= (!showSettings && !showProducts) ? "active" : "" %>" id="dashboard-content">
            <div class="dashboard-section">
                <h3>Admin Controls</h3>
                <p>Welcome to your admin control panel. From here you can manage products, view orders, and update your settings.</p>
                <div class="btn-group">
                    <a href="../admin-product.jsp" class="btn"><i class='bx bx-package'></i> Manage Products</a>
                    <a href="../AdminReviews.jsp" class="btn"><i class='bx bx-star'></i> Manage Reviews</a>
                </div>
            </div>
        </div>
        
        <!-- Products Section -->
        <div class="tab-content <%= showProducts ? "active" : "" %>" id="products-content">
            <div class="dashboard-section">
                <h3>Product Management</h3>
                <p>Add, edit, or remove products from your inventory.</p>
                <a href="../admin-product.jsp" class="btn"><i class='bx bx-package'></i> Go to Product Management</a>
            </div>
        </div>
        
        <!-- Settings Section -->
        <div class="tab-content <%= showSettings ? "active" : "" %>" id="settings-content">
            <div class="dashboard-section">
                <h3>Account Settings</h3>
                <form action="../update-account" method="post">
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
                        <input type="password" id="newPassword" name="newPassword">
                    </div>
                    <div class="form-group">
                        <label for="confirmPassword">Confirm New Password</label>
                        <input type="password" id="confirmPassword" name="confirmPassword">
                    </div>
                    <button type="submit" class="btn"><i class='bx bx-save'></i> Update Settings</button>
                </form>
            </div>
        </div>
    </div>

    <script>
        // Simple password confirmation check
        document.querySelector('form').addEventListener('submit', function(event) {
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            if (newPassword && newPassword !== confirmPassword) {
                alert('New password and confirmation do not match!');
                event.preventDefault();
            }
        });
    </script>
</body>
</html>
