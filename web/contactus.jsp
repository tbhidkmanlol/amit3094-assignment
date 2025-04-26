<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en" class="dark-theme">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Contact Us - PocketGadget</title>
  <link rel="stylesheet" href="contactus.css" />
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
        <li><a href="contact.jsp" class="active">Contact Us</a></li>
        
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

  <!-- Contact Us Content -->
  <div class="contact-container">
    <div class="contact-info">
      <h1>Contact Us</h1>
      <p>Feel free to use the form or drop us an email. Old-fashioned phone calls work too.</p>
      
      <div class="contact-methods">
        <div class="contact-method">
          <i class='bx bx-phone'></i>
          <a href="tel:012-34567890">01234567890</a>
        </div>
        
        <div class="contact-method">
          <i class='bx bx-envelope'></i>
          <a href="mailto:info@pocketgadget.com">pocketgadget@gmail.com</a>
        </div>
        
        <div class="contact-method">
          <i class='bx bx-map'></i>
          <address>
            Hong Mon, 41, Jalan 14/27b<br>
            53300 Kuala Lumpur Kuala Lumpur
          </address>
        </div>
      </div>
    </div>
    
    <div class="contact-form">
      <form action="ContactUs" method="post">
        <div class="form-row">
          <div class="form-group">
            <label for="firstName">First Name</label>
            <input type="text" id="firstName" name="firstName" placeholder="First" required>
          </div>
          <div class="form-group">
            <label for="firstName">Last Name</label>
            <input type="text" id="lastName" name="lastName" placeholder="Last" required>
          </div>
        </div>
        
        <div class="form-group">
          <label for="email">Email</label>
          <input type="email" id="email" name="email" placeholder="example@email.com" required>
        </div>
        
        <div class="form-group">
          <label for="phone">Phone (optional)</label>
          <input type="tel" id="phone" name="phone" placeholder="xxx-xxx-xxxx">
        </div>
        
        <div class="form-group">
          <label for="message">Message</label>
          <textarea id="message" name="message" placeholder="Type your message..." required></textarea>
        </div>
        
        <button type="submit" class="submit-btn">Submit</button>
      </form>
    </div>
  </div>
  
  <!-- Map Section -->
  <div class="map-container">
    <iframe 
  src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3984.0000000000005!2d101.7304435!3d3.2052369!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x31cc383c28373d43%3A0x859a261caa78640b!2sRDS%20Restaurant%20Wangsa%20Maju%20Sdn%20Bhd!5e0!3m2!1sen!2smy!4v1714019354934!5m2!1sen!2smy"
      width="100%" 
      height="400" 
      style="border:0;" 
      allowfullscreen="" 
      loading="lazy"
      referrerpolicy="no-referrer-when-downgrade">
    </iframe>
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
  <div id="popupMessage" style="display:none; position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%);
    background-color: black; border: 2px solid #4CAF50; padding: 20px; z-index: 9999; border-radius: 10px; box-shadow: 0 5px 15px rgba(0,0,0,0.3); text-align: center;">
    <span id="popupText"></span><br><br>
    <button onclick="closePopup()" style="padding: 5px 10px; background-color: #4CAF50; color: white; border: none; border-radius: 5px;">OK</button>
</div>

<div id="popupOverlay" style="display:none; position: fixed; top: 0; left: 0; width: 100vw; height: 100vh; 
    background-color: rgba(0,0,0,0.3); z-index: 9998;"></div>

</body>

<script>
    function showPopup(message) {
        document.getElementById("popupText").innerText = message;
        document.getElementById("popupOverlay").style.display = "block";
        document.getElementById("popupMessage").style.display = "block";
    }

    function closePopup() {
        document.getElementById("popupOverlay").style.display = "none";
        document.getElementById("popupMessage").style.display = "none";
    }
</script>

<% if (request.getAttribute("contactMessage") != null) { %>
    <script>
        window.onload = function() {
            showPopup("<%= request.getAttribute("contactMessage") %>");
        };
    </script>
<% } else if (request.getAttribute("contactError") != null) { %>
    <script>
        window.onload = function() {
            showPopup("<%= request.getAttribute("contactError") %>");
        };
    </script>
<% } %>




</html>