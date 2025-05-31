<%-- 
    Document   : change_password
    Created on : May 28, 2025, 8:18:57 PM
    Author     : phanh
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Change Password</title>
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

        .form-box {
            background: rgba(255,255,255,0.05);
            padding: 40px;
            border-radius: 20px;
            color: white;
            backdrop-filter: blur(10px);
            width: 350px;
        }

        .form-box h2 {
            font-size: 36px;
                font-weight: 400;
                margin-bottom: 30px;
                margin-top: 0;
                text-align: left;
        }

        .form-box input {
            width: 100%;
            padding: 12px;
            margin-bottom: 20px;
            background: rgba(255,255,255,0.1);
            border: none;
            border-radius: 10px;
            color: white;
        }

        .form-box button {
            width: 100%;
            padding: 12px;
            background: linear-gradient(to right, #4facfe, #9b59b6);
            border: none;
            border-radius: 10px;
            color: white;
            font-weight: bold;
            cursor: pointer;
        }

        .message {
            color: yellow;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <div class="form-box">
        <h2>Change Password</h2>
        <form action="ChangePasswordServlet" method="post">
            <input type="text" name="email" placeholder="Your email" required />
            <input type="password" name="oldPass" placeholder="Old password" required />
            <input type="password" name="newPass" placeholder="New password" required />
            <button type="submit">Change Password</button>
        </form>
        <div class="message">${requestScope.message}</div>
    </div>
</body>
</html>

