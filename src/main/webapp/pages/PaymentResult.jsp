<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Kết quả thanh toán</title>
    <style>
        body { font-family: sans-serif; text-align: center; margin-top: 50px; }
        .container { border: 1px solid #ccc; padding: 20px 40px; display: inline-block; border-radius: 8px; }
        .success { color: #28a745; }
        .fail { color: #dc3545; }
        .error { color: #ffc107; }
        .home-link { display: inline-block; margin-top: 20px; padding: 10px 20px; background-color: #007bff; color: white; text-decoration: none; border-radius: 5px; }
    </style>
</head>
<body>
    <div class="container">
        <c:choose>
            <c:when test="${requestScope.status == 'success'}">
                <h1 class="success">Thanh toán thành công!</h1>
                <p>Mã đơn hàng của bạn là: <strong>${requestScope.orderId}</strong></p>
            </c:when>
            <c:when test="${requestScope.status == 'fail'}">
                <h1 class="fail">Thanh toán thất bại</h1>
                <p>${requestScope.message}</p>
                 <p>Mã đơn hàng: <strong>${requestScope.orderId}</strong></p>
            </c:when>
            <c:otherwise>
                <h1 class="error">Đã xảy ra lỗi</h1>
                <p>${requestScope.message}</p>
            </c:otherwise>
        </c:choose>

        <a href="${pageContext.request.contextPath}/" class="home-link">Quay về trang chủ</a>
    </div>
</body>
</html>