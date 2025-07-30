<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt lại mật khẩu - EventTicketHub</title>
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
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(10px);
            padding: 1rem 0;
            box-shadow: 0 2px 20px rgba(0, 0, 0, 0.3);
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
            color: white;
            font-size: 1.5rem;
            font-weight: bold;
        }

        .logo i {
            margin-right: 0.5rem;
            color: #64f3ff;
        }

        .nav-menu {
            display: flex;
            list-style: none;
            gap: 2rem;
        }

        .nav-menu a {
            text-decoration: none;
            color: white;
            font-weight: 500;
            transition: color 0.3s;
        }

        .nav-menu a:hover {
            color: #64f3ff;
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
        .reset-container {
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(25px);
            border-radius: 20px;
            padding: 50px 40px;
            width: 500px;
            text-align: center;
            box-shadow: 0 0 40px rgba(0, 0, 0, 0.6);
            color: white;
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        .reset-container h2 {
            font-size: 36px;
            font-weight: 400;
            margin-bottom: 25px;
            color: white;
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
            text-align: left;
            margin-bottom: 8px;
            color: #ccc;
            font-size: 15px;
            font-weight: 600;
        }

        .form-group input {
            width: 100%;
            padding: 12px;
            margin-bottom: 20px;
            border: none;
            border-radius: 12px;
            background-color: rgba(255, 255, 255, 0.08);
            color: white;
            font-size: 16px;
            outline: none;
            transition: all 0.3s;
        }

        .form-group input:focus {
            background-color: rgba(255, 255, 255, 0.15);
            box-shadow: 0 0 0 3px rgba(100, 243, 255, 0.2);
        }

        /* Button */
        .btn {
            background: linear-gradient(to right, #64f3ff, #e74cfa);
            border: none;
            color: white;
            font-size: 18px;
            padding: 12px 40px;
            border-radius: 20px;
            cursor: pointer;
            transition: 0.3s ease;
            font-weight: 600;
            min-width: 200px;
        }

        .btn:hover {
            opacity: 0.9;
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(100, 243, 255, 0.3);
        }

        .btn i {
            margin-right: 0.5rem;
        }

        /* Back to Login */
        .bottom-text {
            margin-top: 25px;
            color: #ccc;
            font-size: 14px;
        }

        .bottom-text a {
            color: #64f3ff;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s;
        }

        .bottom-text a:hover {
            color: #e74cfa;
            transform: translateX(5px);
        }

        .bottom-text i {
            margin-right: 0.5rem;
        }

        /* Footer */
        .footer {
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(10px);
            padding: 2rem 0;
            margin-top: auto;
        }

        .footer-content {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 2rem;
            text-align: center;
            color: #ccc;
        }

        .footer-content p {
            margin-bottom: 0.5rem;
        }

        .social-links {
            margin-top: 1rem;
        }

        .social-links a {
            color: #64f3ff;
            margin: 0 0.5rem;
            font-size: 1.2rem;
            transition: color 0.3s;
        }

        .social-links a:hover {
            color: #e74cfa;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .nav-container {
                padding: 0 1rem;
            }

            .nav-menu {
                gap: 1rem;
            }

            .reset-container {
                padding: 2rem;
                margin: 1rem;
                width: 90%;
            }

            .reset-container h2 {
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

            .reset-container {
                padding: 1.5rem;
            }

            .reset-container h2 {
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
                EventTicketHub
            </a>
            <ul class="nav-menu">
                <li><a href="${pageContext.request.contextPath}/">Trang chủ</a></li>
                <li><a href="${pageContext.request.contextPath}/authentication/login.jsp">Đăng nhập</a></li>
                <li><a href="${pageContext.request.contextPath}/authentication/register.jsp">Đăng ký</a></li>
            </ul>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="main-content">
        <div class="reset-container">
            <h2><i class="fas fa-key"></i> Đặt lại mật khẩu</h2>
            <p class="form-description">
                Nhập mã xác nhận và mật khẩu mới để hoàn tất quá trình đặt lại mật khẩu
            </p>

            <!-- Error Message (Hidden by default) -->
            <div id="errorMessage" class="error-message">
                <i class="fas fa-exclamation-triangle"></i>
                <span id="errorText"></span>
            </div>

            <form id="resetPasswordForm" action="${pageContext.request.contextPath}/resetPassword" method="post">
                <div class="form-group">
                    <label for="otp">
                        <i class="fas fa-shield-alt"></i> Mã xác nhận (OTP)
                    </label>
                    <input type="text" id="otp" name="otp" placeholder="Nhập mã OTP" required>
                </div>

                <div class="form-group">
                    <label for="newPassword">
                        <i class="fas fa-lock"></i> Mật khẩu mới
                    </label>
                    <input type="password" id="newPassword" name="newPassword" placeholder="Nhập mật khẩu mới" required>
                </div>

                <div class="form-group">
                    <label for="confirmPassword">
                        <i class="fas fa-lock"></i> Xác nhận mật khẩu
                    </label>
                    <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Nhập lại mật khẩu mới" required>
                </div>

                <button type="submit" class="btn">
                    <i class="fas fa-check"></i>
                    Xác nhận
                </button>
            </form>

            <div class="bottom-text">
                <i class="fas fa-arrow-left"></i>
                <a href="${pageContext.request.contextPath}/authentication/login.jsp">Quay lại đăng nhập</a>
            </div>
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
        document.getElementById('resetPasswordForm').addEventListener('submit', function(e) {
            const otp = document.getElementById('otp').value.trim();
            const newPassword = document.getElementById('newPassword').value.trim();
            const confirmPassword = document.getElementById('confirmPassword').value.trim();
            const errorMessage = document.getElementById('errorMessage');
            const errorText = document.getElementById('errorText');
            
            // Hide any existing error message
            errorMessage.classList.remove('show');
            
            // Validate OTP
            if (!otp) {
                showError('Vui lòng nhập mã xác nhận OTP');
                e.preventDefault();
                return;
            }
            
            // Validate new password
            if (!newPassword) {
                showError('Vui lòng nhập mật khẩu mới');
                e.preventDefault();
                return;
            }
            
            if (newPassword.length < 6) {
                showError('Mật khẩu phải có ít nhất 6 ký tự');
                e.preventDefault();
                return;
            }
            
            // Validate confirm password
            if (!confirmPassword) {
                showError('Vui lòng xác nhận mật khẩu mới');
                e.preventDefault();
                return;
            }
            
            if (newPassword !== confirmPassword) {
                showError('Mật khẩu xác nhận không khớp');
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
        document.querySelectorAll('input').forEach(function(input) {
            input.addEventListener('input', function() {
                const errorMessage = document.getElementById('errorMessage');
                errorMessage.classList.remove('show');
            });
        });
    </script>
</body>
</html>
