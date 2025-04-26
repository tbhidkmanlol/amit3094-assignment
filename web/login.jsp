<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login / Register - PocketGadget</title>
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
                <% if (request.getParameter("error") != null) { 
                    String errorType = request.getParameter("error");
                    String errorMessage = "Invalid username or password. Please try again.";
                    
                    if ("username_taken".equals(errorType)) {
                        errorMessage = "Username already exists. Please choose another one.";
                    } else if ("registration".equals(errorType)) {
                        errorMessage = "Registration failed. Please try again.";
                    } else if ("system".equals(errorType)) {
                        errorMessage = "System error occurred. Please try again later.";
                    } else if ("unauthorized".equals(errorType)) {
                        errorMessage = "Unauthorized access. Please log in with proper credentials.";
                    }
                %>
                <div class="cyber-alert">
                    <i class="fas fa-exclamation-triangle"></i>
                    <span><%= errorMessage %></span>
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
                        <i class="fas fa-id-card cyber-input-icon"></i>
                        <input type="text" name="fullName" id="fullName" class="cyber-input" placeholder="Full Name" required>
                        <span class="cyber-input-border"></span>
                        <div class="input-feedback" id="name-feedback"></div>
                    </div>
                    
                    <div class="cyber-input-group">
                        <i class="fas fa-phone cyber-input-icon"></i>
                        <input type="tel" name="phone" id="phone" class="cyber-input" placeholder="Contact Number" 
                               pattern="[0-9]{10,15}" title="Phone number should be between 10-15 digits" required>
                        <span class="cyber-input-border"></span>
                        <div class="input-feedback" id="phone-feedback"></div>
                    </div>
                    
                    <div class="cyber-input-group">
                        <i class="fas fa-envelope cyber-input-icon"></i>
                        <input type="email" name="email" id="email" class="cyber-input" placeholder="Email Address" required>
                        <span class="cyber-input-border"></span>
                        <div class="input-feedback" id="email-feedback"></div>
                    </div>
                    
                    <div class="cyber-input-group">
                        <i class="fas fa-user cyber-input-icon"></i>
                        <input type="text" name="username" id="reg-username" class="cyber-input" placeholder="Username" 
                               pattern=".{5,50}" title="Username should be between 5-50 characters" required>
                        <span class="cyber-input-border"></span>
                        <div class="input-feedback" id="username-feedback"></div>
                    </div>

                    <div class="cyber-input-group">
                        <i class="fas fa-lock cyber-input-icon"></i>
                        <input type="password" name="password" id="password" class="cyber-input" placeholder="Password" 
                               pattern=".{8,50}" title="Password should be at least 8 characters" required>
                        <span class="cyber-input-border"></span>
                        <div class="input-feedback" id="password-feedback"></div>
                    </div>

                    <div class="cyber-input-group">
                        <i class="fas fa-check-circle cyber-input-icon"></i>
                        <input type="password" id="confirm_password" class="cyber-input" placeholder="Confirm Password" required>
                        <span class="cyber-input-border"></span>
                        <div class="input-feedback" id="confirm-password-feedback"></div>
                    </div>

                    <!-- Confirmation Section -->
                    <div id="confirmation-section" class="hidden">
                        <h3 class="cyber-text">Confirm Your Details</h3>
                        <div class="confirmation-details">
                            <p><strong>Full Name:      </strong> <span id="confirm-name"></span></p>
                            <p><strong>Contact Number: </strong> <span id="confirm-phone"></span></p>
                            <p><strong>Email:          </strong> <span id="confirm-email"></span></p>
                            <p><strong>Username:       </strong> <span id="confirm-username"></span></p>
                        </div>
                        <div class="confirmation-buttons">
                            <button type="submit" class="cyber-button">
                                <span class="cyber-button-text">CONFIRM REGISTER</span>
                                <span class="cyber-button-glitch"></span>
                            </button>
                        </div>
                    </div>

                    <div class="terms-group" id="terms-group">
                        <label class="cyber-checkbox">
                            <input type="checkbox" name="terms" id="terms" required>
                            <span class="checkmark"></span>
                            I agree to the <a href="#">Terms of Service</a> and <a href="#">Privacy Policy</a>
                        </label>
                    </div>

                    <button type="button" id="verify-button" class="cyber-button">
                        <span class="cyber-button-text">VERIFY DETAILS</span>
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

            // Enhanced customer registration with validation
            const fullName = document.getElementById('fullName');
            const phone = document.getElementById('phone');
            const email = document.getElementById('email');
            const regUsername = document.getElementById('reg-username');
            const password = document.getElementById('password');
            const confirmPassword = document.getElementById('confirm_password');
            const verifyButton = document.getElementById('verify-button');
            const confirmationSection = document.getElementById('confirmation-section');
            const termsGroup = document.getElementById('terms-group');
            
            // Input validation feedback elements
            const nameFeedback = document.getElementById('name-feedback');
            const phoneFeedback = document.getElementById('phone-feedback');
            const emailFeedback = document.getElementById('email-feedback');
            const usernameFeedback = document.getElementById('username-feedback');
            const passwordFeedback = document.getElementById('password-feedback');
            const confirmPasswordFeedback = document.getElementById('confirm-password-feedback');
            
            // Confirmation display elements
            const confirmName = document.getElementById('confirm-name');
            const confirmPhone = document.getElementById('confirm-phone');
            const confirmEmail = document.getElementById('confirm-email');
            const confirmUsername = document.getElementById('confirm-username');
            
            // Input validation functions
            function validateName() {
                if (fullName.value.length < 2) {
                    nameFeedback.textContent = 'Name must be at least 2 characters';
                    nameFeedback.className = 'input-feedback error';
                    return false;
                } else {
                    nameFeedback.textContent = 'Valid name';
                    nameFeedback.className = 'input-feedback match';
                    return true;
                }
            }
            
            function validatePhone() {
                const phoneRegex = /^[0-9]{10,15}$/;
                if (!phoneRegex.test(phone.value)) {
                    phoneFeedback.textContent = 'Phone must be 10-15 digits';
                    phoneFeedback.className = 'input-feedback error';
                    return false;
                } else {
                    phoneFeedback.textContent = 'Valid phone number';
                    phoneFeedback.className = 'input-feedback match';
                    return true;
                }
            }
            
            function validateEmail() {
                const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                if (!emailRegex.test(email.value)) {
                    emailFeedback.textContent = 'Please enter a valid email';
                    emailFeedback.className = 'input-feedback error';
                    return false;
                } else {
                    emailFeedback.textContent = 'Valid email address';
                    emailFeedback.className = 'input-feedback match';
                    return true;
                }
            }
            
            function validateUsername() {
                if (regUsername.value.length < 5) {
                    usernameFeedback.textContent = 'Username must be at least 5 characters';
                    usernameFeedback.className = 'input-feedback error';
                    return false;
                } else {
                    usernameFeedback.textContent = 'Valid username';
                    usernameFeedback.className = 'input-feedback match';
                    return true;
                }
            }
            
            function validatePassword() {
                if (password.value.length < 8) {
                    passwordFeedback.textContent = 'Password must be at least 8 characters';
                    passwordFeedback.className = 'input-feedback error';
                    return false;
                } else {
                    passwordFeedback.textContent = 'Valid password';
                    passwordFeedback.className = 'input-feedback match';
                    return true;
                }
            }
            
            function validateConfirmPassword() {
                if (confirmPassword.value === '') {
                    confirmPasswordFeedback.textContent = '';
                    confirmPasswordFeedback.className = 'input-feedback';
                    return false;
                } else if (password.value === confirmPassword.value) {
                    confirmPasswordFeedback.textContent = 'Passwords match';
                    confirmPasswordFeedback.className = 'input-feedback match';
                    return true;
                } else {
                    confirmPasswordFeedback.textContent = 'Passwords do not match';
                    confirmPasswordFeedback.className = 'input-feedback error';
                    return false;
                }
            }
            
            // Add validation event listeners
            fullName.addEventListener('input', validateName);
            phone.addEventListener('input', validatePhone);
            email.addEventListener('input', validateEmail);
            regUsername.addEventListener('input', validateUsername);
            password.addEventListener('input', function() {
                validatePassword();
                if (confirmPassword.value !== '') {
                    validateConfirmPassword();
                }
            });
            confirmPassword.addEventListener('input', validateConfirmPassword);
            
            // Verification process
            verifyButton.addEventListener('click', function() {
                const isNameValid = validateName();
                const isPhoneValid = validatePhone();
                const isEmailValid = validateEmail();
                const isUsernameValid = validateUsername();
                const isPasswordValid = validatePassword();
                const isConfirmPasswordValid = validateConfirmPassword();
                const isTermsChecked = document.getElementById('terms').checked;
                
                if (isNameValid && isPhoneValid && isEmailValid && isUsernameValid 
                    && isPasswordValid && isConfirmPasswordValid && isTermsChecked) {
                    
                    // Show confirmation section
                    confirmName.textContent = fullName.value;
                    confirmPhone.textContent = phone.value;
                    confirmEmail.textContent = email.value;
                    confirmUsername.textContent = regUsername.value;
                    
                    verifyButton.classList.add('hidden');
                    termsGroup.classList.add('hidden');
                    confirmationSection.classList.remove('hidden');
                } else {
                    // Highlight any missing fields
                    if (!isTermsChecked) {
                        alert('Please accept the Terms and Conditions');
                    }
                }
            });
            
            // Remove reference to the edit details button which was deleted
            // But keep the registration form submission validation
            document.getElementById('registration-form').addEventListener('submit', function(event) {
                if (!validateConfirmPassword()) {
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