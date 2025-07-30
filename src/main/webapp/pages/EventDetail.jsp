<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <title>MasterTicket - Chi tiết sự kiện</title>
        <style>
            :root {
                --primary: #6366f1;
                --primary-dark: #4f46e5;
                --secondary: #ec4899;
                --secondary-dark: #db2777;
                --accent: #06b6d4;
                --dark-bg: #0f172a;
                --darker-bg: #020617;
                --card-bg: #1e293b;
                --card-hover: #334155;
                --border-color: #334155;
                --text-light: #f1f5f9;
                --text-muted: #94a3b8;
                --success: #10b981;
                --warning: #f59e0b;
                --danger: #ef4444;
                --glass-bg: rgba(30, 41, 59, 0.8);
                --gradient-1: linear-gradient(135deg, var(--primary), var(--secondary));
                --gradient-2: linear-gradient(135deg, var(--accent), var(--primary));
            }

            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
                background: var(--darker-bg);
                color: var(--text-light);
                line-height: 1.6;
                overflow-x: hidden;
            }

            /* Animated Background */
            body::before {
                content: '';
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background:
                    radial-gradient(circle at 20% 80%, rgba(99, 102, 241, 0.1) 0%, transparent 50%),
                    radial-gradient(circle at 80% 20%, rgba(236, 72, 153, 0.1) 0%, transparent 50%),
                    radial-gradient(circle at 40% 40%, rgba(6, 182, 212, 0.05) 0%, transparent 50%);
                z-index: -1;
                animation: backgroundShift 20s ease infinite;
            }

            @keyframes backgroundShift {
                0%, 100% {
                    opacity: 1;
                }
                50% {
                    opacity: 0.8;
                }
            }

            /* Enhanced Header */
            .header-container {
                position: sticky;
                top: 0;
                z-index: 100;
                backdrop-filter: blur(20px);
                background: rgba(2, 6, 23, 0.9);
                border-bottom: 1px solid var(--border-color);
                box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
            }

            .header {
                max-width: 1400px;
                margin: 0 auto;
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 1rem 2rem;
            }

            .logo {
                font-size: 1.75rem;
                font-weight: 700;
                background: var(--gradient-1);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                background-clip: text;
            }

            .search {
                display: flex;
                align-items: center;
                gap: 0.75rem;
            }

            .search input {
                padding: 0.75rem 1.25rem;
                border-radius: 50px;
                border: 1px solid var(--border-color);
                width: 350px;
                background: var(--glass-bg);
                backdrop-filter: blur(10px);
                color: var(--text-light);
                font-size: 0.9rem;
                transition: all 0.3s ease;
            }

            .search input:focus {
                outline: none;
                border-color: var(--primary);
                box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.1);
            }

            .search button {
                padding: 0.75rem 1.5rem;
                background: var(--gradient-1);
                border: none;
                border-radius: 50px;
                color: white;
                cursor: pointer;
                font-weight: 600;
                transition: all 0.3s ease;
            }

            .search button:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 25px rgba(99, 102, 241, 0.3);
            }

            .actions {
                display: flex;
                align-items: center;
                gap: 1.5rem;
            }

            .primary-btn {
                background: var(--gradient-1);
                border: none;
                padding: 0.75rem 1.5rem;
                color: white;
                border-radius: 50px;
                cursor: pointer;
                font-weight: 600;
                transition: all 0.3s ease;
                position: relative;
                overflow: hidden;
            }

            .primary-btn::before {
                content: '';
                position: absolute;
                top: 0;
                left: -100%;
                width: 100%;
                height: 100%;
                background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
                transition: left 0.5s;
            }

            .primary-btn:hover::before {
                left: 100%;
            }

            .primary-btn:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 25px rgba(99, 102, 241, 0.4);
            }

            .link {
                color: var(--text-light);
                text-decoration: none;
                font-weight: 500;
                padding: 0.5rem 1rem;
                border-radius: 8px;
                transition: all 0.3s ease;
            }

            .link:hover {
                background: rgba(255, 255, 255, 0.1);
                transform: translateY(-1px);
            }

            .account {
                background: var(--card-bg);
                border: 1px solid var(--border-color);
                padding: 0.5rem 1rem;
                border-radius: 50px;
                font-weight: 500;
                cursor: pointer;
                transition: all 0.3s ease;
            }

            .account:hover {
                background: var(--card-hover);
                transform: translateY(-1px);
            }

            /* Main Content */
            .main-content {
                max-width: 1400px;
                margin: 0 auto;
                padding: 3rem 2rem;
            }


            .back-link {
                color: var(--primary);
                text-decoration: none;
                font-size: 1rem;
                display: inline-flex;
                align-items: center;
                gap: 0.5rem;
                margin-bottom: 2rem;
                padding: 0.75rem 1rem;
                background: var(--glass-bg);
                backdrop-filter: blur(10px);
                border-radius: 50px;
                border: 1px solid var(--border-color);
                transition: all 0.3s ease;
                font-weight: 500;
            }

            .back-link:hover {
                background: var(--card-hover);
                transform: translateY(-2px);
                box-shadow: 0 8px 25px rgba(0, 0, 0, 0.2);
            }

            /* Hero Section */
            .event-hero {
                display: grid;
                grid-template-columns: 1fr 1.5fr;
                gap: 4rem;
                margin-bottom: 4rem;
                align-items: start;
            }

            .event-poster-container {
                position: relative;
            }

            .event-poster {
                width: 100%;
                max-width: 450px;
                aspect-ratio: 4/3;
                border-radius: 24px;
                overflow: hidden;
                position: relative;
                background: var(--gradient-1);
                padding: 4px;
                transition: all 0.5s cubic-bezier(0.175, 0.885, 0.32, 1.275);
                box-shadow:
                    0 20px 40px rgba(0,0,0,0.3),
                    0 0 0 1px rgba(255,255,255,0.1);
            }

            .event-poster::before {
                content: '';
                position: absolute;
                top: 4px;
                left: 4px;
                right: 4px;
                bottom: 4px;
                background: var(--card-bg);
                border-radius: 20px;
                z-index: 1;
            }

            .event-poster img {
                width: calc(100% - 8px);
                height: calc(100% - 8px);
                object-fit: contain;
                object-position: center;
                position: relative;
                z-index: 2;
                margin: 4px;
                border-radius: 20px;
                transition: all 0.5s ease;
            }

            .event-poster:hover {
                transform: translateY(-12px) scale(1.02);
                box-shadow:
                    0 35px 60px rgba(0,0,0,0.4),
                    0 0 0 1px rgba(255,255,255,0.2),
                    0 0 50px rgba(99, 102, 241, 0.3);
            }

            .event-poster:hover img {
                filter: brightness(1.1) contrast(1.1);
            }

            /* Event Info */
            .event-info {
                padding: 2rem 0;
            }

            .event-title {
                font-size: 3rem;
                font-weight: 700;
                margin-bottom: 1.5rem;
                background: var(--gradient-1);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                background-clip: text;
                line-height: 1.2;
            }

            .event-meta {
                display: flex;
                flex-direction: column;
                gap: 1rem;
                margin-bottom: 2rem;
            }

            .event-meta-item {
                display: flex;
                align-items: center;
                gap: 1rem;
                padding: 1rem;
                background: var(--glass-bg);
                backdrop-filter: blur(10px);
                border-radius: 16px;
                border: 1px solid var(--border-color);
                transition: all 0.3s ease;
            }

            .event-meta-item:hover {
                background: var(--card-hover);
                transform: translateX(8px);
            }

            .event-meta-item i {
                font-size: 1.25rem;
                color: var(--primary);
                width: 24px;
                text-align: center;
            }

            .event-description {
                font-size: 1.1rem;
                line-height: 1.8;
                color: var(--text-muted);
                margin-bottom: 2.5rem;
                padding: 1.5rem;
                background: var(--glass-bg);
                backdrop-filter: blur(10px);
                border-radius: 16px;
                border: 1px solid var(--border-color);
            }

            .action-buttons {
                display: flex;
                gap: 1rem;
                flex-wrap: wrap;
            }

            .btn-large {
                padding: 1rem 2rem;
                font-size: 1.1rem;
                font-weight: 600;
                border-radius: 50px;
                border: none;
                cursor: pointer;
                transition: all 0.3s ease;
                position: relative;
                overflow: hidden;
            }

            .btn-primary {
                background: var(--gradient-1);
                color: white;
            }

            .btn-secondary {
                background: var(--glass-bg);
                backdrop-filter: blur(10px);
                color: var(--text-light);
                border: 1px solid var(--border-color);
            }

            .btn-large:hover {
                transform: translateY(-3px);
                box-shadow: 0 12px 30px rgba(0,0,0,0.3);
            }

            /* Content Sections */
            .content-grid {
                display: grid;
                gap: 2rem;
                margin-bottom: 4rem;
            }

            .section-card {
                background: var(--glass-bg);
                backdrop-filter: blur(20px);
                border: 1px solid var(--border-color);
                border-radius: 24px;
                padding: 2.5rem;
                transition: all 0.3s ease;
                position: relative;
                overflow: hidden;
            }

            .section-card::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                height: 4px;
                background: var(--gradient-1);
            }

            .section-card:hover {
                transform: translateY(-4px);
                box-shadow: 0 20px 40px rgba(0,0,0,0.2);
                border-color: var(--primary);
            }

            .section-title {
                font-size: 1.75rem;
                font-weight: 700;
                margin-bottom: 2rem;
                color: var(--text-light);
                display: flex;
                align-items: center;
                gap: 0.75rem;
            }

            .section-title i {
                color: var(--primary);
            }

            /* Enhanced Table */
            .ticket-table {
                width: 100%;
                border-collapse: separate;
                border-spacing: 0;
                background: var(--card-bg);
                border-radius: 16px;
                overflow: hidden;
                box-shadow: 0 8px 25px rgba(0,0,0,0.2);
            }

            .ticket-table th {
                background: var(--gradient-1);
                color: white;
                padding: 1.25rem;
                font-weight: 600;
                text-align: left;
            }

            .ticket-table td {
                padding: 1.25rem;
                border-bottom: 1px solid var(--border-color);
                transition: all 0.3s ease;
            }

            .ticket-table tr:hover td {
                background: var(--card-hover);
            }

            .ticket-table tr:last-child td {
                border-bottom: none;
            }

            /* Feedback Section */
            .feedback-form {
                display: grid;
                gap: 1.5rem;
                margin-bottom: 3rem;
            }

            .feedback-form textarea {
                padding: 1.25rem;
                border: 1px solid var(--border-color);
                border-radius: 16px;
                background: var(--card-bg);
                color: var(--text-light);
                font-size: 1rem;
                resize: vertical;
                min-height: 120px;
                transition: all 0.3s ease;
            }

            .feedback-form textarea:focus {
                outline: none;
                border-color: var(--primary);
                box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.1);
            }

            .rating {
                display: flex;
                align-items: center;
                gap: 1rem;
            }

            .rating .fa-star {
                font-size: 1.5rem;
                cursor: pointer;
                color: var(--text-muted);
                transition: all 0.2s ease;
            }

            .rating .fa-star:hover,
            .rating .fa-star.active {
                color: var(--warning);
                transform: scale(1.1);
            }

            .feedback-item {
                background: var(--card-bg);
                border: 1px solid var(--border-color);
                border-radius: 16px;
                padding: 1.5rem;
                margin-bottom: 1rem;
                transition: all 0.3s ease;
            }

            .feedback-item:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 25px rgba(0,0,0,0.2);
            }

            /* Suggestions Grid */
            .suggestions-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
                gap: 2rem;
            }

            .event-card {
                background: var(--glass-bg);
                backdrop-filter: blur(10px);
                border: 1px solid var(--border-color);
                border-radius: 20px;
                overflow: hidden;
                transition: all 0.4s ease;
                text-decoration: none;
                color: inherit;
                position: relative;
            }

            .event-card::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background: var(--gradient-1);
                opacity: 0;
                transition: opacity 0.3s ease;
            }

            .event-card:hover::before {
                opacity: 0.1;
            }

            .event-card:hover {
                transform: translateY(-8px) scale(1.02);
                box-shadow: 0 20px 40px rgba(0,0,0,0.3);
                border-color: var(--primary);
            }

            .event-card img {
                width: 100%;
                height: 200px;
                object-fit: cover;
                transition: all 0.4s ease;
            }

            .event-card:hover img {
                transform: scale(1.05);
            }

            .card-body {
                padding: 1.5rem;
                position: relative;
                z-index: 2;
            }

            /* Footer */
            .footer {
                background: var(--darker-bg);
                border-top: 1px solid var(--border-color);
                padding: 4rem 2rem 2rem;
                margin-top: 6rem;
            }

            .footer-content {
                max-width: 1400px;
                margin: 0 auto;
            }

            .footer-container {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                gap: 3rem;
                margin-bottom: 2rem;
            }

            .footer-section h3 {
                color: var(--text-light);
                margin-bottom: 1.5rem;
                font-weight: 600;
            }

            .footer-section ul {
                list-style: none;
            }

            .footer-section ul li {
                margin-bottom: 0.75rem;
            }

            .footer-section ul li a {
                color: var(--text-muted);
                text-decoration: none;
                transition: all 0.3s ease;
            }

            .footer-section ul li a:hover {
                color: var(--primary);
                transform: translateX(4px);
            }

            .subscribe-box {
                display: flex;
                background: var(--card-bg);
                border: 1px solid var(--border-color);
                border-radius: 50px;
                padding: 0.5rem;
                margin-bottom: 1.5rem;
            }

            .subscribe-box input {
                flex: 1;
                border: none;
                background: transparent;
                color: var(--text-light);
                padding: 0.75rem 1rem;
                outline: none;
            }

            .subscribe-box button {
                background: var(--gradient-1);
                border: none;
                border-radius: 50px;
                padding: 0.75rem 1.5rem;
                color: white;
                cursor: pointer;
                transition: all 0.3s ease;
            }

            .language img,
            .social-images img {
                width: 32px;
                height: 32px;
                margin-right: 0.75rem;
                border-radius: 8px;
                cursor: pointer;
                transition: all 0.3s ease;
            }

            .language img:hover,
            .social-images img:hover {
                transform: scale(1.1);
            }

            /* Responsive Design */
            @media (max-width: 1024px) {
                .event-hero {
                    grid-template-columns: 1fr;
                    gap: 2rem;
                    text-align: center;
                }

                .event-title {
                    font-size: 2.5rem;
                }
            }

            @media (max-width: 768px) {
                .header {
                    flex-direction: column;
                    gap: 1rem;
                    padding: 1rem;
                }

                .search input {
                    width: 100%;
                }

                .main-content {
                    padding: 2rem 1rem;
                }

                .event-title {
                    font-size: 2rem;
                }

                .action-buttons {
                    justify-content: center;
                }

                .section-card {
                    padding: 1.5rem;
                }
            }

            /* Loading Animation */
            @keyframes shimmer {
                0% {
                    transform: translateX(-100%);
                }
                100% {
                    transform: translateX(100%);
                }
            }

            .loading-shimmer {
                position: relative;
                overflow: hidden;
            }

            .loading-shimmer::after {
                content: '';
                position: absolute;
                top: 0;
                right: 0;
                bottom: 0;
                left: 0;
                background: linear-gradient(90deg, transparent, rgba(255,255,255,0.1), transparent);
                animation: shimmer 2s infinite;
            }
        </style>
    </head>

    <body>
        <div class="header-container">
            <header class="header">
                <div class="logo">
                   <a href="/OnlineSellingTicketEvents/home" class="logo">MasterTicket</a>                   
                </div>
                <div class="search">
                    <input type="text" placeholder="Tìm kiếm sự kiện, nghệ sĩ, địa điểm...">
                    <button><i class="fas fa-search"></i></button>
                </div>
                <div class="actions">
                    <button class="primary-btn">
                        <i class="fas fa-plus"></i>
                        Tạo sự kiện
                    </button>
<!--                    <a href="${pageContext.request.contextPath}/TicketOrderHistoryServlet" class="link">
                        <i class="fas fa-history"></i>
                        Vé đã mua
                    </a>-->
                    <div class="account">
                        <a href="${pageContext.request.contextPath}/updateProfile" class="link">
                            <i class="fas fa-user"></i>
                            Tài khoản
                        </a>
                    </div>
                </div>
            </header>
        </div>

        <fmt:setLocale value="vi_VN" />

        <div class="main-content">

            <a href="${pageContext.request.contextPath}/HomePageServlet" class="back-link">
                <i class="fas fa-arrow-left"></i> 
                Trở về trang sự kiện
            </a>
            <c:if test="${not empty event}">
                <div class="event-hero">
                    <div class="event-poster-container">
                        <div class="event-poster">
                            <img src="${pageContext.request.contextPath}/uploads/event_banners/${event.imageURL}"
                                 alt="Poster sự kiện ${event.name}"
                                 onerror="this.src='${pageContext.request.contextPath}/images/default-poster.jpg'">
                        </div>
                    </div>

                    <div class="event-info">
                        <h1 class="event-title">${event.name}</h1>

                        <div class="event-meta">
                            <div class="event-meta-item">
                                <i class="fas fa-clock"></i>
                                <div>
                                    <strong>Thời gian</strong><br>
                                    <fmt:formatDate value="${event.startTime}" pattern="HH:mm"/> - 
                                    <fmt:formatDate value="${event.endTime}" pattern="HH:mm, dd/MM/yyyy"/>
                                </div>
                            </div>
                            <div class="event-meta-item">
                                <i class="fas fa-map-marker-alt"></i>
                                <div>
                                    <strong>Địa điểm</strong><br>
                                    ${event.physicalLocation}
                                </div>
                            </div>
                            <div class="event-meta-item">
                                <i class="fas fa-tag"></i>
                                <div>
                                    <strong>Giá từ</strong><br>
                                    <c:choose>
                                        <c:when test="${not empty ticketList}">
                                            <fmt:formatNumber value="${ticketList[0].price}" type="currency" currencyCode="VND"/>
                                        </c:when>
                                        <c:otherwise>Liên hệ</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>

                        <div class="event-description">
                            ${event.description}
                        </div>

                        <div class="action-buttons">
                            <c:choose>
                                <c:when test="${not empty sessionScope.user}">
                                    <button class="btn-large btn-primary"
                                            onclick="handleBuyTickets(${event.eventID}, '${event.hasSeatingChart}')">
                                        <i class="fas fa-ticket-alt"></i>
                                        Mua vé ngay
                                    </button>
                                    <button class="btn-large btn-secondary" onclick="handleStartChat(${event.eventID})">
                                        <i class="fas fa-comments"></i>
                                        Chat hỗ trợ
                                    </button>
                                </c:when>
                                <c:otherwise>
                                    <c:url var="loginUrl" value="/login">
                                        <c:param name="redirect" value="EventServlet?id=${event.eventID}" />
                                    </c:url>
                                    <button class="btn-large btn-primary" onclick="location.href = '${loginUrl}'">
                                        <i class="fas fa-sign-in-alt"></i>
                                        Đăng nhập để mua vé
                                    </button>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

                <div class="content-grid">
                    <div class="section-card">
                        <h2 class="section-title">
                            <i class="fas fa-info-circle"></i>
                            Thông tin chi tiết
                        </h2>
                        <div class="event-card-detail">
                            <h3 class="event-name">${event.name}</h3>
                            <div class="event-meta">
                                <div class="meta-item">
                                    <strong><i class="fas fa-clock"></i> Thời gian:</strong>
                                    <span><fmt:formatDate value="${event.startTime}" pattern="HH:mm, dd/MM/yyyy"/></span>
                                </div>
                                <div class="meta-item">
                                    <strong><i class="fas fa-map-marker-alt"></i> Địa điểm:</strong>
                                    <span>${event.physicalLocation}</span>
                                </div>
                                <div class="meta-item">
                                    <strong><i class="fas fa-money-bill-wave"></i> Giá từ:</strong>
                                    <span>
                                        <c:choose>
                                            <c:when test="${not empty ticketList}">
                                                <fmt:formatNumber value="${ticketList[0].price}" type="currency" currencyCode="VND"/>
                                            </c:when>
                                            <c:otherwise>Liên hệ</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="section-card">
                        <h2 class="section-title">
                            <i class="fas fa-ticket-alt"></i>
                            Loại vé và giá
                        </h2>
                        <c:if test="${empty ticketList}">
                            <p style="text-align: center; color: var(--text-muted); padding: 2rem;">
                                <i class="fas fa-exclamation-triangle" style="font-size: 2rem; margin-bottom: 1rem; display: block;"></i>
                                Chưa có vé cho sự kiện này hoặc vé đã ngừng bán.
                            </p>
                        </c:if>
                        <c:if test="${not empty ticketList}">
                            <table class="ticket-table">
                                <thead>
                                    <tr>
                                        <th><i class="fas fa-tag"></i> Loại vé</th>
                                        <th><i class="fas fa-money-bill-wave"></i> Giá</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="ticket" items="${ticketList}">
                                        <tr>
                                            <td>
                                                <div>
                                                    <strong style="font-size: 1.1rem;">${ticket.ticketName}</strong><br>
                                                    <span style="color: var(--primary); font-weight: 500;">Loại: ${ticket.category}</span><br>
                                                    <small style="color: var(--text-muted);">${ticket.ticketDescription}</small>
                                                </div>
                                            </td>
                                            <td>
                                                <strong style="font-size: 1.2rem; color: var(--success);">
                                                    <fmt:formatNumber value="${ticket.price}" type="currency" currencyCode="VND"/>
                                                </strong>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                            <p class="ticket-note" style="margin-top: 1rem; font-style: italic; color: var(--text-muted);">
                                <i class="fas fa-info-circle"></i>
                                Vé được cập nhật liên tục và có thể thay đổi.
                            </p>
                        </c:if>
                    </div>

                    <div class="section-card">
                        <h2 class="section-title">
                            <i class="fas fa-comments"></i>
                            Phản hồi từ người tham dự
                        </h2>

                        <c:choose>
                            <c:when test="${not empty feedbackList}">
                                <c:forEach var="fb" items="${feedbackList}">
                                    <div class="feedback-item" style="margin-bottom: 1.5rem;">
                                        <!-- Nội dung feedback -->
                                        <p class="feedback-text" style="margin: 0 0 0.5rem 0; font-weight: 500;">
                                            ${fb.content}
                                        </p>

                                        <!-- Số sao + người gửi + ngày -->
                                        <div class="feedback-meta" style="display: flex; align-items: center; flex-wrap: wrap; gap: 0.75rem;">
                                            <!-- Số sao -->
                                            <div class="feedback-stars">
                                                <c:forEach begin="1" end="5" var="i">
                                                    <i class="${i <= fb.rating ? 'fas' : 'far'} fa-star"
                                                       style="color: ${i <= fb.rating ? 'var(--warning)' : 'var(--text-muted)'};"></i>
                                                </c:forEach>
                                            </div>

                                            <!-- Người gửi -->
                                            <span class="feedback-author" style="color: var(--primary); font-weight: 600;">
                                                ${fb.userName}
                                            </span>

                                            <!-- Ngày gửi -->
                                            <span class="feedback-date" style="color: var(--text-muted); font-size: 0.95em;">
                                                (${fb.formattedDate})
                                            </span>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <p style="color: var(--text-muted); margin-top: 1rem;">
                                    Hiện tại chưa có phản hồi nào cho sự kiện này.
                                </p>
                            </c:otherwise>
                        </c:choose>
                    </div>

                </div>
            </c:if>
        </div>

        <footer class="footer">
            <div class="footer-content">
                <div class="footer-container">
                    <div class="footer-section">
                        <h3><i class="fas fa-headset"></i> Dịch vụ khách hàng</h3>
                        <ul>
                            <li><a href="#"><i class="fas fa-question-circle"></i> Câu hỏi thường gặp</a></li>
                            <li><a href="#"><i class="fas fa-phone"></i> Liên hệ chúng tôi</a></li>
                            <li><a href="#"><i class="fas fa-shield-alt"></i> Chính sách bảo mật</a></li>
                            <li><a href="#"><i class="fas fa-file-contract"></i> Điều khoản dịch vụ</a></li>
                        </ul>
                        <p style="margin-top: 1rem;">
                            <i class="fas fa-envelope" style="color: var(--success);"></i>
                            <a href="mailto:support@masterTicket.vn" style="color: var(--text-muted);">support@masterTicket.vn</a>
                        </p>
                    </div>

                    <div class="footer-section">
                        <h3><i class="fas fa-sitemap"></i> Sitemap</h3>
                        <ul>
                            <li><a href="#"><i class="fas fa-user-plus"></i> Tạo tài khoản</a></li>
                            <li><a href="#"><i class="fas fa-newspaper"></i> Tin tức</a></li>
                            <li><a href="#"><i class="fas fa-star"></i> Sự kiện nổi bật</a></li>
                        </ul>
                    </div>

                    <div class="footer-section">
                        <h3><i class="fas fa-bell"></i> Đăng ký nhận thông báo</h3>
                        <form class="subscribe-box">
                            <input type="email" placeholder="Email của bạn..." required />
                            <button type="submit">
                                <i class="fas fa-paper-plane"></i>
                            </button>
                        </form>

                        <div class="language">
                            <p><i class="fas fa-globe"></i> Ngôn ngữ:</p>
                            <img src="https://flagcdn.com/w40/vn.png" alt="Tiếng Việt" />
                            <img src="https://flagcdn.com/w40/gb.png" alt="Tiếng Anh" />
                        </div>

                        <div class="social-icons">
                            <p><i class="fas fa-share-alt"></i> Theo dõi chúng tôi:</p>
                            <div class="social-images">
                                <img src="https://cdn-icons-png.flaticon.com/512/733/733547.png" alt="Facebook" />
                                <img src="https://cdn-icons-png.flaticon.com/512/2111/2111463.png" alt="Instagram" />
                                <img src="https://cdn-icons-png.flaticon.com/512/3046/3046120.png" alt="TikTok" />
                            </div>
                        </div>
                    </div>
                </div>

                <div style="text-align: center; padding-top: 2rem; border-top: 1px solid var(--border-color); color: var(--text-muted);">
                    <p>&copy; 2025 MasterTicket. Tất cả quyền được bảo lưu.</p>
                </div>
            </div>
        </footer>

        <script type="text/javascript">
            var contextPath = '${pageContext.request.contextPath}';

            function handleBuyTickets(eventId, hasSeatingChartStr) {
                console.log("DEBUG: Bắt đầu hàm handleBuyTickets.");
                console.log("  - eventId nhận được:", eventId, "(kiểu:", typeof eventId, ")");
                console.log("  - hasSeatingChartStr nhận được:", hasSeatingChartStr, "(kiểu:", typeof hasSeatingChartStr, ")");

                if (hasSeatingChartStr === 'true') {
                    console.log("  - KẾT LUẬN: CÓ sơ đồ ghế. Chuyển hướng tới BookChairServlet.");
                    window.location.href = contextPath + '/BookSeatServlet?eventId=' + eventId;
                } else {
                    console.log("  - KẾT LUẬN: KHÔNG có sơ đồ ghế. Chuyển hướng tới TicketSelectionServlet.");
                    window.location.href = contextPath + '/TicketInfoServlet?eventId=' + eventId;
                }
            }

            function handleStartChat(eventId) {
                console.log("Starting chat for eventId: ", eventId);
                window.location.href = contextPath + '/init-chat?eventId=' + eventId;
            }


            document.addEventListener('DOMContentLoaded', function () {
                const stars = document.querySelectorAll('.rating .fa-star');
                stars.forEach((star, index) => {
                    star.addEventListener('click', function () {
                        stars.forEach((s, i) => {
                            if (i <= index) {
                                s.classList.remove('far');
                                s.classList.add('fas', 'active');
                            } else {
                                s.classList.remove('fas', 'active');
                                s.classList.add('far');
                            }
                        });
                    });

                    star.addEventListener('mouseenter', function () {
                        stars.forEach((s, i) => {
                            if (i <= index) {
                                s.style.color = 'var(--warning)';
                            } else {
                                s.style.color = 'var(--text-muted)';
                            }
                        });
                    });
                });

                document.querySelector('.rating').addEventListener('mouseleave', function () {
                    stars.forEach(star => {
                        if (!star.classList.contains('active')) {
                            star.style.color = 'var(--text-muted)';
                        }
                    });
                });
            });
        </script>
    </body>
</html>