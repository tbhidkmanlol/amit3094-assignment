<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en" class="dark-theme">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>About Us - PocketGadget</title>
  <link rel="stylesheet" href="AboutUs.css" />
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
        <li><a href="AboutUs.jsp" class="active">About Us</a></li>
        <li><a href="contactus.jsp" >Contact Us</a></li>
        
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

<!-- Main Content Section -->
<main class="main-content">
  <!-- Mission Section -->
  <section class="mission-section">
    <div class="section-container">
      <div class="mission-text">
        <h2>Our Mission</h2>
        <p>There's this notion that to grow a business, you have to be ruthless. But we know there's a better way to grow. One where what's good for the bottom line is also good for customers. We believe businesses can grow with a conscience, deliver amazing products, and they can do it with outbound. That's why we've created an ecosystem mixing software, education, and community to help businesses grow better every day.</p>
      </div>
      <div class="mission-image">
          <img src="Images/Technology-inspire-teamwork.png" alt="Team members discussing business strategy" />
      </div>
    </div>
  </section>

  <!-- Our Story Section -->
  <section class="story-section">
    <div class="section-container">
      <div class="story-content">
        <div class="story-image">
            <img src="Images/Tech-Research.jpg" alt="Company story image" />
        </div>
        <div class="story-text">
                            <h2>Our Story</h2>
          <p>As fellow graduate students at MIT in 2004, Brian and Dharmesh noticed a shift in the way people shop and buy. Consumers were no longer tolerating interruptive bids for their attention — in fact, they'd gotten really, really good at ignoring them.</p>
        </div>
      </div>
    </div>
  </section>
</main>

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
</html>
