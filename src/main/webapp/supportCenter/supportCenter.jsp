<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hỗ trợ - MasterTicket</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(to bottom, #161b22, #0d1117);
            color: #e6edf3;
            min-height: 100vh;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 2rem;
        }

        .header {
            text-align: center;
            margin-bottom: 3rem;
        }

        .header h1 {
            font-size: 2.5rem;
            color: #667aff;
            margin-bottom: 1rem;
        }

        .header p {
            font-size: 1.1rem;
            color: #8b949e;
        }

        .support-tabs {
            display: flex;
            justify-content: center;
            margin-bottom: 2rem;
            background: #21262d;
            border-radius: 10px;
            padding: 0.5rem;
        }

        .tab-button {
            background: none;
            border: none;
            color: #8b949e;
            padding: 1rem 2rem;
            cursor: pointer;
            border-radius: 8px;
            transition: all 0.3s;
            font-size: 1rem;
        }

        .tab-button.active {
            background: #667aff;
            color: white;
        }

        .tab-button:hover {
            background: #5566dd;
            color: white;
        }

        .tab-content {
            display: none;
        }

        .tab-content.active {
            display: block;
        }

        .support-form {
            background: #21262d;
            padding: 2rem;
            border-radius: 10px;
            margin-bottom: 2rem;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            color: #e6edf3;
            font-weight: 500;
        }

        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid #30363d;
            border-radius: 6px;
            background: #161b22;
            color: #e6edf3;
            font-size: 1rem;
        }

        .form-group textarea {
            resize: vertical;
            min-height: 120px;
        }

        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #667aff;
        }

        .submit-btn {
            background: #667aff;
            color: white;
            border: none;
            padding: 1rem 2rem;
            border-radius: 6px;
            cursor: pointer;
            font-size: 1rem;
            font-weight: 500;
            transition: background 0.3s;
        }

        .submit-btn:hover {
            background: #5566dd;
        }

        .support-requests {
            background: #21262d;
            border-radius: 10px;
            overflow: hidden;
        }

        .request-item {
            padding: 1.5rem;
            border-bottom: 1px solid #30363d;
            transition: background 0.3s;
        }

        .request-item:last-child {
            border-bottom: none;
        }

        .request-item:hover {
            background: #2d3748;
        }

        .request-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
        }

        .request-subject {
            font-size: 1.1rem;
            font-weight: 600;
            color: #e6edf3;
        }

        .request-status {
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.875rem;
            font-weight: 500;
        }

        .status-pending {
            background: #ffcc00;
            color: #000;
        }

        .status-replied {
            background: #667aff;
            color: white;
        }

        .status-resolved {
            background: #00cc66;
            color: white;
        }

        .status-closed {
            background: #8b949e;
            color: white;
        }

        .request-meta {
            display: flex;
            gap: 2rem;
            margin-bottom: 1rem;
            font-size: 0.875rem;
            color: #8b949e;
        }

        .request-content {
            color: #e6edf3;
            line-height: 1.6;
        }

        .admin-response {
            margin-top: 1rem;
            padding: 1rem;
            background: #161b22;
            border-radius: 6px;
            border-left: 4px solid #667aff;
        }

        .admin-response h4 {
            color: #667aff;
            margin-bottom: 0.5rem;
        }

        .alert {
            padding: 1rem;
            border-radius: 6px;
            margin-bottom: 1rem;
        }

        .alert-success {
            background: rgba(0, 204, 102, 0.1);
            border: 1px solid #00cc66;
            color: #00cc66;
        }

        .alert-error {
            background: rgba(255, 51, 51, 0.1);
            border: 1px solid #ff3333;
            color: #ff3333;
        }

        .empty-state {
            text-align: center;
            padding: 3rem;
            color: #8b949e;
        }

        .empty-state i {
            font-size: 3rem;
            margin-bottom: 1rem;
            color: #667aff;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1><i class="fas fa-headset"></i> Trung tâm hỗ trợ</h1>
            <p>Chúng tôi luôn sẵn sàng hỗ trợ bạn 24/7</p>
        </div>

        <c:if test="${not empty success}">
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i> ${success}
            </div>
        </c:if>

        <c:if test="${not empty error}">
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle"></i> ${error}
            </div>
        </c:if>

        <div class="support-tabs">
            <button class="tab-button active" onclick="showTab('new-request')">
                <i class="fas fa-plus"></i> Gửi yêu cầu mới
            </button>
            <button class="tab-button" onclick="showTab('my-requests')">
                <i class="fas fa-list"></i> Yêu cầu của tôi
            </button>
        </div>

        <!-- Tab: Gửi yêu cầu mới -->
        <div id="new-request" class="tab-content active">
            <div class="support-form">
                <h2><i class="fas fa-edit"></i> Gửi yêu cầu hỗ trợ</h2>
                <form action="${pageContext.request.contextPath}/support" method="post">
                    <input type="hidden" name="action" value="submit-request">
                    
                    <div class="form-group">
                        <label for="subject">Tiêu đề *</label>
                        <input type="text" id="subject" name="subject" required 
                               placeholder="Nhập tiêu đề yêu cầu hỗ trợ...">
                    </div>

                    <div class="form-group">
                        <label for="category">Danh mục</label>
                        <select id="category" name="category">
                            <option value="GENERAL">Chung</option>
                            <option value="TECHNICAL">Kỹ thuật</option>
                            <option value="PAYMENT">Thanh toán</option>
                            <option value="TICKET">Vé sự kiện</option>
                            <option value="ACCOUNT">Tài khoản</option>
                            <option value="OTHER">Khác</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="priority">Mức độ ưu tiên</label>
                        <select id="priority" name="priority">
                            <option value="LOW">Thấp</option>
                            <option value="MEDIUM" selected>Trung bình</option>
                            <option value="HIGH">Cao</option>
                            <option value="URGENT">Khẩn cấp</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="content">Nội dung *</label>
                        <textarea id="content" name="content" required 
                                  placeholder="Mô tả chi tiết vấn đề của bạn..."></textarea>
                    </div>

                    <button type="submit" class="submit-btn">
                        <i class="fas fa-paper-plane"></i> Gửi yêu cầu
                    </button>
                </form>
            </div>
        </div>

        <!-- Tab: Yêu cầu của tôi -->
        <div id="my-requests" class="tab-content">
            <div class="support-requests">
                <c:choose>
                    <c:when test="${not empty supportRequests}">
                        <c:forEach var="request" items="${supportRequests}">
                            <div class="request-item">
                                <div class="request-header">
                                    <div class="request-subject">${request.subject}</div>
                                    <span class="request-status status-${fn:toLowerCase(request.status)}">
                                        <c:choose>
                                            <c:when test="${request.status == 'PENDING'}">Chờ xử lý</c:when>
                                            <c:when test="${request.status == 'REPLIED'}">Đã phản hồi</c:when>
                                            <c:when test="${request.status == 'RESOLVED'}">Đã giải quyết</c:when>
                                            <c:when test="${request.status == 'CLOSED'}">Đã đóng</c:when>
                                            <c:otherwise>${request.status}</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                                
                                <div class="request-meta">
                                    <span><i class="fas fa-calendar"></i> ${request.getFormattedSendDate()}</span>
                                    <span><i class="fas fa-tag"></i> ${request.category}</span>
                                    <span><i class="fas fa-flag"></i> ${request.priority}</span>
                                </div>
                                
                                <div class="request-content">
                                    ${request.content}
                                </div>

                                <c:if test="${not empty request.adminResponse}">
                                    <div class="admin-response">
                                        <h4><i class="fas fa-reply"></i> Phản hồi từ Admin</h4>
                                        <p>${request.adminResponse}</p>
                                        <small>Phản hồi bởi: ${request.assignedAdmin}</small>
                                    </div>
                                </c:if>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <i class="fas fa-inbox"></i>
                            <h3>Chưa có yêu cầu hỗ trợ nào</h3>
                            <p>Bạn chưa gửi yêu cầu hỗ trợ nào. Hãy tạo yêu cầu mới nếu cần hỗ trợ!</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <script>
        function showTab(tabName) {
            // Hide all tab contents
            const tabContents = document.querySelectorAll('.tab-content');
            tabContents.forEach(content => content.classList.remove('active'));
            
            // Remove active class from all tab buttons
            const tabButtons = document.querySelectorAll('.tab-button');
            tabButtons.forEach(button => button.classList.remove('active'));
            
            // Show selected tab content
            document.getElementById(tabName).classList.add('active');
            
            // Add active class to clicked button
            event.target.classList.add('active');
        }

        // Load user requests when page loads
        window.onload = function() {
            // You can add AJAX call here to load user requests
        };
    </script>
</body>
</html> 