<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.User" %>
<!DOCTYPE html>
<html>
<head>
    <title>Create New Product</title>
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
        
        .container {
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
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 5px;
            color: #cccccc;
        }
        
        .form-group input, .form-group select, .form-group textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid rgba(255, 70, 70, 0.3);
            background: rgba(30, 30, 30, 0.8);
            border-radius: 5px;
            color: white;
            font-family: 'Orbitron', sans-serif;
        }
        
        .form-group textarea {
            min-height: 100px;
            resize: vertical;
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
        
        .back-btn {
            background: transparent;
            border: 1px solid rgba(255, 70, 70, 0.5);
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
    %>
    
    <!-- Navigation Bar -->
    <div class="navbar">
        <h2>Create New Product</h2>
        <div class="links">
            <a href="dashboard.jsp?section=products"><i class='bx bx-arrow-back'></i> Back to Dashboard</a>
            <a href="../home.jsp"><i class='bx bx-home'></i> Back to Home</a>
            <a href="${pageContext.request.contextPath}/auth/logout"><i class='bx bx-log-out'></i> Logout</a>
        </div>
    </div>
    
    <div class="container">
        <h1>Add New Product</h1>
        
        <!-- Success or error messages -->
        <% if (request.getParameter("success") != null) { %>
            <div class="notice success">
                <i class='bx bx-check-circle'></i> Product has been created successfully!
            </div>
        <% } %>
        
        <% if (request.getParameter("error") != null) { %>
            <div class="notice error">
                <i class='bx bx-error-circle'></i> Failed to create product. Please try again.
            </div>
        <% } %>
        
        <form action="${pageContext.request.contextPath}/CreateProduct" method="post" enctype="multipart/form-data">
            <div class="form-group">
                <label for="name">Product Name</label>
                <input type="text" id="name" name="name" required>
            </div>
            
            <div class="form-group">
                <label for="description">Description</label>
                <textarea id="description" name="description" required></textarea>
            </div>
            
            <div class="form-group">
                <label for="price">Price (RM)</label>
                <input type="number" id="price" name="price" step="0.01" min="0.01" required>
            </div>
            
            <div class="form-group">
                <label for="quantity">Quantity</label>
                <input type="number" id="quantity" name="quantity" min="1" required>
            </div>
            
            <div class="form-group">
                <label for="category">Category</label>
                <select id="category" name="category" required>
                    <option value="" disabled selected>Select a category</option>
                    <option value="Cables">Cables</option>
                    <option value="Chargers">Chargers</option>
                    <option value="Audio">Audio</option>
                    <option value="Phone Accessories">Phone Accessories</option>
                    <option value="Computer Peripherals">Computer Peripherals</option>
                    <option value="Other">Other</option>
                </select>
            </div>
            
            <div class="form-group">
                <label for="image">Product Image</label>
                <input type="file" id="image" name="image" accept="image/*" required>
            </div>
            
            <div style="display: flex; gap: 10px;">
                <button type="submit" class="btn"><i class='bx bx-save'></i> Create Product</button>
                <a href="dashboard.jsp?section=products" class="btn back-btn"><i class='bx bx-x'></i> Cancel</a>
            </div>
        </form>
    </div>
</body>
</html>