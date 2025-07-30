<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch sử yêu cầu hoàn tiền - MasterTicket</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary: #6366f1;
            --primary-dark: #4f46e5;
            --secondary: #ec4899;
            --secondary-dark: #db2777;
            --accent: #06b6d4;
            --dark-bg: #0f172a;
            --darker-bg: #020617;
            --card-bg: #1e293b;
            --card-hover: #334155;
            --border-color: #334155;
            --text-light: #f1f5f9;
            --text-muted: #94a3b8;
            --success: #10b981;
            --warning: #f59e0b;
            --danger: #ef4444;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background: var(--darker-bg);
            color: var(--text-light);
            line-height: 1.6;
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

        .page-title {
            font-size: 2.5rem;
            font-weight: 700;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 1rem;
        }

        .page-subtitle {
            color: var(--text-muted);
            font-size: 1.1rem;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
            margin-bottom: 3rem;
        }

        .stat-card {
            background: var(--card-bg);
            border-radius: 16px;
            padding: 2rem;
            border: 1px solid var(--border-color);
            text-align: center;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.3);
        }

        .stat-icon {
            font-size: 2.5rem;
            margin-bottom: 1rem;
            opacity: 0.8;
        }

        .stat-value {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }

        .stat-label {
            color: var(--text-muted);
            font-size: 0.9rem;
        }

        .content-section {
            background: var(--card-bg);
            border-radius: 16px;
            padding: 2rem;
            border: 1px solid var(--border-color);
            margin-bottom: 2rem;
        }

        .section-title {
            font-size: 1.5rem;
            font-weight: 600;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .refund-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 1rem;
        }

        .refund-table th,
        .refund-table td {
            padding: 1rem;
            text-align: left;
            border-bottom: 1px solid var(--border-color);
        }

        .refund-table th {
            font-weight: 600;
            color: var(--text-muted);
            background: rgba(255, 255, 255, 0.05);
        }

        .refund-table tbody tr:hover {
            background: rgba(255, 255, 255, 0.05);
        }

        .status-badge {
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 500;
            text-transform: uppercase;
            display: inline-block;
        }

        .status-pending {
            background: rgba(255, 193, 7, 0.2);
            color: #ffc107;
        }

        .status-approved {
            background: rgba(40, 167, 69, 0.2);
            color: #28a745;
        }

        .status-rejected {
            background: rgba(220, 53, 69, 0.2);
            color: #dc3545;
        }

        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            color: var(--text-muted);
        }

        .empty-state i {
            font-size: 4rem;
            margin-bottom: 1rem;
            opacity: 0.5;
        }

        .empty-state h3 {
            font-size: 1.5rem;
            margin-bottom: 0.5rem;
            color: var(--text-light);
        }

        .empty-state p {
            margin-bottom: 2rem;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 500;
            text-decoration: none;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .btn-primary {
            background: var(--primary);
            color: white;
        }

        .btn-primary:hover {
            background: var(--primary-dark);
            transform: translateY(-2px);
        }

        .alert {
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .alert-success {
            background: rgba(40, 167, 69, 0.2);
            border: 1px solid #28a745;
            color: #28a745;
        }

        .alert-error {
            background: rgba(220, 53, 69, 0.2);
            border: 1px solid #dc3545;
            color: #dc3545;
        }

        .back-btn {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            color: var(--text-muted);
            text-decoration: none;
            font-weight: 500;
            margin-bottom: 2rem;
            transition: color 0.3s ease;
        }

        .back-btn:hover {
            color: var(--primary);
        }

        @media (max-width: 768px) {
            .container {
                padding: 1rem;
            }
            
            .page-title {
                font-size: 2rem;
            }
            
            .stats-grid {
                grid-template-columns: 1fr;
            }
            
            .refund-table {
                font-size: 0.875rem;
            }
            
            .refund-table th,
            .refund-table td {
                padding: 0.5rem;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <a href="${pageContext.request.contextPath}/pages/TicketOrderHistory.jsp" class="back-btn">
            <i class="fas fa-arrow-left"></i>
            Quay lại lịch sử đặt vé
        </a>

        <div class="header">
            <h1 class="page-title">
                <i class="fas fa-undo-alt"></i>
                Lịch sử yêu cầu hoàn tiền
            </h1>
            <p class="page-subtitle">Theo dõi trạng thái các yêu cầu hoàn tiền của bạn</p>
        </div>

        <c:if test="${not empty flashMessage_success}">
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i>
                ${flashMessage_success}
            </div>
        </c:if>

        <c:if test="${not empty flashMessage_fail}">
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle"></i>
                ${flashMessage_fail}
            </div>
        </c:if>

        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon" style="color: #ffc107;">
                    <i class="fas fa-clock"></i>
                </div>
                <div class="stat-value">
                    <c:set var="pendingCount" value="0" />
                    <c:forEach var="refund" items="${userRefunds}">
                        <c:if test="${refund.refundStatus == 'pending'}">
                            <c:set var="pendingCount" value="${pendingCount + 1}" />
                        </c:if>
                    </c:forEach>
                    ${pendingCount}
                </div>
                <div class="stat-label">Đang chờ xử lý</div>
            </div>

            <div class="stat-card">
                <div class="stat-icon" style="color: #28a745;">
                    <i class="fas fa-check-circle"></i>
                </div>
                <div class="stat-value">
                    <c:set var="approvedCount" value="0" />
                    <c:forEach var="refund" items="${userRefunds}">
                        <c:if test="${refund.refundStatus == 'approved'}">
                            <c:set var="approvedCount" value="${approvedCount + 1}" />
                        </c:if>
                    </c:forEach>
                    ${approvedCount}
                </div>
                <div class="stat-label">Đã phê duyệt</div>
            </div>

            <div class="stat-card">
                <div class="stat-icon" style="color: #dc3545;">
                    <i class="fas fa-times-circle"></i>
                </div>
                <div class="stat-value">
                    <c:set var="rejectedCount" value="0" />
                    <c:forEach var="refund" items="${userRefunds}">
                        <c:if test="${refund.refundStatus == 'rejected'}">
                            <c:set var="rejectedCount" value="${rejectedCount + 1}" />
                        </c:if>
                    </c:forEach>
                    ${rejectedCount}
                </div>
                <div class="stat-label">Đã từ chối</div>
            </div>

            <div class="stat-card">
                <div class="stat-icon" style="color: #6366f1;">
                    <i class="fas fa-list"></i>
                </div>
                <div class="stat-value">${userRefunds.size()}</div>
                <div class="stat-label">Tổng yêu cầu</div>
            </div>
        </div>

        <div class="content-section">
            <h2 class="section-title">
                <i class="fas fa-history"></i>
                Danh sách yêu cầu hoàn tiền
            </h2>

            <c:choose>
                <c:when test="${empty userRefunds}">
                    <div class="empty-state">
                        <i class="fas fa-inbox"></i>
                        <h3>Chưa có yêu cầu hoàn tiền nào</h3>
                        <p>Bạn chưa gửi yêu cầu hoàn tiền nào. Hãy vào lịch sử đặt vé để yêu cầu hoàn tiền cho các vé đã mua.</p>
                        <a href="${pageContext.request.contextPath}/pages/TicketOrderHistory.jsp" class="btn btn-primary">
                            <i class="fas fa-ticket-alt"></i>
                            Xem lịch sử đặt vé
                        </a>
                    </div>
                </c:when>
                <c:otherwise>
                    <table class="refund-table">
                        <thead>
                            <tr>
                                <th>ID yêu cầu</th>
                                <th>Mã đơn hàng</th>
                                <th>Số tiền</th>
                                <th>Lý do</th>
                                <th>Ngày yêu cầu</th>
                                <th>Trạng thái</th>
                                <th>Ngày xử lý</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="refund" items="${userRefunds}">
                                <tr>
                                    <td>#${refund.refundId}</td>
                                    <td>${refund.orderNumber}</td>
                                    <td>
                                        <fmt:formatNumber value="${refund.refundAmount}" type="currency" currencySymbol="₫" />
                                    </td>
                                    <td>
                                        <div style="max-width: 200px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                                            ${refund.refundReason}
                                        </div>
                                    </td>
                                    <td>
                                        <fmt:formatDate value="${refund.refundRequestDate}" pattern="dd/MM/yyyy HH:mm" />
                                    </td>
                                    <td>
                                        <span class="status-badge status-${refund.refundStatus}">
                                            ${refund.refundStatus == 'pending' ? 'Chờ xử lý' : 
                                              refund.refundStatus == 'approved' ? 'Đã phê duyệt' : 'Đã từ chối'}
                                        </span>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty refund.refundProcessedDate}">
                                                <fmt:formatDate value="${refund.refundProcessedDate}" pattern="dd/MM/yyyy HH:mm" />
                                            </c:when>
                                            <c:otherwise>
                                                <span style="color: var(--text-muted);">-</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html> 