<%-- 
    Document   : login
    Created on : May 27, 2025, 10:03:39 PM
    Author     : phanh
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Login</title>
    <style>
        * {
            box-sizing: border-box;
            font-family: "Segoe UI", sans-serif;
        }

        body {
            margin: 0;
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(120deg, #0f2027, #203a43, #2c5364);
        }

        .login-box {
            background: rgba(255, 255, 255, 0.05);
            border-radius: 20px;
            padding: 40px;
            width: 350px;
            color: white;
            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
        }

        .login-box h2 {
            font-size: 32px;
            margin-bottom: 30px;
        }

        .login-box label {
            display: block;
            margin-bottom: 5px;
            font-size: 14px;
        }

        .login-box input[type="text"],
        .login-box input[type="password"] {
            width: 100%;
            padding: 12px;
            margin-bottom: 20px;
            background: rgba(255, 255, 255, 0.1);
            border: none;
            border-radius: 10px;
            color: white;
        }

        .login-box input::placeholder {
            color: #ccc;
        }

        .login-box .checkbox {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 14px;
            margin-bottom: 20px;
        }

        .login-box input[type="checkbox"] {
            margin-right: 5px;
        }

        .login-box button {
            width: 100%;
            padding: 12px;
            background: linear-gradient(to right, #4facfe, #9b59b6);
            border: none;
            border-radius: 10px;
            color: white;
            font-weight: bold;
            cursor: pointer;
        }

        .login-box .divider {
            text-align: center;
            margin: 20px 0;
            color: #ccc;
            position: relative;
        }

        .login-box .divider::before,
        .login-box .divider::after {
            content: "";
            position: absolute;
            top: 50%;
            width: 40%;
            height: 1px;
            background: #ccc;
        }

        .login-box .divider::before {
            left: 0;
        }

        .login-box .divider::after {
            right: 0;
        }

        .social-icons {
            display: flex;
            justify-content: space-between;
        }

        .social-icons img {
            width: 40px;
            height: 40px;
            background: white;
            border-radius: 6px;
            padding: 5px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.2);
            transition: transform 0.2s ease;
        }

        .social-icons img:hover {
            transform: scale(1.1);
        }

        .login-box .signup {
            margin-top: 20px;
            text-align: center;
            font-size: 14px;
            color: #ccc;
        }

        .login-box .signup a {
            color: #ff33cc;
            text-decoration: none;
        }

        .login-box .signup a:hover {
            text-decoration: underline;
        }

        .login-box .actions {
            display: flex;
            justify-content: space-between;
            font-size: 14px;
        }

        .login-box .actions a {
            color: #ccc;
            text-decoration: none;
        }

        .login-box .actions a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="login-box">
        <h2>Login</h2>
        <form action="/LoginServlet" method="post">
            <label>Email</label>
            <input type="text" name="user" placeholder="Enter your email" required />
            <label>Password</label>
            <input type="password" name="pass" placeholder="Enter your password" required />
            <div class="checkbox">
                <label><input type="checkbox" name="remember" /> Remember me</label>
            </div>
            <div class="actions">
                <a href="change_password.jsp">Change password</a>
                <a href="forgot_password.jsp">Forgot password?</a>

            </div>
            <br>
            <button type="submit">Sign in</button>

            <div class="divider">or</div>

            <div class="social-icons">
                <img src="https://www.gstatic.com/firebasejs/ui/2.0.0/images/auth/google.svg" alt="Google">
                <img src="https://upload.wikimedia.org/wikipedia/commons/9/91/Icon_of_Zalo.svg" alt="Zalo">
                <img src="https://upload.wikimedia.org/wikipedia/commons/0/05/Facebook_Logo_%282019%29.png" alt="Facebook">
            </div>

            <div class="signup">
                Not have an account yet? Please <a href="${pageContext.request.contextPath}/register.jsp">sign up</a>
            </div>
        </form>
    </div>
</body>
</html>

