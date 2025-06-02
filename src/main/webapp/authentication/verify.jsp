

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Xác minh Email</title>
</head>
<body>
    <h2>Nhập mã xác minh đã gửi tới email của bạn</h2>
    <form action="${pageContext.request.contextPath}/verify" method="post">
        <input type="text" name="otp" placeholder="Nhập mã OTP" required />
        <button type="submit">Xác minh</button>
    </form>
    <c:if test="${not empty error}">
        <p style="color:red;">${error}</p>
    </c:if>
</body>
</html>

