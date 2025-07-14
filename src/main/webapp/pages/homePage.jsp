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
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: linear-gradient(to bottom, #161b22, #0d1117);
                color: var(--text-light);
                min-height: 100vh;
            }

            /* Color Scheme from EventDetails.jsp */
            :root {
                --primary: #667aff;      /* Primary color */
                --secondary: #e06bce;    /* Secondary color */
                --dark-bg: #161b22;      /* Gradient start */
                --darker-bg: #0d1117;    /* Gradient end */
                --card-bg: #21262d;      /* Card background */
                --border-color: #30363d; /* Border color */
                --text-light: #e6edf3;   /* Main text color */
                --text-muted: #8b949e;   /* Muted text color */
                --success: #00cc66;      /* Success/price color */
                --warning: #ffcc00;      /* Warning color */
                --danger: #ff3333;       /* Error color */
            }

            /* Header */
            .header {
                background: var(--darker-bg);
                padding: 1rem 2rem;
                position: sticky;
                top: 0;
                z-index: 100;
                border-bottom: 1px solid var(--border-color);
            }

            .nav {
                display: flex;
                justify-content: space-between;
                align-items: center;
                max-width: 1400px;
                margin: 0 auto;
                flex-wrap: wrap;
            }

            .logo {
                font-size: 1.5rem;
                font-weight: bold;
                color: var(--primary);
                text-decoration: none;
            }

            .nav-links {
                display: flex;
                gap: 1.5rem;
                list-style: none;
                flex-wrap: wrap;
            }

            .nav-links a {
                color: var(--text-light);
                text-decoration: none;
                transition: color 0.3s;
                display: flex;
                align-items: center;
                gap: 5px;
            }

            .nav-links a:hover {
                color: var(--primary);
            }

            .search-filter-toggle {
                background: none;
                border: none;
                color: var(--text-light);
                font-size: 1.2rem;
                cursor: pointer;
                padding: 0.5rem;
                display: none; /* Hidden by default, shown on smaller screens */
            }

            .search-filter-container {
                display: flex;
                flex-wrap: wrap;
                gap: 10px;
                flex: 1;
                max-width: 600px; /* Adjust as needed */
                margin: 0.5rem 1rem;
                width: 100%;
                align-items: center; /* Align items vertically */
            }

            .search-box, .filter-input {
                flex: 1;
                padding: 0.75rem 1rem;
                background: var(--card-bg);
                border: 1px solid var(--border-color);
                border-radius: 25px;
                color: var(--text-light);
                outline: none;
                transition: all 0.3s;
            }

            .search-box::placeholder, .filter-input::placeholder {
                color: var(--text-muted);
            }

            .search-box:focus, .filter-input:focus {
                background: rgba(255, 255, 255, 0.1);
                border-color: var(--primary);
            }

            .auth-buttons {
                display: flex;
                gap: 0.75rem;
                align-items: center;
                flex-wrap: wrap;
            }

            .btn {
                padding: 0.6rem 1.8rem;
                border: none;
                border-radius: 25px;
                cursor: pointer;
                font-weight: 500;
                font-size: 0.9rem;
                transition: all 0.3s;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                min-width: 100px;
                color: var(--text-light);
            }

            .btn-outline {
                background: transparent;
                border: 1px solid var(--border-color);
            }

            .btn-outline:hover {
                background: rgba(102, 122, 255, 0.2);
                color: var(--primary);
                border-color: var(--primary);
            }

            .btn-primary {
                background: var(--primary);
            }

            .btn-primary:hover {
                background: #5566dd;
                transform: translateY(-2px);
            }

            .user-greeting {
                color: var(--text-light);
                font-size: 0.9rem;
                margin-right: 0.75rem;
                white-space: nowrap;
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
                border-radius: 16px;
                overflow: hidden;
                margin-bottom: 3rem;
                box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
            }

            .carousel-slide {
                position: absolute;
                width: 100%;
                height: 100%;
                background: linear-gradient(to right, var(--primary) 40%, var(--secondary) 100%); /* Fallback */
                background-image: url('https://images.unsplash.com/photo-1514525253161-7a46d19cd819?ixlib=rb-4.0.3&auto=format&fit=crop&w=1400&q=80'); /* Event-related image */
                background-size: cover;
                background-position: center;
                display: flex;
                align-items: center;
                justify-content: space-between;
                padding: 2rem;
                opacity: 0;
                transition: opacity 0.5s;
            }

            .carousel-slide::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0, 0, 0, 0.3); /* Dark tint for readability */
                z-index: 1;
            }

            .carousel-slide.active {
                opacity: 1;
            }

            .carousel-content {
                position: relative;
                background: rgba(0, 0, 0, 0.5); /* Semi-transparent overlay */
                padding: 1.5rem;
                border-radius: 10px;
                max-width: 50%;
                z-index: 2; /* Above tint */
            }

            .carousel-content h2 {
                font-size: clamp(1.8rem, 5vw, 2.5rem);
                margin-bottom: 1rem;
                color: var(--text-light);
                text-shadow: 0 2px 4px rgba(0, 0, 0, 0.5);
            }

            .carousel-content p {
                font-size: clamp(1rem, 3vw, 1.2rem);
                margin-bottom: 2rem;
                color: var(--text-light);
                text-shadow: 0 1px 2px rgba(0, 0, 0, 0.3);
            }

            .carousel-indicators {
                position: absolute;
                bottom: 20px;
                left: 50%;
                transform: translateX(-50%);
                display: flex;
                gap: 10px;
                z-index: 2;
            }

            .indicator {
                width: 12px;
                height: 12px;
                border-radius: 50%;
                background: var(--text-muted);
                cursor: pointer;
                transition: all 0.3s;
            }

            .indicator.active {
                background: var(--text-light);
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
                color: var(--primary);
            }

            .view-all {
                color: var(--primary);
                text-decoration: none;
                font-weight: 500;
                transition: color 0.3s;
            }

            .view-all:hover {
                color: #5566dd;
            }

            /* Event Grid */
            .event-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
                gap: 2rem;
                margin-bottom: 3rem;
            }

            .event-card {
                background: var(--card-bg);
                border-radius: 15px;
                overflow: hidden;
                transition: all 0.3s;
                border: 1px solid var(--border-color);
                cursor: pointer;
            }

            .event-card:hover {
                transform: translateY(-10px);
                box-shadow: 0 20px 40px rgba(0, 0, 0, 0.3);
                background: rgba(255, 255, 255, 0.08);
                border-color: var(--primary);
            }

            .event-image {
                width: 100%;
                height: 200px;
                object-fit: cover;
                background: linear-gradient(45deg, var(--primary), var(--secondary));
                display: flex;
                align-items: center;
                justify-content: center;
                color: var(--text-light);
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
                color: var(--text-light);
            }

            .event-date {
                color: var(--primary);
                font-size: 0.9rem;
                margin-bottom: 0.5rem;
            }

            .event-location {
                color: var(--text-muted);
                font-size: 0.9rem;
                margin-bottom: 1rem;
            }

            .event-description {
                color: var(--text-muted);
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
                color: var(--success);
            }

            /* Ticket Purchase Section */
            .ticket-section {
                background: linear-gradient(135deg, var(--primary), var(--secondary));
                border-radius: 20px;
                padding: 2rem;
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
                0% { transform: rotate(0deg); }
                100% { transform: rotate(360deg); }
            }

            .ticket-content {
                position: relative;
                z-index: 1;
            }

            .ticket-title {
                font-size: clamp(1.8rem, 5vw, 2.5rem);
                margin-bottom: 1rem;
                color: var(--text-light);
            }

            .ticket-subtitle {
                font-size: clamp(1rem, 3vw, 1.2rem);
                margin-bottom: 2rem;
                color: var(--text-muted);
            }

            /* No Events Message */
            .no-events {
                text-align: center;
                padding: 4rem 2rem;
                color: var(--text-muted);
            }

            .no-events h2 {
                font-size: 2rem;
                margin-bottom: 1rem;
                color: var(--danger);
            }

            /* Footer */
            .footer {
                background: var(--darker-bg);
                padding: 3rem 2rem;
                margin-top: 4rem;
                border-top: 1px solid var(--border-color);
            }

            .footer-content {
                max-width: 1400px;
                margin: 0 auto;
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                gap: 2rem;
            }

            .footer-section h3 {
                color: var(--primary);
                margin-bottom: 1rem;
                font-size: 1.2rem;
            }

            .footer-section ul {
                list-style: none;
            }

            .footer-section ul li {
                margin-bottom: 0.5rem;
            }

            .footer-section ul li a {
                color: var(--text-muted);
                text-decoration: none;
                transition: color 0.3s;
            }

            .footer-section ul li a:hover {
                color: var(--text-light);
            }

            .subscribe-box {
                display: flex;
                gap: 0.5rem;
                margin-top: 1rem;
                border: 2px solid var(--primary);
                border-radius: 8px;
                padding: 5px;
                background: var(--card-bg);
            }

            .subscribe-box input {
                flex: 1;
                padding: 0.75rem;
                border: none;
                border-radius: 25px;
                background: transparent;
                color: var(--text-light);
                outline: none;
            }

            .subscribe-box input::placeholder {
                color: var(--text-muted);
            }

            .subscribe-box button {
                padding: 0.75rem 1rem;
                border: none;
                border-radius: 25px;
                background: var(--primary);
                color: var(--text-light);
                cursor: pointer;
                transition: background 0.3s;
            }

            .subscribe-box button:hover {
                background: #5566dd;
            }

            .language {
                display: flex;
                align-items: center;
                gap: 0.5rem;
                margin-top: 1rem;
            }

            .language img {
                width: 24px;
                height: 16px;
                cursor: pointer;
                transition: transform 0.3s;
            }

            .language img:hover {
                transform: scale(1.1);
            }

            .social-icons {
                display: flex;
                align-items: center;
                gap: 0.5rem;
                margin-top: 1rem;
            }

            .social-images img {
                width: 24px;
                height: 24px;
                cursor: pointer;
                transition: transform 0.3s;
            }

            .social-images img:hover {
                transform: scale(1.1);
            }

            /* Responsive */
            @media (max-width: 992px) {
                .search-filter-container {
                    max-width: 100%;
                    margin: 0.5rem 0;
                    justify-content: center;
                }
                .search-box, .filter-input {
                    min-width: 150px;
                }
            }

            @media (max-width: 768px) {
                .nav {
                    flex-direction: column;
                    gap: 1rem;
                    text-align: center;
                }

                .nav-links {
                    gap: 1rem;
                    justify-content: center;
                    display: none; /* Hide nav links by default on small screens */
                    width: 100%;
                    flex-direction: column;
                    margin-top: 1rem;
                }

                .nav-links.active {
                    display: flex; /* Show when active */
                }

                .search-filter-toggle {
                    display: block; /* Show toggle button */
                    order: -1; /* Move toggle button to the left */
                    align-self: flex-start; /* Align it to the start */
                }
                
                .nav-toggle {
                    display: block; /* Show hamburger menu toggle */
                    background: none;
                    border: none;
                    color: var(--text-light);
                    font-size: 1.5rem;
                    cursor: pointer;
                    align-self: flex-end;
                }

                .search-filter-container {
                    flex-direction: column;
                    gap: 10px;
                    display: none; /* Hidden by default, toggled by JS */
                    width: 100%;
                    margin: 1rem 0;
                }
                
                .search-filter-container.active {
                    display: flex; /* Show when active */
                }

                .search-box, .filter-input {
                    width: 100%;
                }

                .auth-buttons {
                    justify-content: center;
                    gap: 0.5rem;
                    width: 100%;
                }

                .user-greeting {
                    margin: 0.5rem 0;
                }

                .carousel-content {
                    max-width: 80%;
                }

                .carousel-content h2 {
                    font-size: 1.5rem;
                }

                .carousel-content p {
                    font-size: 0.9rem;
                }

                .event-grid {
                    grid-template-columns: 1fr;
                }

                .ticket-section {
                    padding: 1.5rem;
                }

                .ticket-title {
                    font-size: 1.8rem;
                }

                .footer-content {
                    grid-template-columns: 1fr;
                    text-align: center;
                }

                .subscribe-box {
                    flex-direction: column;
                }

                .subscribe-box input,
                .subscribe-box button {
                    width: 100%;
                }

                .language,
                .social-icons {
                    justify-content: center;
                }
            }

            @media (max-width: 480px) {
                .container {
                    padding: 1rem;
                }

                .hero-carousel {
                    height: 300px;
                }

                .section-title {
                    font-size: 1.5rem;
                }

                .event-card {
                    min-width: 100%;
                }

                .btn {
                    min-width: 80px;
                    padding: 0.5rem 1rem;
                }

                .carousel-content {
                    max-width: 90%;
                    padding: 1rem;
                }
            }
        </style>
    </head>
    <body>
        <header class="header">
            <nav class="nav">
                <a href="${pageContext.request.contextPath}/home" class="logo">MasterTicket</a>
                
                <button class="search-filter-toggle" id="searchFilterToggle">
                    <i class="fas fa-search"></i>
                </button>
                
                <div class="search-filter-container" id="searchFilterContainer">
                    <input type="text" class="search-box" placeholder="Tìm sự kiện theo tên..." id="searchInput">
                    <input type="date" class="filter-input" id="startDateInput" title="Ngày bắt đầu">
                    <input type="date" class="filter-input" id="endDateInput" title="Ngày kết thúc">
                    <input type="text" class="filter-input" placeholder="Địa điểm..." id="locationInput">
                </div>

                <ul class="nav-links" id="navLinks">
                    <li><a href="#events"><i class="fas fa-home"></i> Trang chủ</a></li>
                    <li><a href="#venues"><i class="fas fa-fire"></i> Sự kiện hot</a></li>
                    <li><a href="#about"><i class="fas fa-tags"></i> Săn voucher</a></li>
                    <li><a href="#contact"><i class="fas fa-plus-circle"></i> Tạo sự kiện</a></li>
                    <li><a href="#contact"><i class="fas fa-question-circle"></i> Hỗ trợ</a></li>
                </ul>

                <button class="nav-toggle" id="navToggle">
                    <i class="fas fa-bars"></i>
                </button>
                
                <div class="auth-buttons">
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <span class="user-greeting">Xin chào, ${sessionScope.user.email}</span>
                            <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline">Đăng xuất</a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/login" class="btn btn-outline">Đăng nhập</a>
                            <a href="${pageContext.request.contextPath}/register" class="btn btn-primary">Đăng ký</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </nav>
        </header>

        <main class="container">
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
            <div class="section-header">
                <h2 class="section-title" id="events">Sự kiện nổi bật</h2>
                <a href="#all-events" class="view-all">Xem tất cả</a>
            </div>

            <div class="event-grid">
                <% for (Event event : events) { %>
                <div class="event-card searchable-event" 
                    data-event-id="<%= event.getEventID() %>"
                    data-event-start-time="<%= event.getStartTime() != null ? event.getStartTime().getTime() : "" %>"
                    data-event-end-time="<%= event.getEndTime() != null ? event.getEndTime().getTime() : "" %>"
                    data-event-location="<%= event.getPhysicalLocation() != null ? event.getPhysicalLocation().toLowerCase() : "" %>"
                    onclick="navigateToEventDetail(this.getAttribute('data-event-id'))">
                    <div class="event-image">
                        <% if (event.getImageURL() != null && !event.getImageURL().trim().isEmpty()) { %>
                        <img src="<%= event.getImageURL() %>" alt="<%= event.getName() %>" />
                        <% } else { %>
                        <span style="font-size: 50px; display: flex; justify-content: center; align-items: center; height: 100%; background-color: var(--card-bg);">🎫</span>
                        <% } %>
                    </div>
                    <div class="event-info">
                        <div class="event-title"><%= event.getName() %></div>
                        <div class="event-date">
                            <% if (event.getStartTime() != null && event.getEndTime() != null) { %>
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
            </div>

            <div class="section-header">
                <h2 class="section-title" id="all-events">Tất cả sự kiện</h2>
                <span class="view-all">Tổng cộng: <%= events.size() %> sự kiện</span>
            </div>

            <div class="event-grid">
                <% for (Event event : events) { %>
                <div class="event-card searchable-event" 
                    data-event-id="<%= event.getEventID() %>"
                    data-event-start-time="<%= event.getStartTime() != null ? event.getStartTime().getTime() : "" %>"
                    data-event-end-time="<%= event.getEndTime() != null ? event.getEndTime().getTime() : "" %>"
                    data-event-location="<%= event.getPhysicalLocation() != null ? event.getPhysicalLocation().toLowerCase() : "" %>"
                    onclick="navigateToEventDetail(this.getAttribute('data-event-id'))">
                    <div class="event-image">
                        <% if (event.getImageURL() != null && !event.getImageURL().trim().isEmpty()) { %>
                        <img src="<%= event.getImageURL() %>" alt="<%= event.getName() %>" />
                        <% } else { %>
                        <span style="font-size: 50px; display: flex; justify-content: center; align-items: center; height: 100%; background-color: var(--card-bg);">🎫</span>
                        <% } %>
                    </div>
                    <div class="event-info">
                        <div class="event-title"><%= event.getName() %></div>
                        <div class="event-date">
                            <% if (event.getStartTime() != null && event.getEndTime() != null) { %>
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
            </div>
            <% } %>
            <div class="ticket-section">
                <div class="ticket-content">
                    <h2 class="ticket-title">Mua vé của bạn</h2>
                    <p class="ticket-subtitle">Đơn giản, nhanh chóng và an toàn</p>
                    <a href="${pageContext.request.contextPath}/login" class="btn btn-primary">Bắt đầu mua vé</a>
                </div>
            </div>
        </main>

        <footer class="footer">
            <div class="footer-content">
                <div class="footer-section">
                    <h3>Dịch vụ khách hàng</h3>
                    <ul>
                        <li><a href="#">FAQ</a></li>
                        <li><a href="#">Liên hệ</a></li>
                        <li><a href="#">Chính sách bảo mật</a></li>
                        <li><a href="#">Điều khoản dịch vụ</a></li>
                    </ul>
                    <p><a href="mailto:support@masterticket.vn">support@masterticket.vn</a></p>
                </div>
                <div class="footer-section">
                    <h3>Sơ đồ trang</h3>
                    <ul>
                        <li><a href="#">Tạo tài khoản</a></li>
                        <li><a href="#">Tin tức</a></li>
                        <li><a href="#">Sự kiện nổi bật</a></li>
                    </ul>
                </div>
                <div class="footer-section">
                    <h3>Đăng ký nhận thông tin</h3>
                    <form class="subscribe-box">
                        <input type="email" placeholder="Email của bạn..." required />
                        <button type="submit">Gửi</button>
                    </form>
                    <div class="language">
                        <p>Ngôn ngữ:</p>
                        <img src="https://flagcdn.com/w40/vn.png" alt="Tiếng Việt" />
                        <img src="https://flagcdn.com/w40/gb.png" alt="English" />
                    </div>
                    <div class="social-icons">
                        <p>Theo dõi chúng tôi:</p>
                        <div class="social-images">
                            <img src="https://cdn-icons-png.flaticon.com/512/733/733547.png" alt="Facebook" />
                            <img src="https://cdn-icons-png.flaticon.com/512/2111/2111463.png" alt="Instagram" />
                            <img src="https://cdn-icons-png.flaticon.com/512/3046/3046120.png" alt="TikTok" />
                        </div>
                    </div>
                </div>
            </div>
        </footer>

        <script>
            // Navigate to event detail
            function navigateToEventDetail(eventId) {
                if (eventId) {
                    window.location.href = "${pageContext.request.contextPath}/EventServlet?id=" + eventId;
                } else {
                    console.error("Event ID is missing.");
                }
            }

            // Function to handle event selection (for fallback or testing)
            function selectEvent(eventName) {
                alert(`Bạn đã chọn sự kiện: ${eventName}\n\nChức năng mua vé sẽ được triển khai sau!`);
            }

            // Search and filter functionality
            function setupSearch() {
                const searchBox = document.getElementById('searchInput');
                const startDateInput = document.getElementById('startDateInput');
                const endDateInput = document.getElementById('endDateInput');
                const locationInput = document.getElementById('locationInput');
                const eventCards = document.querySelectorAll('.searchable-event');

                const applyFilters = () => {
                    const query = searchBox.value.toLowerCase();
                    const startDate = startDateInput.value ? new Date(startDateInput.value).setHours(0,0,0,0) : null;
                    const endDate = endDateInput.value ? new Date(endDateInput.value).setHours(23,59,59,999) : null;
                    const locationQuery = locationInput.value.toLowerCase();

                    eventCards.forEach(card => {
                        const title = card.querySelector('.event-title');
                        const description = card.querySelector('.event-description');
                        const eventLocation = card.getAttribute('data-event-location');
                        const eventStartTime = card.getAttribute('data-event-start-time');
                        const eventEndTime = card.getAttribute('data-event-end-time');

                        const titleText = title ? title.textContent.toLowerCase() : '';
                        const descText = description ? description.textContent.toLowerCase() : '';
                        
                        let isVisible = true;

                        // Filter by text query (name, description, location)
                        if (query) {
                            if (!titleText.includes(query) && !descText.includes(query) && (eventLocation ? !eventLocation.includes(query) : true)) {
                                isVisible = false;
                            }
                        }
                        
                        // Filter by location input
                        if (locationQuery && eventLocation && !eventLocation.includes(locationQuery)) {
                            isVisible = false;
                        }

                        // Filter by start date
                        if (startDate && eventStartTime) {
                            if (parseInt(eventStartTime) < startDate) {
                                isVisible = false;
                            }
                        }

                        // Filter by end date
                        if (endDate && eventEndTime) {
                            if (parseInt(eventEndTime) > endDate) {
                                isVisible = false;
                            }
                        }

                        card.style.display = isVisible ? 'block' : 'none';
                    });
                };

                searchBox.addEventListener('input', applyFilters);
                startDateInput.addEventListener('change', applyFilters);
                endDateInput.addEventListener('change', applyFilters);
                locationInput.addEventListener('input', applyFilters);
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

                        slides[index].classList.add('active');
                        indicators[index].classList.add('active');
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

                    setInterval(nextSlide, 5000);
                }
            }
            
            // Toggle for navigation links on small screens
            function setupNavToggle() {
                const navToggle = document.getElementById('navToggle');
                const navLinks = document.getElementById('navLinks');

                if (navToggle && navLinks) {
                    navToggle.addEventListener('click', () => {
                        navLinks.classList.toggle('active');
                        // Hide search/filter container when nav links are shown
                        document.getElementById('searchFilterContainer').classList.remove('active');
                    });
                }
            }

            // Toggle for search and filter inputs on small screens
            function setupSearchFilterToggle() {
                const searchFilterToggle = document.getElementById('searchFilterToggle');
                const searchFilterContainer = document.getElementById('searchFilterContainer');

                if (searchFilterToggle && searchFilterContainer) {
                    searchFilterToggle.addEventListener('click', () => {
                        searchFilterContainer.classList.toggle('active');
                        // Hide nav links when search/filter are shown
                        document.getElementById('navLinks').classList.remove('active');
                    });
                }
            }

            // Initialize page
            document.addEventListener('DOMContentLoaded', () => {
                setupSearch();
                setupCarousel();
                setupNavToggle();
                setupSearchFilterToggle();
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