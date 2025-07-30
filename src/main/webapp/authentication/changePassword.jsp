<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dto.UserDTO" %>
<%
    UserDTO user = (UserDTO) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("authentication/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đổi mật khẩu - MasterTicket</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
            background: linear-gradient(135deg, #1a1c2e 0%, #2d1b69 50%, #8b5a8c 100%);
            min-height: 100vh;
            color: #ffffff;
            overflow-x: hidden;
        }

        /* Header */
        .header {
            background: rgba(26, 28, 46, 0.95);
            backdrop-filter: blur(10px);
            padding: 15px 0;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .nav-container {
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0 20px;
        }

        .logo {
            font-size: 24px;
            font-weight: bold;
            color: #ffffff;
            text-decoration: none;
        }

        .search-container {
            display: flex;
            align-items: center;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 25px;
            padding: 8px 16px;
            min-width: 300px;
        }

        .search-input {
            background: none;
            border: none;
            color: #ffffff;
            outline: none;
            flex: 1;
            padding: 5px 10px;
            font-size: 14px;
        }

        .search-input::placeholder {
            color: rgba(255, 255, 255, 0.6);
        }

        .search-btn {
            background: #6366f1;
            border: none;
            color: white;
            padding: 8px 16px;
            border-radius: 20px;
            margin-left: 10px;
            cursor: pointer;
            font-size: 14px;
            transition: all 0.3s ease;
        }

        .search-btn:hover {
            background: #4f46e5;
        }

        .auth-buttons {
            display: flex;
            gap: 10px;
        }

        .btn-register, .btn-login {
            padding: 8px 20px;
            border-radius: 20px;
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .btn-register {
            background: transparent;
            color: #ffffff;
            border: 1px solid rgba(255, 255, 255, 0.3);
        }

        .btn-login {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: #ffffff;
            border: none;
        }

        .btn-register:hover {
            background: rgba(255, 255, 255, 0.1);
        }

        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.3);
        }

        .nav-menu {
            display: flex;
            gap: 30px;
            margin-left: 40px;
        }

        .nav-menu a {
            color: rgba(255, 255, 255, 0.8);
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
            transition: color 0.3s ease;
        }

        .nav-menu a:hover {
            color: #ffffff;
        }

        /* Main Content */
        .main-container {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: calc(100vh - 80px);
            padding: 40px 20px;
        }

        .change-password-card {
            background: rgba(26, 28, 46, 0.9);
            backdrop-filter: blur(20px);
            border-radius: 20px;
            padding: 40px;
            width: 100%;
            max-width: 450px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            border: 1px solid rgba(255, 255, 255, 0.1);
            position: relative;
            overflow: hidden;
        }

        .change-password-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 3px;
            background: linear-gradient(90deg, #667eea, #764ba2, #f093fb);
        }

        .card-header {
            text-align: center;
            margin-bottom: 30px;
        }

        .card-title {
            font-size: 28px;
            font-weight: 700;
            color: #ffffff;
            margin-bottom: 8px;
        }

        .card-subtitle {
            color: rgba(255, 255, 255, 0.6);
            font-size: 14px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-label {
            display: block;
            color: #ffffff;
            font-size: 14px;
            font-weight: 500;
            margin-bottom: 8px;
        }

        .form-input {
            width: 100%;
            padding: 14px 16px;
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 12px;
            color: #ffffff;
            font-size: 14px;
            transition: all 0.3s ease;
            outline: none;
        }

        .form-input:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.2);
            background: rgba(255, 255, 255, 0.15);
        }

        .form-input::placeholder {
            color: rgba(255, 255, 255, 0.5);
        }

        .submit-btn {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 12px;
            color: #ffffff;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-top: 10px;
        }

        .submit-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 15px 35px rgba(102, 126, 234, 0.4);
        }

        .submit-btn:active {
            transform: translateY(0);
        }

        .message {
            margin-top: 20px;
            padding: 12px 16px;
            border-radius: 12px;
            font-size: 14px;
            text-align: center;
        }

        .message.error {
            background: rgba(239, 68, 68, 0.1);
            border: 1px solid rgba(239, 68, 68, 0.3);
            color: #fca5a5;
        }

        .message.success {
            background: rgba(34, 197, 94, 0.1);
            border: 1px solid rgba(34, 197, 94, 0.3);
            color: #86efac;
        }

        .back-link {
            text-align: center;
            margin-top: 25px;
            padding-top: 20px;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
        }

        .back-link a {
            color: #667eea;
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s ease;
        }

        .back-link a:hover {
            color: #4f46e5;
            transform: translateX(-3px);
        }

        /* Responsive */
        @media (max-width: 768px) {
            .nav-container {
                flex-direction: column;
                gap: 15px;
                padding: 15px;
            }

            .search-container {
                min-width: 250px;
            }

            .nav-menu {
                margin-left: 0;
                gap: 20px;
            }

            .change-password-card {
                padding: 30px 20px;
                margin: 20px;
            }

            .card-title {
                font-size: 24px;
            }
        }

        /* Floating particles effect */
        .particle {
            position: absolute;
            width: 4px;
            height: 4px;
            background: rgba(102, 126, 234, 0.3);
            border-radius: 50%;
            animation: float 6s ease-in-out infinite;
        }
        
        /* User Menu */
            .user-menu {
                display: flex;
                align-items: center;
                gap: 1rem;
                position: relative;
            }

            .user-info {
                display: flex;
                align-items: center;
                gap: 0.5rem;
                cursor: pointer;
                padding: 0.5rem 1rem;
                border-radius: 25px;
                background: rgba(255, 255, 255, 0.1);
                transition: all 0.3s;
            }

            .user-info:hover {
                background: rgba(255, 255, 255, 0.15);
            }

            .user-avatar {
                width: 35px;
                height: 35px;
                border-radius: 50%;
                background: linear-gradient(45deg, #ff6b6b, #4ecdc4);
                display: flex;
                align-items: center;
                justify-content: center;
                font-weight: bold;
                font-size: 0.9rem;
            }

            .user-dropdown {
                position: absolute;
                top: 100%;
                right: 0;
                background: rgba(0, 0, 0, 0.9);
                backdrop-filter: blur(10px);
                border-radius: 10px;
                padding: 1rem;
                min-width: 200px;
                border: 1px solid rgba(255, 255, 255, 0.1);
                opacity: 0;
                visibility: hidden;
                transform: translateY(-10px);
                transition: all 0.3s;
            }

            .user-dropdown.show {
                opacity: 1;
                visibility: visible;
                transform: translateY(0);
            }

            .dropdown-item {
                display: block;
                color: white;
                text-decoration: none;
                padding: 0.5rem 0;
                border-bottom: 1px solid rgba(255, 255, 255, 0.1);
                transition: color 0.3s;
            }

            .dropdown-item:last-child {
                border-bottom: none;
            }

            .dropdown-item:hover {
                color: #ff6b6b;
            }

        @keyframes float {
            0%, 100% { transform: translateY(0px) rotate(0deg); opacity: 0.7; }
            50% { transform: translateY(-20px) rotate(180deg); opacity: 1; }
        }
    </style>
</head>
<body>
    <!-- Header -->
    <header class="header">
        <div class="nav-container">
            <a href="#" class="logo">MasterTicket</a>
            
            <div class="nav-menu">
                <a href="${pageContext.request.contextPath}/">Trang Chủ</a>
            </div>

            <div class="search-container">
                <input type="text" class="search-input" placeholder="Bạn tìm gì hôm nay ?">
                <button class="search-btn">Tìm kiếm</button>
            </div>

            <div class="user-menu">
                    <div class="user-info" onclick="toggleUserDropdown()">
                        👤 Xin chào, <%= user.getEmail() %> <span style="margin-left: 0.5rem;">▼</span>
                    </div>
                    <div class="user-dropdown" id="userDropdown">
                        <a href="updateProfile" class="dropdown-item">👤 Thông tin cá nhân</a>
                        <a href="#tickets" class="dropdown-item">🎫 Vé đã mua</a>
                        <a href="#favorites" class="dropdown-item">❤️ Sự kiện yêu thích</a>
                        <a href="#settings" class="dropdown-item">⚙️ Cài đặt</a>
                        <hr style="border: none; border-top: 1px solid rgba(255,255,255,0.1); margin: 0.5rem 0;">
                        <a href="LogoutServlet" class="dropdown-item" style="color: #ff6b6b;">🚪 Đăng xuất</a>
                    </div>
                </div>
        </div>
    </header>

    <!-- Main Content -->
    <div class="main-container">
        <div class="change-password-card">
            <!-- Floating particles -->
            <div class="particle" style="top: 20%; left: 10%; animation-delay: 0s;"></div>
            <div class="particle" style="top: 80%; right: 10%; animation-delay: 2s;"></div>
            <div class="particle" style="top: 40%; right: 20%; animation-delay: 4s;"></div>
            
            <div class="card-header">
                <h2 class="card-title">Đổi mật khẩu</h2>
                <p class="card-subtitle">Cập nhật mật khẩu để bảo vệ tài khoản của bạn</p>
            </div>

            <form action="changePassword" method="post">
                <div class="form-group">
                    <label class="form-label" for="currentPassword">Mật khẩu hiện tại</label>
                    <input type="password" id="currentPassword" name="currentPassword" class="form-input" placeholder="Nhập mật khẩu hiện tại" required>
                </div>

                <div class="form-group">
                    <label class="form-label" for="newPassword">Mật khẩu mới</label>
                    <input type="password" id="newPassword" name="newPassword" class="form-input" placeholder="Nhập mật khẩu mới" required>
                </div>

                <div class="form-group">
                    <label class="form-label" for="confirmPassword">Xác nhận mật khẩu mới</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" class="form-input" placeholder="Nhập lại mật khẩu mới" required>
                </div>

                <button type="submit" class="submit-btn">Cập nhật mật khẩu</button>
            </form>

            <!-- Messages -->
            <% if (request.getAttribute("changePasswordError") != null) { %>
                <div class="message error">
                    <%= request.getAttribute("changePasswordError") %>
                </div>
            <% } %>
            
            <% if (request.getAttribute("changePasswordMessage") != null) { %>
                <div class="message success">
                    <%= request.getAttribute("changePasswordMessage") %>
                </div>
            <% } %>

            <div class="back-link">
                <a href="updateProfile">
                    <span>←</span>
                    Quay lại hồ sơ
                </a>
            </div>
        </div>
    </div>

    <script>
        // Add some interactive effects
        document.querySelectorAll('.form-input').forEach(input => {
            input.addEventListener('focus', function() {
                this.parentElement.style.transform = 'translateY(-2px)';
            });
            
            input.addEventListener('blur', function() {
                this.parentElement.style.transform = 'translateY(0)';
            });
        });

        // Form validation
        document.querySelector('form').addEventListener('submit', function(e) {
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            if (newPassword !== confirmPassword) {
                e.preventDefault();
                alert('Mật khẩu mới và xác nhận mật khẩu không khớp!');
            }
            
            if (newPassword.length < 6) {
                e.preventDefault();
                alert('Mật khẩu mới phải có ít nhất 6 ký tự!');
            }
        });
    </script>
</body>
</html>