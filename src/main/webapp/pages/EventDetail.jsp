<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page import="dto.UserDTO"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MasterTicket - Chi tiết sự kiện</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
            margin: 0;
            background: linear-gradient(to bottom, #161b22, #0d1117);
            position: relative;
            overflow-x: hidden;
        }

        /* Background circles */
        body::before {
            content: '';
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: -1;
            background: 
                radial-gradient(circle at 20% 20%, rgba(102, 122, 255, 0.15) 0%, transparent 60%),
                radial-gradient(circle at 80% 40%, rgba(224, 107, 206, 0.12) 0%, transparent 60%),
                radial-gradient(circle at 40% 80%, rgba(102, 122, 255, 0.1) 0%, transparent 60%),
                radial-gradient(circle at 90% 10%, rgba(224, 107, 206, 0.08) 0%, transparent 60%),
                radial-gradient(circle at 10% 90%, rgba(102, 122, 255, 0.12) 0%, transparent 60%),
                radial-gradient(circle at 70% 70%, rgba(224, 107, 206, 0.09) 0%, transparent 60%);
            pointer-events: none;
            animation: float 20s ease-in-out infinite;
        }

        @keyframes float {
            0%, 100% {
                transform: translateY(0px) rotate(0deg);
            }
            33% {
                transform: translateY(-20px) rotate(1deg);
            }
            66% {
                transform: translateY(10px) rotate(-1deg);
            }
        }

        /* Additional background elements */
        body::after {
            content: '';
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: -2;
            background: 
                radial-gradient(circle at 30% 60%, rgba(102, 122, 255, 0.08) 0%, transparent 40%),
                radial-gradient(circle at 85% 25%, rgba(224, 107, 206, 0.06) 0%, transparent 40%),
                radial-gradient(circle at 15% 75%, rgba(102, 122, 255, 0.05) 0%, transparent 40%);
            pointer-events: none;
            animation: float 25s ease-in-out infinite reverse;
        }
        /* Color Scheme */
        :root {
            --primary: #667aff;
            --secondary: #e06bce;
            --dark-bg: #161b22;
            --darker-bg: #0d1117;
            --card-bg: #21262d;
            --border-color: #30363d;
            --text-light: #e6edf3;
            --text-muted: #8b949e;
            --success: #00cc66;
            --warning: #ffcc00;
            --danger: #ff3333;
        }

        .header {
            background: var(--darker-bg);
            padding: 1rem 2rem;
            position: sticky;
            top: 0;
            z-index: 100;
            border-bottom: 1px solid var(--border-color);
            overflow: visible;
        }

        .nav {
            display: flex;
            justify-content: space-between;
            align-items: center;
            max-width: 1400px;
            margin: 0 auto;
            flex-wrap: nowrap;
        }

        .logo {
            font-size: 1.5rem;
            font-weight: bold;
            color: var(--primary);
            text-decoration: none;
            flex-shrink: 0;
            margin-left: 1rem;
        }

        .nav-center-content {
            display: flex;
            align-items: center;
            flex-grow: 1;
            justify-content: center;
            gap: 1rem;
            flex-wrap: nowrap;
        }

        .nav-links {
            display: flex;
            gap: 1.5rem;
            list-style: none;
            flex-wrap: nowrap;
        }

        .nav-links a {
            color: var(--text-light);
            text-decoration: none;
            transition: color 0.3s;
            display: flex;
            align-items: center;
            gap: 5px;
            white-space: nowrap;
        }

        .nav-links a:hover {
            color: var(--primary);
        }

        .auth-buttons {
            display: flex;
            gap: 0.75rem;
            align-items: center;
            flex-shrink: 0;
            margin-left: 1rem;
            position: relative;
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

        /* User Menu */
        .user-menu {
            display: flex;
            align-items: center;
            gap: 1rem;
            position: relative;
            z-index: 1000;
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            cursor: pointer;
            padding: 0.5rem 0.75rem;
            border-radius: 25px;
            background: rgba(255, 255, 255, 0.1);
            transition: all 0.3s;
            max-width: 200px;
            overflow: hidden;
        }

        .user-info:hover {
            background: rgba(255, 255, 255, 0.15);
        }

        .user-avatar {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            background-size: cover;
            background-position: center;
            border: 1px solid rgba(255, 255, 255, 0.3);
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            font-size: 0.8rem;
            background: linear-gradient(45deg, var(--primary), var(--secondary));
            color: white;
            flex-shrink: 0;
        }

        .user-avatar img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 50%;
        }

        .user-info span {
            font-size: 0.9rem;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            max-width: 120px;
        }

        .user-dropdown {
            position: absolute;
            top: calc(100% + 10px);
            right: 0;
            background: var(--darker-bg);
            backdrop-filter: blur(10px);
            border-radius: 10px;
            padding: 1rem;
            min-width: 200px;
            border: 1px solid var(--border-color);
            opacity: 0;
            visibility: hidden;
            transform: translateY(-10px);
            transition: all 0.3s ease-in-out;
            z-index: 9999;
            max-height: none;
            overflow-y: visible;
        }

        .user-dropdown.show {
            opacity: 1;
            visibility: visible;
            transform: translateY(0);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.3);
        }

        .dropdown-item {
            display: block;
            color: var(--text-light);
            text-decoration: none;
            padding: 0.75rem 0.5rem;
            border-bottom: 1px solid var(--border-color);
            transition: background 0.3s, color 0.3s;
            white-space: nowrap;
        }

        .dropdown-item:last-child {
            border-bottom: none;
        }

        .dropdown-item:hover {
            background: rgba(102, 122, 255, 0.2);
            color: var(--primary);
        }

        /* Ensure all content has lower z-index than dropdown */
        .container * {
            z-index: 1;
        }


        .main-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 1.2rem 0.5rem 0 0.5rem;
            background: none;
        }
        .section-card, .ticket-table-section, .event-description, .organizer-section, .feedback-section {
            background: rgba(24,28,42,0.98);
            border-radius: 12px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.08);
            padding: 1.2rem 1.2rem;
            margin-bottom: 1.2rem;
            position: relative;
            z-index: 1;
            color: #e6edf3;
        }
        .ticket-banner {
            display: flex;
            align-items: center;
            background: linear-gradient(90deg, #7b2ff2 0%, #f357a8 100%);
            border-radius: 24px;
            padding: 2rem;
            margin-bottom: 2.5rem;
            box-shadow: 0 8px 32px rgba(0,0,0,0.18);
            position: relative;
        }
        .ticket-banner .ticket-info {
            flex: 1;
            background: #fff;
            color: #181c2a;
            border-radius: 18px;
            padding: 2rem 2.5rem;
            box-shadow: 0 4px 16px rgba(0,0,0,0.08);
            display: flex;
            flex-direction: column;
            gap: 1.2rem;
            position: relative;
        }
        .ticket-banner .ticket-info .event-title {
            font-size: 1.3rem;
            font-weight: bold;
            color: #181c2a;
        }
        .ticket-banner .ticket-info .event-meta {
            font-size: 1rem;
            color: #444;
            display: flex;
            flex-wrap: wrap;
            gap: 1.2rem;
        }
        .ticket-banner .ticket-info .event-meta span {
            display: flex;
            align-items: center;
            gap: 0.4rem;
        }
        .ticket-banner .ticket-info .barcode {
            margin-top: 1.2rem;
            display: flex;
            align-items: center;
            gap: 1.2rem;
        }
        .ticket-banner .ticket-info .barcode img {
            height: 48px;
        }
        .ticket-banner .ticket-info .price {
            font-size: 1.1rem;
            color: #667aff;
            font-weight: bold;
        }
        .ticket-banner .ticket-info .btn-primary {
            align-self: flex-end;
            margin-top: 1rem;
        }
        .ticket-banner .event-image {
            width: 220px;
            height: 320px;
            border-radius: 18px;
            overflow: hidden;
            margin-left: 2.5rem;
            box-shadow: 0 4px 24px rgba(0,0,0,0.18);
            flex-shrink: 0;
            background: #23263a;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .ticket-banner .event-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .section-title {
            font-size: 1.3rem;
            color: #667aff;
            font-weight: bold;
            margin-bottom: 1.2rem;
        }
        .event-detail-content {
            display: flex;
            gap: 2rem;
            margin-bottom: 2.5rem;
        }
        .event-detail-main {
            flex: 2;
        }
        .event-detail-side {
            flex: 1;
            min-width: 220px;
        }
        .event-description {
            background: #23263a;
            border-radius: 16px;
            padding: 1.5rem 2rem;
            margin-bottom: 1.5rem;
            color: #e6edf3;
            font-size: 1.05rem;
        }
        .event-detail-side .side-banner {
            background: #fff;
            border-radius: 16px;
            padding: 1rem;
            margin-bottom: 1.5rem;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            display: flex;
            flex-direction: column;
            align-items: center;
        }
        .event-detail-side .side-banner img {
            width: 100%;
            border-radius: 12px;
            margin-bottom: 0.8rem;
        }
        .event-detail-side .side-banner .side-title {
            font-size: 1rem;
            color: #181c2a;
            font-weight: bold;
            margin-bottom: 0.5rem;
        }
        .event-detail-side .side-banner .side-desc {
            font-size: 0.95rem;
            color: #444;
        }
        .ticket-table-section {
            background: #23263a;
            border-radius: 16px;
            padding: 1.5rem 2rem;
            margin-bottom: 2rem;
        }
        .ticket-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 1rem;
        }
        .ticket-table th, .ticket-table td {
            padding: 1rem 0.7rem;
            text-align: left;
            color: #e6edf3;
        }
        .ticket-table th {
            color: #667aff;
            font-weight: 600;
            border-bottom: 1px solid #30363d;
        }
        .ticket-table tr {
            border-bottom: 1px solid #23263a;
        }
        .ticket-table tr:last-child {
            border-bottom: none;
        }
        .ticket-table .price {
            color: #00cc66;
            font-weight: bold;
        }
        .ticket-note {
            color: #ffcc00;
            font-size: 0.95rem;
            margin-top: 0.5rem;
        }
        .organizer-section {
            background: #23263a;
            border-radius: 16px;
            padding: 1.5rem 2rem;
            margin-bottom: 2rem;
            display: flex;
            align-items: center;
            gap: 1.5rem;
        }
        .organizer-logo {
            width: 60px;
            height: 60px;
            border-radius: 12px;
            overflow: hidden;
            background: #fff;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .organizer-logo img {
            width: 100%;
            height: 100%;
            object-fit: contain;
        }
        .organizer-info {
            flex: 1;
        }
        .organizer-info .org-name {
            font-size: 1.1rem;
            font-weight: bold;
            color: #fff;
        }
        .organizer-info .org-desc {
            color: #8b949e;
            font-size: 0.97rem;
        }
        .organizer-section .btn-primary {
            margin-left: auto;
        }
        .suggestions {
            margin-top: 2.5rem;
        }
        .suggestions-title {
            font-size: 1.2rem;
            color: #e06bce;
            font-weight: bold;
            margin-bottom: 1.2rem;
        }
        .suggestions-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 1.2rem;
        }
        .event-card {
            background: #23263a;
            border-radius: 14px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            text-decoration: none;
            color: #e6edf3;
            display: flex;
            flex-direction: column;
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .event-card:hover {
            transform: translateY(-6px) scale(1.03);
            box-shadow: 0 8px 32px rgba(102,122,255,0.12);
        }
        .event-card img {
            width: 100%;
            height: 140px;
            object-fit: cover;
            background: #181c2a;
        }
        .event-card .card-body {
            padding: 1rem 1.2rem;
        }
        .event-card .card-body h4 {
            font-size: 1.05rem;
            font-weight: bold;
            margin: 0 0 0.5rem 0;
            color: #fff;
        }
        .event-card .card-body p {
            font-size: 0.95rem;
            color: #8b949e;
            margin: 0.2rem 0;
        }
        .event-card .card-body .price {
            color: #00cc66;
            font-weight: bold;
            font-size: 1rem;
        }
        .footer {
            background: #181c2a;
            color: #8b949e;
            padding: 3rem 0 1.5rem 0;
            margin-top: 3rem;
        }
        .footer-content {
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            flex-wrap: wrap;
            gap: 2rem;
            justify-content: space-between;
        }
        .footer-section {
            flex: 1 1 220px;
            min-width: 200px;
        }
        .footer-section h3 {
            color: #667aff;
            margin-bottom: 1rem;
            font-size: 1.1rem;
        }
        .footer-section ul {
            list-style: none;
            padding: 0;
            margin: 0 0 1rem 0;
        }
        .footer-section ul li {
            margin-bottom: 0.5rem;
        }
        .footer-section ul li a {
            color: #8b949e;
            text-decoration: none;
            transition: color 0.2s;
        }
        .footer-section ul li a:hover {
            color: #667aff;
        }
        .subscribe-box {
            display: flex;
            gap: 0.5rem;
            margin-top: 1rem;
            border: 2px solid #667aff;
            border-radius: 8px;
            padding: 5px;
            background: #23263a;
        }
        .subscribe-box input {
            flex: 1;
            padding: 0.75rem;
            border: none;
            border-radius: 25px;
            background: transparent;
            color: #e6edf3;
            outline: none;
        }
        .subscribe-box button {
            padding: 0.75rem 1rem;
            border: none;
            border-radius: 25px;
            background: #667aff;
            color: #e6edf3;
            cursor: pointer;
            transition: background 0.2s;
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
            transition: transform 0.2s;
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
            transition: transform 0.2s;
        }
        .social-images img:hover {
            transform: scale(1.1);
        }
        @media (max-width: 900px) {
            .main-container { padding: 1rem 0.2rem 0 0.2rem; }
            .ticket-banner { flex-direction: column; align-items: stretch; }
            .ticket-banner .event-image { margin-left: 0; margin-top: 2rem; width: 100%; height: 220px; }
            .event-detail-content { flex-direction: column; gap: 1.2rem; }
            .event-detail-side { min-width: unset; }
        }
        @media (max-width: 600px) {
            .header { flex-direction: column; gap: 1rem; padding: 1rem 0.5rem; }
            .search-bar { margin: 1rem 0; }
            .main-container { padding: 0.5rem 0.1rem 0 0.1rem; }
            .ticket-banner { padding: 1rem; }
            .ticket-banner .ticket-info { padding: 1rem; }
            .event-detail-content { gap: 0.5rem; }
            .event-description, .ticket-table-section, .organizer-section { padding: 1rem; }
        }
    </style>
</head>
<body>
    <!-- Header -->
    <header class="header">
        <nav class="nav">
            <a href="${pageContext.request.contextPath}/home" class="logo">MasterTicket</a>

            <div class="nav-center-content">
                <ul class="nav-links">
                    <li><a href="${pageContext.request.contextPath}/home"><i class="fas fa-home"></i> Trang chủ</a></li>
                    <li><a href="${pageContext.request.contextPath}/home#hot-events"><i class="fas fa-fire"></i> Sự kiện hot</a></li>
                    <li><a href="${pageContext.request.contextPath}/home#vouchers"><i class="fas fa-tags"></i> Săn voucher</a></li>
                    <li><a href="${pageContext.request.contextPath}/support"><i class="fas fa-question-circle"></i> Hỗ trợ</a></li>
                </ul>
            </div>

            <div class="auth-buttons">
                <c:choose>
                    <c:when test="${sessionScope.user != null}">
                        <div class="user-menu">
                            <div class="user-info" onclick="toggleUserDropdown()">
                                <div class="user-avatar">
                                    <c:if test="${not empty sessionScope.user.avatar}">
                                        <img src="${pageContext.request.contextPath}/uploads/user_avatar/${sessionScope.user.avatar}" alt="Avatar">
                                    </c:if>
                                    <c:if test="${empty sessionScope.user.avatar}">
                                        ${fn:substring(sessionScope.user.email, 0, 1)}
                                    </c:if>
                                </div>
                                Xin chào, ${sessionScope.user.name != null ? sessionScope.user.name : sessionScope.user.email} <span style="margin-left: 0.5rem;">▼</span>
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
                        <a href="${pageContext.request.contextPath}/login" class="btn btn-outline">Đăng nhập</a>
                        <a href="${pageContext.request.contextPath}/register" class="btn btn-primary">Đăng ký</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </nav>
    </header>
    <div class="main-container">
        <!-- Ticket Banner -->
        <div class="ticket-banner">
            <div class="ticket-info">
                <div class="event-title">${event.name}</div>
                <div class="event-meta">
                    <span><i class="fa fa-calendar"></i> <fmt:formatDate value="${event.startTime}" pattern="HH:mm, dd/MM/yyyy"/></span>
                    <span><i class="fa fa-map-marker-alt"></i> ${event.physicalLocation}</span>
                </div>
                <div class="barcode">
                    <img src="${pageContext.request.contextPath}/asset/image/Ticket_duotone.svg" alt="barcode" />
                    <span>Price from: <span class="price">
                        <c:choose>
                            <c:when test="${not empty ticketList}">
                                <fmt:formatNumber value="${ticketList[0].price}" type="currency" currencyCode="VND"/>
                            </c:when>
                            <c:otherwise>Liên hệ</c:otherwise>
                        </c:choose>
                    </span></span>
                </div>
                <button class="btn-primary" onclick="handleBuyTickets('${event.eventID}', '${event.hasSeatingChart}')">Buy Now</button>
            </div>
            <div class="event-image">
                <c:choose>
                    <c:when test="${not empty event.imageURL && fn:startsWith(event.imageURL, 'http')}">
                        <img src="${event.imageURL}" alt="${event.name}" />
                    </c:when>
                    <c:otherwise>
                        <img src="${pageContext.request.contextPath}/uploads/event_banners/${event.imageURL}" alt="${event.name}" />
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
        <!-- Event Detail Content -->
        <div class="event-detail-content">
            <div class="event-detail-main">
                <div class="section-title">Thông tin chi tiết</div>
                <div class="event-description">
                    <b>${event.name}</b><br/>
                    <fmt:formatDate value="${event.startTime}" pattern="dd/MM/yyyy"/> tại <b>${event.physicalLocation}</b><br/><br/>
                    ${event.description}
                </div>
                <div class="ticket-table-section">
                    <div class="section-title">Hạng vé & giá</div>
                    <c:if test="${empty ticketList}">
                        <p>Chưa có vé cho sự kiện này hoặc vé đã ngừng bán.</p>
                    </c:if>
                    <c:if test="${not empty ticketList}">
                        <table class="ticket-table">
                            <thead>
                                <tr>
                                    <th>Loại vé</th>
                                    <th>Giá</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="ticket" items="${ticketList}">
                                    <tr>
                                        <td><strong>${ticket.ticketName}</strong><br/><span style="font-size: 0.9em; color: #aaa;">${ticket.ticketDescription}</span></td>
                                        <td class="price"><fmt:formatNumber value="${ticket.price}" type="currency" currencyCode="VND"/></td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                        <p class="ticket-note">* Vé được cập nhật liên tục và có thể thay đổi.</p>
                    </c:if>
                </div>
            </div>
            <div class="event-detail-side">
                <div class="side-banner">
                    <img src="${pageContext.request.contextPath}/asset/image/Banner_secondary.svg" alt="side banner" />
                    <div class="side-title">BABYMONSTER HELLO MONSTERS</div>
                    <div class="side-desc">Giảm 150K khi thanh toán bằng VNPAY</div>
                </div>
                <div class="organizer-section">
                    <div class="organizer-logo">
                        <img src="${pageContext.request.contextPath}/uploads/user_avatar/maylangthang.jpg" alt="May Lang Thang" />
                    </div>
                    <div class="organizer-info">
                        <div class="org-name">May Lang Thang</div>
                        <div class="org-desc">Nơi âm nhạc và cảm xúc thăng hoa</div>
                    </div>
                    <a href="#" class="btn-primary">Xem Thêm</a>
                </div>
            </div>
        </div>
        <!-- Suggestions -->
        <div class="suggestions">
            <div class="suggestions-title">Có Thể Bạn Cũng Thích</div>
            <div class="suggestions-grid">
                <c:forEach var="suggestedEvent" items="${suggestedEvents}">
                    <a href="EventServlet?id=${suggestedEvent.eventID}" class="event-card">
                        <c:choose>
                            <c:when test="${not empty suggestedEvent.imageURL && fn:startsWith(suggestedEvent.imageURL, 'http')}">
                                <img src="${suggestedEvent.imageURL}" alt="${suggestedEvent.name}" />
                            </c:when>
                            <c:otherwise>
                                <img src="${pageContext.request.contextPath}/uploads/event_banners/${suggestedEvent.imageURL}" alt="${suggestedEvent.name}" />
                            </c:otherwise>
                        </c:choose>
                        <div class="card-body">
                            <h4>${suggestedEvent.name}</h4>
                            <p><fmt:formatDate value="${suggestedEvent.startTime}" pattern="dd/MM/yyyy"/> • ${suggestedEvent.physicalLocation}</p>
                        </div>
                    </a>
                </c:forEach>
                <c:if test="${empty suggestedEvents}">
                    <p style="grid-column: 1 / -1; text-align: center; color: #8b949e;">Không có sự kiện gợi ý nào vào lúc này.</p>
                </c:if>
            </div>
        </div>
        <!-- Feedback Section -->
        <div class="feedback-section section-card">
            <h2 class="section-title">Đánh giá & Phản hồi từ người tham dự</h2>
            <c:choose>
                <c:when test="${not empty feedbackList}">
                    <c:forEach var="fb" items="${feedbackList}">
                        <div class="feedback-item">
                            <div class="feedback-meta">
                                <span class="feedback-author">${fb.userName}</span>
                                <span class="feedback-date">
                                    <fmt:formatDate value="${fb.createdAtDate}" pattern="dd/MM/yyyy HH:mm"/>
                                </span>
                                <span class="feedback-stars">
                                    <c:forEach begin="1" end="${fb.rating}" var="i">★</c:forEach>
                                </span>
                            </div>
                            <div class="feedback-text">${fb.content}</div>
                            <div class="feedback-actions">
                                <button class="btn-like" title="Thích"><i class="fa fa-thumbs-up"></i> Thích</button>
                                <button class="btn-reply" title="Phản hồi"><i class="fa fa-reply"></i> Phản hồi</button>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="feedback-item">
                        <div class="feedback-text">Chưa có phản hồi nào cho sự kiện này.</div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
    <!-- Footer -->
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
                <p><a href="mailto:support@masterticket.vn">support@masterticket.vn</a></p>
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
                <form class="subscribe-box">
                    <input type="email" placeholder="Your email..." required />
                    <button type="submit"><i class="fas fa-paper-plane"></i></button>
                </form>
                <div class="language">
                    <p>Language:</p>
                    <img src="https://flagcdn.com/w40/vn.png" alt="Tiếng Việt" />
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
    </footer>
    <script>
        function handleBuyTickets(eventId, hasSeatingChartStr) {
                console.log("DEBUG: Bắt đầu hàm handleBuyTickets.");
                console.log("  - eventId nhận được:", eventId, "(kiểu:", typeof eventId, ")");
                console.log("  - hasSeatingChartStr nhận được:", hasSeatingChartStr, "(kiểu:", typeof hasSeatingChartStr, ")");

                if (hasSeatingChartStr === 'true') {
                    console.log("  - KẾT LUẬN: CÓ sơ đồ ghế. Chuyển hướng tới BookChairServlet.");
                   window.location.href = '${pageContext.request.contextPath}/BookSeatServlet?eventId=' + eventId;
                } else {
                    console.log("  - KẾT LUẬN: KHÔNG có sơ đồ ghế. Chuyển hướng tới TicketSelectionServlet.");
                    window.location.href = '${pageContext.request.contextPath}/TicketInfoServlet?eventId=' + eventId;
                }
            }

        function toggleUserDropdown() {
            const dropdown = document.getElementById('userDropdown');
            dropdown.classList.toggle('show');
            
            if (dropdown.classList.contains('show')) {
                // Check if dropdown goes below viewport
                const rect = dropdown.getBoundingClientRect();
                const viewportHeight = window.innerHeight;
                
                if (rect.bottom > viewportHeight) {
                    // Position dropdown above the user menu
                    dropdown.style.top = 'auto';
                    dropdown.style.bottom = 'calc(100% + 10px)';
                } else {
                    // Reset to default position
                    dropdown.style.top = 'calc(100% + 10px)';
                    dropdown.style.bottom = 'auto';
                }
            }
        }

        // Close dropdown when clicking outside
        window.onclick = function(event) {
            if (!event.target.matches('.user-info') && !event.target.matches('.user-info *')) {
                const dropdowns = document.getElementsByClassName('user-dropdown');
                for (let dropdown of dropdowns) {
                    if (dropdown.classList.contains('show')) {
                        dropdown.classList.remove('show');
                    }
                }
            }
        };
    </script>
</body>
</html>