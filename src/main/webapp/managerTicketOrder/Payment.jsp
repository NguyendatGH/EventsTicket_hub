<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
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

                /* Thêm biến màu cho các phần tử UI */
                --white: #ffffff;
                --dark-gray: #333333;
                --light-text-color: #666666;
                --border-color: #e0e0e0;
                --background-light: #f8f8f8;
                --primary-color: #00c713; /* Đổi màu xanh lá cây cho primary */
                --red-coupon: #ff4444; /* Màu đỏ cho tag coupon */
            }

            body {
                font-family: 'Montserrat', sans-serif;
                margin: 0;
                background-color: var(--background-light);
                color: var(--dark-gray); /* Đổi màu chữ body thành dark-gray để phù hợp với nền sáng */
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

            /* Progress Bar */
            .mt-progress-bar {
                display: flex;
                justify-content: center;
                align-items: center;
                background-color: var(--primary-color); /* Sử dụng biến màu */
                padding: 15px 0;
                margin-bottom: 20px;
            }

            .mt-progress-step {
                display: flex;
                align-items: center;
                color: rgba(255, 255, 255, 0.6);
                font-size: 16px;
                font-weight: 500;
            }

            .mt-progress-step i {
                margin-right: 8px;
                font-size: 18px;
            }

            .mt-progress-step-active {
                color: var(--white);
                font-weight: 600;
            }

            .mt-progress-divider {
                width: 80px;
                height: 2px;
                background-color: rgba(255, 255, 255, 0.4);
                margin: 0 15px;
            }

            /* Main Container */
            .mt-main-container {
                display: flex;
                padding: 0 50px 30px;
                gap: 30px;
                align-items: flex-start;
            }

            .mt-main-left {
                flex: 2;
            }

            .mt-main-right {
                flex: 1;
                min-width: 300px;
            }

            /* Event Info */
            .mt-event-info {
                background-color: var(--white);
                padding: 25px;
                border-radius: 8px;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
                margin-bottom: 20px;
            }

            .mt-event-title {
                font-size: 22px;
                font-weight: 600;
                margin-bottom: 15px;
                padding-bottom: 15px;
                border-bottom: 1px dashed var(--border-color);
                color: var(--dark-gray);
            }

            .mt-event-detail div {
                display: flex;
                align-items: flex-start;
                margin-bottom: 10px;
                font-size: 15px;
                color: var(--light-text-color);
                line-height: 1.4;
            }

            .mt-event-detail i {
                margin-right: 10px;
                color: var(--dark-gray);
                font-size: 18px;
                width: 20px;
                text-align: center;
            }

            /* Payment Section */
            .mt-payment-section {
                background-color: var(--white);
                padding: 25px;
                border-radius: 8px;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
                margin-bottom: 20px; /* Thêm margin-bottom để cách biệt với các phần khác */
            }

            .mt-payment-title {
                font-size: 22px;
                font-weight: 600;
                margin-bottom: 10px;
                color: var(--dark-gray);
            }

            .mt-payment-desc {
                font-size: 14px;
                color: var(--light-text-color);
                margin-bottom: 20px;
            }

            .mt-email {
                font-weight: 500;
                color: var(--primary); /* Sử dụng biến primary từ header */
            }

            /* CSS mới cho phần khuyến mãi đã tách */
            .mt-coupon-section {
                background-color: var(--white);
                padding: 25px;
                border-radius: 8px;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
                margin-bottom: 20px; /* Tạo khoảng cách với phần tử bên dưới */
            }

            .mt-coupon-title {
                font-size: 22px;
                font-weight: 600;
                margin-bottom: 15px;
                color: var(--dark-gray);
            }


            .mt-coupon-box {
                display: flex;
                align-items: center;
                gap: 15px;
                /* margin-bottom đã được di chuyển ra mt-coupon-section */
            }

            .mt-coupon-label {
                font-weight: 500;
                color: var(--dark-gray);
                /* Loại bỏ margin-bottom vì nó không còn cần thiết ở đây */
            }

            .mt-coupon-select {
                background-color: var(--background-light);
                color: var(--dark-gray);
                border: 1px solid var(--border-color);
                padding: 8px 15px;
                border-radius: 20px;
                cursor: pointer;
                font-size: 14px;
                font-weight: 500;
                transition: background-color 0.2s;
            }

            .mt-coupon-select:hover {
                background-color: #e8e8e8;
            }

            .mt-coupon-input {
                flex-grow: 1;
                border: none;
                background-color: transparent;
                outline: none;
                font-size: 14px;
                color: var(--dark-gray);
            }

            .mt-coupon-input::placeholder {
                color: var(--light-text-color);
            }

            .mt-payment-methods .mt-methods-label {
                font-weight: 500;
                margin-bottom: 15px;
                color: var(--dark-gray);
            }

            .mt-methods-list {
                background-color: var(--background-light);
                border-radius: 8px;
                padding: 15px;
            }

            .mt-method-item {
                display: flex;
                align-items: center;
                padding: 12px 0;
                border-bottom: 1px solid var(--border-color);
                cursor: pointer;
                font-size: 15px;
                color: var(--dark-gray);
            }

            .mt-method-item:last-child {
                border-bottom: none;
            }

            .mt-method-item input[type="radio"] {
                margin-right: 15px;
                accent-color: var(--primary-color);
                transform: scale(1.2);
            }

            .mt-method-item img {
                height: 25px;
                margin-right: 10px;
                object-fit: contain; /* Ensure images scale correctly */
            }

            .mt-method-item .fa-brands {
                font-size: 30px;
                margin-right: 5px;
                color: var(--dark-gray);
            }

            .mt-coupon-tag {
                background-color: var(--red-coupon);
                color: var(--white);
                padding: 3px 8px;
                border-radius: 4px;
                font-size: 12px;
                font-weight: 600;
                margin-left: 10px;
            }

            /* Right Section - Timer and Ticket Info */
            .mt-timer-box, .mt-ticket-info-box {
                background-color: var(--white);
                padding: 25px;
                border-radius: 8px;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
                margin-bottom: 20px;
                text-align: center;
            }

            .mt-timer-label {
                font-size: 16px;
                color: var(--light-text-color);
                margin-bottom: 15px;
            }

            .mt-timer {
                display: flex;
                justify-content: center;
                align-items: center;
                background-color: #333;
                color: var(--primary-color);
                border-radius: 8px;
                padding: 15px 20px;
                width: fit-content;
                margin: 0 auto 20px;
            }

            .mt-timer-num {
                font-size: 48px;
                font-weight: 700;
                letter-spacing: 2px;
                font-variant-numeric: tabular-nums;
            }

            .mt-timer-colon {
                font-size: 48px;
                font-weight: 700;
                margin: 0 5px;
            }

            .mt-ticket-info-title {
                font-size: 18px;
                font-weight: 600;
                color: var(--dark-gray);
                text-align: left;
                margin-bottom: 15px;
                padding-bottom: 10px;
                border-bottom: 1px dashed var(--border-color);
            }

            .mt-ticket-info-row {
                display: flex;
                justify-content: space-between;
                padding: 8px 0;
                font-size: 15px;
                color: var(--dark-gray);
            }

            .mt-ticket-info-row span:first-child {
                color: var(--light-text-color);
            }

            .mt-ticket-seat {
                font-weight: 600;
                color: var(--primary); /* Sử dụng biến primary từ header */
            }

            .mt-ticket-info-total {
                font-size: 20px;
                font-weight: 700;
                color: var(--primary); /* Sử dụng biến primary từ header */
                padding-top: 15px;
                border-top: 1px dashed var(--border-color);
                margin-top: 15px;
            }

            .mt-btn-pay {
                background-color: var(--primary-color); /* Sử dụng biến màu */
                color: var(--white);
                border: none;
                padding: 12px 25px;
                border-radius: 8px;
                cursor: pointer;
                font-size: 18px;
                font-weight: 600;
                width: 100%;
                margin-top: 20px;
                transition: background-color 0.2s;
            }

            .mt-btn-pay:hover {
                background-color: #00A355;
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
        <div class="mt-progress-bar">
            <div class="mt-progress-step mt-progress-step-active">
                <i class="fa fa-check"></i> Chọn vé
            </div>
            <div class="mt-progress-divider"></div>
            <div class="mt-progress-step mt-progress-step-active">
                <i class="fa fa-check"></i> Thanh toán
            </div>
        </div>
        <div class="mt-main-container">
            <div class="mt-main-left">
                <div class="mt-event-info">
                    <div class="mt-event-title">Nhà Hát Kịch IDECAF: Tấm Cám Đại Chiến</div>
                    <div class="mt-event-detail">
                        <div><i class="fa fa-clock"></i> 19:30, 6 tháng 6, 2025</div>
                        <div><i class="fa fa-location-dot"></i> Tại nhà hát Kịch IDECAF<br> Số 28 Lê Thánh Tôn, Phường Bến Nghé, Quận 1</div>
                    </div>
                </div>

                <div class="mt-payment-section">
                    <div class="mt-payment-title">Thanh toán</div>
                    <div class="mt-payment-desc">Thông tin nhận vé sẽ được gửi đến thư mục vé của tôi tại tài khoản <span class="mt-email">lephuochat@gmail.com</span></div>
                </div>

                <div class="mt-coupon-section">
                    <div class="mt-coupon-title">Mã khuyến mãi</div>
                    <div class="mt-coupon-box">
                        <button class="mt-coupon-select">Chọn khuyến mãi</button>
                        <input class="mt-coupon-input" type="text" placeholder="+ Thêm khuyến mãi"/>
                    </div>
                </div>

                <div class="mt-payment-section mt-payment-methods"> <div class="mt-methods-label">Phương thức thanh toán</div>
                    <div class="mt-methods-list">
                        <label class="mt-method-item"><input type="radio" name="paymethod"> <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/VNPAY_logo.svg/langvi-260px-VNPAY_logo.svg.png" alt="VNPAY logo"> VNPAY/Mobile Banking app</label>
                        <label class="mt-method-item"><input type="radio" name="paymethod"> <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/c/c5/VietQR_Logo.svg/langvi-260px-VietQR_Logo.svg.png" alt="VietQR logo"> VietQR</label>
                        <label class="mt-method-item"><input type="radio" name="paymethod"> <img src="https://upload.wikimedia.org/wikipedia/commons/f/fe/Shopee_logo.png" alt="ShopeePay logo"> ShopeePay <span class="mt-coupon-tag">Coupon</span></label>
                        <label class="mt-method-item"><input type="radio" name="paymethod"> <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/e/e0/MoMo_Logo.svg/langvi-260px-MoMo_Logo.svg.png" alt="MoMo logo"> MoMo</label>
                        <label class="mt-method-item"><input type="radio" name="paymethod"> <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/a/ad/ZaloPay-Logo.wine.svg/langvi-260px-ZaloPay-Logo.wine.svg.png" alt="ZaloPay logo"> ZaloPay</label>
                        <label class="mt-method-item"><input type="radio" name="paymethod"> <i class="fa-brands fa-cc-visa"></i> <i class="fa-brands fa-cc-mastercard"></i> <i class="fa-brands fa-cc-jcb"></i> Credit Card/Debit Card</label>
                    </div>
                </div>
            </div>
            <div class="mt-main-right">
                <div class="mt-timer-box">
                    <div class="mt-timer-label">Hoàn tất đặt vé trong</div>
                    <div class="mt-timer" id="countdown-timer">
                        <span class="mt-timer-num" id="timer-min">10</span>
                        <span class="mt-timer-colon">:</span>
                        <span class="mt-timer-num" id="timer-sec">00</span>
                    </div>
                </div>
                <div class="mt-ticket-info-box">
                    <div class="mt-ticket-info-title">Thông tin đặt vé</div>
                    <div class="mt-ticket-info-row">
                        <span>Loại vé</span>
                        <span>VIP</span>
                    </div>
                    <div class="mt-ticket-info-row">
                        <span>Số lượng</span>
                        <span>01</span>
                    </div>
                    <div class="mt-ticket-info-row">
                        <span></span>
                        <span class="mt-ticket-seat">G-14</span>
                    </div>
                    <div class="mt-ticket-info-row">
                        <span></span>
                        <span>320,000đ</span>
                    </div>
                    <div class="mt-ticket-info-title">Thông tin đơn hàng</div>
                    <div class="mt-ticket-info-row">
                        <span>Tạm tính</span>
                        <span>320,000đ</span>
                    </div>
                    <div class="mt-ticket-info-row mt-ticket-info-total">
                        <span>Tổng tiền</span>
                        <span>320,000đ</span>
                    </div>
                    <button class="mt-btn mt-btn-pay">Thanh toán</button>
                </div>
            </div>
        </div>
    </body>
    <script>
        dayjs.extend(dayjs_plugin_duration);
        const totalSeconds = 10 * 60;
        let remaining = totalSeconds;
        const minEl = document.getElementById('timer-min');
        const secEl = document.getElementById('timer-sec');
        function updateTimer() {
            const duration = dayjs.duration(remaining, 'seconds');
            minEl.textContent = String(duration.minutes()).padStart(2, '0');
            secEl.textContent = String(duration.seconds()).padStart(2, '0');
            if (remaining > 0) {
                remaining--;
            } else {
                minEl.textContent = '00';
                secEl.textContent = '00';
                clearInterval(timerInterval);
                // Optionally: show alert or disable payment button
            }
        }
        updateTimer();
        const timerInterval = setInterval(updateTimer, 1000);
    </script>
</html>