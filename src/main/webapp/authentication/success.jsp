<%-- 
    Document   : success
    Created on : May 28, 2025, 7:44:23 AM
    Author     : phanh
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Bạn Đã Sẵn Sàng</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            height: 100vh;
            background: linear-gradient(to right, #0f0c29, #302b63, #24243e);
            display: flex;
            justify-content: center;
            align-items: center;
            font-family: 'Segoe UI', sans-serif;
        }

        .container {
            background: rgba(255, 255, 255, 0.05);
            border-radius: 20px;
            padding: 40px 60px;
            text-align: center;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.6);
            backdrop-filter: blur(10px);
        }

        .container h2 {
            font-size: 32px;
            color: white;
            margin-bottom: 30px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }

        .icon {
            font-size: 22px;
            color: #3fa6ff;
        }

        .checkmark {
            width: 100px;
            height: 100px;
            margin: 0 auto 30px;
        }

        .checkmark svg {
            width: 100%;
            height: 100%;
        }

        .btn {
            background: linear-gradient(to right, #6dd5fa, #ff00cc);
            border: none;
            color: white;
            font-size: 16px;
            padding: 10px 30px;
            border-radius: 12px;
            cursor: pointer;
            transition: background 0.3s;
        }

        .btn:hover {
            background: linear-gradient(to right, #4ca1af, #c94bdb);
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>
            <span class="icon">🔷</span>
            Bạn Đã Sẵn Sàng
            <span class="icon">🔷</span>
        </h2>

        <div class="checkmark">
            <svg viewBox="0 0 52 52">
                <circle cx="26" cy="26" r="24" fill="none" stroke="#00cc00" stroke-width="4"/>
                <path d="M16 27 L23 34 L36 19" fill="none" stroke="#00cc00" stroke-width="4" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
        </div>

        <form action="ExploreServlet" method="post">
            <button type="submit" class="btn">Khám Phá Nào</button>
        </form>
    </div>
</body>
</html>



