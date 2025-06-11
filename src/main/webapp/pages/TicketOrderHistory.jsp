<%-- 
    Document   : TicketOrderHistory
    Created on : May 26, 2025, 7:18:08 PM
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

        <title>MasterTicket</title>
        <style>


            :root {
                --primary: #4a4aff;
                --secondary: #ff4da6;
                --dark-bg: #0f0f1a;
                --darker-bg: #000015;
                --card-bg: #1a1a2e;
                --text-light: #ffffff;
                --text-muted: #aaaaaa;
                --success: #00cc66;
                --warning: #ffcc00;
                --danger: #ff3333;
            }
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Segoe UI', Arial, sans-serif;
                background: linear-gradient(to bottom, #000015, #1a1a2e);
                color: #ffffff;
                min-height: 100vh;
            }


            /* Header Styles */
            .header-container {
                display: flex;
                justify-content: center;
                background-color: var(--dark-bg);
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.3);
            }

            .header {
                max-width: 1300px;
                width: 100%;
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 15px 40px;
            }

            .logo {
                font-size: 24px;
                font-weight: bold;
                color: #4a4aff;
            }

            .search {
                display: flex;
                align-items: center;
            }

            .search input {
                padding: 10px 15px;
                border-radius: 25px;
                border: 1px solid #333344;
                width: 300px;
                background-color: #1a1a2e;
                color: white;
                font-size: 14px;
            }

            .search button {
                padding: 10px 15px;
                margin-left: 10px;
                background-color: var(--primary);
                border: none;
                border-radius: 25px;
                color: white;
                cursor: pointer;
                font-weight: bold;
                transition: all 0.2s;
            }

            .search button:hover {
                background-color: #3a3add;
            }

            .actions {
                display: flex;
                align-items: center;
                gap: 20px;
            }

            .primary-btn {
                background-color: var(--secondary);
                border: none;
                padding: 10px 20px;
                color: white;
                border-radius: 25px;
                cursor: pointer;
                font-weight: bold;
                transition: all 0.2s;
            }

            .primary-btn:hover {
                background-color: #e04496;
            }

            .link {
                color: var(--text-light);
                text-decoration: none;
                font-weight: 500;
                padding: 8px 12px;
                border-radius: 5px;
                transition: all 0.2s;
            }

            .link:hover {
                background-color: rgba(255, 255, 255, 0.1);
            }

            .account {
                background-color: #333344;
                padding: 8px 16px;
                border-radius: 25px;
                font-weight: 500;
                cursor: pointer;
                transition: all 0.2s;
            }

            .account:hover {
                background-color: #444455;
            }

            /* Main Container */
            .main-container {
                max-width: 1400px;
                margin: 0 auto;
                display: flex;
                gap: 30px;
                padding: 30px;
            }

            /* Sidebar */
            .sidebar {
                width: 280px;
                flex-shrink: 0;
            }

            .profile-card {
                background: rgba(255, 255, 255, 0.05);
                backdrop-filter: blur(15px);
                border-radius: 15px;
                padding: 25px;
                margin-bottom: 20px;
            }

            /* Profile Header */
            .profile-header {
                display: flex;
                align-items: center;
                margin-bottom: 20px;
            }

            .profile-avatar {
                width: 50px;
                height: 50px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 30px;
                color: white;
                border-radius: 50%;
                background: transparent;
                margin-right: 10px;
            }

            .profile-info-box {
                background-color: #ccc;
                padding: 5px 10px;
                border-radius: 8px;
            }

            .profile-label {
                font-size: 12px;
                color: black;
            }

            .profile-username {
                font-size: 14px;
                font-weight: bold;
                color: black;
            }

            /* Menu */
            .profile-menu {
                list-style: none;
                padding: 0;
                margin: 0;
            }

            .profile-menu li {
                display: flex;
                align-items: center;
                gap: 12px;
                padding: 12px 0;
                cursor: pointer;
                font-size: 14px;
                color: white;
                transition: color 0.3s ease;
            }

            .profile-menu li i {
                font-size: 16px;
            }

            .profile-menu li:hover {
                color: #40c9ff;
            }

            .profile-menu li.active {
                color: #0bc26e;
                font-weight: 600;
            }

            /* Main Content */
            /* Main Content */
            .main-content {
                flex: 1;
                background: radial-gradient(circle at top left, #101e4b, #01010b);
                padding: 40px 60px;
                min-height: 100vh;
                color: white;
                font-family: 'Segoe UI', sans-serif;
            }

            /* Filter Tabs */
            .filter-tabs {
                display: flex;
                gap: 16px;
                margin-bottom: 30px;
                justify-content: center;
            }

            .filter-tab {
                padding: 10px 20px;
                border-radius: 999px;
                border: none;
                cursor: pointer;
                font-size: 14px;
                transition: all 0.3s ease;
                background: rgba(255, 255, 255, 0.1);
                color: #aaa;
            }

            .filter-tab.active {
                background: #0bc26e;
                color: white;
            }

            .filter-tab:hover {
                background: rgba(255, 255, 255, 0.3);
                color: white;
            }

            /* Status Buttons */
            .status-buttons {
                display: flex;
                justify-content: space-between;
                gap: 10px;
                margin-bottom: 30px;
            }

            .status-btn {
                flex: 1;
                padding: 10px 18px;
                border-radius: 20px;
                border: none;
                font-size: 14px;
                background: #222;
                color: #ccc;
                cursor: pointer;
                transition: 0.3s ease;
            }

            .status-btn.upcoming {
                background: #ffe680;
                color: #000;
                font-weight: bold;
            }

            .status-btn.ended:hover {
                background: #333;
                color: white;
            }

            /* Tickets Section */
            .tickets-header {
                background: rgba(255, 255, 255, 0.1);
                padding: 12px;
                border-radius: 8px;
                text-align: center;
                margin-bottom: 30px;
            }

            .tickets-title {
                font-size: 24px;
                font-weight: 600;
                color: white;
            }

            /* Empty State */
            .empty-state {
                text-align: center;
                padding: 60px 20px;
            }

            .empty-icon {
                width: 120px;
                height: 120px;
                background: linear-gradient(45deg, #ffa500, #ff6b35);
                border-radius: 50%;
                margin: 0 auto 20px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 48px;
                color: white;
            }

            .empty-text {
                font-size: 20px;
                color: rgba(255, 255, 255, 0.7);
                margin-bottom: 40px;
            }

            /* Suggestions Section */
            .suggestions-section {
                margin-top: 50px;
            }

            .suggestions-title {
                text-align: center;
                font-size: 22px;
                margin-bottom: 30px;
                background: linear-gradient(45deg, #40c9ff, #e81cff);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                background-clip: text;
            }

            .suggestions-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
                gap: 20px;
                margin-bottom: 40px;
            }

            .suggestion-card {
                background: rgba(255, 255, 255, 0.05);
                border-radius: 16px;
                overflow: hidden;
                transition: transform 0.3s ease, box-shadow 0.3s ease;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
                cursor: pointer;
            }

            .suggestion-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 6px 18px rgba(0, 0, 0, 0.5);
            }

            .card-image {
                width: 100%;
                height: 150px;
                background: linear-gradient(45deg, #3a3a3a, #666);
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                font-size: 12px;
                background-size: cover;
                background-position: center;
            }

            .card-content {
                padding: 15px;
            }

            .card-title {
                font-size: 14px;
                font-weight: 600;
                color: white;
                margin-bottom: 6px;
                line-height: 1.3;
            }

            .card-date {
                font-size: 12px;
                color: rgba(255, 255, 255, 0.6);
            }




            /* Footer */
            .footer-content {
                max-width: 1300px; /* same as main-content */
                margin: 0 auto;    /* center alignment */
                box-sizing: border-box;
            }

            /* Container for footer sections */
            .footer-container {
                display: flex;
                justify-content: space-between;
                flex-wrap: wrap;
                gap: 20px;
                padding: 0px 15px;
            }

            /* Each section in footer */
            .footer-section {
                flex: 1;
                min-width: 250px;
                margin: 10px;
            }

            .footer-section h3 {
                color: #ddd;
                margin-bottom: 15px;
            }

            .footer-section ul {
                list-style: none;
                padding: 0;
            }

            .footer-section ul li {
                padding: 10px 0;
            }

            .footer-section ul li a {
                text-decoration: none;
                color: #aaa;
                transition: 0.3s;
            }

            .footer-section ul li a:hover,
            .footer-section a:hover {
                color: #fff;
            }

            .footer-section p, .footer-section a {
                color: #aaa;
                margin: 5px 0;
                text-decoration: underline;
            }

            .footer-section li {
                padding: 5px 0;
            }

            .subscribe-box {
                display: flex;
                align-items: center;
                border: 2px solid #6f42c1;
                border-radius: 8px;
                padding: 5px 10px;
                background: #000;
                margin-bottom: 15px;
                gap: 10px;
            }

            .fa-envelope:before {
                content: "\f0e0";
                color: #15d715;
            }

            .subscribe-box input {
                flex: 1;
                border: none;
                background: transparent;
                color: white;
                padding: 8px;
                outline: none;
                font-size: 14px;
            }

            .subscribe-box button {
                background: #6f42c1;
                border: none;
                border-radius: 5px;
                padding: 8px 12px;
                color: white;
                cursor: pointer;
                transition: background 0.3s;
            }

            .subscribe-box button:hover {
                background: #5a339e;
            }

            .language img {
                width: 30px;
                margin: 5px 10px 5px 0;
                cursor: pointer;
                border-radius: 4px;
                transition: transform 0.2s;
            }

            .language img:hover {
                transform: scale(1.1);
            }

            .social-icons {
                margin-top: 15px;
            }

            .social-images img {
                width: 30px;
                margin-right: 10px;
                border-radius: 5px;
                cursor: pointer;
                transition: transform 0.3s;
            }

            .social-images img:hover {
                transform: scale(1.2);
            }
        </style>
    </head>
    <body>
        <!-- Header -->
        <div class="header-container">
            <header class="header">
                <div class="logo">MasterTicket</div>
                <div class="search">
                    <input type="text" placeholder="What are you looking for today?">
                    <button>Search</button>
                </div>
                <div class="actions">
                    <button class="primary-btn">Create Event</button>
                    <a href="#" class="link">Purchased Tickets</a>
                    <div class="account">Account</div>
                </div>
            </header>
        </div>

        <!-- Main Container -->
        <div class="main-container">
            <!-- Sidebar -->
            <div class="sidebar">
                <div class="profile-card">
                    <div class="profile-header">
                        <div class="profile-avatar">
                            <i class="fas fa-user-circle"></i>
                        </div>
                        <div class="profile-info-box">
                            <span class="profile-label">Account of</span><br>
                            <span class="profile-username">Phuoc Hat Le</span>
                        </div>
                    </div>
                    <ul class="profile-menu">
                        <li><i class="fas fa-user"></i> Account Settings</li>
                        <li><i class="fas fa-info-circle"></i> Account Information</li>
                        <li class="active"><i class="fas fa-ticket-alt"></i> Purchased Tickets</li>
                        <li><i class="fas fa-calendar-alt"></i> My Events</li>
                    </ul>
                </div>
            </div>

            <!-- Main Content -->
            <div class="main-content">
                <!-- Filter Tabs -->
                <div class="tickets-header">
                    <h2 class="tickets-title">Purchased Tickets</h2>
                </div>

                <div class="filter-tabs">
                    <button class="filter-tab active">All</button>
                    <button class="filter-tab">Successful</button>
                    <button class="filter-tab">Processing</button>
                    <button class="filter-tab">Cancelled</button>
                </div>

                <!-- Status Buttons -->
                <div class="status-buttons">
                    <button class="status-btn upcoming">Upcoming</button>
                    <button class="status-btn ended">Ended</button>
                </div>

                <!-- Empty State -->
                <div class="empty-state">
                    <div class="empty-icon">💡</div>
                    <div class="empty-text">You don't have any tickets yet</div>
                </div>

                <!-- Suggestions Section -->
                <div class="suggestions-section">
                    <div class="suggestions-grid">
                        <div class="suggestion-card">
                            <div class="card-image">Event Image</div>
                            <div class="card-content">
                                <div class="card-title">WORKSHOP - FOOD AND BEVERAGE INDUSTRY</div>
                                <div class="card-date">From Thursday 02, 22/08</div>
                            </div>
                        </div>

                        <div class="suggestion-card">
                            <div class="card-image">Event Image</div>
                            <div class="card-content">
                                <div class="card-title">SUPER CHEF - COOKING COMPETITION FOR STUDENTS</div>
                                <div class="card-date">From Thursday 04, 24/08</div>
                            </div>
                        </div>

                        <div class="suggestion-card">
                            <div class="card-image">Event Image</div>
                            <div class="card-content">
                                <div class="card-title">CONFERENCE ON WEBSITE AND APP EXPLOITATION</div>
                                <div class="card-date">From Thursday 06, 26/08</div>
                            </div>
                        </div>

                        <div class="suggestion-card">
                            <div class="card-image">Event Image</div>
                            <div class="card-content">
                                <div class="card-title">CONFERENCE ON JAPANESE TECHNOLOGY AND MARKET</div>
                                <div class="card-date">From Thursday 07, 27/08</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Footer -->
        <footer class="footer">
            <div class="footer-content">
                <div class="footer-container">
                    <!-- Customer Services -->
                    <div class="footer-section">
                        <h3>Customer Services</h3>
                        <ul>
                            <li><a href="#">FAQS</a></li>
                            <li><a href="#">Contact us</a></li>
                            <li><a href="#">Privacy Policy</a></li>
                            <li><a href="#">Terms of Service</a></li>
                        </ul>
                        <p><i class="fas fa-envelope"></i> <a href="mailto:support@masterTicket.vn">support@masterTicket.vn</a></p>
                    </div>

                    <!-- Sitemap -->
                    <div class="footer-section">
                        <h3>SiteMap</h3>
                        <ul>
                            <li><a href="#">Create Account</a></li>
                            <li><a href="#">News</a></li>
                            <li><a href="#">Top-Rated Event</a></li>
                        </ul>
                    </div>

                    <!-- Subscribe -->
                    <div class="footer-section">
                        <h3>Subscribe for event updates.</h3>
                        <form class="subscribe-box">
                            <input type="email" placeholder="Your email..." required />                            
                            <button type="submit"><i class="fas fa-paper-plane"></i></button>                          
                        </form>

                        <div class="language">
                            <p>Language:</p>
                            <img src="https://flagcdn.com/w40/vn.png" alt="Vietnamese" />
                            <img src="https://flagcdn.com/w40/gb.png" alt="English" />
                        </div>

                        <div class="social-icons">
                            <p>Follow us:</p>
                            <div class="social-images">
                                <img src="https://cdn-icons-png.flaticon.com/512/733/733547.png" alt="Facebook" />
                                <img src="https://cdn-icons-png.flaticon.com/512/2111/2111463.png" alt="Instagram" />
                                <img src="https://cdn-icons-png.flaticon.com/512/3046/3046120.png" alt="TikTok" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </footer>
    </body>
</html>


