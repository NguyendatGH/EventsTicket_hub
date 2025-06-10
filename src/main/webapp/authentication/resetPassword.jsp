<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Đặt lại mật khẩu</title>
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

        .reset-container {
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(25px);
            border-radius: 20px;
            padding: 50px 40px;
            width: 500px;
            text-align: center;
            box-shadow: 0 0 40px rgba(0, 0, 0, 0.6);
            color: white;
        }

        .reset-container h2 {
            font-size: 36px;
            font-weight: 400;
            margin-bottom: 25px;
        }

        .reset-container label {
            display: block;
            text-align: left;
            margin-bottom: 8px;
            color: #ccc;
            font-size: 15px;
        }

        .reset-container input {
            width: 100%;
            padding: 12px;
            margin-bottom: 20px;
            border: none;
            border-radius: 12px;
            background-color: rgba(255, 255, 255, 0.08);
            color: white;
            font-size: 16px;
        }

        .reset-container input:focus {
            outline: none;
            background-color: rgba(255, 255, 255, 0.2);
        }

        .reset-container button {
            background: linear-gradient(to right, #64f3ff, #e74cfa);
            border: none;
            color: white;
            font-size: 18px;
            padding: 10px 40px;
            border-radius: 20px;
            cursor: pointer;
            transition: 0.3s ease;
        }

        .reset-container button:hover {
            opacity: 0.9;
        }

        .error-message {
            color: red;
            margin-bottom: 15px;
            font-size: 14px;
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
    </style>
</head>
<body>
<div class="reset-container">
    <h2>Đặt lại mật khẩu</h2>

    <c:if test="${not empty error}">
        <p class="error-message">${error}</p>
    </c:if>

    <form action="${pageContext.request.contextPath}/resetPassword" method="post">
        <label for="otp">Mã xác nhận (OTP):</label>
        <input type="text" id="otp" name="otp" required>

        <label for="newPassword">Mật khẩu mới:</label>
        <input type="password" id="newPassword" name="newPassword" required>

        <button type="submit">Xác nhận</button>
    </form>

    <div class="bottom-text">
        Đã có tài khoản? <a href="login.jsp">Đăng nhập</a>
    </div>
</div>
</body>
</html>
