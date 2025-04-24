<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%
    // Check if user is logged in and is a manager
    User user = (User) session.getAttribute("user");
    if (user == null || !"MANAGER".equals(user.getRole())) {
        response.sendRedirect("../login.jsp?error=unauthorized");
        return;
    }
    
    // Get the created admin name if available
    String adminName = request.getParameter("adminName");
    if (adminName == null) {
        adminName = "Admin";
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Created Successfully</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg-color: black;
            --text-color: #fff;
            --heading-color: #fff;
            --card-bg: rgba(20, 20, 20, 0.8);
            --card-border: rgba(255, 70, 70, 0.3);
            --shadow: 0 0 10px rgba(255, 0, 0, 0.3);
            --btn-bg: linear-gradient(90deg, #ff0000, #ff4500);
            --btn-text: white;
            --cyber-glow: 0 0 5px #ff0000, 0 0 10px #ff4500;
            --cyber-glow-intense: 0 0 10px #ff0000, 0 0 20px #ff4500, 0 0 30px rgba(255, 69, 0, 0.5);
            --accent-color: #ff4500;
            --secondary-color: #ff00f7;
            --input-bg: rgba(30, 30, 30, 0.8);
            --success-color: #00ff66;
            --success-bg: rgba(0, 255, 102, 0.1);
            --error-color: #ff0055;
            --border-glow: 0 0 5px #ff0000, 0 0 10px rgba(255, 69, 0, 0.7);
            --glitch-color-1: #ff00c1;
            --glitch-color-2: #00ffff;
            --binary-color: rgba(0, 255, 170, 0.03);
        }
        
        /* Light Theme */
        html.light-theme {
            --bg-color: #f5f5f5;
            --text-color: #333;
            --heading-color: #222;
            --card-bg: rgba(255, 255, 255, 0.9);
            --card-border: rgba(255, 70, 70, 0.2);
            --shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            --btn-bg: linear-gradient(90deg, #ff0000, #ff4500);
            --btn-text: white;
            --cyber-glow: 0 0 3px rgba(255, 0, 0, 0.3), 0 0 6px rgba(255, 69, 0, 0.2);
            --cyber-glow-intense: 0 0 5px rgba(255, 0, 0, 0.5), 0 0 10px rgba(255, 69, 0, 0.3);
            --input-bg: rgba(245, 245, 245, 0.9);
            --success-color: #00cc44;
            --success-bg: rgba(0, 204, 68, 0.1);
            --error-color: #ff0044;
            --border-glow: 0 0 3px rgba(255, 0, 0, 0.3), 0 0 5px rgba(255, 69, 0, 0.2);
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Orbitron', sans-serif;
            background-color: var(--bg-color);
            color: var(--text-color);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            overflow-x: hidden;
            position: relative;
        }
        
        /* Background Elements */
        .background-elements {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: -1;
            overflow: hidden;
        }
        
        .cyber-circle {
            position: absolute;
            border-radius: 50%;
            border: 2px solid var(--accent-color);
            opacity: 0.2;
            filter: blur(2px);
            box-shadow: var(--cyber-glow);
            animation: pulsate 4s infinite alternate;
        }
        
        .cyber-circle:nth-child(1) {
            width: 300px;
            height: 300px;
            top: -100px;
            left: -100px;
            border-color: var(--accent-color);
            animation-delay: 0s;
        }
        
        .cyber-circle:nth-child(2) {
            width: 500px;
            height: 500px;
            bottom: -200px;
            right: -200px;
            border-color: var(--secondary-color);
            animation-delay: 1s;
        }
        
        .cyber-circle.small-circle {
            width: 150px;
            height: 150px;
            top: 70%;
            left: 20%;
            border-color: var(--secondary-color);
            animation-delay: 0.5s;
            opacity: 0.15;
        }
        
        .cyber-line {
            position: absolute;
            height: 2px;
            background: linear-gradient(90deg, transparent, var(--accent-color), transparent);
            opacity: 0.4;
            filter: blur(1px);
            animation: flow 8s infinite linear;
        }
        
        .line1 {
            width: 100%;
            top: 20%;
            left: 0;
            animation-duration: 10s;
        }
        
        .line2 {
            width: 80%;
            top: 50%;
            right: 0;
            animation-duration: 8s;
        }
        
        .line3 {
            width: 60%;
            bottom: 30%;
            left: 10%;
            animation-duration: 12s;
        }
        
        .cyber-grid {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-image: 
                linear-gradient(rgba(255, 0, 0, 0.05) 1px, transparent 1px),
                linear-gradient(90deg, rgba(255, 0, 0, 0.05) 1px, transparent 1px);
            background-size: 50px 50px;
            opacity: 0.3;
            z-index: -1;
        }
        
        .success-container {
            background-color: var(--card-bg);
            border: 1px solid var(--card-border);
            border-radius: 10px;
            box-shadow: var(--shadow);
            padding: 40px;
            text-align: center;
            max-width: 500px;
            width: 90%;
            position: relative;
            overflow: hidden;
            backdrop-filter: blur(10px);
            animation: fadeIn 0.5s ease-out;
        }
        
        .success-container::before {
            content: '';
            position: absolute;
            top: -2px;
            left: -2px;
            right: -2px;
            bottom: -2px;
            border: 2px solid transparent;
            border-radius: 12px;
            background: linear-gradient(45deg, var(--accent-color), transparent, var(--accent-color)) border-box;
            -webkit-mask: linear-gradient(#fff 0 0) padding-box, linear-gradient(#fff 0 0);
            -webkit-mask-composite: xor;
            mask-composite: exclude;
            opacity: 0.7;
            animation: borderPulse 2s infinite alternate;
        }
        
        .success-icon {
            font-size: 80px;
            color: var(--success-color);
            margin-bottom: 20px;
            position: relative;
            display: inline-block;
            animation: iconPulse 2s infinite alternate;
        }
        
        .success-icon::after {
            content: '';
            position: absolute;
            width: 100%;
            height: 100%;
            background: radial-gradient(circle, var(--success-bg) 30%, transparent 70%);
            border-radius: 50%;
            z-index: -1;
            transform: scale(1.5);
            opacity: 0.7;
            animation: glowPulse 2s infinite alternate;
        }
        
        h1 {
            color: var(--heading-color);
            font-size: 28px;
            margin-bottom: 15px;
            font-weight: 700;
            text-transform: uppercase;
            text-shadow: var(--cyber-glow);
            position: relative;
            display: inline-block;
        }
        
        h1::after {
            content: '';
            position: absolute;
            bottom: -8px;
            left: 50%;
            transform: translateX(-50%);
            width: 50%;
            height: 3px;
            background: linear-gradient(to right, transparent, var(--accent-color), transparent);
            border-radius: 2px;
        }
        
        p {
            color: var(--text-color);
            margin-bottom: 30px;
            line-height: 1.6;
            font-size: 16px;
            opacity: 0.9;
        }
        
        .admin-name {
            color: var(--accent-color);
            font-weight: 600;
            position: relative;
            padding: 0 5px;
        }
        
        .admin-name::before {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 100%;
            height: 30%;
            background-color: var(--accent-color);
            opacity: 0.2;
            z-index: -1;
        }
        
        .options-container {
            display: flex;
            flex-direction: column;
            gap: 15px;
            margin-top: 20px;
        }
        
        .option-button {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            padding: 12px 20px;
            border-radius: 5px;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
            position: relative;
            overflow: hidden;
            font-family: 'Orbitron', sans-serif;
        }
        
        .primary-btn {
            background: var(--btn-bg);
            color: var(--btn-text);
            box-shadow: var(--cyber-glow);
        }
        
        .primary-btn:hover {
            box-shadow: var(--cyber-glow-intense);
            transform: translateY(-2px);
        }
        
        .outline-btn {
            background-color: transparent;
            color: var(--accent-color);
            border: 1px solid var(--accent-color);
            box-shadow: inset 0 0 10px rgba(255, 0, 0, 0.1);
        }
        
        .outline-btn:hover {
            background-color: rgba(255, 0, 0, 0.1);
            box-shadow: inset 0 0 15px rgba(255, 0, 0, 0.2), var(--cyber-glow);
        }
        
        .danger-btn {
            background-color: transparent;
            color: var(--error-color);
            border: 1px solid var(--error-color);
            box-shadow: inset 0 0 10px rgba(255, 0, 85, 0.1);
        }
        
        .danger-btn:hover {
            background-color: rgba(255, 0, 85, 0.1);
            box-shadow: inset 0 0 15px rgba(255, 0, 85, 0.2), 0 0 10px rgba(255, 0, 85, 0.3);
        }
        
        .option-button i {
            font-size: 16px;
        }
        
        .theme-toggle {
            position: absolute;
            top: 15px;
            right: 15px;
            background: transparent;
            border: none;
            color: var(--text-color);
            font-size: 20px;
            cursor: pointer;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s ease;
        }
        
        .theme-toggle:hover {
            background-color: rgba(255, 255, 255, 0.1);
            transform: rotate(30deg);
        }
        
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        @keyframes pulsate {
            0% { transform: scale(1); opacity: 0.2; }
            100% { transform: scale(1.05); opacity: 0.3; }
        }
        
        @keyframes flow {
            0% { transform: translateX(-100%); }
            100% { transform: translateX(100%); }
        }
        
        @keyframes iconPulse {
            0% { transform: scale(1); }
            100% { transform: scale(1.1); }
        }
        
        @keyframes glowPulse {
            0% { opacity: 0.5; transform: scale(1.3); }
            100% { opacity: 0.8; transform: scale(1.7); }
        }
        
        @keyframes borderPulse {
            0% { opacity: 0.5; }
            100% { opacity: 0.9; }
        }
        
        @media (max-width: 768px) {
            .success-container {
                padding: 30px;
                max-width: 90%;
            }
            
            h1 {
                font-size: 22px;
            }
            
            .success-icon {
                font-size: 60px;
            }
        }
        
        @media (max-width: 480px) {
            .success-container {
                padding: 20px;
            }
            
            h1 {
                font-size: 18px;
            }
            
            p {
                font-size: 14px;
            }
            
            .success-icon {
                font-size: 50px;
            }
            
            .option-button {
                padding: 10px 15px;
                font-size: 14px;
            }
        }
    </style>
</head>
<body>
    <!-- Background Elements -->
    <div class="background-elements">
        <div class="cyber-circle"></div>
        <div class="cyber-circle small-circle"></div>
        <div class="cyber-circle" style="width: 400px; height: 400px; top: 60%; left: 70%; border-color: #ff0000;"></div>
        <div class="cyber-line line1"></div>
        <div class="cyber-line line2"></div>
        <div class="cyber-line line3"></div>
        <div class="cyber-grid"></div>
    </div>
    
    <div class="success-container">
        <button id="theme-toggle" class="theme-toggle" title="Toggle Theme">
            <i class="fas fa-moon"></i>
        </button>
        
        <div class="success-icon">
            <i class="fas fa-check-circle"></i>
        </div>
        
        <h1>ADMIN ACCOUNT CREATED</h1>
        <p>The new administrator account <span class="admin-name"><%= adminName %></span> has been created successfully. They can now log in with their credentials to access the admin panel.</p>
        
        <div class="options-container">
            <a href="dashboard.jsp" class="option-button primary-btn">
                <i class="fas fa-tachometer-alt"></i> BACK TO DASHBOARD
            </a>
            <a href="../home.jsp" class="option-button outline-btn">
                <i class="fas fa-home"></i> GO TO HOMEPAGE
            </a>
            <a href="../auth/logout" class="option-button danger-btn">
                <i class="fas fa-sign-out-alt"></i> LOGOUT
            </a>
        </div>
    </div>
    
    <script>
        // Theme toggle functionality
        const themeToggle = document.getElementById('theme-toggle');
        const themeIcon = themeToggle.querySelector('i');
        const htmlElement = document.querySelector('html');
        
        // Check for saved theme preference
        const savedTheme = localStorage.getItem('theme');
        if (savedTheme === 'light') {
            htmlElement.classList.add('light-theme');
            themeIcon.className = 'fas fa-sun';
        }
        
        themeToggle.addEventListener('click', function() {
            // Toggle theme class
            htmlElement.classList.toggle('light-theme');
            
            // Update button icon and save preference
            if (htmlElement.classList.contains('light-theme')) {
                themeIcon.className = 'fas fa-sun';
                localStorage.setItem('theme', 'light');
            } else {
                themeIcon.className = 'fas fa-moon';
                localStorage.setItem('theme', 'dark');
            }
        });
    </script>
</body>
</html> 