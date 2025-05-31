<%-- 
    Document   : forgot_password
    Created on : May 28, 2025, 8:23:35 PM
    Author     : phanh
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Forgot Password</title>
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

        .box {
            background: rgba(255, 255, 255, 0.1);
            padding: 30px;
            border-radius: 15px;
            width: 300px;
            backdrop-filter: blur(10px);
        }

        .box h2 {
            margin: 0 0 20px 0;
            font-size: 28px;
            font-weight: normal;
            color: white;
        }

        input[type=email], button {
            width: 100%;
            padding: 10px;
            margin-top: 15px;
            border-radius: 8px;
            border: none;
        }

        button {
            width: 100%;
            padding: 12px;
            background: linear-gradient(to right, #4facfe, #9b59b6);
            border: none;
            border-radius: 10px;
            color: white;
            font-weight: bold;
            cursor: pointer;
        }

        a {
            display: inline-block;
            margin-top: 15px;
            color: #ccc;
            text-decoration: none;
        }

        a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="box">
        <h2>Forgot Password</h2>
        <form action="ForgotPasswordServlet" method="post">
            <label>Enter your email:</label>
            <input type="email" name="email" required placeholder="you@example.com">
            <button type="submit">Reset Password</button>
        </form>
        <a href="login.jsp">Back to login</a>
    </div>
</body>
</html>


