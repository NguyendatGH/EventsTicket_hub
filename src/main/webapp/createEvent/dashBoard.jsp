<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="models.User" %> <%-- Import the User model as it's the shared entity --%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Event Dashboard - MasterTicket</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #122536 0%, #764ba2 100%);
            min-height: 100vh;
            color: #fff;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }

        .sidebar {
            position: fixed;
            left: 0;
            top: 0;
            width: 250px;
            height: 100vh;
            background: rgba(0,0,0,0.3);
            backdrop-filter: blur(10px);
            padding: 20px;
            z-index: 1000;
        }

        .sidebar .brand {
            color: #4CAF50;
            font-size: 20px;
            font-weight: bold;
            margin-bottom: 30px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .sidebar .menu {
            list-style: none;
        }

        .sidebar .menu li {
            margin-bottom: 15px;
        }

        .sidebar .menu a {
            color: #d8cbcb;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 10px;
            border-radius: 5px;
            transition: all 0.3s;
        }

        .sidebar .menu a:hover,
        .sidebar .menu a.active {
            background: rgba(76, 175, 80, 0.2);
            color: #4CAF50;
            transform: translateX(5px);
        }

        .main-content {
            margin-left: 270px;
            padding: 20px;
        }

        .navbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 0;
            border-bottom: 1px solid rgba(255,255,255,0.1);
            margin-bottom: 30px;
        }

        .navbar .nav-links {
            display: flex;
            gap: 30px;
            list-style: none;
        }

        .navbar .nav-links a {
            color: #fff;
            text-decoration: none;
            opacity: 0.8;
            transition: all 0.3s;
            padding: 8px 16px;
            border-radius: 20px;
        }

        .navbar .nav-links a:hover,
        .navbar .nav-links a.active {
            opacity: 1;
            color: #4CAF50;
            background: rgba(76, 175, 80, 0.1);
        }

        /* --- START: User Menu Styles for Navbar (Copied from updateProfile.jsp) --- */
        .user-menu {
            display: flex;
            align-items: center;
            gap: 1rem;
            position: relative; /* Crucial for dropdown positioning */
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            cursor: pointer;
            padding: 0.5rem 1rem;
            border-radius: 25px;
            background: rgba(255, 255, 255, 0.1);
            transition: all 0.3s;
        }

        .user-info:hover {
            background: rgba(255, 255, 255, 0.15);
        }

        .user-avatar {
            width: 35px; /* Adjust size as needed for navbar */
            height: 35px;
            border-radius: 50%;
            background-size: cover; /* Ensures image fills the container */
            background-position: center; /* Centers the image */
            border: 1px solid rgba(255, 255, 255, 0.3); /* Nice border */
            display: flex; /* For centering initial letter if no image */
            align-items: center;
            justify-content: center;
            font-weight: bold;
            font-size: 0.9rem;
            background: linear-gradient(45deg, #4CAF50, #45a049); /* Default background color for event owner */
            color: white; /* For initial letter */
        }
        .user-avatar img { /* Style for the actual image inside avatar div */
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 50%;
        }

        .user-dropdown {
            position: absolute;
            top: calc(100% + 10px); /* Position below user-info with some gap */
            right: 0;
            background: rgba(0, 0, 0, 0.9);
            backdrop-filter: blur(10px);
            border-radius: 10px;
            padding: 1rem;
            min-width: 200px;
            border: 1px solid rgba(255, 255, 255, 0.1);
            opacity: 0;
            visibility: hidden;
            transform: translateY(-10px);
            transition: all 0.3s ease-in-out;
            z-index: 101; /* Ensure it appears above other elements */
        }

        .user-dropdown.show {
            opacity: 1;
            visibility: visible;
            transform: translateY(0);
        }

        .dropdown-item {
            display: block;
            color: white;
            text-decoration: none;
            padding: 0.75rem 0.5rem; /* Better click area */
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            transition: background 0.3s, color 0.3s;
        }

        .dropdown-item:last-child {
            border-bottom: none;
        }

        .dropdown-item:hover {
            background: rgba(76, 175, 80, 0.2); /* Highlight on hover */
            color: #4CAF50;
        }
        /* --- END: User Menu Styles for Navbar --- */

        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-block;
        }

        .btn-primary {
            background: #4CAF50;
            color: white;
        }

        .btn-primary:hover {
            background: #45a049;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(76, 175, 80, 0.3);
        }

        .btn-logout {
            background: linear-gradient(45deg, #ff6b6b, #ee5a24);
            color: white;
            border-radius: 20px;
            padding: 8px 16px;
            font-size: 12px;
        }

        .btn-logout:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(255, 107, 107, 0.3);
        }

        .dashboard-header {
            background: rgba(255,255,255,0.1);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 30px;
            text-align: center;
        }

        .dashboard-header h1 {
            font-size: 2.5rem;
            margin-bottom: 10px;
            background: linear-gradient(45deg, #4CAF50, #45a049);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: rgba(255,255,255,0.1);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            padding: 25px;
            text-align: center;
            transition: all 0.3s;
            border: 1px solid rgba(255,255,255,0.1);
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.2);
            border-color: #4CAF50;
        }

        .stat-card .icon {
            font-size: 3rem;
            margin-bottom: 15px;
        }

        .stat-card .number {
            font-size: 2rem;
            font-weight: bold;
            color: #4CAF50;
            margin-bottom: 5px;
        }

        .stat-card .label {
            color: rgba(255,255,255,0.8);
            font-size: 0.9rem;
        }

        .content-section {
            background: rgba(255,255,255,0.1);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 30px;
        }

        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
        }

        .section-header h2 {
            color: #4CAF50;
            font-size: 1.5rem;
        }

        .event-list {
            display: grid;
            gap: 15px;
        }

        .event-item {
            background: rgba(255,255,255,0.05);
            border-radius: 10px;
            padding: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            transition: all 0.3s;
            border: 1px solid rgba(255,255,255,0.1);
        }

        .event-item:hover {
            background: rgba(255,255,255,0.1);
            transform: translateX(5px);
        }

        .event-info h3 {
            color: #4CAF50;
            margin-bottom: 5px;
        }

        .event-info p {
            color: rgba(255,255,255,0.7);
            font-size: 0.9rem;
        }

        .event-status {
            padding: 5px 12px;
            border-radius: 15px;
            font-size: 0.8rem;
            font-weight: bold;
        }

        .status-active {
            background: rgba(76, 175, 80, 0.2);
            color: #4CAF50;
            border: 1px solid #4CAF50;
        }

        .status-pending {
            background: rgba(255, 193, 7, 0.2);
            color: #ffc107;
            border: 1px solid #ffc107;
        }

        .status-ended {
            background: rgba(244, 67, 54, 0.2);
            color: #f44336;
            border: 1px solid #f44336;
        }

        .quick-actions {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-top: 20px;
        }

        .action-btn {
            background: rgba(255,255,255,0.1);
            border: 1px solid rgba(255,255,255,0.2);
            color: #fff;
            padding: 15px;
            border-radius: 10px;
            text-align: center;
            text-decoration: none;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }

        .action-btn:hover {
            background: rgba(76, 175, 80, 0.2);
            border-color: #4CAF50;
            color: #4CAF50;
            transform: translateY(-2px);
        }

        .footer {
            background: rgba(0,0,0,0.5);
            margin-top: 50px;
            padding: 40px 0;
            color: rgba(255,255,255,0.8);
        }

        .footer-content {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 30px;
        }

        .footer-section h3 {
            color: #4CAF50;
            margin-bottom: 15px;
        }

        .footer-section ul {
            list-style: none;
        }

        .footer-section ul li {
            margin-bottom: 8px;
        }

        .footer-section ul li a {
            color: rgba(255,255,255,0.7);
            text-decoration: none;
            transition: color 0.3s;
        }

        .footer-section ul li a:hover {
            color: #4CAF50;
        }

        .email-subscribe {
            display: flex;
            gap: 10px;
            margin-top: 15px;
        }

        .email-subscribe input {
            flex: 1;
            padding: 10px;
            border: 1px solid rgba(255,255,255,0.3);
            border-radius: 5px;
            background: rgba(255,255,255,0.1);
            color: #fff;
        }

        .social-icons {
            display: flex;
            gap: 10px;
            margin-top: 15px;
        }

        .social-icons a {
            width: 35px;
            height: 35px;
            background: rgba(255,255,255,0.2);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            text-decoration: none;
            transition: all 0.3s;
        }

        .social-icons a:hover {
            background: #4CAF50;
            transform: translateY(-2px);
        }

        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.8);
            z-index: 2000;
            backdrop-filter: blur(5px);
        }

        .modal-content {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background: linear-gradient(135deg, #122536 0%, #764ba2 100%);
            padding: 30px;
            border-radius: 15px;
            max-width: 500px;
            width: 90%;
            text-align: center;
        }

        .close-btn {
            position: absolute;
            top: 10px;
            right: 15px;
            background: none;
            border: none;
            color: #fff;
            font-size: 24px;
            cursor: pointer;
        }

        @media (max-width: 768px) {
            .sidebar {
                transform: translateX(-100%);
                transition: transform 0.3s;
            }
            
            .main-content {
                margin-left: 0;
            }
            
            .stats-grid {
                grid-template-columns: 1fr;
            }
            
            .navbar {
                flex-direction: column;
                gap: 15px;
            }
            
            .navbar .nav-links {
                flex-wrap: wrap;
                justify-content: center;
            }
        }

        .animate-bounce {
            animation: bounce 2s infinite;
        }

        @keyframes bounce {
            0%, 20%, 50%, 80%, 100% {
                transform: translateY(0);
            }
            40% {
                transform: translateY(-10px);
            }
            60% {
                transform: translateY(-5px);
            }
        }

        .pulse {
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0% {
                box-shadow: 0 0 0 0 rgba(76, 175, 80, 0.7);
            }
            70% {
                box-shadow: 0 0 0 10px rgba(76, 175, 80, 0);
            }
            100% {
                box-shadow: 0 0 0 0 rgba(76, 175, 80, 0);
            }
        }
    </style>
</head>
<body>
    <%
        // Retrieve User object from session
        User currentUser = (User) session.getAttribute("user");
        // Redirect if not logged in or if role is not 'event_owner'
        if (currentUser == null || !"event_owner".equals(currentUser.getRole())) { // Corrected role check
            response.sendRedirect(request.getContextPath() + "/login"); // Adjust login URL as needed
            return;
        }
    %>

    <div class="sidebar">
        <div class="brand">🎟️ MasterTicket</div>
        <ul class="menu">
            <li><a href="#" class="active">📅 My Events</a></li>
            <li><a href="#">📊 Manage Reports</a></li>
            <li><a href="#">📋 Rules</a></li>
            <li><a href="#">⚙️ Settings</a></li>
            <li><a href="#">📈 Analytics</a></li>
        </ul>
    </div>

    <div class="main-content">
        <nav class="navbar">
            <div class="nav-links">
                <a href="${pageContext.request.contextPath}/eventOwnerPage/eventOwnerHomePage">Home</a>
                <a href="${pageContext.request.contextPath}/shows">Shows</a>
                <a href="${pageContext.request.contextPath}/offers">Offers & Discount</a>
                <a href="${pageContext.request.contextPath}/eventOwnerPage/eventOwnerDashboard" class="active">Dashboard</a>
                
                <button class="chat-btn" onclick="window.location.href='${pageContext.request.contextPath}/chat'">
                    💬 Go to Chat
                </button>
            </div>
            
            <div class="user-menu"> <%-- Integrated User Profile and Dropdown --%>
                <div class="user-info" onclick="toggleUserDropdown()">
                    <%-- User Avatar --%>
                    <div class="user-avatar">
                        <% if (currentUser.getAvatar() != null && !currentUser.getAvatar().isEmpty()) { %>
                            <img src="${pageContext.request.contextPath}/images/<%= currentUser.getAvatar() %>" alt="User Avatar">
                        <% } else { %>
                            <%= currentUser.getEmail().substring(0, 1).toUpperCase() %>
                        <% } %>
                    </div>
                    Xin chào, <%= currentUser.getName() != null && !currentUser.getName().isEmpty() ? currentUser.getName() : currentUser.getEmail() %> <span style="margin-left: 0.5rem;">▼</span>
                </div>
                
                <%-- User Dropdown Menu --%>
                <div class="user-dropdown" id="userDropdown">
                    <a href="${pageContext.request.contextPath}/updateEventOwnerProfile" class="dropdown-item">👤 Thông tin cá nhân Chủ sự kiện</a>
                    <a href="${pageContext.request.contextPath}/eventOwnerEvents" class="dropdown-item">🎫 Sự kiện của tôi</a>
                    <a href="${pageContext.request.contextPath}/changePassword" class="dropdown-item">⚙️ Đổi mật khẩu</a> <%-- Common change password servlet --%>
                    <hr style="border: none; border-top: 1px solid rgba(255,255,255,0.1); margin: 0.5rem 0;">
                    <a href="${pageContext.request.contextPath}/logout" class="dropdown-item" style="color: #ff6b6b;">🚪 Đăng xuất</a> <%-- Common logout servlet --%>
                </div>
            </div>
        </nav>

        <div class="dashboard-header">
            <h1 class="animate-bounce">🎭 Event Dashboard</h1>
            <p>Manage your events and track performance</p>
        </div>

        <div class="stats-grid">
            <div class="stat-card pulse">
                <div class="icon">🎫</div>
                <div class="number">125</div>
                <div class="label">Total Events</div>
            </div>
            <div class="stat-card">
                <div class="icon">👥</div>
                <div class="number">12,890</div>
                <div class="label">Total Attendees</div>
            </div>
            <div class="stat-card">
                <div class="icon">💰</div>
                <div class="number">$89,542</div>
                <div class="label">Total Revenue</div>
            </div>
            <div class="stat-card">
                <div class="icon">⭐</div>
                <div class="number">4.8</div>
                <div class="label">Average Rating</div>
            </div>
        </div>

        <div class="content-section">
            <div class="section-header">
                <h2>🎪 Recent Events</h2>
                <button class="btn btn-primary" onclick="openModal()">+ Create New Event</button>
            </div>
            
            <div class="event-list">
                <div class="event-item">
                    <div class="event-info">
                        <h3>Summer Music Festival 2024</h3>
                        <p>📍 Central Park • 📅 July 15, 2024 • 👥 2,500 attendees</p>
                    </div>
                    <div class="event-status status-active">Active</div>
                </div>
                
                <div class="event-item">
                    <div class="event-info">
                        <h3>Tech Conference: AI & Future</h3>
                        <p>📍 Convention Center • 📅 August 22, 2024 • 👥 1,200 attendees</p>
                    </div>
                    <div class="event-status status-pending">Pending</div>
                </div>
                
                <div class="event-item">
                    <div class="event-info">
                        <h3>Food & Wine Expo</h3>
                        <p>📍 Downtown Plaza • 📅 June 10, 2024 • 👥 3,800 attendees</p>
                    </div>
                    <div class="event-status status-ended">Ended</div>
                </div>
                
                <div class="event-item">
                    <div class="event-info">
                        <h3>Art Gallery Opening</h3>
                        <p>📍 Modern Art Museum • 📅 September 5, 2024 • 👥 800 attendees</p>
                    </div>
                    <div class="event-status status-active">Active</div>
                </div>
            </div>
        </div>

        <div class="content-section">
            <div class="section-header">
                <h2>⚡ Quick Actions</h2>
            </div>
            
            <div class="quick-actions">
                <a href="${pageContext.request.contextPath}/createEvent" class="action-btn">
                    <span>📝</span>
                    Create Event
                </a>
                <a href="#" class="action-btn">
                    <span>📊</span>
                    View Reports
                </a>
                <a href="#" class="action-btn">
                    <span>🎫</span>
                    Manage Tickets
                </a>
                <a href="#" class="action-btn">
                    <span>💬</span>
                    Customer Support
                </a>
                <a href="#" class="action-btn">
                    <span>📈</span>
                    Analytics
                </a>
                <a href="#" class="action-btn">
                    <span>⚙️</span>
                    Settings
                </a>
            </div>
        </div>
    </div>

    <div id="eventModal" class="modal">
        <div class="modal-content">
            <button class="close-btn" onclick="closeModal()">&times;</button>
            <h2 style="color: #4CAF50; margin-bottom: 20px;">🎭 Create New Event</h2>
            <p style="margin-bottom: 20px;">Ready to create an amazing event experience?</p>
            <div style="display: flex; gap: 15px; justify-content: center;">
                <button class="btn btn-primary" onclick="window.location.href='${pageContext.request.contextPath}/createEvent/NotesWhenPostEvent.jsp'">Start Creating</button>
                <button class="btn" style="background: rgba(255,255,255,0.2); color: white;" onclick="closeModal()">Cancel</button>
            </div>
        </div>
    </div>

    <footer class="footer">
        <div class="footer-content">
            <div class="footer-section">
                <h3>Customer Services</h3>
                <ul>
                    <li><a href="#">FAQS</a></li>
                    <li><a href="#">Contact us</a></li>
                    <li><a href="#">Privacy Policy</a></li>
                    <li><a href="#">Terms of Service</a></li>
                </ul>
            </div>
            
            <div class="footer-section">
                <h3>SiteMap</h3>
                <ul>
                    <li><a href="#">Create Account</a></li>
                    <li><a href="#">News</a></li>
                    <li><a href="#">Top-Rated Events</a></li>
                </ul>
            </div>
            
            <div class="footer-section">
                <h3>Subscribe for event updates</h3>
                <p>Get the latest news about upcoming events</p>
                <div class="email-subscribe">
                    <input type="email" placeholder="Your email...">
                    <button class="btn btn-primary">Subscribe</button>
                </div>
                
                <h4 style="margin-top: 20px;">Follow us:</h4>
                <div class="social-icons">
                    <a href="#" title="Facebook">📘</a>
                    <a href="#" title="Instagram">📷</a>
                    <a href="#" title="Twitter">🐦</a>
                    <a href="#" title="YouTube">📺</a>
                </div>
            </div>
            
            <div class="footer-section">
                <h3>Contact Information</h3>
                <p>📧 Email: <a href="mailto:support@masterticket.vn">support@masterticket.vn</a></p>
                <p>📱 Phone: +84 123 456 789</p>
                <p>🏢 Address: 123 Tech Street, District 1, Ho Chi Minh City</p>
            </div>
        </div>
    </footer>

    <script>
        function openModal() {
            document.getElementById('eventModal').style.display = 'block';
        }

        function closeModal() {
            document.getElementById('eventModal').style.display = 'none';
        }

        // Close modal when clicking outside
        window.onclick = function(event) {
            const modal = document.getElementById('eventModal');
            if (event.target == modal) {
                modal.style.display = 'none';
            }
        }

        // Function to toggle the user dropdown menu
        function toggleUserDropdown() {
            const dropdown = document.getElementById('userDropdown');
            dropdown.classList.toggle('show');
        }

        // Close the dropdown if the user clicks outside of it
        window.addEventListener('click', function(event) {
            const userInfoArea = document.querySelector('.user-info');
            const dropdown = document.getElementById('userDropdown');
            if (!userInfoArea.contains(event.target) && dropdown.classList.contains('show')) {
                dropdown.classList.remove('show');
            }
        });

        // Add some interactive effects
        document.querySelectorAll('.stat-card').forEach(card => {
            card.addEventListener('mouseenter', function() {
                this.style.transform = 'translateY(-10px) scale(1.02)';
            });
            
            card.addEventListener('mouseleave', function() {
                this.style.transform = 'translateY(-5px) scale(1)';
            });
        });

        // Animate numbers on load
        window.addEventListener('load', function() {
            const numbers = document.querySelectorAll('.number');
            numbers.forEach(num => {
                const finalValue = num.textContent;
                let currentValue = 0;
                const increment = parseInt(finalValue.replace(/[^0-9]/g, '')) / 50;
                
                const timer = setInterval(() => {
                    currentValue += increment;
                    if (currentValue >= parseInt(finalValue.replace(/[^0-9]/g, ''))) {
                        num.textContent = finalValue;
                        clearInterval(timer);
                    } else {
                        if (finalValue.includes('$')) {
                            num.textContent = '$' + Math.floor(currentValue).toLocaleString();
                        } else if (finalValue.includes('.')) {
                            num.textContent = (currentValue / 1000).toFixed(1);
                        } else {
                            num.textContent = Math.floor(currentValue).toLocaleString();
                        }
                    }
                }, 50);
            });
        });
    </script>
</body>
</html>