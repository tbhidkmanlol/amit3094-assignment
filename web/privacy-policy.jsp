<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Privacy Policy - PocketGadget</title>
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

            .privacy-card {
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
            <div class="privacy-card">
                <div class="header">
                    <div class="logo-container">
                        <img src="Images/logo.png" alt="PocketGadget Logo" class="logo">
                    </div>
                    <h1 class="title">Privacy Policy</h1>
                </div>
                
                <p>At PocketGadget, we are committed to protecting your privacy and ensuring the security of your personal information. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you visit our website or make a purchase.</p>
                
                <h2>1. Information We Collect</h2>
                
                <h3>1.1 Personal Information</h3>
                <p>We may collect the following types of personal information when you register, make a purchase, or otherwise interact with our website:</p>
                <ul>
                    <li>Contact information (name, email address, phone number, shipping and billing address)</li>
                    <li>Account credentials (username and password)</li>
                    <li>Payment information (credit card details, payment method)</li>
                    <li>Purchase history and preferences</li>
                    <li>Communications with our customer service team</li>
                </ul>
                
                <h3>1.2 Automatically Collected Information</h3>
                <p>When you visit our website, we may automatically collect certain information about your device and browsing actions, including:</p>
                <ul>
                    <li>IP address and device identifiers</li>
                    <li>Browser type and version</li>
                    <li>Operating system</li>
                    <li>Pages visited and time spent on those pages</li>
                    <li>Referring website or source</li>
                    <li>Clickstream data and interaction with our site</li>
                </ul>
                
                <h2>2. How We Use Your Information</h2>
                <p>We use the information we collect for various purposes, including:</p>
                <ul>
                    <li>Processing and fulfilling your orders</li>
                    <li>Creating and managing your account</li>
                    <li>Providing customer support</li>
                    <li>Sending transactional emails (order confirmations, shipping updates)</li>
                    <li>Sending promotional communications (if you've opted in)</li>
                    <li>Improving our website, products, and services</li>
                    <li>Detecting and preventing fraud or unauthorized access</li>
                    <li>Complying with legal obligations</li>
                </ul>
                
                <h2>3. Cookies and Tracking Technologies</h2>
                <p>We use cookies and similar tracking technologies to collect information about your browsing activities. These technologies help us analyze website traffic, customize content, and enhance your shopping experience.</p>
                
                <p>You can control cookies through your browser settings. However, disabling cookies may limit your ability to use certain features of our website.</p>
                
                <h2>4. Information Sharing and Disclosure</h2>
                <p>We may share your personal information with:</p>
                <ul>
                    <li><strong>Service Providers:</strong> Third-party companies that help us operate our website, process payments, fulfill orders, and deliver products to you</li>
                    <li><strong>Business Partners:</strong> Trusted partners who provide services or products that complement our offerings</li>
                    <li><strong>Legal Authorities:</strong> When required by law, court order, or government regulation</li>
                    <li><strong>Business Transfers:</strong> In connection with a merger, acquisition, or sale of all or part of our business</li>
                </ul>
                
                <p>We do not sell your personal information to third parties for their marketing purposes without your explicit consent.</p>
                
                <h2>5. Data Security</h2>
                <p>We implement appropriate technical and organizational measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction. However, no method of transmission over the Internet or electronic storage is 100% secure, and we cannot guarantee absolute security.</p>
                
                <h2>6. Data Retention</h2>
                <p>We retain your personal information for as long as necessary to fulfill the purposes outlined in this Privacy Policy, unless a longer retention period is required or permitted by law.</p>
                
                <h2>7. Your Rights and Choices</h2>
                <p>Depending on your location, you may have certain rights regarding your personal information, including:</p>
                <ul>
                    <li>Accessing your personal information</li>
                    <li>Correcting inaccurate information</li>
                    <li>Deleting your personal information</li>
                    <li>Objecting to certain processing activities</li>
                    <li>Withdrawing consent (where applicable)</li>
                    <li>Data portability</li>
                </ul>
                
                <p>To exercise these rights, please contact us using the information provided in the "Contact Us" section below.</p>
                
                <h2>8. Children's Privacy</h2>
                <p>Our website is not intended for individuals under the age of 13. We do not knowingly collect personal information from children under 13. If you believe a child under 13 has provided us with personal information, please contact us immediately.</p>
                
                <h2>9. International Data Transfers</h2>
                <p>Your information may be transferred to and processed in countries other than your country of residence. These countries may have different data protection laws than your country. We ensure that appropriate safeguards are in place to protect your information when transferred internationally.</p>
                
                <h2>10. Changes to This Privacy Policy</h2>
                <p>We may update this Privacy Policy from time to time to reflect changes in our practices or for other operational, legal, or regulatory reasons. The revised policy will be posted on this page with an updated "Last Updated" date. We encourage you to review this Privacy Policy periodically.</p>
                
                <h2>11. Contact Us</h2>
                <p>If you have any questions, concerns, or requests regarding this Privacy Policy or our privacy practices, please contact us at:</p>
                <p>
                    <strong>PocketGadget</strong><br>
                    Email: privacy@PocketGadget.com<br>
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