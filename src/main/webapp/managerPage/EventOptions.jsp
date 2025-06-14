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
                font-family: Inter;
            }
            body {
                font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
                min-height: 100vh;
                background-color: #070a17;
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
                margin-bottom: 40px;
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
                font-size: 20px;
                font-weight: 600;
                margin-bottom: 20px;
                color: white;
            }
            .overview-section {
                border-radius: 12px;
                margin-bottom: 30px;
                width: 40%;
            }
            .link-container {
                display: flex;
                align-items: center;
                gap: 50px;
                background-color: rgba(217, 217, 217, 0.08);
                border: 1px solid rgba(184, 195, 188, 0.71);
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
                background: rgba(255, 255, 255, 0.08);
                border-radius: 12px;
                padding: 20px;
                margin-bottom: 30px;
                border: 1px solid rgba(255, 255, 255, 0.15);
                width: 50%;
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
                border: none;
                color: white;
                font-size: 24px;
                font-weight: 500;
            }
            .event-input:active {
                border: none;
            }
            .description-section {
                background: rgba(255, 255, 255, 0.08);
                border-radius: 12px;
                padding: 25px;
                margin-bottom: 34px;
                border: 1px solid rgba(255, 255, 255, 0.15);
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
            }
            .details-grid {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 34px;
                margin-bottom: 34px;
            }
            .details-section {
                background: rgba(255, 255, 255, 0.08);
                border-radius: 12px;
                padding: 20px;
                border: 1px solid rgba(255, 255, 255, 0.15);
            }
            .detail-item {
                display: flex;
                align-items: flex-start;
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
                color: white;
                text-align: start;
                font-size: 16px;
                padding-left: 10px;
            }
            .info-section {
                background: rgba(255, 255, 255, 0.08);
                border-radius: 12px;
                padding: 30px 20px;
                border: 1px solid rgba(255, 255, 255, 0.15);
                margin-bottom: 40px;
            }
            .info-title {
                font-size: 16px;
                font-weight: 600;
                margin-bottom: 15px;
                color: #e0e0e0;
            }
            .info-text {
                font-size: 16px;
                line-height: 1.7;
                color: #ffffff;
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
            }
            .img-wrapper img {
                width: 100%;
                height: 100%;
            }
            .content-wrapper {
                width: 80%;
                display: flex;
                flex-direction: row;
                align-items: center;
                gap: 34px;
                object-fit: cover;
                box-sizing: border-box;
            }
            .autoGap {
                margin-top: 40px;
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

            /* Overlay for Blur Effect */
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
            @media (max-width: 1200px) {
                .content-grid {
                    grid-template-columns: 1fr;
                }
            }
            @media (max-width: 768px) {
                .stats-grid {
                    grid-template-columns: 1fr;
                }
                .sidebar {
                    width: 240px;
                }
            }
            .bg_elips {
                width: 800px;
                height: 800px;
                object-fit: cover;
                position: absolute;
            }
            .firstElement {
                top: -200px;
                left: -50px;
            }
            .secondElement {
                bottom: -400px;
                right: -200px;
            }
               @media (max-width: 992px) {
                .control-panel {
                    margin-top: 30px;
                }
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

                .stats-grid {
                    flex-direction: column;
                    align-items: stretch;
                }

                .stat-card {
                    min-width: 100%;
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

                .bg_elips {
                    width: 500px;
                    height: 500px;
                }
                .hamburger{
                    display: flex;
                }
            }
        </style>
    </head>
    <body>
        <img class="bg_elips firstElement" src="${pageContext.request.contextPath}/asset/image/full.svg" />
        <img class="bg_elips secondElement" src="${pageContext.request.contextPath}/asset/image/full2.svg" />
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
                        <path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z" />
                        </svg>
                    </div>
                    <div class="admin-name">Quản trị viên</div>
                    <div class="admin-role">Quản lý website MasterTicket</div>
                </div>
                <nav>
                    <ul class="nav-menu">
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/admin-servlet/dashboard" class="nav-link">Bảng điều khiển</a>
                        </li>
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/admin-servlet/event-management" class="nav-link active">Danh sách sự kiện</a>
                        </li>
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/admin-servlet/user-management" class="nav-link">Danh sách tài khoản</a>
                        </li>
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/admin-servlet/support-center" class="nav-link">Hỗ trợ khách hàng</a>
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
                    <div style="color: #ff0c0c; background: rgba(255, 0, 0, 0.1); padding: 10px; border-radius: 8px; margin-bottom: 20px;">
                        ${error}
                    </div>
                </c:if>
                <c:choose>
                    <c:when test="${editMode}">
                        <form action="${pageContext.request.contextPath}/admin-servlet/event-management/event-detail" method="POST">
                            <input type="hidden" name="action" value="update" />
                            <input type="hidden" name="eventID" value="${event.eventID}" />
                            <div class="section">
                                <h2 class="section-title">Tổng quan</h2>
                                <div class="overview-section">
                                    <div class="link-container">
                                        <span class="link-label">Liên kết sự kiện</span>
                                        <input type="text" class="link-input" value="${event.eventLink}" readonly />
                                    </div>
                                </div>
                            </div>
                            <div class="event-name-section">
                                <div class="event-input-group">
                                    <span class="event-label">Tên sự kiện:</span>
                                    <input type="text" class="event-input" name="name" value="${event.name}" required />
                                </div>
                            </div>
                            <div class="description-section">
                                <h3 class="description-title">Mô tả</h3>
                                <textarea class="description-text" name="description" rows="5" style="width: 100%; background: transparent; color: white; border: none;">${event.description}</textarea>
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
                                        <input type="text" class="detail-value" name="physicalLocation" value="${event.physicalLocation}" style="background: transparent; color: white; border: none;" required />
                                    </div>
                                    <div class="detail-item">
                                        <span class="detail-label">Số lượng vé:</span>
                                        <input type="number" class="detail-value" name="totalTicketCount" value="${event.totalTicketCount}" style="background: transparent; color: white; border: none;" required min="0" />
                                    </div>
                                    <div class="detail-item">
                                        <span class="detail-label">Trạng thái:</span>
                                        <select name="status" class="detail-value" style="background: transparent; color: white; border: none;">
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
                                    <div class="Banner">
                                        <h3 class="banner-header">Hình ảnh chính</h3>
                                        <div class="banner-content content">
                                            <div class="img-wrapper">
                                                <input type="text" class="detail-value" name="imageURL" value="${event.imageURL}" style="background: transparent; color: white; border: none;" />
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="event-option">
                                <button type="submit" class="btn save">Lưu thay đổi</button>
                                <a href="${pageContext.request.contextPath}/admin-servlet/event-management" class="btn reject">Hủy</a>
                            </div>
                        </form>
                    </c:when>
                    <c:otherwise>
                        <div class="section">
                            <h2 class="section-title">Tổng quan</h2>
                            <div class="overview-section">
                                <div class="link-container">
                                    <span class="link-label">Liên kết sự kiện</span>
                                    <input type="text" class="link-input" value="${event.eventLink}" readonly />
                                </div>
                            </div>
                        </div>
                        <div class="event-name-section">
                            <div class="event-input-group">
                                <span class="event-label">Tên sự kiện:</span>
                                <span class="event-input">${event.name}</span>
                            </div>
                        </div>
                        <div class="description-section">
                            <h3 class="description-title">Mô tả</h3>
                            <p class="description-text">${event.description}</p>
                        </div>
                        <div class="details-grid">
                            <div class="details-section">
                                <div class="detail-item">
                                    <span class="detail-label">Thời gian bắt đầu:</span>
                                    <span class="detail-value"><fmt:formatDate value="${event.startTime}" pattern="dd/MM/yyyy HH:mm" /></span>
                                </div>
                                <div class="detail-item">
                                    <span class="detail-label">Thời gian kết thúc:</span>
                                    <span class="detail-value"><fmt:formatDate value="${event.endTime}" pattern="dd/MM/yyyy HH:mm" /></span>
                                </div>
                            </div>
                            <div class="details-section">
                                <div class="detail-item">
                                    <span class="detail-label">Địa điểm:</span>
                                    <span class="detail-value">${event.physicalLocation}</span>
                                </div>
                                <div class="detail-item">
                                    <span class="detail-label">Số lượng vé:</span>
                                    <span class="detail-value">${event.totalTicketCount}</span>
                                </div>
                                <div class="detail-item">
                                    <span class="detail-label">Trạng thái:</span>
                                    <span class="detail-value">
                                        <c:choose>
                                            <c:when test="${event.status == 'pending'}">Đang chờ duyệt</c:when>
                                            <c:when test="${event.status == 'active'}">Đang hoạt động</c:when>
                                            <c:when test="${event.status == 'cancelled'}">Đã hủy</c:when>
                                            <c:when test="${event.status == 'completed'}">Đã hoàn thành</c:when>
                                        </c:choose>
                                    </span>
                                </div>
                            </div>
                        </div>
                        <div class="events-material">
                            <h3 class="material-header">Hình ảnh</h3>
                            <div class="material-wrapper">
                                <div class="Banner">
                                    <h3 class="banner-header">Hình ảnh chính</h3>
                                    <div class="banner-content content">
                                        <div class="img-wrapper">
                                            <img src="${pageContext.request.contextPath}/${event.imageURL}" alt="Hình ảnh chính" />
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="event-option">
                            <button type="button" class="btn approve" onclick="handleApprove(${event.eventID})">
                                Phê duyệt
                                <img src="${pageContext.request.contextPath}/asset/image/accept.svg" class="btn-img" alt="Phê duyệt" />
                            </button>
                            <button type="button" class="btn reject" onclick="handleReject(${event.eventID})">
                                Từ chối
                                <img src="${pageContext.request.contextPath}/asset/image/Trash.svg" class="btn-img" alt="Từ chối" />
                            </button>
                        </div>
                    </c:otherwise>
                </c:choose>
            </main>
        </div>
        <script>
            // Animate ellipses
            function animateEllipses() {
                const ellipses = document.querySelectorAll(".bg_elips");
                ellipses.forEach((ellipse, index) => {
                    const duration = 8000 + index * 2000;
                    ellipse.style.animation = `float ${duration}ms ease-in-out infinite`;
                });
            }

            // Hamburger menu and overlay toggle
            const hamburger = document.querySelector('.hamburger');
            const sidebar = document.querySelector('.sidebar');
            const overlay = document.querySelector('.overlay');

            if (hamburger && sidebar && overlay) {
                hamburger.addEventListener('click', () => {
                    hamburger.classList.toggle('active');
                    sidebar.classList.toggle('active');
                    overlay.classList.toggle('active');
                });

                // Close sidebar and overlay when clicking a nav link on mobile
                document.querySelectorAll('.nav-link').forEach(link => {
                    link.addEventListener('click', () => {
                        if (window.innerWidth <= 992) {
                            hamburger.classList.remove('active');
                            sidebar.classList.remove('active');
                            overlay.classList.remove('active');
                        }
                    });
                });

                // Close sidebar and overlay when clicking outside
                document.addEventListener('click', (e) => {
                    if (window.innerWidth <= 992 && !sidebar.contains(e.target) && !hamburger.contains(e.target)) {
                        hamburger.classList.remove('active');
                        sidebar.classList.remove('active');
                        overlay.classList.remove('active');
                    }
                });
            }
            function handleApprove(eventId) {
                window.location.href = `${pageContext.request.contextPath}/admin-servlet/event-management/event-detail?action=approve&eventID=${eventId}`;
                    }

                    function handleReject(eventId) {
                        window.location.href = `${pageContext.request.contextPath}/admin-servlet/event-management/event-detail?action=reject&eventID=${eventId}`;
                            }
                            animateEllipses();

        </script>
    </body>
</html>