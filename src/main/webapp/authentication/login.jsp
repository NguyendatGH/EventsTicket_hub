<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
                background: linear-gradient(135deg, #0f1123, #1f1d40, #5e1763);
                background-size: cover;
                background-repeat: no-repeat;
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
                font-size: 36px;
                font-weight: 400;
                margin-bottom: 30px;
                margin-top: 0;
                text-align: left;
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

            .checkbox {
                display: flex;
                align-items: center;
                font-size: 14px;
                margin-bottom: 10px;
            }

            .login-box .actions {
                display: flex;
                justify-content: space-between;
                font-size: 14px;
                margin-bottom: 20px;
            }

            .login-box .actions a {
                color: #ccc;
                text-decoration: none;
            }

            .login-box .actions a:hover {
                text-decoration: underline;
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
                margin-top: 10px;
            }

            .divider {
                text-align: center;
                margin: 20px 0;
                color: #ccc;
                position: relative;
            }

            .divider::before,
            .divider::after {
                content: "";
                position: absolute;
                top: 50%;
                width: 40%;
                height: 1px;
                background: #ccc;
            }

            .divider::before {
                left: 0;
            }

            .divider::after {
                right: 0;
            }

            .signup {
                margin-top: 20px;
                text-align: center;
                font-size: 14px;
                color: #ccc;
            }

            .signup a {
                color: #ff33cc;
                text-decoration: none;
            }

            .signup a:hover {
                text-decoration: underline;
            }
        </style>
    </head>
    <body>
        <div class="login-box">
            <h2>Login</h2>

            <c:if test="${not empty error}">
                <p style="color: red; margin-bottom: 10px;">${error}</p>
            </c:if>

            <form action="${pageContext.request.contextPath}/login" method="post">
                <label>Email</label>
                <input type="text" name="email" placeholder="Enter your email" required />

                <label>Password</label>
                <input type="password" name="password" placeholder="Enter your password" required />

                <div class="checkbox">
                    <input type="checkbox" name="remember" />
                    <label>Remember me</label>
                </div>

                <div class="actions">
                    <a href="${pageContext.request.contextPath}/authentication/forgotPassword.jsp">Quên mật khẩu?</a>

                </div>

                <button type="submit">Sign in</button>
            </form>

            <div class="divider">or</div>
            <div style="margin-top: 10px;"> 
                <a href="${pageContext.request.contextPath}/login-google">
                    <img src="https://developers.google.com/identity/images/btn_google_signin_dark_normal_web.png" />
                </a>
            </div>

            <div class="signup">
                Don't have an account yet? Please 
                <a href="${pageContext.request.contextPath}/authentication/register.jsp">sign up</a>
            </div>
        </div>

        <script src="https://accounts.google.com/gsi/client" async defer></script>
    </body>
</html>