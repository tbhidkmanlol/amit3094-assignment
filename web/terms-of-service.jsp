<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Terms of Service - PocketGadget</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@400;500;600;700;800;900&family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <style>
            /* Root Variables - Matching cyberpunk theme */
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
                --error-color: #ff0055;
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
            }

            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Poppins', sans-serif;
                background-color: var(--bg-color);
                color: var(--text-color);
                min-height: 100vh;
                position: relative;
                padding: 0;
                overflow-x: hidden;
            }

            body::before {
                content: '';
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: linear-gradient(rgba(0, 0, 0, 0.8), rgba(0, 0, 0, 0.7)), 
                            url('Images/HomeBackground.jpg');
                background-size: cover;
                background-position: center;
                z-index: -1;
                filter: brightness(0.7) contrast(1.1);
            }

            .cyber-grid {
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background-image: 
                    linear-gradient(rgba(255, 0, 0, 0.05) 1px, transparent 1px),
                    linear-gradient(90deg, rgba(255, 0, 0, 0.05) 1px, transparent 1px);
                background-size: 30px 30px;
                z-index: -1;
            }

            .container {
                max-width: 1000px;
                margin: 0 auto;
                padding: 40px 20px;
            }

            .terms-card {
                background-color: var(--card-bg);
                border: 1px solid var(--card-border);
                border-radius: 8px;
                box-shadow: var(--shadow), 0 0 20px rgba(255, 69, 0, 0.2);
                padding: 40px;
                margin-bottom: 40px;
                backdrop-filter: blur(10px);
            }

            .header {
                text-align: center;
                margin-bottom: 40px;
                position: relative;
            }

            .logo-container {
                display: flex;
                justify-content: center;
                margin-bottom: 15px;
            }

            .logo {
                height: 80px;
                filter: drop-shadow(var(--cyber-glow));
            }

            .title {
                font-family: 'Orbitron', sans-serif;
                font-size: 32px;
                font-weight: 700;
                color: var(--heading-color);
                text-transform: uppercase;
                margin-bottom: 10px;
                letter-spacing: 2px;
                text-shadow: var(--cyber-glow-intense);
            }

            h2 {
                font-family: 'Orbitron', sans-serif;
                font-size: 24px;
                color: var(--accent-color);
                margin: 30px 0 15px;
                text-shadow: var(--cyber-glow);
            }

            h3 {
                font-family: 'Orbitron', sans-serif;
                font-size: 18px;
                margin: 20px 0 10px;
            }

            p, ul, ol {
                line-height: 1.8;
                margin-bottom: 15px;
                font-size: 15px;
            }

            ul, ol {
                padding-left: 25px;
            }

            li {
                margin-bottom: 10px;
            }

            .highlight {
                color: var(--accent-color);
                font-weight: 500;
            }

            .effective-date {
                text-align: center;
                margin-top: 30px;
                font-style: italic;
                font-size: 14px;
                opacity: 0.8;
            }

            .back-btn {
                display: inline-block;
                padding: 10px 25px;
                background: var(--btn-bg);
                color: var(--btn-text);
                text-decoration: none;
                border-radius: 4px;
                font-family: 'Orbitron', sans-serif;
                font-size: 14px;
                font-weight: 600;
                margin-top: 20px;
                letter-spacing: 1px;
                transition: all 0.3s;
                box-shadow: var(--cyber-glow);
            }

            .back-btn:hover {
                box-shadow: var(--cyber-glow-intense);
                transform: translateY(-2px);
            }

            .back-btn i {
                margin-right: 8px;
            }

            /* Theme toggle button */
            .theme-toggle {
                position: fixed;
                top: 20px;
                right: 20px;
                background: transparent;
                border: 2px solid var(--accent-color);
                color: var(--accent-color);
                width: 40px;
                height: 40px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                cursor: pointer;
                z-index: 100;
                transition: all 0.3s ease;
                box-shadow: var(--cyber-glow);
            }

            .theme-toggle:hover {
                transform: scale(1.1);
                box-shadow: var(--cyber-glow-intense);
            }

            /* Cyber elements */
            .cyber-line {
                position: fixed;
                height: 2px;
                background: linear-gradient(90deg, transparent, var(--accent-color), transparent);
                opacity: 0.4;
                filter: blur(1px);
                z-index: -1;
            }

            .line1 {
                width: 100%;
                top: 20%;
                left: 0;
                animation: flow 10s infinite linear;
            }

            .line2 {
                width: 80%;
                top: 50%;
                right: 0;
                animation: flow 8s infinite linear;
            }

            .line3 {
                width: 60%;
                bottom: 30%;
                left: 10%;
                animation: flow 12s infinite linear;
            }

            @keyframes flow {
                0% { transform: translateX(-100%); }
                100% { transform: translateX(100%); }
            }
        </style>
    </head>
    <body>
        <!-- Theme Toggle Button -->
        <button class="theme-toggle" id="theme-toggle" title="Toggle light/dark mode">
            <i class="fas fa-sun"></i>
        </button>
        
        <!-- Cyberpunk background elements -->
        <div class="cyber-grid"></div>
        <div class="cyber-line line1"></div>
        <div class="cyber-line line2"></div>
        <div class="cyber-line line3"></div>
        
        <div class="container">
            <div class="terms-card">
                <div class="header">
                    <div class="logo-container">
                        <img src="Images/logo.png" alt="PocketGadget Logo" class="logo">
                    </div>
                    <h1 class="title">Terms of Service</h1>
                </div>
                
                <p>Welcome to PocketGadget. By accessing our website and using our services, you agree to comply with and be bound by the following terms and conditions. Please review these terms carefully before using our platform.</p>
                
                <h2>1. Acceptance of Terms</h2>
                <p>By accessing or using PocketGadget's website, mobile applications, or any other service provided by PocketGadget (collectively, the "Services"), you agree to be bound by these Terms of Service and all applicable laws and regulations. If you do not agree with any of these terms, you are prohibited from using or accessing our Services.</p>
                
                <h2>2. User Accounts</h2>
                <p>To access certain features of our Services, you may be required to create an account. You agree to provide accurate, current, and complete information during the registration process and to update such information to keep it accurate, current, and complete. You are solely responsible for:</p>
                <ul>
                    <li>Maintaining the confidentiality of your account and password</li>
                    <li>Restricting access to your computer or device</li>
                    <li>Accepting responsibility for all activities that occur under your account</li>
                </ul>
                
                <h2>3. Products and Purchases</h2>
                <h3>3.1 Product Availability</h3>
                <p>All products displayed on our website are subject to availability. We reserve the right to discontinue any product at any time and to limit quantities of any product.</p>
                
                <h3>3.2 Pricing</h3>
                <p>All prices are displayed in Malaysian Ringgit (RM) and include applicable taxes unless otherwise stated. We reserve the right to change prices without notice at any time.</p>
                
                <h3>3.3 Order Acceptance</h3>
                <p>Receipt of your order confirmation does not constitute acceptance of your order. PocketGadget reserves the right to accept or decline any order for any reason.</p>
                
                <h3>3.4 Payment</h3>
                <p>We accept various payment methods as indicated on our checkout page. By submitting an order, you authorize us or our third-party payment processors to charge your chosen payment method for the total amount of your order.</p>
                
                <h2>4. Shipping and Delivery</h2>
                <p>PocketGadget aims to deliver products within the estimated delivery time specified during checkout. However, delivery times are not guaranteed and may vary depending on your location and other factors outside our control.</p>
                
                <h2>5. Returns and Refunds</h2>
                <p>For details on our return and refund policies, please refer to our separate <span class="highlight">Returns and Refunds Policy</span> available on our website.</p>
                
                <h2>6. Intellectual Property</h2>
                <p>All content on our website, including but not limited to text, graphics, logos, images, audio clips, digital downloads, and software, is the property of PocketGadget or its content suppliers and is protected by international copyright laws.</p>
                
                <h2>7. User Conduct</h2>
                <p>When using our Services, you agree not to:</p>
                <ul>
                    <li>Use the Services for any illegal purpose or in violation of any local, state, national, or international law</li>
                    <li>Violate or infringe upon the rights of others, including intellectual property rights</li>
                    <li>Attempt to circumvent, disable, or interfere with security-related features of the Services</li>
                    <li>Use automated means, including spiders, robots, crawlers, or data mining tools, to download data from the website</li>
                    <li>Introduce any viruses, Trojan horses, worms, or other malicious or harmful material</li>
                </ul>
                
                <h2>8. Limitation of Liability</h2>
                <p>To the fullest extent permitted by applicable law, PocketGadget shall not be liable for any indirect, incidental, special, consequential, or punitive damages, or any loss of profits or revenues, whether incurred directly or indirectly, or any loss of data, use, goodwill, or other intangible losses resulting from:</p>
                <ul>
                    <li>Your use or inability to use the Services</li>
                    <li>Any unauthorized access to or use of our secure servers and/or any personal information stored therein</li>
                    <li>Any interruption or cessation of transmission to or from the Services</li>
                    <li>Any bugs, viruses, Trojan horses, or the like that may be transmitted to or through the Services by any third party</li>
                </ul>
                
                <h2>9. Modifications to Terms and Services</h2>
                <p>PocketGadget reserves the right to modify or replace these Terms of Service at any time. The most current version will always be available on our website. Your continued use of the Services after any changes constitutes acceptance of those changes.</p>
                
                <h2>10. Governing Law</h2>
                <p>These Terms of Service shall be governed by and construed in accordance with the laws of Malaysia, without regard to its conflict of law provisions.</p>
                
                <h2>11. Contact Information</h2>
                <p>If you have any questions about these Terms of Service, please contact us at:</p>
                <p>
                    <strong>PocketGadget</strong><br>
                    Email: support@PocketGadget.com<br>
                    Phone: +60 123456789
                </p>
                
                <p class="effective-date">Last Updated: April 26, 2025</p>
                
                <a href="login.jsp" class="back-btn"><i class="fas fa-arrow-left"></i> Back to Login</a>
            </div>
        </div>
        
        <script>
            // Theme toggle functionality
            const themeToggle = document.getElementById('theme-toggle');
            const themeIcon = themeToggle.querySelector('i');
            
            // Check if user has a previously saved theme preference
            const savedTheme = localStorage.getItem('theme');
            if (savedTheme === 'light') {
                applyTheme('light');
                themeIcon.className = 'fas fa-moon';
            } else {
                // Default is dark theme
                applyTheme('dark');
                themeIcon.className = 'fas fa-sun';
            }
            
            // Theme toggle click handler
            themeToggle.addEventListener('click', function() {
                const isLightTheme = document.documentElement.classList.contains('light-theme');
                
                if (isLightTheme) {
                    // Switch to dark theme
                    applyTheme('dark');
                    themeIcon.className = 'fas fa-sun';
                    localStorage.setItem('theme', 'dark');
                } else {
                    // Switch to light theme
                    applyTheme('light');
                    themeIcon.className = 'fas fa-moon';
                    localStorage.setItem('theme', 'light');
                }
            });
            
            // Function to apply theme
            function applyTheme(theme) {
                if (theme === 'light') {
                    document.documentElement.classList.add('light-theme');
                } else {
                    document.documentElement.classList.remove('light-theme');
                }
            }
        </script>
    </body>
</html>