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
            font-family: "Segoe UI", sans-serif;
            background: linear-gradient(120deg, #0f2027, #203a43, #2c5364);
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
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
            margin-bottom: 20px;
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

