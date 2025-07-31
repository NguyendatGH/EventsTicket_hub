<%-- File: src/main/webapp/TicketDetail.jsp (Enhanced) --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>MasterTicket - Chọn vé</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
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

            /* Main Container */
            .container {
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

            .page-title {
                font-size: 2.5rem;
                font-weight: 700;
                margin-bottom: 2rem;
                background: var(--gradient-1);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                background-clip: text;
                line-height: 1.2;
            }

            .error-message {
                color: var(--danger);
                text-align: center;
                margin-bottom: 2rem;
                font-weight: 600;
                padding: 1rem 1.5rem;
                background: rgba(239, 68, 68, 0.1);
                border: 1px solid rgba(239, 68, 68, 0.3);
                border-radius: 12px;
                backdrop-filter: blur(10px);
            }

            /* Layout Grid */
            .ticket-layout-grid {
                display: grid;
                grid-template-columns: 2fr 1fr;
                gap: 3rem;
                align-items: start;
            }

            .ticket-selection-area {
                display: flex;
                flex-direction: column;
                gap: 1.5rem;
            }

            /* Enhanced Ticket Items */
            .ticket-item {
                background: var(--glass-bg);
                backdrop-filter: blur(20px);
                border: 1px solid var(--border-color);
                border-radius: 20px;
                padding: 2rem;
                transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
                position: relative;
                overflow: hidden;
            }

            .ticket-item::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                height: 4px;
                background: var(--gradient-1);
            }

            .ticket-item:hover {
                transform: translateY(-4px);
                box-shadow: 0 20px 40px rgba(0, 0, 0, 0.3);
                border-color: var(--primary);
            }

            .ticket-item-content {
                display: flex;
                justify-content: space-between;
                align-items: center;
                gap: 2rem;
            }

            .ticket-info {
                flex: 1;
            }

            .ticket-name {
                font-weight: 700;
                font-size: 1.25rem;
                margin-bottom: 0.5rem;
                color: var(--text-light);
            }

            .ticket-price {
                color: var(--success);
                font-size: 1.1rem;
                font-weight: 600;
                margin-bottom: 0.75rem;
            }

            .ticket-description {
                color: var(--text-muted);
                font-size: 0.9rem;
                line-height: 1.5;
            }

            /* Quantity Controls */
            .quantity-section {
                display: flex;
                flex-direction: column;
                align-items: flex-end;
                gap: 0.75rem;
            }

            .quantity-control {
                display: flex;
                align-items: center;
                gap: 1rem;
                background: rgba(255, 255, 255, 0.05);
                padding: 0.5rem;
                border-radius: 50px;
                border: 1px solid var(--border-color);
            }

            .quantity-btn {
                background: var(--gradient-1);
                color: white;
                border: none;
                border-radius: 50%;
                width: 40px;
                height: 40px;
                font-size: 1.2rem;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                display: flex;
                align-items: center;
                justify-content: center;
            }

            .quantity-btn:hover {
                transform: scale(1.1);
                box-shadow: 0 4px 15px rgba(99, 102, 241, 0.4);
            }

            .quantity-btn:active {
                transform: scale(0.95);
            }

            .quantity-input {
                background: transparent;
                color: var(--text-light);
                border: none;
                width: 60px;
                height: 40px;
                text-align: center;
                font-size: 1.1rem;
                font-weight: 600;
                outline: none;
            }

            .available-quantity-text {
                color: var(--text-muted);
                font-size: 0.85rem;
                display: flex;
                align-items: center;
                gap: 0.5rem;
            }

            .quantity-error-message {
                color: var(--danger);
                font-size: 0.8rem;
                background: rgba(239, 68, 68, 0.1);
                padding: 0.5rem;
                border-radius: 8px;
                border: 1px solid rgba(239, 68, 68, 0.3);
                display: none;
                max-width: 200px;
                text-align: right;
            }

            /* Enhanced Summary Panel */
            .summary-panel {
                background: var(--glass-bg);
                backdrop-filter: blur(20px);
                border: 1px solid var(--border-color);
                border-radius: 24px;
                padding: 2rem;
                position: sticky;
                top: 120px;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            }

            .event-details {
                margin-bottom: 2rem;
                padding-bottom: 2rem;
                border-bottom: 1px solid var(--border-color);
            }

            .event-details h3 {
                color: var(--text-light);
                font-size: 1.5rem;
                font-weight: 700;
                margin-bottom: 1rem;
                background: var(--gradient-1);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                background-clip: text;
            }

            .event-details p {
                color: var(--text-muted);
                margin-bottom: 0.75rem;
                font-size: 0.95rem;
                display: flex;
                align-items: center;
                gap: 0.75rem;
            }

            .event-details i {
                color: var(--primary);
                width: 20px;
                text-align: center;
            }

            .price-summary h4 {
                color: var(--text-light);
                margin-bottom: 1.5rem;
                font-size: 1.25rem;
                font-weight: 600;
                display: flex;
                align-items: center;
                gap: 0.5rem;
            }

            #selected-tickets-summary {
                min-height: 60px;
                margin-bottom: 1.5rem;
            }

            .summary-item {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 1rem;
                padding: 0.75rem;
                background: rgba(255, 255, 255, 0.05);
                border-radius: 12px;
                font-size: 0.95rem;
            }

            .summary-item span:first-child {
                color: var(--text-muted);
            }

            .summary-item span:last-child {
                color: var(--text-light);
                font-weight: 600;
            }

            .no-tickets-selected {
                color: var(--text-muted);
                font-style: italic;
                text-align: center;
                padding: 2rem;
                background: rgba(255, 255, 255, 0.02);
                border-radius: 12px;
                border: 1px dashed var(--border-color);
            }

            .total-summary {
                font-weight: 700;
                font-size: 1.2rem;
                background: rgba(255, 255, 255, 0.1);
                border-radius: 12px;
                padding: 1rem;
                margin: 1.5rem 0;
            }

            .total-summary span:first-child {
                color: var(--text-light) !important;
            }

            #total-price {
                color: var(--success) !important;
                font-size: 1.3rem;
            }

            /* Enhanced Continue Button */
            .continue-button {
                background: var(--gradient-1);
                color: white;
                border: none;
                padding: 1rem 2rem;
                border-radius: 50px;
                font-size: 1.1rem;
                font-weight: 600;
                cursor: pointer;
                width: 100%;
                transition: all 0.3s ease;
                position: relative;
                overflow: hidden;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 0.5rem;
            }

            .continue-button::before {
                content: '';
                position: absolute;
                top: 0;
                left: -100%;
                width: 100%;
                height: 100%;
                background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
                transition: left 0.5s;
            }

            .continue-button:hover:not(:disabled)::before {
                left: 100%;
            }

            .continue-button:hover:not(:disabled) {
                transform: translateY(-2px);
                box-shadow: 0 8px 25px rgba(99, 102, 241, 0.4);
            }

            .continue-button:disabled {
                background: var(--text-muted);
                cursor: not-allowed;
                transform: none;
                box-shadow: none;
            }

            .continue-button:disabled::before {
                display: none;
            }

            /* Responsive Design */
            @media (max-width: 1024px) {
                .ticket-layout-grid {
                    grid-template-columns: 1fr;
                    gap: 2rem;
                }

                .summary-panel {
                    position: static;
                }

                .page-title {
                    font-size: 2rem;
                }
            }

            @media (max-width: 768px) {
                .container {
                    padding: 2rem 1rem;
                }

                .ticket-item {
                    padding: 1.5rem;
                }

                .ticket-item-content {
                    flex-direction: column;
                    align-items: stretch;
                    gap: 1.5rem;
                }

                .quantity-section {
                    align-items: center;
                }

                .page-title {
                    font-size: 1.75rem;
                }

                .header {
                    padding: 1rem;
                }

                .actions {
                    gap: 1rem;
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

            /* Success State */
            .ticket-selected {
                border-color: var(--success) !important;
                box-shadow: 0 0 0 2px rgba(16, 185, 129, 0.2) !important;
            }

            .ticket-selected::before {
                background: linear-gradient(135deg, var(--success), var(--accent)) !important;
            }

            /* Quantity Badge */
            .quantity-badge {
                position: absolute;
                top: -8px;
                right: -8px;
                background: var(--gradient-1);
                color: white;
                border-radius: 50%;
                width: 24px;
                height: 24px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 0.75rem;
                font-weight: 600;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.3);
            }
        </style>
    </head>

    <body>
        <div class="header-container">
            <header class="header">
                <div class="logo">
                    <a href="/OnlineSellingTicketEvents/home" class="logo">MasterTicket</a>                   
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

        <div class="container">
            <a href="${pageContext.request.contextPath}/EventServlet?id=${event.eventID}" class="back-link">
                <i class="fas fa-arrow-left"></i> 
                Trở về trang sự kiện
            </a>

            <h1 class="page-title">
                <i class="fas fa-shopping-cart"></i>
                Chọn vé <c:if test="${not empty event}">cho sự kiện: ${event.name}</c:if>
                </h1>

            <c:if test="${not empty errorMessage}">
                <div class="error-message">
                    <i class="fas fa-exclamation-triangle"></i>
                    ${errorMessage}
                </div>
            </c:if>

            <div class="ticket-layout-grid">
                <main class="ticket-selection-area">
                    <form id="ticketOrderForm" action="${pageContext.request.contextPath}/PaymentServlet" method="POST" style="display: contents;">
                        <c:if test="${not empty event}">
                            <input type="hidden" name="eventId" value="${event.eventID}">
                        </c:if>

                        <c:choose>
                            <c:when test="${not empty listTicket}">
                                <c:forEach var="ticket" items="${listTicket}" varStatus="status">
                                    <div class="ticket-item fade-in-up" style="animation-delay: ${status.index * 0.1}s">
                                        <div class="ticket-item-content">
                                            <div class="ticket-info">
                                                <div class="ticket-name">
                                                    <i class="fas fa-tag"></i>
                                                    ${ticket.ticketName}
                                                </div>
                                                <div class="ticket-price">
                                                    <fmt:formatNumber value="${ticket.price}" type="currency" currencyCode="VND"/>
                                                </div>
                                                <c:if test="${not empty ticket.ticketDescription}">
                                                    <div class="ticket-description">
                                                        ${ticket.ticketDescription}
                                                    </div>
                                                </c:if>
                                            </div>

                                            <div class="quantity-section">
                                                <div class="quantity-control">
                                                    <button type="button" class="quantity-btn decrease" data-ticket-id="${ticket.ticketInfoID}">
                                                        <i class="fas fa-minus"></i>
                                                    </button>
                                                    <input type="text"
                                                           class="quantity-input"
                                                           name="quantity_${ticket.ticketInfoID}"
                                                           value="0" readonly
                                                           data-ticket-id-input="${ticket.ticketInfoID}"
                                                           data-ticket-name="${ticket.ticketName}"
                                                           data-ticket-price="${ticket.price}"
                                                           data-available-quantity="${ticket.availableQuantity}"
                                                           data-max-quantity-per-order="${ticket.maxQuantityPerOrder}">
                                                    <button type="button" class="quantity-btn increase" data-ticket-id="${ticket.ticketInfoID}">
                                                        <i class="fas fa-plus"></i>
                                                    </button>
                                                </div>

                                                <div class="available-quantity-text">
                                                    <i class="fas fa-info-circle"></i>
                                                    Còn lại: <span id="available_${ticket.ticketInfoID}">${ticket.availableQuantity}</span>
                                                </div>

                                                <div class="quantity-error-message" id="error_message_${ticket.ticketInfoID}"></div>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="no-tickets-selected" style="padding: 4rem; text-align: center;">
                                    <i class="fas fa-ticket-alt" style="font-size: 3rem; margin-bottom: 1rem; color: var(--text-muted);"></i>
                                    <p>Sự kiện này hiện chưa có thông tin vé hoặc đã hết vé.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </form>
                </main>

                <aside class="summary-panel fade-in-up" style="animation-delay: 0.3s">
                    <div class="event-details">
                        <c:if test="${not empty event}">
                            <h3>
                                <i class="fas fa-calendar-check"></i>
                                ${event.name}
                            </h3>
                            <p>
                                <i class="fas fa-clock"></i>
                                <fmt:formatDate value="${event.startTime}" pattern="HH:mm, dd/MM/yyyy"/>
                            </p>
                            <p>
                                <i class="fas fa-map-marker-alt"></i>
                                ${event.physicalLocation}
                            </p>
                        </c:if>
                    </div>

                    <div class="price-summary">
                        <h4>
                            <i class="fas fa-receipt"></i>
                            Tóm tắt đơn hàng
                        </h4>
                        <div id="selected-tickets-summary">
                            <div class="no-tickets-selected">
                                <i class="fas fa-shopping-cart"></i>
                                Vui lòng chọn vé
                            </div>
                        </div>

                        <div class="total-summary">
                            <span>Tổng cộng:</span>
                            <span id="total-price">0 VND</span>
                        </div>
                    </div>

                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <button type="submit" form="ticketOrderForm" class="continue-button" disabled>
                                <i class="fas fa-credit-card"></i>
                                Tới trang thanh toán
                            </button>
                        </c:when>
                        <c:otherwise>
                            <c:url var="loginUrl" value="/login">
                                <c:param name="redirect" value="TicketInfoServlet?eventId=${event.eventID}" />
                            </c:url>
                            <button type="button" class="continue-button" onclick="location.href = '${loginUrl}'">
                                <i class="fas fa-sign-in-alt"></i>
                                Đăng nhập để mua vé
                            </button>
                        </c:otherwise>
                    </c:choose>
                </aside>
            </div>
        </div>

        <script>
            document.addEventListener('DOMContentLoaded', () => {
                const ticketOrderForm = document.getElementById('ticketOrderForm');
                const quantityInputs = document.querySelectorAll('.quantity-input');
                const continueButton = document.querySelector('.continue-button');
                const summaryContainer = document.getElementById('selected-tickets-summary');
                const totalPriceElement = document.getElementById('total-price');
                const selectedTickets = new Map();

                function formatCurrency(amount) {
                    return new Intl.NumberFormat('vi-VN', {style: 'currency', currency: 'VND'}).format(amount);
                }

                function updateSummaryAndTotal() {
                    summaryContainer.innerHTML = '';
                    let totalAmount = 0;
                    let totalQuantityOverall = 0;

                    if (selectedTickets.size === 0) {
                        summaryContainer.innerHTML = `
                            <div class="no-tickets-selected">
                                <i class="fas fa-shopping-cart"></i>
                                Vui lòng chọn vé
                            </div>
                        `;
                    } else {
                        selectedTickets.forEach((ticket) => {
                            const summaryItem = document.createElement('div');
                            summaryItem.className = 'summary-item';

                            const ticketNameAndQuantity = document.createElement('span');
                            ticketNameAndQuantity.innerHTML = `<i class="fas fa-ticket-alt"></i> ${ticket.quantity} x ${ticket.name}`;

                            const ticketSubtotal = document.createElement('span');
                            const subtotal = ticket.quantity * ticket.price;
                            ticketSubtotal.textContent = formatCurrency(subtotal);

                            summaryItem.appendChild(ticketNameAndQuantity);
                            summaryItem.appendChild(ticketSubtotal);
                            summaryContainer.appendChild(summaryItem);

                            totalAmount += subtotal;
                            totalQuantityOverall += ticket.quantity;
                        });
                    }

                    totalPriceElement.textContent = formatCurrency(totalAmount);


                    if (continueButton.getAttribute('form') === 'ticketOrderForm') {
                        if (totalQuantityOverall > 0) {
                            continueButton.disabled = false;
                            continueButton.innerHTML = '<i class="fas fa-credit-card"></i> Tới trang thanh toán';
                        } else {
                            continueButton.disabled = true;
                            continueButton.innerHTML = '<i class="fas fa-shopping-cart"></i> Vui lòng chọn vé';
                        }
                    }
                }

                document.querySelectorAll('.ticket-item').forEach(item => {
                    const decreaseBtn = item.querySelector('.decrease');
                    const increaseBtn = item.querySelector('.increase');
                    const quantityInput = item.querySelector('.quantity-input');
                    const errorMessageSpan = item.querySelector('.quantity-error-message');

                    const ticketId = quantityInput.dataset.ticketIdInput;
                    const ticketName = quantityInput.dataset.ticketName;
                    const ticketPrice = parseFloat(quantityInput.dataset.ticketPrice);
                    let availableQuantity = parseInt(quantityInput.dataset.availableQuantity);
                    let maxQuantityPerOrder = parseInt(quantityInput.dataset.maxQuantityPerOrder);

                    const updateQuantity = (newQuantity) => {
                        errorMessageSpan.style.display = 'none';
                        item.classList.remove('ticket-selected');

                        if (isNaN(newQuantity) || newQuantity < 0) {
                            newQuantity = 0;
                        }

                        const effectiveMaxQuantity = Math.min(availableQuantity, maxQuantityPerOrder);
                        if (newQuantity > effectiveMaxQuantity) {
                            newQuantity = effectiveMaxQuantity;
                            errorMessageSpan.innerHTML = `<i class="fas fa-exclamation-triangle"></i> Bạn chỉ có thể mua tối đa ${effectiveMaxQuantity} vé này.`;
                            errorMessageSpan.style.display = 'block';
                        }

                        quantityInput.value = newQuantity;

                        if (newQuantity > 0) {
                            selectedTickets.set(ticketId, {
                                name: ticketName,
                                price: ticketPrice,
                                quantity: newQuantity,
                                availableQuantity: availableQuantity,
                                maxQuantityPerOrder: maxQuantityPerOrder
                            });
                            item.classList.add('ticket-selected');

                            let badge = item.querySelector('.quantity-badge');
                            if (!badge) {
                                badge = document.createElement('div');
                                badge.className = 'quantity-badge';
                                item.style.position = 'relative';
                                item.appendChild(badge);
                            }
                            badge.textContent = newQuantity;
                        } else {
                            selectedTickets.delete(ticketId);
                            const badge = item.querySelector('.quantity-badge');
                            if (badge) {
                                badge.remove();
                            }
                        }

                        updateSummaryAndTotal();
                    };

                    decreaseBtn.addEventListener('click', () => {
                        updateQuantity(parseInt(quantityInput.value) - 1);
                    });

                    increaseBtn.addEventListener('click', () => {
                        updateQuantity(parseInt(quantityInput.value) + 1);
                    });

                    quantityInput.addEventListener('change', () => {
                        updateQuantity(parseInt(quantityInput.value));
                    });
                });

                updateSummaryAndTotal();

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

                document.querySelectorAll('.ticket-item, .summary-panel').forEach(el => {
                    observer.observe(el);
                });
            });
        </script>
    </body>
</html>