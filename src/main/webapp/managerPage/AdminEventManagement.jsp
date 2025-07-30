<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>MasterTicket Admin</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
    :root {
        --primary-bg: #070a17;
        --secondary-bg: rgba(15, 23, 42, 0.9);
        --success-green: #28a745;
        --error-red: #dc3545;
        --text-primary: #ffffff;
        --text-secondary: #94a3b8;
        --border-dark: rgba(255, 255, 255, 0.1);
        --border-light: rgba(255, 255, 255, 0.2);
        --shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
      }
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
        position: relative;
            background-color: var(--primary-bg);
        color: var(--text-primary);
        overflow-x: hidden;
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
        border-right: 1px solid var(--border-dark);
        padding: 2rem 0;
        transition: transform 0.3s ease;
        position: fixed;
        height: 100%;
        z-index: 1100;
      }

      .logo {
        color: var(--text-primary);
        font-size: 1.75rem;
        font-weight: 700;
        margin-bottom: 3rem;
        padding: 0 2rem;
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
        background: rgba(255, 255, 255, 0.08);
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        margin: 0 auto 1.5rem;
        box-shadow: var(--shadow);
      }

      .admin-avatar svg {
        width: 60px;
        height: 60px;
        color: var(--text-secondary);
      }

      .admin-name {
        color: var(--text-primary);
        font-size: 1.25rem;
        font-weight: 600;
        margin-bottom: 0.25rem;
      }

      .admin-role {
        color: var(--text-secondary);
        font-size: 0.875rem;
        font-weight: 400;
      }

      .nav-menu {
        list-style: none;
      }

      .nav-item {
        border-bottom: 1px solid var(--border-dark);
      }

      .nav-link {
        display: block;
        color: var(--text-secondary);
        text-decoration: none;
        padding: 1rem 2rem;
        font-weight: 500;
        transition: all 0.3s ease;
        position: relative;
      }

      .nav-link:hover,
      .nav-link.active {
        background: rgba(255, 255, 255, 0.08);
        color: var(--text-primary);
        box-shadow: inset 4px 0 0 #0f67ff;
      }

      .logout {
        position: fixed;
        bottom: 2rem;
        left: 2rem;
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

        .main-content.full {
            margin-left: 0;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
        }

        .page-title {
            font-size: 1.75rem;
            font-weight: 600;
            color: white;
        }

        .hamburger {
            display: none;
            background: none;
            border: none;
            cursor: pointer;
            padding: 0.5rem;
            z-index: 1100;
        }

        .hamburger span {
            display: block;
            width: 24px;
            height: 3px;
            background: white;
            margin: 5px 0;
            transition: all 0.3s ease;
        }

        .hamburger.active span:nth-child(1) {
            transform: rotate(45deg) translate(6px, 6px);
        }

        .hamburger.active span:nth-child(2) {
            opacity: 0;
        }

        .hamburger.active span:nth-child(3) {
            transform: rotate(-45deg) translate(6px, -6px);
        }

        .overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            z-index: 950;
            transition: opacity 0.3s ease;
        }

        .overlay.active {
            display: block;
        }

        .card {
            background: rgba(255, 255, 255, 0.1);
            border-radius: 12px;
            padding: 1.5rem;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            transition: transform 0.2s ease;
        }

        .card:hover {
            transform: translateY(-3px);
        }

        .dashboard-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .stat-card {
            display: flex;
            flex-direction: column;
            align-items: center;
            text-align: center;
        }

        .stat-title {
            font-size: 1rem;
            font-weight: 600;
            color: #94a3b8;
            margin-bottom: 0.5rem;
        }

        .stat-value {
            font-size: 1.75rem;
            font-weight: 700;
            color: white;
        }

        .table-container {
            width: 100%;
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            color: white;
        }

        th, td {
            padding: 1rem;
            text-align: left;
            font-size: 0.9rem;
        }

        th {
            background: rgba(21, 0, 97, 0.8);
            font-weight: 600;
            color: #e5e7eb;
        }

        tbody tr {
            background: rgba(255, 255, 255, 0.05);
            transition: background 0.2s ease;
        }

        tbody tr:hover {
            background: rgba(255, 255, 255, 0.1);
        }

        .status-tag {
            padding: 0.5rem 1rem;
            border-radius: 6px;
            font-size: 0.85rem;
            font-weight: 500;
            text-align: center;
        }

        .success {
            background: rgba(16, 185, 129, 0.2);
            color: #10b981;
            border: 1px solid #10b981;
        }

        .warning {
            background: rgba(245, 158, 11, 0.2);
            color: #f59e0b;
            border: 1px solid #f59e0b;
        }

        .error {
            background: rgba(239, 68, 68, 0.2);
            color: #ef4444;
            border: 1px solid #ef4444;
        }

        .actions {
            display: flex;
            gap: 0.5rem;
        }

        .action-btn {
            width: 32px;
            height: 32px;
            border-radius: 6px;
            border: none;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: background 0.2s ease;
        }

        .edit-btn {
            background: rgba(40, 167, 69, 0.2);
            color: #28a745;
        }

        .edit-btn:hover {
            background: rgba(40, 167, 69, 0.4);
        }

        .delete-btn {
            background: rgba(220, 53, 69, 0.2);
            color: #dc3545;
        }

        .delete-btn:hover {
            background: rgba(220, 53, 69, 0.4);
        }

        .charts-section {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .chart-container {
            background: rgba(255, 255, 255, 0.1);
            border-radius: 12px;
            padding: 1.5rem;
            backdrop-filter: blur(10px);
        }

        .chart-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: white;
            margin-bottom: 1rem;
            text-align: center;
        }

        .chart-wrapper {
            height: 250px;
        }

        .search-container {
            position: relative;
            width: 100%;
            max-width: 250px;
        }

        .search-box {
            width: 100%;
            padding: 0.75rem 2.5rem 0.75rem 1rem;
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 8px;
            color: white;
            font-size: 0.9rem;
            outline: none;
            transition: all 0.2s ease;
        }

        .search-box:focus {
            border-color: #6366f1;
            background: rgba(255, 255, 255, 0.15);
        }

        .search-icon {
            position: absolute;
            right: 1rem;
            top: 50%;
            transform: translateY(-50%);
            color: #94a3b8;
        }

        .message-alert {
            position: fixed;
            top: 1rem;
            right: 1rem;
            padding: 1rem;
            border-radius: 8px;
            color: white;
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            z-index: 1200;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
            opacity: 0;
            transform: translateY(-20px);
            transition: all 0.3s ease;
        }

        .message-alert.show {
            opacity: 1;
            transform: translateY(0);
        }

        .message-success {
            background: #10b981;
        }

        .message-error {
            background: #ef4444;
        }

        .message-alert::before {
            content: '';
            width: 20px;
            height: 20px;
            background-size: cover;
        }

        .message-success::before {
            background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="white"><path d="M9 16.2l-3.5-3.5 1.4-1.4L9 13.8l8.6-8.6 1.4 1.4L9 16.2z"/></svg>');
        }

        .message-error::before {
            background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="white"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm5 13.59L15.59 17 12 13.41 8.41 17 7 15.59 10.59 12 7 8.41 8.41 7 12 10.59 15.59 7 17 8.41 13.41 12 17 15.59z"/></svg>');
        }

        ::-webkit-scrollbar {
            width: 6px;
        }

        ::-webkit-scrollbar-track {
            background: rgba(255, 255, 255, 0.1);
            border-radius: 10px;
        }

        ::-webkit-scrollbar-thumb {
            background: #6366f1;
            border-radius: 10px;
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
            }

            .hamburger {
                display: flex;
                position: fixed;
                top: 1rem;
                right: 1rem;
            }

            .charts-section {
                grid-template-columns: 1fr;
            }

            .table-container {
                overflow-x: auto;
            }
        }

        @media (max-width: 768px) {
            .dashboard-grid {
                grid-template-columns: 1fr;
            }

            .page-title {
                font-size: 1.5rem;
            }

            .search-container {
                max-width: 100%;
            }

            .chart-wrapper {
                height: 200px;
            }
        }

        @media (max-width: 576px) {
            .main-content {
                padding: 1rem;
            }

            .table-container th, .table-container td {
                font-size: 0.8rem;
                padding: 0.75rem;
            }

            .action-btn {
                width: 28px;
                height: 28px;
            }

            .search-box {
                font-size: 0.8rem;
            }
        }

        @keyframes float {
            0% { transform: translateY(0); }
            50% { transform: translateY(-15px); }
            100% { transform: translateY(0); }
        }
    </style>
</head>
<body>
    <img class="bg_elips firstElement" src="${pageContext.request.contextPath}/asset/image/full.svg" style="position: fixed; top: -150px; left: -100px; width: 600px; height: 600px; opacity: 0.6; z-index: -1;" />
    <img class="bg_elips secondElement" src="${pageContext.request.contextPath}/asset/image/full2.svg" style="position: fixed; bottom: -200px; right: -100px; width: 600px; height: 600px; opacity: 0.6; z-index: -1;" />
    <button class="hamburger">
        <span></span>
        <span></span>
        <span></span>
    </button>
    <div class="overlay"></div>
    <div class="container">
        <aside class="sidebar">
        <div class="logo">EventTicketHub</div>
        <div class="admin-section">
          <div class="admin-avatar">
            <svg fill="currentColor" viewBox="0 0 24 24">
              <path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z" />
            </svg>
          </div>
          <div class="admin-name">Admin</div>
          <div class="admin-role">Quản lý website </div>
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
              <a href="${pageContext.request.contextPath}/admin-servlet/user-management" class="nav-link ">Danh sách tài khoản</a>
            </li>
            <li class="nav-item">
              <a href="${pageContext.request.contextPath}/admin-servlet/transaction-management" class="nav-link">Danh sách giao dịch</a>
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
        <div class="main-content">
            <header class="header">
                <div class="page-title">Danh sách sự kiện</div>
                <div class="search-container">
                    <input type="text" class="search-box" placeholder="Tìm kiếm sự kiện..." />
                    <div class="search-icon">🔍</div>
                </div>
            </header>
            <c:if test="${not empty sessionScope.message}">
                <div class="message-alert message-${sessionScope.messageType}">
                    ${sessionScope.message}
                </div>
                <c:remove var="message" scope="session" />
                <c:remove var="messageType" scope="session" />
            </c:if>
            <div class="dashboard-grid">
                <div class="card stat-card">
                    <div class="stat-title">Tổng số sự kiện</div>
                    <div class="stat-value">${fn:length(activeEvents) + fn:length(nonActiveEvents)}</div>
                </div>
                <div class="card stat-card">
                    <div class="stat-title">Sự kiện đang hoạt động</div>
                    <div class="stat-value">${fn:length(activeEvents)}</div>
                </div>
                <div class="card stat-card">
                    <div class="stat-title">Sự kiện chờ duyệt</div>
                    <div class="stat-value">${fn:length(nonActiveEvents)}</div>
                </div>
            </div>
            <div class="charts-section">
                <div class="chart-container">
                    <h3 class="chart-title">Thống kê theo trạng thái</h3>
                    <div class="chart-wrapper">
                        <canvas id="statusChart"></canvas>
                    </div>
                </div>
                <div class="chart-container">
                    <h3 class="chart-title">Thống kê theo thể loại</h3>
                    <div class="chart-wrapper">
                        <canvas id="genreChart"></canvas>
                    </div>
                </div>
            </div>
             <div class="card">
                <h3 class="chart-title">Bảng xếp hạng tổ chức</h3>
                <div class="table-container">
                    <table>
                        <thead>
                            <tr>
                                <th>Tên tổ chức</th>
                                <th>Số sự kiện</th>
                                <th>Vé đã bán</th>
                                <th>Trạng thái</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty topOrganizers}">
                                    <c:forEach var="organizer" items="${topOrganizers}" varStatus="status">
                                        <tr>
                                            <td><c:out value="${organizer.name}" /></td>
                                            <td><c:out value="${organizer.numsOfEvent}" /></td>
                                            <td><c:out value="${organizer.numsOfTicketSelled}" /></td>
                                            <td><span class="status-tag ${organizer.status ? 'error' : 'success'}">
                                                <c:choose>
                                                    <c:when test="${organizer.status}">Khóa</c:when>
                                                    <c:otherwise>Đang hoạt động</c:otherwise>
                                                </c:choose>
                                            </span></td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="4">Không có tổ chức sự kiện nào.</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="card">
                <h3 class="chart-title">Sự kiện gần đây</h3>
                <div class="table-container">
                    <table>
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Tên sự kiện</th>
                                <th>Thời gian</th>
                                <th>Trạng thái</th>
                                <th>Hành động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:if test="${not empty activeEvents}">
                                <c:forEach var="event" items="${activeEvents}" varStatus="status">
                                    <tr>
                                        <td>${status.count}</td>
                                        <td><c:out value="${event.name}" /></td>
                                        <td><fmt:formatDate value="${event.startTime}" pattern="dd/MM/yyyy" /> - <fmt:formatDate value="${event.endTime}" pattern="dd/MM/yyyy" /></td>
                                        <td><span class="status-tag success">Đang hoạt động</span></td>
                                        <td class="actions">
                                            <button class="action-btn edit-btn" onclick="handleEditEvent(${event.eventID})">
                                                <img src="${pageContext.request.contextPath}/asset/image/Edit_fill.svg" alt="Edit" />
                                            </button>
                                            <button class="action-btn delete-btn" onclick="handleDeleteEvent(${event.eventID})">
                                                <img src="${pageContext.request.contextPath}/asset/image/Trash.svg" alt="Delete" />
                                            </button>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:if>
                            <c:if test="${not empty nonActiveEvents}">
                                <c:forEach var="event" items="${nonActiveEvents}" varStatus="status">
                                    <tr>
                                        <td>${status.count}</td>
                                        <td><c:out value="${event.name}" /></td>
                                        <td><fmt:formatDate value="${event.startTime}" pattern="dd/MM/yyyy" /> - <fmt:formatDate value="${event.endTime}" pattern="dd/MM/yyyy" /></td>
                                        <td><span class="status-tag ${event.status == 'pending' ? 'warning' : event.status == 'cancelled' ? 'error' : 'error'}">
                                            ${event.status == 'pending' ? 'Đang chờ duyệt' : event.status == 'cancelled' ? 'Đã hủy' : 'Đã hoàn thành'}
                                        </span></td>
                                        <td class="actions">
                                            <button class="action-btn edit-btn" onclick="handleEditEvent(${event.eventID})">
                                                <img src="${pageContext.request.contextPath}/asset/image/Edit_fill.svg" alt="Edit" />
                                            </button>
                                            <button class="action-btn delete-btn" onclick="handleDeleteEvent(${event.eventID})">
                                                <img src="${pageContext.request.contextPath}/asset/image/Trash.svg" alt="Delete" />
                                            </button>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:if>
                            <c:if test="${empty activeEvents && empty nonActiveEvents}">
                                <tr>
                                    <td colspan="5">Không có sự kiện nào.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
           
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>
        // Hamburger menu toggle
        const hamburger = document.querySelector(".hamburger");
        const sidebar = document.querySelector(".sidebar");
        const overlay = document.querySelector(".overlay");
        const mainContent = document.querySelector(".main-content");

        hamburger.addEventListener("click", () => {
            hamburger.classList.toggle("active");
            sidebar.classList.toggle("hidden");
            overlay.classList.toggle("active");
            mainContent.classList.toggle("full");
        });

        document.addEventListener("click", (e) => {
            if (window.innerWidth <= 992 && !sidebar.contains(e.target) && !hamburger.contains(e.target)) {
                hamburger.classList.remove("active");
                sidebar.classList.add("hidden");
                overlay.classList.remove("active");
                mainContent.classList.add("full");
            }
        });

        // Toast notification
        document.addEventListener("DOMContentLoaded", () => {
            const messages = document.querySelectorAll(".message-alert");
            messages.forEach((message) => {
                setTimeout(() => {
                    message.classList.add("show");
                }, 100);
                setTimeout(() => {
                    message.classList.remove("show");
                    setTimeout(() => message.remove(), 300);
                }, 3000);
            });
        });

        // Search functionality
        document.querySelector(".search-box").addEventListener("input", function () {
            const searchTerm = this.value.toLowerCase();
            const rows = document.querySelectorAll(".table-container tbody tr");
            rows.forEach((row) => {
                const eventName = row.children[1].textContent.toLowerCase();
                const date = row.children[2]?.textContent.toLowerCase() || "";
                row.style.display = eventName.includes(searchTerm) || date.includes(searchTerm) ? "" : "none";
            });
        });

        // Event handlers
        function handleEditEvent(eventID) {
            window.location.href = "${pageContext.request.contextPath}/admin-servlet/event-management?action=edit-event&eventId=" + eventID;
        }

        function handleDeleteEvent(eventID) {
            Swal.fire({
                title: "Xác nhận xóa",
                text: "Bạn có chắc muốn xóa sự kiện này?",
                icon: "warning",
                showCancelButton: true,
                confirmButtonText: "Có",
                cancelButtonText: "Hủy",
                confirmButtonColor: "#ef4444",
            }).then((result) => {
                if (result.isConfirmed) {
                    fetch("${pageContext.request.contextPath}/admin-servlet/event-management?action=delete&eventID=" + eventID, {
                        method: "POST",
                    })
                        .then((response) => response.json().then((data) => ({ status: response.status, data })))
                        .then(({ status, data }) => {
                            if (status === 200 && data.success) {
                                const messageDiv = document.createElement("div");
                                messageDiv.className = "message-alert message-success";
                                messageDiv.textContent = "Xóa sự kiện thành công!";
                                document.body.appendChild(messageDiv);
                                setTimeout(() => {
                                    messageDiv.classList.add("show");
                                    setTimeout(() => {
                                        messageDiv.classList.remove("show");
                                        setTimeout(() => {
                                            messageDiv.remove();
                                            window.location.reload();
                                        }, 300);
                                    }, 3000);
                                }, 100);
                            } else {
                                const messageDiv = document.createElement("div");
                                messageDiv.className = "message-alert message-error";
                                messageDiv.textContent = data.message || "Không thể xóa sự kiện.";
                                document.body.appendChild(messageDiv);
                                setTimeout(() => {
                                    messageDiv.classList.add("show");
                                    setTimeout(() => {
                                        messageDiv.classList.remove("show");
                                        setTimeout(() => messageDiv.remove(), 300);
                                    }, 3000);
                                }, 100);
                            }
                        })
                        .catch((error) => {
                            console.error("Error deleting event:", error);
                            const messageDiv = document.createElement("div");
                            messageDiv.className = "message-alert message-error";
                            messageDiv.textContent = "Lỗi hệ thống khi xóa sự kiện.";
                            document.body.appendChild(messageDiv);
                            setTimeout(() => {
                                messageDiv.classList.add("show");
                                setTimeout(() => {
                                    messageDiv.classList.remove("show");
                                    setTimeout(() => messageDiv.remove(), 300);
                                }, 3000);
                            }, 100);
                        });
                }
            });
        }

        // Background animation
        function animateEllipses() {
            const ellipses = document.querySelectorAll(".bg_elips");
            ellipses.forEach((ellipse, index) => {
                const duration = 6000 + index * 2000;
                ellipse.style.animation = `float ${duration}ms ease-in-out infinite`;
            });
        }
        animateEllipses();

        // Chart setup
        const chartColors = {
            primary: "#6366f1",
            success: "#10b981",
            warning: "#f59e0b",
            danger: "#ef4444",
            info: "#06b6d4",
            purple: "#8b5cf6",
        };

        var statusStatsData = '<%= request.getAttribute("statusStatsJson") %>';
        var genreStatsData = '<%= request.getAttribute("genreStatsJson") %>';
        var monthlyStatsData = '<%= request.getAttribute("monthlyStatsJson") %>';

        let statusStats = {};
        let genreStats = {};
        let monthlyStats = [];

        try {
            statusStats = JSON.parse(statusStatsData.replace(/&quot;/g, '"').trim() || "{}");
        } catch (e) {
            console.error("Failed to parse statusStatsJson:", e);
        }

        try {
            genreStats = JSON.parse(genreStatsData.replace(/&quot;/g, '"').trim() || "{}");
        } catch (e) {
            console.error("Failed to parse genreStatsJson:", e);
        }

        try {
            monthlyStats = JSON.parse(monthlyStatsData.replace(/&quot;/g, '"').trim() || "[]");
        } catch (e) {
            console.error("Failed to parse monthlyStatsJson:", e);
        }

        if (Object.keys(statusStats).length > 0) {
            const statusCtx = document.getElementById("statusChart").getContext("2d");
            new Chart(statusCtx, {
                type: "doughnut",
                data: {
                    labels: Object.keys(statusStats).map(status => ({
                        active: "Đang hoạt động",
                        pending: "Đang chờ duyệt",
                        cancelled: "Đã hủy",
                        completed: "Đã hoàn thành"
                    })[status] || status),
                    datasets: [{
                        data: Object.values(statusStats),
                        backgroundColor: [chartColors.success, chartColors.warning, chartColors.danger, chartColors.info],
                        borderWidth: 1,
                        borderColor: "rgba(255, 255, 255, 0.1)",
                    }],
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { position: "bottom", labels: { color: "white", font: { size: 12 } } },
                        tooltip: { backgroundColor: "rgba(0, 0, 0, 0.8)", titleColor: "white", bodyColor: "white" },
                    },
                },
            });
        }

        if (Object.keys(genreStats).length > 0) {
            const genreCtx = document.getElementById("genreChart").getContext("2d");
            new Chart(genreCtx, {
                type: "bar",
                data: {
                    labels: Object.keys(genreStats),
                    datasets: [{
                        label: "Số lượng sự kiện",
                        data: Object.values(genreStats),
                        backgroundColor: chartColors.primary,
                        borderColor: chartColors.primary,
                        borderWidth: 1,
                        borderRadius: 6,
                    }],
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { display: false },
                        tooltip: { backgroundColor: "rgba(0, 0, 0, 0.8)", titleColor: "white", bodyColor: "white" },
                    },
                    scales: {
                        y: { beginAtZero: true, ticks: { color: "white", stepSize: 1 }, grid: { color: "rgba(255, 255, 255, 0.1)" } },
                        x: { ticks: { color: "white" }, grid: { display: false } },
                    },
                },
            });
        }

        if (monthlyStats.length > 0) {
            if (monthlyStats.length === 1) {
                monthlyStats = [{ month: monthlyStats[0].month - 1, year: monthlyStats[0].year, count: 0 }, ...monthlyStats];
            }
            const monthlyLabels = monthlyStats.map(item => {
                const months = ["Th1", "Th2", "Th3", "Th4", "Th5", "Th6", "Th7", "Th8", "Th9", "Th10", "Th11", "Th12"];
                return months[item.month - 1] + " " + item.year;
            });

            const monthlyCtx = document.getElementById("monthlyChart").getContext("2d");
            new Chart(monthlyCtx, {
                type: "line",
                data: {
                    labels: monthlyLabels,
                    datasets: [{
                        label: "Số sự kiện mới",
                        data: monthlyStats.map(item => item.count),
                        borderColor: chartColors.success,
                        backgroundColor: chartColors.success + "20",
                        borderWidth: 2,
                        fill: true,
                        tension: 0.3,
                        pointBackgroundColor: chartColors.success,
                        pointBorderColor: "white",
                        pointBorderWidth: 1,
                        pointRadius: 4,
                    }],
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { labels: { color: "white" } },
                        tooltip: { backgroundColor: "rgba(0, 0, 0, 0.8)", titleColor: "white", bodyColor: "white" },
                    },
                    scales: {
                        y: { beginAtZero: true, ticks: { color: "white", stepSize: 1 }, grid: { color: "rgba(255, 255, 255, 0.1)" } },
                        x: { ticks: { color: "white" }, grid: { display: false } },
                    },
                },
            });
        }
    </script>
</body>
</html>