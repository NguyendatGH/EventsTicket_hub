

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>MasterTicket - Chi tiết vé</title>
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
            .header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 15px 40px;
                background-color: var(--dark-bg);
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
                max-width: 1200px;
                margin: 30px auto;
                padding: 0 40px;
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
            .ticket-detail-container {
                max-width: 1000px;
                margin: 0 auto;
                padding: 20px;
                font-family: 'Segoe UI', Arial, sans-serif;
                color: #333;
            }

            .section-title {
                font-size: 22px;
                font-weight: 600;
                margin-bottom: 20px;
                color: #4a4aff;
                padding-bottom: 8px;
                border-bottom: 2px solid #4a4aff;
            }

            .event-card {
                background-color: #f8f9fa;
                border-radius: 10px;
                padding: 25px;
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

            .meta-icon {
                font-size: 16px;
            }

            .ticket-table-container {
                background-color: #f8f9fa;
                border-radius: 10px;
                padding: 20px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                margin-bottom: 30px;
            }

            .ticket-table {
                width: 100%;
                border-collapse: collapse;
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
                padding-bottom: 10px;
            }

            .suggestions-title::after {
                content: '';
                position: absolute;
                bottom: 0;
                left: 0;
                width: 50px;
                height: 3px;
                background-color: var(--secondary);
            }

            .suggestions-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
                gap: 20px;
            }

            .event-card {
                background-color: #222233;
                border-radius: 8px;
                overflow: hidden;
                transition: transform 0.2s;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            }

            .event-name {
                font-size: 20px;
                font-weight: 600;
                margin-bottom: 15px;
                color: #ffffff;
            }

            .event-card img {
                width: 100%;
                height: 150px;
                object-fit: cover;
                display: block;
            }

            .event-card .card-body {
                padding: 15px;
            }

            .event-card h4 {
                font-size: 16px;
                margin-bottom: 5px;
            }

            .event-card p {
                font-size: 13px;
                color: var(--text-muted);
                margin-bottom: 10px;
            }

            .event-card .price {
                color: var(--secondary);
                font-weight: bold;
                font-size: 14px;
            }

            .event-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 6px 12px rgba(0, 0, 0, 0.3);
            }

            /* Footer */
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

                .footer {
                    flex-direction: column;
                    padding: 30px 20px;
                    gap: 25px;
                }
            }
        </style>
    </head>
    <body>
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

        <div class="main-content">
            <!-- Event Header -->
            <div class="event-header">
                <div class="event-poster">
                    <img src="https://cdn.tuoitre.vn/thumb_w/730/471584752817336320/2024/5/15/bui-cong-nam-1715744581616963775462.jpeg" alt="Event Poster">
                </div>
                <div class="event-info">
                    <h1 class="event-title">30/05 - BÙI CÔNG NAM & KHÁCH MỜI: LÂM BẢO NGỌC - ĐÀ NẴNG</h1>
                    <div class="event-meta">
                        <div class="event-meta-item">
                            <span>⏰</span>
                            <span>20:00 - 22:00, 30 tháng 05, 2025</span>
                        </div>
                        <div class="event-meta-item">
                            <span>📍</span>
                            <span>Sân khấu Veranda - Phía Tây Cầu Trần Thị Lý, Đà Nẵng</span>
                        </div>
                    </div>
                    <p class="event-description">
                        Vào tối ngày 30/05/2025 tại Nhà hát Trung Vương - Đà Nẵng, đêm nhạc với sự góp mặt của nhạc sĩ Bùi Công Nam và ca sĩ khách mời Lâm Bảo Ngọc sẽ mang đến một không gian nghệ thuật giàu cảm xúc, nơi những giai điệu từ các ca khúc nổi tiếng của nhạc sĩ Bùi Công Nam được thể hiện qua giọng hát truyền cảm của Lâm Bảo Ngọc.
                    </p>
                    <button class="primary-btn">Mua vé ngay</button>
                </div>
            </div>

            <!-- Ticket Table Section -->
            <div class="ticket-detail-container">
                <!-- Event Information Section -->
                <div class="event-info-section">
                    <h2 class="section-title">Thông tin chi tiết</h2>

                    <div class="event-card">
                        <h3 class="event-name">30/05 - BÙI CÔNG NAM & KHÁCH MỜI: LÂM BẢO NGỌC - ĐÀ NẴNG</h3>
                        <p class="event-description">
                            Vào tối ngày 30/05/2025 tại Nhà hát Trung Vương - Đà Nẵng, đêm nhạc với sự góp mặt của nhạc sĩ Bùi Công Nam và ca sĩ khách mời Lâm Bảo Ngọc sẽ mang đến một không gian nghệ thuật giàu cảm xúc, nơi những giai điệu từ các ca khúc nổi tiếng của nhạc sĩ Bùi Công Nam được thể hiện qua giọng hát truyền cảm của Lâm Bảo Ngọc.
                        </p>

                        <div class="event-meta">
                            <div class="meta-item">
                                <span class="meta-icon">⏰</span>
                                <span>20:00, 30/05/2025</span>
                            </div>
                            <div class="meta-item">
                                <span class="meta-icon">📍</span>
                                <span>Nhà hát Trung Vương, Đà Nẵng</span>
                            </div>
                            <div class="meta-item">
                                <span class="meta-icon">💰</span>
                                <span>Giá từ: 525.000đ</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Ticket Information Section -->
                <div class="ticket-info-section">
                    <h2 class="section-title">Thông tin vé</h2>

                    <div class="ticket-table-container">
                        <table class="ticket-table">
                            <thead>
                                <tr>
                                    <th>Loại vé</th>
                                    <th>Giá</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>PREMIUM / THẢNH THƠI</td>
                                    <td>1.825.000đ</td>
                                </tr>
                                <tr>
                                    <td>STANDARD A</td>
                                    <td>725.000đ</td>
                                </tr>
                                <tr>
                                    <td>STANDARD B</td>
                                    <td>525.000đ</td>
                                </tr>
                            </tbody>
                        </table>

                        <div class="ticket-note">
                            <p>* Vé được cập nhật liên tục theo hệ thống phân phối và có thể thay đổi.</p>
                        </div>
                    </div>
                </div>

                <!-- Organizer Section -->
                <div class="organizer-section">
                    <h2 class="section-title">Ban Tổ Chức</h2>

                    <div class="organizer-card">
                        <h3 class="organizer-name">Máy Lang Thang</h3>
                        <p class="organizer-desc">Nơi âm nhạc và cảm xúc thăng hoa</p>

                        <div class="organizer-links">
                            <a href="https://my.langthang.com" class="organizer-link">Website</a>
                            <a href="#" class="organizer-link">Fanpage</a>
                        </div>
                    </div>
                </div>
            </div>



            <!-- Suggestions -->
            <div class="suggestions">
                <h2 class="suggestions-title">Có Thể Bạn Cũng Thích</h2>
                <div class="suggestions-grid">
                    <div class="event-card">
                        <img src="https://images.tkbcdn.com/2/608/332/ts/ds/27/f7/40/745c65a46ab0c5540ff9306eee4322ca.jpg" alt="BOF DEBUT SHOWCASE">
                        <div class="card-body">
                            <h4>BOF DEBUT SHOWCASE</h4>
                            <p>06/06/2025 • Hà Nội</p>
                            <p class="price">Từ 350.000đ</p>
                        </div>
                    </div>
                    <div class="event-card">
                        <img src="https://images.tkbcdn.com/2/608/332/ts/ds/77/67/54/d1ee978159818ef0d07bbefa3e3cd6cb.png" alt="LULULOLA SHOW HƯƠNG TRÀM">
                        <div class="card-body">
                            <h4>LULULOLA SHOW HƯƠNG TRÀM</h4>
                            <p>21/06/2025 • TP.HCM</p>
                            <p class="price">Từ 450.000đ</p>
                        </div>
                    </div>
                    <div class="event-card">
                        <img src="https://images.tkbcdn.com/2/608/332/ts/ds/a8/d6/13/a7169a90abe9cbd7708a9ec7f187f209.jpg" alt="Đêm nhạc Bạch Công Khanh">
                        <div class="card-body">
                            <h4>Đêm nhạc Bạch Công Khanh</h4>
                            <p>15/07/2025 • Đà Nẵng</p>
                            <p class="price">Từ 500.000đ</p>
                        </div>
                    </div>
                    <div class="event-card">
                        <img src="https://images.tkbcdn.com/2/608/332/ts/ds/54/89/88/8514f83803c10102dd8b61658602431a.jpg" alt="FORESTIVAL 2025">
                        <div class="card-body">
                            <h4>FORESTIVAL 2025 - Tràng An</h4>
                            <p>28/07/2025 • Ninh Bình</p>
                            <p class="price">Từ 650.000đ</p>
                        </div>
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
    </body>
</html>