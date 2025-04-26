<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%
    // Check if user is logged in
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp?error=unauthorized");
        return;
    }
    
    // Get error message if available
    String errorMsg = request.getParameter("error");
    if (errorMsg == null || errorMsg.trim().isEmpty()) {
        errorMsg = "An unknown error occurred during password update";
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Password Change Failed</title>
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
            --error-color: #ff0055;
            --error-bg: rgba(255, 0, 85, 0.1);
            --border-glow: 0 0 5px #ff0000, 0 0 10px rgba(255, 69, 0, 0.7);
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
            --error-color: #ff0044;
            --error-bg: rgba(255, 0, 68, 0.1);
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
        
        .error-container {
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
        
        .error-container::before {
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
        
        .error-icon {
            font-size: 80px;
            color: var(--error-color);
            margin-bottom: 20px;
            position: relative;
            display: inline-block;
            animation: iconPulse 2s infinite alternate;
        }
        
        .error-icon::after {
            content: '';
            position: absolute;
            width: 100%;
            height: 100%;
            background: radial-gradient(circle, var(--error-bg) 30%, transparent 70%);
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
        
        p {
            font-size: 16px;
            margin-bottom: 25px;
            line-height: 1.6;
            opacity: 0.9;
        }
        
        .error-message {
            background-color: rgba(255, 0, 0, 0.1);
            border: 1px solid rgba(255, 0, 0, 0.2);
            border-radius: 5px;
            padding: 15px;
            margin-bottom: 25px;
            font-family: monospace;
            font-size: 14px;
            text-align: left;
            color: var(--error-color);
        }
        
        .security-warning {
            background-color: rgba(255, 0, 0, 0.15);
            border: 1px solid rgba(255, 0, 0, 0.3);
            border-radius: 5px;
            padding: 15px;
            margin: 25px 0;
            text-align: left;
            color: var(--error-color);
            display: flex;
            align-items: center;
        }
        
        .security-warning i {
            font-size: 24px;
            margin-right: 15px;
        }
        
        .btn {
            display: inline-block;
            padding: 12px 30px;
            background: var(--btn-bg);
            color: var(--btn-text);
            border: none;
            border-radius: 5px;
            font-family: 'Orbitron', sans-serif;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            text-transform: uppercase;
            letter-spacing: 1px;
            box-shadow: var(--cyber-glow);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        
        .btn:hover {
            transform: translateY(-3px);
            box-shadow: var(--cyber-glow-intense);
        }
        
        .btn::after {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: linear-gradient(rgba(255, 255, 255, 0.2), transparent);
            transform: rotate(30deg);
            transition: all 0.3s ease;
        }
        
        .btn:hover::after {
            transform: rotate(30deg) translateY(-50px);
        }
        
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        @keyframes pulsate {
            from { transform: scale(1); opacity: 0.2; }
            to { transform: scale(1.05); opacity: 0.3; }
        }
        
        @keyframes borderPulse {
            from { opacity: 0.4; }
            to { opacity: 0.8; }
        }
        
        @keyframes iconPulse {
            from { transform: scale(1); }
            to { transform: scale(1.1); }
        }
        
        @keyframes glowPulse {
            from { opacity: 0.5; transform: scale(1.3); }
            to { opacity: 0.7; transform: scale(1.7); }
        }
    </style>
</head>
<body>
    <div class="background-elements">
        <div class="cyber-circle"></div>
        <div class="cyber-circle"></div>
        <div class="cyber-circle small-circle"></div>
    </div>
    
    <div class="error-container">
        <div class="error-icon">
            <i class="fas fa-exclamation-triangle"></i>
        </div>
        <h1>Password Change Failed</h1>
        <p>We were unable to update your password. There might be an issue with your credentials.</p>
        
        <div class="error-message">
            <%= errorMsg %>
        </div>
        
        <div class="security-warning">
            <i class="fas fa-shield-alt"></i>
            <div>
                <strong>Security Alert:</strong> We suspect that you may not be the account owner. For your account security, please log in again to verify your identity.
            </div>
        </div>
        
        <a href="${pageContext.request.contextPath}/auth/logout" class="btn">Log Out & Verify Identity</a>
    </div>
    
    <script>
        // Apply system theme if available
        if (window.matchMedia && window.matchMedia('(prefers-color-scheme: light)').matches) {
            document.documentElement.classList.add('light-theme');
        }
        
        // Listen for system theme changes
        window.matchMedia('(prefers-color-scheme: light)').addEventListener('change', event => {
            if (event.matches) {
                document.documentElement.classList.add('light-theme');
            } else {
                document.documentElement.classList.remove('light-theme');
            }
        });
    </script>
</body>
</html> 