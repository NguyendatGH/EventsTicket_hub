<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý hỗ trợ - Admin</title>
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
            max-width: 1400px;
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
            font-size: 2rem;
            color: #667aff;
        }

        .stats {
            display: flex;
            gap: 1rem;
        }

        .stat-item {
            background: #161b22;
            padding: 1rem;
            border-radius: 8px;
            text-align: center;
            min-width: 120px;
        }

        .stat-number {
            font-size: 1.5rem;
            font-weight: bold;
            color: #667aff;
        }

        .stat-label {
            font-size: 0.875rem;
            color: #8b949e;
        }

        .support-tabs {
            display: flex;
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

        .support-table {
            background: #21262d;
            border-radius: 10px;
            overflow: hidden;
        }

        .table-header {
            display: grid;
            grid-template-columns: 50px 2fr 1fr 1fr 1fr 1fr 120px;
            gap: 1rem;
            padding: 1rem;
            background: #161b22;
            font-weight: 600;
            color: #e6edf3;
        }

        .table-row {
            display: grid;
            grid-template-columns: 50px 2fr 1fr 1fr 1fr 1fr 120px;
            gap: 1rem;
            padding: 1rem;
            border-bottom: 1px solid #30363d;
            align-items: center;
            transition: background 0.3s;
        }

        .table-row:hover {
            background: #2d3748;
        }

        .table-row:last-child {
            border-bottom: none;
        }

        .status-badge {
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.875rem;
            font-weight: 500;
            text-align: center;
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

        .action-btn {
            background: #667aff;
            color: white;
            border: none;
            padding: 0.5rem 1rem;
            border-radius: 6px;
            cursor: pointer;
            font-size: 0.875rem;
            transition: background 0.3s;
        }

        .action-btn:hover {
            background: #5566dd;
        }

        .action-btn.view {
            background: #667aff;
        }

        .action-btn.reply {
            background: #00cc66;
        }

        .action-btn.resolve {
            background: #ffcc00;
            color: #000;
        }

        .action-btn.close {
            background: #8b949e;
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
            <h1><i class="fas fa-headset"></i> Quản lý hỗ trợ</h1>
            <div class="stats">
                <div class="stat-item">
                    <div class="stat-number">${pendingCount}</div>
                    <div class="stat-label">Chờ xử lý</div>
                </div>
                <div class="stat-item">
                    <div class="stat-number">${allRequests.size()}</div>
                    <div class="stat-label">Tổng yêu cầu</div>
                </div>
            </div>
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
            <button class="tab-button active" onclick="showTab('all-requests')">
                <i class="fas fa-list"></i> Tất cả yêu cầu
            </button>
            <button class="tab-button" onclick="showTab('pending-requests')">
                <i class="fas fa-clock"></i> Chờ xử lý
            </button>
        </div>

        <!-- Tab: Tất cả yêu cầu -->
        <div id="all-requests" class="tab-content active">
            <div class="support-table">
                <div class="table-header">
                    <div>ID</div>
                    <div>Tiêu đề</div>
                    <div>Người gửi</div>
                    <div>Danh mục</div>
                    <div>Mức độ</div>
                    <div>Trạng thái</div>
                    <div>Thao tác</div>
                </div>

                <c:choose>
                    <c:when test="${not empty allRequests}">
                        <c:forEach var="request" items="${allRequests}">
                            <div class="table-row">
                                <div>#${request.supportId}</div>
                                <div>${request.subject}</div>
                                <div>${request.fromEmail}</div>
                                <div>${request.category}</div>
                                <div>
                                    <span class="priority-badge priority-${fn:toLowerCase(request.priority)}">
                                        <c:choose>
                                            <c:when test="${request.priority == 'LOW'}">Thấp</c:when>
                                            <c:when test="${request.priority == 'MEDIUM'}">Trung bình</c:when>
                                            <c:when test="${request.priority == 'HIGH'}">Cao</c:when>
                                            <c:when test="${request.priority == 'URGENT'}">Khẩn cấp</c:when>
                                            <c:otherwise>${request.priority}</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                                <div>
                                    <span class="status-badge status-${fn:toLowerCase(request.status)}">
                                        <c:choose>
                                            <c:when test="${request.status == 'PENDING'}">Chờ xử lý</c:when>
                                            <c:when test="${request.status == 'REPLIED'}">Đã phản hồi</c:when>
                                            <c:when test="${request.status == 'RESOLVED'}">Đã giải quyết</c:when>
                                            <c:when test="${request.status == 'CLOSED'}">Đã đóng</c:when>
                                            <c:otherwise>${request.status}</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                                <div>
                                    <button class="action-btn view" onclick="viewDetail(${request.supportId})">
                                        <i class="fas fa-eye"></i> Xem
                                    </button>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <i class="fas fa-inbox"></i>
                            <h3>Chưa có yêu cầu hỗ trợ nào</h3>
                            <p>Hiện tại chưa có yêu cầu hỗ trợ nào được gửi.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Tab: Chờ xử lý -->
        <div id="pending-requests" class="tab-content">
            <div class="support-table">
                <div class="table-header">
                    <div>ID</div>
                    <div>Tiêu đề</div>
                    <div>Người gửi</div>
                    <div>Danh mục</div>
                    <div>Mức độ</div>
                    <div>Thời gian</div>
                    <div>Thao tác</div>
                </div>

                <c:choose>
                    <c:when test="${not empty pendingRequests}">
                        <c:forEach var="request" items="${pendingRequests}">
                            <div class="table-row">
                                <div>#${request.supportId}</div>
                                <div>${request.subject}</div>
                                <div>${request.fromEmail}</div>
                                <div>${request.category}</div>
                                <div>
                                    <span class="priority-badge priority-${fn:toLowerCase(request.priority)}">
                                        <c:choose>
                                            <c:when test="${request.priority == 'LOW'}">Thấp</c:when>
                                            <c:when test="${request.priority == 'MEDIUM'}">Trung bình</c:when>
                                            <c:when test="${request.priority == 'HIGH'}">Cao</c:when>
                                            <c:when test="${request.priority == 'URGENT'}">Khẩn cấp</c:when>
                                            <c:otherwise>${request.priority}</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                                <div>${request.getFormattedSendDate()}</div>
                                <div>
                                    <button class="action-btn view" onclick="viewDetail(${request.supportId})">
                                        <i class="fas fa-eye"></i> Xem
                                    </button>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <i class="fas fa-check-circle"></i>
                            <h3>Không có yêu cầu chờ xử lý</h3>
                            <p>Tất cả yêu cầu hỗ trợ đã được xử lý!</p>
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

        function viewDetail(supportId) {
            window.location.href = '${pageContext.request.contextPath}/admin/support?action=view-detail&id=' + supportId;
        }
    </script>
</body>
</html>