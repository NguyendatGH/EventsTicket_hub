<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Login</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <style>
        * { box-sizing: border-box; font-family: 'Segoe UI', sans-serif; }
        body {
            margin: 0;
            min-height: 100vh;
            background: radial-gradient(ellipse at top left, #0f1123 60%, #1f1d40 100%), linear-gradient(135deg, #5e1763 0%, #1f1d40 100%);
            background-repeat: no-repeat;
            background-size: cover;
            display: flex;
            flex-direction: column;
        }
        .header {
            width: 100%;
            background: rgba(15, 17, 35, 0.95);
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 18px 60px 10px 60px;
            position: relative;
            z-index: 10;
            height: 70px;
            min-height: 70px;
        }
        .header > * {
            align-self: center;
        }
        .header .logo,
        .header .search-bar,
        .header .menu,
        .header .auth-btns {
            align-self: center;
            margin-top: 0 !important;
            margin-bottom: 0 !important;
            padding-top: 0 !important;
            padding-bottom: 0 !important;
        }
        .header .logo {
            color: #fff;
            font-size: 1.6rem;
            font-weight: 700;
            letter-spacing: 1px;
        }
        .header .search-bar {
            display: flex;
            align-items: center;
            background: #23243a;
            border-radius: 8px;
            padding: 2px 8px;
        }
        .header .search-bar input {
            background: transparent;
            border: none;
            color: #fff;
            padding: 8px 10px;
            outline: none;
            width: 220px;
        }
        .header .search-bar button {
            background: #444;
            color: #fff;
            border: none;
            border-radius: 6px;
            padding: 7px 18px;
            margin-left: 6px;
            cursor: pointer;
        }
        .header .menu {
            display: flex;
            gap: 28px;
            margin-left: 40px;
        }
        .header .menu a {
            color: #bdbdfc;
            text-decoration: none;
            font-size: 1rem;
            font-weight: 500;
            transition: color 0.2s;
        }
        .header .menu a.active, .header .menu a:hover {
            color: #a259f7;
        }
        .header .auth-btns {
            display: flex;
            gap: 10px;
            align-items: center;
            height: 44px;
        }
        .header .auth-btns a {
            width: 150px !important;
            min-width: 150px !important;
            max-width: 150px !important;
            height: 44px !important;
            line-height: 44px !important;
            padding: 0 !important;
            margin: 0 !important;
            border-radius: 12px;
            font-weight: 600;
            font-size: 1rem;
            border: 2px solid #a259f7;
            background: transparent;
            color: #a259f7;
            text-decoration: none;
            transition: background 0.2s, color 0.2s;
            box-shadow: none;
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
            white-space: nowrap;
            font-family: inherit;
            vertical-align: middle;
        }
        .header .auth-btns a.login {
            background: #a259f7;
            color: #fff;
            /* box-shadow: 0 2px 12px 0 #a259f766; */
        }
        .header .auth-btns a.login:hover {
            background: #8839c4;
            color: #fff;
        }
        .header .auth-btns a.signup {
            background: transparent;
            color: #a259f7;
        }
        .header .auth-btns a.signup:hover {
            background: #e0c3fc;
            color: #fff;
            border-color: #a259f7;
        }
        .login-container {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 80vh;
            position: relative;
        }
        /* Blurred circles background */
        .blurred-bg {
            position: absolute;
            top: 0; left: 0; right: 0; bottom: 0;
            width: 100%;
            height: 100%;
            z-index: 0;
            pointer-events: none;
        }
        .blurred-circle {
            position: absolute;
            border-radius: 50%;
            filter: blur(60px);
            opacity: 0.5;
            z-index: 1;
        }
        .circle1 {
            width: 320px; height: 320px;
            background: radial-gradient(circle, #a259f7 60%, #4facfe 100%);
            top: 10%; left: 5%;
        }
        .circle2 {
            width: 220px; height: 220px;
            background: radial-gradient(circle, #ff33cc 60%, #a259f7 100%);
            bottom: 15%; right: 10%;
        }
        .circle3 {
            width: 180px; height: 180px;
            background: radial-gradient(circle, #4facfe 60%, #00ffd0 100%);
            top: 60%; left: 60%;
        }
        .login-box {
            background: rgba(36, 19, 54, 0.85);
            border-radius: 28px;
            padding: 48px 38px 38px 38px;
            width: 400px;
            color: #fff;
            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37), 0 2px 24px 0 #a259f733;
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
            display: flex;
            flex-direction: column;
            align-items: stretch;
            z-index: 2;
        }
        .login-box h2 {
            font-size: 2.5rem;
            font-weight: 600;
            margin-bottom: 32px;
            margin-top: 0;
            text-align: left;
        }
        .login-box label {
            display: block;
            margin-bottom: 7px;
            font-size: 1rem;
            font-weight: 500;
        }
        .login-box input[type="text"],
        .login-box input[type="password"] {
            width: 100%;
            padding: 13px 16px;
            margin-bottom: 18px;
            background: rgba(255, 255, 255, 0.08);
            border: none;
            border-radius: 12px;
            color: #fff;
            font-size: 1rem;
        }
        .login-box input::placeholder {
            color: #bdbdbd;
        }
        .login-box .row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 18px;
        }
        .login-box .remember {
            display: flex;
            align-items: center;
            gap: 7px;
            font-size: 0.98rem;
        }
        .login-box .forgot {
            color: #bdbdfc;
            text-decoration: none;
            font-size: 0.98rem;
            transition: color 0.2s;
        }
        .login-box .forgot:hover {
            color: #a259f7;
        }
        .login-box button[type="submit"] {
            width: 100%;
            padding: 15px 0;
            background: linear-gradient(90deg, #a259f7 0%, #4facfe 100%);
            border: none;
            border-radius: 32px;
            color: #fff;
            font-weight: 700;
            font-size: 1.15rem;
            cursor: pointer;
            margin-top: 10px;
            margin-bottom: 10px;
            transition: background 0.2s, box-shadow 0.2s, transform 0.1s;
            box-shadow: 0 4px 18px 0 #a259f766;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }
        .login-box button[type="submit"]:hover {
            background: linear-gradient(90deg, #4facfe 0%, #a259f7 100%);
            box-shadow: 0 6px 24px 0 #4facfe99;
            transform: translateY(-2px) scale(1.03);
        }
        .login-box button[type="submit"] i {
            font-size: 1.2em;
        }
        .divider {
            text-align: center;
            margin: 18px 0 12px 0;
            color: #ccc;
            position: relative;
            font-size: 1rem;
        }
        .divider::before, .divider::after {
            content: "";
            position: absolute;
            top: 50%;
            width: 40%;
            height: 1px;
            background: #444;
        }
        .divider::before { left: 0; }
        .divider::after { right: 0; }
        .social-login {
            display: flex;
            justify-content: center;
            gap: 18px;
            margin-bottom: 10px;
        }
        .social-login a {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 44px;
            height: 44px;
            border-radius: 8px;
            background: #23243a;
            transition: background 0.2s;
        }
        .social-login a:hover {
            background: #a259f7;
        }
        .social-login img {
            width: 26px;
            height: 26px;
        }
        .signup {
            margin-top: 18px;
            text-align: center;
            font-size: 1rem;
            color: #ccc;
        }
        .signup a {
            color: #a259f7;
            text-decoration: none;
            font-weight: 500;
        }
        .signup a:hover {
            text-decoration: underline;
        }
        .footer {
            width: 100%;
            background: rgba(15, 17, 35, 0.95);
            color: #bdbdbd;
            padding: 38px 0 18px 0;
            margin-top: 40px;
            display: flex;
            flex-direction: column;
            align-items: center;
        }
        .footer-content {
            width: 90%;
            max-width: 1200px;
            display: flex;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 30px;
        }
        .footer-col {
            min-width: 200px;
            flex: 1;
        }
        .footer-col h4 {
            color: #fff;
            margin-bottom: 16px;
            font-size: 1.1rem;
        }
        .footer-col ul {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        .footer-col ul li {
            margin-bottom: 10px;
        }
        .footer-col ul li a {
            color: #bdbdbd;
            text-decoration: none;
            font-size: 1rem;
        }
        .footer-col ul li a:hover {
            color: #a259f7;
        }
        .footer .subscribe {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-top: 8px;
        }
        .footer .subscribe input {
            padding: 8px 12px;
            border-radius: 8px 0 0 8px;
            border: none;
            outline: none;
            background: #23243a;
            color: #fff;
        }
        .footer .subscribe button {
            padding: 8px 16px;
            border-radius: 0 8px 8px 0;
            border: none;
            background: #a259f7;
            color: #fff;
            cursor: pointer;
        }
        .footer .lang-flags {
            display: flex;
            gap: 8px;
            margin-top: 8px;
        }
        .footer .lang-flags img {
            width: 28px;
            height: 20px;
            border-radius: 3px;
            border: 1px solid #444;
        }
        .footer .social {
            display: flex;
            gap: 12px;
            margin-top: 10px;
        }
        .footer .social a {
            color: #fff;
            font-size: 1.3rem;
            transition: color 0.2s;
        }
        .footer .social a:hover {
            color: #a259f7;
        }
        @media (max-width: 900px) {
            .footer-content { flex-direction: column; align-items: flex-start; }
            .footer-col { min-width: 0; }
        }
        @media (max-width: 600px) {
            .header, .footer-content { padding-left: 10px; padding-right: 10px; }
            .login-box { width: 98vw; padding: 24px 6vw; }
        }

        /* Error message styling */
        .error-message {
            background: rgba(255, 107, 129, 0.1);
            border: 1px solid #ff6b81;
            border-radius: 8px;
            padding: 12px;
            margin-bottom: 20px;
            color: #ff6b81;
            font-size: 0.9rem;
            animation: fadeIn 0.3s ease-in;
        }

        .error-message .error-content {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .error-message i {
            font-size: 1.1rem;
            flex-shrink: 0;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
</head>
<body>
    <div class="header">
        <div class="logo">MasterTicket</div>
        <form class="search-bar" action="#" method="get">
            <input type="text" placeholder="Bạn tìm gì hôm nay ?" />
            <button type="submit">Tìm kiếm</button>
        </form>
        <nav class="menu">
            <a href="#" class="active">Trang Chủ</a>
            <a href="#">Các sự kiện hot</a>
            <a href="#">Săn voucher giảm giá</a>
            <a href="#">Tạo sự kiện</a>
            <a href="#">Hỗ trợ</a>
        </nav>
        <div class="auth-btns">
            <a href="${pageContext.request.contextPath}/authentication/register.jsp" class="signup">Đăng ký</a>
            <a href="${pageContext.request.contextPath}/authentication/login.jsp" class="login">Đăng nhập</a>
        </div>
    </div>
    <div class="login-container">
        <div class="blurred-bg">
            <div class="blurred-circle circle1"></div>
            <div class="blurred-circle circle2"></div>
            <div class="blurred-circle circle3"></div>
        </div>
        <div class="login-box">
            <h2>Login</h2>
            <c:if test="${not empty error}">
                <div class="error-message">
                    <div class="error-content">
                        <i class="fa fa-exclamation-triangle"></i>
                        <span>${error}</span>
                    </div>
                </div>
            </c:if>
            <form action="${pageContext.request.contextPath}/login" method="post">
                <label>Email</label>
                <input type="text" name="email" placeholder="Enter your email" required />
                <label>Passwords</label>
                <input type="password" name="password" placeholder="Enter your password" required />
                <c:if test="${not empty param.redirect}">
                    <input type="hidden" name="redirect" value="${param.redirect}" />
                </c:if>
                <div class="row">
                    <div class="remember">
                        <input type="checkbox" name="remember" id="remember" style="width: 16px; height: 16px;" />
                        <label for="remember" style="margin-bottom: 0;">Remember me</label>
                    </div>
                    <a href="${pageContext.request.contextPath}/authentication/forgotPassword.jsp" class="forgot">Fogot password?</a>
                </div>
                <button type="submit"><i class="fa fa-sign-in-alt"></i>Sign in</button>
            </form>
            <div class="divider">or</div>
            <div class="social-login">
                <a href="${pageContext.request.contextPath}/login-google" title="Sign in with Google">
                    <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/google/google-original.svg" alt="Google" />
                </a>
                <a href="#" title="Sign in with Zalo">
                    <img src="https://upload.wikimedia.org/wikipedia/commons/9/91/Icon_of_Zalo.svg" alt="Zalo" onclick="alert('soon!')"/>
                </a>
                <a href="#" title="Sign in with Facebook" onclick="alert('soon!')">
                    <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/facebook/facebook-original.svg" alt="Facebook" />
                </a>
            </div>
            <div class="signup">
                Not have account yet ? Please <a href="${pageContext.request.contextPath}/authentication/register.jsp">sign up</a>
            </div>
        </div>
    </div>
    <footer class="footer">
        <div class="footer-content">
            <div class="footer-col">
                <h4>Customer Services</h4>
                <ul>
                    <li><a href="#">FAQS</a></li>
                    <li><a href="#">Contact us</a></li>
                    <li><a href="#">Pricy Policy</a></li>
                    <li><a href="#">Terms of Service</a></li>
                </ul>
                <div style="margin-top: 10px;">
                    Email: <a href="mailto:support@masterTicket.vn" style="color:#7fffd4;"><i class="fa fa-envelope"></i> support@masterTicket.vn</a>
                </div>
                <div style="margin-top: 8px;">
                    Hotline: <a href="tel:1900xxxx" style="color:#7fffd4;"><i class="fa fa-phone"></i> 1900-xxxx</a>
                </div>
            </div>
            <div class="footer-col">
                <h4>SiteMap</h4>
                <ul>
                    <li><a href="#">Create Account</a></li>
                    <li><a href="#">News</a></li>
                    <li><a href="#">Top-Rated Event</a></li>
                </ul>
            </div>
            <div class="footer-col">
                <h4>Subscribe for event updates.</h4>
                <form class="subscribe" action="#" method="post" onsubmit="return false;">
                    <input type="email" placeholder="Your email..." required />
                    <button type="submit"><i class="fa fa-envelope"></i></button>
                </form>
                <div style="margin-top: 18px;">
                    Language:
                    <span class="lang-flags">
                        <img src="https://cdn.jsdelivr.net/gh/hjnilsson/country-flags/svg/vn.svg" alt="VN" />
                        <img src="https://cdn.jsdelivr.net/gh/hjnilsson/country-flags/svg/gb.svg" alt="EN" />
                    </span>
                </div>
            </div>
            <div class="footer-col">
                <h4>Follow us:</h4>
                <div class="social">
                    <a href="#"><i class="fab fa-facebook"></i></a>
                    <a href="#"><i class="fab fa-instagram"></i></a>
                    <a href="#"><i class="fab fa-tiktok"></i></a>
                </div>
            </div>
        </div>
    </footer>
</body>
</html>