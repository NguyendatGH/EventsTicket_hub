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
            font-family: "Segoe UI", sans-serif;
            background: linear-gradient(120deg, #0f2027, #203a43, #2c5364);
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .box {
            background: rgba(255, 255, 255, 0.1);
            color: white;
            padding: 30px;
            border-radius: 15px;
            width: 300px;
            backdrop-filter: blur(10px);
        }
        input[type=email], button {
            width: 100%;
            padding: 10px;
            margin-top: 15px;
            border-radius: 8px;
            border: none;
        }
        button {
            background: #4facfe;
            color: white;
            cursor: pointer;
            font-weight: bold;
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
        <br>
        <a href="login.jsp" style="color: #ccc;">Back to login</a>
    </div>
</body>
</html>

