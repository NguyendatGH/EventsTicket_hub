
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Quản lý sự kiện</title>
    <style>
        :root {
            --primary-bg: #070a17;
            --secondary-bg: rgba(15, 23, 42, 0.9);
            --accent-blue: #0f67ff;
            --text-primary: #ffffff;
            --text-secondary: #94a3b8;
            --border-light: rgba(255, 255, 255, 0.2);
            --border-dark: rgba(255, 255, 255, 0.1);
            --success-green: #28a745;
            --error-red: #ff0c0c;
            --card-bg: rgba(255, 255, 255, 0.08);
            --shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
        }

        body {
            min-height: 100vh;
            background: var(--primary-bg);
            color: var(--text-primary);
            overflow-x: hidden;
            position: relative;
        }

        .container {
            display: flex;
            position: relative;
            z-index: 1;
        }

        .sidebar {
            width: 280px;
            background: var(--secondary-bg);
            backdrop-filter: blur(20px);
            padding: 2rem 0;
            transition: transform 0.3s ease;
            position: fixed;
            height: 100%;
            z-index: 1100;
            border-right: 1px solid var(--border-dark);
        }

        .logo {
            font-size: 1.75rem;
            font-weight: 700;
            color: var(--text-primary);
            padding: 0 2rem;
            margin-bottom: 3rem;
            letter-spacing: 0.5px;
        }

        .admin-section {
            padding: 0 2rem;
            margin-bottom: 2rem;
            text-align: center;
        }

        .admin-avatar {
            width: 100px;
            height: 100px;
            background: var(--card-bg);
            border-radius: 50%;
            margin: 0 auto 1.5rem;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: var(--shadow);
        }

        .admin-avatar svg {
            width: 60px;
            height: 60px;
            color: var(--text-secondary);
        }

        .admin-name {
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 0.25rem;
        }

        .admin-role {
            font-size: 0.875rem;
            color: var(--text-secondary);
            font-weight: 400;
        }

        .nav-menu {
            list-style: none;
        }

        .nav-item {
            border-bottom: 1px solid var(--border-dark);
        }

        .nav-link {
            display: flex;
            align-items: center;
            padding: 1rem 2rem;
            color: var(--text-secondary);
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
            position: relative;
        }

        .nav-link:hover,
        .nav-link.active {
            background: var(--card-bg);
            color: var(--text-primary);
            box-shadow: inset 4px 0 0 var(--accent-blue);
        }

        .logout {
            position: absolute;
            bottom: 2rem;
            left: 2rem;
            right: 2rem;
            color: var(--text-secondary);
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            font-weight: 500;
            transition: color 0.3s ease;
        }

        .logout:hover {
            color: var(--text-primary);
        }

        .main-content {
            flex: 1;
            margin-left: 280px;
            padding: 2rem 3rem;
            overflow-y: auto;
            display: flex;
            flex-direction: column;
            gap: 2rem;
        }

        .top-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
        }

恒
        .breadcrumb {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            font-size: 0.875rem;
            font-weight: 500;
            background: var(--card-bg);
            border-radius: 8px;
            padding: 0.75rem 1.25rem;
            box-shadow: var(--shadow);
        }

        .breadcrumb-item {
            color: var(--text-secondary);
        }

        .breadcrumb-current {
            color: var(--text-primary);
            font-weight: 600;
        }

        .section-title {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 1.5rem;
        }

        .event-name-section {
            background: var(--card-bg);
            border-radius: 12px;
            padding: 1.5rem;
            border: 1px solid var(--border-dark);
            box-shadow: var(--shadow);
        }

        .event-input-group {
            display: flex;
            align-items: center;
            gap: 1.5rem;
        }

        .event-label {
            font-size: 0.9375rem;
            font-weight: 500;
            color: var(--text-secondary);
            min-width: 100px;
        }

        .event-input {
            flex: 1;
            padding: 0.75rem 1rem;
            background: var(--card-bg);
            border: 1px solid var(--border-light);
            color: var(--text-primary);
            font-size: 1.125rem;
            font-weight: 500;
            border-radius: 8px;
            transition: border-color 0.3s ease;
        }

        .event-input:focus {
            outline: none;
            border-color: var(--accent-blue);
            box-shadow: 0 0 0 3px rgba(15, 103, 255, 0.2);
        }

        .description-section {
            background: var(--card-bg);
            border-radius: 12px;
            padding: 1.5rem;
            border: 1px solid var(--border-dark);
            box-shadow: var(--shadow);
        }

        .description-title {
            font-size: 1rem;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 1rem;
        }

        .description-text {
            width: 100%;
            background: var(--card-bg);
            border: 1px solid var(--border-light);
            border-radius: 8px;
            padding: 0.75rem;
            color: var(--text-primary);
            font-size: 1rem;
            line-height: 1.6;
            resize: vertical;
            transition: border-color 0.3s ease;
        }

        .description-text:focus {
            outline: none;
            border-color: var(--accent-blue);
            box-shadow: 0 0 0 3px rgba(15, 103, 255, 0.2);
        }

        .details-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1.5rem;
        }

        .details-section {
            background: var(--card-bg);
            border-radius: 12px;
            padding: 1.5rem;
            border: 1px solid var(--border-dark);
            box-shadow: var(--shadow);
        }

        .detail-item {
            display: flex;
            align-items: center;
            gap: 1rem;
            margin-bottom: 1.5rem;
        }

        .detail-item:last-child {
            margin-bottom: 0;
        }

        .detail-label {
            font-size: 0.875rem;
            font-weight: 500;
            color: var(--text-secondary);
            min-width: 80px;
        }

        .detail-value {
            flex: 1;
            padding: 0.75rem;
            background: var(--card-bg);
            border: 1px solid var(--border-light);
            color: var(--text-primary);
            font-size: 0.9375rem;
            border-radius: 8px;
            transition: border-color 0.3s ease;
        }

        .detail-value:focus {
            outline: none;
            border-color: var(--accent-blue);
            box-shadow: 0 0 0 3px rgba(15, 103, 255, 0.2);
        }

        .events-material {
            margin-bottom: 2rem;
        }

        .material-header {
            font-size: 1.125rem;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 1rem;
        }

        .material-wrapper {
            border: 2px dashed var(--accent-blue);
            border-radius: 12px;
            padding: 2rem;
            background: var(--card-bg);
            box-shadow: var(--shadow);
        }

        .banner-header {
            font-size: 1rem;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 1rem;
        }

        .img-wrapper {
            width: 100%;
            max-width: 600px;
            margin: 0 auto;
        }

        .img-wrapper img {
            width: 100%;
            height: auto;
            max-height: 400px;
            object-fit: cover;
            border-radius: 12px;
            border: 1px solid var(--border-light);
            transition: transform 0.3s ease;
        }

        .img-wrapper img:hover {
            transform: scale(1.02);
        }

        .upload-section {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 0.75rem;
            margin-top: 1.5rem;
        }

        .upload-label {
            font-size: 0.875rem;
            color: var(--text-secondary);
            font-weight: 500;
        }

        .upload-input {
            padding: 0.75rem;
            background: var(--card-bg);
            border: 2px dashed var(--border-light);
            color: var(--text-primary);
            border-radius: 8px;
            cursor: pointer;
            text-align: center;
            transition: border-color 0.3s ease;
        }

        .upload-input:hover {
            border-color: var(--accent-blue);
        }

        .file-info {
            font-size: 0.75rem;
            color: var(--text-secondary);
            text-align: center;
        }

        .event-option {
            display: flex;
            gap: 1rem;
            justify-content: flex-end;
        }

        .btn {
            padding: 0.75rem 1.5rem;
            font-size: 0.9375rem;
            font-weight: 600;
            color: var(--text-primary);
            border-radius: 8px;
            border: none;
            cursor: pointer;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn.save {
            background: var(--success-green);
        }

        .btn.save:hover {
            background: #218838;
            box-shadow: 0 4px 12px rgba(40, 167, 69, 0.3);
        }

        .btn.reject {
            background: transparent;
            border: 1px solid var(--accent-blue);
        }

        .btn.reject:hover {
            background: var(--accent-blue);
            color: var(--text-primary);
            box-shadow: 0 4px 12px rgba(15, 103, 255, 0.3);
        }

        .hamburger {
            display: none;
            position: fixed;
            top: 1.5rem;
            right: 1.5rem;
            z-index: 1200;
            background: var(--card-bg);
            border: none;
            padding: 0.5rem;
            cursor: pointer;
            border-radius: 8px;
        }

        .hamburger span {
            display: block;
            width: 24px;
            height: 3px;
            background: var(--text-primary);
            margin: 4px 0;
            transition: all 0.3s ease;
        }

        .hamburger.active span:nth-child(1) {
            transform: rotate(45deg) translate(5px, 5px);
        }

        .hamburger.active span:nth-child(2) {
            opacity: 0;
        }

        .hamburger.active span:nth-child(3) {
            transform: rotate(-45deg) translate(7px, -7px);
        }

        .overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            backdrop-filter: blur(5px);
            z-index: 1000;
            opacity: 0;
            transition: opacity 0.3s ease;
        }

        .overlay.active {
            display: block;
            opacity: 1;
        }

        .bg_elips {
            width: 700px;
            height: 700px;
            object-fit: cover;
            position: fixed;
            z-index: -1;
            pointer-events: none;
            opacity: 0.6;
            filter: blur(50px);
        }

        .firstElement {
            top: -150px;
            left: -100px;
        }

        .secondElement {
            bottom: -200px;
            right: -150px;
        }

        ::-webkit-scrollbar {
            width: 10px;
        }

        ::-webkit-scrollbar-track {
            background: var(--card-bg);
            border-radius: 10px;
        }

        ::-webkit-scrollbar-thumb {
            background: var(--accent-blue);
            border-radius: 10px;
        }

        ::-webkit-scrollbar-thumb:hover {
            background: #0d55cc;
        }

        .error-message {
            background: rgba(255, 12, 12, 0.1);
            color: var(--error-red);
            padding: 0.75rem 1rem;
            border-radius: 8px;
            font-size: 0.875rem;
            margin-bottom: 1.5rem;
            box-shadow: var(--shadow);
        }

        .success-message {
            background: rgba(40, 167, 69, 0.1);
            color: var(--success-green);
            padding: 0.75rem 1rem;
            border-radius: 8px;
            font-size: 0.875rem;
            margin-bottom: 1.5rem;
            box-shadow: var(--shadow);
        }

        @media (max-width: 1400px) {
            .main-content {
                padding: 1.5rem 2rem;
            }
        }

        @media (max-width: 1200px) {
            .details-grid {
                grid-template-columns: 1fr;
            }

            .sidebar {
                width: 260px;
            }

            .main-content {
                margin-left: 260px;
            }

            .bg_elips {
                width: 600px;
                height: 600px;
            }
        }

        @media (max-width: 992px) {
            .sidebar {
                transform: translateX(-100%);
            }

            .sidebar.active {
                transform: translateX(0);
            }

            .main-content {
                margin-left: 0;
                padding: 1.5rem;
            }

            .hamburger {
                display: flex;
            }

            .event-input-group {
                flex-direction: column;
                align-items: stretch;
            }

            .event-input,
            .detail-value,
            .description-text {
                width: 100%;
            }

            .bg_elips {
                width: 500px;
                height: 500px;
            }
        }

        @media (max-width: 768px) {
            .main-content {
                padding: 1rem;
            }

            .top-bar {
                flex-direction: column;
                align-items: flex-start;
                gap: 1rem;
            }

            .event-input {
                font-size: 1rem;
            }

            .bg_elips {
                width: 400px;
                height: 400px;
                opacity: 0.5;
            }
        }

        @media (max-width: 576px) {
            .sidebar {
                width: 100%;
            }

            .event-option {
                flex-direction: column;
                gap: 0.75rem;
            }

            .btn {
                width: 100%;
                justify-content: center;
            }

            .bg_elips {
                width: 300px;
                height: 300px;
                opacity: 0.4;
            }

            .event-input,
            .description-text,
            .detail-value {
                font-size: 0.875rem;
            }
        }

        @keyframes float {
            0% {
                transform: translateY(0);
            }
            50% {
                transform: translateY(-15px);
            }
            100% {
                transform: translateY(0);
            }
        }
    </style>
</head>
<body>
    <img
      class="bg_elips firstElement"
      src="${pageContext.request.contextPath}/asset/image/full.svg"
    />
    <img
      class="bg_elips secondElement"
      src="${pageContext.request.contextPath}/asset/image/full2.svg"
    />
    <button class="hamburger">
        <span></span>
        <span></span>
        <span></span>
    </button>
    <div class="container">
        <div class="overlay"></div>
      <aside class="sidebar">
        <div class="logo">EventTicketHub</div>
        <div class="admin-section">
          <div class="admin-avatar">
            <svg fill="currentColor" viewBox="0 0 24 24">
              <path
                d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"
              />
            </svg>
          </div>
          <div class="admin-name">Admin</div>
          <div class="admin-role">Quản lý website </div>
        </div>
        <nav>
          <ul class="nav-menu">
            <li class="nav-item">
              <a
                href="${pageContext.request.contextPath}/admin-servlet/dashboard"
                class="nav-link active"
                >Bảng điều khiển</a
              >
            </li>
            <li class="nav-item">
              <a
                href="${pageContext.request.contextPath}/admin-servlet/event-management"
                class="nav-link"
                >Danh sách sự kiện</a
              >
            </li>
            <li class="nav-item">
              <a
                href="${pageContext.request.contextPath}/admin-servlet/user-management"
                class="nav-link"
                >Danh sách tài khoản</a
              >
            </li>
            <li class="nav-item">
              <a
                href="${pageContext.request.contextPath}/admin-servlet/transaction-management"
                class="nav-link"
                >Danh sách giao dịch</a
              >
            </li>
            <li class="nav-item">
              <a
                href="${pageContext.request.contextPath}/admin/refund"
                class="nav-link"
                >Quản lý hoàn tiền</a
              >
            </li>
            <li class="nav-item">
              <a
                href="${pageContext.request.contextPath}/admin-servlet/support-center"
                class="nav-link"
                >Hỗ trợ khách hàng</a
              >
            </li>
          </ul>
        </nav>
        <a href="${pageContext.request.contextPath}/logout" class="logout">
          <svg width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
            <path d="M16 13v-2H7V8l-5 4 5 4v-3z" />
            <path d="M20 3h-9c-1.103 0-2 .897-2 2v4h2V5h9v14h-9v-4H9v4c0 1.103.897 2 2 2h9c1.103 0 2-.897 2-2V5c0-1.103-.897-2-2-2z" />
          </svg>
          Đăng xuất
        </a>
      </aside>
        <main class="main-content">
            <div class="top-bar">
                <div class="breadcrumb">
                    <span class="breadcrumb-item">Bảng điều khiển</span>
                    <span style="color: white">/</span>
                    <span class="breadcrumb-current">Chi tiết sự kiện</span>
                </div>
            </div>
            <c:if test="${not empty error}">
                <div class="error-message">${error}</div>
            </c:if>
            <c:if test="${not empty success}">
                <div class="success-message">${success}</div>
            </c:if>
            <form id="updateEventForm" action="${pageContext.request.contextPath}/admin-servlet/event-management" method="POST" enctype="multipart/form-data" onsubmit="return validateForm()">
                <input type="hidden" name="action" value="update" />
                <input type="hidden" name="eventID" value="${event.eventID}" />
                <div class="section">
                    <h2 class="section-title">Tổng quan</h2>
                </div>
                <div class="event-name-section">
                    <div class="event-input-group">
                        <span class="event-label">Tên sự kiện:</span>
                        <input type="text" class="event-input" name="name" value="${event.name}" required maxlength="100" />
                    </div>
                </div>
                <div class="description-section">
                    <h3 class="description-title">Mô tả</h3>
                    <textarea class="description-text" name="description" rows="5">${event.description}</textarea>
                </div>
                <div class="details-grid">
                    <div class="details-section">
                   <div class="detail-item">
                            <span class="detail-label">Chủ sở hữu:</span>
                            <input type="text" class="detail-value" name="Ownername" value="${ownerName}" disabled />
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">Thời gian bắt đầu:</span>
                            <input type="datetime-local" class="detail-value" name="startTime" value="<fmt:formatDate value='${event.startTime}' pattern='yyyy-MM-dd\'T\'HH:mm' />" required />
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">Thời gian kết thúc:</span>
                            <input type="datetime-local" class="detail-value" name="endTime" value="<fmt:formatDate value='${event.endTime}' pattern='yyyy-MM-dd\'T\'HH:mm' />" required />
                        </div>
                    </div>
                    <div class="details-section">
                        <div class="detail-item">
                            <span class="detail-label">Địa điểm:</span>
                            <input type="text" class="detail-value" name="physicalLocation" value="${event.physicalLocation}" required maxlength="200" />
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">Số lượng vé:</span>
                            <input type="number" class="detail-value" name="totalTicketCount" value="${event.totalTicketCount}" required min="0" />
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">Trạng thái:</span>
                            <select name="status" class="detail-value">
                                <option value="pending" ${event.status == 'pending' ? 'selected' : ''}>Đang chờ duyệt</option>
                                <option value="active" ${event.status == 'active' ? 'selected' : ''}>Đang hoạt động</option>
                                <option value="cancelled" ${event.status == 'cancelled' ? 'selected' : ''}>Đã hủy</option>
                                <option value="completed" ${event.status == 'completed' ? 'selected' : ''}>Đã hoàn thành</option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="events-material">
            <h3 class="material-header">Hình ảnh sự kiện</h3>
            <div class="material-wrapper">
                <div class="banner">
                    <h3 class="banner-header">Ảnh đại diện sự kiện</h3>
                    <div class="banner-content content">
                        <div class="img-wrapper">
                            <c:choose>
                                <c:when test="${not empty event.imageURL}">
                                    <img id="imagePreview" src="${pageContext.request.contextPath}/uploads/event_banners/${event.imageURL}" alt="Hình ảnh sự kiện"  />
                                </c:when>
                                <c:otherwise>
                                    <img id="imagePreview" src="${pageContext.request.contextPath}/asset/image/MayLangThangAvt.svg" alt="Hình ảnh mặc định" />
                                </c:otherwise>
                            </c:choose>
                            <div class="upload-section">
                                <label for="imageFile" class="upload-label">Chọn ảnh từ máy tính</label>
                                <input type="file" id="imageFile" name="imageFile" accept="image/*" class="upload-input" onchange="previewImage(this)">
                                <div id="fileInfo" class="file-info">Định dạng: JPG, PNG, GIF | Tối đa: 5MB</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
                <div class="event-option">
                    <button type="submit" class="btn save">Cập nhật</button>
                    <a href="${pageContext.request.contextPath}/admin-servlet/event-management" class="btn reject">Quay lại</a>
                </div>
            </form>
        </main>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
      function animateEllipses() {
            const ellipses = document.querySelectorAll(".bg_elips");
            ellipses.forEach((ellipse, index) => {
                const duration = 8000 + index * 2000;
                ellipse.style.animation = `float ${duration}ms ease-in-out infinite`;
            });
        }

        const hamburger = document.querySelector('.hamburger');
        const sidebar = document.querySelector('.sidebar');
        const overlay = document.querySelector('.overlay');

        if (hamburger && sidebar && overlay) {
            hamburger.addEventListener('click', () => {
                hamburger.classList.toggle('active');
                sidebar.classList.toggle('active');
                overlay.classList.toggle('active');
            });

            document.querySelectorAll('.nav-link').forEach(link => {
                link.addEventListener('click', () => {
                    if (window.innerWidth <= 992) {
                        hamburger.classList.remove('active');
                        sidebar.classList.remove('active');
                        overlay.classList.remove('active');
                    }
                });
            });

            document.addEventListener('click', (e) => {
                if (window.innerWidth <= 992 && !sidebar.contains(e.target) && !hamburger.contains(e.target)) {
                    hamburger.classList.remove('active');
                    sidebar.classList.remove('active');
                    overlay.classList.remove('active');
                }
            });
        }

        function previewImage(input) {
            const file = input.files[0];
            const reader = new FileReader();
            const fileInfo = document.getElementById('fileInfo');
            
            reader.onloadend = function() {
                const preview = document.getElementById('imagePreview');
                if (preview) {
                    preview.src = reader.result;
                }
                
                if (fileInfo && file) {
                    const fileSize = (file.size / (1024 * 1024)).toFixed(2);
                    fileInfo.textContent = `Tên file: ${file.name} | Kích thước: ${fileSize}MB`;
                    fileInfo.style.color = '#28a745';
                }
            }
            
            if (file) {
                reader.readAsDataURL(file);
            } else {
                const preview = document.getElementById('imagePreview');
                if (preview) {
                    preview.src = '${pageContext.request.contextPath}/asset/image/MayLangThangAvt.svg';
                }
                if (fileInfo) {
                    fileInfo.textContent = 'Định dạng: JPG, PNG, GIF | Tối đa: 5MB';
                    fileInfo.style.color = '#a8a8a8';
                }
            }
        }

        function validateForm() {
            if (!window.Swal) {
                alert('Lỗi: Không thể tải thư viện SweetAlert2. Vui lòng kiểm tra kết nối mạng.');
                return false;
            }

            const name = document.querySelector('input[name="name"]').value.trim();
            const description = document.querySelector('textarea[name="description"]').value.trim();
            const physicalLocation = document.querySelector('input[name="physicalLocation"]').value.trim();
            const startTime = document.querySelector('input[name="startTime"]').value;
            const endTime = document.querySelector('input[name="endTime"]').value;
            const totalTicketCount = document.querySelector('input[name="totalTicketCount"]').value;
            const imageFile = document.querySelector('input[name="imageFile"]').files[0];

            if (!name) {
                Swal.fire('Lỗi', 'Tên sự kiện không được để trống', 'error');
                return false;
            }
            if (name.length > 100) {
                Swal.fire('Lỗi', 'Tên sự kiện không được vượt quá 100 ký tự', 'error');
                return false;
            }

            if (description.length > 1000) {
                Swal.fire('Lỗi', 'Mô tả không được vượt quá 1000 ký tự', 'error');
                return false;
            }

            if (!physicalLocation) {
                Swal.fire('Lỗi', 'Địa điểm không được để trống', 'error');
                return false;
            }
            if (physicalLocation.length > 200) {
                Swal.fire('Lỗi', 'Địa điểm không được vượt quá 200 ký tự', 'error');
                return false;
            }

            if (!startTime) {
                Swal.fire('Lỗi', 'Thời gian bắt đầu không được để trống', 'error');
                return false;
            }
            if (!endTime) {
                Swal.fire('Lỗi', 'Thời gian kết thúc không được để trống', 'error');
                return false;
            }
            if (new Date(startTime) >= new Date(endTime)) {
                Swal.fire('Lỗi', 'Thời gian bắt đầu phải trước thời gian kết thúc', 'error');
                return false;
            }

            if (isNaN(totalTicketCount) || totalTicketCount < 0) {
                Swal.fire('Lỗi', 'Số lượng vé phải là số không âm', 'error');
                return false;
            }

            if (imageFile) {
                const validTypes = ['image/jpeg', 'image/png', 'image/gif'];
                if (!validTypes.includes(imageFile.type)) {
                    Swal.fire('Lỗi', 'Chỉ chấp nhận file ảnh định dạng JPG, PNG hoặc GIF', 'error');
                    return false;
                }

                const maxSize = 5 * 1024 * 1024;
                if (imageFile.size > maxSize) {
                    Swal.fire('Lỗi', 'Kích thước ảnh không được vượt quá 5MB', 'error');
                    return false;
                }
            }

            Swal.fire({
                title: 'Đang xử lý',
                text: 'Vui lòng chờ trong khi cập nhật sự kiện...',
                allowOutsideClick: false,
                didOpen: () => {
                    Swal.showLoading();
                }
            });

            return true;
        }

        animateEllipses();

        <c:if test="${not empty error}">
            Swal.fire('Lỗi', '${error}', 'error');
        </c:if>
        <c:if test="${not empty success}">
            Swal.fire('Thành công', '${success}', 'success');
        </c:if>
</script>
</body>
</html>
