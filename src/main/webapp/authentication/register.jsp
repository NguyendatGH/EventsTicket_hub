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
            background: linear-gradient(135deg, #0f1123, #1f1d40, #5e1763);
            background-size: cover;
            background-repeat: no-repeat;
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
            font-size: 32px;
            font-weight: 300;
            margin-bottom: 30px;
            text-align: center;
            width: 100%;
            color: white;
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
            width: 32px;
            height: 32px;
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
            <svg class="icon" fill="none" stroke="currentColor" stroke-width="1.5" viewBox="0 0 24 24"
                 xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
                <path stroke-linecap="round" stroke-linejoin="round"
                      d="M15.75 6a3.75 3.75 0 11-7.5 0 3.75 3.75 0 017.5 0zM4.501 20.118a7.5 7.5 0 0114.998 0A17.933 17.933 0 0112 21.75c-2.676 0-5.216-.584-7.499-1.632z"/>
            </svg>
            Người Dùng Mới
        </button>
        <button class="button" name="role" value="organizer">
            <svg class="icon" fill="none" stroke="currentColor" stroke-width="1.5" viewBox="0 0 24 24"
                 xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
                <path stroke-linecap="round" stroke-linejoin="round"
                      d="M17.25 6.75a3 3 0 11-6 0 3 3 0 016 0zM20.25 12.75a2.25 2.25 0 11-4.5 0 2.25 2.25 0 014.5 0zM3.75 6.75a3 3 0 106 0 3 3 0 00-6 0zM7.5 12.75a2.25 2.25 0 11-4.5 0 2.25 2.25 0 014.5 0zM12 14.25c-2.485 0-4.5 2.015-4.5 4.5v.75h9v-.75c0-2.485-2.015-4.5-4.5-4.5z"/>
            </svg>
            Tổ Chức Sự Kiện
        </button>
    </form>
    <div class="login-link">
        Đã có tài khoản trước đó ? <a href="/authentication/login.jsp">Đăng nhập</a>
    </div>
</div>
</body>
</html>


