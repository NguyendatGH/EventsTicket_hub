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
                min-height: 100vh;
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
            .header {
                position: sticky;
                top: 0;
                z-index: 100;
                backdrop-filter: blur(20px);
                background: rgba(2, 6, 23, 0.9);
                border-bottom: 1px solid var(--border-color);
                box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
            }

            .header-container {
                max-width: 1400px;
                margin: 0 auto;
                padding: 1rem 2rem;
                display: flex;
                align-items: center;
                justify-content: space-between;
            }

            .logo {
                font-size: 1.75rem;
                font-weight: 700;
                background: var(--gradient-1);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                background-clip: text;
                display: flex;
                align-items: center;
                gap: 0.5rem;
            }

            .search-container {
                flex: 1;
                max-width: 400px;
                margin: 0 2rem;
                position: relative;
            }

            .search-input {
                width: 100%;
                padding: 0.75rem 1rem 0.75rem 3rem;
                border: 1px solid var(--border-color);
                border-radius: 50px;
                background: var(--glass-bg);
                backdrop-filter: blur(10px);
                color: var(--text-light);
                font-size: 0.9rem;
                transition: all 0.3s ease;
            }

            .search-input:focus {
                outline: none;
                border-color: var(--primary);
                box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.1);
            }

            .search-input::placeholder {
                color: var(--text-muted);
            }

            .search-icon {
                position: absolute;
                left: 1rem;
                top: 50%;
                transform: translateY(-50%);
                color: var(--text-muted);
                font-size: 1rem;
            }

            .header-actions {
                display: flex;
                align-items: center;
                gap: 1rem;
            }

            .btn {
                padding: 0.75rem 1.5rem;
                border-radius: 50px;
                font-weight: 600;
                font-size: 0.9rem;
                cursor: pointer;
                transition: all 0.3s ease;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                gap: 0.5rem;
                border: none;
                position: relative;
                overflow: hidden;
            }

            .btn::before {
                content: '';
                position: absolute;
                top: 0;
                left: -100%;
                width: 100%;
                height: 100%;
                background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
                transition: left 0.5s;
            }

            .btn:hover::before {
                left: 100%;
            }

            .btn-outline {
                background: var(--glass-bg);
                backdrop-filter: blur(10px);
                border: 1px solid var(--border-color);
                color: var(--text-light);
            }

            .btn-outline:hover {
                background: var(--card-hover);
                transform: translateY(-2px);
                box-shadow: 0 8px 25px rgba(0, 0, 0, 0.3);
            }

            .btn-primary {
                background: var(--gradient-1);
                color: white;
            }

            .btn-primary:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 25px rgba(99, 102, 241, 0.4);
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

            a.link {
                color: white;
                text-decoration: none;
            }


            /* Enhanced Back Button */
            .back-button-container {
                max-width: 1400px;
                margin: 0 auto;
                padding: 2rem 2rem 0;
                position: relative;
            }

            .back-button {
                background: var(--glass-bg);
                backdrop-filter: blur(20px);
                border: 1px solid var(--border-color);
                color: var(--text-light);
                text-decoration: none;
                padding: 0.75rem 1.5rem;
                border-radius: 50px;
                font-size: 0.95rem;
                font-weight: 500;
                display: inline-flex;
                align-items: center;
                gap: 0.75rem;
                transition: all 0.3s ease;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
                animation: backButtonSlideIn 0.6s ease 0.3s both;
                position: relative;
                overflow: hidden;
            }

            @keyframes backButtonSlideIn {
                from {
                    opacity: 0;
                    transform: translateX(-30px);
                }
                to {
                    opacity: 1;
                    transform: translateX(0);
                }
            }

            .back-button::before {
                content: '';
                position: absolute;
                top: 0;
                left: -100%;
                width: 100%;
                height: 100%;
                background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
                transition: left 0.5s;
            }

            .back-button:hover::before {
                left: 100%;
            }

            .back-button:hover {
                background: var(--card-hover);
                transform: translateY(-2px);
                box-shadow: 0 8px 25px rgba(0, 0, 0, 0.3);
                color: var(--text-light);
                text-decoration: none;
            }

            .back-button i {
                color: var(--primary);
                transition: all 0.3s ease;
            }

            .back-button:hover i {
                transform: translateX(-3px);
                color: var(--accent);
            }

            /* Main Content */
            .main-container {
                max-width: 1400px;
                margin: 0 auto;
                padding: 2rem 2rem 3rem;
            }

            .page-header {
                margin-bottom: 3rem;
                text-align: center;
            }

            .page-title {
                font-size: 3rem;
                font-weight: 700;
                background: var(--gradient-1);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                background-clip: text;
                margin-bottom: 1rem;
                line-height: 1.2;
            }

            .page-subtitle {
                color: var(--text-muted);
                font-size: 1.2rem;
                max-width: 600px;
                margin: 0 auto;
            }

            /* Enhanced Ticket Cards */
            .tickets-list-horizontal {
                display: flex;
                flex-direction: column;
                gap: 2rem;
            }

            .ticket-horizontal-card {
                background: var(--glass-bg);
                backdrop-filter: blur(20px);
                border: 1px solid var(--border-color);
                border-radius: 24px;
                padding: 2rem;
                transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
                position: relative;
                overflow: hidden;
            }

            .ticket-horizontal-card::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                height: 4px;
                background: var(--gradient-1);
            }

            .ticket-horizontal-card:hover {
                transform: translateY(-8px);
                box-shadow: 0 25px 50px rgba(0, 0, 0, 0.3);
                border-color: var(--primary);
            }

            .ticket-card-content {
                display: grid;
                grid-template-columns: 1fr auto;
                gap: 2rem;
                align-items: center;
            }

            .ticket-info h3 {
                font-size: 1.5rem;
                font-weight: 700;
                margin-bottom: 1rem;
                color: var(--text-light);
                background: var(--gradient-1);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                background-clip: text;
            }

            .ticket-meta {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 1rem;
                margin-bottom: 1.5rem;
            }

            .ticket-meta-item {
                display: flex;
                align-items: center;
                gap: 0.75rem;
                padding: 0.75rem;
                background: rgba(255, 255, 255, 0.05);
                border-radius: 12px;
                transition: all 0.3s ease;
            }

            .ticket-meta-item:hover {
                background: rgba(255, 255, 255, 0.1);
                transform: translateX(4px);
            }

            .ticket-meta-item i {
                color: var(--primary);
                font-size: 1.1rem;
                width: 20px;
                text-align: center;
            }

            .ticket-meta-item span {
                color: var(--text-light);
                font-weight: 500;
            }

            .ticket-stats {
                display: flex;
                gap: 2rem;
                margin-top: 1rem;
            }

            .ticket-stat {
                text-align: center;
                padding: 1rem;
                background: rgba(255, 255, 255, 0.05);
                border-radius: 12px;
                min-width: 120px;
            }

            .ticket-stat-value {
                font-size: 1.5rem;
                font-weight: 700;
                color: var(--success);
                margin-bottom: 0.25rem;
            }

            .ticket-stat-label {
                font-size: 0.875rem;
                color: var(--text-muted);
            }

            /* Action Buttons */
            .ticket-actions {
                display: flex;
                flex-direction: column;
                gap: 1rem;
                align-items: flex-end;
            }

            .btn-refund {
                background: linear-gradient(135deg, var(--danger), #dc2626);
                color: white;
                padding: 0.75rem 1.5rem;
                border-radius: 50px;
                border: none;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                display: flex;
                align-items: center;
                gap: 0.5rem;
                position: relative;
                overflow: hidden;
            }

            .btn-refund::before {
                content: '';
                position: absolute;
                top: 0;
                left: -100%;
                width: 100%;
                height: 100%;
                background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
                transition: left 0.5s;
            }

            .btn-refund:hover:not(:disabled)::before {
                left: 100%;
            }

            .btn-refund:hover:not(:disabled) {
                transform: translateY(-2px);
                box-shadow: 0 8px 25px rgba(239, 68, 68, 0.4);
            }

            .btn-refund:disabled {
                opacity: 0.5;
                cursor: not-allowed;
                background: var(--text-muted);
            }

            .btn-refund:disabled::before {
                display: none;
            }

            .btn-feedback {
                background: var(--gradient-2);
                color: white;
                padding: 0.75rem 1.5rem;
                border-radius: 50px;
                border: none;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                display: flex;
                align-items: center;
                gap: 0.5rem;
                position: relative;
                overflow: hidden;
            }

            .btn-feedback::before {
                content: '';
                position: absolute;
                top: 0;
                left: -100%;
                width: 100%;
                height: 100%;
                background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
                transition: left 0.5s;
            }

            .btn-feedback:hover::before {
                left: 100%;
            }

            .btn-feedback:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 25px rgba(6, 182, 212, 0.4);
            }

            /* Empty State */
            .empty-state {
                text-align: center;
                padding: 6rem 2rem;
                background: var(--glass-bg);
                backdrop-filter: blur(20px);
                border: 1px solid var(--border-color);
                border-radius: 24px;
                margin-bottom: 3rem;
            }

            .empty-icon {
                width: 8rem;
                height: 8rem;
                background: var(--gradient-1);
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                margin: 0 auto 2rem;
                font-size: 3rem;
                color: white;
                position: relative;
                overflow: hidden;
            }

            .empty-icon::before {
                content: '';
                position: absolute;
                top: -50%;
                left: -50%;
                width: 200%;
                height: 200%;
                background: linear-gradient(45deg, transparent, rgba(255,255,255,0.3), transparent);
                animation: shimmer 3s infinite;
            }

            @keyframes shimmer {
                0% {
                    transform: translateX(-100%) translateY(-100%) rotate(45deg);
                }
                100% {
                    transform: translateX(100%) translateY(100%) rotate(45deg);
                }
            }

            .empty-title {
                font-size: 2rem;
                font-weight: 700;
                color: var(--text-light);
                margin-bottom: 1rem;
            }

            .empty-description {
                color: var(--text-muted);
                font-size: 1.1rem;
                margin-bottom: 2rem;
                max-width: 500px;
                margin-left: auto;
                margin-right: auto;
            }

            /* Enhanced Footer */
            .footer {
                background: var(--darker-bg);
                border-top: 1px solid var(--border-color);
                margin-top: 6rem;
            }

            .footer-container {
                max-width: 1400px;
                margin: 0 auto;
                padding: 4rem 2rem 2rem;
            }

            .footer-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                gap: 3rem;
                margin-bottom: 3rem;
            }

            .footer-brand {
                font-size: 1.75rem;
                font-weight: 700;
                background: var(--gradient-1);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                background-clip: text;
                margin-bottom: 1rem;
                display: flex;
                align-items: center;
                gap: 0.5rem;
            }

            .footer-description {
                color: var(--text-muted);
                margin-bottom: 1.5rem;
                line-height: 1.6;
            }

            .footer-section h3 {
                font-weight: 600;
                margin-bottom: 1.5rem;
                color: var(--text-light);
                font-size: 1.1rem;
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
                display: flex;
                align-items: center;
                gap: 0.5rem;
            }

            .footer-section ul li a:hover {
                color: var(--primary);
                transform: translateX(4px);
            }

            .social-links {
                display: flex;
                gap: 1rem;
                margin-top: 1rem;
            }

            .social-link {
                width: 3rem;
                height: 3rem;
                background: var(--card-bg);
                border: 1px solid var(--border-color);
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                color: var(--text-light);
                text-decoration: none;
                transition: all 0.3s ease;
                font-size: 1.2rem;
            }

            .social-link:hover {
                background: var(--gradient-1);
                transform: translateY(-3px);
                box-shadow: 0 8px 25px rgba(99, 102, 241, 0.4);
            }

            .newsletter-form {
                display: flex;
                gap: 0.5rem;
                margin-bottom: 1.5rem;
            }

            .newsletter-input {
                flex: 1;
                padding: 0.75rem 1rem;
                border: 1px solid var(--border-color);
                border-radius: 50px;
                background: var(--card-bg);
                color: var(--text-light);
                transition: all 0.3s ease;
            }

            .newsletter-input:focus {
                outline: none;
                border-color: var(--primary);
                box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.1);
            }

            .newsletter-input::placeholder {
                color: var(--text-muted);
            }

            .newsletter-btn {
                background: var(--gradient-1);
                border: none;
                color: white;
                padding: 0.75rem 1.5rem;
                border-radius: 50px;
                cursor: pointer;
                transition: all 0.3s ease;
            }

            .newsletter-btn:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 25px rgba(99, 102, 241, 0.4);
            }

            .footer-bottom {
                border-top: 1px solid var(--border-color);
                padding-top: 2rem;
                text-align: center;
                color: var(--text-muted);
            }

            .language-flags {
                display: flex;
                align-items: center;
                gap: 0.5rem;
                margin-top: 1rem;
            }

            .language-flags img {
                width: 24px;
                height: 18px;
                border-radius: 4px;
                cursor: pointer;
                transition: all 0.3s ease;
            }

            .language-flags img:hover {
                transform: scale(1.1);
            }

            /* Responsive Design */
            @media (max-width: 1024px) {
                .ticket-card-content {
                    grid-template-columns: 1fr;
                    gap: 1.5rem;
                }

                .ticket-actions {
                    align-items: center;
                    flex-direction: row;
                    justify-content: center;
                }

                .page-title {
                    font-size: 2.5rem;
                }
            }

            @media (max-width: 768px) {
                .header-container {
                    flex-direction: column;
                    gap: 1rem;
                    padding: 1rem;
                }

                .search-container {
                    margin: 0;
                    max-width: none;
                    width: 100%;
                }

                .back-button-container {
                    padding: 1rem;
                }

                .main-container {
                    padding: 1rem;
                }

                .page-title {
                    font-size: 2rem;
                }

                .ticket-horizontal-card {
                    padding: 1.5rem;
                }

                .ticket-meta {
                    grid-template-columns: 1fr;
                }

                .ticket-stats {
                    flex-direction: column;
                    gap: 1rem;
                }

                .ticket-actions {
                    flex-direction: column;
                    width: 100%;
                }

                .btn-refund,
                .btn-feedback {
                    width: 100%;
                    justify-content: center;
                }
            }

            /* Loading Animation */
            @keyframes pulse {
                0%, 100% {
                    opacity: 1;
                }
                50% {
                    opacity: 0.5;
                }
            }

            .loading {
                animation: pulse 2s infinite;
            }

            /* Scroll Animations */
            @keyframes fadeInUp {
                from {
                    opacity: 0;
                    transform: translateY(30px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .fade-in-up {
                animation: fadeInUp 0.6s ease forwards;
            }
        </style>
    </head>

    <body>
        <!-- Header -->
        <header class="header">
            <div class="header-container">
                <div class="logo">
                    <i class="fas fa-ticket-alt"></i>
                    MasterTicket
                </div>
                <div class="search-container">
                    <i class="fas fa-search search-icon"></i>
                    <input type="text" class="search-input" placeholder="Tìm kiếm sự kiện, vé đã mua...">
                </div>
                <div class="header-actions">
                    <a href="${pageContext.request.contextPath}/customer/refund-history" class="btn btn-outline">
                        <i class="fas fa-undo-alt"></i>
                        Lịch sử hoàn tiền
                    </a>
                    <a href="#" class="btn btn-outline">
                        <i class="fas fa-plus"></i>
                        Tạo sự kiện
                    </a>
                    <div class="account">
                        <a href="${pageContext.request.contextPath}/updateProfile" class="link">
                            <i class="fas fa-user"></i>
                            Tài khoản
                        </a>
                    </div>
                </div>
            </div>
        </header>

        <!-- Enhanced Back Button -->
        <div class="back-button-container">
            <a href="javascript:history.back()" class="back-button" title="Quay lại trang trước">
                <i class="fas fa-arrow-left"></i>
                <span>Quay lại</span>
            </a>
        </div>

        <!-- Main Content -->
        <main class="main-container">
            <div class="page-header fade-in-up">
                <h1 class="page-title">
                    <i class="fas fa-history"></i>
                    Vé đã mua
                </h1>
                <p class="page-subtitle">Quản lý và theo dõi tất cả các vé bạn đã mua tại MasterTicket</p>
            </div>

            <c:choose>
                <c:when test="${not empty orderHistory}">
                    <div class="tickets-list-horizontal">
                        <c:forEach var="order" items="${orderHistory}" varStatus="status">
                            <div class="ticket-horizontal-card fade-in-up" style="animation-delay: ${status.index * 0.1}s">
                                <div class="ticket-card-content">
                                    <div class="ticket-info">
                                        <h3>
                                            <i class="fas fa-calendar-check"></i>
                                            ${order['eventName']}
                                        </h3>

                                        <div class="ticket-meta">
                                            <div class="ticket-meta-item">
                                                <i class="fas fa-map-marker-alt"></i>
                                                <span>${order['physicalLocation']}</span>
                                            </div>
                                            <div class="ticket-meta-item">
                                                <i class="fas fa-clock"></i>
                                                <span>${order['startTime']}</span>
                                            </div>
                                            <div class="ticket-meta-item">
                                                <i class="fas fa-calendar-plus"></i>
                                                <span>Đặt: ${order['createdAt']}</span>
                                            </div>
                                        </div>

                                        <div class="ticket-stats">
                                            <div class="ticket-stat">
                                                <div class="ticket-stat-value">${order['totalQuantity']}</div>
                                                <div class="ticket-stat-label">Số vé</div>
                                            </div>
                                            <div class="ticket-stat">
                                                <div class="ticket-stat-value">${order['totalAmount']}đ</div>
                                                <div class="ticket-stat-label">Tổng tiền</div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="ticket-actions">
                                        <c:choose>
                                            <c:when test="${order['canRefund'] == true}">
                                                <form method="get" action="${pageContext.request.contextPath}/RefundTicketServlet"
                                                      onsubmit="return confirm('Bạn có chắc muốn hoàn trả vé này không?');">
                                                    <input type="hidden" name="orderId" value="${order['orderId']}" />
                                                    <button type="submit" class="btn-refund">
                                                        <i class="fas fa-undo"></i>
                                                        Hoàn trả vé
                                                    </button>
                                                </form>
                                            </c:when>
                                            <c:otherwise>
                                                <button class="btn-refund" disabled>
                                                    <i class="fas fa-ban"></i>
                                                    Không thể hoàn vé
                                                </button>
                                            </c:otherwise>
                                        </c:choose>

                                        <c:if test="${order['startTime'] lt now}">
                                            <form method="get" action="${pageContext.request.contextPath}/FeedbackServlet">
                                                <input type="hidden" name="orderId" value="${order['orderId']}" />
                                                <input type="hidden" name="eventId" value="${order['eventId']}" />
                                                <button type="submit" class="btn-feedback">
                                                    <i class="fas fa-star"></i>
                                                    Đánh giá sự kiện
                                                </button>
                                            </form>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="empty-state fade-in-up">
                        <div class="empty-icon">
                            <i class="fas fa-ticket-alt"></i>
                        </div>
                        <h3 class="empty-title">Bạn chưa có vé nào</h3>
                        <p class="empty-description">
                            Khám phá hàng ngàn sự kiện thú vị và đặt vé ngay hôm nay để tạo nên những trải nghiệm đáng nhớ!
                        </p>
                        <a href="explore.jsp" class="btn btn-primary">
                            <i class="fas fa-compass"></i>
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
                        <div class="footer-brand">
                            <i class="fas fa-ticket-alt"></i>
                            MasterTicket
                        </div>
                        <p class="footer-description">
                            Nền tảng đặt vé sự kiện hàng đầu Việt Nam, mang đến trải nghiệm giải trí tuyệt vời cho mọi người.
                        </p>
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
                            <a href="#" class="social-link">
                                <i class="fab fa-youtube"></i>
                            </a>
                        </div>
                    </div>

                    <div>
                        <h3><i class="fas fa-headset"></i> Hỗ trợ khách hàng</h3>
                        <ul>
                            <li><a href="#"><i class="fas fa-question-circle"></i> Câu hỏi thường gặp</a></li>
                            <li><a href="#"><i class="fas fa-phone"></i> Liên hệ hỗ trợ</a></li>
                            <li><a href="#"><i class="fas fa-shield-alt"></i> Chính sách bảo mật</a></li>
                            <li><a href="#"><i class="fas fa-file-contract"></i> Điều khoản dịch vụ</a></li>
                        </ul>
                        <p style="color: var(--text-muted); margin-top: 1rem;">
                            <i class="fas fa-envelope" style="color: var(--success);"></i>
                            <a href="mailto:support@masterticket.vn" style="color: var(--text-muted);">
                                support@masterticket.vn
                            </a>
                        </p>
                    </div>

                    <div>
                        <h3><i class="fas fa-compass"></i> Khám phá</h3>
                        <ul>
                            <li><a href="#"><i class="fas fa-user-plus"></i> Tạo tài khoản</a></li>
                            <li><a href="#"><i class="fas fa-newspaper"></i> Tin tức & Blog</a></li>
                            <li><a href="#"><i class="fas fa-fire"></i> Sự kiện hot</a></li>
                            <li><a href="#"><i class="fas fa-calendar-week"></i> Lịch sự kiện</a></li>
                        </ul>
                    </div>

                    <div>
                        <h3><i class="fas fa-bell"></i> Nhận thông báo mới</h3>
                        <p style="color: var(--text-muted); margin-bottom: 1rem; font-size: 0.9rem;">
                            Đăng ký để nhận thông tin về các sự kiện mới nhất và ưu đãi đặc biệt.
                        </p>
                        <form class="newsletter-form">
                            <input type="email" class="newsletter-input" placeholder="Email của bạn..." required>
                            <button type="submit" class="newsletter-btn">
                                <i class="fas fa-paper-plane"></i>
                            </button>
                        </form>

                        <div style="color: var(--text-muted); font-size: 0.9rem;">
                            <i class="fas fa-globe"></i> Ngôn ngữ:
                            <div class="language-flags">
                                <img src="https://flagcdn.com/w20/vn.png" alt="Tiếng Việt" title="Tiếng Việt">
                                <img src="https://flagcdn.com/w20/gb.png" alt="English" title="English">
                            </div>
                        </div>
                    </div>
                </div>

                <div class="footer-bottom">
                    <p>&copy; 2024 MasterTicket. Tất cả quyền được bảo lưu. | Thiết kế với ❤️ tại Việt Nam</p>
                </div>
            </div>
        </footer>

        <script>

            document.querySelector('.search-input').addEventListener('input', function () {
                const searchTerm = this.value.toLowerCase();
                const tickets = document.querySelectorAll('.ticket-horizontal-card');

                tickets.forEach(ticket => {
                    const eventName = ticket.querySelector('h3').textContent.toLowerCase();
                    const location = ticket.querySelector('.ticket-meta-item span').textContent.toLowerCase();

                    if (eventName.includes(searchTerm) || location.includes(searchTerm)) {
                        ticket.style.display = 'block';
                        ticket.classList.add('fade-in-up');
                    } else {
                        ticket.style.display = 'none';
                    }
                });
            });

            const observerOptions = {
                threshold: 0.1,
                rootMargin: '0px 0px -50px 0px'
            };

            const observer = new IntersectionObserver((entries) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        entry.target.classList.add('fade-in-up');
                    }
                });
            }, observerOptions);

            document.querySelectorAll('.ticket-horizontal-card, .empty-state').forEach(el => {
                observer.observe(el);
            });

            document.querySelector('.newsletter-form').addEventListener('submit', function (e) {
                e.preventDefault();
                const email = this.querySelector('.newsletter-input').value;

                alert('Cảm ơn bạn đã đăng ký! Chúng tôi sẽ gửi thông tin sự kiện mới nhất đến email của bạn.');
                this.querySelector('.newsletter-input').value = '';
            });

            document.querySelectorAll('form').forEach(form => {
                form.addEventListener('submit', function () {
                    const button = this.querySelector('button[type="submit"]');
                    if (button && !button.disabled) {
                        button.classList.add('loading');
                        button.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang xử lý...';
                    }
                });
            });

            document.addEventListener('keydown', function (e) {
                if (e.key === 'Escape') {
                    history.back();
                }
            });

            window.addEventListener('scroll', function () {
                const backButton = document.querySelector('.back-button');
                if (window.scrollY > 300) {
                    backButton.style.position = 'fixed';
                    backButton.style.top = '2rem';
                    backButton.style.left = '2rem';
                    backButton.style.zIndex = '1000';
                } else {
                    backButton.style.position = 'static';
                }
            });
        </script>
    </body>
</html>