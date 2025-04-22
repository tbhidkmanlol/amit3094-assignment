<html lang="en" class="dark-theme">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>PocketGadget</title>
  <!-- Link CSS here -->
  <link rel="stylesheet" href="home.css" />
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
        <li><a href="#">About Us</a></li>
        <li><a href="#">Contact Us</a></li>
        
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


  
<!-- Start of Content -->
    <div class="menu-btn">
        <i class="fas fa-bars fa-2x"></i>
    </div>

    <div class="container">
        <ul class="right-menu">
            <li>
                <a href="#">
                    <i class="fas fa-search"></i>
                </a>
            </li>
            <li>
                <a href="cart.jsp" style="position: relative;">
                    <i class="fas fa-shopping-cart"></i>
                    <% 
                        // Only show cart badge for regular users who are logged in
                        if (session.getAttribute("user") != null && "USER".equals(session.getAttribute("role"))) { 
                            Integer rightMenuCartCount = (Integer) session.getAttribute("cartCount");
                            if (rightMenuCartCount != null && rightMenuCartCount > 0) { 
                    %>
                        <span class="cart-badge"><%= rightMenuCartCount %></span>
                    <% 
                            }
                        } 
                    %>
                </a>
            </li>
        </ul>

        <!-- Showcase -->
        <section class="showcase">
            <h1>POCKET GADGETS</h1>
            <p>Welcome to Pocket gadget E-Commerce Website</p>
            <a href="ViewEvents.html" class="btn">
                Purchase Now <i class="fas fa-chevron-right"></i>
            </a>
        </section>

        <!-- Home cards 1 -->
        <section class="home-cards">
            <div>
                <img src="Images/PhoneCase1.jpg" alt="" />
                <h3>Phone Cases</h3>
                <p>Protect your phone with stylish and durable cases for all models!</p>
                <a href="ViewEvents.html">Learn More <i class="fas fa-chevron-right"></i></a>
            </div>
            <div>
                <img src="Images/PowerBank1.jpeg" alt="" />
                <h3>Power Bank</h3>
                <p>Stay charged anywhere with our high-capacity portable power banks</p>
                <a href="ViewEvents.html">Learn More <i class="fas fa-chevron-right"></i></a>
            </div>
            <div>
                <img src="Images/Cable2.webp" alt="" />
                <h3>Charging Cable</h3>
                <p>Fast and reliable cables for all your charging and syncing needs.</p>
                <a href="ViewEvents.html">Learn More <i class="fas fa-chevron-right"></i></a>
            </div>
            <div>
                <img src="Images/ScreenProtector2.webp" alt="" />
                <h3>Screen Protector</h3>
                <p>Shield your screen from scratches, smudges, and cracks.</p>
                <a href="ViewEvents.html">Learn More <i class="fas fa-chevron-right"></i></a>
            </div>
        </section>

        <!-- Discount -->
        <section class="xbox">
            <div class="content">
                <h2>Mega Discount Event</h2>
                <p>Get ready for massive savings! We?re offering up to 50% OFF on
                    a wide selection of phone accessories, including phone cases, power banks, Bluetooth 
                    earphones, screen protectors, and more.</p>
                
                <a href="ViewEvents.html" class="btn">Join Now <i class="fas fa-chevron-right"></i></a>
            </div>
        </section>

        <!-- Home cards 2 -->
        <section class="home-cards">
            <div>
                <img src="Images/CarCharger.jpg" alt="" />
                <h3>Car Charger</h3>
                <p>Charge your devices quickly while you're on the road..</p>
                <a href="ViewEvents.html">Learn More <i class="fas fa-chevron-right"></i></a>
            </div>
            <div>
                <img src="Images/Earphone.jpeg" alt="" />
                <h3>Bluetooth Earphone</h3>
                <p>Enjoy wireless freedom with crystal-clear sound and comfort!</p>
                <a href="ViewEvents.html">Learn More<i class="fas fa-chevron-right"></i></a>
            </div>
            <div>
                <img src="Images/PhoneHolder.jpg" alt="" />
                <h3>Phone Navigation Holder</h3>
                <p>Securely mount your phone in the car for easy GPS navigation.</p>
                <a href="ViewEvents.html">Learn More<i class="fas fa-chevron-right"></i></a>
            </div>
            <div>
                <img src="Images/Keyboard.webp" alt="" />
                <h3>Keyboard</h3>
                <p>Compact and responsive keyboards perfect for mobile typing or gaming.</p>
                <a href="ViewEvents.html">Learn More<i class="fas fa-chevron-right"></i></a>
            </div>
        </section>

        <!-- Training -->
        <section class="carbon dark">
            <div class="content">
                <h2>Free Shipping Promotion</h2>
                <p>We have got great news for all online shoppers! For a limited time, enjoy FREE SHIPPING on all orders, no 
                    minimum purchase required! Whether you're buying a single cable or a full set of phone
                    accessories, we?ll deliver it right to your door , absolutely free of charge.</p>
                <a href="ViewEvents.html" class="btn">Join Now <i class="fas fa-chevron-right"></i></a>
            </div>
        </section>
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

<!-- Script for Register tab selection -->
<script>
  document.addEventListener('DOMContentLoaded', function() {
    // Check if URL contains #register and redirect to login page with register tab active
    const registerLinks = document.querySelectorAll('a[href="login.jsp#register"]');
    registerLinks.forEach(link => {
      link.addEventListener('click', function(e) {
        e.preventDefault();
        window.location.href = 'login.jsp#register';
        
        // Store a flag to switch to register tab when the page loads
        sessionStorage.setItem('showRegisterTab', 'true');
      });
    });
  });
</script>
</body>
</html>