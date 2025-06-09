<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Quên mật khẩu</title>
</head>
<body>
    <h2>Quên mật khẩu</h2>
    
    <c:if test="${not empty error}">
        <p style="color:red">${error}</p>
    </c:if>

    <form action="${pageContext.request.contextPath}/sendResetOTP" method="post">
        <label for="email">Nhập email đã đăng ký:</label><br>
        <input type="email" id="email" name="email" required><br><br>
        <button type="submit">Gửi mã xác nhận</button>
    </form>

    <a href="${pageContext.request.contextPath}/login.jsp">Quay lại đăng nhập</a>
</body>
</html>
