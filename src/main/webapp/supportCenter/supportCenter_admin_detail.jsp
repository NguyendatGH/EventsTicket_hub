<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết yêu cầu hỗ trợ - Admin</title>
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
            max-width: 1000px;
            margin: 0 auto;
            padding: 2rem;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
            background: #21262d;
            padding: 1.5rem;
            border-radius: 10px;
        }

        .header h1 {
            font-size: 1.8rem;
            color: #667aff;
        }

        .back-btn {
            background: #667aff;
            color: white;
            border: none;
            padding: 0.75rem 1.5rem;
            border-radius: 6px;
            cursor: pointer;
            text-decoration: none;
            font-size: 0.9rem;
            transition: background 0.3s;
        }

        .back-btn:hover {
            background: #5566dd;
        }

        .request-details {
            background: #21262d;
            border-radius: 10px;
            padding: 2rem;
            margin-bottom: 2rem;
        }

        .detail-row {
            display: flex;
            margin-bottom: 1rem;
            padding: 0.75rem 0;
            border-bottom: 1px solid #30363d;
        }

        .detail-row:last-child {
            border-bottom: none;
        }

        .detail-label {
            width: 150px;
            font-weight: 600;
            color: #8b949e;
        }

        .detail-value {
            flex: 1;
            color: #e6edf3;
        }

        .status-badge {
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

        .priority-badge {
            padding: 0.25rem 0.5rem;
            border-radius: 12px;
            font-size: 0.75rem;
            font-weight: 500;
        }

        .priority-low {
            background: #00cc66;
            color: white;
        }

        .priority-medium {
            background: #ffcc00;
            color: #000;
        }

        .priority-high {
            background: #ff6b35;
            color: white;
        }

        .priority-urgent {
            background: #ff3333;
            color: white;
        }

        .content-section {
            background: #161b22;
            padding: 1.5rem;
            border-radius: 8px;
            margin: 1rem 0;
        }

        .content-section h3 {
            color: #667aff;
            margin-bottom: 1rem;
        }

        .content-text {
            line-height: 1.6;
            color: #e6edf3;
        }

        .admin-response-form {
            background: #21262d;
            border-radius: 10px;
            padding: 2rem;
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

        .form-group textarea {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid #30363d;
            border-radius: 6px;
            background: #161b22;
            color: #e6edf3;
            font-size: 1rem;
            resize: vertical;
            min-height: 120px;
        }

        .form-group textarea:focus {
            outline: none;
            border-color: #667aff;
        }

        .action-buttons {
            display: flex;
            gap: 1rem;
            margin-top: 1.5rem;
        }

        .action-btn {
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 0.9rem;
            font-weight: 500;
            transition: background 0.3s;
        }

        .action-btn.reply {
            background: #667aff;
            color: white;
        }

        .action-btn.reply:hover {
            background: #5566dd;
        }

        .action-btn.resolve {
            background: #00cc66;
            color: white;
        }

        .action-btn.resolve:hover {
            background: #00b359;
        }

        .action-btn.close {
            background: #8b949e;
            color: white;
        }

        .action-btn.close:hover {
            background: #7a8288;
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
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1><i class="fas fa-headset"></i> Chi tiết yêu cầu hỗ trợ</h1>
            <a href="${pageContext.request.contextPath}/admin/support" class="back-btn">
                <i class="fas fa-arrow-left"></i> Quay lại
            </a>
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

        <c:if test="${not empty supportItem}">
            <div class="request-details">
                <div class="detail-row">
                    <div class="detail-label">ID yêu cầu:</div>
                    <div class="detail-value">#${supportItem.supportId}</div>
                </div>

                <div class="detail-row">
                    <div class="detail-label">Tiêu đề:</div>
                    <div class="detail-value">${supportItem.subject}</div>
                </div>

                <div class="detail-row">
                    <div class="detail-label">Người gửi:</div>
                    <div class="detail-value">${supportItem.fromEmail}</div>
                </div>

                <div class="detail-row">
                    <div class="detail-label">Danh mục:</div>
                    <div class="detail-value">${supportItem.category}</div>
                </div>

                <div class="detail-row">
                    <div class="detail-label">Mức độ ưu tiên:</div>
                    <div class="detail-value">
                        <span class="priority-badge priority-${fn:toLowerCase(supportItem.priority)}">
                            <c:choose>
                                <c:when test="${supportItem.priority == 'LOW'}">Thấp</c:when>
                                <c:when test="${supportItem.priority == 'MEDIUM'}">Trung bình</c:when>
                                <c:when test="${supportItem.priority == 'HIGH'}">Cao</c:when>
                                <c:when test="${supportItem.priority == 'URGENT'}">Khẩn cấp</c:when>
                                <c:otherwise>${supportItem.priority}</c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                </div>

                <div class="detail-row">
                    <div class="detail-label">Trạng thái:</div>
                    <div class="detail-value">
                        <span class="status-badge status-${fn:toLowerCase(supportItem.status)}">
                            <c:choose>
                                <c:when test="${supportItem.status == 'PENDING'}">Chờ xử lý</c:when>
                                <c:when test="${supportItem.status == 'REPLIED'}">Đã phản hồi</c:when>
                                <c:when test="${supportItem.status == 'RESOLVED'}">Đã giải quyết</c:when>
                                <c:when test="${supportItem.status == 'CLOSED'}">Đã đóng</c:when>
                                <c:otherwise>${supportItem.status}</c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                </div>

                <div class="detail-row">
                    <div class="detail-label">Thời gian gửi:</div>
                    <div class="detail-value">${supportItem.getFormattedSendDate()}</div>
                </div>

                <c:if test="${not empty supportItem.assignedAdmin}">
                    <div class="detail-row">
                        <div class="detail-label">Admin phụ trách:</div>
                        <div class="detail-value">${supportItem.assignedAdmin}</div>
                    </div>
                </c:if>

                <div class="content-section">
                    <h3><i class="fas fa-comment"></i> Nội dung yêu cầu</h3>
                    <div class="content-text">${supportItem.content}</div>
                </div>

                <c:if test="${not empty supportItem.adminResponse}">
                    <div class="content-section">
                        <h3><i class="fas fa-reply"></i> Phản hồi từ Admin</h3>
                        <div class="content-text">${supportItem.adminResponse}</div>
                    </div>
                </c:if>
            </div>

            <div class="admin-response-form">
                <h2><i class="fas fa-edit"></i> Phản hồi yêu cầu</h2>
                
                <form action="${pageContext.request.contextPath}/admin/support" method="post">
                    <input type="hidden" name="supportId" value="${supportItem.supportId}">
                    
                    <div class="form-group">
                        <label for="adminResponse">Nội dung phản hồi *</label>
                        <textarea id="adminResponse" name="adminResponse" required 
                                  placeholder="Nhập nội dung phản hồi cho người dùng...">${supportItem.adminResponse}</textarea>
                    </div>

                    <div class="action-buttons">
                        <button type="submit" name="action" value="reply" class="action-btn reply">
                            <i class="fas fa-reply"></i> Phản hồi
                        </button>
                        
                        <button type="submit" name="action" value="resolve" class="action-btn resolve">
                            <i class="fas fa-check"></i> Giải quyết
                        </button>
                        
                        <button type="submit" name="action" value="close" class="action-btn close">
                            <i class="fas fa-times"></i> Đóng
                        </button>
                    </div>
                </form>
            </div>
        </c:if>

        <c:if test="${empty supportItem}">
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle"></i> Không tìm thấy yêu cầu hỗ trợ!
            </div>
        </c:if>
    </div>
</body>
</html>