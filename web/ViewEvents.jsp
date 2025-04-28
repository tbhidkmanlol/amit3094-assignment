<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en" class="dark-theme">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Special Events & Promotions - PocketGadget</title>
    <link rel="stylesheet" href="home.css">
    <!-- Add a custom stylesheet for events page -->
    <style>
        /* Event Specific CSS */
        .event-container {
            width: 90%;
            max-width: 1100px;
            margin: 40px auto;
            padding: 20px;
            background: var(--card-bg);
            border: 1px solid var(--card-border);
            border-radius: 10px;
            box-shadow: var(--shadow);
        }
        
        .event-card {
            margin-bottom: 40px;
            padding: 30px;
            border-radius: 8px;
            background: rgba(20, 20, 20, 0.5);
            border: 1px solid var(--card-border);
            box-shadow: var(--shadow);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        
        html.light-theme .event-card {
            background: rgba(245, 245, 245, 0.9);
        }
        
        .event-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(255, 0, 0, 0.3);
        }
        
        .event-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            border-bottom: 2px solid var(--card-border);
            padding-bottom: 10px;
        }
        
        .event-title {
            font-size: 24px;
            font-weight: bold;
            color: var(--heading-color);
            text-shadow: 0 0 5px rgba(255, 0, 0, 0.5);
        }
        
        .event-dates {
            background: linear-gradient(90deg, #ff0000, #ff4500);
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 14px;
            color: white;
        }
        
        .event-description {
            margin-bottom: 20px;
            line-height: 1.6;
        }
        
        .event-image {
            width: 100%;
            height: 300px;
            object-fit: cover;
            border-radius: 8px;
            margin-bottom: 20px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
        }
        
        .promo-features {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
            margin: 20px 0;
        }
        
        .promo-feature {
            padding: 20px;
            background: rgba(255, 69, 0, 0.1);
            border-radius: 8px;
            border: 1px solid rgba(255, 69, 0, 0.3);
            text-align: center;
            transition: transform 0.3s ease;
        }
        
        .promo-feature:hover {
            transform: translateY(-5px);
            background: rgba(255, 69, 0, 0.2);
        }
        
        .promo-feature i {
            font-size: 30px;
            margin-bottom: 10px;
            color: #ff4500;
        }
        
        .promo-feature h3 {
            margin-bottom: 10px;
        }
        
        .event-cta {
            text-align: center;
            margin-top: 30px;
        }
        
        .event-btn {
            background: var(--btn-bg);
            color: var(--btn-text);
            padding: 10px 25px;
            border-radius: 25px;
            text-decoration: none;
            font-weight: bold;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
            display: inline-block;
            box-shadow: 0 5px 15px rgba(255, 0, 0, 0.3);
        }
        
        .event-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(255, 0, 0, 0.4);
        }
        
        /* Countdown Timer */
        .countdown {
            display: flex;
            justify-content: center;
            margin: 30px 0;
            gap: 15px;
        }
        
        .countdown-item {
            display: flex;
            flex-direction: column;
            align-items: center;
            background: rgba(20, 20, 20, 0.8);
            padding: 10px;
            border-radius: 8px;
            min-width: 80px;
            border: 1px solid var(--card-border);
        }
        
        html.light-theme .countdown-item {
            background: rgba(240, 240, 240, 0.8);
        }
        
        .countdown-value {
            font-size: 28px;
            font-weight: bold;
            color: #ff4500;
        }
        
        .countdown-label {
            font-size: 12px;
            color: var(--text-color);
        }
        
        @media (max-width: 768px) {
            .promo-features {
                grid-template-columns: 1fr;
            }
            
            .countdown {
                flex-wrap: wrap;
            }
        }
    </style>
    <link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@500&display=swap" rel="stylesheet">
    <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
    <script src="theme.js"></script>
</head>
<body>
    <!-- Header Section with theme-specific data attribute -->
    <header class="header" data-theme-target="header">
        <div class="left-section">
            <div class="logo">
                <a href="home.jsp" style="display: block;">
                    <img src="Images/logo.png" alt="Logo" />
                </a>
            </div>
            <div class="brand">
                <h1><a href="home.jsp" style="text-decoration: none; color: inherit;">PocketGadget</a></h1>
            </div>
        </div>

        <nav class="navbar">
            <ul>
                <li><a href="CartController">Products</a></li>
                <li><a href="cart.jsp" style="position: relative;">Cart
                        <% 
                            // Only show cart badge for regular users who are logged in
                            if (session.getAttribute("user") != null && "USER".equals(session.getAttribute("role"))) { 
                                Integer navCartCount = (Integer) session.getAttribute("cartCount");
                                if (navCartCount != null && navCartCount > 0) { 
                        %>
                            <span class="cart-badge"><%= navCartCount %></span>
                        <% 
                                }
                            } 
                        %>
                    </a>
                </li>
                <li><a href="AboutUs.jsp">About Us</a></li>
                <li><a href="contactus.jsp">Contact Us</a></li>
                
                <!-- Account Dropdown - Changes based on login status -->
                <li class="account-dropdown">
                    <% if (session.getAttribute("user") != null) { 
                       String username = (String)session.getAttribute("username");
                       String role = (String)session.getAttribute("role");
                    %>
                        <a href="#" class="dropdown-trigger">
                        <i class="bx bx-user-circle"></i> Welcome, <%= username %> <i class="bx bx-chevron-down"></i>
                        </a>
                        <div class="dropdown-content">
                        <% if ("ADMIN".equals(role)) { %>
                            <a href="home.jsp"><i class="bx bx-home"></i> Home</a>
                            <a href="admin/dashboard.jsp"><i class="bx bx-tachometer"></i> Admin Dashboard</a>
                            <a href="admin/dashboard.jsp?section=settings"><i class="bx bx-cog"></i> Settings</a>
                        <% } else if ("MANAGER".equals(role)) { %>
                            <a href="home.jsp"><i class="bx bx-home"></i> Home</a>
                            <a href="manager/dashboard.jsp"><i class="bx bx-tachometer"></i> Manager Dashboard</a>
                            <a href="manager/dashboard.jsp?section=settings"><i class="bx bx-cog"></i> Settings</a>
                        <% } else { %>
                            <a href="home.jsp"><i class="bx bx-home"></i> Home</a>
                            <a href="customer/dashboard.jsp"><i class="bx bx-user"></i> My Account</a>
                            <a href="#"><i class="bx bx-package"></i> My Orders</a>
                            <a href="customer/dashboard.jsp?section=settings"><i class="bx bx-cog"></i> Settings</a>
                        <% } %>
                        <a href="auth/logout" class="logout-link"><i class="bx bx-log-out"></i> Sign Out</a>
                        </div>
                    <% } else { %>
                        <a href="#" class="dropdown-trigger">
                        <i class="bx bx-user"></i> Account <i class="bx bx-chevron-down"></i>
                        </a>
                        <div class="dropdown-content">
                        <a href="login.jsp"><i class="bx bx-log-in"></i> Login</a>
                        <a href="login.jsp#register"><i class="bx bx-user-plus"></i> Register</a>
                        </div>
                    <% } %>
                </li>
                
                <li><a href="#"><i class="bx bx-search"></i></a></li>
                <li>
                    <button id="theme-toggle" class="theme-toggle">
                        <i class="bx bx-moon"></i>
                        <span class="theme-text">Switch Theme</span>
                    </button>
                </li>
            </ul>
        </nav>
    </header>

    <!-- Page Title Banner -->
    <section class="showcase" style="height: 250px; margin-bottom: 40px;">
        <h1>SPECIAL EVENTS & PROMOTIONS</h1>
        <p>Check out our latest offers and exclusive deals</p>
    </section>

    <div class="event-container">
        <!-- Countdown Timer -->
        <div class="countdown">
            <div class="countdown-item">
                <span class="countdown-value" id="days">00</span>
                <span class="countdown-label">Days</span>
            </div>
            <div class="countdown-item">
                <span class="countdown-value" id="hours">00</span>
                <span class="countdown-label">Hours</span>
            </div>
            <div class="countdown-item">
                <span class="countdown-value" id="minutes">00</span>
                <span class="countdown-label">Minutes</span>
            </div>
            <div class="countdown-item">
                <span class="countdown-value" id="seconds">00</span>
                <span class="countdown-label">Seconds</span>
            </div>
        </div>

        <!-- Mega Discount Event -->
        <div class="event-card">
            <div class="event-header">
                <h2 class="event-title">Mega Discount Event</h2>
                <span class="event-dates">April 25 - May 10, 2025</span>
            </div>
            <img src="Images/HomeBackground2.jpg" class="event-image" alt="Mega Discount Event">
            <div class="event-description">
                <p>Get ready for massive savings! We're offering up to 50% OFF on a wide selection of phone accessories, including phone cases, power banks, Bluetooth earphones, screen protectors, and more.</p>
                <p>Don't miss this limited-time opportunity to upgrade your gadget accessories at incredible prices!</p>
                
                <div class="promo-features">
                    <div class="promo-feature">
                        <i class='bx bxs-discount'></i>
                        <h3>Up to 50% OFF</h3>
                        <p>Massive savings on all accessories</p>
                    </div>
                    <div class="promo-feature">
                        <i class='bx bx-package'></i>
                        <h3>All Categories</h3>
                        <p>Discounts across all product lines</p>
                    </div>
                    <div class="promo-feature">
                        <i class='bx bx-calendar'></i>
                        <h3>Limited Time</h3>
                        <p>Offer valid until May 10, 2025</p>
                    </div>
                </div>
            </div>
            <div class="event-cta">
                <a href="CartController" class="event-btn">Shop Now</a>
            </div>
        </div>

        <!-- Free Shipping Promotion -->
        <div class="event-card">
            <div class="event-header">
                <h2 class="event-title">Free Shipping Promotion</h2>
                <span class="event-dates">April 1 - June 30, 2025</span>
            </div>
            <img src="Images/HomeBackground3.jpg" class="event-image" alt="Free Shipping Promotion">
            <div class="event-description">
                <p>We have got great news for all online shoppers! For a limited time, enjoy FREE SHIPPING on all orders, no minimum purchase required!</p>
                <p>Whether you're buying a single cable or a full set of phone accessories, we'll deliver it right to your door, absolutely free of charge.</p>
                
                <div class="promo-features">
                    <div class="promo-feature">
                        <i class='bx bxs-truck'></i>
                        <h3>Free Shipping</h3>
                        <p>No minimum order required</p>
                    </div>
                    <div class="promo-feature">
                        <i class='bx bx-globe'></i>
                        <h3>Nationwide</h3>
                        <p>Available throughout the country</p>
                    </div>
                    <div class="promo-feature">
                        <i class='bx bx-time'></i>
                        <h3>Fast Delivery</h3>
                        <p>Get your items in 2-4 business days</p>
                    </div>
                </div>
            </div>
            <div class="event-cta">
                <a href="CartController" class="event-btn">Shop Now</a>
            </div>
        </div>

        <!-- Featured Products -->
        <div class="event-card">
            <div class="event-header">
                <h2 class="event-title">Featured Products</h2>
                <span class="event-dates">Limited Stock Available</span>
            </div>
            
            <div class="event-description">
                <p>Discover our most popular accessories that customers love! These items are in high demand and showcased on our home page. Check them out before they're gone!</p>
                
                <div class="promo-features">
                    <div class="promo-feature">
                        <i class='bx bx-mobile-alt'></i>
                        <h3>Phone Cases</h3>
                        <p>Stylish and durable protection</p>
                    </div>
                    <div class="promo-feature">
                        <i class='bx bxs-battery-charging'></i>
                        <h3>Power Banks</h3>
                        <p>Stay charged anywhere</p>
                    </div>
                    <div class="promo-feature">
                        <i class='bx bx-headphone'></i>
                        <h3>Earphones</h3>
                        <p>Crystal-clear sound quality</p>
                    </div>
                </div>
            </div>
            <div class="event-cta">
                <a href="CartController" class="event-btn">Browse Featured Products</a>
            </div>
        </div>
    </div>

    <!-- FOOTER -->
    <div class="footer">
        <div class="contain">
            <div class="col">
                <h1>Company</h1>
                <ul>
                    <li>About</li>
                    <li>Mission</li>
                    <li>Services</li>
                    <li>Social</li>
                    <li>Get in touch</li>
                </ul>
            </div>
            <div class="col">
                <h1>Products</h1>
                <ul>
                    <li>About</li>
                    <li>Mission</li>
                    <li>Services</li>
                    <li>Social</li>
                    <li>Get in touch</li>
                </ul>
            </div>
            <div class="col">
                <h1>Accounts</h1>
                <ul>
                    <li>About</li>
                    <li>Mission</li>
                    <li>Services</li>
                    <li>Social</li>
                    <li>Get in touch</li>
                </ul>
            </div>
            <div class="col">
                <h1>Resources</h1>
                <ul>
                    <li>Webmail</li>
                    <li>Redeem code</li>
                    <li>WHOIS lookup</li>
                    <li>Site map</li>
                    <li>Web templates</li>
                    <li>Email templates</li>
                </ul>
            </div>
            <div class="col">
                <h1>Support</h1>
                <ul>
                    <li>Contact us</li>
                </ul>
            </div>
            <div class="col social">
                <h1>Social</h1>
                <ul>
                    <li>
                        <a href="https://www.instagram.com/">
                        <img src="Images/IG.png" width="32" style="width: 25px; border-radius: 40%;">
                        </a>
                    </li>       
                    <li>
                        <a href="https://www.facebook.com/">
                        <img src="Images/FB.png" width="32" style="width: 25px; border-radius: 40%;">
                        </a>
                    </li>
                </ul>
            </div>
            <div class="clearfix"></div>
            <footer>
                <p>&copy;2025 PocketGadget. All rights reserved.</p>
            </footer>
        </div>
    </div>

    <!-- Countdown Timer Script -->
    <script>
        // Set the target date for the countdown (May 10, 2025)
        const targetDate = new Date('May 10, 2025 23:59:59').getTime();
        
        // Update the countdown every 1 second
        const countdown = setInterval(function() {
            // Get today's date and time
            const now = new Date().getTime();
            
            // Find the distance between now and the target date
            const distance = targetDate - now;
            
            // Time calculations for days, hours, minutes and seconds
            const days = Math.floor(distance / (1000 * 60 * 60 * 24));
            const hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
            const minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
            const seconds = Math.floor((distance % (1000 * 60)) / 1000);
            
            // Display the result
            document.getElementById('days').innerHTML = days.toString().padStart(2, '0');
            document.getElementById('hours').innerHTML = hours.toString().padStart(2, '0');
            document.getElementById('minutes').innerHTML = minutes.toString().padStart(2, '0');
            document.getElementById('seconds').innerHTML = seconds.toString().padStart(2, '0');
            
            // If the countdown is finished, display a message
            if (distance < 0) {
                clearInterval(countdown);
                document.getElementById('days').innerHTML = "00";
                document.getElementById('hours').innerHTML = "00";
                document.getElementById('minutes').innerHTML = "00";
                document.getElementById('seconds').innerHTML = "00";
            }
        }, 1000);
    </script>
</body>
</html>