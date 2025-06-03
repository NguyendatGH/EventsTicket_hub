<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Đặt lại mật khẩu</title>
</head>
<body>
    <h2>Đặt lại mật khẩu</h2>

    <c:if test="${not empty error}">
        <p style="color:red">${error}</p>
    </c:if>

    <form action="${pageContext.request.contextPath}/resetPassword" method="post">
        <label for="otp">Mã xác nhận (OTP):</label><br>
        <input type="text" id="otp" name="otp" required><br>

        <label for="newPassword">Mật khẩu mới:</label><br>
        <input type="password" id="newPassword" name="newPassword" required><br><br>

        <button type="submit">Xác nhận</button>
    </form>
</body>
</html>
