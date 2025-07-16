<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <title>Event Created - MasterTicket</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #122536 0%, #764ba2 100%);
            min-height: 100vh;
            color: #fff;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }

        .sidebar {
            position: fixed;
            left: 0;
            top: 0;
            width: 250px;
            height: 100vh;
            background: rgba(0,0,0,0.3);
            backdrop-filter: blur(10px);
            padding: 20px;
            z-index: 1000;
        }

        .sidebar .brand {
            color: #4CAF50;
            font-size: 20px;
            font-weight: bold;
            margin-bottom: 30px;
        }

        .sidebar .menu {
            list-style: none;
        }

        .sidebar .menu li {
            margin-bottom: 15px;
        }

        .sidebar .menu a {
            color: #d8cbcb;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 10px;
            border-radius: 5px;
            transition: background 0.3s;
        }

        .sidebar .menu a:hover,
        .sidebar .menu a.active {
            background: rgba(204, 185, 185, 0.1);
        }

        .main-content {
            margin-left: 270px;
            padding: 20px;
        }

        .navbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 0;
            border-bottom: 1px solid rgba(255,255,255,0.1);
            margin-bottom: 30px;
        }

        .navbar .nav-links {
            display: flex;
            gap: 30px;
            list-style: none;
        }

        .navbar .nav-links a {
            color: #fff;
            text-decoration: none;
            opacity: 0.8;
            transition: opacity 0.3s;
        }

        .navbar .nav-links a:hover {
            opacity: 1;
        }

        .result-container {
            background: rgba(255,255,255,0.1);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            padding: 40px;
            margin-bottom: 20px;
            text-align: center;
        }

        .success-icon {
            font-size: 80px;
            color: #4CAF50;
            margin-bottom: 20px;
            animation: bounce 2s infinite;
        }

        .error-icon {
            font-size: 80px;
            color: #f44336;
            margin-bottom: 20px;
            animation: shake 0.5s;
        }

        @keyframes bounce {
            0%, 20%, 50%, 80%, 100% {
                transform: translateY(0);
            }
            40% {
                transform: translateY(-10px);
            }
            60% {
                transform: translateY(-5px);
            }
        }

        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-5px); }
            75% { transform: translateX(5px); }
        }

        .result-title {
            font-size: 32px;
            font-weight: bold;
            margin-bottom: 15px;
        }

        .result-subtitle {
            font-size: 18px;
            opacity: 0.8;
            margin-bottom: 30px;
        }

        .event-details {
            background: rgba(255,255,255,0.05);
            border-radius: 10px;
            padding: 30px;
            margin: 30px 0;
            text-align: left;
        }

        .event-details h3 {
            color: #4CAF50;
            margin-bottom: 20px;
            font-size: 24px;
        }

        .detail-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 0;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }

        .detail-row:last-child {
            border-bottom: none;
        }

        .detail-label {
            font-weight: 500;
            color: rgba(255,255,255,0.8);
        }

        .detail-value {
            font-weight: bold;
            color: #fff;
        }

        .event-image {
            width: 100px;
            height: 60px;
            object-fit: cover;
            border-radius: 5px;
        }

        .status-badge {
            display: inline-block;
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: bold;
        }

        .status-pending {
            background: rgba(255, 193, 7, 0.2);
            color: #ffc107;
            border: 1px solid #ffc107;
        }

        .status-approved {
            background: rgba(76, 175, 80, 0.2);
            color: #4CAF50;
            border: 1px solid #4CAF50;
        }

        .status-rejected {
            background: rgba(244, 67, 54, 0.2);
            color: #f44336;
            border: 1px solid #f44336;
        }

        .action-buttons {
            display: flex;
            gap: 20px;
            justify-content: center;
            margin-top: 30px;
        }

        .btn {
            padding: 12px 30px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 16px;
            font-weight: 500;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-block;
        }

        .btn-primary {
            background: #4CAF50;
            color: white;
        }

        .btn-primary:hover {
            background: #45a049;
            transform: translateY(-2px);
        }

        .btn-secondary {
            background: rgba(255,255,255,0.2);
            color: #fff;
            border: 1px solid rgba(255,255,255,0.3);
        }

        .btn-secondary:hover {
            background: rgba(255,255,255,0.3);
            transform: translateY(-2px);
        }

        .btn-outline {
            background: transparent;
            color: #4CAF50;
            border: 2px solid #4CAF50;
        }

        .btn-outline:hover {
            background: #4CAF50;
            color: white;
        }

        .error-details {
            background: rgba(244, 67, 54, 0.1);
            border: 1px solid #f44336;
            border-radius: 10px;
            padding: 20px;
            margin: 20px 0;
            text-align: left;
        }

        .error-details h4 {
            color: #f44336;
            margin-bottom: 10px;
        }

        .error-details ul {
            list-style: none;
            padding: 0;
        }

        .error-details li {
            padding: 5px 0;
            color: #f44336;
        }

        .error-details li:before {
            content: "⚠️ ";
            margin-right: 10px;
        }

        .next-steps {
            background: rgba(76, 175, 80, 0.1);
            border: 1px solid #4CAF50;
            border-radius: 10px;
            padding: 20px;
            margin: 20px 0;
            text-align: left;
        }

        .next-steps h4 {
            color: #4CAF50;
            margin-bottom: 15px;
        }

        .next-steps ul {
            list-style: none;
            padding: 0;
        }

        .next-steps li {
            padding: 8px 0;
            color: rgba(255,255,255,0.9);
        }

        .next-steps li:before {
            content: "✅ ";
            margin-right: 10px;
        }

        .promotion-info {
            background: rgba(139, 95, 191, 0.1);
            border: 1px solid #8b5fbf;
            border-radius: 10px;
            padding: 15px;
            margin: 10px 0;
        }

        .promotion-info h5 {
            color: #8b5fbf;
            margin-bottom: 10px;
        }

        @media (max-width: 768px) {
            .sidebar {
                transform: translateX(-100%);
                transition: transform 0.3s;
            }

            .main-content {
                margin-left: 0;
            }

            .action-buttons {
                flex-direction: column;
                align-items: center;
            }

            .detail-row {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }
        }
    </style>
</head>
<body>
    <!-- Sidebar -->
    <div class="sidebar">
        <div class="brand">🎟️ MasterTicket</div>
        <ul class="menu">
            <li><a href="#" class="active">📅 Sự kiện của tôi</a></li>
            <li><a href="#">📊 Quản lí báo cáo</a></li>
            <li><a href="#">📋 Điều khoản</a></li>
        </ul>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <!-- Navigation -->
        <nav class="navbar">
            <div class="nav-links">
                <a href="#">Trang chủ</a>
                <a href="#">Các sự kiện hot</a>
                <a href="#">Săn voucher giảm giá</a>
                <a href="#">Tạo sự kiện</a>
                <a href="#">Hỗ trợ</a>
            </div>
        </nav>

        <!-- Result Container -->
        <div class="result-container">
            <c:choose>
                <c:when test="${requestScope.success}">
                    <!-- Success Case -->
                    <div class="success-icon">🎉</div>
                    <h1 class="result-title">Sự kiện đã được tạo thành công!</h1>
                    <p class="result-subtitle">Cảm ơn bạn đã tạo sự kiện trên MasterTicket. Sự kiện của bạn đang được xem xét.</p>
                    
                    <!-- Event Details -->
                    <div class="event-details">
                        <h3>📋 Thông tin sự kiện</h3>
                        
                        <div class="detail-row">
                            <span class="detail-label">Mã sự kiện:</span>
                            <span class="detail-value">#${requestScope.event.eventID}</span>
                        </div>
                        
                        <div class="detail-row">
                            <span class="detail-label">Tên sự kiện:</span>
                            <span class="detail-value">${requestScope.event.eventName}</span>
                        </div>
                        
                        <div class="detail-row">
                            <span class="detail-label">Mô tả:</span>
                            <span class="detail-value">${requestScope.event.description}</span>
                        </div>
                        
                        <div class="detail-row">
                            <span class="detail-label">Địa điểm:</span>
                            <span class="detail-value">${requestScope.event.location}</span>
                        </div>
                        
                        <div class="detail-row">
                            <span class="detail-label">Thời gian bắt đầu:</span>
                            <span class="detail-value">
                                <fmt:formatDate value="${requestScope.event.startTime}" pattern="dd/MM/yyyy HH:mm"/>
                            </span>
                        </div>
                        
                        <div class="detail-row">
                            <span class="detail-label">Thời gian kết thúc:</span>
                            <span class="detail-value">
                                <fmt:formatDate value="${requestScope.event.endTime}" pattern="dd/MM/yyyy HH:mm"/>
                            </span>
                        </div>
                        
                        <div class="detail-row">
                            <span class="detail-label">Thể loại:</span>
                            <span class="detail-value">${requestScope.event.genre.genreName}</span>
                        </div>
                        
                        <div class="detail-row">
                            <span class="detail-label">Có ghế ngồi:</span>
                            <span class="detail-value">
                                <c:choose>
                                    <c:when test="${requestScope.event.hasSeat}">
                                        ✅ Có ghế ngồi được phân bổ
                                    </c:when>
                                    <c:otherwise>
                                        ❌ Không có ghế ngồi cố định
                                    </c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                        
                        <div class="detail-row">
                            <span class="detail-label">Trạng thái:</span>
                            <span class="detail-value">
                                <c:choose>
                                    <c:when test="${requestScope.event.status == 'PENDING'}">
                                        <span class="status-badge status-pending">🔄 Đang chờ duyệt</span>
                                    </c:when>
                                    <c:when test="${requestScope.event.status == 'APPROVED'}">
                                        <span class="status-badge status-approved">✅ Đã duyệt</span>
                                    </c:when>
                                    <c:when test="${requestScope.event.status == 'REJECTED'}">
                                        <span class="status-badge status-rejected">❌ Bị từ chối</span>
                                    </c:when>
                                </c:choose>
                            </span>
                        </div>
                        
                        <c:if test="${not empty requestScope.event.logoImagePath}">
                            <div class="detail-row">
                                <span class="detail-label">Logo sự kiện:</span>
                                <span class="detail-value">
                                    <img src="${requestScope.event.logoImagePath}" alt="Event Logo" class="event-image">
                                </span>
                            </div>
                        </c:if>
                    </div>

                    <!-- Promotion Information -->
                    <c:if test="${not empty requestScope.promotion}">
                        <div class="promotion-info">
                            <h5>🎁 Thông tin khuyến mãi</h5>
                            <div class="detail-row">
                                <span class="detail-label">Tên khuyến mãi:</span>
                                <span class="detail-value">${requestScope.promotion.promotionName}</span>
                            </div>
                            <div class="detail-row">
                                <span class="detail-label">Mã khuyến mãi:</span>
                                <span class="detail-value">${requestScope.promotion.promotionCode}</span>
                            </div>
                            <div class="detail-row">
                                <span class="detail-label">Thời gian bắt đầu:</span>
                                <span class="detail-value">
                                    <fmt:formatDate value="${requestScope.promotion.startTime}" pattern="dd/MM/yyyy HH:mm"/>
                                </span>
                            </div>
                            <c:if test="${not empty requestScope.promotion.endTime}">
                                <div class="detail-row">
                                    <span class="detail-label">Thời gian kết thúc:</span>
                                    <span class="detail-value">
                                        <fmt:formatDate value="${requestScope.promotion.endTime}" pattern="dd/MM/yyyy HH:mm"/>
                                    </span>
                                </div>
                            </c:if>
                        </div>
                    </c:if>

                    <!-- Next Steps -->
                    <div class="next-steps">
                        <h4>🚀 Các bước tiếp theo</h4>
                        <ul>
                            <li>Sự kiện của bạn sẽ được admin xem xét trong vòng 24-48 giờ</li>
                            <li>Bạn sẽ nhận được email thông báo khi sự kiện được duyệt</li>
                            <li>Sau khi được duyệt, bạn có thể tạo vé và bắt đầu bán vé</li>
                            <li>Theo dõi sự kiện của bạn trong mục "Sự kiện của tôi"</li>
                        </ul>
                    </div>

                    <!-- Action Buttons -->
                    <div class="action-buttons">
                        <a href="${pageContext.request.contextPath}/events/my-events" class="btn btn-primary">
                            📋 Xem sự kiện của tôi
                        </a>
                        <a href="${pageContext.request.contextPath}/events/create" class="btn btn-outline">
                            ➕ Tạo sự kiện mới
                        </a>
                        <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-secondary">
                            🏠 Về trang chủ
                        </a>
                    </div>

                </c:when>
                <c:otherwise>
                    <!-- Error Case -->
                    <div class="error-icon">❌</div>
                    <h1 class="result-title">Có lỗi xảy ra!</h1>
                    <p class="result-subtitle">Không thể tạo sự kiện. Vui lòng kiểm tra lại thông tin và thử lại.</p>
                    
                    <!-- Error Details -->
                    <div class="error-details">
                        <h4>Chi tiết lỗi:</h4>
                        <ul>
                            <c:choose>
                                <c:when test="${not empty requestScope.errorMessages}">
                                    <c:forEach var="error" items="${requestScope.errorMessages}">
                                        <li>${error}</li>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <li>Lỗi không xác định. Vui lòng thử lại sau.</li>
                                </c:otherwise>
                            </c:choose>
                        </ul>
                    </div>

                    <!-- Action Buttons -->
                    <div class="action-buttons">
                        <a href="javascript:history.back()" class="btn btn-primary">
                            ← Quay lại chỉnh sửa
                        </a>
                        <a href="${pageContext.request.contextPath}/events/create" class="btn btn-secondary">
                            🔄 Tạo sự kiện mới
                        </a>
                        <a href="${pageContext.request.contextPath}/support" class="btn btn-outline">
                            🆘 Liên hệ hỗ trợ
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <script>
        // Auto redirect after success (optional)
        <c:if test="${requestScope.success}">
            // Uncomment to auto redirect after 10 seconds
            // setTimeout(() => {
            //     window.location.href = '${pageContext.request.contextPath}/events/my-events';
            // }, 10000);
        </c:if>

        // Show notification
        document.addEventListener('DOMContentLoaded', function() {
            const resultContainer = document.querySelector('.result-container');
            resultContainer.style.opacity = '0';
            resultContainer.style.transform = 'translateY(20px)';
            
            setTimeout(() => {
                resultContainer.style.transition = 'all 0.5s ease';
                resultContainer.style.opacity = '1';
                resultContainer.style.transform = 'translateY(0)';
            }, 100);
        });
    </script>
</body>
</html>