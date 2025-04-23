<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login Error - Cyberpunk Tech</title>
    <link rel="stylesheet" href="login.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
</head>
<body>
    <!-- Video Background -->
    <video autoplay muted loop id="background-video">
        <source src="Images/loginBackground.mp4" type="video/mp4">
    </video>
    
    <!-- Background Elements -->
    <div class="background-elements">
        <div class="cyber-grid"></div>
        <div class="cyber-circle"></div>
        <div class="cyber-circle"></div>
        <div class="cyber-line line1"></div>
        <div class="cyber-line line2"></div>
        <div class="cyber-line line3"></div>
        <div class="cyber-line line4"></div>
        <div class="cyber-circle small-circle"></div>
        <div class="binary-overlay"></div>
    </div>

    <div class="auth-container">
        <div class="auth-box">
            <header class="auth-header">
                <div class="logo-container">
                    <img src="Images/logo.png" alt="Logo" class="logo">
                    <div class="logo-glitch-effect"></div>
                </div>
                <h1 class="auth-title cyber-text glitch" data-text="ERROR">
                    <span>System Error</span>
                </h1>
                <div class="cyber-subtitle">Authentication Failed</div>
            </header>

            <div class="error-container">
                <div class="cyber-alert">
                    <i class="fas fa-exclamation-triangle"></i>
                    <span>
                        <%
                        String errorCode = request.getParameter("code");
                        String errorMessage = "An unknown error occurred during authentication.";
                        
                        if ("1".equals(errorCode)) {
                            errorMessage = "Invalid username or password. Please try again.";
                        } else if ("username_taken".equals(errorCode)) {
                            errorMessage = "Username already exists. Please choose another one.";
                        } else if ("registration".equals(errorCode)) {
                            errorMessage = "Registration failed. Please try again.";
                        } else if ("unauthorized".equals(errorCode)) {
                            errorMessage = "You are not authorized to access this resource.";
                        } else if ("session_expired".equals(errorCode)) {
                            errorMessage = "Your session has expired. Please log in again.";
                        }
                        %>
                        <%= errorMessage %>
                    </span>
                </div>
                
                <div class="cyber-button-container">
                    <a href="login.jsp" class="cyber-button">
                        <span class="cyber-button-text">RETURN TO LOGIN</span>
                        <span class="cyber-button-glitch"></span>
                    </a>
                </div>
                
                <div class="help-text">
                    <p>If you continue to experience issues, please contact support.</p>
                    <p>Error Code: <%= errorCode != null ? errorCode : "UNKNOWN" %></p>
                </div>
            </div>

            <footer class="cyber-footer">
                <div class="back-to-home">
                    <a href="home.jsp">
                        <i class="fas fa-arrow-left"></i> Return to Main Grid
                    </a>
                </div>
            </footer>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Glitch effect
            const glitchTitle = document.querySelector('.glitch');
            function randomGlitch() {
                glitchTitle.classList.add('active-glitch');
                setTimeout(() => {
                    glitchTitle.classList.remove('active-glitch');
                }, 200);
            }
            
            // Trigger glitch effect more frequently for error page
            setInterval(randomGlitch, 1500 + Math.random() * 2000);
        });
    </script>
</body>
</html>