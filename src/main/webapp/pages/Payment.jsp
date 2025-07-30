<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>MasterTicket - Thanh toán</title>
                <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
                    rel="stylesheet">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                <script src="https://cdnjs.cloudflare.com/ajax/libs/dayjs/1.11.10/dayjs.min.js"></script>
                <script src="https://cdnjs.cloudflare.com/ajax/libs/dayjs/1.11.10/plugin/duration.min.js"></script>
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

                        0%,
                        100% {
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
                        display: flex;
                        align-items: center;
                        gap: 0.5rem;
                    }

                    .actions {
                        display: flex;
                        align-items: center;
                        gap: 1.5rem;
                    }

                    .link {
                        color: var(--text-light);
                        text-decoration: none;
                        font-weight: 500;
                        padding: 0.5rem 1rem;
                        border-radius: 8px;
                        transition: all 0.3s ease;
                        display: flex;
                        align-items: center;
                        gap: 0.5rem;
                    }

                    .link:hover {
                        background: rgba(255, 255, 255, 0.1);
                        transform: translateY(-1px);
                    }

                    .account {
                        background: var(--glass-bg);
                        backdrop-filter: blur(10px);
                        border: 1px solid var(--border-color);
                        padding: 0.5rem 1rem;
                        border-radius: 50px;
                        font-weight: 500;
                        cursor: pointer;
                        transition: all 0.3s ease;
                        display: flex;
                        align-items: center;
                        gap: 0.5rem;
                    }

                    .account:hover {
                        background: var(--card-hover);
                        transform: translateY(-1px);
                    }

                    /* Enhanced Progress Bar */
                    .mt-progress-bar {
                        background: var(--gradient-1);
                        padding: 1.5rem 0;
                        position: relative;
                        overflow: hidden;
                    }

                    .mt-progress-bar::before {
                        content: '';
                        position: absolute;
                        top: 0;
                        left: 0;
                        right: 0;
                        bottom: 0;
                        background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.1), transparent);
                        animation: shimmer 3s infinite;
                    }

                    @keyframes shimmer {
                        0% {
                            transform: translateX(-100%);
                        }

                        100% {
                            transform: translateX(100%);
                        }
                    }

                    .progress-container {
                        display: flex;
                        justify-content: center;
                        align-items: center;
                        max-width: 600px;
                        margin: 0 auto;
                        position: relative;
                        z-index: 2;
                    }

                    .mt-progress-step {
                        display: flex;
                        align-items: center;
                        color: rgba(255, 255, 255, 0.7);
                        font-size: 1rem;
                        font-weight: 500;
                        padding: 0.75rem 1.5rem;
                        background: rgba(255, 255, 255, 0.1);
                        border-radius: 50px;
                        backdrop-filter: blur(10px);
                        transition: all 0.3s ease;
                    }

                    .mt-progress-step i {
                        margin-right: 0.5rem;
                        font-size: 1.1rem;
                        width: 20px;
                        text-align: center;
                    }

                    .mt-progress-step-active {
                        color: white;
                        font-weight: 600;
                        background: rgba(255, 255, 255, 0.2);
                        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
                    }

                    .mt-progress-divider {
                        width: 80px;
                        height: 2px;
                        background: rgba(255, 255, 255, 0.3);
                        margin: 0 1rem;
                        border-radius: 1px;
                    }

                    /* Enhanced Back Button */
                    .back-button-container {
                        position: relative;
                        max-width: 1400px;
                        margin: 0 auto;
                        padding: 0 2rem;
                    }

                    .back-button {
                        position: absolute;
                        left: 2rem;
                        top: -4rem;
                        background: var(--glass-bg);
                        backdrop-filter: blur(20px);
                        border: 1px solid var(--border-color);
                        color: var(--text-light);
                        text-decoration: none;
                        padding: 0.75rem 1.5rem;
                        border-radius: 50px;
                        font-size: 0.95rem;
                        font-weight: 500;
                        display: flex;
                        align-items: center;
                        gap: 0.75rem;
                        transition: all 0.3s ease;
                        z-index: 10;
                        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
                        animation: backButtonSlideIn 0.6s ease 0.5s both;
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

                    /* Main Container */
                    .mt-main-container {
                        display: grid;
                        grid-template-columns: 2fr 1fr;
                        gap: 3rem;
                        align-items: flex-start;
                        max-width: 1400px;
                        margin: 3rem auto;
                        padding: 0 2rem;
                    }

                    .mt-main-left,
                    .mt-main-right {
                        display: flex;
                        flex-direction: column;
                        gap: 2rem;
                    }

                    .mt-main-right {
                        position: sticky;
                        top: 120px;
                    }

                    /* Enhanced Cards */
                    .mt-card {
                        background: var(--glass-bg);
                        backdrop-filter: blur(20px);
                        border: 1px solid var(--border-color);
                        border-radius: 24px;
                        padding: 2rem;
                        transition: all 0.3s ease;
                        position: relative;
                        overflow: hidden;
                    }

                    .mt-card::before {
                        content: '';
                        position: absolute;
                        top: 0;
                        left: 0;
                        right: 0;
                        height: 4px;
                        background: var(--gradient-1);
                    }

                    .mt-card:hover {
                        transform: translateY(-2px);
                        box-shadow: 0 20px 40px rgba(0, 0, 0, 0.2);
                        border-color: var(--primary);
                    }

                    .mt-card-title {
                        font-size: 1.5rem;
                        font-weight: 700;
                        margin-bottom: 1.5rem;
                        padding-bottom: 1rem;
                        border-bottom: 1px solid var(--border-color);
                        color: var(--text-light);
                        display: flex;
                        align-items: center;
                        gap: 0.75rem;
                    }

                    .mt-card-title i {
                        color: var(--primary);
                    }

                    /* Event Details */
                    .mt-event-detail div {
                        display: flex;
                        align-items: center;
                        margin-bottom: 1rem;
                        font-size: 1rem;
                        color: var(--text-muted);
                        padding: 0.75rem;
                        background: rgba(255, 255, 255, 0.05);
                        border-radius: 12px;
                        transition: all 0.3s ease;
                    }

                    .mt-event-detail div:hover {
                        background: rgba(255, 255, 255, 0.1);
                        transform: translateX(4px);
                    }

                    .mt-event-detail i {
                        margin-right: 1rem;
                        color: var(--primary);
                        font-size: 1.1rem;
                        width: 24px;
                        text-align: center;
                    }

                    /* Payment Description */
                    .mt-payment-desc {
                        font-size: 1rem;
                        color: var(--text-muted);
                        line-height: 1.6;
                        padding: 1.5rem;
                        background: rgba(255, 255, 255, 0.05);
                        border-radius: 16px;
                        border: 1px solid var(--border-color);
                    }

                    .mt-email {
                        font-weight: 600;
                        color: var(--primary);
                        background: rgba(99, 102, 241, 0.1);
                        padding: 0.25rem 0.5rem;
                        border-radius: 6px;
                    }

                    /* Enhanced Coupon Box */
                    .mt-coupon-box {
                        display: flex;
                        align-items: center;
                        gap: 1rem;
                        background: var(--card-bg);
                        border: 1px solid var(--border-color);
                        border-radius: 50px;
                        padding: 0.5rem;
                        transition: all 0.3s ease;
                    }

                    .mt-coupon-box:focus-within {
                        border-color: var(--primary);
                        box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.1);
                    }

                    .mt-coupon-input {
                        flex: 1;
                        border: none;
                        background: transparent;
                        outline: none;
                        font-size: 1rem;
                        color: var(--text-light);
                        padding: 0.75rem 1rem;
                    }

                    .mt-coupon-input::placeholder {
                        color: var(--text-muted);
                    }

                    .mt-coupon-select {
                        background: var(--gradient-1);
                        color: white;
                        border: none;
                        padding: 0.75rem 1.5rem;
                        border-radius: 50px;
                        cursor: pointer;
                        font-size: 0.9rem;
                        font-weight: 600;
                        transition: all 0.3s ease;
                        position: relative;
                        overflow: hidden;
                    }

                    .mt-coupon-select::before {
                        content: '';
                        position: absolute;
                        top: 0;
                        left: -100%;
                        width: 100%;
                        height: 100%;
                        background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
                        transition: left 0.5s;
                    }

                    .mt-coupon-select:hover::before {
                        left: 100%;
                    }

                    .mt-coupon-select:hover {
                        transform: translateY(-2px);
                        box-shadow: 0 8px 25px rgba(99, 102, 241, 0.4);
                    }

                    /* Enhanced Timer */
                    .timer-card {
                        background: var(--gradient-1);
                        color: white;
                        text-align: center;
                        position: relative;
                        overflow: hidden;
                    }

                    .timer-card::before {
                        background: var(--gradient-2) !important;
                    }

                    .mt-timer-label {
                        font-size: 1.1rem;
                        margin-bottom: 1rem;
                        opacity: 0.9;
                    }

                    .mt-timer {
                        display: flex;
                        justify-content: center;
                        align-items: center;
                        gap: 0.5rem;
                        font-family: 'Inter', monospace;
                    }

                    .mt-timer-num {
                        font-size: 3rem;
                        font-weight: 700;
                        background: rgba(255, 255, 255, 0.2);
                        padding: 0.5rem 1rem;
                        border-radius: 16px;
                        backdrop-filter: blur(10px);
                        min-width: 80px;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                    }

                    .mt-timer-colon {
                        font-size: 2rem;
                        font-weight: 700;
                        opacity: 0.8;
                        animation: blink 1s infinite;
                    }

                    @keyframes blink {

                        0%,
                        50% {
                            opacity: 1;
                        }

                        51%,
                        100% {
                            opacity: 0.3;
                        }
                    }

                    /* Order Summary */
                    .mt-ticket-info-row {
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                        padding: 1rem;
                        font-size: 1rem;
                        background: rgba(255, 255, 255, 0.05);
                        border-radius: 12px;
                        margin-bottom: 0.75rem;
                        transition: all 0.3s ease;
                    }

                    .mt-ticket-info-row:hover {
                        background: rgba(255, 255, 255, 0.1);
                    }

                    .mt-ticket-info-row span:first-child {
                        color: var(--text-muted);
                        display: flex;
                        align-items: center;
                        gap: 0.5rem;
                    }

                    .mt-ticket-info-row span:last-child {
                        color: var(--text-light);
                        font-weight: 600;
                    }

                    .mt-ticket-info-total {
                        font-size: 1.25rem;
                        font-weight: 700;
                        background: var(--gradient-1);
                        color: white;
                        border-radius: 16px;
                        margin-top: 1rem;
                    }

                    .mt-ticket-info-total span:last-child {
                        color: white !important;
                        font-size: 1.4rem;
                    }

                    #discount-row {
                        background: rgba(16, 185, 129, 0.1);
                        border: 1px solid rgba(16, 185, 129, 0.3);
                    }

                    #discount-row span:last-child {
                        color: var(--success) !important;
                    }

                    /* Payment Methods */
                    .mt-methods-list {
                        background: var(--card-bg);
                        border-radius: 16px;
                        padding: 1rem;
                        border: 1px solid var(--border-color);
                    }

                    .mt-method-item {
                        display: flex;
                        align-items: center;
                        padding: 1.25rem;
                        border-radius: 12px;
                        cursor: pointer;
                        font-size: 1rem;
                        color: var(--text-light);
                        transition: all 0.3s ease;
                        border: 2px solid transparent;
                    }

                    .mt-method-item:hover {
                        background: var(--card-hover);
                        transform: translateY(-2px);
                        box-shadow: 0 8px 25px rgba(0, 0, 0, 0.2);
                    }

                    .mt-method-item input[type="radio"] {
                        margin-right: 1rem;
                        accent-color: var(--primary);
                        transform: scale(1.3);
                    }

                    .mt-method-item input[type="radio"]:checked+img+span {
                        color: var(--primary);
                        font-weight: 600;
                    }

                    .mt-method-item:has(input[type="radio"]:checked) {
                        background: rgba(99, 102, 241, 0.1);
                        border-color: var(--primary);
                    }

                    .mt-method-item img {
                        height: 32px;
                        margin-right: 1rem;
                        object-fit: contain;
                        border-radius: 8px;
                    }

                    /* Enhanced Pay Button */
                    .mt-btn-pay {
                        background: var(--gradient-1);
                        color: white;
                        border: none;
                        padding: 1.25rem 2rem;
                        border-radius: 50px;
                        cursor: pointer;
                        font-size: 1.1rem;
                        font-weight: 600;
                        width: 100%;
                        margin-top: 1rem;
                        transition: all 0.3s ease;
                        position: relative;
                        overflow: hidden;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        gap: 0.5rem;
                    }

                    .mt-btn-pay::before {
                        content: '';
                        position: absolute;
                        top: 0;
                        left: -100%;
                        width: 100%;
                        height: 100%;
                        background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
                        transition: left 0.5s;
                    }

                    .mt-btn-pay:hover:not(:disabled)::before {
                        left: 100%;
                    }

                    .mt-btn-pay:hover:not(:disabled) {
                        transform: translateY(-3px);
                        box-shadow: 0 12px 30px rgba(99, 102, 241, 0.4);
                    }

                    .mt-btn-pay:disabled {
                        background: var(--text-muted);
                        cursor: not-allowed;
                        transform: none;
                        box-shadow: none;
                    }

                    .mt-btn-pay:disabled::before {
                        display: none;
                    }

                    /* Messages */
                    .error-message,
                    .success-message {
                        padding: 1rem 1.5rem;
                        margin-top: 1rem;
                        border-radius: 12px;
                        font-weight: 600;
                        text-align: center;
                        border: 1px solid;
                        backdrop-filter: blur(10px);
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        gap: 0.5rem;
                    }

                    .error-message {
                        background: rgba(239, 68, 68, 0.1);
                        color: var(--danger);
                        border-color: var(--danger);
                    }

                    .success-message {
                        background: rgba(16, 185, 129, 0.1);
                        color: var(--success);
                        border-color: var(--success);
                    }

                    #promoMessage {
                        margin-top: 1rem;
                        padding: 0.75rem;
                        border-radius: 8px;
                        font-size: 0.9rem;
                        display: none;
                    }

                    #promoMessage:not(:empty) {
                        display: block;
                    }

                    /* Responsive Design */
                    @media (max-width: 1024px) {
                        .mt-main-container {
                            grid-template-columns: 1fr;
                            gap: 2rem;
                        }

                        .mt-main-right {
                            position: static;
                        }
                    }

                    @media (max-width: 768px) {
                        .mt-main-container {
                            padding: 0 1rem;
                            margin: 2rem auto;
                        }

                        .mt-card {
                            padding: 1.5rem;
                        }

                        .header {
                            padding: 1rem;
                        }

                        .progress-container {
                            flex-direction: column;
                            gap: 1rem;
                        }

                        .mt-progress-divider {
                            width: 2px;
                            height: 30px;
                            margin: 0;
                        }

                        .mt-timer-num {
                            font-size: 2rem;
                            min-width: 60px;
                        }

                        .mt-coupon-box {
                            flex-direction: column;
                            border-radius: 16px;
                            padding: 1rem;
                        }

                        .mt-coupon-select {
                            width: 100%;
                            border-radius: 12px;
                        }

                        .back-button-container {
                            padding: 0 1rem;
                        }

                        .back-button {
                            left: 1rem;
                            top: -2.5rem;
                            padding: 0.5rem 1rem;
                            font-size: 0.9rem;
                        }
                    }

                    /* Loading Animation */
                    @keyframes pulse {

                        0%,
                        100% {
                            opacity: 1;
                        }

                        50% {
                            opacity: 0.5;
                        }
                    }

                    .loading {
                        animation: pulse 2s infinite;
                    }

                    /* Fade In Animation */
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
                <div class="header-container">
                    <header class="header">
                        <div class="logo">
                            <i class="fas fa-ticket-alt"></i>
                            MasterTicket
                        </div>
                        <div class="actions">
                            <a href="${pageContext.request.contextPath}/TicketOrderHistoryServlet" class="link">
                                <i class="fas fa-history"></i>
                                Vé đã mua
                            </a>
                            <div class="account">
                                <a href="${pageContext.request.contextPath}/updateProfile" class="link">
                                    <i class="fas fa-user"></i>
                                    Tài khoản
                                </a>
                            </div>
                        </div>
                    </header>
                </div>

                <div class="mt-progress-bar">
                    <div class="progress-container">
                        <div class="mt-progress-step mt-progress-step-active">
                            <i class="fas fa-check"></i>
                            Chọn vé
                        </div>
                        <div class="mt-progress-divider"></div>
                        <div class="mt-progress-step mt-progress-step-active">
                            <i class="fas fa-credit-card"></i>
                            Thanh toán
                        </div>
                    </div>
                </div>

                <!-- Enhanced Back Button -->
                <div class="back-button-container">
                    <a href="javascript:history.back()" class="back-button" title="Quay lại trang trước">
                        <i class="fas fa-arrow-left"></i>
                        <span>Quay lại</span>
                    </a>
                </div>

                <div class="mt-main-container">
                    <div class="mt-main-left">
                        <div class="mt-card fade-in-up">
                            <div class="mt-card-title">
                                <i class="fas fa-calendar-check"></i>
                                ${sessionScope.currentOrder.event.name}
                            </div>
                            <div class="mt-event-detail">
                                <div>
                                    <i class="fas fa-clock"></i>
                                    <fmt:formatDate value="${sessionScope.currentOrder.event.startTime}"
                                        pattern="HH:mm, EEE, dd/MM/yyyy" />
                                </div>
                                <div>
                                    <i class="fas fa-map-marker-alt"></i>
                                    ${sessionScope.currentOrder.event.physicalLocation}
                                </div>
                            </div>
                        </div>

                        <div class="mt-card fade-in-up" style="animation-delay: 0.1s">
                            <div class="mt-card-title">
                                <i class="fas fa-info-circle"></i>
                                Thông tin thanh toán
                            </div>
                            <div class="mt-payment-desc">
                                <i class="fas fa-envelope"></i>
                                Thông tin nhận vé sẽ được gửi đến thư mục vé của tôi tại tài khoản
                                <span class="mt-email">${sessionScope.user.email}</span>
                            </div>
                        </div>

                        <div class="mt-card fade-in-up" style="animation-delay: 0.2s">
                            <div class="mt-card-title">
                                <i class="fas fa-tags"></i>
                                Mã khuyến mãi
                            </div>
                            <div class="mt-coupon-box">
                                <input id="promoCodeInput" class="mt-coupon-input" type="text"
                                    placeholder="Nhập mã khuyến mãi để được giảm giá" />
                                <button type="button" id="applyPromoBtn" class="mt-coupon-select">
                                    <i class="fas fa-check"></i>
                                    Áp dụng
                                </button>
                            </div>
                            <div id="promoMessage"></div>
                            <input type="hidden" name="appliedPromoCode" id="appliedPromoCode" />
                        </div>
                    </div>

                    <div class="mt-main-right">
                        <form id="paymentForm" action="${pageContext.request.contextPath}/ProcessPaymentServlet"
                            method="POST">
                            <div class="mt-card timer-card fade-in-up" style="animation-delay: 0.3s">
                                <div class="mt-timer-label">
                                    <i class="fas fa-hourglass-half"></i>
                                    Hoàn tất đặt vé trong
                                </div>
                                <div class="mt-timer" id="countdown-timer">
                                    <span class="mt-timer-num" id="timer-min">10</span>
                                    <span class="mt-timer-colon">:</span>
                                    <span class="mt-timer-num" id="timer-sec">00</span>
                                </div>
                            </div>

                            <div class="mt-card fade-in-up" style="animation-delay: 0.4s">
                                <div class="mt-card-title">
                                    <i class="fas fa-receipt"></i>
                                    Thông tin đơn hàng
                                </div>
                                <c:forEach var="item" items="${sessionScope.currentOrder.items}">
                                    <div class="mt-ticket-info-row">
                                        <span>
                                            <i class="fas fa-ticket-alt"></i>
                                            ${item.ticketTypeName} (x${item.quantity})
                                        </span>
                                        <span>
                                            <fmt:formatNumber value="${item.unitPrice * item.quantity}" type="currency"
                                                currencySymbol="đ" groupingUsed="true" maxFractionDigits="0" />
                                        </span>
                                    </div>
                                </c:forEach>
                                <!--
                                                <div class="mt-ticket-info-row" id="discount-row" style="display: none;">
                                                    <span>
                                                        <i class="fas fa-percentage"></i>
                                                        Giảm giá:
                                                    </span>
                                                    <span>
                                                        <span id="discount-amount">-</span>
                                                        <span id="discount-extra"></span>
                                                    </span>
                                                </div>-->


                                <div class="mt-ticket-info-row mt-ticket-info-total"
                                    data-original-amount="${sessionScope.currentOrder.totalAmount}">
                                    <span>
                                        <i class="fas fa-calculator"></i>
                                        Tổng tiền
                                    </span>
                                    <span id="totalAmount">
                                        <fmt:formatNumber value="${sessionScope.currentOrder.totalAmount}"
                                            type="currency" currencySymbol="đ" groupingUsed="true"
                                            maxFractionDigits="0" />
                                    </span>
                                </div>
                            </div>

                            <div class="mt-card fade-in-up" style="animation-delay: 0.5s">
                                <div class="mt-card-title">
                                    <i class="fas fa-credit-card"></i>
                                    Phương thức thanh toán
                                </div>
                                <div class="mt-methods-list">
                                    <label class="mt-method-item">
                                        <input type="radio" name="paymethod" value="PAYOS" checked required>
                                        <img src="../asset/logo/PayOSLogo.png" alt="PayOS logo" />
                                        <span>Thanh toán qua PayOS</span>
                                    </label>
                                </div>
                            </div>

                            <button type="submit" class="mt-btn-pay fade-in-up" style="animation-delay: 0.6s">
                                <i class="fas fa-lock"></i>
                                Thanh toán an toàn
                            </button>
                        </form>
                    </div>
                </div>

                <script>

                    dayjs.extend(dayjs_plugin_duration);

                    const totalSeconds = 10 * 60;
                    let remaining = totalSeconds;
                    const minEl = document.getElementById('timer-min');
                    const secEl = document.getElementById('timer-sec');
                    const paymentButton = document.querySelector('.mt-btn-pay');

                    function updateTimer() {
                        const duration = dayjs.duration(remaining, 'seconds');
                        minEl.textContent = String(duration.minutes()).padStart(2, '0');
                        secEl.textContent = String(duration.seconds()).padStart(2, '0');

                        if (remaining > 0) {
                            remaining--;
                        } else {
                            clearInterval(timerInterval);
                            minEl.textContent = '00';
                            secEl.textContent = '00';
                            if (paymentButton) {
                                paymentButton.disabled = true;
                                paymentButton.innerHTML = '<i class="fas fa-clock"></i> Đã hết thời gian';
                            }
                        }
                    }

                    updateTimer();
                    const timerInterval = setInterval(updateTimer, 1000);

                    let promoAlreadyApplied = false;
let previouslyAppliedCode = '';

document.getElementById('applyPromoBtn').addEventListener('click', () => {
    const codeInput = document.getElementById('promoCodeInput');
    const msgEl = document.getElementById('promoMessage');
    const rawCode = codeInput.value.trim().toUpperCase();

    if (!rawCode) {
        msgEl.innerHTML = '<i class="fas fa-exclamation-circle"></i> Vui lòng nhập mã khuyến mãi.';
        styleMessage(msgEl, 'danger');
        return;
    }

    if (promoAlreadyApplied && rawCode === previouslyAppliedCode) {
        const discountAmount = document.getElementById('discount-amount').textContent;
        const discountExtra = document.getElementById('discount-extra').textContent;
        const totalAmount = document.getElementById('totalAmount').textContent;

        msgEl.innerHTML = `
            <i class="fas fa-exclamation-triangle"></i> Mã <strong>${rawCode}</strong> đã được áp dụng trước đó.<br/>
            Giảm: <strong>${discountAmount}</strong>${discountExtra}<br/>
            Tổng mới: <strong>${totalAmount}</strong>
        `;
        styleMessage(msgEl, 'warning');
        document.getElementById('discount-row').style.display = 'flex';
        return;
    }

    const encodedCode = encodeURIComponent(rawCode);
    const applyBtn = document.getElementById('applyPromoBtn');
    applyBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang xử lý...';
    applyBtn.disabled = true;

    fetch('/OnlineSellingTicketEvents/ApplyPromotionServlet?promoCode=' + encodedCode)
        .then(response => {
            if (!response.ok)
                throw new Error("Phản hồi không hợp lệ");
            return response.json();
        })
        .then(data => {
            if (data.valid) {
                promoAlreadyApplied = true;
                previouslyAppliedCode = rawCode;

                const original = parseFloat(data.originalTotal || 0);
                const discount = parseFloat(data.discountAmount || 0);
                const percent = original > 0 ? Math.round(discount / original * 100) : 0;
                const percentText = percent > 0 ? ` (${percent}%)` : '';

                msgEl.innerHTML = `<i class="fas fa-check-circle"></i> Đã áp dụng mã <strong>${rawCode}</strong> thành công!`;
                styleMessage(msgEl, 'success');

                document.getElementById('discount-row').style.display = 'flex';
                document.getElementById('discount-amount').textContent = `- ${data.discountFormatted || ''}`;
                document.getElementById('discount-extra').textContent = percentText;

                document.getElementById('totalAmount').textContent = data.newTotalFormatted || '';
                document.getElementById('appliedPromoCode').value = rawCode;
            } else {
                let msg = 'Mã khuyến mãi không hợp lệ.';
if (typeof data.message === 'string' && data.message.trim() !== '') {
                    msg = data.message;
                }
                msgEl.innerHTML = `<i class="fas fa-times-circle"></i> ${msg}`;
                styleMessage(msgEl, 'danger');
            }
        })
        .catch(error => {
            console.error("Lỗi khi gọi API mã khuyến mãi", error);
            msgEl.innerHTML = '<i class="fas fa-exclamation-triangle"></i> Lỗi hệ thống khi áp dụng mã.';
            styleMessage(msgEl, 'danger');
        })
        .finally(() => {
            applyBtn.innerHTML = '<i class="fas fa-check"></i> Áp dụng';
            applyBtn.disabled = false;
        });
});

window.addEventListener('DOMContentLoaded', () => {
    const appliedCode = document.getElementById('appliedPromoCode').value.trim().toUpperCase();
    const msgEl = document.getElementById('promoMessage');
    const totalAmountEl = document.getElementById('totalAmount');
    const discountRow = document.getElementById('discount-row');
    const discountAmountEl = document.getElementById('discount-amount');
    const discountExtraEl = document.getElementById('discount-extra');

    const totalOriginal = parseFloat(totalAmountEl.parentElement.getAttribute('data-original-amount'));
    totalAmountEl.textContent = new Intl.NumberFormat('vi-VN', {
        style: 'currency',
        currency: 'VND',
        maximumFractionDigits: 0
    }).format(totalOriginal);
    discountRow.style.display = 'none';

    if (appliedCode) {
        promoAlreadyApplied = true;
        previouslyAppliedCode = appliedCode;

        fetch('/OnlineSellingTicketEvents/ApplyPromotionServlet?promoCode=' + encodeURIComponent(appliedCode))
            .then(response => {
                if (!response.ok)
                    throw new Error("Phản hồi không hợp lệ");
                return response.json();
            })
            .then(data => {
                if (data.valid) {
                    const original = parseFloat(data.originalTotal || 0);
                    const discount = parseFloat(data.discountAmount || 0);
                    const percent = original > 0 ? Math.round(discount / original * 100) : 0;
                    const percentText = percent > 0 ? ` (${percent}%)` : '';

                    msgEl.innerHTML = `
                        <i class="fas fa-check-circle"></i> Đã áp dụng mã <strong>${appliedCode}</strong><br/>
                        Giảm: <strong>${data.discountFormatted}</strong>${percentText}<br/>
                        Tổng mới: <strong>${data.newTotalFormatted}</strong>
                    `;
                    styleMessage(msgEl, 'success');

                    discountRow.style.display = 'flex';
                    discountAmountEl.textContent = `- ${data.discountFormatted || ''}`;
                    discountExtraEl.textContent = percentText;
                }
            })
            .catch(err => {
console.error("Không thể hiển thị mã khuyến mãi khi reload", err);
            });
    }
});

function styleMessage(el, type) {
    const colorMap = {
        success: 'rgba(16, 185, 129, 0.1)',
        danger: 'rgba(239, 68, 68, 0.1)',
        warning: 'rgba(245, 158, 11, 0.1)'
    };
    const borderMap = {
        success: '1px solid var(--success)',
        danger: '1px solid var(--danger)',
        warning: '1px solid var(--warning)'
    };
    const textColorMap = {
        success: 'var(--success)',
        danger: 'var(--danger)',
        warning: 'var(--warning)'
    };

    el.style.color = textColorMap[type] || 'black';
    el.style.background = colorMap[type] || '#eee';
    el.style.border = borderMap[type] || '1px solid #ccc';
}
                    const observer = new IntersectionObserver((entries) => {
                        entries.forEach(entry => {
                            if (entry.isIntersecting) {
                                entry.target.classList.add('fade-in-up');
                            }
                        });
                    }, observerOptions);

                    document.querySelectorAll('.mt-card, .mt-btn-pay').forEach(el => {
                        observer.observe(el);
                    });


                    document.addEventListener('keydown', function (e) {
                        if (e.key === 'Escape') {
                            history.back();
                        }
                    });
                </script>
            </body>

            </html>