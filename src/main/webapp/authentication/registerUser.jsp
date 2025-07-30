<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Đăng ký - MasterTicket</title>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: radial-gradient(circle at center, #0f1123 0%, #1f1d40 50%, #5e1763 100%);
                color: white;
                min-height: 100vh;
                position: relative;
                overflow-x: hidden;
            }

            /* Background circles */
            body::before {
                content: '';
                position: fixed;
                top: -200px;
                left: -50px;
                width: 800px;
                height: 800px;
                background: radial-gradient(circle, rgba(162, 89, 247, 0.1) 0%, transparent 70%);
                border-radius: 50%;
                z-index: -1;
                animation: float 6s ease-in-out infinite;
            }

            body::after {
                content: '';
                position: fixed;
                bottom: -400px;
                right: -200px;
                width: 800px;
                height: 800px;
                background: radial-gradient(circle, rgba(79, 172, 254, 0.1) 0%, transparent 70%);
                border-radius: 50%;
                z-index: -1;
                animation: float 8s ease-in-out infinite reverse;
            }

            @keyframes float {
                0% { transform: translateY(0) rotate(0deg); }
                50% { transform: translateY(-20px) rotate(180deg); }
                100% { transform: translateY(0) rotate(360deg); }
            }

            /* Header */
            .header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 20px 50px;
                background: rgba(255, 255, 255, 0.05);
                backdrop-filter: blur(10px);
                border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            }

            .logo {
                font-size: 24px;
                font-weight: bold;
                color: white;
            }

            .search-section {
                display: flex;
                align-items: center;
                gap: 10px;
                flex: 1;
                max-width: 500px;
                margin: 0 50px;
            }

            .search-bar {
                display: flex;
                align-items: center;
                background: rgba(255, 255, 255, 0.1);
                border-radius: 25px;
                padding: 8px 15px;
                flex: 1;
            }

            .search-bar input {
                background: transparent;
                border: none;
                color: white;
                outline: none;
                width: 100%;
                padding: 5px;
            }

            .search-bar input::placeholder {
                color: rgba(255, 255, 255, 0.7);
            }

            .search-icon {
                width: 16px;
                height: 16px;
                margin-right: 8px;
                opacity: 0.7;
            }

            .search-btn {
                background: #666;
                border: none;
                color: white;
                padding: 8px 15px;
                border-radius: 20px;
                cursor: pointer;
                font-size: 14px;
            }

            .auth-btns {
                display: flex;
                gap: 10px;
                align-items: center;
            }

            .auth-btns a {
                padding: 8px 20px;
                border-radius: 20px;
                text-decoration: none;
                font-weight: 500;
                transition: all 0.3s;
                border: 2px solid transparent;
            }

            .auth-btns .signup {
                border-color: #4facfe;
                color: white;
            }

            .auth-btns .login {
                background: linear-gradient(45deg, #a259f7, #d02090);
                color: white;
            }

            /* Navigation */
            .nav {
                display: flex;
                justify-content: center;
                padding: 15px 0;
                background: rgba(255, 255, 255, 0.02);
            }

            .nav a {
                color: white;
                text-decoration: none;
                margin: 0 20px;
                font-size: 14px;
                transition: color 0.3s;
            }

            .nav a:hover {
                color: #a259f7;
            }

            /* Main Content */
            .main-content {
                display: flex;
                justify-content: center;
                align-items: center;
                padding: 50px 20px;
                min-height: calc(100vh - 200px);
            }

            .register-card {
                background: rgba(255, 255, 255, 0.08);
                backdrop-filter: blur(25px);
                border-radius: 25px;
                padding: 50px;
                width: 100%;
                max-width: 950px;
                box-shadow: 0 20px 40px rgba(0, 0, 0, 0.4);
                border: 1px solid rgba(255, 255, 255, 0.1);
            }

            .register-title {
                font-size: 36px;
                font-weight: 400;
                margin-bottom: 40px;
                color: white;
                text-align: center;
                letter-spacing: 1px;
            }

            .register-form {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 25px 40px;
            }

            .form-group {
                display: flex;
                flex-direction: column;
                position: relative;
            }

            .form-group label {
                font-size: 13px;
                color: rgba(255, 255, 255, 0.8);
                margin-bottom: 8px;
                font-weight: 500;
                letter-spacing: 0.5px;
            }

            .form-group input,
            .form-group select {
                background: rgba(255, 255, 255, 0.05);
                border: 1px solid rgba(255, 255, 255, 0.2);
                border-radius: 12px;
                padding: 15px 18px;
                color: white;
                font-size: 15px;
                outline: none;
                transition: all 0.3s ease;
                backdrop-filter: blur(10px);
            }

            .form-group input:focus,
            .form-group select:focus {
                border-color: #a259f7;
                background: rgba(255, 255, 255, 0.08);
                box-shadow: 0 0 0 3px rgba(162, 89, 247, 0.1);
            }

            .form-group input::placeholder {
                color: rgba(255, 255, 255, 0.4);
                font-weight: 300;
            }

            .form-group select {
                cursor: pointer;
                appearance: none;
                background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 20 20'%3e%3cpath stroke='%23ffffff' stroke-linecap='round' stroke-linejoin='round' stroke-width='1.5' d='m6 8 4 4 4-4'/%3e%3c/svg%3e");
                background-repeat: no-repeat;
                background-position: right 15px center;
                background-size: 16px;
                padding-right: 45px;
            }

            .form-group select option {
                background: #1f1d40;
                color: white;
                padding: 10px;
            }

            .submit-section {
                grid-column: span 2;
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-top: 35px;
                padding-top: 25px;
                border-top: 1px solid rgba(255, 255, 255, 0.1);
            }

            .submit-btn {
                background: linear-gradient(135deg, #4facfe 0%, #a259f7 100%);
                border: none;
                color: white;
                padding: 16px 40px;
                border-radius: 30px;
                font-size: 16px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                letter-spacing: 0.5px;
                box-shadow: 0 8px 25px rgba(79, 172, 254, 0.3);
            }

            .submit-btn:hover {
                transform: translateY(-3px);
                box-shadow: 0 12px 35px rgba(162, 89, 247, 0.4);
                background: linear-gradient(135deg, #3a9bfe 0%, #8f4af7 100%);
            }

            .submit-btn:active {
                transform: translateY(-1px);
            }

            .login-link {
                color: rgba(255, 255, 255, 0.7);
                font-size: 14px;
                font-weight: 400;
            }

            .login-link a {
                color: #a259f7;
                text-decoration: none;
                font-weight: 600;
            }

            /* Password Requirements */
            .password-requirements {
                margin-top: 8px;
                padding: 12px;
                background: rgba(255, 255, 255, 0.05);
                border-radius: 8px;
                border: 1px solid rgba(255, 255, 255, 0.1);
            }

            .password-requirements small {
                color: rgba(255, 255, 255, 0.7);
                font-size: 12px;
                display: block;
                margin-bottom: 8px;
            }

            .password-requirements ul {
                list-style: none;
                margin: 0;
                padding: 0;
            }

            .password-requirements li {
                font-size: 11px;
                color: rgba(255, 255, 255, 0.6);
                margin-bottom: 4px;
                transition: color 0.3s ease;
            }

            .password-requirements li.valid {
                color: #4facfe;
            }

            .password-requirements li.invalid {
                color: #ff6b6b;
            }

            .login-link a:hover {
                color: #8f4af7;
                text-decoration: underline;
            }

            /* Footer */
            .footer {
                background: rgba(0, 0, 0, 0.3);
                padding: 40px 50px;
                margin-top: auto;
            }

            .footer-content {
                display: grid;
                grid-template-columns: 1fr 1fr 1fr;
                gap: 40px;
                max-width: 1200px;
                margin: 0 auto;
            }

            .footer-section h3 {
                font-size: 16px;
                margin-bottom: 15px;
                color: white;
            }

            .footer-section a {
                color: rgba(255, 255, 255, 0.7);
                text-decoration: none;
                display: block;
                margin-bottom: 8px;
                font-size: 14px;
                transition: color 0.3s;
            }

            .footer-section a:hover {
                color: #a259f7;
            }

            .footer-section p {
                color: rgba(255, 255, 255, 0.7);
                font-size: 14px;
                margin-bottom: 8px;
            }

            .email-input {
                display: flex;
                align-items: center;
                background: rgba(255, 255, 255, 0.1);
                border-radius: 25px;
                padding: 8px 15px;
                margin-bottom: 15px;
            }

            .email-input input {
                background: transparent;
                border: none;
                color: white;
                outline: none;
                flex: 1;
                padding: 5px;
            }

            .email-input input::placeholder {
                color: rgba(255, 255, 255, 0.5);
            }

            .email-icon {
                width: 16px;
                height: 16px;
                margin-right: 8px;
                color: #4facfe;
            }

            .send-icon {
                width: 16px;
                height: 16px;
                color: #4facfe;
                cursor: pointer;
            }

            .flag-icons {
                display: flex;
                gap: 10px;
                margin-bottom: 15px;
            }

            .flag {
                width: 24px;
                height: 16px;
                border-radius: 2px;
                cursor: pointer;
            }

            .social-icons {
                display: flex;
                gap: 10px;
            }

            .social-icon {
                width: 32px;
                height: 32px;
                background: rgba(255, 255, 255, 0.1);
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                cursor: pointer;
                transition: background 0.3s;
            }

            .social-icon:hover {
                background: #a259f7;
            }

            /* Error message */
            .error-message {
                color: #ff4d4d;
                font-size: 14px;
                grid-column: span 2;
                margin-bottom: 15px;
            }

            /* Responsive */
            @media (max-width: 768px) {
                .header {
                    padding: 15px 20px;
                    flex-direction: column;
                    gap: 15px;
                }

                .search-section {
                    margin: 0;
                    max-width: 100%;
                }

                .register-form {
                    grid-template-columns: 1fr;
                }

                .submit-section {
                    grid-column: span 1;
                    flex-direction: column;
                    gap: 15px;
                }

                .footer-content {
                    grid-template-columns: 1fr;
                    gap: 30px;
                }
            }
        </style>
    </head>
    <body>
        <!-- Header -->
        <header class="header">
            <div class="logo">
                <a href="${pageContext.request.contextPath}/home" style="color: white; text-decoration: none;">MasterTicket</a>
            </div>
            
            <div class="search-section">
                <div class="search-bar">
                    <svg class="search-icon" fill="currentColor" viewBox="0 0 20 20">
                        <path fill-rule="evenodd" d="M8 4a4 4 0 100 8 4 4 0 000-8zM2 8a6 6 0 1110.89 3.476l4.817 4.817a1 1 0 01-1.414 1.414l-4.816-4.816A6 6 0 012 8z" clip-rule="evenodd"></path>
                    </svg>
                    <input type="text" placeholder="Bạn tìm gì hôm nay ?">
                </div>
                <button class="search-btn">Tìm kiếm</button>
            </div>
            
            <div class="auth-btns">
                <a href="${pageContext.request.contextPath}/authentication/register.jsp" class="signup">Đăng ký</a>
                <a href="${pageContext.request.contextPath}/authentication/login.jsp" class="login">Đăng nhập</a>
            </div>
        </header>

        <!-- Navigation -->
        <nav class="nav">
            <a href="${pageContext.request.contextPath}/home">Trang Chủ</a>
            <a href="#">Các sự kiện hot</a>
            <a href="#">Săn voucher giảm giá</a>
            <a href="#">Tạo sự kiện</a>
            <a href="#">Hỗ trợ</a>
        </nav>

        <!-- Main Content -->
        <main class="main-content">
            <div class="register-card">
                <h2 class="register-title">Đăng Ký</h2>

                <!-- Hiển thị lỗi nếu có -->
                <c:if test="${not empty error}">
                    <div class="error-message">${error}</div>
                </c:if>

                <form action="${pageContext.request.contextPath}/register" method="post" class="register-form">
                    <div class="form-group">
                        <label for="name">Họ và tên</label>
                        <input type="text" id="name" name="name" placeholder="Vui lòng nhập họ và tên" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="email">Email</label>
                        <input type="email" id="email" name="email" placeholder="Vui lòng nhập email" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="gender">Giới tính</label>
                        <select id="gender" name="gender" required>
                            <option value="" disabled selected>Chọn giới tính</option>
                            <option value="male">Nam</option>
                            <option value="female">Nữ</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="password">Mật khẩu</label>
                        <input type="password" id="password" name="password" placeholder="Nhập mật khẩu" required>
                        <div class="password-requirements">
                            <small>Mật khẩu phải có:</small>
                            <ul>
                                <li id="length-check">❌ Ít nhất 8 ký tự</li>
                                <li id="uppercase-check">❌ Ít nhất 1 ký tự viết hoa</li>
                                <li id="special-check">❌ Ít nhất 1 ký tự đặc biệt</li>
                            </ul>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="phone">Số điện thoại</label>
                        <input type="text" id="phone" name="phone" placeholder="Nhập số điện thoại" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="confirmPassword">Xác nhận mật khẩu</label>
                        <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Nhập lại mật khẩu" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="dob">Ngày sinh</label>
                        <input type="text" id="dob" name="dob" placeholder="dd/MM/yyyy" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="country">Quốc gia</label>
                        <input type="text" id="country" name="country" placeholder="Nhập quốc gia" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="language">Ngôn ngữ</label>
                        <input type="text" id="language" name="language" placeholder="Nhập ngôn ngữ" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="address">Địa chỉ</label>
                        <input type="text" id="address" name="address" placeholder="Nhập địa chỉ" required>
                    </div>

                    <div class="submit-section">
                        <button class="submit-btn" type="submit">Đăng Ký »</button>
                        <div class="login-link">
                            Đã có tài khoản trước đó ? <a href="${pageContext.request.contextPath}/authentication/login.jsp">Đăng nhập</a>
                        </div>
                    </div>
                </form>
            </div>
        </main>

        <!-- Footer -->
        <footer class="footer">
            <div class="footer-content">
                <div class="footer-section">
                    <h3>Customer Services</h3>
                    <a href="#">FAQS</a>
                    <a href="#">Contact us</a>
                    <a href="#">Pricy Policy</a>
                    <a href="#">Terms of Service</a>
                    <p>Email: <span style="color: #4facfe;">📧 support@masterTicket.vn</span></p>
                </div>
                
                <div class="footer-section">
                    <h3>SiteMap</h3>
                    <a href="#">Create Account</a>
                    <a href="#">News</a>
                    <a href="#">Top-Rated Event</a>
                </div>
                
                <div class="footer-section">
                    <h3>Subscribe for event updates.</h3>
                    <div class="email-input">
                        <span class="email-icon">📧</span>
                        <input type="email" placeholder="Your email...">
                        <span class="send-icon">✈️</span>
                    </div>
                    
                    <h3>Language:</h3>
                    <div class="flag-icons">
                        <div class="flag" style="background: linear-gradient(to bottom, #da251d 50%, #ffff00 50%);"></div>
                        <div class="flag" style="background: linear-gradient(to bottom, #012169 50%, #ffffff 50%, #ffffff 75%, #c8102e 75%);"></div>
                    </div>
                    
                    <h3>Follow us:</h3>
                    <div class="social-icons">
                        <div class="social-icon">📘</div>
                        <div class="social-icon">📷</div>
                        <div class="social-icon">🎵</div>
                    </div>
                </div>
            </div>
        </footer>

        <script>
            // Password validation
            const passwordInput = document.getElementById('password');
            const confirmPasswordInput = document.getElementById('confirmPassword');
            
            function validatePassword(password) {
                const lengthCheck = document.getElementById('length-check');
                const uppercaseCheck = document.getElementById('uppercase-check');
                const specialCheck = document.getElementById('special-check');
                
                // Length check
                if (password.length >= 8) {
                    lengthCheck.textContent = '✅ Ít nhất 8 ký tự';
                    lengthCheck.className = 'valid';
                } else {
                    lengthCheck.textContent = '❌ Ít nhất 8 ký tự';
                    lengthCheck.className = 'invalid';
                }
                
                // Uppercase check
                if (/[A-Z]/.test(password)) {
                    uppercaseCheck.textContent = '✅ Ít nhất 1 ký tự viết hoa';
                    uppercaseCheck.className = 'valid';
                } else {
                    uppercaseCheck.textContent = '❌ Ít nhất 1 ký tự viết hoa';
                    uppercaseCheck.className = 'invalid';
                }
                
                // Special character check
                if (/[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(password)) {
                    specialCheck.textContent = '✅ Ít nhất 1 ký tự đặc biệt';
                    specialCheck.className = 'valid';
                } else {
                    specialCheck.textContent = '❌ Ít nhất 1 ký tự đặc biệt';
                    specialCheck.className = 'invalid';
                }
            }
            
            function validateConfirmPassword() {
                const password = passwordInput.value;
                const confirmPassword = confirmPasswordInput.value;
                
                if (confirmPassword && password !== confirmPassword) {
                    confirmPasswordInput.setCustomValidity('Mật khẩu xác nhận không khớp');
                } else {
                    confirmPasswordInput.setCustomValidity('');
                }
            }
            
            // Event listeners
            passwordInput.addEventListener('input', function() {
                validatePassword(this.value);
            });
            
            confirmPasswordInput.addEventListener('input', validateConfirmPassword);
            
            // Form validation
            document.querySelector('form').addEventListener('submit', function(e) {
                const password = passwordInput.value;
                const confirmPassword = confirmPasswordInput.value;
                
                // Check password requirements
                if (password.length < 8) {
                    e.preventDefault();
                    alert('Mật khẩu phải có ít nhất 8 ký tự');
                    return;
                }
                
                if (!/[A-Z]/.test(password)) {
                    e.preventDefault();
                    alert('Mật khẩu phải có ít nhất 1 ký tự viết hoa');
                    return;
                }
                
                if (!/[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(password)) {
                    e.preventDefault();
                    alert('Mật khẩu phải có ít nhất 1 ký tự đặc biệt');
                    return;
                }
                
                if (password !== confirmPassword) {
                    e.preventDefault();
                    alert('Mật khẩu xác nhận không khớp');
                    return;
                }
            });
        </script>
    </body>
</html>
