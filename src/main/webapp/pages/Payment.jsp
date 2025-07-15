<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>MasterTicket - Payment</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <script src="https://cdnjs.cloudflare.com/ajax/libs/dayjs/1.11.10/dayjs.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/dayjs/1.11.10/plugin/duration.min.js"></script>

        <style>
            @import url('https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700&display=swap');

            :root {
                --primary: #667aff;
                --secondary: #e06bce;
                --dark-bg: #161b22;
                --darker-bg: #0d1117;
                --card-bg: #21262d;
                --border-color: #30363d;
                --text-light: #e6edf3;
                --text-muted: #8b949e;
                --white: #ffffff;
                --danger: #ff4444;
                --success: #28a745; /* Thêm màu cho thông báo thành công */
            }

            body {
                font-family: 'Montserrat', sans-serif;
                margin: 0;
                background-color: var(--dark-bg);
                color: var(--text-light);
            }

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

            .mt-progress-bar {
                display: flex;
                justify-content: center;
                align-items: center;
                background-color: var(--primary);
                padding: 15px 0;
            }

            .mt-progress-step {
                display: flex;
                align-items: center;
                color: rgba(255, 255, 255, 0.7);
                font-size: 16px;
                font-weight: 500;
            }

            .mt-progress-step i {
                margin-right: 8px;
                font-size: 18px;
                text-align: center;
            }

            .mt-progress-step-active {
                color: var(--white);
                font-weight: 600;
            }

            .mt-progress-divider {
                width: 80px;
                height: 2px;
                background-color: rgba(255, 255, 255, 0.5);
                margin: 0 15px;
            }

            .mt-main-container {
                display: grid;
                grid-template-columns: 2fr 1fr;
                gap: 40px;
                align-items: flex-start;
                max-width: 1300px;
                margin: 40px auto;
                padding: 0 40px;
            }

            .mt-main-left, .mt-main-right {
                display: flex;
                flex-direction: column;
                gap: 25px;
            }

            .mt-main-right {
                position: sticky;
                top: 40px;
            }

            .mt-card {
                background-color: var(--card-bg);
                padding: 25px;
                border-radius: 8px;
                border: 1px solid var(--border-color);
            }

            .mt-card-title {
                font-size: 22px;
                font-weight: 600;
                margin-bottom: 15px;
                padding-bottom: 15px;
                border-bottom: 1px dashed var(--border-color);
                color: var(--text-light);
            }

            .mt-event-detail div {
                display: flex;
                align-items: flex-start;
                margin-bottom: 12px;
                font-size: 15px;
                color: var(--text-muted);
                line-height: 1.5;
            }

            .mt-event-detail i {
                margin-right: 12px;
                color: var(--text-muted);
                font-size: 18px;
                width: 20px;
                text-align: center;
            }

            .mt-payment-desc {
                font-size: 15px;
                color: var(--text-muted);
                line-height: 1.6;
            }

            .mt-email {
                font-weight: 600;
                color: var(--primary);
            }

            .mt-coupon-box {
                display: flex;
                align-items: center;
                gap: 15px;
            }

            .mt-coupon-select {
                background-color: var(--dark-bg);
                color: var(--text-light);
                border: 1px solid var(--border-color);
                padding: 10px 18px;
                border-radius: 20px;
                cursor: pointer;
                font-size: 14px;
                font-weight: 500;
                transition: background-color 0.2s;
            }
            .mt-coupon-select:hover {
                background-color: var(--border-color);
            }

            .mt-coupon-input {
                flex-grow: 1;
                border: none;
                background-color: transparent;
                outline: none;
                font-size: 15px;
                color: var(--text-light);
            }
            .mt-coupon-input::placeholder {
                color: var(--text-muted);
            }

            .mt-timer-label {
                font-size: 16px;
                color: var(--text-muted);
                margin-bottom: 15px;
                text-align: center;
            }

            .mt-timer {
                display: flex;
                justify-content: center;
                align-items: center;
                color: var(--primary);
                padding: 10px;
                width: fit-content;
                margin: 0 auto;
            }

            .mt-timer-num, .mt-timer-colon {
                font-size: 48px;
                font-weight: 700;
                font-variant-numeric: tabular-nums;
            }

            .mt-timer-colon {
                margin: 0 5px;
            }

            .mt-ticket-info-row {
                display: flex;
                justify-content: space-between;
                padding: 10px 0;
                font-size: 15px;
                color: var(--text-light);
            }
            .mt-ticket-info-row span:first-child {
                color: var(--text-muted);
            }

            .mt-ticket-info-total {
                font-size: 20px;
                font-weight: 700;
                padding-top: 15px;
                border-top: 1px dashed var(--border-color);
                margin-top: 15px;
            }
            .mt-ticket-info-total span:last-child{
                color: var(--primary);
            }

            .mt-methods-list {
                background-color: var(--dark-bg);
                border-radius: 8px;
                padding: 10px;
            }

            .mt-method-item {
                display: flex;
                align-items: center;
                padding: 15px;
                border-radius: 6px;
                cursor: pointer;
                font-size: 15px;
                color: var(--text-light);
                transition: background-color 0.2s;
            }
            .mt-method-item:hover {
                background-color: var(--border-color);
            }

            .mt-method-item input[type="radio"] {
                margin-right: 15px;
                accent-color: var(--primary);
                transform: scale(1.2);
            }

            .mt-method-item img {
                height: 25px;
                margin-right: 10px;
                object-fit: contain;
            }

            .mt-btn-pay {
                background-color: var(--primary);
                color: var(--white);
                border: none;
                padding: 15px 25px;
                border-radius: 8px;
                cursor: pointer;
                font-size: 18px;
                font-weight: 600;
                width: 100%;
                margin-top: 10px;
                transition: background-color 0.2s;
            }

            .mt-btn-pay:hover:not(:disabled) {
                background-color: #5566dd;
            }

            .mt-btn-pay:disabled {
                background-color: #555;
                color: #999;
                cursor: not-allowed;
            }
            /* Thêm CSS cho thông báo lỗi */
            .error-message, .success-message {
                padding: 15px;
                margin-top: 20px;
                border-radius: 8px;
                font-weight: 600;
                text-align: center;
                border: 1px solid transparent;
            }
            .error-message {
                background-color: rgba(255, 68, 68, 0.2);
                color: var(--danger);
                border-color: var(--danger);
            }
            .success-message {
                background-color: rgba(40, 167, 69, 0.2);
                color: var(--success);
                border-color: var(--success);
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

        <div class="mt-progress-bar">
            <div class="mt-progress-step mt-progress-step-active">
                <i class="fa fa-check"></i> Chọn vé
            </div>
            <div class="mt-progress-divider"></div>
            <div class="mt-progress-step mt-progress-step-active">
                <i class="fa fa-credit-card"></i> Thanh toán
            </div>
        </div>

        <div class="mt-main-container">
            <div class="mt-main-left">
                <div class="mt-card">
                    <div class="mt-card-title">${sessionScope.currentOrder.event.name}</div>
                    <div class="mt-event-detail">
                        <div><i class="fa fa-clock"></i>
                            <fmt:formatDate value="${sessionScope.currentOrder.event.startTime}" pattern="HH:mm, EEE, dd/MM/yyyy"/>
                        </div>
                        <div><i class="fa fa-location-dot"></i> ${sessionScope.currentOrder.event.physicalLocation}</div>
                    </div>
                </div>

                <div class="mt-card">
                    <div class="mt-card-title">Thanh toán</div>
                    <div class="mt-payment-desc">
                        Thông tin nhận vé sẽ được gửi đến thư mục vé của tôi tại tài khoản
                        <span class="mt-email">${sessionScope.user.email}</span>
                    </div>
                </div>

                <div class="mt-card">
                    <div class="mt-card-title">Mã khuyến mãi</div>
                    <div class="mt-coupon-box">
                        <input id="promoCodeInput" class="mt-coupon-input" type="text" placeholder="Nhập mã khuyến mãi"/>
                        <button type="button" id="applyPromoBtn" class="mt-coupon-select">Áp dụng</button>
                        <div id="promoMessage" style="margin-top: 10px; color: green;"></div>
                        <input type="hidden" name="appliedPromoCode" id="appliedPromoCode"/>
                    </div>
                </div>
            </div>

            <div class="mt-main-right">
                <form id="paymentForm" action="${pageContext.request.contextPath}/ProcessPaymentServlet" method="POST">
                    <div class="mt-card">
                        <div class="mt-timer-label">Hoàn tất đặt vé trong</div>
                        <div class="mt-timer" id="countdown-timer">
                            <span class="mt-timer-num" id="timer-min">10</span>
                            <span class="mt-timer-colon">:</span>
                            <span class="mt-timer-num" id="timer-sec">00</span>
                        </div>
                    </div>

                    <div class="mt-card">
                        <div class="mt-card-title">Thông tin đơn hàng</div>

                        <c:forEach var="item" items="${sessionScope.currentOrder.items}">
                            <div class="mt-ticket-info-row">
                                <span>${item.ticketTypeName} (x${item.quantity})</span>
                                <span>
                                    <fmt:formatNumber value="${item.unitPrice * item.quantity}" type="currency" currencySymbol="đ" groupingUsed="true" maxFractionDigits="0"/>
                                </span>
                            </div>
                        </c:forEach>

                        <div class="mt-ticket-info-row" id="discount-row" style="display: none;">
                            <span>Giảm giá:</span>
                            <span>
                                <span id="discount-amount">-</span>
                                (<span id="discount-percent">0</span>%)
                            </span>
                        </div>

                        <div class="mt-ticket-info-row mt-ticket-info-total" 
                             data-original-amount="${sessionScope.currentOrder.totalAmount}">
                            <span>Tổng tiền</span>
                            <span id="totalAmount">
                                <fmt:formatNumber value="${sessionScope.currentOrder.totalAmount}" type="currency" currencySymbol="đ" groupingUsed="true" maxFractionDigits="0"/>
                            </span>
                        </div>

                    </div>

                    <div class="mt-card">
                        <div class="mt-card-title">Phương thức thanh toán</div>
                        <label class="mt-method-item">
                            <input type="radio" name="paymethod" value="PAYOS" checked required>
                            <img src="../asset/logo/PayOSLogo.png" alt="PayOS logo" style="height: 32px;" />
                            Thanh toán qua PayOS
                        </label>
                    </div>

                    <button type="submit" class="mt-btn-pay">Thanh toán</button>
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
                        paymentButton.textContent = 'Đã hết thời gian';
                    }
                }
            }

            updateTimer();
            const timerInterval = setInterval(updateTimer, 1000);

            let promoAlreadyApplied = false;

            document.getElementById('applyPromoBtn').addEventListener('click', () => {
                const codeInput = document.getElementById('promoCodeInput');
                const msgEl = document.getElementById('promoMessage');
                const rawCode = codeInput.value;

                if (promoAlreadyApplied) {
                    msgEl.style.color = 'orange';
                    msgEl.textContent = '️ Mã đã được áp dụng. Không thể áp dụng lại.';
                    return;
                }

                if (!rawCode || rawCode.trim() === "") {
                    msgEl.style.color = 'red';
                    msgEl.textContent = ' Vui lòng nhập mã khuyến mãi.';
                    return;
                }

                const encodedCode = encodeURIComponent(rawCode.trim());
                console.log(" Gửi mã:", encodedCode);

                fetch('/OnlineSellingTicketEvents/ApplyPromotionServlet?promoCode=' + encodedCode)
                        .then(response => {
                            if (!response.ok)
                                throw new Error("Phản hồi không hợp lệ");
                            return response.json();
                        })
                        .then(data => {
                            console.log(" Response:", data);
                            if (data.valid) {
                                promoAlreadyApplied = true;

                                const original = parseFloat(data.originalTotal);
                                const discount = parseFloat(data.discountAmount);
                                const percent = original > 0 ? Math.round(discount / original * 100) : 0;

                                msgEl.style.color = 'green';
                                msgEl.innerHTML = `Đã áp dụng mã <strong>${rawCode.trim()}</strong>`;


                                document.getElementById('discount-row').style.display = 'flex';
                                document.getElementById('discount-amount').textContent = `- ${data.discountFormatted}`;
                                document.getElementById('discount-percent').textContent = `${percent}%`;
                                document.getElementById('totalAmount').textContent = data.newTotalFormatted;

                                document.getElementById('appliedPromoCode').value = rawCode.trim();
                            } else {
                                msgEl.style.color = 'red';
                                msgEl.textContent = data.message || '❌ Mã khuyến mãi không hợp lệ.';
                            }
                        })
                        .catch(error => {
                            console.error("❌ Lỗi khi gọi API mã khuyến mãi", error);
                            msgEl.style.color = 'red';
                            msgEl.textContent = '❌ Lỗi hệ thống khi áp dụng mã.';
                        });
            });

            // 🔁 Auto-load lại trạng thái nếu đã có mã áp dụng
            window.addEventListener('DOMContentLoaded', () => {
                const appliedCode = document.getElementById('appliedPromoCode').value;
                const msgEl = document.getElementById('promoMessage');
                const totalAmountEl = document.getElementById('totalAmount');
                const discountRow = document.getElementById('discount-row');

                // Lấy tổng tiền gốc từ data attribute trên thẻ chứa tổng tiền
                const totalOriginal = parseFloat(totalAmountEl.parentElement.getAttribute('data-original-amount'));

                // Reset tổng tiền và ẩn phần giảm giá lúc reload trang
                totalAmountEl.textContent = new Intl.NumberFormat('vi-VN', {style: 'currency', currency: 'VND', maximumFractionDigits: 0}).format(totalOriginal);
                discountRow.style.display = 'none';

                if (appliedCode) {
                    promoAlreadyApplied = true;

                    fetch('/OnlineSellingTicketEvents/ApplyPromotionServlet?promoCode=' + encodeURIComponent(appliedCode))
                            .then(response => {
                                if (!response.ok)
                                    throw new Error("Phản hồi không hợp lệ");
                                return response.json();
                            })
                            .then(data => {
                                if (data.valid) {
                                    const original = parseFloat(data.originalTotal);
                                    const discount = parseFloat(data.discountAmount);
                                    const percent = original > 0 ? Math.round(discount / original * 100) : 0;

                                    msgEl.style.color = 'green';
                                    msgEl.innerHTML = `✅ Đã áp dụng mã <strong>${appliedCode}</strong><br/>
                         Giảm: <strong>${data.discountFormatted}</strong> (${percent}%)<br/>
                         Tổng mới: <strong>${data.newTotalFormatted}</strong>`;

                                    discountRow.style.display = 'flex';
                                    document.getElementById('discount-amount').textContent = `- ${data.discountFormatted}`;
                                    document.getElementById('discount-percent').textContent = `${percent}%`;

                                    // Không cập nhật lại tổng tiền ở đây để tránh hiển thị sai khi reload
                                    // totalAmountEl.textContent = data.newTotalFormatted;
                                }
                            })
                            .catch(err => {
                                console.error("❌ Không thể hiển thị mã khuyến mãi khi reload", err);
                            });
                }
            });
        </script>


    </body>



</html>