<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="models.Event"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>MasterTicket - Vé Sự Kiện</title>
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

            .auth-buttons {
                display: flex;
                gap: 1rem;
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

            /* Ticket Purchase Section */
            .ticket-section {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                border-radius: 20px;
                padding: 3rem;
                margin: 3rem 0;
                text-align: center;
                position: relative;
                overflow: hidden;
            }

            .ticket-section::before {
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

            .ticket-content {
                position: relative;
                z-index: 1;
            }

            .ticket-title {
                font-size: 2.5rem;
                margin-bottom: 1rem;
            }

            .ticket-subtitle {
                font-size: 1.2rem;
                margin-bottom: 2rem;
                opacity: 0.9;
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

                .ticket-title {
                    font-size: 2rem;
                }
            }
        </style>
    </head>
    <body>
        <!-- Header -->
        <header class="header">
            <nav class="nav">
                <div class="logo">MasterTicket</div>
                <div class="search-container">
                    <input type="text" class="search-box" placeholder="Tìm sự kiện theo tên..." id="searchInput">
                </div>
                <ul class="nav-links">
                    <li><a href="#events">Trang chủ</a></li>
                    <li><a href="#venues">Các sự kiện hot</a></li>
                    <li><a href="#about">Săn voucher giảm giá</a></li>
                    <li><a href="#contact">Tạo sự kiện</a></li>
                    <li><a href="#contact">Hỗ trợ</a></li>

                </ul>
                <div class="auth-buttons">
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <%-- Nếu người dùng đã đăng nhập, hiển thị email và nút Đăng xuất --%>
                            <span style="color: white; align-self: center; margin-right: 15px;">Xin chào, ${sessionScope.user.email}</span>
                            <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline">Đăng xuất</a>
                        </c:when>
                        <c:otherwise>
                            <%-- Nếu người dùng chưa đăng nhập, hiển thị như cũ --%>
                            <a href="${pageContext.request.contextPath}/login" class="btn btn-outline">Đăng nhập</a>
                            <a href="${pageContext.request.contextPath}/register" class="btn btn-primary">Đăng ký</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </nav>
        </header>

        <!-- Main Content -->
        <main class="container">
            <!-- Hero Carousel -->
            <div class="hero-carousel">
                <div class="carousel-slide active">
                    <div class="carousel-content">
                        <h2>Chào mừng đến với MasterTicket</h2>
                        <p>Khám phá hàng ngàn sự kiện thú vị và đặt vé ngay hôm nay!</p>
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
                <h2 class="section-title" id="events">Sự kiện nổi bật</h2>
                <a href="#all-events" class="view-all">Xem tất cả</a>
            </div>

            <div class="event-grid">
                <% if (events != null) { %>
                <% for (Event event : events) { %>
                <div class="event-card searchable-event" 
                     data-event-id="<%= event.getEventID() %>"  <%-- Lưu EventID vào data attribute --%>
                     onclick="navigateToEventDetail(this.getAttribute('data-event-id'))" 
                     style="cursor: pointer;">

                    <div class="event-image">
                        <% if (event.getImageURL() != null && !event.getImageURL().trim().isEmpty()) { %>
                        <img src="<%= event.getImageURL() %>" alt="<%= event.getName() %>" />
                        <% } else { %>
                        <span style="font-size: 50px; display: flex; justify-content: center; align-items: center; height: 100%; background-color: #e0e0e0;">🎫</span>
                        <% } %>
                    </div>
                    <div class="event-info">
                        <div class="event-title"><%= event.getName() %></div>
                        <div class="event-date">
                            <% if (event.getStartTime() != null && event.getEndTime() != null && dateFormat != null) { %>
                            🗓️ <%= dateFormat.format(event.getStartTime()) %> - <%= dateFormat.format(event.getEndTime()) %>
                            <% } else { %>
                            🗓️ Thời gian không xác định
                            <% } %>
                        </div>
                        <div class="event-location">📍 <%= event.getPhysicalLocation() != null ? event.getPhysicalLocation() : "Địa điểm không xác định" %></div>
                        <div class="event-description" style="white-space: nowrap; overflow: hidden; text-overflow: ellipsis; max-width: 200px; max-height: 3.6em; line-height: 1.2em;">
                            <%= event.getDescription() != null ? event.getDescription() : "" %>
                        </div>
                        <div class="event-price">Từ 150,000 VNĐ</div>
                    </div>
                </div>
                <% } %>
                <% } else { %>
                <p>Không có sự kiện nào để hiển thị.</p>
                <% } %>
            </div>

            <%-- Đặt đoạn script này ở cuối trang, hoặc trong một file .js riêng --%>
            <script type="text/javascript">
                function navigateToEventDetail(eventId) {
                    if (eventId) {
                        // Nếu ứng dụng của bạn có context path, bạn cần xử lý nó ở đây
                        // ví dụ: var contextPath = "${pageContext.request.contextPath}";
                        // window.location.href = contextPath + "/EventServlet?id=" + eventId;
                        window.location.href = "EventServlet?id=" + eventId;
                    } else {
                        console.error("Event ID is missing.");
                    }
                }
            </script>

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

        <div class="ticket-section">
            <div class="ticket-content">
                <h2 class="ticket-title">Mua vé của bạn</h2>
                <p class="ticket-subtitle">Đơn giản, nhanh chóng và an toàn</p>
                <a href="login" class="btn btn-primary">Bắt đầu mua vé</a>
            </div>
        </div>
    </main>

    <!-- Footer -->
    <footer class="footer">
        <div class="footer-content">
            <div class="footer-section">
                <h3>Dịch vụ khách hàng</h3>
                <ul>
                    <li><a href="#">FAQ</a></li>
                    <li><a href="#">Liên hệ</a></li>
                    <li><a href="#">Chính sách</a></li>
                    <li><a href="#">Điều khoản</a></li>
                </ul>
            </div>
            <div class="footer-section">
                <h3>Về chúng tôi</h3>
                <ul>
                    <li><a href="#">Tạo tài khoản</a></li>
                    <li><a href="#">Tin tức</a></li>
                    <li><a href="#">Sự kiện hàng đầu</a></li>
                </ul>
            </div>
            <div class="footer-section">
                <h3>Đăng ký nhận thông tin</h3>
                <p>Nhận thông báo về các sự kiện mới</p>
                <div class="newsletter">
                    <input type="email" placeholder="Email của bạn...">
                    <button class="btn btn-primary">Đăng ký</button>
                </div>
                <div class="social-links">
                    <a href="#" class="social-link">f</a>
                    <a href="#" class="social-link">t</a>
                    <a href="#" class="social-link">i</a>
            <!-- Ticket Purchase Section -->
            <div class="ticket-section">
                <div class="ticket-content">
                    <h2 class="ticket-title">Mua vé của bạn</h2>
                    <p class="ticket-subtitle">Đơn giản, nhanh chóng và an toàn</p>
                    <a href="#" class="btn btn-primary">Bắt đầu mua vé</a>
                </div>
            </div>
        </main>

        <!-- Footer -->
        <footer class="footer">
            <div class="footer-content">
                <div class="footer-section">
                    <h3>Dịch vụ khách hàng</h3>
                    <ul>
                        <li><a href="#">FAQ</a></li>
                        <li><a href="#">Liên hệ</a></li>
                        <li><a href="#">Chính sách</a></li>
                        <li><a href="#">Điều khoản</a></li>
                    </ul>
                </div>
                <div class="footer-section">
                    <h3>Về chúng tôi</h3>
                    <ul>
                        <li><a href="#">Tạo tài khoản</a></li>
                        <li><a href="#">Tin tức</a></li>
                        <li><a href="#">Sự kiện hàng đầu</a></li>
                    </ul>
                </div>
                <div class="footer-section">
                    <h3>Đăng ký nhận thông tin</h3>
                    <p>Nhận thông báo về các sự kiện mới</p>
                    <div class="newsletter">
                        <input type="email" placeholder="Email của bạn...">
                        <button class="btn btn-primary">Đăng ký</button>
                    </div>
                    <div class="social-links">
                        <a href="#" class="social-link">f</a>
                        <a href="#" class="social-link">t</a>
                        <a href="#" class="social-link">i</a>
                    </div>
                </div>
            </div>
        </footer>

        <script>
            // Function to handle event selection
            function selectEvent(eventName) {
                alert(`Bạn đã chọn sự kiện: ${eventName}\n\nChức năng mua vé sẽ được triển khai sau!`);
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

            // Initialize page
            document.addEventListener('DOMContentLoaded', () => {
                setupSearch();
                setupCarousel();
            });

            // Smooth scrolling for navigation links
            document.querySelectorAll('a[href^="#"]').forEach(anchor => {
                anchor.addEventListener('click', function (e) {
                    e.preventDefault();
                    const targetId = this.getAttribute('href').substring(1);
                    const target = document.getElementById(targetId);
                    if (target) {
                        target.scrollIntoView({
                            behavior: 'smooth',
                            block: 'start'
                        });
                    }
                });
            });
        </script>
    </body>
</html>