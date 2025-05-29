<%-- 
    Document   : registerUser
    Created on : May 27, 2025, 10:02:16 PM
    Author     : phanh
--%>

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
            font-size: 36px;
            margin-bottom: 40px;
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
            color: #aaa;
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
    </style>
</head>
<body>
<div class="container">
    <h2>Đăng Ký</h2>
    <form action="registerUser" method="post">
        <input type="email" name="email" placeholder="Vui lòng nhập email" required>
        <input type="text" name="gender" placeholder="Giới tính" required>
        <input type="password" name="password" placeholder="Mật khẩu" required>
        <input type="text" name="phone" placeholder="Số điện thoại" required>
        <input type="password" name="confirmPassword" placeholder="Xác nhận mật khẩu" required>
        <input type="text" name="dob" placeholder="dd/MM/yyyy" required>
        <input type="text" name="country" placeholder="Quốc gia" required>
        <input type="text" name="language" placeholder="Ngôn ngữ" required>
        
        <div class="full-width">
            <button class="submit-button" type="submit">Đăng Ký ➤</button>
        </div>

        <div class="login-link">
            Đã có tài khoản trước đó ? <a href="login.jsp">Đăng nhập</a>
        </div>
    </form>
</div>
</body>
</html>


