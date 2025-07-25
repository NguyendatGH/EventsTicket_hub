<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="dto.UserDTO"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

        <title>MasterTicket - Chi tiết sự kiện</title>
        <style>

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

            .header {
                width: 100vw;
                min-width: 100vw;
                background: var(--darker-bg);
                padding: 1rem 2rem;
                position: sticky;
                top: 0;
                z-index: 100;
                border-bottom: 1px solid var(--border-color);
                box-sizing: border-box;
            }

            .nav {
                width: 100%;
                max-width: none;
                margin: 0;
                box-sizing: border-box;
                display: flex;
                align-items: center;
            }

            .logo {
                font-size: 1.5rem;
                font-weight: bold;
                color: var(--primary);
                text-decoration: none;
                flex-shrink: 0;
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

            .user-greeting {
                color: var(--text-light);
                font-size: 0.9rem;
                margin-right: 0.75rem;
                white-space: nowrap;
                cursor: pointer;
            }

            .user-dropdown {
                position: absolute;
                top: 100%;
                right: 0;
                background: var(--darker-bg);
                border-radius: 10px;
                padding: 1rem;
                min-width: 200px;
                border: 1px solid var(--border-color);
                opacity: 0;
                visibility: hidden;
                transform: translateY(-10px);
                transition: all 0.3s;
                z-index: 101;
            }

            .user-dropdown.show {
                opacity: 1;
                visibility: visible;
                transform: translateY(0);
            }

            .dropdown-item {
                display: block;
                color: var(--text-light);
                text-decoration: none;
                padding: 0.5rem 0;
                border-bottom: 1px solid var(--border-color);
                transition: color 0.3s;
            }

            .dropdown-item:last-child {
                border-bottom: none;
            }

            .dropdown-item:hover {
                color: var(--primary);
            }

            @media (min-width: 993px) {
                .nav {
                    flex-wrap: nowrap;
                    justify-content: space-between;
                }
                .nav-links {
                    margin-left: 1rem;
                }
                .auth-buttons {
                    margin-left: 1rem;
                }
            }

            @media (max-width: 992px) {
                .nav {
                    flex-wrap: wrap;
                    justify-content: flex-start;
                }
                .logo {
                    margin-right: 1rem;
                }
                .nav-links {
                    flex-basis: 100%;
                    margin-left: 0;
                    margin-top: 1rem;
                    justify-content: flex-start;
                    flex-wrap: wrap;
                }
                .auth-buttons {
                    margin-left: auto;
                    order: 2;
                }
            }

            @media (max-width: 768px) {
                .nav {
                    flex-direction: column;
                    align-items: flex-start;
                }
                .logo {
                    width: 100%;
                    text-align: center;
                    margin-bottom: 1rem;
                    margin-right: 0;
                }
                .nav-links {
                    display: none;
                    flex-direction: column;
                    width: 100%;
                    padding: 1rem 0;
                    border-top: none;
                    box-shadow: none;
                    background: transparent;
                }
                .nav-links.active {
                    display: flex;
                }
                .auth-buttons {
                    order: unset;
                    width: 100%;
                    justify-content: center;
                    margin-left: 0;
                    margin-top: 1rem;
                }
            }

            .header-container {
                display: flex;
                justify-content: center;
                background-color: var(--darker-bg); /* Giữ nguyên nền header */
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.3);
                border-bottom: 1px solid var(--border-color);
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
                color: var(--primary); /* Sử dụng màu primary mới */
            }

            .search {
                display: flex;
                align-items: center;
                margin: 0 1.5rem;
                flex: 1;
            }

            .search input {
                padding: 10px 15px;
                border-radius: 25px;
                border: 1px solid var(--border-color);
                width: 300px;
                background-color: var(--card-bg); /* Nền ô search nhất quán */
                color: var(--text-light);
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
                background-color: #5566dd; /* Hover tối hơn một chút */
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
                background-color: #c85ab6; /* Hover tối hơn một chút */
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
                background-color: var(--card-bg);
                border: 1px solid var(--border-color);
                padding: 8px 16px;
                border-radius: 25px;
                font-weight: 500;
                cursor: pointer;
                transition: all 0.2s;
            }

            .account:hover {
                background-color: #444455;
            }


            .main-content {
                max-width: 1300px;
                margin: 40px auto; /* Tăng khoảng cách từ header */
                padding: 0 30px;
            }


            .event-header {
                display: flex;
                gap: 40px; /* Tăng khoảng cách giữa poster và thông tin */
                margin-bottom: 50px; /* Tăng khoảng cách tới phần dưới */
            }

            .event-poster {
                width: 300px;
                height: 400px;
                border-radius: 10px;
                overflow: hidden;
                flex-shrink: 0;
                box-shadow: 0 8px 20px rgba(0,0,0,0.4);
            }

            .event-poster img {
                width: 100%;
                height: 100%;
                object-fit: cover;
            }

            .event-info {
                flex: 1;
            }

            .event-title {
                font-size: 32px; /* Chữ to, rõ ràng hơn */
                margin-bottom: 20px;
                color: var(--text-light);
                font-weight: 700;
            }

            .event-meta {
                display: flex;
                flex-direction: column; /* xếp dọc cho rõ */
                gap: 15px;
                margin-bottom: 25px;
                color: var(--text-muted);
                font-size: 16px;
            }

            .event-meta-item {
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .event-description {
                margin-bottom: 30px;
                line-height: 1.7; /* Giãn dòng cho dễ đọc */
                color: var(--text-muted);
            }

            /* === UNIFIED DARK THEME FOR CONTENT SECTIONS === */

            .ticket-detail-container {
                display: flex;
                flex-direction: column;
                gap: 40px; /* Thêm khoảng cách giữa các khối thông tin */
            }

            .section-card {
                background-color: var(--card-bg);
                border: 1px solid var(--border-color);
                border-radius: 10px;
                padding: 25px 30px;
            }

            .section-title {
                font-size: 24px;
                font-weight: 600;
                margin-bottom: 25px;
                color: var(--primary);
                padding-bottom: 10px;
                border-bottom: 2px solid var(--primary); /* Thêm gạch chân để làm nổi bật tiêu đề */
                display: inline-block; /* Để border-bottom vừa với chữ */
            }

            /* Thẻ thông tin chi tiết */
            .event-card-detail .event-name { /* Đổi tên class để tránh xung đột */
                font-size: 20px;
                font-weight: 600;
                margin-bottom: 15px;
                color: var(--text-light); /* Đổi màu chữ */
            }

            .event-card-detail .event-description {
                font-size: 15px;
                line-height: 1.6;
                margin-bottom: 20px;
                color: var(--text-muted); /* Đổi màu chữ */
            }

            .event-card-detail .event-meta {
                display: flex;
                flex-direction: column;
                gap: 15px;
                align-items: flex-start;
            }

            .event-card-detail .meta-item {
                display: flex;
                align-items: center;
                gap: 8px;
                font-size: 15px;
                color: var(--text-muted); /* Đổi màu chữ */
            }
            .event-card-detail .meta-item span{
                color: var(--text-light); /* Đổi màu chữ */
            }


            /* === DARK THEME FOR TICKET TABLE === */
            .ticket-table {
                width: 100%;
                border-collapse: collapse;
                background-color: transparent; /* Bỏ nền cũ */
                overflow: hidden;
            }

            .ticket-table th {
                text-align: left;
                padding: 15px;
                background-color: rgba(110, 118, 129, 0.2); /* Nền header bảng */
                font-weight: 600;
                color: var(--text-light); /* Màu chữ header */
            }

            .ticket-table td {
                padding: 15px;
                border-bottom: 1px solid var(--border-color);
                color: var(--text-muted); /* Màu chữ nội dung */
            }
            .ticket-table td:last-child {
                color: var(--text-light);
                font-weight: 500;
            }

            .ticket-table tr:last-child td {
                border-bottom: none;
            }

            .ticket-note {
                margin-top: 15px;
                font-size: 13px;
                color: var(--text-muted);
                font-style: italic;
            }

            /* --- Feedback Section Styles --- */
            .feedback-section {
                margin-top: 40px; /* Khoảng cách phía trên phần feedback */
            }

            .feedback-form {
                margin-bottom: 30px;
                display: flex;
                flex-direction: column;
                gap: 15px;
            }

            .feedback-form textarea {
                width: 100%;
                padding: 15px;
                border: 1px solid var(--border-color);
                border-radius: 8px;
                background-color: var(--darker-bg); /* Nền tối hơn cho textarea */
                color: var(--text-light);
                font-size: 15px;
                resize: vertical;
                min-height: 100px;
            }

            .feedback-form textarea::placeholder {
                color: var(--text-muted);
            }

            .feedback-form .rating {
                display: flex;
                align-items: center;
                gap: 10px;
                font-size: 16px;
                color: var(--text-muted);
            }

            .feedback-form .rating .fa-star {
                cursor: pointer;
                color: var(--text-muted); /* Màu sao mặc định */
                transition: color 0.2s;
            }

            /* Màu sao đã chọn/hover - có thể thêm JS sau để đánh giá động */
            .feedback-form .rating .fa-star.active,
            .feedback-form .rating .fa-star:hover {
                color: var(--warning); /* Màu vàng cho sao đã chọn/hover */
            }

            .feedback-form .primary-btn {
                align-self: flex-start; /* Căn nút sang trái */
                padding: 10px 25px;
            }

            .feedback-list h3 {
                font-size: 20px;
                color: var(--text-light);
                margin-bottom: 20px;
                padding-bottom: 10px;
                border-bottom: 1px solid var(--border-color);
            }

            .feedback-item {
                background-color: var(--darker-bg); /* Nền hơi tối hơn cho từng mục feedback */
                border: 1px solid var(--border-color);
                border-radius: 8px;
                padding: 15px 20px;
                margin-bottom: 15px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.2);
            }

            .feedback-item:last-child {
                margin-bottom: 0;
            }

            .feedback-item .feedback-text {
                font-size: 15px;
                line-height: 1.6;
                color: var(--text-light);
                margin-bottom: 10px;
            }

            .feedback-item .feedback-meta {
                display: flex;
                align-items: center;
                gap: 10px;
                font-size: 13px;
                color: var(--text-muted);
            }

            .feedback-item .feedback-meta .feedback-author {
                font-weight: 600;
                color: var(--primary);
            }

            .feedback-item .feedback-meta .feedback-stars .fas.fa-star {
                color: var(--warning); /* Màu vàng cho sao đã điền */
            }

            .feedback-actions {
                display: flex;
                gap: 10px;
                margin-top: 10px;
            }

            .btn-like, .btn-reply {
                padding: 5px 10px;
                border: 1px solid var(--border-color);
                border-radius: 5px;
                background-color: var(--darker-bg);
                color: var(--text-light);
                font-size: 0.9rem;
                cursor: pointer;
                display: flex;
                align-items: center;
                gap: 5px;
                transition: all 0.2s;
            }

            .btn-like:hover, .btn-reply:hover {
                background-color: rgba(102, 122, 255, 0.2);
                color: var(--primary);
                border-color: var(--primary);
            }

            /* === SUGGESTIONS SECTION === */
            .suggestions {
                margin-top: 60px;
            }

            .suggestions-title {
                font-size: 24px;
                margin-bottom: 30px;
                color: var(--secondary);
                text-align: center;
                font-weight: 600;
            }

            .suggestions-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
                gap: 20px;
            }

            /* Styling cho card gợi ý */
            .event-card {
                background-color: var(--card-bg); /* Nền card nhất quán */
                border: 1px solid var(--border-color);
                border-radius: 8px;
                overflow: hidden;
                transition: transform 0.2s ease, box-shadow 0.2s ease;
                color: inherit;
                text-decoration: none;
            }

            .event-card img {
                width: 100%;
                height: 150px;
                object-fit: cover;
                display: block;
                border-bottom: 1px solid var(--border-color);
            }

            .event-card .card-body {
                padding: 15px;
            }

            .event-card h4 {
                font-size: 16px;
                margin-bottom: 5px;
                color: var(--text-light);
            }

            .event-card p {
                font-size: 13px;
                margin-bottom: 10px;
                color: var(--text-muted);
            }

            .event-card .price {
                font-weight: bold;
                font-size: 14px;
                color: var(--secondary);
            }

            .event-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 8px 15px rgba(0, 0, 0, 0.3);
                border-color: var(--primary);
            }

            /* ==== FOOTER SECTION ==== */
            .footer {
                padding: 40px 15px;
                background-color: var(--darker-bg);
                margin-top: 80px;
                border-top: 1px solid var(--border-color);
            }
            .footer-content {
                max-width: 1300px;
                margin: 0 auto;
                box-sizing: border-box;
            }
            .footer-container {
                display: flex;
                justify-content: space-between;
                flex-wrap: wrap;
                gap: 20px;
                padding: 0px 15px;
            }
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

            /* Responsive */
            @media (max-width: 1024px) {
                .event-header {
                    flex-direction: column;
                }
                .event-poster {
                    width: 100%;
                    height: auto;
                    aspect-ratio: 3/4; /* Giữ tỉ lệ poster */
                }
            }
            @media (max-width: 768px) {
                .header {
                    flex-direction: column;
                    gap: 15px;
                    padding: 15px 20px;
                }
                .search input {
                    width: 100%;
                }
                .main-content {
                    padding: 0 20px;
                    margin-top: 20px;
                }
                .footer {
                    padding: 30px 20px;
                }
                .footer-content {
                    padding: 0;
                }
                .footer-container {
                    flex-direction: column;
                    align-items: center;
                    text-align: center;
                }
                .subscribe-box {
                    flex-direction: column;
                    align-items: stretch;
                }
                .subscribe-box input,
                .subscribe-box button {
                    width: 100%;
                    box-sizing: border-box;
                }
            }
        </style>
    </head>
    <body>
        <header class="header">
            <div class="logo">MasterTicket</div>
            <div class="search">
                <input type="text" placeholder="Bạn đang tìm kiếm gì hôm nay?">
                <button>Tìm kiếm</button>
            </div>
            <div class="actions">
                <button class="primary-btn">Create Event</button>
                <a href="${pageContext.request.contextPath}/TicketOrderHistoryServlet" class="link">Vé đã mua</a>
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <span class="user-greeting">Xin chào, ${sessionScope.user.email}</span>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/login" class="btn btn-outline">Đăng nhập</a>
                        <a href="${pageContext.request.contextPath}/register" class="btn btn-primary">Đăng ký</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </header>

        <fmt:setLocale value="vi_VN" />

        <div class="main-content">
            <c:if test="${not empty event}">
                <div class="event-header">
                    <div class="event-poster">
                        <img src="${pageContext.request.contextPath}/uploads/event_banners/${event.imageURL}" alt="Poster sự kiện ${event.name}">
                    </div>
                    <div class="event-info">
                        <h1 class="event-title">${event.name}</h1>
                        <div class="event-meta">
                            <div class="event-meta-item">
                                <span>⏰</span>
                                <span>
                                    <fmt:formatDate value="${event.startTime}" pattern="HH:mm"/> -
                                    <fmt:formatDate value="${event.endTime}" pattern="HH:mm, dd/MM/yyyy"/>
                                </span>
                            </div>
                            <div class="event-meta-item">
                                <span>📍</span>
                                <span>${event.physicalLocation}</span>
                            </div>
                        </div>
                        <p class="event-description">${event.description}</p>
                        <c:choose>
                            <c:when test="${not empty sessionScope.user}">
                                <button class="primary-btn"
                                        onclick="handleBuyTickets('${event.eventID}', '${event.hasSeatingChart}')">
                                    Mua vé ngay
                                </button>
                                <button onClick="handleStartChat('${event.eventID}')">Chat ngay</button>
                            </c:when>
                            <c:otherwise>
                                <c:url var="loginUrl" value="/login">
                                    <c:param name="redirect" value="EventServlet?id=${event.eventID}" />
                                </c:url>
                                <button class="primary-btn" onclick="location.href = '${loginUrl}'">
                                    Đăng nhập để mua vé
                                </button>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div class="ticket-detail-container">
                    <div class="event-info-section section-card">
                        <h2 class="section-title">Thông tin chi tiết</h2>
                        <div class="event-card-detail">
                            <h3 class="event-name">${event.name}</h3>
                            <div class="event-meta">
                                <div class="meta-item">
                                    <strong>⏰ Thời gian:</strong>
                                    <span><fmt:formatDate value="${event.startTime}" pattern="HH:mm, dd/MM/yyyy"/></span>
                                </div>
                                <div class="meta-item">
                                    <strong>📍 Địa điểm:</strong>
                                    <span>${event.physicalLocation}</span>
                                </div>
                                <div class="meta-item">
                                    <strong>💰 Giá từ:</strong>
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

                    <div class="ticket-info-section section-card">
                        <h2 class="section-title">Loại vé và giá</h2>

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
                                            <td>
                                                <strong>${ticket.ticketName}</strong>
                                                <br>
                                                <span style="font-size: 0.9em; color: #555;">Loại: ${ticket.category}</span>
                                                <br>
                                                <small style="font-size: 0.8em; color: #777;">${ticket.ticketDescription}</small>
                                            </td>
                                            <td>
                                                <fmt:formatNumber value="${ticket.price}" type="currency" currencyCode="VND"/>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                            <p class="ticket-note">* Vé được cập nhật liên tục và có thể thay đổi.</p>
                        </c:if>
                    </div>
                </div>

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
                </c:if>
            <c:if test="${empty event}">
                <p style="text-align: center; font-size: 20px; color: var(--danger);">Không tìm thấy sự kiện. Vui lòng thử lại.</p>
            </c:if>


            <div class="suggestions">
                <h2 class="suggestions-title">Có Thể Bạn Cũng Thích</h2>
                <div class="suggestions-grid">
                    <c:forEach var="suggestedEvent" items="${suggestedEvents}">
                        <a href="EventServlet?id=${suggestedEvent.eventID}" class="event-card">
                            <img src="${suggestedEvent.imageURL}" alt="${suggestedEvent.name}">
                            <div class="card-body">
                                <h4>${suggestedEvent.name}</h4>
                                <p>
                                    <fmt:formatDate value="${suggestedEvent.startTime}" pattern="dd/MM/yyyy"/> •
                                    ${suggestedEvent.physicalLocation}
                                </p>
                                <p class="price">Từ
                                    <c:choose>
                                        <c:when test="${not empty suggestedEvent.ticketList}">
                                            <fmt:formatNumber value="${suggestedEvent.ticketList[0].price}" type="currency" currencyCode="VND"/>
                                        </c:when>
                                        <c:otherwise>Liên hệ</c:otherwise>
                                    </c:choose>
                                </p>
                            </div>
                        </a>
                    </c:forEach>
                    <c:if test="${empty suggestedEvents}">
                        <p style="grid-column: 1 / -1; text-align: center; color: var(--text-muted);">Không có sự kiện gợi ý nào vào lúc này.</p>
                    </c:if>
                </div>
            </div>
        </div>


        <footer class="footer">
            <div class="footer-content">
                <div class="footer-container">
                    <div class="footer-section">
                        <h3>Dịch vụ khách hàng</h3>
                        <ul>
                            <li><a href="#">Câu hỏi thường gặp</a></li>
                            <li><a href="#">Liên hệ chúng tôi</a></li>
                            <li><a href="#">Chính sách bảo mật</a></li>
                            <li><a href="#">Điều khoản dịch vụ</a></li>
                        </ul>
                        <p><i class="fas fa-envelope"></i> <a href="mailto:support@masterTicket.vn">support@masterTicket.vn</a></p>
                    </div>

                    <div class="footer-section">
                        <h3>Sitemap</h3>
                        <ul>
                            <li><a href="#">Tạo tài khoản</a></li>
                            <li><a href="#">Tin tức</a></li>
                            <li><a href="#">Sự kiện nổi bật</a></li>
                        </ul>
                    </div>

                    <div class="footer-section">
                        <h3>Đăng ký để nhận cập nhật sự kiện.</h3>
                        <form class="subscribe-box">
                            <input type="email" placeholder="Email của bạn..." required />
                            <button type="submit"><i class="fas fa-paper-plane"></i></button>
                        </form>

                        <div class="language">
                            <p>Ngôn ngữ:</p>
                            <img src="https://flagcdn.com/w40/vn.png" alt="Tiếng Việt" />
                            <img src="https://flagcdn.com/w40/gb.png" alt="Tiếng Anh" />
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
            </div>
        </footer>

        <script type="text/javascript">
            var contextPath = '${pageContext.request.contextPath}';
            console.log("[EventDetail.jsp - Inline JS] Context Path được định nghĩa là: '" + contextPath + "'");

            function handleBuyTickets(eventId, hasSeatingChartStr) {
                console.log("DEBUG: Bắt đầu hàm handleBuyTickets.");
                console.log("  - eventId nhận được:", eventId, "(kiểu:", typeof eventId, ")");
                console.log("  - hasSeatingChartStr nhận được:", hasSeatingChartStr, "(kiểu:", typeof hasSeatingChartStr, ")");

                if (hasSeatingChartStr === 'true') {
                    console.log("  - KẾT LUẬN: CÓ sơ đồ ghế. Chuyển hướng tới BookChairServlet.");
                    window.location.href = '${pageContext.request.contextPath}/BookChairServlet?eventId=' + eventId;
                } else {
                    console.log("  - KẾT LUẬN: KHÔNG có sơ đồ ghế. Chuyển hướng tới TicketSelectionServlet.");
                    window.location.href = '${pageContext.request.contextPath}/TicketInfoServlet?eventId=' + eventId;
                }
            }

            function handleStartChat(eventId){
                console.log("Starting chat for eventId: ", eventId);
            window.location.href = '${pageContext.request.contextPath}/init-chat?eventId=' + eventId;
            }
        </script>
        <script>
            // Toggle for user dropdown
            function toggleUserDropdown() {
                const dropdown = document.getElementById("userDropdown");
                if (dropdown) {
                    dropdown.classList.toggle("show");
                }
            }

            // Close dropdown if click outside
            window.addEventListener("click", function (e) {
                const userGreeting = document.querySelector(".user-greeting");
                const dropdown = document.getElementById("userDropdown");

                if (userGreeting && dropdown && !userGreeting.contains(e.target) && !dropdown.contains(e.target)) {
                    dropdown.classList.remove("show");
                }
            });
        </script>
    </body>
</html>