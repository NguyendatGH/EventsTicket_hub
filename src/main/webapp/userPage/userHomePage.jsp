<%-- 
    Document   : userHomePage
    Created on : Jun 3, 2025, 5:28:06 AM
    Author     : Huy Nguyen
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="models.Event"%>
<%@page import="models.User"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>MasterTicket - Trang Chủ Người Dùng</title>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: linear-gradient(135deg, #1a1a2e 0%, #16213e 50%, #0f3460 100%);
                color: white;
                min-height: 100vh;
            }

            /* Header */
            .header {
                background: rgba(0, 0, 0, 0.3);
                backdrop-filter: blur(10px);
                padding: 1rem 2rem;
                position: sticky;
                top: 0;
                z-index: 100;
                border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            }

            .nav {
                display: flex;
                justify-content: space-between;
                align-items: center;
                max-width: 1400px;
                margin: 0 auto;
            }

            .logo {
                font-size: 1.5rem;
                font-weight: bold;
                color: #ff6b6b;
            }

            .nav-links {
                display: flex;
                gap: 2rem;
                list-style: none;
            }

            .nav-links a {
                color: white;
                text-decoration: none;
                transition: color 0.3s;
            }

            .nav-links a:hover {
                color: #ff6b6b;
            }

            .search-container {
                position: relative;
                flex: 1;
                max-width: 400px;
                margin: 0 2rem;
            }

            .search-box {
                width: 100%;
                padding: 0.75rem 1rem;
                background: rgba(255, 255, 255, 0.1);
                border: 1px solid rgba(255, 255, 255, 0.2);
                border-radius: 25px;
                color: white;
                outline: none;
                transition: all 0.3s;
            }

            .search-box::placeholder {
                color: rgba(255, 255, 255, 0.6);
            }

            .search-box:focus {
                background: rgba(255, 255, 255, 0.15);
                border-color: #ff6b6b;
            }

            /* User Menu */
            .user-menu {
                display: flex;
                align-items: center;
                gap: 1rem;
                position: relative;
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
                width: 35px;
                height: 35px;
                border-radius: 50%;
                background: linear-gradient(45deg, #ff6b6b, #4ecdc4);
                display: flex;
                align-items: center;
                justify-content: center;
                font-weight: bold;
                font-size: 0.9rem;
            }

            .user-dropdown {
                position: absolute;
                top: 100%;
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
                transition: all 0.3s;
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
                padding: 0.5rem 0;
                border-bottom: 1px solid rgba(255, 255, 255, 0.1);
                transition: color 0.3s;
            }

            .dropdown-item:last-child {
                border-bottom: none;
            }

            .dropdown-item:hover {
                color: #ff6b6b;
            }

            .btn {
                padding: 0.5rem 1.5rem;
                border: none;
                border-radius: 25px;
                cursor: pointer;
                font-weight: 500;
                transition: all 0.3s;
                text-decoration: none;
                display: inline-block;
                text-align: center;
            }

            .btn-outline {
                background: transparent;
                color: white;
                border: 1px solid rgba(255, 255, 255, 0.3);
            }

            .btn-outline:hover {
                background: rgba(255, 255, 255, 0.1);
            }

            .btn-primary {
                background: linear-gradient(45deg, #ff6b6b, #ff8e8e);
                color: white;
            }

            .btn-primary:hover {
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(255, 107, 107, 0.4);
            }

            /* Welcome Banner */
            .welcome-banner {
                background: linear-gradient(135deg, #ff6b6b, #4ecdc4);
                border-radius: 15px;
                padding: 2rem;
                margin-bottom: 2rem;
                text-align: center;
                position: relative;
                overflow: hidden;
            }

            .welcome-banner::before {
                content: '';
                position: absolute;
                top: -50%;
                left: -50%;
                width: 200%;
                height: 200%;
                background: radial-gradient(circle, rgba(255, 255, 255, 0.1) 0%, transparent 70%);
                animation: rotate 20s linear infinite;
            }

            @keyframes rotate {
                0% {
                    transform: rotate(0deg);
                }
                100% {
                    transform: rotate(360deg);
                }
            }

            .welcome-content {
                position: relative;
                z-index: 1;
            }

            .welcome-title {
                font-size: 2rem;
                margin-bottom: 0.5rem;
            }

            .welcome-subtitle {
                font-size: 1.1rem;
                opacity: 0.9;
            }

            /* Quick Stats */
            .quick-stats {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 1rem;
                margin-bottom: 2rem;
            }

            .stat-card {
                background: rgba(255, 255, 255, 0.05);
                border-radius: 10px;
                padding: 1.5rem;
                text-align: center;
                border: 1px solid rgba(255, 255, 255, 0.1);
                transition: all 0.3s;
            }

            .stat-card:hover {
                background: rgba(255, 255, 255, 0.08);
                transform: translateY(-2px);
            }

            .stat-number {
                font-size: 2rem;
                font-weight: bold;
                color: #ff6b6b;
                margin-bottom: 0.5rem;
            }

            .stat-label {
                color: rgba(255, 255, 255, 0.8);
                font-size: 0.9rem;
            }

            /* Main Content */
            .container {
                max-width: 1400px;
                margin: 0 auto;
                padding: 2rem;
            }

            /* Hero Carousel */
            .hero-carousel {
                position: relative;
                height: 400px;
                border-radius: 20px;
                overflow: hidden;
                margin-bottom: 3rem;
                box-shadow: 0 20px 40px rgba(0, 0, 0, 0.3);
            }

            .carousel-slide {
                position: absolute;
                width: 100%;
                height: 100%;
                background: linear-gradient(45deg, #ff6b6b, #4ecdc4);
                display: flex;
                align-items: center;
                justify-content: space-between;
                padding: 3rem;
                opacity: 0;
                transition: opacity 0.5s;
            }

            .carousel-slide.active {
                opacity: 1;
            }

            .carousel-content h2 {
                font-size: 2.5rem;
                margin-bottom: 1rem;
                text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.3);
            }

            .carousel-content p {
                font-size: 1.2rem;
                margin-bottom: 2rem;
                opacity: 0.9;
            }

            .carousel-indicators {
                position: absolute;
                bottom: 20px;
                left: 50%;
                transform: translateX(-50%);
                display: flex;
                gap: 10px;
            }

            .indicator {
                width: 12px;
                height: 12px;
                border-radius: 50%;
                background: rgba(255, 255, 255, 0.5);
                cursor: pointer;
                transition: all 0.3s;
            }

            .indicator.active {
                background: white;
                transform: scale(1.2);
            }

            /* Section Headers */
            .section-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin: 3rem 0 2rem;
            }

            .section-title {
                font-size: 1.8rem;
                font-weight: bold;
            }

            .view-all {
                color: #ff6b6b;
                text-decoration: none;
                font-weight: 500;
                transition: color 0.3s;
            }

            .view-all:hover {
                color: #ff8e8e;
            }

            /* Event Grid */
            .event-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
                gap: 2rem;
                margin-bottom: 3rem;
            }

            .event-card {
                background: rgba(255, 255, 255, 0.05);
                border-radius: 15px;
                overflow: hidden;
                transition: all 0.3s;
                border: 1px solid rgba(255, 255, 255, 0.1);
                cursor: pointer;
            }

            .event-card:hover {
                transform: translateY(-10px);
                box-shadow: 0 20px 40px rgba(0, 0, 0, 0.3);
                background: rgba(255, 255, 255, 0.08);
            }

            .event-image {
                width: 100%;
                height: 200px;
                object-fit: cover;
                background: linear-gradient(45deg, #ff6b6b, #4ecdc4);
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
            }

            .event-image img {
                width: 100%;
                height: 100%;
                object-fit: cover;
            }

            .event-info {
                padding: 1.5rem;
            }

            .event-title {
                font-size: 1.2rem;
                font-weight: bold;
                margin-bottom: 0.5rem;
                color: white;
            }

            .event-date {
                color: #ff6b6b;
                font-size: 0.9rem;
                margin-bottom: 0.5rem;
            }

            .event-location {
                color: rgba(255, 255, 255, 0.7);
                font-size: 0.9rem;
                margin-bottom: 1rem;
            }

            .event-description {
                color: rgba(255, 255, 255, 0.8);
                font-size: 0.85rem;
                line-height: 1.4;
                margin-bottom: 1rem;
                display: -webkit-box;
                -webkit-line-clamp: 2;
                -webkit-box-orient: vertical;
                overflow: hidden;
            }

            .event-price {
                font-size: 1.1rem;
                font-weight: bold;
                color: #4ecdc4;
            }

            /* No Events Message */
            .no-events {
                text-align: center;
                padding: 4rem 2rem;
                color: rgba(255, 255, 255, 0.7);
            }

            .no-events h2 {
                font-size: 2rem;
                margin-bottom: 1rem;
                color: #ff6b6b;
            }

            /* Footer */
            .footer {
                background: rgba(0, 0, 0, 0.5);
                padding: 3rem 2rem 2rem;
                margin-top: 4rem;
            }

            .footer-content {
                max-width: 1400px;
                margin: 0 auto;
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                gap: 2rem;
            }

            .footer-section h3 {
                color: #ff6b6b;
                margin-bottom: 1rem;
            }

            .footer-section ul {
                list-style: none;
            }

            .footer-section ul li {
                margin-bottom: 0.5rem;
            }

            .footer-section ul li a {
                color: rgba(255, 255, 255, 0.7);
                text-decoration: none;
                transition: color 0.3s;
            }

            .footer-section ul li a:hover {
                color: white;
            }

            .newsletter {
                display: flex;
                gap: 1rem;
                margin-top: 1rem;
            }

            .newsletter input {
                flex: 1;
                padding: 0.75rem;
                border: none;
                border-radius: 25px;
                background: rgba(255, 255, 255, 0.1);
                color: white;
                outline: none;
            }

            .newsletter input::placeholder {
                color: rgba(255, 255, 255, 0.6);
            }

            .social-links {
                display: flex;
                gap: 1rem;
                margin-top: 1rem;
            }

            .social-link {
                width: 40px;
                height: 40px;
                background: rgba(255, 255, 255, 0.1);
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                text-decoration: none;
                transition: all 0.3s;
            }

            .social-link:hover {
                background: #ff6b6b;
                transform: translateY(-2px);
            }

            /* Responsive */
            @media (max-width: 768px) {
                .nav {
                    flex-direction: column;
                    gap: 1rem;
                }

                .search-container {
                    max-width: 100%;
                    margin: 0;
                }

                .nav-links {
                    gap: 1rem;
                }

                .carousel-content h2 {
                    font-size: 1.8rem;
                }

                .event-grid {
                    grid-template-columns: 1fr;
                }

                .welcome-title {
                    font-size: 1.5rem;
                }

                .quick-stats {
                    grid-template-columns: 1fr;
                }

                .user-menu {
                    flex-direction: column;
                    align-items: stretch;
                }
            }
        </style>
    </head>
    <body>
        <%
            User user = (User) session.getAttribute("user");
            String userEmail = (user != null) ? user.getEmail() : "";
        %>

        <!-- Header -->
        <header class="header">
            <nav class="nav">
                <div class="logo">MasterTicket</div>
                <div class="search-container">
                    <input type="text" class="search-box" placeholder="Tìm sự kiện theo tên..." id="searchInput">
                </div>
                <ul class="nav-links">
                    <li><a href="#events">Trang chủ</a></li>
                    <li><a href="#venues">Sự kiện hot</a></li>
                    <li><a href="#about">Voucher giảm giá</a></li>
                    <li><a href="#contact">Vé đã mua</a></li>
                    <li><a href="#contact">Hỗ trợ</a></li>
                </ul>
                <div class="user-menu">
                    <div class="user-info" onclick="toggleUserDropdown()">
                        👤 Xin chào, <%= user.getEmail() %> <span style="margin-left: 0.5rem;">▼</span>
                    </div>
                    <div class="user-dropdown" id="userDropdown">
                        <a href="updateProfile" class="dropdown-item">👤 Thông tin cá nhân</a>
                        <a href="#tickets" class="dropdown-item">🎫 Vé đã mua</a>
                        <a href="#favorites" class="dropdown-item">❤️ Sự kiện yêu thích</a>
                        <a href="#settings" class="dropdown-item">⚙️ Cài đặt</a>
                        <hr style="border: none; border-top: 1px solid rgba(255,255,255,0.1); margin: 0.5rem 0;">
                        <a href="LogoutServlet" class="dropdown-item" style="color: #ff6b6b;">🚪 Đăng xuất</a>
                    </div>
                </div>
            </nav>
        </header>

        <!-- Main Content -->
        <main class="container">
            <!-- Welcome Banner -->
            <div class="welcome-banner">
                <div class="welcome-content">
                    <p class="welcome-subtitle">Khám phá những sự kiện thú vị và đặt vé ngay hôm nay</p>
                </div>
            </div>

            <!-- Hero Carousel -->
            <div class="hero-carousel">
                <div class="carousel-slide active">
                    <div class="carousel-content">
                        <h2>Khám phá sự kiện mới</h2>
                        <p>Tìm kiếm và đặt vé cho những sự kiện thú vị nhất trong tuần!</p>
                        <a href="#events" class="btn btn-primary">Khám phá ngay</a>
                    </div>
                </div>
                <div class="carousel-indicators">
                    <div class="indicator active"></div>
                    <div class="indicator"></div>
                    <div class="indicator"></div>
                </div>
            </div>

            <% 
            List<Event> events = (List<Event>) request.getAttribute("events");
            SimpleDateFormat dateFormat = new SimpleDateFormat("EEE, dd/MM/yyyy HH:mm");
        
            if (events == null || events.isEmpty()) { 
            %>
            <div class="no-events">
                <h2>Không có sự kiện nào!</h2>
                <p>Hiện tại chưa có sự kiện nào được tổ chức. Vui lòng quay lại sau!</p>
            </div>
            <% } else { %>
            <!-- Featured Events Section -->
            <div class="section-header">
                <h2 class="section-title" id="events">Sự kiện dành cho bạn</h2>
                <a href="#all-events" class="view-all">Xem tất cả</a>
            </div>

            <div class="event-grid">
                <% 
                int featuredCount = 0;
                for (Event event : events) { 
                    if (featuredCount >= 3) break;
                    featuredCount++;
                %>
                <div class="event-card searchable-event" onclick="selectEvent('<%= event.getName().replace("'", "\\'") %>')">
                    <div class="event-image">
                        <% if (event.getImageURL() != null && !event.getImageURL().trim().isEmpty()) { %>
                        <img src="<%= event.getImageURL() %>" alt="<%= event.getName() %>" />
                        <% } else { %>
                        🎫
                        <% } %>
                    </div>
                    <div class="event-info">
                        <div class="event-title"><%= event.getName() %></div>
                        <div class="event-date">
                            🗓️ <%= dateFormat.format(event.getStartTime()) %> - <%= dateFormat.format(event.getEndTime()) %>
                        </div>
                        <div class="event-location">📍 <%= event.getPhysicalLocation() %></div>
                        <div class="event-description"><%= event.getDescription() %></div>
                        <div class="event-price">Từ 150,000 VNĐ</div>
                    </div>
                </div>
                <% } %>
            </div>

            <!-- All Events Section -->
            <div class="section-header">
                <h2 class="section-title" id="all-events">Tất cả sự kiện</h2>
                <span class="view-all">Tổng cộng: <%= events.size() %> sự kiện</span>
            </div>

            <div class="event-grid">
                <% for (Event event : events) { %>
                <div class="event-card searchable-event" onclick="selectEvent('<%= event.getName().replace("'", "\\'") %>')">
                    <div class="event-image">
                        <% if (event.getImageURL() != null && !event.getImageURL().trim().isEmpty()) { %>
                        <img src="<%= event.getImageURL() %>" alt="<%= event.getName() %>" />
                        <% } else { %>
                        🎫
                        <% } %>
                    </div>
                    <div class="event-info">
                        <div class="event-title"><%= event.getName() %></div>
                        <div class="event-date">
                            🗓️ <%= dateFormat.format(event.getStartTime()) %> - <%= dateFormat.format(event.getEndTime()) %>
                        </div>
                        <div class="event-location">📍 <%= event.getPhysicalLocation() %></div>
                        <div class="event-description"><%= event.getDescription() %></div>
                        <div class="event-price">Từ 150,000 VNĐ</div>
                    </div>
                </div>
                <% } %>
            </div>
            <% } %>
        </main>

        <!-- Footer -->
        <footer class="footer">
            <div class="footer-content">
                <div class="footer-section">
                    <h3>Tài khoản của bạn</h3>
                    <ul>
                        <li><a href="#profile">Thông tin cá nhân</a></li>
                        <li><a href="#tickets">Vé đã mua</a></li>
                        <li><a href="#favorites">Sự kiện yêu thích</a></li>
                        <li><a href="#settings">Cài đặt tài khoản</a></li>
                    </ul>
                </div>
                <div class="footer-section">
                    <h3>Dịch vụ khách hàng</h3>
                    <ul>
                        <li><a href="#">FAQ</a></li>
                        <li><a href="#">Liên hệ hỗ trợ</a></li>
                        <li><a href="#">Chính sách hoàn tiền</a></li>
                        <li><a href="#">Điều khoản sử dụng</a></li>
                    </ul>
                </div>
                <div class="footer-section">
                    <h3>Nhận thông báo</h3>
                    <p>Cập nhật về sự kiện mới và ưu đãi đặc biệt</p>
                    <div class="newsletter">
                        <input type="email" placeholder="<%= userEmail %>" value="<%= userEmail %>">
                        <button class="btn btn-primary">Cập nhật</button>
                    </div>
                    <div class="social-links">
                        <a href="#" class="social-link">f</a>
                        <a href="#" class="social-link">t</a>
                        <a href="#" class="social-link">i</a>
                    </div>
                </div>
            </div>
        </footer>
    </body>

        <script>
            function toggleUserDropdown() {
                const dropdown = document.getElementById("userDropdown");
                dropdown.classList.toggle("show");
            }

            // Đóng dropdown nếu click ra ngoài
            window.addEventListener("click", function (e) {
                const userInfo = document.querySelector(".user-info");
                const dropdown = document.getElementById("userDropdown");

                if (!userInfo.contains(e.target) && !dropdown.contains(e.target)) {
                    dropdown.classList.remove("show");
                }
            });

            // Function to handle event selection
            function selectEvent(eventName) {
                // In a real application, this would redirect to event details page
                if (confirm(`Bạn muốn xem chi tiết sự kiện: ${eventName}?`)) {
                    // Redirect to event details or booking page
                    alert('Chuyển hướng đến trang chi tiết sự kiện...');
                }
            }

            // Search functionality
            function setupSearch() {
                const searchBox = document.getElementById('searchInput');
                if (searchBox) {
                    searchBox.addEventListener('input', (e) => {
                        const query = e.target.value.toLowerCase();
                        const eventCards = document.querySelectorAll('.searchable-event');

                        eventCards.forEach(card => {
                            const title = card.querySelector('.event-title');
                            const description = card.querySelector('.event-description');
                            const location = card.querySelector('.event-location');

                            if (title && description && location) {
                                const titleText = title.textContent.toLowerCase();
                                const descText = description.textContent.toLowerCase();
                                const locText = location.textContent.toLowerCase();

                                if (titleText.includes(query) || descText.includes(query) || locText.includes(query)) {
                                    card.style.display = 'block';
                                    card.style.animation = 'fadeInUp 0.3s ease-out';
                                } else {
                                    card.style.display = 'none';
                                }
                            }
                        });
                    });
                }
            }

            // Carousel functionality
            function setupCarousel() {
                const slides = document.querySelectorAll('.carousel-slide');
                const indicators = document.querySelectorAll('.indicator');
                let currentSlide = 0;

                if (slides.length > 0 && indicators.length > 0) {
                    function showSlide(index) {
                        slides.forEach(slide => slide.classList.remove('active'));
                        indicators.forEach(indicator => indicator.classList.remove('active'));

                        if (slides[index] && indicators[index]) {
                            slides[index].classList.add('active');
                            indicators[index].classList.add('active');
                        }
                    }

                    function nextSlide() {
                        currentSlide = (currentSlide + 1) % slides.length;
                        showSlide(currentSlide);
                    }

                    indicators.forEach((indicator, index) => {
                        indicator.addEventListener('click', () => {
                            currentSlide = index;
                            showSlide(currentSlide);
                        });
                    });

                    // Auto advance carousel
                    setInterval(nextSlide, 5000);
                }
            }
       </script>
            
            

