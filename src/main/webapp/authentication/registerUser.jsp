<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Đăng ký Người Dùng</title>
        <style>
            body {
                margin: 0;
                padding: 0;
                font-family: 'Segoe UI', sans-serif;
                background: radial-gradient(circle at left top, #000428, #2c003e);
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
                color: white;
            }

            .container {
                background: rgba(255, 255, 255, 0.05);
                backdrop-filter: blur(20px);
                border-radius: 20px;
                padding: 50px 60px;
                box-shadow: 0 0 30px rgba(0, 0, 0, 0.6);
                width: 850px;
            }

            h2 {
                font-size: 32px;
                font-weight: 300;
                margin-bottom: 30px;
                text-align: left;
                width: 100%;
                color: white;
            }

            form {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 20px 40px;
            }

            input {
                background: transparent;
                border: none;
                border-bottom: 1px solid #bbb;
                padding: 10px 5px;
                font-size: 16px;
                color: white;
                width: 100%;
            }

            input::placeholder {
                color: rgba(255, 255, 255, 0.25);
            }

            .full-width {
                grid-column: span 2;
                text-align: left;
            }

            .submit-button {
                background: linear-gradient(to right, #4facfe, #d02090);
                border: none;
                color: white;
                padding: 12px 25px;
                border-radius: 10px;
                font-size: 16px;
                cursor: pointer;
                transition: 0.3s;
            }

            .submit-button:hover {
                opacity: 0.9;
            }

            .login-link {
                margin-top: 25px;
                text-align: right;
                font-size: 14px;
                grid-column: span 2;
            }

            .login-link a {
                color: magenta;
                text-decoration: none;
            }

            .login-link a:hover {
                text-decoration: underline;
            }

            .error-message {
                color: #ff4d4d;
                font-size: 14px;
                grid-column: span 2;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h2>Đăng Ký</h2>

            <!-- Hiển thị lỗi nếu có -->
            <c:if test="${not empty error}">
                <div class="error-message">${error}</div>
            </c:if>

            <form action="register" method="post">
                <input type="email" name="email" placeholder="Vui lòng nhập email" required>
                <select name="gender" required>
                    <option value="" disabled selected>Chọn giới tính</option>
                    <option value="male">Nam</option>
                    <option value="female">Nữ</option>
                </select>
                <input type="password" name="password" placeholder="Mật khẩu" required>
                <input type="text" name="phone" placeholder="Số điện thoại" required>
                <input type="password" name="confirmPassword" placeholder="Xác nhận mật khẩu" required>
                <input type="text" name="dob" placeholder="Ngày sinh (dd/MM/yyyy)" required>
                <input type="text" name="address" placeholder="Địa chỉ" required>

                <div class="full-width">
                    <button class="submit-button" type="submit">Đăng Ký ➤</button>
                </div>

                <div class="login-link">
                    Đã có tài khoản? <a href="login.jsp">Đăng nhập</a>
                </div>
            </form>
        </div>
    </body>
</html>
