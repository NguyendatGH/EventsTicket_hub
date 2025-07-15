<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Kết quả thanh toán - MasterTicket</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary: #667aff;
            --success: #28a745;
            --danger: #dc3545;
            --warning: #ffc107;
            --bg-dark: #f1f3f5;
            --card-bg: #ffffff;
            --text-color: #1f2937;
            --muted: #6b7280;
            --border: #e5e7eb;
        }

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: 'Segoe UI', sans-serif;
            background-color: var(--bg-dark);
            color: var(--text-color);
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            padding: 20px;
        }

        .result-card {
            background-color: var(--card-bg);
            border-radius: 12px;
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.08);
            padding: 40px 30px;
            max-width: 500px;
            width: 100%;
            text-align: center;
            border: 1px solid var(--border);
        }

        .icon-wrapper {
            font-size: 60px;
            margin-bottom: 20px;
        }

        .success { color: var(--success); }
        .fail { color: var(--danger); }
        .error { color: var(--warning); }

        .result-title {
            font-size: 24px;
            font-weight: 700;
            margin-bottom: 10px;
        }

        .result-message {
            font-size: 15px;
            color: var(--muted);
            margin-bottom: 30px;
        }

        .details-section {
            background-color: #f9fafb;
            border: 1px solid var(--border);
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 25px;
            text-align: left;
        }

        .detail-item {
            display: flex;
            justify-content: space-between;
            font-size: 14px;
            padding: 10px 0;
            border-bottom: 1px solid var(--border);
        }

        .detail-item:last-child {
            border-bottom: none;
        }

        .button-group {
            display: flex;
            flex-direction: column;
            gap: 10px;
            margin-top: 15px;
        }

        .btn {
            display: inline-block;
            text-decoration: none;
            font-weight: 600;
            padding: 12px;
            border-radius: 8px;
            text-align: center;
            transition: 0.2s;
        }

        .btn-primary {
            background-color: var(--primary);
            color: white;
        }

        .btn-secondary {
            background-color: #e2e8f0;
            color: #1f2937;
        }

        .btn:hover {
            opacity: 0.9;
        }
    </style>
</head>
<body>

<div class="result-card">
    <c:choose>
        <c:when test="${requestScope.status == 'success'}">
            <div class="icon-wrapper success"><i class="fas fa-check-circle"></i></div>
            <h1 class="result-title">Thanh toán thành công!</h1>
            <p class="result-message">${requestScope.message}</p>

            <div class="details-section">
                <div class="detail-item">
                    <span>Phương thức:</span>
                    <span>${requestScope.paymentMethod}</span>
                </div>
                <div class="detail-item">
                    <span>Mã đơn hàng:</span>
                    <span>${requestScope.orderCode}</span>
                </div>
                <div class="detail-item">
                    <span>Mã giao dịch:</span>
                    <span>${requestScope.transactionId}</span>
                </div>
            </div>

            <div class="button-group">
                <a href="${pageContext.request.contextPath}/" class="btn btn-primary">Về trang chủ</a>
                <a href="${pageContext.request.contextPath}/TicketOrderHistoryServlet" class="btn btn-secondary">Xem vé đã mua</a>
            </div>
        </c:when>

        <c:when test="${requestScope.status == 'fail'}">
            <div class="icon-wrapper fail"><i class="fas fa-times-circle"></i></div>
            <h1 class="result-title">Giao dịch chưa hoàn tất</h1>
            <p class="result-message">${requestScope.message}</p>
            <div class="button-group">
                <a href="${pageContext.request.contextPath}/" class="btn btn-primary">Về trang chủ</a>
            </div>
        </c:when>

        <c:otherwise>
            <div class="icon-wrapper error"><i class="fas fa-exclamation-triangle"></i></div>
            <h1 class="result-title">Đã có lỗi xảy ra</h1>
            <p class="result-message">${requestScope.message}</p>
            <div class="button-group">
                <a href="${pageContext.request.contextPath}/" class="btn btn-primary">Về trang chủ</a>
            </div>
        </c:otherwise>
    </c:choose>
</div>

</body>
</html>
