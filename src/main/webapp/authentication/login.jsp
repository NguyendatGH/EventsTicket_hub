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

            .social-icons {
                display: flex;
                justify-content: space-between;
                margin-top: 10px;
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
            <form action="/LoginServlet" method="post">
                <label>Email</label>
                <input type="text" name="user" placeholder="Enter your email" required />
                <label>Passwords</label>
                <input type="password" name="pass" placeholder="Enter your password" required />

                <div class="checkbox">
                    <input type="checkbox" name="remember" />
                    <label>Remember me</label>
                </div>

                <div class="actions">
                    <a href="change_password.jsp">Change password</a>
                    <a href="forgot_password.jsp">Forgot password?</a>
                </div>

                <button type="submit">Sign in</button>

                <div class="divider">or</div>

                <div class="social-icons">
                    <img src="https://www.gstatic.com/firebasejs/ui/2.0.0/images/auth/google.svg" alt="Google">
                    <img src="https://upload.wikimedia.org/wikipedia/commons/9/91/Icon_of_Zalo.svg" alt="Zalo">
                    <img src="https://upload.wikimedia.org/wikipedia/commons/0/05/Facebook_Logo_%282019%29.png" alt="Facebook">
                </div>

                <div class="signup">
                    Don't have an account yet? Please <a href="${pageContext.request.contextPath}/register.jsp">sign up</a>
                </div>
            </form>
        </div>
    </body>
</html>


