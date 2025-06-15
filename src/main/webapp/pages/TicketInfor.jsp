<%-- File: src/main/webapp/TicketDetail.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%-- Import các lớp Java bạn cần, lưu ý đúng package --%>
<%@ page import="java.util.List" %>
<%@ page import="models.TicketInfor" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>MasterTicket - Chọn vé</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <style>
            /* === BẢNG MÀU ĐỒNG BỘ VỚI TRANG TRƯỚC === */
            :root {
                --primary: #667aff;      /* Màu xanh dương dịu */
                --secondary: #e06bce;    /* Màu hồng/tím nhẹ nhàng */
                --dark-bg: #161b22;      /* Nền tối (hơi ngả xanh) */
                --darker-bg: #0d1117;    /* Nền tối hơn */
                --card-bg: #21262d;      /* Nền cho các thẻ thông tin */
                --border-color: #30363d; /* Màu viền tinh tế */
                --text-light: #e6edf3;   /* Màu chữ trắng ngà */
                --text-muted: #8b949e;   /* Màu chữ phụ */
            }

            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Segoe UI', Arial, sans-serif;
                margin: 0;
                background-color: var(--dark-bg);
                color: var(--text-light);
                display: flex;
                flex-direction: column;
                min-height: 100vh;
            }

            /* === HEADER STYLE (giữ đồng bộ) === */
            .header-container {
                display: flex;
                justify-content: center;
                background-color: var(--darker-bg);
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
                color: var(--primary);
            }

            .actions {
                display: flex;
                align-items: center;
                gap: 20px;
            }

            .link {
                color: var(--text-light);
                text-decoration: none;
                font-weight: 500;
            }

            .account {
                background-color: var(--card-bg);
                border: 1px solid var(--border-color);
                padding: 8px 16px;
                border-radius: 25px;
            }

            /* === BỐ CỤC CHÍNH 2 CỘT === */
            .container {
                max-width: 1300px;
                width: 100%;
                margin: 40px auto;
                padding: 0 40px;
            }

            .back-link {
                color: var(--primary);
                text-decoration: none;
                font-size: 16px;
                display: inline-flex;
                align-items: center;
                gap: 8px;
                margin-bottom: 20px;
                transition: color 0.2s;
            }
            .back-link:hover {
                color: var(--text-light);
            }
            
            .page-title {
                color: var(--text-light);
                margin-bottom: 30px;
                font-size: 28px;
                font-weight: 600;
            }

            .ticket-layout-grid {
                display: grid;
                grid-template-columns: 2fr 1fr;
                gap: 40px;
                align-items: start;
            }

            /* === CỘT CHỌN VÉ BÊN TRÁI === */
            .ticket-selection-area {
                display: flex;
                flex-direction: column;
                gap: 20px; /* Khoảng cách giữa các card vé */
            }

            .ticket-item {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 20px;
                background-color: var(--card-bg);
                border-radius: 8px;
                border: 1px solid var(--border-color);
            }

            .ticket-info {
                display: flex;
                flex-direction: column;
            }

            .ticket-name {
                font-weight: bold;
                font-size: 18px;
                margin-bottom: 5px;
                color: var(--text-light);
            }

            .ticket-price {
                color: var(--text-muted);
                font-size: 16px;
            }

            .ticket-description {
                color: var(--text-muted);
                font-size: 13px;
                margin-top: 8px;
            }

            .quantity-control {
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .quantity-btn {
                background-color: var(--primary);
                color: white;
                border: none;
                border-radius: 50%;
                width: 32px;
                height: 32px;
                font-size: 22px;
                line-height: 32px; /* căn giữa dấu + - */
                text-align: center;
                cursor: pointer;
                transition: background-color 0.2s;
            }
            .quantity-btn:hover {
                background-color: #5566dd;
            }

            .quantity-input {
                background-color: var(--dark-bg);
                color: white;
                border: 1px solid var(--border-color);
                border-radius: 5px;
                width: 50px;
                height: 32px;
                text-align: center;
                font-size: 16px;
                font-weight: bold;
                -moz-appearance: textfield; /* Firefox */
            }
            .quantity-input::-webkit-outer-spin-button,
            .quantity-input::-webkit-inner-spin-button {
                -webkit-appearance: none;
                margin: 0;
            }

            /* === CỘT TÓM TẮT BÊN PHẢI (STICKY) === */
            .summary-panel {
                background-color: var(--card-bg);
                padding: 25px;
                border-radius: 8px;
                border: 1px solid var(--border-color);
                position: sticky;
                top: 40px; /* Dính lại khi cuộn, cách top 40px */
            }

            .event-details {
                margin-bottom: 20px;
                padding-bottom: 20px;
                border-bottom: 1px solid var(--border-color);
            }

            .event-details h3 {
                color: var(--text-light);
                font-size: 20px;
                margin-bottom: 15px;
            }

            .event-details p {
                color: var(--text-muted);
                margin-bottom: 8px;
                font-size: 14px;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .price-summary h4 {
                color: var(--primary);
                margin-bottom: 15px;
                font-size: 18px;
            }
            
            #selected-tickets-summary {
                 min-height: 40px; /* Giữ không gian dù chưa có vé */
            }

            .summary-item {
                display: flex;
                justify-content: space-between;
                margin-bottom: 12px;
                font-size: 15px;
                color: var(--text-muted);
            }
            .summary-item span:last-child {
                color: var(--text-light);
            }
            
            .no-tickets-selected{
                color: var(--text-muted);
                font-style: italic;
            }

            .total-summary {
                font-weight: bold;
                font-size: 1.2em;
                color: var(--text-light);
            }

            #total-price {
                color: var(--primary);
            }
            
            .continue-button {
                background-color: var(--primary);
                color: white;
                border: none;
                padding: 15px;
                border-radius: 5px;
                font-size: 18px;
                font-weight: bold;
                cursor: pointer;
                width: 100%;
                margin-top: 20px;
                transition: background-color 0.2s;
            }

            .continue-button:hover:not(:disabled) {
                 background-color: #5566dd;
            }
            
            .continue-button:disabled {
                background-color: #555;
                color: #999;
                cursor: not-allowed;
            }
        </style>
    </head>
    <body>
        <div class="header-container">
            <header class="header">
                <div class="logo">MasterTicket</div>
                <div class="actions">
                    <a href="#" class="link">Purchased Tickets</a>
                    <div class="account">Account</div>
                </div>
            </header>
        </div>

        <div class="container">
            <a href="${pageContext.request.contextPath}/EventServlet?id=${event.eventID}" class="back-link">
                <i class="fas fa-arrow-left"></i> Trở về trang sự kiện
            </a>
            
            <h1 class="page-title">
                Chọn vé <c:if test="${not empty event}">cho sự kiện: ${event.name}</c:if>
            </h1>

            <div class="ticket-layout-grid">
                <%-- CỘT BÊN TRÁI: DANH SÁCH VÉ --%>
                <main class="ticket-selection-area">
                    <form id="ticketOrderForm" action="${pageContext.request.contextPath}/PaymentServlet" method="POST" style="display: contents;">
                        <c:if test="${not empty event}">
                            <input type="hidden" name="eventId" value="${event.eventID}">
                        </c:if>
                        
                        <c:if test="${not empty listTicket}">
                            <c:forEach var="ticket" items="${listTicket}">
                                <div class="ticket-item">
                                    <div class="ticket-info">
                                        <span class="ticket-name">${ticket.ticketName}</span>
                                        <span class="ticket-price"><fmt:formatNumber value="${ticket.price}" type="currency" currencyCode="VND"/></span>
                                        <c:if test="${not empty ticket.ticketDescription}">
                                            <small class="ticket-description">${ticket.ticketDescription}</small>
                                        </c:if>
                                    </div>
                                    <div class="quantity-control">
                                        <button type="button" class="quantity-btn decrease">-</button>
                                        <input type="text" class="quantity-input" name="quantity_${ticket.ticketInforID}" value="0" readonly 
                                               data-ticket-id-input="${ticket.ticketInforID}"
                                               data-ticket-name="${ticket.ticketName}" 
                                               data-ticket-price="${ticket.price}">
                                        <input type="hidden" name="ticketId" value="${ticket.ticketInforID}"> 
                                        <button type="button" class="quantity-btn increase">+</button>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:if>

                        <c:if test="${empty listTicket}">
                            <p style="text-align: center; color: var(--text-muted);">Sự kiện này hiện chưa có thông tin vé hoặc đã hết vé.</p>
                        </c:if>
                    </form>
                </main>

                <%-- CỘT BÊN PHẢI: TÓM TẮT --%>
                <aside class="summary-panel">
                    <div class="event-details">
                        <c:if test="${not empty event}">
                            <h3>${event.name}</h3>
                            <p><i class="fas fa-calendar-alt"></i> <fmt:formatDate value="${event.startTime}" pattern="HH:mm, dd/MM/yyyy"/></p>
                            <p><i class="fas fa-map-marker-alt"></i> ${event.physicalLocation}</p>
                        </c:if>
                    </div>

                    <div class="price-summary">
                        <h4>Giá vé tạm tính</h4>
                        <div id="selected-tickets-summary">
                            <p class="no-tickets-selected">Vui lòng chọn vé.</p>
                        </div>
                        <hr style="margin: 20px 0; border-color: var(--border-color);">
                        <div class="summary-item total-summary">
                            <span>Tổng cộng:</span>
                            <span id="total-price">0 VND</span>
                        </div>
                    </div>

                    <button type="submit" form="ticketOrderForm" class="continue-button" disabled>Vui lòng chọn vé</button>
                </aside>
            </div>
        </div>

        <script>
            document.addEventListener('DOMContentLoaded', () => {
                const ticketItems = document.querySelectorAll('.ticket-item');
                const continueButton = document.querySelector('.continue-button');
                const summaryContainer = document.getElementById('selected-tickets-summary');
                const totalPriceElement = document.getElementById('total-price');
                const selectedTickets = new Map();

                function formatCurrency(amount) {
                    return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(amount);
                }

                function updateSummaryAndTotal() {
                    // Xóa nội dung tóm tắt cũ
                    summaryContainer.innerHTML = ''; 
                    
                    let totalAmount = 0;
                    let totalQuantity = 0;

                    // Nếu không có vé nào được chọn, hiển thị thông báo
                    if (selectedTickets.size === 0) {
                         summaryContainer.innerHTML = '<p class="no-tickets-selected">Vui lòng chọn vé.</p>';
                    }

                    selectedTickets.forEach((ticket) => {
                        const summaryItem = document.createElement('div');
                        summaryItem.className = 'summary-item';
                        
                        const ticketNameAndQuantity = document.createElement('span');
                        ticketNameAndQuantity.textContent = `${ticket.quantity} x ${ticket.name}`;
                        
                        const ticketSubtotal = document.createElement('span');
                        const subtotal = ticket.quantity * ticket.price;
                        ticketSubtotal.textContent = formatCurrency(subtotal);
                        
                        summaryItem.appendChild(ticketNameAndQuantity);
                        summaryItem.appendChild(ticketSubtotal);
                        summaryContainer.appendChild(summaryItem);
                        
                        totalAmount += subtotal;
                        totalQuantity += ticket.quantity;
                    });
                    
                    totalPriceElement.textContent = formatCurrency(totalAmount);

                    if (totalQuantity > 0) {
                        continueButton.disabled = false;
                        continueButton.textContent = 'Tới trang thanh toán';
                    } else {
                        continueButton.disabled = true;
                        continueButton.textContent = 'Vui lòng chọn vé';
                    }
                }

                ticketItems.forEach(item => {
                    const decreaseBtn = item.querySelector('.decrease');
                    const increaseBtn = item.querySelector('.increase');
                    const quantityInput = item.querySelector('.quantity-input');
                    const ticketId = quantityInput.dataset.ticketIdInput;
                    const ticketName = quantityInput.dataset.ticketName;
                    const ticketPrice = parseFloat(quantityInput.dataset.ticketPrice);

                    decreaseBtn.addEventListener('click', () => {
                        let currentValue = parseInt(quantityInput.value);
                        if (currentValue > 0) {
                            currentValue--;
                            quantityInput.value = currentValue;
                            
                            if (currentValue === 0) {
                                selectedTickets.delete(ticketId);
                            } else {
                                selectedTickets.set(ticketId, { name: ticketName, price: ticketPrice, quantity: currentValue });
                            }
                            updateSummaryAndTotal();
                        }
                    });

                    increaseBtn.addEventListener('click', () => {
                        let currentValue = parseInt(quantityInput.value);
                        // Optional: Add a max limit if needed, e.g., if (currentValue >= 10) return;
                        currentValue++;
                        quantityInput.value = currentValue;
                        selectedTickets.set(ticketId, { name: ticketName, price: ticketPrice, quantity: currentValue });
                        updateSummaryAndTotal();
                    });
                });
                
                // Initial call to set the correct state
                updateSummaryAndTotal();
            });
        </script>
    </body>
</html>