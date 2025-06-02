<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

        <title>MasterTicket - Ticket Details</title>
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
                background: linear-gradient(to bottom, var(--darker-bg), var(--dark-bg));
                color: var(--text-light);
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

            /* Main Content */
            .main-content {
                max-width: 1300px;
                margin: 30px auto;
                padding: 0 30px;
            }

            /* Event Header */
            .event-header {
                display: flex;
                gap: 30px;
                margin-bottom: 30px;
            }

            .event-poster {
                width: 300px;
                height: 400px;
                border-radius: 10px;
                overflow: hidden;
                flex-shrink: 0;
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
                font-size: 28px;
                margin-bottom: 15px;
                color: var(--text-light);
            }

            .event-meta {
                display: flex;
                gap: 20px;
                margin-bottom: 20px;
                color: var(--text-muted);
            }

            .event-meta-item {
                display: flex;
                align-items: center;
                gap: 5px;
            }

            .event-description {
                margin-bottom: 30px;
                line-height: 1.6;
            }

            /* Ticket Table */
            /* === TICKET DETAIL CONTAINER === */
            .ticket-detail-container {
                max-width: 1300px;
                margin: 0 auto;
                padding: 20px;
                font-family: 'Segoe UI', Arial, sans-serif;
                color: #333;
            }

            .event-info-section.section-card {
                display: grid;
                justify-content: start;
                width: 70%;
            }

            /* .organizer-section.section-card{
                display: grid;
                justify-content: start;
                width: 70%;
            }*/

            .organizer-card {
                background-color: #f8f9fa;
                border-radius: 10px;
                padding: 20px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                width: 54vw;
            }



            /* === SECTION TITLES === */
            .section-title {
                font-size: 22px;
                font-weight: 600;
                margin-bottom: 20px;
                color: #4a4aff;
                padding-bottom: 8px;
                /* border-bottom: 2px solid #4a4aff; */
            }

            /* === 1. DETAILED INFORMATION === */
            .event-card {
                background-color: #f8f9fa;
                border-radius: 10px;
                margin-bottom: 30px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }

            .event-name {
                font-size: 20px;
                font-weight: 600;
                margin-bottom: 15px;
                color: #222;
            }

            .event-description {
                font-size: 15px;
                line-height: 1.6;
                margin-bottom: 20px;
                color: #555;
            }

            .event-meta {
                display: flex;
                flex-wrap: wrap;
                gap: 15px;
            }

            .meta-item {
                display: flex;
                align-items: center;
                gap: 8px;
                font-size: 14px;
                color: #666;
            }

            /* === 2. ORGANIZER === */
            .organizer-card {
                background-color: #f8f9fa;
                border-radius: 10px;
                padding: 20px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                margin-bottom: 30px;
            }

            .organizer-name {
                font-size: 18px;
                font-weight: 600;
                margin-bottom: 5px;
                color: #222;
            }

            .organizer-desc {
                font-size: 14px;
                color: #666;
                margin-bottom: 15px;
            }

            .organizer-links {
                display: flex;
                gap: 10px;
            }

            .organizer-link {
                display: inline-block;
                padding: 8px 15px;
                background-color: #4a4aff;
                color: white;
                text-decoration: none;
                border-radius: 5px;
                font-size: 14px;
                transition: background-color 0.2s;
            }

            .organizer-link:hover {
                background-color: #3a3add;
            }

            /* === 3. TICKET INFORMATION === */
            .ticket-table {
                width: 100%;
                border-collapse: collapse;
                background-color: #f8f9fa;
                border-radius: 10px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                overflow: hidden;
            }

            .ticket-table th {
                text-align: left;
                padding: 12px 15px;
                background-color: #e9ecef;
                font-weight: 600;
                color: #495057;
            }

            .ticket-table td {
                padding: 12px 15px;
                border-bottom: 1px solid #dee2e6;
                color: #555;
            }

            .ticket-table tr:last-child td {
                border-bottom: none;
            }

            .ticket-note {
                margin-top: 15px;
                font-size: 13px;
                color: #6c757d;
                font-style: italic;
            }


            .organizer-card {
                background-color: #f8f9fa;
                border-radius: 10px;
                padding: 20px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }

            .organizer-name {
                font-size: 18px;
                font-weight: 600;
                margin-bottom: 5px;
                color: #222;
            }

            .organizer-desc {
                font-size: 14px;
                color: #666;
                margin-bottom: 15px;
            }

            .organizer-links {
                display: flex;
                gap: 10px;
            }

            .organizer-link {
                display: inline-block;
                padding: 8px 15px;
                background-color: #4a4aff;
                color: white;
                text-decoration: none;
                border-radius: 5px;
                font-size: 14px;
                transition: background-color 0.2s;
            }

            .organizer-link:hover {
                background-color: #3a3add;
            }

            .number-btn:hover {
                background-color: var(--primary);
            }

            /* Organizer Info */
            .organizer-info {
                margin-top: 40px;
                background-color: var(--card-bg);
                padding: 20px;
                border-radius: 10px;
            }

            .organizer-title {
                font-size: 20px;
                margin-bottom: 15px;
                color: var(--primary);
            }

            /* Suggestions */
            .suggestions {
                margin-top: 60px;
            }

            .suggestions-title {
                font-size: 22px;
                margin-bottom: 20px;
                color: var(--secondary);
                position: relative;
                padding-bottom: 7%;
                display: flex;
                justify-content: center;
            }

            /* .suggestions-title::after {
                content: '';
                position: absolute;
                bottom: 0;
                left: 0;
                width: 50px;
                height: 3px;
                background-color: var(--secondary);
            }*/

            .suggestions-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
                gap: 20px;
            }

            .event-card {
                background-color: transparent;
                border-radius: 8px;
                overflow: hidden;
                transition: background-color 0.3s ease, transform 0.2s ease;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
                color: inherit;
            }

            /* IMAGE NOT AFFECTED */
            .event-card img {
                width: 100%;
                height: 150px;
                object-fit: cover;
                display: block;
                /* No transition or effects applied to image */
                border-top-left-radius: 8px;
                border-top-right-radius: 8px;
            }

            /* CARD BODY */
            .event-card .card-body {
                padding: 15px;
                background-color: transparent;
                transition: background-color 0.3s ease;
            }

            .event-card h4,
            .event-card p,
            .event-card .price {
                color: var(--text-muted);
                transition: color 0.3s ease;
            }

            /* HOVER ONLY AFFECTS BODY PART */
            .event-card:hover {
                background-color: #1E1F24;
                transform: translateY(-5px);
                box-shadow: 0 6px 12px rgba(0, 0, 0, 0.3);
            }

            .event-card:hover .card-body {
                background-color: #1E1F24; /* text background rises */
            }

            .event-card:hover h4,
            .event-card:hover p,
            .event-card:hover .price {
                color: #fff;
            }

            /* Text structure */
            .event-card h4 {
                font-size: 16px;
                margin-bottom: 5px;
            }

            .event-card p {
                font-size: 13px;
                margin-bottom: 10px;
            }

            .event-card .price {
                font-weight: bold;
                font-size: 14px;
                color: var(--secondary);
            }

            .event-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 6px 12px rgba(0, 0, 0, 0.3);
            }

            /* Wrapper centers and limits content width */
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


            /* Responsive */

            @media (max-width: 1024px) {
                .event-header {
                    flex-direction: column;
                }

                .event-poster {
                    width: 100%;
                    height: auto;
                    aspect-ratio: 2/3;
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
                }

                /* Footer responsive - keep content centered */
                .footer {
                    padding: 30px 50px; /* maintain padding for background width */
                }

                .footer-content {
                    max-width: 100%; /* full width for smaller screens */
                    padding: 0 20px; /* add small padding to avoid edge contact */
                    margin: 0 auto;
                    box-sizing: border-box;
                }

                .footer-container {
                    flex-direction: column;
                    align-items: center;
                    text-align: center;
                }

                .footer-section {
                    margin: 10px 0;
                    max-width: 100%;
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
                        <button class="primary-btn">Buy Tickets Now</button>
                    </div>
                </div>

                <div class="ticket-detail-container">
                    <div class="event-info-section section-card">
                        <h2 class="section-title">Detailed Information</h2>
                        <div class="event-card">
                            <h3 class="event-name">${event.name}</h3>
                            <p class="event-description">${event.description}</p>
                            <div class="event-meta">
                                <h3 class="section-title">Event Information</h3>
                                <div class="meta-item"><span>⏰</span>
                                    <fmt:formatDate value="${event.startTime}" pattern="HH:mm, dd/MM/yyyy"/>
                                </div>
                                <div class="meta-item"><span>📍</span> ${event.physicalLocation}</div>
                                <div class="meta-item"><span>💰</span> Price from:
                                    <c:choose>
                                        <c:when test="${not empty ticketList}">
                                            <fmt:formatNumber value="${ticketList[0].price}" type="currency" currencyCode="VND"/>
                                        </c:when>
                                        <c:otherwise>Contact</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="ticket-info-section section-card">
                        <h2 class="section-title">Ticket Types and Prices</h2>
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
                                        <td>${ticket.ticketName}</td>
                                        <td><fmt:formatNumber value="${ticket.price}" type="currency" currencyCode="VND"/></td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty ticketList}">
                                    <tr><td colspan="2">Chưa có vé cho sự kiện này</td></tr>
                                </c:if>
                            </tbody>
                        </table>
                        <p class="ticket-note">* Vé được cập nhật liên tục theo hệ thống phân phối và có thể thay đổi.</p>
                    </div>
                </div>

                <div class="organizer-section section-card">
                    <h2 class="section-title">Organizer</h2>
                    <div class="organizer-card">
                        <c:if test="${not empty organizer}">
                            <h3 class="organizer-name">${organizer.name}</h3>
                            <p class="organizer-desc">${organizer.description}</p>
                            <div class="organizer-links">
                                <a href="${organizer.website}" class="organizer-link">Learn More</a>
                            </div>
                        </c:if>
                        <c:if test="${empty organizer}">
                            <p>Organizer information has not been updated.</p>
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
                                        <%-- Assuming suggestedEvent also has a 'ticketList' if you want to display price --%>
                                        <%-- You might need to adjust your EventDAO::getSuggestedEvents to fetch ticket info for suggested events too, or simplify this --%>
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
    </body>
</html>