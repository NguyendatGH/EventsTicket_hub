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
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
        }

        body {
            min-height: 100vh;
            background-color: #070a17;
            overflow-x: hidden;
            position: relative;
        }

        .container {
            display: flex;
            position: relative;
            z-index: 1;
        }

        .sidebar {
            width: 16%;
            background: rgba(15, 23, 42, 0.9);
            backdrop-filter: blur(20px);
            border-right: 1px solid #4d4d4d;
            padding: 2rem 0;
            transition: transform 0.3s ease;
            z-index: 1100;
        }

        .logo {
            color: white;
            font-size: 1.5rem;
            font-weight: 700;
            margin-bottom: 5rem;
            padding: 0 2rem;
        }

        .admin-section {
            padding: 0 2rem;
            margin-bottom: 3rem;
        }

        .admin-avatar {
            width: 120px;
            height: 120px;
            background: rgba(71, 85, 105, 0.8);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 2rem;
        }

        .admin-avatar svg {
            width: 80px;
            height: 80px;
            color: #94a3b8;
        }

        .admin-name {
            color: white;
            font-size: 24px;
            font-weight: 600;
            text-align: center;
            margin-bottom: 0.5rem;
        }

        .admin-role {
            color: #94a3b8;
            font-size: 0.875rem;
            text-align: center;
        }

        .nav-menu {
            list-style: none;
        }

        .nav-item {
            border-bottom: 1px solid rgba(15, 23, 42, 0.14);
        }

        .nav-link {
            display: block;
            color: white;
            background-color: rgba(255, 255, 255, 0.18);
            text-decoration: none;
            padding: 1rem 2rem;
            font-weight: 500;
            transition: all 0.3s ease;
            position: relative;
        }

        .nav-link.active {
            background: rgba(255, 255, 255, 0.05);
            color: white;
        }

        .nav-link:hover {
            color: white;
            background: rgba(255, 255, 255, 0.05);
        }

        .logout {
            position: absolute;
            bottom: 2rem;
            left: 2rem;
            right: 2rem;
            color: #94a3b8;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-weight: 500;
            transition: color 0.3s ease;
        }

        .logout:hover {
            color: white;
        }

        .main-content {
            flex: 1;
            padding: 0 94px;
            padding-top: 2rem;
            overflow-y: auto;
            display: flex;
            flex-direction: column;
            gap: 2rem;
        }

        .top-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
        }

        .breadcrumb {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 16px;
            font-weight: 500;
            background: rgba(255, 255, 255, 0.18);
            border-radius: 12px;
            padding: 10px 20px;
        }

        .breadcrumb-item {
            color: #a8a8a8;
        }

        .breadcrumb-current {
            color: white;
        }

        .section {
            margin-bottom: 30px;
        }

        .section-title {
            font-size: 24px;
            font-weight: 700;
            margin-bottom: 20px;
            color: white;
        }

        .overview-section {
            border-radius: 12px;
            margin-bottom: 30px;
            width: 100%;
        }

        .link-container {
            display: flex;
            align-items: center;
            gap: 50px;
            background-color: rgba(255, 255, 255, 0.18);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 14px;
        }

        .link-label {
            font-size: 14px;
            color: #e6e6e6;
            min-width: 80px;
            padding-left: 20px;
        }

        .link-input {
            flex: 1;
            padding: 12px 16px;
            background: transparent;
            border: none;
            color: white;
            font-size: 14px;
        }

        .event-name-section {
            background: rgba(255, 255, 255, 0.18);
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 30px;
            border: 1px solid rgba(255, 255, 255, 0.1);
            width: 100%;
        }

        .event-input-group {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .event-label {
            font-size: 15px;
            font-weight: 500;
            color: #e0e0e0;
            min-width: 100px;
        }

        .event-input {
            flex: 1;
            padding: 12px 20px;
            background: transparent;
            border: 1px solid rgba(255, 255, 255, 0.2);
            color: white;
            font-size: 22px;
            font-weight: 500;
            border-radius: 8px;
        }

        .event-input:focus {
            outline: none;
            border-color: #0f67ff;
        }

        .description-section {
            background: rgba(255, 255, 255, 0.18);
            border-radius: 12px;
            padding: 25px;
            margin-bottom: 34px;
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        .description-title {
            font-size: 16px;
            font-weight: 600;
            margin-bottom: 15px;
            color: #ffffff;
        }

        .description-text {
            font-size: 18px;
            line-height: 1.6;
            color: #ffffff;
            width: 100%;
            background: transparent;
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 8px;
            padding: 8px;
        }

        .details-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 34px;
            margin-bottom: 34px;
        }

        .details-section {
            background: rgba(255, 255, 255, 0.18);
            border-radius: 12px;
            padding: 20px;
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        .detail-item {
            display: flex;
            align-items: center;
            margin-bottom: 34px;
            font-size: 14px;
        }

        .detail-item:last-child {
            margin-bottom: 0;
        }

        .detail-label {
            color: #dbdbdb;
            font-weight: 500;
            min-width: 80px;
            font-size: 14px;
        }

        .detail-value {
            margin-top: 30px;
            color: white;
            text-align: start;
            font-size: 16px;
            padding-left: 10px;
            width: 100%;
            background: transparent;
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 8px;
            padding: 8px;
        }

        .detail-value:focus {
            outline: none;
            border-color: #0f67ff;
        }

        .events-material {
            color: white;
        }

        .material-header {
            margin-bottom: 12px;
        }

        .material-wrapper {
            border-style: dotted;
            border-color: rgba(79, 102, 206, 0.94);
            border-width: 4px;
            border-radius: 12px;
            padding: 40px 20px;
            margin-bottom: 34px;
        }

        .content {
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .img-wrapper {
            width: 80%;
            box-sizing: border-box;
            object-fit: cover;
            margin-top: 30px;
        }

        .img-wrapper img {
            width: 100%;
            height: auto;
            border-radius: 8px;
        }

        .event-option {
            display: flex;
            flex-direction: row;
            align-items: center;
            gap: 34px;
            margin-bottom: 34px;
        }

        .btn {
            padding: 12px 18px;
            display: flex;
            flex-direction: row;
            align-items: center;
            color: white;
            font-size: 16px;
            font-weight: 600;
            gap: 14px;
            border-radius: 12px;
            border: 1px solid transparent;
            cursor: pointer;
        }

        .approve {
            background-color: #0f67ff;
        }

        .reject {
            background-color: transparent;
            border: 1px solid #0f67ff;
        }

        .save {
            background-color: #28a745;
        }

        .hamburger {
            display: none;
            position: fixed;
            top: 20px;
            right: 34px;
            z-index: 1100;
            background: none;
            border: none;
            padding: 8px;
            cursor: pointer;
            width: 32px;
            height: 32px;
            flex-direction: column;
            justify-content: space-around;
        }

        .hamburger span {
            display: block;
            width: 20px;
            height: 2px;
            background: white;
            transition: all 0.3s ease;
        }

        .hamburger.active span:nth-child(1) {
            transform: rotate(45deg) translate(2px, 2px);
        }

        .hamburger.active span:nth-child(2) {
            opacity: 0;
        }

        .hamburger.active span:nth-child(3) {
            transform: rotate(-45deg) translate(5px, -6px);
        }

        .overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(21, 27, 58, 0.384);
            backdrop-filter: blur(5px);
            z-index: 950;
            transition: opacity 0.3s ease;
        }

        .overlay.active {
            display: block;
            opacity: 1;
        }

        .bg_elips {
            width: 800px;
            height: 800px;
            object-fit: cover;
            position: fixed;
            z-index: -1;
            pointer-events: none;
            opacity: 0.7;
        }

        .firstElement {
            top: -200px;
            left: -50px;
        }

        .secondElement {
            bottom: -400px;
            right: -200px;
        }

        ::-webkit-scrollbar {
            width: 8px;
        }

        ::-webkit-scrollbar-track {
            background: rgba(255, 255, 255, 0.1);
            border-radius: 10px;
        }

        ::-webkit-scrollbar-thumb {
            background: rgba(38, 62, 114, 0.5);
            border-radius: 10px;
        }

        ::-webkit-scrollbar-thumb:hover {
            background: rgba(45, 70, 126, 0.7);
        }

        .error-message {
            color: #ff0c0c;
            background: rgba(255, 0, 0, 0.1);
            padding: 10px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 14px;
        }

        .success-message {
            color: #28a745;
            background: rgba(40, 167, 69, 0.1);
            padding: 10px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 14px;
        }

        @media (max-width: 1400px) {
            .main-content {
                padding: 0 50px;
            }
        }

        @media (max-width: 1200px) {
            .details-grid {
                grid-template-columns: 1fr;
            }

            .sidebar {
                width: 20%;
            }

            .main-content {
                padding: 0 30px;
            }

            .bg_elips {
                width: 600px;
                height: 600px;
            }

            .firstElement {
                top: -150px;
                left: -30px;
            }

            .secondElement {
                bottom: -300px;
                right: -150px;
            }
        }

        @media (max-width: 992px) {
            .sidebar {
                width: 260px;
                position: fixed;
                height: 100%;
                transform: translateX(-100%);
                z-index: 1000;
            }

            .sidebar.active {
                transform: translateX(0);
            }

            .main-content {
                padding: 0 20px;
            }

            .overview-section {
                width: 100%;
            }

            .event-name-section {
                width: 100%;
            }

            .admin-avatar {
                width: 100px;
                height: 100px;
            }

            .admin-avatar svg {
                width: 60px;
                height: 60px;
            }

            .admin-name {
                font-size: 20px;
            }

            .logo {
                font-size: 1.3rem;
            }

            .event-input-group {
                display: flex;
                flex-direction: column;
                align-items: flex-start;
            }

            .event-input {
                width: 100%;
            }

            .link-container {
                display: flex;
                flex-direction: column;
                align-items: flex-start;
                padding: 20px;
                gap: 20px;
            }

            .link-input {
                width: 100%;
            }

            .bg_elips {
                width: 500px;
                height: 500px;
            }

            .firstElement {
                top: -120px;
                left: -20px;
            }

            .secondElement {
                bottom: -250px;
                right: -120px;
            }

            .hamburger {
                display: flex;
            }
        }

        @media (max-width: 768px) {
            .main-content {
                padding: 0 15px;
            }

            .top-bar {
                flex-direction: column;
                align-items: flex-start;
                gap: 1rem;
            }

            .event-input {
                font-size: 20px;
            }

            .bg_elips {
                width: 400px;
                height: 400px;
                opacity: 0.5;
            }

            .firstElement {
                top: -100px;
                left: -15px;
            }

            .secondElement {
                bottom: -200px;
                right: -100px;
            }
        }

        @media (max-width: 576px) {
            .sidebar {
                width: 100%;
            }

            .main-content {
                padding: 0 10px;
            }

            .event-option {
                flex-direction: column;
                gap: 15px;
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

            .firstElement {
                top: -80px;
                left: -10px;
            }

            .secondElement {
                bottom: -150px;
                right: -50px;
            }

            .event-input {
                font-size: 18px;
            }

            .description-text {
                font-size: 16px;
            }

            .detail-value {
                font-size: 14px;
            }
        }

        @keyframes float {
            0% {
                transform: translateY(0);
            }
            50% {
                transform: translateY(-20px);
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
        <div class="logo">MasterTicket</div>
        <div class="admin-section">
          <div class="admin-avatar">
            <svg fill="currentColor" viewBox="0 0 24 24">
              <path
                d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"
              />
            </svg>
          </div>
          <div class="admin-name">Admin</div>
          <div class="admin-role">Quản lý website MasterTicket</div>
        </div>
        <nav>
          <ul class="nav-menu">
            <li class="nav-item">
              <a
                href="${pageContext.request.contextPath}/admin-servlet/dashboard"
                class="nav-link"
                >Bảng điều khiển</a
              >
            </li>
            <li class="nav-item">
              <a
                href="${pageContext.request.contextPath}/admin-servlet/event-management"
                class="nav-link active"
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
            <!-- CHANGED: Updated form action to correct servlet URL -->
            <form id="updateEventForm" action="${pageContext.request.contextPath}/admin-servlet/event-management" method="POST" onsubmit="return validateForm()">
                <input type="hidden" name="action" value="update" />
                <input type="hidden" name="eventID" value="${event.eventID}" />
                <div class="section">
                    <h2 class="section-title">Tổng quan</h2>
                    <div class="overview-section">
                        <div class="link-container">
                            <span class="link-label">Tên sự kiện</span>
                            <input type="text" class="link-input" value="${event.name}" readonly />
                        </div>
                    </div>
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
                    <h3 class="material-header">Hình ảnh</h3>
                    <div class="material-wrapper">
                        <div class="banner">
                            <h3 class="banner-header">Hình ảnh chính</h3>
                            <div class="banner-content content">
                                <div class="img-wrapper">
                                    <img id="imagePreview" src="${event.imageURL}" alt="Hình ảnh chính" onerror="this.src='${pageContext.request.contextPath}/asset/image/MayLangThangAvt.svg'" />
                                    <input type="text" class="detail-value" id="imageURL" name="imageURL" value="${event.imageURL}" placeholder="Nhập URL ảnh" maxlength="500" />
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

        // Xem trước ảnh khi nhập URL
        const imageURLInput = document.getElementById('imageURL');
        const imagePreview = document.getElementById('imagePreview');
        if (imageURLInput && imagePreview) {
            imageURLInput.addEventListener('input', () => {
                const url = imageURLInput.value.trim();
                if (url) {
                    imagePreview.src = url;
                } else {
                    imagePreview.src = '${pageContext.request.contextPath}/asset/image/MayLangThangAvt.svg';
                }
            });
        }

        function validateForm() {
            // ADDED: Check if SweetAlert2 is available
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
            const imageURL = document.querySelector('input[name="imageURL"]').value.trim();

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
            if (imageURL && !isValidURL(imageURL)) {
                Swal.fire('Lỗi', 'URL ảnh không hợp lệ', 'error');
                return false;
            }

            // ADDED: Show a loading SweetAlert while submitting
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

        function isValidURL(url) {
            try {
                new URL(url);
                return url.match(/\.(jpeg|jpg|gif|png|svg)$/i) != null;
            } catch (_) {
                return false;
            }
        }
        function editEvent(eventId) {
    window.location.href = '${pageContext.request.contextPath}/editEvent?eventId=' + eventId;
}
        animateEllipses();

        // ADDED: Display server-side success/error messages as SweetAlert on page load
        <c:if test="${not empty error}">
            Swal.fire('Lỗi', '${error}', 'error');
        </c:if>
        <c:if test="${not empty success}">
            Swal.fire('Thành công', '${success}', 'success');
        </c:if>
    </script>
</body>
</html>