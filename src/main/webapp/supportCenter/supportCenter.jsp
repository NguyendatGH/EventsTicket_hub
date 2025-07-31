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
            color: var(--text-light);
            min-height: 100vh;
            overflow-x: hidden;
        }

        /* Color Scheme */
        :root {
            --primary: #667aff;
            --secondary: #e06bce;
            --dark-bg: #161b22;
            --darker-bg: #0d1117;
            --card-bg: #21262d;
            --border-color: #30363d;
            --text-light: #e6edf3;
            --text-muted: #8b949e;
            --success: #00cc66;
            --warning: #ffcc00;
            --danger: #ff3333;
        }

        /* Header */
        .header {
            background: var(--darker-bg);
            padding: 1rem 2rem;
            position: sticky;
            top: 0;
            border-bottom: 1px solid var(--border-color);
            overflow: visible;
            z-index: 1;
        }

        /* Ensure all content has lower z-index than dropdown */
        .container * {
            z-index: 1;
        }

        .nav {
            display: flex;
            justify-content: space-between;
            align-items: center;
            max-width: 1400px;
            margin: 0 auto;
            flex-wrap: nowrap;
        }

        .logo {
            font-size: 1.5rem;
            font-weight: bold;
            color: var(--primary);
            text-decoration: none;
            flex-shrink: 0;
        }

        .nav-center-content {
            display: flex;
            align-items: center;
            flex-grow: 1;
            justify-content: center;
            gap: 1rem;
            flex-wrap: nowrap;
        }

        .nav-links {
            display: flex;
            gap: 1.5rem;
            list-style: none;
            flex-wrap: nowrap;
        }

        .nav-links a {
            color: var(--text-light);
            text-decoration: none;
            transition: color 0.3s;
            display: flex;
            align-items: center;
            gap: 5px;
            white-space: nowrap;
        }

        .nav-links a:hover {
            color: var(--primary);
        }

        .auth-buttons {
            display: flex;
            gap: 0.75rem;
            align-items: center;
            flex-shrink: 0;
            margin-left: 1rem;
            position: relative;
        }

        .btn {
            padding: 0.6rem 1.8rem;
            border: none;
            border-radius: 25px;
            cursor: pointer;
            font-weight: 500;
            font-size: 0.9rem;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-width: 100px;
            color: var(--text-light);
        }

        .btn-outline {
            background: transparent;
            border: 1px solid var(--border-color);
        }

        .btn-outline:hover {
            background: rgba(102, 122, 255, 0.2);
            color: var(--primary);
            border-color: var(--primary);
        }

        .btn-primary {
            background: var(--primary);
        }

        .btn-primary:hover {
            background: #5566dd;
            transform: translateY(-2px);
        }

        /* User Menu */
        .user-menu {
            display: flex;
            align-items: center;
            gap: 1rem;
            position: relative;
            z-index: 1000;
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            cursor: pointer;
            padding: 0.5rem 0.75rem;
            border-radius: 25px;
            background: rgba(255, 255, 255, 0.1);
            transition: all 0.3s;
            max-width: 200px;
            overflow: hidden;
        }

        .user-info:hover {
            background: rgba(255, 255, 255, 0.15);
        }

        .user-avatar {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            background-size: cover;
            background-position: center;
            border: 1px solid rgba(255, 255, 255, 0.3);
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            font-size: 0.8rem;
            background: linear-gradient(45deg, var(--primary), var(--secondary));
            color: white;
            flex-shrink: 0;
        }

        .user-avatar img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 50%;
        }

        .user-info span {
            font-size: 0.9rem;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            max-width: 120px;
        }

        .user-dropdown {
            position: absolute;
            top: calc(100% + 10px);
            right: 0;
            background: var(--darker-bg);
            backdrop-filter: blur(10px);
            border-radius: 10px;
            padding: 1rem;
            min-width: 200px;
            border: 1px solid var(--border-color);
            opacity: 0;
            visibility: hidden;
            transform: translateY(-10px);
            transition: all 0.3s ease-in-out;
            z-index: 9999;
            max-height: none;
            overflow-y: visible;
        }

        .user-dropdown.show {
            opacity: 1;
            visibility: visible;
            transform: translateY(0);
        }

        .dropdown-item {
            display: block;
            color: var(--text-light);
            text-decoration: none;
            padding: 0.75rem 0.5rem;
            border-bottom: 1px solid var(--border-color);
            transition: background 0.3s, color 0.3s;
            white-space: nowrap;
        }

        .dropdown-item:last-child {
            border-bottom: none;
        }

        .dropdown-item:hover {
            background: rgba(102, 122, 255, 0.2);
            color: var(--primary);
        }

        /* Ensure dropdown is visible */
        .user-dropdown.show {
            opacity: 1;
            visibility: visible;
            transform: translateY(0);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.3);
        }

        /* Dropdown positioned above */
        .user-dropdown.show[style*="bottom"] {
            transform: translateY(0);
            box-shadow: 0 -10px 25px rgba(0, 0, 0, 0.3);
        }

        /* Back Button */
        .back-button-container {
            margin-bottom: 2rem;
        }

        .back-button {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.75rem 1.5rem;
            background: var(--card-bg);
            color: var(--text-light);
            text-decoration: none;
            border-radius: 8px;
            border: 1px solid var(--border-color);
            transition: all 0.3s ease;
            font-weight: 500;
        }

        .back-button:hover {
            background: var(--primary);
            color: white;
            transform: translateX(-5px);
        }

        .back-button i {
            font-size: 0.9rem;
        }

        /* Main Content */
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 2rem;
            min-height: calc(100vh - 200px);
            position: relative;
            z-index: 1;
        }

        .header {
            text-align: center;
            margin-bottom: 3rem;
            position: relative;
            z-index: 1;
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
            position: relative;
            z-index: 1;
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
            position: relative;
            z-index: 1;
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

        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #667aff;
        }

        .form-group textarea {
            resize: vertical;
            min-height: 120px;
        }

        .submit-btn {
            background: #667aff;
            color: white;
            border: none;
            padding: 1rem 2rem;
            border-radius: 8px;
            cursor: pointer;
            font-size: 1rem;
            font-weight: 500;
            transition: background 0.3s;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .submit-btn:hover {
            background: #5566dd;
        }

        .support-requests {
            background: #21262d;
            border-radius: 10px;
            padding: 2rem;
            position: relative;
            z-index: 1;
        }

        .request-item {
            border: 1px solid #30363d;
            border-radius: 8px;
            padding: 1.5rem;
            margin-bottom: 1rem;
            background: #161b22;
        }

        .request-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
        }

        .request-subject {
            font-size: 1.2rem;
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
            color: #fff;
        }

        .status-resolved {
            background: #00cc66;
            color: #fff;
        }

        .status-closed {
            background: #8b949e;
            color: #fff;
        }

        .request-meta {
            display: flex;
            gap: 1rem;
            margin-bottom: 1rem;
            color: #8b949e;
            font-size: 0.875rem;
        }

        .request-content {
            color: #e6edf3;
            line-height: 1.6;
            margin-bottom: 1rem;
        }

        .admin-response {
            background: #2d3748;
            padding: 1rem;
            border-radius: 6px;
            margin-top: 1rem;
        }

        .admin-response h4 {
            color: #667aff;
            margin-bottom: 0.5rem;
        }

        .admin-response p {
            color: #e6edf3;
            margin-bottom: 0.5rem;
        }

        .admin-response small {
            color: #8b949e;
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

        .empty-state h3 {
            margin-bottom: 0.5rem;
            color: #e6edf3;
        }

        /* File upload styles */
        .file-input {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid #30363d;
            border-radius: 6px;
            background: #161b22;
            color: #e6edf3;
            font-size: 1rem;
        }

        .file-info {
            margin-top: 0.5rem;
            color: #8b949e;
            font-size: 0.875rem;
        }

        .file-info small {
            display: block;
            margin-bottom: 0.25rem;
        }

        .file-list {
            margin-top: 1rem;
        }

        .file-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0.75rem;
            background: #161b22;
            border: 1px solid #30363d;
            border-radius: 6px;
            margin-bottom: 0.5rem;
        }

        .file-item-info {
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .file-icon {
            font-size: 1.25rem;
            color: #667aff;
        }

        .file-details {
            flex: 1;
        }

        .file-name {
            color: #e6edf3;
            font-weight: 500;
            margin-bottom: 0.25rem;
        }

        .file-size {
            color: #8b949e;
            font-size: 0.875rem;
        }

        .file-remove {
            background: #dc3545;
            color: white;
            border: none;
            padding: 0.5rem;
            border-radius: 4px;
            cursor: pointer;
            font-size: 0.875rem;
            transition: background 0.3s;
        }

        .file-remove:hover {
            background: #c82333;
        }

        .attachment-list {
            margin-top: 1rem;
        }

        .attachment-item {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            padding: 0.5rem;
            background: #161b22;
            border-radius: 4px;
            margin-bottom: 0.5rem;
        }

        .attachment-icon {
            color: #667aff;
            font-size: 1rem;
        }

        .attachment-name {
            color: #e6edf3;
            font-size: 0.875rem;
        }

        .attachment-download {
            color: #667aff;
            text-decoration: none;
            font-size: 0.875rem;
        }

        .attachment-download:hover {
            text-decoration: underline;
        }

        .attachment-actions {
            display: flex;
            gap: 0.5rem;
            margin-left: auto;
        }

        .attachment-view {
            color: #28a745;
            text-decoration: none;
            font-size: 0.875rem;
        }

        .attachment-view:hover {
            text-decoration: underline;
        }

        /* Footer */
        .footer {
            background: var(--darker-bg);
            color: var(--text-muted);
            padding: 3rem 0 1rem;
            margin-top: 4rem;
            border-top: 1px solid var(--border-color);
        }

        .footer-content {
            max-width: 1400px;
            margin: 0 auto;
            padding: 0 2rem;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 2rem;
        }

        .footer-section h3 {
            color: var(--primary);
            margin-bottom: 1rem;
            font-size: 1.2rem;
        }

        .footer-section ul {
            list-style: none;
        }

        .footer-section ul li {
            margin-bottom: 0.5rem;
        }

        .footer-section ul li a {
            color: var(--text-muted);
            text-decoration: none;
            transition: color 0.3s;
        }

        .footer-section ul li a:hover {
            color: var(--text-light);
        }

        .footer-bottom {
            text-align: center;
            margin-top: 2rem;
            padding-top: 1rem;
            border-top: 1px solid var(--border-color);
        }

        /* Responsive */
        @media (max-width: 768px) {
            .nav-center-content {
                display: none;
            }
            
            .container {
                padding: 1rem;
            }
            
            .support-tabs {
                flex-direction: column;
            }
            
            .request-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 0.5rem;
            }

            .user-info {
                max-width: 150px;
                padding: 0.5rem;
            }

            .user-info span {
                max-width: 80px;
                font-size: 0.8rem;
            }

            .user-avatar {
                width: 28px;
                height: 28px;
                font-size: 0.7rem;
            }
        }

        @media (max-width: 480px) {
            .user-info {
                max-width: 120px;
            }

            .user-info span {
                max-width: 60px;
                font-size: 0.75rem;
            }

            .user-avatar {
                width: 24px;
                height: 24px;
                font-size: 0.6rem;
            }

            .user-dropdown {
                right: -10px;
                min-width: 180px;
                max-height: 250px;
            }
        }
    </style>
</head>
<body>
    <!-- Header -->
    <header class="header">
        <nav class="nav">
            <a href="${pageContext.request.contextPath}/home" class="logo">MasterTicket</a>

            <div class="nav-center-content">
                <ul class="nav-links">
                    <li><a href="${pageContext.request.contextPath}/home"><i class="fas fa-home"></i> Trang chủ</a></li>
                    <li><a href="${pageContext.request.contextPath}/home#hot-events"><i class="fas fa-fire"></i> Sự kiện hot</a></li>
                    <li><a href="${pageContext.request.contextPath}/home#vouchers"><i class="fas fa-tags"></i> Săn voucher</a></li>
                    <li><a href="${pageContext.request.contextPath}/support" class="active"><i class="fas fa-question-circle"></i> Hỗ trợ</a></li>
                </ul>
            </div>

            <div class="auth-buttons">
                <c:choose>
                    <c:when test="${sessionScope.user != null}">
                        <div class="user-menu">
                            <div class="user-info" onclick="toggleUserDropdown()">
                                <div class="user-avatar">
                                    <c:if test="${not empty sessionScope.user.avatar}">
                                        <img src="${pageContext.request.contextPath}/uploads/user_avatar/${sessionScope.user.avatar}" alt="Avatar">
                                    </c:if>
                                    <c:if test="${empty sessionScope.user.avatar}">
                                        ${fn:substring(sessionScope.user.email, 0, 1)}
                                    </c:if>
                                </div>
                                Xin chào, ${sessionScope.user.name != null ? sessionScope.user.name : sessionScope.user.email} <span style="margin-left: 0.5rem;">▼</span>
                            </div>
                            <div class="user-dropdown" id="userDropdown">
                                <a href="${pageContext.request.contextPath}/updateProfile" class="dropdown-item">👤 Thông tin cá nhân</a>
                                <a href="${pageContext.request.contextPath}/TicketOrderHistoryServlet" class="dropdown-item">🎫 Vé đã mua</a>
                                <a href="${pageContext.request.contextPath}/favoriteEvents" class="dropdown-item">❤️ Sự kiện yêu thích</a>
                                <a href="${pageContext.request.contextPath}/settings" class="dropdown-item">⚙️ Cài đặt</a>
                                <hr style="border: none; border-top: 1px solid var(--border-color); margin: 0.5rem 0;">
                                <a href="${pageContext.request.contextPath}/logout" class="dropdown-item" style="color: var(--danger);">🚪 Đăng xuất</a>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/login" class="btn btn-outline">Đăng nhập</a>
                        <a href="${pageContext.request.contextPath}/register" class="btn btn-primary">Đăng ký</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </nav>
    </header>

    <div class="container">
        <!-- Back Button -->
        <div class="back-button-container">
            <a href="${pageContext.request.contextPath}/home" class="back-button">
                <i class="fas fa-arrow-left"></i> Quay lại
            </a>
        </div>

        <div class="header">
            <h1><i class="fas fa-headset"></i> Trung tâm hỗ trợ</h1>
            <p>Chúng tôi luôn sẵn sàng hỗ trợ bạn 24/7</p>
        </div>

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
                <c:if test="${not empty error}">
                    <div style="background: #dc3545; color: white; padding: 1rem; border-radius: 6px; margin-bottom: 1rem;">
                        ${error}
                    </div>
                </c:if>
                
                <c:if test="${not empty success}">
                    <div style="background: #00cc66; color: white; padding: 1rem; border-radius: 6px; margin-bottom: 1rem;">
                        ${success}
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/support" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="submit-request">
                    
                    <div class="form-group">
                        <label for="subject">Tiêu đề</label>
                        <input type="text" id="subject" name="subject" required 
                               placeholder="Nhập tiêu đề yêu cầu hỗ trợ...">
                    </div>

                    <div class="form-group">
                        <label for="category">Danh mục</label>
                        <select id="category" name="category" required>
                            <option value="">Chọn danh mục</option>
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
                        <select id="priority" name="priority" required>
                            <option value="">Chọn mức độ</option>
                            <option value="LOW">Thấp</option>
                            <option value="MEDIUM">Trung bình</option>
                            <option value="HIGH">Cao</option>
                            <option value="URGENT">Khẩn cấp</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="content">Nội dung</label>
                        <textarea id="content" name="content" required 
                                  placeholder="Mô tả chi tiết vấn đề của bạn..."></textarea>
                    </div>

                    <div class="form-group">
                        <label for="attachments">Tệp đính kèm</label>
                        <input type="file" id="attachments" name="attachments" multiple 
                               accept=".jpg,.jpeg,.png,.gif,.bmp,.pdf,.doc,.docx,.txt,.zip,.rar,.exe"
                               class="file-input">
                        <div class="file-info">
                            <small>Hỗ trợ: Ảnh (JPG, PNG, GIF), Tài liệu (PDF, DOC, DOCX, TXT), Nén (ZIP, RAR), Thực thi (EXE)</small>
                            <small>Tối đa 5 file, mỗi file tối đa 10MB</small>
                        </div>
                        <div id="file-list" class="file-list"></div>
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
                                    <span><i class="fas fa-tag"></i> 
                                        <c:choose>
                                            <c:when test="${request.category == 'GENERAL'}">Chung</c:when>
                                            <c:when test="${request.category == 'TECHNICAL'}">Kỹ thuật</c:when>
                                            <c:when test="${request.category == 'PAYMENT'}">Thanh toán</c:when>
                                            <c:when test="${request.category == 'TICKET'}">Vé sự kiện</c:when>
                                            <c:when test="${request.category == 'ACCOUNT'}">Tài khoản</c:when>
                                            <c:when test="${request.category == 'OTHER'}">Khác</c:when>
                                            <c:otherwise>${request.category}</c:otherwise>
                                        </c:choose>
                                    </span>
                                    <span><i class="fas fa-flag"></i> 
                                        <c:choose>
                                            <c:when test="${request.priority == 'LOW'}">Thấp</c:when>
                                            <c:when test="${request.priority == 'MEDIUM'}">Trung bình</c:when>
                                            <c:when test="${request.priority == 'HIGH'}">Cao</c:when>
                                            <c:when test="${request.priority == 'URGENT'}">Khẩn cấp</c:when>
                                            <c:otherwise>${request.priority}</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                                
                                <div class="request-content">
                                    ${request.content}
                                </div>

                                <!-- Hiển thị file đính kèm -->
                                <c:if test="${not empty request.attachments}">
                                    <div class="attachment-list">
                                        <h4><i class="fas fa-paperclip"></i> Tệp đính kèm:</h4>
                                        <c:forEach var="attachment" items="${request.attachments}">
                                            <div class="attachment-item">
                                                <i class="attachment-icon ${attachment.iconClass}"></i>
                                                <span class="attachment-name">${attachment.originalFileName}</span>
                                                <div class="attachment-actions">
                                                    <a href="${pageContext.request.contextPath}/support?action=download&fileId=${attachment.attachmentId}" 
                                                       class="attachment-download"
                                                       target="_blank"
                                                       rel="noopener noreferrer"
                                                       download="${attachment.originalFileName}">
                                                        <i class="fas fa-download"></i> Tải xuống
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/support?action=view&fileId=${attachment.attachmentId}" 
                                                       class="attachment-view"
                                                       target="_blank"
                                                       rel="noopener noreferrer">
                                                        <i class="fas fa-eye"></i> Xem file
                                                    </a>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:if>

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
                            <p>Bạn chưa gửi yêu cầu hỗ trợ nào. Hãy gửi yêu cầu đầu tiên!</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="footer">
        <div class="footer-content">
            <div class="footer-section">
                <h3>MasterTicket</h3>
                <p>Nền tảng đặt vé sự kiện hàng đầu Việt Nam. Khám phá và tham gia các sự kiện thú vị cùng chúng tôi.</p>
            </div>
            <div class="footer-section">
                <h3>Liên kết nhanh</h3>
                <ul>
                    <li><a href="${pageContext.request.contextPath}/home">Trang chủ</a></li>
                    <li><a href="${pageContext.request.contextPath}/home#hot-events">Sự kiện hot</a></li>
                    <li><a href="${pageContext.request.contextPath}/home#vouchers">Săn voucher</a></li>
                    <li><a href="${pageContext.request.contextPath}/support">Hỗ trợ</a></li>
                </ul>
            </div>
            <div class="footer-section">
                <h3>Hỗ trợ</h3>
                <ul>
                    <li><a href="${pageContext.request.contextPath}/support">Trung tâm hỗ trợ</a></li>
                    <li><a href="${pageContext.request.contextPath}/faq">Câu hỏi thường gặp</a></li>
                    <li><a href="${pageContext.request.contextPath}/contact">Liên hệ</a></li>
                    <li><a href="${pageContext.request.contextPath}/terms">Điều khoản sử dụng</a></li>
                </ul>
            </div>
        </div>
        <div class="footer-bottom">
            <p>&copy; 2025 MasterTicket. Tất cả quyền được bảo lưu.</p>
        </div>
    </footer>

    <script>
        function showTab(tabName) {
            // Hide all tab contents
            const tabContents = document.querySelectorAll('.tab-content');
            tabContents.forEach(content => {
                content.classList.remove('active');
            });

            // Remove active class from all tab buttons
            const tabButtons = document.querySelectorAll('.tab-button');
            tabButtons.forEach(button => {
                button.classList.remove('active');
            });

            // Show selected tab content
            document.getElementById(tabName).classList.add('active');

            // Add active class to clicked button
            event.target.classList.add('active');
        }

        function toggleUserDropdown() {
            const dropdown = document.getElementById('userDropdown');
            dropdown.classList.toggle('show');
            
            if (dropdown.classList.contains('show')) {
                // Check if dropdown goes below viewport
                const rect = dropdown.getBoundingClientRect();
                const viewportHeight = window.innerHeight;
                
                if (rect.bottom > viewportHeight) {
                    // Position dropdown above the user menu
                    dropdown.style.top = 'auto';
                    dropdown.style.bottom = 'calc(100% + 10px)';
                } else {
                    // Reset to default position
                    dropdown.style.top = 'calc(100% + 10px)';
                    dropdown.style.bottom = 'auto';
                }
            }
        }

        // Close dropdown when clicking outside
        document.addEventListener('click', function(event) {
            if (!event.target.matches('.user-info') && !event.target.matches('.user-info *')) {
                const dropdowns = document.getElementsByClassName('user-dropdown');
                for (let dropdown of dropdowns) {
                    if (dropdown.classList.contains('show')) {
                        dropdown.classList.remove('show');
                    }
                }
            }
        });

        // File upload handling
        document.getElementById('attachments').addEventListener('change', function(e) {
            console.log('File input changed');
            const fileList = document.getElementById('file-list');
            fileList.innerHTML = '';
            
            const files = e.target.files;
            console.log('Number of files selected:', files.length);
            
            if (files.length > 5) {
                alert('Chỉ được chọn tối đa 5 file!');
                e.target.value = '';
                return;
            }
            
            for (let i = 0; i < files.length; i++) {
                const file = files[i];
                console.log('Processing file:', file.name, 'Size:', file.size);
                
                // Check file size (10MB = 10 * 1024 * 1024 bytes)
                if (file.size > 10 * 1024 * 1024) {
                    alert(`File ${file.name} quá lớn! Kích thước tối đa là 10MB.`);
                    continue;
                }
                
                const fileItem = document.createElement('div');
                fileItem.className = 'file-item';
                
                const fileIcon = getFileIcon(file.name);
                const fileSize = formatFileSize(file.size);
                
                fileItem.innerHTML = `
                    <div class="file-item-info">
                        <i class="file-icon ${fileIcon}"></i>
                        <div class="file-details">
                            <div class="file-name">${file.name}</div>
                            <div class="file-size">${fileSize}</div>
                        </div>
                    </div>
                    <button type="button" class="file-remove" onclick="removeFile(${i})">
                        <i class="fas fa-times"></i>
                    </button>
                `;
                
                fileList.appendChild(fileItem);
                console.log('File item added to list');
            }
        });

        function getFileIcon(fileName) {
            const extension = fileName.split('.').pop().toLowerCase();
            switch (extension) {
                case 'jpg':
                case 'jpeg':
                case 'png':
                case 'gif':
                case 'bmp':
                    return 'fas fa-image';
                case 'pdf':
                    return 'fas fa-file-pdf';
                case 'doc':
                case 'docx':
                    return 'fas fa-file-word';
                case 'txt':
                    return 'fas fa-file-alt';
                case 'zip':
                case 'rar':
                    return 'fas fa-file-archive';
                case 'exe':
                    return 'fas fa-cog';
                default:
                    return 'fas fa-file';
            }
        }

        function formatFileSize(bytes) {
            if (bytes === 0) return '0 Bytes';
            const k = 1024;
            const sizes = ['Bytes', 'KB', 'MB', 'GB'];
            const i = Math.floor(Math.log(bytes) / Math.log(k));
            return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
        }

        function removeFile(index) {
            const input = document.getElementById('attachments');
            const dt = new DataTransfer();
            const { files } = input;
            
            for (let i = 0; i < files.length; i++) {
                if (i !== index) {
                    dt.items.add(files[i]);
                }
            }
            
            input.files = dt.files;
            input.dispatchEvent(new Event('change'));
        }

        // Load user requests when page loads
        window.onload = function() {
            console.log('Page loaded');
            const fileInput = document.getElementById('attachments');
            const fileList = document.getElementById('file-list');
            console.log('File input found:', fileInput);
            console.log('File list found:', fileList);
            
            // Ensure download links work properly
            const downloadLinks = document.querySelectorAll('.attachment-download');
            downloadLinks.forEach(link => {
                link.addEventListener('click', function(e) {
                    // Allow the download to proceed normally
                    console.log('Download link clicked:', this.href);
                });
            });
        };
    </script>
</body>
</html> 