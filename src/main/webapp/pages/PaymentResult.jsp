<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MasterTicket - Kết quả thanh toán</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        :root {
            --primary: #667aff;
            --dark-bg: #161b22;
            --card-bg: #21262d;
            --border-color: #30363d;
            --text-light: #e6edf3;
            --text-muted: #8b949e;
            --success: #28a745;
            --danger: #dc3545;
            --warning: #ffc107;
        }
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background-color: var(--dark-bg);
            color: var(--text-light);
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
            padding: 20px;
        }
        .result-card {
            background-color: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 12px;
            padding: 40px;
            text-align: center;
            max-width: 550px;
            width: 100%;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
        }
        .icon-wrapper {
            font-size: 72px;
            line-height: 1;
            margin-bottom: 25px;
        }
        .icon-wrapper.success { color: var(--success); }
        .icon-wrapper.fail { color: var(--danger); }
        .icon-wrapper.error { color: var(--warning); }

        .result-title {
            font-size: 28px;
            margin-bottom: 15px;
            font-weight: 600;
        }
        .result-message {
            font-size: 16px;
            color: var(--text-muted);
            line-height: 1.6;
            margin-bottom: 30px;
        }
        .details-section {
            background-color: var(--dark-bg);
            border: 1px solid var(--border-color);
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 30px;
            text-align: left;
        }
        .detail-item {
            display: flex;
            justify-content: space-between;
            padding: 8px 0;
            font-size: 14px;
            border-bottom: 1px solid var(--border-color);
        }
        .detail-item:last-child {
            border-bottom: none;
        }
        .detail-item span:first-child {
            color: var(--text-muted);
        }
        .detail-item span:last-child {
            font-weight: 600;
            color: var(--text-light);
        }
        .button-group {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 15px;
        }
        .btn {
            display: inline-block;
            text-decoration: none;
            color: white;
            padding: 12px 25px;
            border-radius: 25px;
            font-weight: bold;
            transition: all 0.2s;
            width: 100%;
            max-width: 250px;
        }
        .btn-primary {
            background-color: var(--primary);
        }
        .btn-secondary {
            background-color: #484f58;
        }
        .btn:hover {
            transform: translateY(-2px);
            opacity: 0.9;
        }
    </style>
</head>
<body>

    <div class="result-card">
        <c:choose>
            <%-- Trường hợp thanh toán thành công --%>
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
                    <a href="${pageContext.request.contextPath}/purchased-tickets" class="btn btn-secondary">Xem vé đã mua</a>
                </div>
            </c:when>

            <%-- Trường hợp thanh toán thất bại hoặc bị hủy --%>
            <c:when test="${requestScope.status == 'fail'}">
                <div class="icon-wrapper fail"><i class="fas fa-times-circle"></i></div>
                <h1 class="result-title">Giao dịch chưa hoàn tất</h1>
                <p class="result-message">${requestScope.message}</p>
                 <div class="button-group">
                    <a href="${pageContext.request.contextPath}/" class="btn btn-primary">Về trang chủ</a>
                </div>
            </c:when>

            <%-- Các trường hợp lỗi khác --%>
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