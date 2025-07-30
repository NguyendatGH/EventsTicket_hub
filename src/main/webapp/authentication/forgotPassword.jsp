<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quên mật khẩu - MasterTicket</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(to bottom, #161b22, #0d1117);
            color: #333;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        /* Navbar Styles */
        .navbar {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            padding: 1rem 0;
            box-shadow: 0 2px 20px rgba(0, 0, 0, 0.1);
            position: sticky;
            top: 0;
            z-index: 1000;
        }

        .nav-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .logo {
            display: flex;
            align-items: center;
            text-decoration: none;
            color: #333;
            font-size: 1.5rem;
            font-weight: bold;
        }

        .logo i {
            margin-right: 0.5rem;
            color: #667eea;
        }

        .nav-menu {
            display: flex;
            list-style: none;
            gap: 2rem;
        }

        .nav-menu a {
            text-decoration: none;
            color: #333;
            font-weight: 500;
            transition: color 0.3s;
        }

        .nav-menu a:hover {
            color: #667eea;
        }

        /* Main Content */
        .main-content {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 2rem 0;
        }

        /* Form Container */
        .forgot-password-container {
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(25px);
            padding: 3rem;
            border-radius: 20px;
            box-shadow: 0 0 40px rgba(0, 0, 0, 0.6);
            max-width: 500px;
            width: 90%;
            text-align: center;
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        .forgot-password-container h2 {
            color: white;
            margin-bottom: 2rem;
            font-size: 2.2rem;
            font-weight: 600;
        }

        .form-description {
            color: #ccc;
            margin-bottom: 2rem;
            font-size: 1rem;
            line-height: 1.6;
        }

        /* Error Message */
        .error-message {
            background: linear-gradient(135deg, #ff6b6b, #ee5a52);
            color: white;
            padding: 1rem;
            border-radius: 10px;
            margin-bottom: 1.5rem;
            font-size: 0.95rem;
            display: none;
            animation: slideIn 0.3s ease-out;
        }

        .error-message.show {
            display: block;
        }

        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* Form Group */
        .form-group {
            margin-bottom: 1.5rem;
            text-align: left;
        }

        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            color: #ccc;
            font-weight: 600;
            font-size: 1rem;
        }

        .form-group input[type="email"] {
            width: 100%;
            padding: 1rem;
            background: rgba(255, 255, 255, 0.08);
            border: 2px solid rgba(255, 255, 255, 0.1);
            border-radius: 10px;
            color: white;
            font-size: 1rem;
            outline: none;
            transition: all 0.3s;
        }

        .form-group input[type="email"]:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.2);
            background: rgba(255, 255, 255, 0.15);
        }

        /* Button */
        .btn {
            padding: 1rem 2.5rem;
            border: none;
            border-radius: 25px;
            cursor: pointer;
            font-weight: 600;
            font-size: 1rem;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-width: 200px;
            color: white;
            background: linear-gradient(to right, #64f3ff, #e74cfa);
            margin-top: 1rem;
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(100, 243, 255, 0.3);
            opacity: 0.9;
        }

        .btn i {
            margin-right: 0.5rem;
        }

        /* Back to Login */
        .back-to-login {
            display: block;
            margin-top: 2rem;
            color: #667eea;
            text-decoration: none;
            font-size: 1rem;
            font-weight: 500;
            transition: all 0.3s;
        }

        .back-to-login:hover {
            color: #5a6fd8;
            transform: translateX(5px);
        }

        .back-to-login i {
            margin-right: 0.5rem;
        }

        /* Footer */
        .footer {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            padding: 2rem 0;
            margin-top: auto;
        }

        .footer-content {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 2rem;
            text-align: center;
            color: #666;
        }

        .footer-content p {
            margin-bottom: 0.5rem;
        }

        .social-links {
            margin-top: 1rem;
        }

        .social-links a {
            color: #667eea;
            margin: 0 0.5rem;
            font-size: 1.2rem;
            transition: color 0.3s;
        }

        .social-links a:hover {
            color: #5a6fd8;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .nav-container {
                padding: 0 1rem;
            }

            .nav-menu {
                gap: 1rem;
            }

            .forgot-password-container {
                padding: 2rem;
                margin: 1rem;
            }

            .forgot-password-container h2 {
                font-size: 1.8rem;
            }

            .btn {
                min-width: 150px;
                padding: 0.8rem 2rem;
            }
        }

        @media (max-width: 480px) {
            .nav-menu {
                display: none;
            }

            .forgot-password-container {
                padding: 1.5rem;
            }

            .forgot-password-container h2 {
                font-size: 1.5rem;
            }

            .btn {
                min-width: 120px;
                padding: 0.7rem 1.5rem;
                font-size: 0.9rem;
            }
        }
    </style>
</head>
<body>
    <!-- Navbar -->
    <nav class="navbar">
        <div class="nav-container">
            <a href="${pageContext.request.contextPath}/" class="logo">
                <i class="fas fa-ticket-alt"></i>
                MasterTicket
            </a>
            <ul class="nav-menu">
                <li><a href="${pageContext.request.contextPath}/">Trang chủ</a></li>
                <li><a href="${pageContext.request.contextPath}/events">Sự kiện</a></li>
                <li><a href="${pageContext.request.contextPath}/authentication/login.jsp">Đăng nhập</a></li>
                <li><a href="${pageContext.request.contextPath}/authentication/register.jsp">Đăng ký</a></li>
            </ul>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="main-content">
    <div class="forgot-password-container">
            <h2><i class="fas fa-key"></i> Quên mật khẩu</h2>
            <p class="form-description">
                Nhập email đã đăng ký để nhận mã xác nhận đặt lại mật khẩu
            </p>

            <!-- Error Message (Hidden by default) -->
            <div id="errorMessage" class="error-message">
                <i class="fas fa-exclamation-triangle"></i>
                <span id="errorText"></span>
            </div>

            <form id="forgotPasswordForm" action="${pageContext.request.contextPath}/sendResetOTP" method="post">
                <div class="form-group">
                    <label for="email">
                        <i class="fas fa-envelope"></i> Email
                    </label>
                    <input type="email" id="email" name="email" placeholder="Nhập email của bạn" required>
                </div>
                <button type="submit" class="btn">
                    <i class="fas fa-paper-plane"></i>
                    Gửi mã xác nhận
                </button>
            </form>

            <a href="${pageContext.request.contextPath}/authentication/login.jsp" class="back-to-login">
                <i class="fas fa-arrow-left"></i>
                Quay lại đăng nhập
            </a>
        </div>
    </div>

    <!-- Footer -->
    <footer class="footer">
        <div class="footer-content">
            <p>&copy; 2024 MasterTicket. Tất cả quyền được bảo lưu.</p>
            <p>Hệ thống đặt vé sự kiện trực tuyến hàng đầu Việt Nam</p>
            <div class="social-links">
                <a href="#"><i class="fab fa-facebook"></i></a>
                <a href="#"><i class="fab fa-twitter"></i></a>
                <a href="#"><i class="fab fa-instagram"></i></a>
                <a href="#"><i class="fab fa-youtube"></i></a>
            </div>
        </div>
    </footer>

    <script>
        // Form validation and error handling
        document.getElementById('forgotPasswordForm').addEventListener('submit', function(e) {
            const email = document.getElementById('email').value.trim();
            const errorMessage = document.getElementById('errorMessage');
            const errorText = document.getElementById('errorText');
            
            // Hide any existing error message
            errorMessage.classList.remove('show');
            
            // Validate email
            if (!email) {
                showError('Vui lòng nhập email của bạn');
                e.preventDefault();
                return;
            }
            
            // Basic email validation
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(email)) {
                showError('Email không hợp lệ. Vui lòng nhập email đúng định dạng');
                e.preventDefault();
                return;
            }
        });

        function showError(message) {
            const errorMessage = document.getElementById('errorMessage');
            const errorText = document.getElementById('errorText');
            
            errorText.textContent = message;
            errorMessage.classList.add('show');
            
            // Scroll to error message
            errorMessage.scrollIntoView({ behavior: 'smooth', block: 'center' });
        }

        // Show error message from server if exists
        <c:if test="${not empty error}">
            showError('${error}');
        </c:if>

        // Clear error when user starts typing
        document.getElementById('email').addEventListener('input', function() {
            const errorMessage = document.getElementById('errorMessage');
            errorMessage.classList.remove('show');
        });
    </script>
</body>
</html>