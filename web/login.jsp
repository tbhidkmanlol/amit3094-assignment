<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login / Register - Cyberpunk Tech</title>
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
        
        <!-- Added more cyberpunk elements -->
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
                <h1 class="auth-title cyber-text glitch" data-text="ACCESS">
                    <span id="form-title">Login</span>
                </h1>
                <div class="cyber-subtitle">Enter The System</div>
            </header>

            <!-- Form Toggle -->
            <div class="form-toggle-container">
                <button id="login-toggle" class="toggle-btn active">Login</button>
                <button id="register-toggle" class="toggle-btn">Register</button>
            </div>

            <!-- Login Form -->
            <div id="login-form" class="form-container">
                <% if (request.getParameter("error") != null) { %>
                <div class="cyber-alert">
                    <i class="fas fa-exclamation-triangle"></i>
                    <span>Invalid username or password. Please try again.</span>
                </div>
                <% } %>
                
                <% if (request.getParameter("registered") != null) { %>
                <div class="cyber-alert success">
                    <i class="fas fa-check-circle"></i>
                    <span>Registration successful! You can now login.</span>
                </div>
                <% } %>
                
                <% if (request.getParameter("logout") != null) { %>
                <div class="cyber-alert success">
                    <i class="fas fa-check-circle"></i>
                    <span>You have been successfully logged out.</span>
                </div>
                <% } %>
                
                <% if (request.getParameter("checkout") != null) { %>
                <div class="cyber-alert">
                    <i class="fas fa-shopping-cart"></i>
                    <span>Please login or register to proceed with checkout.</span>
                </div>
                <% } %>

                <form action="auth/login" method="post">
                    <div class="cyber-input-group">
                        <i class="fas fa-user cyber-input-icon"></i>
                        <input type="text" name="username" class="cyber-input" placeholder="Username" required>
                        <span class="cyber-input-border"></span>
                    </div>

                    <div class="cyber-input-group">
                        <i class="fas fa-lock cyber-input-icon"></i>
                        <input type="password" name="password" class="cyber-input" placeholder="Password" required>
                        <span class="cyber-input-border"></span>
                    </div>

                    <div class="remember-group">
                        <label class="cyber-checkbox">
                            <input type="checkbox" name="remember">
                            <span class="checkmark"></span>
                            Remember me
                        </label>
                        <a href="#" class="forgot-link">Forgot password?</a>
                    </div>

                    <button type="submit" class="cyber-button">
                        <span class="cyber-button-text">ACCESS SYSTEM</span>
                        <span class="cyber-button-glitch"></span>
                    </button>
                </form>

                <div class="separator">
                    <span>OR</span>
                </div>

                <div class="social-login">
                    <a href="#" class="social-btn google">
                        <i class="fab fa-google"></i>
                    </a>
                    <a href="#" class="social-btn facebook">
                        <i class="fab fa-facebook-f"></i>
                    </a>
                    <a href="#" class="social-btn twitter">
                        <i class="fab fa-twitter"></i>
                    </a>
                </div>
            </div>

            <!-- Register Form -->
            <div id="register-form" class="form-container hidden">
                <form action="auth/register" method="post" id="registration-form">
                    <div class="cyber-input-group">
                        <i class="fas fa-user cyber-input-icon"></i>
                        <input type="text" name="username" class="cyber-input" placeholder="Username" required>
                        <span class="cyber-input-border"></span>
                    </div>

                    <div class="cyber-input-group">
                        <i class="fas fa-envelope cyber-input-icon"></i>
                        <input type="email" name="email" class="cyber-input" placeholder="Email Address" required>
                        <span class="cyber-input-border"></span>
                    </div>
                    
                    <div class="cyber-input-group">
                        <i class="fas fa-id-card cyber-input-icon"></i>
                        <input type="text" name="fullName" class="cyber-input" placeholder="Full Name" required>
                        <span class="cyber-input-border"></span>
                    </div>
                    
                    <div class="cyber-input-group">
                        <i class="fas fa-phone cyber-input-icon"></i>
                        <input type="tel" name="phone" class="cyber-input" placeholder="Phone Number" required>
                        <span class="cyber-input-border"></span>
                    </div>

                    <div class="cyber-input-group">
                        <i class="fas fa-lock cyber-input-icon"></i>
                        <input type="password" name="password" id="password" class="cyber-input" placeholder="Password" required>
                        <span class="cyber-input-border"></span>
                    </div>

                    <div class="cyber-input-group">
                        <i class="fas fa-check-circle cyber-input-icon"></i>
                        <input type="password" id="confirm_password" class="cyber-input" placeholder="Confirm Password" required>
                        <span class="cyber-input-border"></span>
                        <div class="password-feedback" id="password-feedback"></div>
                    </div>

                    <div class="terms-group">
                        <label class="cyber-checkbox">
                            <input type="checkbox" name="terms" required>
                            <span class="checkmark"></span>
                            I agree to the <a href="#">Terms of Service</a> and <a href="#">Privacy Policy</a>
                        </label>
                    </div>

                    <button type="submit" class="cyber-button" id="register-button">
                        <span class="cyber-button-text">CREATE IDENTITY</span>
                        <span class="cyber-button-glitch"></span>
                    </button>
                </form>
            </div>

            <footer class="cyber-footer">
                <div class="back-to-home">
                    <a href="home.jsp">
                        <i class="fas fa-arrow-left"></i> Return to Main Grid
                    </a>
                </div>
                <button id="theme-toggle" class="theme-toggle">
                    <i class="fas fa-moon"></i>
                    <span class="theme-text">Dark Mode</span>
                </button>
            </footer>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Form toggle functionality
            const loginToggle = document.getElementById('login-toggle');
            const registerToggle = document.getElementById('register-toggle');
            const loginForm = document.getElementById('login-form');
            const registerForm = document.getElementById('register-form');
            const formTitle = document.getElementById('form-title');

            loginToggle.addEventListener('click', function() {
                loginToggle.classList.add('active');
                registerToggle.classList.remove('active');
                loginForm.classList.remove('hidden');
                registerForm.classList.add('hidden');
                formTitle.textContent = 'Login';
            });

            registerToggle.addEventListener('click', function() {
                registerToggle.classList.add('active');
                loginToggle.classList.remove('active');
                registerForm.classList.remove('hidden');
                loginForm.classList.add('hidden');
                formTitle.textContent = 'Register';
            });

            // Password confirmation check
            const password = document.getElementById('password');
            const confirmPassword = document.getElementById('confirm_password');
            const passwordFeedback = document.getElementById('password-feedback');
            const registerButton = document.getElementById('register-button');

            function checkPasswords() {
                if (confirmPassword.value === '') {
                    passwordFeedback.textContent = '';
                    passwordFeedback.className = 'password-feedback';
                    return false;
                } else if (password.value === confirmPassword.value) {
                    passwordFeedback.textContent = 'Identities match';
                    passwordFeedback.className = 'password-feedback match';
                    return true;
                } else {
                    passwordFeedback.textContent = 'Identities do not match';
                    passwordFeedback.className = 'password-feedback no-match';
                    return false;
                }
            }

            confirmPassword.addEventListener('input', checkPasswords);
            password.addEventListener('input', function() {
                if (confirmPassword.value !== '') {
                    checkPasswords();
                }
            });

            // Registration form validation
            document.getElementById('registration-form').addEventListener('submit', function(event) {
                if (!checkPasswords()) {
                    event.preventDefault();
                    confirmPassword.focus();
                }
            });

            // Theme toggle functionality
            const themeToggle = document.getElementById('theme-toggle');
            const themeIcon = themeToggle.querySelector('i');
            const themeText = themeToggle.querySelector('.theme-text');

            themeToggle.addEventListener('click', function() {
                document.documentElement.classList.toggle('light-theme');
                
                if (document.documentElement.classList.contains('light-theme')) {
                    themeIcon.className = 'fas fa-sun';
                    themeText.textContent = 'Light Mode';
                } else {
                    themeIcon.className = 'fas fa-moon';
                    themeText.textContent = 'Dark Mode';
                }
            });

            // Enhanced cyberpunk glitch effect on buttons
            const cyberButtons = document.querySelectorAll('.cyber-button');
            cyberButtons.forEach(button => {
                button.addEventListener('mouseover', function() {
                    // Create the glitch effect
                    const buttonText = this.querySelector('.cyber-button-text');
                    const originalText = buttonText.textContent;
                    
                    // Quick text scramble animation
                    let iterations = 0;
                    const maxIterations = 2;
                    const interval = setInterval(() => {
                        buttonText.textContent = originalText
                            .split('')
                            .map((char, idx) => {
                                if (Math.random() < 0.3) {
                                    return String.fromCharCode(65 + Math.floor(Math.random() * 26));
                                }
                                return char;
                            })
                            .join('');
                        
                        iterations++;
                        if (iterations >= maxIterations) {
                            clearInterval(interval);
                            buttonText.textContent = originalText;
                        }
                    }, 100);
                });
            });

            // Random glitch animation on the page title
            const glitchTitle = document.querySelector('.glitch');
            function randomGlitch() {
                glitchTitle.classList.add('active-glitch');
                setTimeout(() => {
                    glitchTitle.classList.remove('active-glitch');
                }, 200);
            }
            
            // Random glitch intervals
            setInterval(randomGlitch, 3000 + Math.random() * 5000);
        });
    </script>
</body>
</html>