<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%
    // Check if user is logged in
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp?error=unauthorized");
        return;
    }
    
    // Determine the redirect URL
    String redirectUrl = "";
    if ("MANAGER".equals(user.getRole())) {
        redirectUrl = "manager/dashboard.jsp";
    } else if ("ADMIN".equals(user.getRole())) {
        redirectUrl = "admin/dashboard.jsp";
    } else if ("CUSTOMER".equals(user.getRole())) {
        redirectUrl = "customer/dashboard.jsp";
    } else {
        redirectUrl = "home.jsp";
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Password Changed Successfully</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg-color: black;
            --text-color: #fff;
            --heading-color: #fff;
            --card-bg: rgba(20, 20, 20, 0.8);
            --card-border: rgba(70, 255, 70, 0.3);
            --shadow: 0 0 10px rgba(0, 255, 0, 0.3);
            --btn-bg: linear-gradient(90deg, #00ff00, #45ff00);
            --btn-text: white;
            --cyber-glow: 0 0 5px #00ff00, 0 0 10px #45ff00;
            --cyber-glow-intense: 0 0 10px #00ff00, 0 0 20px #45ff00, 0 0 30px rgba(69, 255, 0, 0.5);
            --accent-color: #45ff00;
            --secondary-color: #00fff7;
            --input-bg: rgba(30, 30, 30, 0.8);
            --success-color: #00ff66;
            --success-bg: rgba(0, 255, 102, 0.1);
            --error-color: #ff0055;
            --border-glow: 0 0 5px #00ff00, 0 0 10px rgba(69, 255, 0, 0.7);
        }
        
        /* Light Theme */
        html.light-theme {
            --bg-color: #f5f5f5;
            --text-color: #333;
            --heading-color: #222;
            --card-bg: rgba(255, 255, 255, 0.9);
            --card-border: rgba(70, 255, 70, 0.2);
            --shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            --btn-bg: linear-gradient(90deg, #00cc00, #45ff00);
            --btn-text: white;
            --cyber-glow: 0 0 3px rgba(0, 255, 0, 0.3), 0 0 6px rgba(69, 255, 0, 0.2);
            --cyber-glow-intense: 0 0 5px rgba(0, 255, 0, 0.5), 0 0 10px rgba(69, 255, 0, 0.3);
            --input-bg: rgba(245, 245, 245, 0.9);
            --success-color: #00cc44;
            --success-bg: rgba(0, 204, 68, 0.1);
            --error-color: #ff0044;
            --border-glow: 0 0 3px rgba(0, 255, 0, 0.3), 0 0 5px rgba(69, 255, 0, 0.2);
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
        
        p {
            font-size: 16px;
            margin-bottom: 25px;
            line-height: 1.6;
            opacity: 0.9;
        }
        
        .redirect-message {
            font-size: 14px;
            margin-top: 25px;
            opacity: 0.7;
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
    
    <div class="success-container">
        <div class="success-icon">
            <i class="fas fa-check-circle"></i>
        </div>
        <h1>Password Changed Successfully</h1>
        <p>Your account password has been successfully updated. Please use your new password for future logins.</p>
        <div class="redirect-message">
            <i class="fas fa-sync fa-spin"></i> Redirecting to dashboard in <span id="countdown">3</span> seconds...
        </div>
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
        
        // Countdown and redirect
        let seconds = 3;
        const countdownElement = document.getElementById('countdown');
        const countdown = setInterval(function() {
            seconds--;
            countdownElement.textContent = seconds;
            if (seconds <= 0) {
                clearInterval(countdown);
                window.location.href = "<%= redirectUrl %>";
            }
        }, 1000);
        
        // Auto redirect after 3 seconds
        setTimeout(function() {
            window.location.href = "<%= redirectUrl %>";
        }, 3000);
    </script>
</body>
</html> 