<%-- 
    Document   : Payment
    Created on : May 26, 2025, 7:18:32 PM
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>MasterTicket - Thanh Toán</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Segoe UI', Arial, sans-serif;
                background: linear-gradient(to bottom, #000015, #1a1a2e);
                color: #ffffff;
                min-height: 100vh;
            }


            /* Header */
            .header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 15px 40px;
                background-color: #0f0f1a;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.3);
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
                background-color: #4a4aff;
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
                background-color: #ff4da6;
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
            .progress-container {
                background: #2dd673;
                padding: 15px 0;
                margin-bottom: 30px;
                border-radius: 15px;
            }

            .progress-steps {
                display: flex;
                justify-content: center;
                align-items: center;
                gap: 40px;
            }

            .step {
                display: flex;
                align-items: center;
                gap: 10px;
                color: #fff;
                font-weight: 500;
            }

            .step-circle {
                width: 30px;
                height: 30px;
                border-radius: 50%;
                background: #fff;
                display: flex;
                align-items: center;
                justify-content: center;
                color: #2dd673;
                font-weight: 600;
            }

            .step.active .step-circle {
                background: #fff;
            }

            /* Main Content */
            .main-content {
                display: grid;
                grid-template-columns: 1fr 400px;
                gap: 30px;
            }

            /* Event Info */
            .event-info {
                background: rgba(255, 255, 255, 0.1);
                backdrop-filter: blur(10px);
                border-radius: 20px;
                padding: 30px;
                margin-bottom: 30px;
            }

            .event-title {
                font-size: 24px;
                font-weight: 700;
                margin-bottom: 20px;
            }

            .event-details {
                display: flex;
                gap: 30px;
                align-items: center;
            }

            .event-image {
                width: 120px;
                height: 120px;
                background: #ddd;
                border-radius: 15px;
                overflow: hidden;
            }

            .event-meta {
                flex: 1;
            }

            .event-meta p {
                margin-bottom: 10px;
                font-size: 16px;
                opacity: 0.9;
            }

            .countdown {
                display: flex;
                gap: 10px;
                margin-top: 20px;
            }

            .countdown-item {
                background: rgba(0, 0, 0, 0.3);
                padding: 15px;
                border-radius: 10px;
                text-align: center;
                min-width: 60px;
            }

            .countdown-number {
                font-size: 24px;
                font-weight: 700;
                display: block;
            }

            .countdown-label {
                font-size: 12px;
                opacity: 0.7;
            }

            /* Payment Section */
            .payment-section {
                background: rgba(255, 255, 255, 0.1);
                backdrop-filter: blur(10px);
                border-radius: 20px;
                padding: 30px;
            }

            .section-title {
                font-size: 20px;
                font-weight: 600;
                margin-bottom: 25px;
            }

            .payment-methods {
                display: grid;
                gap: 15px;
            }

            .payment-method {
                background: rgba(255, 255, 255, 0.05);
                border: 2px solid transparent;
                border-radius: 12px;
                padding: 15px;
                cursor: pointer;
                transition: all 0.3s ease;
                display: flex;
                align-items: center;
                gap: 15px;
            }

            .payment-method:hover {
                background: rgba(255, 255, 255, 0.1);
                border-color: rgba(255, 255, 255, 0.3);
            }

            .payment-method.selected {
                border-color: #2dd673;
                background: rgba(45, 214, 115, 0.1);
            }

            .payment-icon {
                width: 40px;
                height: 40px;
                background: #fff;
                border-radius: 8px;
                display: flex;
                align-items: center;
                justify-content: center;
            }

            .payment-name {
                font-weight: 500;
            }

            .coupon-section {
                margin-top: 30px;
                padding-top: 20px;
                border-top: 1px solid rgba(255, 255, 255, 0.1);
            }

            .coupon-input {
                display: flex;
                gap: 10px;
                margin-top: 15px;
            }

            .coupon-input input {
                flex: 1;
                padding: 12px 15px;
                border: 1px solid rgba(255, 255, 255, 0.3);
                border-radius: 8px;
                background: rgba(255, 255, 255, 0.1);
                color: #fff;
                outline: none;
            }

            .coupon-input button {
                padding: 12px 20px;
                background: #2dd673;
                color: #fff;
                border: none;
                border-radius: 8px;
                cursor: pointer;
                font-weight: 500;
            }

            /* Order Summary */
            .order-summary {
                background: rgba(255, 255, 255, 0.95);
                color: #333;
                border-radius: 20px;
                padding: 30px;
                height: fit-content;
                position: sticky;
                top: 20px;
            }

            .summary-title {
                font-size: 18px;
                font-weight: 700;
                margin-bottom: 20px;
                color: #333;
            }

            .ticket-info {
                background: #f8f9fa;
                padding: 20px;
                border-radius: 12px;
                margin-bottom: 20px;
            }

            .ticket-type {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 10px;
            }

            .ticket-details {
                display: grid;
                grid-template-columns: 1fr 1fr 1fr;
                gap: 10px;
                font-size: 14px;
                color: #666;
            }

            .price-breakdown {
                margin-top: 20px;
            }

            .price-item {
                display: flex;
                justify-content: space-between;
                margin-bottom: 10px;
                font-size: 14px;
            }

            .total-price {
                display: flex;
                justify-content: space-between;
                font-size: 18px;
                font-weight: 700;
                color: #2dd673;
                padding-top: 15px;
                border-top: 2px solid #e9ecef;
                margin-top: 15px;
            }

            .checkout-btn {
                width: 100%;
                padding: 15px;
                background: #2dd673;
                color: #fff;
                border: none;
                border-radius: 12px;
                font-size: 16px;
                font-weight: 600;
                cursor: pointer;
                margin-top: 20px;
                transition: all 0.3s ease;
            }

            .checkout-btn:hover {
                background: #25b663;
                transform: translateY(-2px);
            }

            .email-info {
                font-size: 12px;
                color: #666;
                text-align: center;
                margin-top: 15px;
                line-height: 1.4;
            }

            .radio-button {
                width: 20px;
                height: 20px;
                border-radius: 50%;
                border: 2px solid rgba(255, 255, 255, 0.5);
                position: relative;
            }

            .radio-button.selected {
                border-color: #2dd673;
            }

            .radio-button.selected::after {
                content: '';
                width: 10px;
                height: 10px;
                background: #2dd673;
                border-radius: 50%;
                position: absolute;
                top: 50%;
                left: 50%;
                transform: translate(-50%, -50%);
            }

            /*Footer*/
            .footer {
                background: linear-gradient(to right, #2c2c54, #1e1e2f, #0f0f1c);
                padding: 30px 50px;
                color: white;
                border-top: 3px solid #00f0ff;
            }

            .footer-container {
                display: flex;
                justify-content: space-between;
                flex-wrap: wrap;
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

            .footer-section ul li a {
                text-decoration: none;
                color: #aaa;
                transition: 0.3s;
            }

            .footer-section ul li a:hover {
                color: #fff;
            }

            .footer-section p,
            .footer-section a {
                color: #aaa;
                margin: 5px 0;
                text-decoration: none;
            }

            .footer-section li {
                padding: 5px 0px 5px 0px;
            }


            .footer-section a:hover {
                color: #fff;
            }

            .subscribe-box {
                display: flex;
                align-items: center;
                border: 2px solid #6f42c1;
                border-radius: 8px;
                padding: 5px 10px;
                background: #000;
                margin-bottom: 15px;
                gap: 8px;
                flex-wrap: wrap;
            }

            .subscribe-box input {
                flex: 1;
                border: none;
                background: transparent;
                color: white;
                padding: 5px;
                outline: none;
            }

            .subscribe-box button {
                background: transparent;
                border: none;
                color: limegreen;
                cursor: pointer;
                font-size: 15px;
            }

            .submit-btn {
                padding: 5px 12px;
                background: #6f42c1;
                border: none;
                border-radius: 5px;
                color: white;
                cursor: pointer;
                font-weight: bold;
                transition: background 0.3s;
            }

            .submit-btn:hover {
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

            @media (max-width: 768px) {
                .main-content {
                    grid-template-columns: 1fr;
                    gap: 20px;
                }

                .search-box {
                    min-width: 200px;
                }

                .header {
                    flex-direction: column;
                    gap: 20px;
                }

                .event-details {
                    flex-direction: column;
                    text-align: center;
                }
            }
        </style>
    </head>
    <body>
        <div class="container">
            <!-- Header -->
            <header class="header">
                <div class="logo">MasterTicket</div>
                <div class="search">
                    <input type="text" placeholder="Bạn tìm gì hôm nay?">
                    <button>Tìm kiếm</button>
                </div>
                <div class="actions">
                    <button class="primary-btn">Tạo sự kiện</button>
                    <a href="#" class="link">Vé đã mua</a>
                    <div class="account">Tài khoản</div>
                </div>
            </header>

            <!-- Progress Bar -->
            <div class="progress-container">
                <div class="progress-steps">
                    <div class="step">
                        <div class="step-circle">1</div>
                        <span>Chọn vé</span>
                    </div>
                    <div class="step active">
                        <div class="step-circle">2</div>
                        <span>Thanh toán</span>
                    </div>
                </div>
            </div>

            <div class="main-content">
                <!-- Left Column -->
                <div class="left-column">
                    <!-- Event Info -->
                    <div class="event-info">
                        <h1 class="event-title">Nhà Hát Kịch IDECAF: Tấm Cám Đại Chiến</h1>
                        <div class="event-details">
                            <div class="event-image"></div>
                            <div class="event-meta">
                                <p><strong>📅 19:30, 6 tháng 6, 2025</strong></p>
                                <p>📍 Tại nhà Hát Kịch IDECAF Số 28 Lê Thánh Tôn, Phường Bến Nghé, Quận 1</p>
                                <p>🎫 Ghế: G-14 | Hạng VIP</p>
                            </div>
                        </div>
                        <div class="countdown">
                            <div class="countdown-item">
                                <span class="countdown-number">10</span>
                                <span class="countdown-label">phút</span>
                            </div>
                            <div class="countdown-item">
                                <span class="countdown-number">00</span>
                                <span class="countdown-label">giây</span>
                            </div>
                        </div>
                    </div>

                    <!-- Payment Methods -->
                    <div class="payment-section">
                        <h2 class="section-title">Phương thức thanh toán</h2>
                        <div class="payment-methods">
                            <div class="payment-method selected" onclick="selectPayment(this)">
                                <div class="radio-button selected"></div>
                                <div class="payment-icon">🏦</div>
                                <div class="payment-name">VNPAY/Mobile Banking app</div>
                            </div>
                            <div class="payment-method" onclick="selectPayment(this)">
                                <div class="radio-button"></div>
                                <div class="payment-icon">📱</div>
                                <div class="payment-name">VietQR</div>
                            </div>
                            <div class="payment-method" onclick="selectPayment(this)">
                                <div class="radio-button"></div>
                                <div class="payment-icon">🛒</div>
                                <div class="payment-name">ShopeePay</div>
                            </div>
                            <div class="payment-method" onclick="selectPayment(this)">
                                <div class="radio-button"></div>
                                <div class="payment-icon">💰</div>
                                <div class="payment-name">MoMo</div>
                            </div>
                            <div class="payment-method" onclick="selectPayment(this)">
                                <div class="radio-button"></div>
                                <div class="payment-icon">⚡</div>
                                <div class="payment-name">Zalopay</div>
                            </div>
                            <div class="payment-method" onclick="selectPayment(this)">
                                <div class="radio-button"></div>
                                <div class="payment-icon">💳</div>
                                <div class="payment-name">Credit Card/Debit Card</div>
                            </div>
                        </div>

                        <div class="coupon-section">
                            <h3 class="section-title">Mã khuyến mãi</h3>
                            <p style="opacity: 0.8; margin-bottom: 10px;">Xem và chọn ưu đãi phù hợp ở mục "Mã khuyến mãi"</p>
                            <div class="coupon-input">
                                <input type="text" placeholder="Nhập mã khuyến mãi">
                                <button>Áp dụng</button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Right Column - Order Summary -->
                <div class="order-summary">
                    <h3 class="summary-title">Thông tin đơn hàng</h3>

                    <div class="ticket-info">
                        <div class="ticket-type">
                            <span><strong>Thông tin đặt vé</strong></span>
                        </div>
                        <div class="ticket-details">
                            <div>
                                <strong>Loại vé</strong><br>
                                <span>Hạng VIP</span>
                            </div>
                            <div>
                                <strong>Số lượng</strong><br>
                                <span>01</span>
                            </div>
                            <div>
                                <strong>Ghế</strong><br>
                                <span>G-14</span>
                            </div>
                        </div>
                    </div>

                    <div class="price-breakdown">
                        <div class="price-item">
                            <span>Tạm tính</span>
                            <span>320,000đ</span>
                        </div>
                        <div class="price-item">
                            <span>Phí dịch vụ</span>
                            <span>0đ</span>
                        </div>
                        <div class="total-price">
                            <span>Tổng tiền</span>
                            <span>320,000đ</span>
                        </div>
                    </div>

                    <button class="checkout-btn" onclick="processPayment()">Thanh toán</button>

                    <div class="email-info">
                        Thông tin nhận vé sẽ được gửi đến thư mục vé của tôi qua tài khoản<br>
                        <strong>"lephuochat@gmail.com"</strong>
                    </div>
                </div>
            </div>
        </div>


        <footer class="footer">
            <div class="footer-container">
                <div class="footer-section">
                    <h3>Customer Services</h3>
                    <ul>
                        <li><a href="#">FAQS</a></li>
                        <li><a href="#">Contact us</a></li>
                        <li><a href="#">Pricy Policy</a></li>
                        <li><a href="#">Terms of Service</a></li>
                    </ul>
                    <p>Email:</p>
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
                        <i class="fas fa-envelope"></i>
                        <input type="email" placeholder="Your email..." required />
                        <button type="submit"><i class="fas fa-paper-plane"></i></button>
                        <button type="submit" class="submit-btn">Submit</button>
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
                            <!--<img src="https://static.cdninstagram.com/rsrc.php/v3/yS/r/fnFD6YDgZ3X.png" alt="Threads" />-->
                            <img src="https://cdn-icons-png.flaticon.com/512/3046/3046120.png" alt="TikTok" />
                        </div>
                    </div>

                </div>
            </div>
        </footer>

        <script>
            function selectPayment(element) {
                // Remove selected class from all methods
                document.querySelectorAll('.payment-method').forEach(method => {
                    method.classList.remove('selected');
                    method.querySelector('.radio-button').classList.remove('selected');
                });

                // Add selected class to clicked method
                element.classList.add('selected');
                element.querySelector('.radio-button').classList.add('selected');
            }

            function processPayment() {
                const selectedMethod = document.querySelector('.payment-method.selected .payment-name').textContent;
                alert(`Đang xử lý thanh toán qua ${selectedMethod}...`);
            }

            // Countdown timer
            let timeLeft = 600; // 10 minutes in seconds

            function updateCountdown() {
                const minutes = Math.floor(timeLeft / 60);
                const seconds = timeLeft % 60;

                document.querySelector('.countdown-number').textContent = minutes.toString().padStart(2, '0');
                document.querySelectorAll('.countdown-number')[1].textContent = seconds.toString().padStart(2, '0');

                if (timeLeft > 0) {
                    timeLeft--;
                } else {
                    alert('Thời gian giữ vé đã hết! Vui lòng đặt lại.');
                }
            }

            setInterval(updateCountdown, 1000);
        </script>
    </body>
</html>
