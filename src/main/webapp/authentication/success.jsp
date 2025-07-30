<!DOCTYPE html>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>MasterTicket - Đăng ký thành công</title>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: linear-gradient(135deg, #000428, #2c003e, #360033);
                min-height: 100vh;
                display: flex;
                flex-direction: column;
                color: white;
            }

            /* Navbar */
            .navbar {
                background: rgba(0, 0, 0, 0.7);
                backdrop-filter: blur(25px);
                padding: 1rem 2rem;
                display: flex;
                justify-content: space-between;
                align-items: center;
                border-bottom: 1px solid rgba(255, 255, 255, 0.03);
            }

            .logo {
                font-size: 1.5rem;
                font-weight: bold;
                color: #fff;
            }

            .nav-search {
                display: flex;
                align-items: center;
                gap: 1rem;
            }

            .search-container {
                position: relative;
            }

            .search-input {
                background: rgba(255, 255, 255, 0.1);
                border: 1px solid rgba(255, 255, 255, 0.2);
                border-radius: 25px;
                padding: 10px 20px;
                color: white;
                width: 300px;
                outline: none;
            }

            .search-input::placeholder {
                color: rgba(255, 255, 255, 0.6);
            }

            .search-btn {
                background: rgba(255, 255, 255, 0.2);
                border: none;
                padding: 10px 20px;
                border-radius: 20px;
                color: white;
                cursor: pointer;
                margin-left: 10px;
            }

            .auth-buttons {
                display: flex;
                gap: 1rem;
            }

            .btn-login {
                background: transparent;
                border: 1px solid rgba(255, 255, 255, 0.3);
                color: white;
                padding: 8px 20px;
                border-radius: 20px;
                cursor: pointer;
                transition: all 0.3s ease;
                display: inline-block;
            }

            .btn-register {
                background: linear-gradient(to right, #64f3ff, #e74cfa);
                border: none;
                color: white;
                padding: 8px 20px;
                border-radius: 20px;
                cursor: pointer;
                transition: all 0.3s ease;
                display: inline-block;
            }

            .btn-login:hover, .btn-register:hover {
                opacity: 0.8;
            }

            /* Sub Navigation */
            .sub-nav {
                background: rgba(0, 0, 0, 0.5);
                padding: 1rem 2rem;
                display: flex;
                gap: 2rem;
                border-bottom: 1px solid rgba(255, 255, 255, 0.03);
            }

            .sub-nav a {
                color: rgba(255, 255, 255, 0.8);
                text-decoration: none;
                transition: color 0.3s ease;
            }

            .sub-nav a:hover,
            .sub-nav a.active {
                color: #667eea;
            }

            /* Main Content */
            .main-content {
                flex: 1;
                display: flex;
                align-items: center;
                justify-content: center;
                padding: 2rem;
            }

            .success-card {
                background: rgba(255, 255, 255, 0.05);
                backdrop-filter: blur(25px);
                border: 1px solid rgba(255, 255, 255, 0.03);
                border-radius: 20px;
                padding: 3rem;
                text-align: center;
                max-width: 500px;
                box-shadow: 0 0 40px rgba(0, 0, 0, 0.6);
            }

            .success-icon {
                width: 80px;
                height: 80px;
                margin: 0 auto 2rem;
                background: #4ade80;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 2.5rem;
                color: white;
            }

            .success-title {
                font-size: 2rem;
                margin-bottom: 1rem;
                background: linear-gradient(45deg, #4a90e2, #7b68ee);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                background-clip: text;
            }

            .success-message {
                color: rgba(255, 255, 255, 0.8);
                font-size: 1.1rem;
                margin-bottom: 2rem;
                line-height: 1.5;
            }

            .explore-btn {
                background: linear-gradient(to right, #64f3ff, #e74cfa);
                border: none;
                color: white;
                padding: 15px 40px;
                border-radius: 25px;
                font-size: 1.1rem;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .explore-btn:hover {
                transform: translateY(-2px);
                box-shadow: 0 10px 20px rgba(228, 76, 250, 0.4);
                opacity: 0.9;
            }

            /* Footer */
            .footer {
                background: rgba(0, 0, 0, 0.7);
                backdrop-filter: blur(25px);
                padding: 3rem 2rem 1rem;
                border-top: 1px solid rgba(255, 255, 255, 0.03);
            }

            .footer-content {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                gap: 2rem;
                max-width: 1200px;
                margin: 0 auto;
            }

            .footer-section h3 {
                font-size: 1.1rem;
                margin-bottom: 1rem;
                color: #fff;
            }

            .footer-section ul {
                list-style: none;
            }

            .footer-section ul li {
                margin-bottom: 0.5rem;
            }

            .footer-section ul li a {
                color: rgba(255, 255, 255, 0.7);
                text-decoration: none;
                transition: color 0.3s ease;
            }

            .footer-section ul li a:hover {
                color: #667eea;
            }

            .newsletter {
                display: flex;
                gap: 0.5rem;
                margin-top: 1rem;
            }

            .newsletter input {
                flex: 1;
                background: rgba(255, 255, 255, 0.1);
                border: 1px solid rgba(255, 255, 255, 0.2);
                border-radius: 20px;
                padding: 10px 15px;
                color: white;
                outline: none;
            }

            .newsletter input::placeholder {
                color: rgba(255, 255, 255, 0.5);
            }

            .newsletter button {
                background: linear-gradient(to right, #64f3ff, #e74cfa);
                border: none;
                color: white;
                padding: 10px 20px;
                border-radius: 20px;
                cursor: pointer;
            }

            .language-section {
                display: flex;
                align-items: center;
                gap: 1rem;
                margin-top: 1rem;
            }

            .language-section span {
                color: rgba(255, 255, 255, 0.7);
            }

            .flag {
                width: 30px;
                height: 20px;
                border-radius: 3px;
                cursor: pointer;
                transition: opacity 0.3s ease;
            }

            .flag:hover {
                opacity: 0.8;
            }

            .flag.vn {
                background: linear-gradient(to bottom, #da020e 50%, #ffff00 50%);
                position: relative;
            }

            .flag.vn::after {
                content: '⭐';
                position: absolute;
                top: 50%;
                left: 50%;
                transform: translate(-50%, -50%);
                color: #ffff00;
                font-size: 12px;
            }

            .flag.en {
                background: linear-gradient(to right, #012169 33%, #fff 33%, #fff 66%, #c8102e 66%);
                background-size: 100% 33.33%;
                background-repeat: repeat-y;
            }

            .contact-info {
                margin-top: 1rem;
            }

            .contact-info p {
                color: rgba(255, 255, 255, 0.7);
                margin-bottom: 0.5rem;
            }

            .contact-info a {
                color: #667eea;
                text-decoration: none;
            }

            .social-links {
                display: flex;
                gap: 1rem;
                margin-top: 1rem;
            }

            .social-links a {
                width: 35px;
                height: 35px;
                background: rgba(255, 255, 255, 0.1);
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                text-decoration: none;
                transition: all 0.3s ease;
            }

            .social-links a:hover {
                background: linear-gradient(to right, #64f3ff, #e74cfa);
                transform: translateY(-2px);
            }

            .footer-bottom {
                text-align: center;
                padding-top: 2rem;
                margin-top: 2rem;
                border-top: 1px solid rgba(255, 255, 255, 0.03);
                color: rgba(255, 255, 255, 0.4);
            }

            @media (max-width: 768px) {
                .navbar {
                    flex-direction: column;
                    gap: 1rem;
                }

                .search-input {
                    width: 250px;
                }

                .sub-nav {
                    flex-wrap: wrap;
                    gap: 1rem;
                }

                .success-card {
                    margin: 1rem;
                    padding: 2rem;
                }

                .footer-content {
                    grid-template-columns: 1fr;
                }
            }
        </style>
    </head>
    <body>
        <!-- Navbar -->
        <nav class="navbar">
            <a href="${pageContext.request.contextPath}/" class="logo" style="text-decoration: none; color: #fff;">MasterTicket</a>
            <div class="nav-search">
                <div class="search-container">
                    <input type="text" class="search-input" placeholder="Bạn tìm gì hôm nay ?">
                    <button class="search-btn">Tìm kiếm</button>
                </div>
            </div>
            <div class="auth-buttons">
                <a href="${pageContext.request.contextPath}/authentication/register.jsp" class="btn-login" style="text-decoration: none;">Đăng ký</a>
                <a href="${pageContext.request.contextPath}/authentication/login.jsp" class="btn-register" style="text-decoration: none;">Đăng nhập</a>
            </div>
        </nav>

        <!-- Sub Navigation -->
        <nav class="sub-nav">
            <a href="${pageContext.request.contextPath}/" class="active">Trang Chủ</a>
            <a href="${pageContext.request.contextPath}/pages/homePage.jsp">Các sự kiện hot</a>
            <a href="${pageContext.request.contextPath}/pages/homePage.jsp">Săn voucher giảm giá</a>
            <a href="${pageContext.request.contextPath}/eventOwner/createEvent/CreateEvent.jsp">Tạo sự kiện</a>
            <a href="${pageContext.request.contextPath}/supportCenter/supportCenter.jsp">Hỗ trợ</a>
        </nav>

        <!-- Main Content -->
        <main class="main-content">
            <div class="success-card">
                <div class="success-icon">✓</div>
                <h1 class="success-title">🎉 Bạn Đã Sẵn Sàng 🎉</h1>
                <p class="success-message">
                    Tài khoản của bạn đã được tạo thành công.<br>
                    Khám phá ngay các sự kiện hấp dẫn!
                </p>
                <a href="${pageContext.request.contextPath}/" class="explore-btn">Khám Phá Ngay</a>
            </div>
        </main>


        <!-- Footer -->
        <footer class="footer">
            <div class="footer-content">
                <div class="footer-section">
                    <h3>Customer Services</h3>
                    <ul>
                        <li><a href="#">FAQS</a></li>
                        <li><a href="#">Contact us</a></li>
                        <li><a href="#">Privacy Policy</a></li>
                        <li><a href="#">Terms of Service</a></li>
                    </ul>
                    <div class="contact-info">
                        <p>Email:</p>
                        <a href="mailto:support@masterTicket.vn">support@masterTicket.vn</a>
                    </div>
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
                    <div class="newsletter">
                        <input type="email" placeholder="Your email...">
                        <button>▶</button>
                    </div>

                    <div class="language-section">
                        <span>Language:</span>
                        <div class="flag vn"></div>
                        <div class="flag en"></div>
                    </div>

                    <div class="social-links">
                        <a href="#">f</a>
                        <a href="#">📷</a>
                        <a href="#">🌐</a>
                        <a href="#">🔍</a>
                    </div>

                    <p style="margin-top: 1rem; color: rgba(255,255,255,0.7);">Follow us:</p>
                </div>
            </div>

            <div class="footer-bottom">
                <p>© 2025 MasterTicket.vn | <a href="mailto:support@masterTicket.vn">support@masterTicket.vn</a></p>
            </div>
        </footer>
    </body>
</html>