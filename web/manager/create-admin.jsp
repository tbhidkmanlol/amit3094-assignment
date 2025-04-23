<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Admin Account</title>
    <link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@400;500;700&display=swap" rel="stylesheet">
    <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
    <link rel="stylesheet" href="create-admin.css">
</head>
<%
    // Authentication check
    User user = (User) session.getAttribute("user");
    if (user == null || !"MANAGER".equals(user.getRole())) {
        response.sendRedirect("../login.jsp?error=unauthorized");
        return;
    }

    // Check if there's a success message
    String success = request.getParameter("success");
    String error = request.getParameter("error");
%>
<body>
    <div class="background-elements">
        <div class="cyber-circle"></div>
        <div class="cyber-circle small-circle"></div>
        <div class="cyber-circle" style="width: 400px; height: 400px; top: 60%; left: 70%; border-color: #00ffcc;"></div>
        <div class="cyber-line line1"></div>
        <div class="cyber-line line2"></div>
        <div class="cyber-line line3"></div>
        <div class="cyber-grid"></div>
    </div>

    <div class="create-admin-container">
        <div class="create-admin-box">
            <div class="create-admin-header">
                <h1 class="create-admin-title cyber-text glitch" data-text="CREATE ADMIN">CREATE ADMIN</h1>
                <p class="cyber-subtitle">MANAGEMENT CONSOLE</p>
            </div>

            <% if (error != null) { %>
                <div class="cyber-alert">
                    <i class='bx bx-error-circle'></i>
                    <% if ("username_exists".equals(error)) { %>
                        This username already exists. Please choose another one.
                    <% } else if ("password_mismatch".equals(error)) { %>
                        Passwords do not match. Please try again.
                    <% } else { %>
                        An error occurred. Please try again.
                    <% } %>
                </div>
            <% } %>

            <% if (success != null && "true".equals(success)) { %>
                <div class="cyber-alert success">
                    <i class='bx bx-check-circle'></i>
                    Admin account created successfully!
                </div>
            <% } %>

            <form action="../createAdmin" method="post" id="createAdminForm">
                <div class="cyber-input-group">
                    <i class='bx bx-user cyber-input-icon'></i>
                    <input type="text" class="cyber-input" id="username" name="username" placeholder="Username" required>
                    <div class="cyber-input-border"></div>
                </div>

                <div class="cyber-input-group">
                    <i class='bx bx-lock-alt cyber-input-icon'></i>
                    <input type="password" class="cyber-input" id="password" name="password" placeholder="Password" required>
                    <div class="cyber-input-border"></div>
                    <div class="password-feedback" id="passwordStrength"></div>
                </div>

                <div class="cyber-input-group">
                    <i class='bx bx-lock cyber-input-icon'></i>
                    <input type="password" class="cyber-input" id="confirmPassword" name="confirmPassword" placeholder="Confirm Password" required>
                    <div class="cyber-input-border"></div>
                    <div class="password-feedback" id="passwordMatch"></div>
                </div>

                <button type="submit" class="cyber-button">
                    <span class="cyber-button-text">CREATE ACCOUNT</span>
                    <div class="cyber-button-glitch"></div>
                </button>
            </form>

            <div class="cyber-footer">
                <div class="back-to-dashboard">
                    <a href="dashboard.jsp">
                        <i class='bx bx-left-arrow-alt'></i> Back to Dashboard
                    </a>
                </div>
                <button class="theme-toggle">
                    <i class='bx bx-moon'></i>
                    <span class="theme-text">Switch Theme</span>
                </button>
            </div>
        </div>
    </div>

    <script>
        // Password validation
        const passwordInput = document.getElementById('password');
        const confirmInput = document.getElementById('confirmPassword');
        const passwordStrength = document.getElementById('passwordStrength');
        const passwordMatch = document.getElementById('passwordMatch');

        passwordInput.addEventListener('input', function() {
            const password = this.value;
            
            // Check password strength
            if (password.length === 0) {
                passwordStrength.textContent = '';
                passwordStrength.className = 'password-feedback';
            } else if (password.length < 6) {
                passwordStrength.textContent = 'Weak password';
                passwordStrength.className = 'password-feedback weak';
            } else if (password.length < 10) {
                passwordStrength.textContent = 'Medium strength';
                passwordStrength.className = 'password-feedback medium';
            } else {
                passwordStrength.textContent = 'Strong password';
                passwordStrength.className = 'password-feedback strong';
            }
            
            // Check if passwords match
            if (confirmInput.value.length > 0) {
                checkPasswordMatch();
            }
        });

        confirmInput.addEventListener('input', checkPasswordMatch);

        function checkPasswordMatch() {
            if (passwordInput.value !== confirmInput.value) {
                passwordMatch.textContent = 'Passwords do not match';
                passwordMatch.className = 'password-feedback no-match';
            } else {
                passwordMatch.textContent = 'Passwords match';
                passwordMatch.className = 'password-feedback match';
            }
        }

        // Form validation
        document.getElementById('createAdminForm').addEventListener('submit', function(event) {
            if (passwordInput.value !== confirmInput.value) {
                event.preventDefault();
                passwordMatch.textContent = 'Passwords do not match';
                passwordMatch.className = 'password-feedback no-match';
            }
        });

        // Theme toggle
        const themeToggle = document.querySelector('.theme-toggle');
        const htmlElement = document.querySelector('html');
        const themeText = document.querySelector('.theme-text');
        const themeIcon = themeToggle.querySelector('i');

        // Check for saved theme preference
        const savedTheme = localStorage.getItem('theme');
        if (savedTheme === 'light') {
            htmlElement.classList.add('light-theme');
            themeText.textContent = 'Dark Mode';
            themeIcon.classList.remove('bx-moon');
            themeIcon.classList.add('bx-sun');
        }

        themeToggle.addEventListener('click', function() {
            htmlElement.classList.toggle('light-theme');
            
            // Update button text and icon
            if (htmlElement.classList.contains('light-theme')) {
                themeText.textContent = 'Dark Mode';
                themeIcon.classList.remove('bx-moon');
                themeIcon.classList.add('bx-sun');
                localStorage.setItem('theme', 'light');
            } else {
                themeText.textContent = 'Light Mode';
                themeIcon.classList.remove('bx-sun');
                themeIcon.classList.add('bx-moon');
                localStorage.setItem('theme', 'dark');
            }
        });

        // Glitch effect on hover
        const glitchElements = document.querySelectorAll('.glitch');
        
        glitchElements.forEach(element => {
            element.addEventListener('mouseenter', () => {
                element.classList.add('active-glitch');
            });
            
            element.addEventListener('mouseleave', () => {
                element.classList.remove('active-glitch');
                setTimeout(() => {
                    element.classList.remove('active-glitch');
                }, 400);
            });
        });
    </script>
</body>
</html>