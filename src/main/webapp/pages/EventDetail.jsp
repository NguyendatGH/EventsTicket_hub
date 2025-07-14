<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

        <title>MasterTicket - EventDetails</title>
        <style>
            
            :root {
                --primary: #667aff;      /* Màu xanh dương dịu hơn */
                --secondary: #e06bce;    /* Màu hồng/tím nhẹ nhàng hơn */
                --dark-bg: #161b22;      /* Nền tối (hơi ngả xanh) */
                --darker-bg: #0d1117;    /* Nền tối hơn */
                --card-bg: #21262d;      /* Nền cho các thẻ thông tin */
                --border-color: #30363d; /* Màu viền tinh tế */
                --text-light: #e6edf3;   /* Màu chữ trắng ngà, dễ chịu cho mắt */
                --text-muted: #8b949e;   /* Màu chữ phụ */
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
                background: linear-gradient(to bottom, var(--darker-bg), var(--dark-bg));
                color: var(--text-light);
                min-height: 100vh;
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

            /* === DARK THEME FOR ORGANIZER CARD === */
            .organizer-card {
                background-color: transparent;
                padding: 0;
            }

            .organizer-name {
                font-size: 18px;
                font-weight: 600;
                margin-bottom: 5px;
                color: var(--text-light);
            }

            .organizer-desc {
                font-size: 14px;
                color: var(--text-muted);
                margin-bottom: 15px;
                line-height: 1.6;
            }

            .organizer-link {
                display: inline-block;
                padding: 8px 15px;
                background-color: var(--primary);
                color: white;
                text-decoration: none;
                border-radius: 5px;
                font-size: 14px;
                transition: background-color 0.2s;
            }

            .organizer-link:hover {
                background-color: #5566dd;
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

            /* ==== FOOTER SECTION (Unchanged as requested) ==== */
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

        <fmt:setLocale value="vi_VN" />

        <div class="main-content">
            <c:if test="${not empty event}">
                <div class="event-header">
                    <div class="event-poster">
                        <img src="${event.imageURL}" alt="${event.name} Poster">
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
                                        onclick="handleBuyTickets(${event.eventID}, '${event.hasSeatingChart}')">
                                    Buy Tickets Now
                                </button>
                                <button onClick="handleStartChat(${event.eventID})">Chat now</button>
                            </c:when>
                            <c:otherwise>
                                <c:url var="loginUrl" value="/login">
                                    <c:param name="redirect" value="EventServlet?id=${event.eventID}" />
                                </c:url>
                                <button class="primary-btn" onclick="location.href = '${loginUrl}'">
                                    Login to Buy Tickets
                                </button>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div class="ticket-detail-container">
                    <div class="event-info-section section-card">
                        <h2 class="section-title">Detailed Information</h2>
                        <div class="event-card-detail">
                            <h3 class="event-name">${event.name}</h3>
                            <div class="event-meta">
                                <div class="meta-item">
                                    <strong>⏰ Time:</strong>
                                    <span><fmt:formatDate value="${event.startTime}" pattern="HH:mm, dd/MM/yyyy"/></span>
                                </div>
                                <div class="meta-item">
                                    <strong>📍 Location:</strong> 
                                    <span>${event.physicalLocation}</span>
                                </div>
                                <div class="meta-item">
                                    <strong>💰 Price from:</strong>
                                    <span>
                                        <c:choose>
                                            <c:when test="${not empty ticketList}">
                                                <fmt:formatNumber value="${ticketList[0].price}" type="currency" currencyCode="VND"/>
                                            </c:when>
                                            <c:otherwise>Contact</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="ticket-info-section section-card">
                        <h2 class="section-title">Ticket Types and Prices</h2>

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
                        <h3>Customer Services</h3>
                        <ul>
                            <li><a href="#">FAQS</a></li>
                            <li><a href="#">Contact us</a></li>
                            <li><a href="#">Privacy Policy</a></li>
                            <li><a href="#">Terms of Service</a></li>
                        </ul>
                        <p><i class="fas fa-envelope"></i> <a href="mailto:support@masterTicket.vn">support@masterTicket.vn</a></p>
                    </div>

                    <div class="footer-section">
                        <h3>SiteMap</h3>
                        <ul>
                            <li><a href="#">Create Account</a></li>
                            <li><a href="#">News</a></li>
                            <li><a href="#">Top-Rated Event</a></li>
                        </ul>
                    </div>

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
    </body>
</html>