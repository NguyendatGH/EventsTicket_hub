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
            background: linear-gradient(135deg, #000428, #2c003e, #360033);
        }

        .otp-container {
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(25px);
            border-radius: 20px;
            padding: 50px 40px;
            width: 500px;
            text-align: center;
            box-shadow: 0 0 40px rgba(0, 0, 0, 0.6);
        }

        .otp-container h2 {
            color: white;
            font-size: 36px;
            font-weight: 400;
            margin-bottom: 25px;
        }

        .otp-container p {
            color: #ccc;
            font-size: 15px;
            margin-bottom: 30px;
        }

        .otp-inputs {
            display: flex;
            justify-content: center;
            gap: 20px;
            margin-bottom: 35px;
        }

        .otp-inputs input {
            width: 60px;
            height: 70px;
            font-size: 32px;
            text-align: center;
            border: none;
            border-radius: 12px;
            background-color: rgba(255, 255, 255, 0.08);
            color: white;
            transition: 0.2s ease;
        }

        .otp-inputs input:focus {
            outline: none;
            background-color: rgba(255, 255, 255, 0.2);
        }

        button {
            background: linear-gradient(to right, #64f3ff, #e74cfa);
            border: none;
            color: white;
            font-size: 18px;
            padding: 10px 40px;
            border-radius: 20px;
            cursor: pointer;
            transition: 0.3s ease;
        }

        button:hover {
            opacity: 0.9;
        }

        .bottom-text {
            margin-top: 25px;
            color: #ccc;
            font-size: 14px;
        }

        .bottom-text a {
            color: #ff00cc;
            text-decoration: none;
        }

        .bottom-text a:hover {
            text-decoration: underline;
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



