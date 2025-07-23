<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="models.Event"%>
<%@page import="dto.UserDTO"%>
<%@page import="models.Notification"%>
<%@page import="service.NotificationService"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>MasterTicket - Trang Chủ</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
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
            // Retrieve UserDTO object from session
            UserDTO user = (UserDTO) session.getAttribute("user");

            // --- Notification Logic ---
            // Initialize notification service and lists
            NotificationService notificationService = new NotificationService();
            List<Notification> notifications = new ArrayList<>();
            int unreadCount = 0;

            // Handle redirection for logged-in users with specific roles
            if (user != null) {
                // If 'user' has a getRole() method and the role is 'event_owner', redirect them.
                if ("event_owner".equals(user.getRole())) {
                    response.sendRedirect(request.getContextPath() + "/eventOwnerPage/eventOwnerHomePage"); // Or eventOwnerDashboard
                    return; // VERY IMPORTANT: Stop further processing of THIS JSP
                }
                // Fetch notifications ONLY if a user is logged in (and not an owner, after redirection)
                notifications = notificationService.getUserNotifications(user.getId());
                unreadCount = notificationService.getUnreadNotificationsCount(user.getId());
            }

            // Retrieve events and pagination attributes from request
            List<Event> events = (List<Event>) request.getAttribute("events");
            Integer currentPageObj = (Integer) request.getAttribute("currentPage");
            Integer noOfPagesObj = (Integer) request.getAttribute("noOfPages");
            Integer totalEventsObj = (Integer) request.getAttribute("totalEvents");

            int currentPage = (currentPageObj != null) ? currentPageObj : 1;
            int noOfPages = (noOfPagesObj != null) ? noOfPagesObj : 1;
            int totalEvents = (totalEventsObj != null) ? totalEventsObj : 0;
            
            SimpleDateFormat dateFormat = new SimpleDateFormat("EEE, dd/MM/yyyy HH:mm");
        %>

        <header class="header">
            <nav class="nav">
                <a href="${pageContext.request.contextPath}/home" class="logo">MasterTicket</a>
                
                <button class="search-filter-toggle" id="searchFilterToggle" aria-label="Toggle search and filters">
                    <i class="fas fa-search"></i>
                </button>
                <button class="nav-toggle" id="navToggle" aria-label="Toggle navigation menu">
                    <i class="fas fa-bars"></i>
                </button>

                <div class="nav-center-content">
                    <div class="search-filter-container" id="searchFilterContainer">
                        <input type="text" class="search-box" placeholder="Tìm sự kiện..." id="searchInput">
                        <input type="date" class="filter-input" id="dateInput" title="Tìm theo ngày">
                        <input type="text" class="filter-input" placeholder="Địa điểm..." id="locationInput">
                    </div>

                    <ul class="nav-links" id="navLinks">
                        <li><a href="${pageContext.request.contextPath}/home"><i class="fas fa-home"></i> Trang chủ</a></li>
                        <li><a href="#hot-events"><i class="fas fa-fire"></i> Sự kiện hot</a></li>
                        <li><a href="#vouchers"><i class="fas fa-tags"></i> Săn voucher</a></li>
                        <li><a href="#contact"><i class="fas fa-question-circle"></i> Hỗ trợ</a></li>
                        <li><a href="${pageContext.request.contextPath}/tickets">🎫 Vé đã mua</a></li>
                        <li><a href="${pageContext.request.contextPath}/support">Hỗ trợ</a></li>
                    </ul>
                </div>
                
                <%-- User Profile and Notifications Section --%>
                <%-- Conditionally render this section based on whether a user is logged in --%>
                <div class="auth-buttons">
                    <c:choose>
                        <c:when test="${sessionScope.user != null}">
                            <%-- Notification Icon and Dropdown --%>
                            <div class="notification-icon-container">
                                <span class="notification-icon" onclick="toggleNotificationDropdown()">
                                    🔔
                                    <span class="notification-badge <%= unreadCount > 0 ? "show" : "" %>" id="notificationBadge">
                                        <%= unreadCount > 0 ? unreadCount : "" %>
                                    </span>
                                </span>
                                <div class="notification-dropdown" id="notificationDropdown">
                                    <% if (notifications.isEmpty()) { %>
                                        <div class="no-notifications">Bạn không có thông báo nào.</div>
                                    <% } else { %>
                                        <% for (Notification notification : notifications) { %>
                                            <div class="notification-item <%= !notification.isIsRead() ? "unread" : "" %>"
                                                 onclick="handleNotificationClick(<%= notification.getNotificationID() %>, '<%= notification.getNotificationType() %>', <%= notification.getRelatedID() != null ? notification.getRelatedID() : "null" %>)">
                                                <span class="notification-title"><%= notification.getTitle() %></span>
                                                <span class="notification-content"><%= notification.getContent() %></span>
                                                <span class="notification-time"><%= new SimpleDateFormat("HH:mm dd/MM").format(java.sql.Timestamp.valueOf(notification.getCreatedAt())) %></span>
                                            </div>
                                        <% } %>
                                    <% } %>
                                </div>
                            </div>

                            <div class="user-menu">
                                <div class="user-info" onclick="toggleUserDropdown()">
                                    <%-- Display User Avatar --%>
                                    <div class="user-avatar">
                                        <% if (user.getAvatar() != null && !user.getAvatar().isEmpty()) { %>
                                            <img src="${pageContext.request.contextPath}/images/<%= user.getAvatar() %>" alt="Avatar">
                                        <% } else { %>
                                            <%= user.getEmail().substring(0, 1).toUpperCase() %>
                                        <% } %>
                                    </div>
                                    Xin chào, <%= user.getName() != null && !user.getName().isEmpty() ? user.getName() : user.getEmail() %> <span style="margin-left: 0.5rem;">▼</span>
                                </div>
                                <div class="user-dropdown" id="userDropdown">
                                    <a href="${pageContext.request.contextPath}/updateProfile" class="dropdown-item">👤 Thông tin cá nhân</a>
                                    <a href="${pageContext.request.contextPath}/myTickets" class="dropdown-item">🎫 Vé đã mua</a>
                                    <a href="${pageContext.request.contextPath}/favoriteEvents" class="dropdown-item">❤️ Sự kiện yêu thích</a>
                                    <a href="${pageContext.request.contextPath}/settings" class="dropdown-item">⚙️ Cài đặt</a>
                                    <hr style="border: none; border-top: 1px solid var(--border-color); margin: 0.5rem 0;">
                                    <a href="${pageContext.request.contextPath}/logout" class="dropdown-item" style="color: var(--danger);">🚪 Đăng xuất</a>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <%-- Show Login/Register buttons if user is not logged in --%>
                            <a href="${pageContext.request.contextPath}/login" class="btn btn-outline">Đăng nhập</a>
                            <a href="${pageContext.request.contextPath}/register" class="btn btn-primary">Đăng ký</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </nav>
        </header>

        <main class="container">
            <div class="hero-carousel">
                <div class="carousel-slide active" style="background-image: url('https://images.unsplash.com/photo-1514525253161-7a46d19cd819?ixlib=rb-4.0.3&auto=format&fit=crop&w=1400&q=80');">
                    <div class="carousel-content">
                        <h2>Chào mừng đến với MasterTicket</h2>
                        <p>Khám phá hàng ngàn sự kiện thú vị và đặt vé ngay hôm nay!</p>
                        <a href="#events" class="btn btn-primary">Khám phá ngay</a>
                    </div>
                </div>
                <div class="carousel-slide" style="background-image: url('https://images.unsplash.com/photo-1505373877845-8c2aace4d817?ixlib=rb-4.0.3&auto=format&fit=crop&w=1400&q=80');">
                    <div class="carousel-content">
                        <h2>Sự kiện âm nhạc đỉnh cao</h2>
                        <p>Đừng bỏ lỡ những đêm nhạc sôi động với các nghệ sĩ hàng đầu!</p>
                        <a href="#events" class="btn btn-primary">Xem chi tiết</a>
                    </div>
                </div>
                <div class="carousel-slide" style="background-image: url('https://images.unsplash.com/photo-1607962837350-ed6062031177?ixlib=rb-4.0.3&auto=format&fit=crop&w=1400&q=80');">
                    <div class="carousel-content">
                        <h2>Sự kiện văn hóa và nghệ thuật</h2>
                        <p>Đắm chìm vào thế giới nghệ thuật với các triển lãm và biểu diễn độc đáo.</p>
                        <a href="#events" class="btn btn-primary">Tìm hiểu thêm</a>
                    </div>
                </div>
                <div class="carousel-indicators">
                    <div class="indicator active"></div>
                    <div class="indicator"></div>
                    <div class="indicator"></div>
                </div>
            </div>

            <% if (events == null || events.isEmpty()) { %>
            <div class="no-events">
                <h2>Không có sự kiện nào!</h2>
                <p>Hiện tại chưa có sự kiện nào được tổ chức. Vui lòng quay lại sau!</p>
            </div>
            <% } else { %>
            
            <div class="section-header">
                <h2 class="section-title" id="hot-events">Sự kiện nổi bật</h2>
                <a href="${pageContext.request.contextPath}/home?page=1" class="view-all">Xem tất cả</a>
            </div>

            <div class="event-grid">
                <%  
                    for (Event event : events) {
                %>
                <div class="event-card searchable-event" 
                     data-event-id="<%= event.getEventID() %>"
                     data-event-name="<%= event.getName() != null ? event.getName().toLowerCase() : "" %>"
                     data-event-description="<%= event.getDescription() != null ? event.getDescription().toLowerCase() : "" %>"
                     data-event-start-time="<%= event.getStartTime() != null ? event.getStartTime().getTime() : "" %>"
                     data-event-location="<%= event.getPhysicalLocation() != null ? event.getPhysicalLocation().toLowerCase() : "" %>"
                     onclick="navigateToEventDetail(this.getAttribute('data-event-id'))">
                    <div class="event-image">
                        <% if (event.getImageURL() != null && !event.getImageURL().trim().isEmpty()) { %>
                            <img src="${pageContext.request.contextPath}/uploads/event_banners/<%= event.getImageURL() %>" alt="<%= event.getName() %>" />
                        <% } else { %>
                            <span style="font-size: 50px; display: flex; justify-content: center; align-items: center; height: 100%; background-color: var(--card-bg);">🎫</span>
                        <% } %>
                    </div>
                    <div class="event-info">
                        <div class="event-title"><%= event.getName()%></div>
                        <div class="event-date">
                            <% if (event.getStartTime() != null && event.getEndTime() != null) {%>
                            🗓️ <%= dateFormat.format(event.getStartTime())%> - <%= dateFormat.format(event.getEndTime())%>
                            <% } else { %>
                            🗓️ Thời gian không xác định
                            <% }%>
                        </div>
                        <div class="event-location">📍 <%= event.getPhysicalLocation() != null ? event.getPhysicalLocation() : "Địa điểm không xác định"%></div>
                        <div class="event-description" style="white-space: nowrap; overflow: hidden; text-overflow: ellipsis; max-width: 200px; max-height: 3.6em; line-height: 1.2em;">
                            <%= event.getDescription() != null ? event.getDescription() : ""%>
                        </div>
                        <div class="event-price">Từ 150,000 VNĐ</div>
                    </div>
                </div>
                <% } %>
            </div>

            <div class="pagination-controls">
                <a href="${pageContext.request.contextPath}/home?page=<%= currentPage - 1 %>" 
                   class="<%= (currentPage == 1) ? "disabled" : "" %>">Trước</a>
                
                <%  
                    // Display page numbers
                    int startPage = Math.max(1, currentPage - 2);
                    int endPage = Math.min(noOfPages, currentPage + 2);

                    if (startPage > 1) {
                        %><a href="${pageContext.request.contextPath}/home?page=1">1</a><%
                        if (startPage > 2) {
                            %><span>...</span><%
                        }
                    }

                    for (int i = startPage; i <= endPage; i++) {
                        if (i == currentPage) {
                            %><span class="current-page"><%= i %></span><%
                        } else {
                            %><a href="${pageContext.request.contextPath}/home?page=<%= i %>"><%= i %></a><%
                        }
                    }

                    if (endPage < noOfPages) {
                        if (endPage < noOfPages - 1) {
                            %><span>...</span><%
                        }
                        %><a href="${pageContext.request.contextPath}/home?page=<%= noOfPages %>"><%= noOfPages %></a><%
                    }
                %>
                
                <a href="${pageContext.request.contextPath}/home?page=<%= currentPage + 1 %>" 
                   class="<%= (currentPage == noOfPages) ? "disabled" : "" %>">Sau</a>
            </div>

            <% } %>

            <div class="ticket-section">
                <div class="ticket-content">
                    <h2 class="ticket-title">Mua vé của bạn</h2>
                    <p class="ticket-subtitle">
                        Đơn giản, nhanh chóng và an toàn
                    </p>
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
                        <input type="email" placeholder="Email của bạn..." required value="<%=(user != null ? user.getEmail() : "")%>"/>
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
            
            

