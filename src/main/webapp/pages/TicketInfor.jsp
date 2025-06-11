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
        <%-- Khuyến nghị: Chuyển toàn bộ CSS sang một file .css riêng và link vào đây --%>
        <%-- Ví dụ: <link rel="stylesheet" href="${pageContext.request.contextPath}/css/ticket-infor-style.css"> --%>
        <style>
            :root {
                --primary: #4a4aff;
                --secondary: #ff4da6;
                --dark-bg: #0f0f1a;
                --text-light: #ffffff;
                --text-muted: #aaaaaa;
                --success-green: #28a745;
            }
            body {
                font-family: 'Montserrat', sans-serif;
                margin: 0;
                background-color: #1a1a1a;
                color: #f0f0f0;
                display: flex;
                flex-direction: column;
                min-height: 100vh;
            }
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
                background-color: #333344;
                padding: 8px 16px;
                border-radius: 25px;
            }
            .container {
                display: flex;
                flex: 1;
            }
            .left-panel {
                width: 200px;
                background-color: #000;
                padding: 30px;
            }
            .back-link {
                color: var(--success-green);
                text-decoration: none;
                font-size: 18px;
                display: flex;
                align-items: center;
                gap: 10px;
            }
            .main-content {
                flex: 1;
                background-color: #000;
                padding: 30px;
                border-left: 1px solid #333;
                border-right: 1px solid #333;
            }
            .section-title {
                color: var(--success-green);
                margin-bottom: 30px;
                font-size: 24px;
            }
            .ticket-selection {
                border-bottom: 1px solid #333;
                padding-bottom: 20px;
                margin-bottom: 20px;
            }
            .ticket-header {
                display: flex;
                justify-content: space-between;
                padding-bottom: 15px;
                border-bottom: 1px solid #333;
                margin-bottom: 15px;
                color: #aaa;
                font-size: 14px;
            }
            .ticket-item {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 15px 0;
                border-bottom: 1px solid #333;
            }
            .ticket-item:last-child {
                border-bottom: none;
            }
            .ticket-info {
                display: flex;
                flex-direction: column;
            }
            .ticket-name {
                font-weight: bold;
                font-size: 18px;
                margin-bottom: 5px;
            }
            .ticket-price {
                color: #bbb;
            }
            .quantity-control {
                display: flex;
                align-items: center;
                gap: 5px;
            }
            .quantity-btn {
                background-color: var(--success-green);
                color: white;
                border: none;
                border-radius: 50%;
                width: 30px;
                height: 30px;
                font-size: 20px;
                display: flex;
                justify-content: center;
                align-items: center;
                cursor: pointer;
            }
            .quantity-input {
                background-color: #333;
                color: white;
                border: 1px solid #555;
                border-radius: 5px;
                width: 40px;
                text-align: center;
                padding: 5px 0;
            }
            .right-panel {
                width: 350px;
                background-color: #222;
                padding: 30px;
                display: flex;
                flex-direction: column;
            }
            .event-details {
                margin-bottom: 30px;
                padding-bottom: 20px;
                border-bottom: 1px solid #444;
            }
            .event-details h3 {
                color: white;
                font-size: 20px;
                margin-bottom: 10px;
            }
            .event-details p {
                color: #aaa;
                margin-bottom: 5px;
                font-size: 14px;
            }
            .price-summary h4 {
                color: var(--success-green);
                margin-bottom: 15px;
                font-size: 18px;
            }
            .summary-item {
                display: flex;
                justify-content: space-between;
                margin-bottom: 10px;
            }
            .continue-button {
                background-color: var(--success-green);
                color: white;
                border: none;
                padding: 15px 20px;
                border-radius: 5px;
                font-size: 18px;
                cursor: pointer;
                margin-top: auto;
            }
            .continue-button:disabled {
                background-color: #555;
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
            <aside class="left-panel">
                <a href="${pageContext.request.contextPath}/EventServlet?id=${event.eventID}" class="back-link">
                    <i class="fas fa-arrow-left"></i> Trở về
                </a>
            </aside>

            <main class="main-content">
                <h2 class="section-title">Chọn vé <c:if test="${not empty event}">cho sự kiện: ${event.name}</c:if></h2>

                <%-- Form sẽ được gửi đến PaymentServlet để chuẩn bị cho trang thanh toán --%>
                <form id="ticketOrderForm" action="${pageContext.request.contextPath}/PaymentServlet" method="POST">
                    <c:if test="${not empty event}">
                        <input type="hidden" name="eventId" value="${event.eventID}">
                    </c:if>

                    <div class="ticket-selection">
                        <div class="ticket-header">
                            <span>Loại vé</span>
                            <span>Số lượng</span>
                        </div>

                        <c:if test="${not empty listTicket}">
                            <c:forEach var="ticket" items="${listTicket}">
                                <div class="ticket-item" data-price="${ticket.price}" data-name="${ticket.ticketName}" data-id="${ticket.ticketInforID}">
                                    <div class="ticket-info">
                                        <span class="ticket-name">${ticket.ticketName}</span>
                                        <span class="ticket-price"><fmt:formatNumber value="${ticket.price}" type="currency" currencyCode="VND"/></span>
                                        <c:if test="${not empty ticket.ticketDescription}">
                                            <small style="color: #aaa; margin-top: 5px;">${ticket.ticketDescription}</small>
                                        </c:if>
                                    </div>
                                    <div class="quantity-control">
                                        <button type="button" class="quantity-btn decrease" data-ticket-id="${ticket.ticketInforID}">-</button>
                                        <input type="text" class="quantity-input" name="quantity_${ticket.ticketInforID}" value="0" readonly 
                                               data-ticket-id-input="${ticket.ticketInforID}"
                                               data-ticket-name="${ticket.ticketName}" 
                                               data-ticket-price="${ticket.price}">
                                        <%-- Input ẩn để gửi ID của tất cả các loại vé có sẵn --%>
                                        <input type="hidden" name="ticketId" value="${ticket.ticketInforID}"> 
                                        <button type="button" class="quantity-btn increase" data-ticket-id="${ticket.ticketInforID}">+</button>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:if>

                        <c:if test="${empty listTicket}">
                            <p style="text-align: center; color: var(--text-muted);">Sự kiện này hiện chưa có thông tin vé hoặc đã hết vé.</p>
                        </c:if>
                    </div>
                </form>
            </main>

            <aside class="right-panel">
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
                        <p class="no-tickets-selected" style="color: var(--text-muted);">Vui lòng chọn vé.</p>
                    </div>
                    <hr style="margin: 10px 0; border-color: #444;">
                    <div class="summary-item" style="font-weight: bold; font-size: 1.1em;">
                        <span>Tổng cộng:</span>
                        <span id="total-price">0 VND</span>
                    </div>
                </div>

                <button type="submit" form="ticketOrderForm" class="continue-button" disabled>Vui lòng chọn vé</button>
            </aside>
        </div>

        <script>
            document.addEventListener('DOMContentLoaded', () => {
                const quantityControls = document.querySelectorAll('.quantity-control');
                const continueButton = document.querySelector('.continue-button');
                const summaryContainer = document.getElementById('selected-tickets-summary');
                const totalPriceElement = document.getElementById('total-price');
                const noTicketsMessage = document.querySelector('.no-tickets-selected');
                const selectedTickets = new Map();

                function formatCurrency(amount) {
                    return new Intl.NumberFormat('vi-VN', {style: 'currency', currency: 'VND'}).format(amount);
                }

                function updateSummaryAndTotal() {
                    summaryContainer.innerHTML = '';
                    let totalAmount = 0;
                    let totalQuantity = 0;

                    selectedTickets.forEach((ticket, ticketId) => {
                        if (ticket.quantity > 0) {
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
                                            }
                                        });

                                        totalPriceElement.textContent = formatCurrency(totalAmount);

                                        if (totalQuantity > 0) {
                                            if (noTicketsMessage)
                                                noTicketsMessage.style.display = 'none';
                                            continueButton.disabled = false;
                                            continueButton.textContent = 'Tới trang thanh toán';
                                        } else {
                                            if (noTicketsMessage)
                                                noTicketsMessage.style.display = 'block';
                                            continueButton.disabled = true;
                                            continueButton.textContent = 'Vui lòng chọn vé';
                                        }
                                    }

                                    quantityControls.forEach(control => {
                                        const decreaseBtn = control.querySelector('.decrease');
                                        const increaseBtn = control.querySelector('.increase');
                                        const quantityInput = control.querySelector('.quantity-input');
                                        const ticketId = quantityInput.dataset.ticketIdInput;
                                        const ticketName = quantityInput.dataset.ticketName;
                                        const ticketPrice = parseFloat(quantityInput.dataset.ticketPrice);

                                        decreaseBtn.addEventListener('click', () => {
                                            let currentValue = parseInt(quantityInput.value);
                                            if (currentValue > 0) {
                                                currentValue--;
                                                quantityInput.value = currentValue;
                                                selectedTickets.set(ticketId, {name: ticketName, price: ticketPrice, quantity: currentValue});
                                                updateSummaryAndTotal();
                                            }
                                        });

                                        increaseBtn.addEventListener('click', () => {
                                            let currentValue = parseInt(quantityInput.value);
                                            currentValue++;
                                            quantityInput.value = currentValue;
                                            selectedTickets.set(ticketId, {name: ticketName, price: ticketPrice, quantity: currentValue});
                                            updateSummaryAndTotal();
                                        });
                                    });
                                });
        </script>
    </body>
</html>