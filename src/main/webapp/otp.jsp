<%-- 
    Document   : otp
    Created on : May 28, 2025, 7:43:36 AM
    Author     : phanh
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Nhập mã OTP</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(135deg, #0f0c29, #302b63, #24243e);
        }

        .otp-container {
            background: rgba(0, 0, 0, 0.4);
            border-radius: 20px;
            padding: 40px;
            width: 500px;
            text-align: center;
            box-shadow: 0 0 20px rgba(0,0,0,0.6);
            backdrop-filter: blur(10px);
        }

        .otp-container h2 {
            color: white;
            margin-bottom: 20px;
            font-size: 32px;
        }

        .otp-container p {
            color: #ccc;
            margin-bottom: 30px;
            font-size: 16px;
        }

        .otp-inputs {
            display: flex;
            justify-content: center;
            gap: 20px;
            margin-bottom: 30px;
        }

        .otp-inputs input {
            width: 60px;
            height: 70px;
            font-size: 32px;
            text-align: center;
            border: none;
            border-radius: 12px;
            background-color: rgba(255, 255, 255, 0.1);
            color: white;
            transition: 0.2s ease;
        }

        .otp-inputs input:focus {
            outline: none;
            background-color: rgba(255, 255, 255, 0.25);
        }

        button {
            background: linear-gradient(to right, #6dd5fa, #2980b9);
            border: none;
            color: white;
            font-size: 18px;
            padding: 10px 40px;
            border-radius: 25px;
            cursor: pointer;
            transition: background 0.3s;
        }

        button:hover {
            background: linear-gradient(to right, #4ca1af, #2c3e50);
        }

        .otp-container a {
            color: #ff00cc;
            text-decoration: none;
            margin-left: 5px;
        }

        .bottom-text {
            margin-top: 20px;
            color: #ccc;
            font-size: 14px;
        }
    </style>
</head>
<body>
<div class="otp-container">
    <h2>Nhập mã OTP</h2>
    <p>Vui lòng kiểm tra email và nhập mã xác thực:</p>
    <form action="OtpServlet" method="post">
        <div class="otp-inputs">
            <input type="text" name="digit1" maxlength="1" required>
            <input type="text" name="digit2" maxlength="1" required>
            <input type="text" name="digit3" maxlength="1" required>
            <input type="text" name="digit4" maxlength="1" required>
            <input type="text" name="digit5" maxlength="1" required>
        </div>
        <button type="submit">Xác Nhận</button>
    </form>
    <div class="bottom-text">
        Đã có tài khoản trước đó? <a href="login.jsp">Đăng nhập</a>
    </div>
</div>
</body>
</html>


