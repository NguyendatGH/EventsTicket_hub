<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Nhập mã OTP</title>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                height: 100vh;
                display: flex;
                justify-content: center;
                align-items: center;
                font-family: 'Segoe UI', sans-serif;
                background: linear-gradient(135deg, #000428, #2c003e, #360033);
            }

            .otp-container {
                background: rgba(255, 255, 255, 0.05);
                backdrop-filter: blur(25px);
                border-radius: 20px;
                padding: 50px 40px;
                width: 500px;
                text-align: center;
                box-shadow: 0 0 40px rgba(0, 0, 0, 0.6);
            }

            .otp-container h2 {
                color: white;
                font-size: 36px;
                font-weight: 400;
                margin-bottom: 25px;
            }

            .otp-container p {
                color: #ccc;
                font-size: 15px;
                margin-bottom: 30px;
            }

            .otp-inputs input {
                width: 250px;
                height: 70px;
                font-size: 32px;
                text-align: center;
                border: none;
                border-radius: 12px;
                background-color: rgba(255, 255, 255, 0.08);
                color: white;
                transition: 0.2s ease;
            }

            .otp-inputs input:focus {
                outline: none;
                background-color: rgba(255, 255, 255, 0.2);
            }

            button {
                background: linear-gradient(to right, #64f3ff, #e74cfa);
                border: none;
                color: white;
                font-size: 18px;
                padding: 10px 40px;
                border-radius: 20px;
                cursor: pointer;
                transition: 0.3s ease;
                margin-top: 30px;
            }

            button:hover {
                opacity: 0.9;
            }

            .bottom-text {
                margin-top: 25px;
                color: #ccc;
                font-size: 14px;
            }

            .bottom-text a {
                color: #ff00cc;
                text-decoration: none;
            }

            .bottom-text a:hover {
                text-decoration: underline;
            }

            .error-message {
                color: #ff4d4d;
                margin-top: 15px;
                font-size: 14px;
            }
        </style>
    </head>

    <body>
        <div class="otp-container">
            <h2>Nhập mã OTP</h2>
            <p>Vui lòng kiểm tra email và nhập mã xác thực (6 chữ số):</p>
            <form action="${pageContext.request.contextPath}/verify" method="post">
                <div class="otp-inputs">
                    <input type="text" name="otp" maxlength="6" pattern="[0-9]{6}" required placeholder="______">
                </div>
                <button type="submit">Xác Nhận</button>
            </form>
            <c:if test="${not empty error}">
                <div class="error-message">${error}</div>
            </c:if>
            <div class="bottom-text">
                Đã có tài khoản trước đó? <a href="login.jsp">Đăng nhập</a>
            </div>
        </div>
    </body>
</html>
