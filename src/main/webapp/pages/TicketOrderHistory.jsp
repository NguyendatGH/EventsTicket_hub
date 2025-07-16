<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="java.util.Date" %>
<fmt:setLocale value="vi_VN"/>
<fmt:setTimeZone value="Asia/Ho_Chi_Minh"/>
<%
    request.setAttribute("now", new Date());
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <title>MasterTicket - Vé đã mua</title>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
                background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
                color: #1e293b;
                line-height: 1.6;
                min-height: 100vh;
            }

            /* Header Styles */
            .header {
                background: white;
                box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
                border-bottom: 1px solid #e2e8f0;
                position: sticky;
                top: 0;
                z-index: 100;
            }

            .header-container {
                max-width: 1280px;
                margin: 0 auto;
                padding: 0 1rem;
                display: flex;
                align-items: center;
                justify-content: space-between;
                height: 4rem;
            }

            .logo {
                font-size: 1.5rem;
                font-weight: 700;
                background: linear-gradient(135deg, #3b82f6, #8b5cf6);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                background-clip: text;
            }

            .search-container {
                flex: 1;
                max-width: 28rem;
                margin: 0 2rem;
                position: relative;
            }

            .search-input {
                width: 100%;
                padding: 0.75rem 1rem 0.75rem 2.5rem;
                border: 1px solid #d1d5db;
                border-radius: 9999px;
                background: #f9fafb;
                font-size: 0.875rem;
                transition: all 0.2s;
            }

            .search-input:focus {
                outline: none;
                border-color: #3b82f6;
                box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
                background: white;
            }

            .search-icon {
                position: absolute;
                left: 0.75rem;
                top: 50%;
                transform: translateY(-50%);
                color: #6b7280;
            }

            .header-actions {
                display: flex;
                align-items: center;
                gap: 1rem;
            }

            .btn {
                padding: 0.5rem 1rem;
                border-radius: 9999px;
                font-weight: 500;
                font-size: 0.875rem;
                cursor: pointer;
                transition: all 0.2s;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                gap: 0.5rem;
            }

            .btn-outline {
                background: transparent;
                border: 1px solid #d1d5db;
                color: #374151;
            }

            .btn-outline:hover {
                background: #f3f4f6;
                border-color: #9ca3af;
            }

            .btn-primary {
                background: linear-gradient(135deg, #3b82f6, #8b5cf6);
                border: none;
                color: white;
            }

            .btn-primary:hover {
                background: linear-gradient(135deg, #2563eb, #7c3aed);
                transform: translateY(-1px);
                box-shadow: 0 4px 12px rgba(59, 130, 246, 0.4);
            }

            /* Main Content */
            .main-container {
                max-width: 1280px;
                margin: 0 auto;
                padding: 2rem 1rem;
            }

            .page-header {
                margin-bottom: 2rem;
            }

            .page-title {
                font-size: 2rem;
                font-weight: 700;
                color: #1e293b;
                margin-bottom: 0.5rem;
            }

            .page-subtitle {
                color: #64748b;
                font-size: 1rem;
            }

            /* Filter Tabs */
            .filter-tabs {
                display: flex;
                background: #f1f5f9;
                border-radius: 9999px;
                padding: 0.25rem;
                margin-bottom: 1.5rem;
                max-width: 24rem;
            }

            .filter-tab {
                flex: 1;
                padding: 0.5rem 1rem;
                border: none;
                background: transparent;
                border-radius: 9999px;
                font-size: 0.875rem;
                font-weight: 500;
                cursor: pointer;
                transition: all 0.2s;
                color: #64748b;
            }

            .filter-tab.active {
                background: white;
                color: #1e293b;
                box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            }

            .filter-tab:hover:not(.active) {
                color: #374151;
            }

            /* Status Buttons */
            .status-filters {
                display: flex;
                gap: 1rem;
                margin-bottom: 2rem;
            }

            .status-btn {
                padding: 0.75rem 1.5rem;
                border-radius: 9999px;
                border: 1px solid #d1d5db;
                background: white;
                color: #374151;
                font-weight: 500;
                cursor: pointer;
                transition: all 0.2s;
                display: flex;
                align-items: center;
                gap: 0.5rem;
            }

            .status-btn.active {
                background: linear-gradient(135deg, #3b82f6, #8b5cf6);
                color: white;
                border-color: transparent;
            }

            .status-btn:hover:not(.active) {
                background: #f8fafc;
                border-color: #9ca3af;
            }

            /* Cards */
            .card {
                background: white;
                border-radius: 1rem;
                box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
                overflow: hidden;
                transition: all 0.3s;
                margin-bottom: 1.5rem;
            }

            .card:hover {
                box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15);
                transform: translateY(-2px);
            }

            .card-header {
                background: linear-gradient(135deg, #f8fafc, #e2e8f0);
                padding: 1.5rem;
                border-bottom: 1px solid #e2e8f0;
            }

            .card-title {
                font-size: 1.25rem;
                font-weight: 600;
                color: #1e293b;
                margin-bottom: 0.5rem;
            }

            .card-meta {
                display: flex;
                flex-wrap: wrap;
                gap: 1rem;
                color: #64748b;
                font-size: 0.875rem;
            }

            .card-meta-item {
                display: flex;
                align-items: center;
                gap: 0.25rem;
            }

            .card-content {
                padding: 1.5rem;
            }

            .card-grid {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 1.5rem;
            }

            @media (max-width: 768px) {
                .card-grid {
                    grid-template-columns: 1fr;
                }
            }

            /* Badge */
            .badge {
                padding: 0.25rem 0.75rem;
                border-radius: 9999px;
                font-size: 0.75rem;
                font-weight: 500;
                text-transform: uppercase;
                letter-spacing: 0.05em;
            }

            .badge-success {
                background: #dcfce7;
                color: #166534;
                border: 1px solid #bbf7d0;
            }

            .badge-warning {
                background: #fef3c7;
                color: #92400e;
                border: 1px solid #fde68a;
            }

            .badge-danger {
                background: #fee2e2;
                color: #991b1b;
                border: 1px solid #fecaca;
            }

            /* Ticket Details */
            .ticket-section {
                background: #f8fafc;
                border-radius: 0.75rem;
                padding: 1rem;
                margin-bottom: 1rem;
            }

            .ticket-section h4 {
                font-weight: 600;
                color: #1e293b;
                margin-bottom: 0.75rem;
                display: flex;
                align-items: center;
                gap: 0.5rem;
            }

            .ticket-detail {
                background: white;
                border-radius: 0.5rem;
                padding: 1rem;
                margin-bottom: 0.75rem;
                border: 1px solid #e2e8f0;
            }

            .ticket-detail-grid {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 0.75rem;
                font-size: 0.875rem;
            }

            .ticket-detail-item {
                display: flex;
                flex-direction: column;
            }

            .ticket-detail-label {
                color: #64748b;
                font-size: 0.75rem;
                margin-bottom: 0.25rem;
            }

            .ticket-detail-value {
                font-weight: 500;
                color: #1e293b;
            }

            .ticket-code {
                font-family: 'Courier New', monospace;
                background: #f1f5f9;
                padding: 0.25rem 0.5rem;
                border-radius: 0.25rem;
            }

            /* Payment Info */
            .payment-section {
                background: #f8fafc;
                border-radius: 0.75rem;
                padding: 1rem;
            }

            .payment-total {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 0.5rem;
                padding-bottom: 0.5rem;
                border-bottom: 1px solid #e2e8f0;
            }

            .payment-total-amount {
                font-size: 1.25rem;
                font-weight: 700;
                color: #059669;
            }

            .payment-date {
                display: flex;
                justify-content: space-between;
                color: #64748b;
                font-size: 0.875rem;
            }

            /* Action Buttons */
            .action-buttons {
                display: flex;
                gap: 0.75rem;
                margin-top: 1rem;
            }

            .btn-sm {
                padding: 0.5rem 1rem;
                font-size: 0.875rem;
            }

            .btn-refund {
                background: #fef2f2;
                color: #dc2626;
                border: 1px solid #fecaca;
            }

            .btn-refund:hover {
                background: #fee2e2;
            }

            .btn-view {
                background: #eff6ff;
                color: #2563eb;
                border: 1px solid #dbeafe;
            }

            .btn-view:hover {
                background: #dbeafe;
            }

            /* Empty State */
            .empty-state {
                text-align: center;
                padding: 4rem 2rem;
                background: white;
                border-radius: 1rem;
                margin-bottom: 2rem;
            }

            .empty-icon {
                width: 6rem;
                height: 6rem;
                background: linear-gradient(135deg, #dbeafe, #e0e7ff);
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                margin: 0 auto 1.5rem;
                font-size: 2rem;
            }

            .empty-title {
                font-size: 1.25rem;
                font-weight: 600;
                color: #1e293b;
                margin-bottom: 0.5rem;
            }

            .empty-description {
                color: #64748b;
                margin-bottom: 1.5rem;
            }

            /*ticket-history*/
            .tickets-list-horizontal {
                display: flex;
                flex-direction: column;
                gap: 1.5rem;
            }

            .ticket-horizontal-card {
                display: flex;
                justify-content: space-between;
                align-items: center;
                background: #ffffff;
                border: 1px solid #e5e7eb;
                border-radius: 1rem;
                padding: 1.5rem;
                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.05);
                transition: transform 0.2s;
            }

            .ticket-horizontal-card:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 14px rgba(0, 0, 0, 0.1);
            }

            .ticket-info h3 {
                font-size: 1.25rem;
                font-weight: 600;
                margin-bottom: 0.5rem;
                color: #1e293b;
            }

            .ticket-info p {
                margin: 0.2rem 0;
                color: #334155;
            }

            .refund-form {
                align-self: flex-start;
            }

            .btn-refund {
                background-color: #fee2e2;
                color: #dc2626;
                border: 1px solid #fecaca;
                padding: 0.5rem 1rem;
                border-radius: 9999px;
                font-weight: 600;
                cursor: pointer;
                transition: background 0.2s;
            }

            .btn-refund:hover {
                background-color: #fecaca;
            }


            /* Suggestions */
            .suggestions-section {
                margin-top: 3rem;
            }

            .suggestions-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 1.5rem;
            }

            .suggestions-title {
                font-size: 1.5rem;
                font-weight: 700;
                color: #1e293b;
            }

            .suggestions-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
                gap: 1.5rem;
            }

            .suggestion-card {
                background: white;
                border-radius: 1rem;
                overflow: hidden;
                box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
                transition: all 0.3s;
            }

            .suggestion-card:hover {
                box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15);
                transform: translateY(-4px);
            }

            .suggestion-image {
                width: 100%;
                height: 12rem;
                background: linear-gradient(135deg, #f3f4f6, #d1d5db);
                display: flex;
                align-items: center;
                justify-content: center;
                color: #6b7280;
                font-size: 0.875rem;
                position: relative;
            }

            .suggestion-price {
                position: absolute;
                top: 1rem;
                right: 1rem;
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(10px);
                padding: 0.25rem 0.75rem;
                border-radius: 9999px;
                font-weight: 600;
                color: #1e293b;
                font-size: 0.875rem;
            }

            .suggestion-content {
                padding: 1.5rem;
            }

            .suggestion-name {
                font-weight: 600;
                color: #1e293b;
                margin-bottom: 0.75rem;
                font-size: 1.125rem;
                line-height: 1.4;
            }

            .suggestion-meta {
                color: #64748b;
                font-size: 0.875rem;
                margin-bottom: 1rem;
            }

            .suggestion-meta-item {
                display: flex;
                align-items: center;
                gap: 0.5rem;
                margin-bottom: 0.5rem;
            }

            .suggestion-stats {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 1rem;
                font-size: 0.875rem;
                color: #64748b;
            }

            .suggestion-rating {
                display: flex;
                align-items: center;
                gap: 0.25rem;
            }

            .suggestion-attendees {
                display: flex;
                align-items: center;
                gap: 0.25rem;
            }

            /* Footer */
            .footer {
                background: #1e293b;
                color: white;
                margin-top: 4rem;
            }

            .footer-container {
                max-width: 1280px;
                margin: 0 auto;
                padding: 3rem 1rem;
            }

            .footer-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                gap: 2rem;
            }

            .footer-section h3 {
                font-weight: 600;
                margin-bottom: 1rem;
                color: white;
            }

            .footer-section ul {
                list-style: none;
            }

            .footer-section ul li {
                margin-bottom: 0.5rem;
            }

            .footer-section ul li a {
                color: #94a3b8;
                text-decoration: none;
                transition: color 0.2s;
            }

            .footer-section ul li a:hover {
                color: white;
            }

            .footer-brand {
                font-size: 1.5rem;
                font-weight: 700;
                background: linear-gradient(135deg, #60a5fa, #a78bfa);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                background-clip: text;
                margin-bottom: 1rem;
            }

            .footer-description {
                color: #94a3b8;
                margin-bottom: 1rem;
            }

            .social-links {
                display: flex;
                gap: 0.75rem;
            }

            .social-link {
                width: 2rem;
                height: 2rem;
                background: #334155;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                text-decoration: none;
                transition: all 0.2s;
            }

            .social-link:hover {
                background: #3b82f6;
                transform: translateY(-2px);
            }

            .newsletter-form {
                display: flex;
                gap: 0.5rem;
                margin-bottom: 1rem;
            }

            .newsletter-input {
                flex: 1;
                padding: 0.75rem;
                border: 1px solid #475569;
                border-radius: 0.5rem;
                background: #334155;
                color: white;
            }

            .newsletter-input::placeholder {
                color: #94a3b8;
            }

            .newsletter-btn {
                background: linear-gradient(135deg, #3b82f6, #8b5cf6);
                border: none;
                color: white;
                padding: 0.75rem 1rem;
                border-radius: 0.5rem;
                cursor: pointer;
            }

            .footer-bottom {
                border-top: 1px solid #334155;
                margin-top: 2rem;
                padding-top: 2rem;
                text-align: center;
                color: #94a3b8;
            }

            /* Responsive */
            @media (max-width: 768px) {
                .header-container {
                    flex-direction: column;
                    height: auto;
                    padding: 1rem;
                    gap: 1rem;
                }

                .search-container {
                    margin: 0;
                    max-width: none;
                }

                .filter-tabs {
                    max-width: none;
                }

                .status-filters {
                    flex-direction: column;
                }

                .suggestions-grid {
                    grid-template-columns: 1fr;
                }
            }
        </style>
    </head>
    <body>
        <!-- Header -->
        <header class="header">
            <div class="header-container">
                <div class="logo">MasterTicket</div>

                <div class="search-container">
                    <i class="fas fa-search search-icon"></i>
                    <input type="text" class="search-input" placeholder="Tìm kiếm sự kiện...">
                </div>

                <div class="header-actions">
                    <a href="#" class="btn btn-outline">Tạo sự kiện</a>
                    <a href="#" class="btn btn-primary">Tài khoản</a>
                </div>
            </div>
        </header>

        <!-- Main Content -->
        <main class="main-container">
            <div class="page-header">
                <h1 class="page-title">Vé đã mua</h1>
                <p class="page-subtitle">Quản lý và theo dõi các vé bạn đã mua</p>
            </div>

            <c:choose>
                <c:when test="${not empty orderHistory}">
                    <div class="tickets-list-horizontal">
                        <c:forEach var="order" items="${orderHistory}">
                            <div class="ticket-horizontal-card">
                                <div class="ticket-info">
                                    <h3>${order['eventName']}</h3>
                                    <p><i class="fas fa-map-marker-alt"></i> ${order['physicalLocation']}</p>
                                    <p><i class="fas fa-calendar-alt"></i> ${order['startTime']}</p>
                                    <p>Số lượng vé: <strong>${order['totalQuantity']}</strong></p>
                                    <p>Tổng tiền: <strong>${order['totalAmount']} đ</strong></p>
                                    <p>Ngày đặt: ${order['createdAt']}</p>
                                </div>

                                <div class="ticket-action">
                                    <c:choose>
                                        <c:when test="${order['canRefund'] == true}">
                                            <form method="get" action="${pageContext.request.contextPath}/RefundTicketServlet"
                                                  onsubmit="return confirm('Bạn có chắc muốn hoàn trả vé này không?');"
                                                  class="refund-form">
                                                <input type="hidden" name="orderId" value="${order['orderId']}" />
                                                <button type="submit" class="btn btn-refund">Hoàn trả vé</button>
                                            </form>
                                        </c:when>
                                        <c:otherwise>
                                            <button class="btn btn-refund" disabled style="opacity: 0.5; cursor: not-allowed;">Không thể hoàn vé</button>
                                        </c:otherwise>
                                    </c:choose>
                                    <c:if test="${order['startTime'] lt now}">
                                        <form method="get" action="${pageContext.request.contextPath}/FeedbackServlet" class="feedback-form" style="margin-top: 10px;">
                                            <input type="hidden" name="orderId" value="${order['orderId']}" />
                                            <input type="hidden" name="eventId" value="${order['eventId']}" />
                                            <button type="submit" class="btn btn-feedback"><i class="fas fa-comment"></i> Gửi phản hồi</button>
                                        </form>
                                    </c:if>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>

                <c:otherwise>
                    <div class="empty-state">
                        <div class="empty-icon">
                            <i class="fas fa-ticket-alt"></i>
                        </div>
                        <h3 class="empty-title">Bạn chưa có vé nào</h3>
                        <p class="empty-description">Khám phá các sự kiện thú vị và đặt vé ngay hôm nay!</p>
                        <a href="explore.jsp" class="btn btn-primary">
                            <i class="fas fa-search"></i>
                            Khám phá sự kiện
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </main>


        <!-- Footer -->
        <footer class="footer">
            <div class="footer-container">
                <div class="footer-grid">
                    <div>
                        <div class="footer-brand">MasterTicket</div>
                        <p class="footer-description">Nền tảng đặt vé sự kiện hàng đầu Việt Nam</p>
                        <div class="social-links">
                            <a href="#" class="social-link">
                                <i class="fab fa-facebook-f"></i>
                            </a>
                            <a href="#" class="social-link">
                                <i class="fab fa-instagram"></i>
                            </a>
                            <a href="#" class="social-link">
                                <i class="fab fa-tiktok"></i>
                            </a>
                        </div>
                    </div>

                    <div>
                        <h3>Hỗ trợ khách hàng</h3>
                        <ul>
                            <li><a href="#">Câu hỏi thường gặp</a></li>
                            <li><a href="#">Liên hệ</a></li>
                            <li><a href="#">Chính sách bảo mật</a></li>
                            <li><a href="#">Điều khoản dịch vụ</a></li>
                        </ul>
                        <p style="color: #94a3b8; margin-top: 1rem;">
                            <i class="fas fa-envelope"></i>
                            <a href="mailto:support@masterticket.vn" style="color: #94a3b8;">support@masterticket.vn</a>
                        </p>
                    </div>

                    <div>
                        <h3>Khám phá</h3>
                        <ul>
                            <li><a href="#">Tạo tài khoản</a></li>
                            <li><a href="#">Tin tức</a></li>
                            <li><a href="#">Sự kiện nổi bật</a></li>
                        </ul>
                    </div>

                    <div>
                        <h3>Nhận thông báo sự kiện</h3>
                        <form class="newsletter-form">
                            <input type="email" class="newsletter-input" placeholder="Email của bạn..." required>
                            <button type="submit" class="newsletter-btn">
                                <i class="fas fa-paper-plane"></i>
                            </button>
                        </form>
                        <p style="color: #94a3b8; font-size: 0.875rem;">
                            Ngôn ngữ: 
                            <img src="https://flagcdn.com/w20/vn.png" alt="Vietnamese" style="width: 20px; margin: 0 5px;">
                            <img src="https://flagcdn.com/w20/gb.png" alt="English" style="width: 20px; margin: 0 5px;">
                        </p>
                    </div>
                </div>

                <div class="footer-bottom">
                    <p>&copy; 2024 MasterTicket. Tất cả quyền được bảo lưu.</p>
                </div>
            </div>
        </footer>

        <script>
            // Filter tabs functionality
            document.querySelectorAll('.filter-tab').forEach(tab => {
                tab.addEventListener('click', function () {
                    document.querySelectorAll('.filter-tab').forEach(t => t.classList.remove('active'));
                    this.classList.add('active');
                });
            });

            // Status buttons functionality
            document.querySelectorAll('.status-btn').forEach(btn => {
                btn.addEventListener('click', function () {
                    document.querySelectorAll('.status-btn').forEach(b => b.classList.remove('active'));
                    this.classList.add('active');
                });
            });

            // Search functionality
            document.querySelector('.search-input').addEventListener('input', function () {
                // Add search logic here
                console.log('Searching for:', this.value);
            });
        </script>
    </body>
</html>
