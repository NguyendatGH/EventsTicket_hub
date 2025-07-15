<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Cập nhật thông tin người dùng - MasterTicket</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
            background-color: #070a17;
            color: white;
        }

        .container {
            max-width: 600px;
            margin: 2rem auto;
            padding: 2rem;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 15px;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        h2 {
            text-align: center;
            margin-bottom: 2rem;
            font-size: 1.5rem;
            font-weight: 700;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 500;
        }

        input, select {
            width: 100%;
            padding: 0.75rem;
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 8px;
            color: white;
            font-size: 1rem;
            outline: none;
            transition: border-color 0.3s ease;
        }

        input:focus, select:focus {
            border-color: rgba(100, 150, 255, 0.5);
        }

        .form-actions {
            display: flex;
            gap: 1rem;
            justify-content: center;
        }

        .submit-btn, .cancel-btn {
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 500;
            transition: background 0.3s ease;
        }

        .submit-btn {
            background: #28a745;
            color: white;
        }

        .submit-btn:hover {
            background: #218838;
        }

        .cancel-btn {
            background: #dc3545;
            color: white;
        }

        .cancel-btn:hover {
            background: #c82333;
        }

        .message-alert {
            text-align: center;
            margin-bottom: 1rem;
            padding: 0.75rem;
            border-radius: 8px;
        }

        .message-success {
            background: rgba(40, 167, 69, 0.2);
            color: #28a745;
        }

        .message-error {
            background: rgba(220, 53, 69, 0.2);
            color: #dc3545;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Cập nhật thông tin người dùng</h2>
        <c:if test="${not empty sessionScope.message}">
            <div class="message-alert message-${sessionScope.messageType}">
                ${sessionScope.message}
            </div>
            <c:remove var="message" scope="session" />
            <c:remove var="messageType" scope="session" />
        </c:if>
        <form action="${pageContext.request.contextPath}/admin-servlet/user-management/edit-user" method="POST">
            <input type="hidden" name="userId" value="${user.id}" />
            <div class="form-group">
                <label for="name">Tên người dùng</label>
                <input type="text" id="name" name="name" value="${user.name}" required />
            </div>
            <div class="form-group">
                <label for="email">Email</label>
                <input type="email" id="email" name="email" value="${user.email}" required />
            </div>
            <div class="form-group">
                <label for="gender">Giới tính</label>
                <select id="gender" name="gender">
                    <option value="Male" ${user.gender == 'Male' ? 'selected' : ''}>Nam</option>
                    <option value="Female" ${user.gender == 'Female' ? 'selected' : ''}>Nữ</option>
                    <option value="Other" ${user.gender == 'Other' ? 'selected' : ''}>Khác</option>
                </select>
            </div>
            <div class="form-group">
                <label for="birthday">Ngày sinh</label>
                <input type="date" id="birthday" name="birthday" value="${user.birthday}" />
            </div>
            <div class="form-group">
                <label for="phoneNumber">Số điện thoại</label>
                <input type="tel" id="phoneNumber" name="phoneNumber" value="${user.phoneNumber}" />
            </div>
            <div class="form-group">
                <label for="address">Địa chỉ</label>
                <input type="text" id="address" name="address" value="${user.address}" />
            </div>
            <div class="form-group">
                <label for="avatar">URL Avatar</label>
                <input type="text" id="avatar" name="avatar" value="${user.avatar}" />
            </div>
            <div class="form-actions">
                <button type="submit" class="submit-btn">Cập nhật</button>
                <a href="${pageContext.request.contextPath}/admin-servlet/user-management" class="cancel-btn">Hủy</a>
            </div>
        </form>
    </div>
</body>
</html>