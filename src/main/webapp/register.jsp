<%-- 
    Document   : register
    Created on : May 27, 2025, 9:52:53 PM
    Author     : phanh
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chọn loại người dùng</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
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
            padding: 50px 40px;
            box-shadow: 0 0 30px rgba(0, 0, 0, 0.6);
            text-align: center;
            width: 500px;
        }

        h2 {
            font-size: 36px;
            margin-bottom: 40px;
        }

        .option-buttons {
            display: flex;
            justify-content: space-around;
            margin-bottom: 30px;
        }

        .button {
            background-color: rgba(255, 255, 255, 0.1);
            border: none;
            color: white;
            padding: 20px 30px;
            border-radius: 12px;
            cursor: pointer;
            font-size: 18px;
            width: 200px;
            transition: 0.3s;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .button:hover {
            background-color: rgba(255, 255, 255, 0.2);
        }

        .icon {
            font-size: 30px;
            margin-bottom: 10px;
        }

        .login-link {
            font-size: 15px;
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
    <h2>Bạn Là ?</h2>
    <form action="signupOption" method="post" class="option-buttons">
        <button class="button" name="role" value="user">
            <div class="icon">👤</div>
            Người Dùng Mới
        </button>
        <button class="button" name="role" value="organizer">
            <div class="icon">👥</div>
            Tổ Chức Sự Kiện
        </button>
    </form>
    <div class="login-link">
        Đã có tài khoản trước đó ? <a href="login.jsp">Đăng nhập</a>
    </div>
</div>
</body>
</html>

