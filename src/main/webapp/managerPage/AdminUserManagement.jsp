<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>EventTicketHub Admin</title>
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
        font-family: 'Inter', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
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

      .header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 1.5rem;
      }

      .page-title {
        color: var(--text-primary);
        font-size: 1.5rem;
        font-weight: 700;
      }

      .control-panel {
        background: rgba(255, 255, 255, 0.08);
        border-radius: 8px;
        padding: 0.75rem 1.5rem;
        color: var(--text-primary);
        font-weight: 600;
        box-shadow: var(--shadow);
      }

      .search-container {
        position: relative;
        width: 100%;
        max-width: 300px;
      }

      .search-box {
        width: 100%;
        padding: 0.75rem 2.5rem 0.75rem 1rem;
        background: rgba(255, 255, 255, 0.08);
        border: 1px solid var(--border-light);
        border-radius: 8px;
        color: var(--text-primary);
        font-size: 0.875rem;
        outline: none;
        transition: all 0.3s ease;
      }

      .search-box:focus {
        border-color: #0f67ff;
        box-shadow: 0 0 0 3px rgba(15, 103, 255, 0.2);
      }

      .search-box::placeholder {
        color: var(--text-secondary);
      }

      .search-icon {
        position: absolute;
        right: 0.75rem;
        top: 50%;
        transform: translateY(-50%);
        color: var(--text-secondary);
        font-size: 1rem;
      }

      .filter-container {
        position: relative;
        width: 100%;
        max-width: 200px;
      }

      .filter-select {
        width: 100%;
        padding: 0.75rem 2rem 0.75rem 1rem;
        background: rgba(255, 255, 255, 0.08);
        border: 1px solid var(--border-light);
        border-radius: 8px;
        color: var(--text-primary);
        font-size: 0.875rem;
        outline: none;
        transition: all 0.3s ease;
        appearance: none;
        cursor: pointer;
      }

      .filter-select:focus {
        border-color: #0f67ff;
        box-shadow: 0 0 0 3px rgba(15, 103, 255, 0.2);
      }

      .filter-icon {
        position: absolute;
        right: 0.75rem;
        top: 50%;
        transform: translateY(-50%);
        color: var(--text-secondary);
        font-size: 0.875rem;
        pointer-events: none;
      }

      .data-table {
        background: rgba(255, 255, 255, 0.08);
        border-radius: 12px;
        overflow: hidden;
        border: 1px solid var(--border-dark);
        box-shadow: var(--shadow);
      }

      .table-header {
        display: grid;
        grid-template-columns: 1fr auto auto;
        gap: 1rem;
        align-items: center;
        background: rgba(15, 23, 42, 0.9);
        padding: 1.5rem;
      }

      .table-columns {
        display: grid;
        grid-template-columns: 50px 1fr 1fr 1fr 1fr 120px;
        gap: 1rem;
        padding: 0.75rem 1.5rem;
        background: rgba(255, 255, 255, 0.05);
        border-bottom: 1px solid var(--border-dark);
        color: var(--text-primary);
        font-weight: 600;
        font-size: 0.875rem;
      }

      .table-row {
        display: grid;
        grid-template-columns: 50px 1fr 1fr 1fr 1fr 120px;
        gap: 1rem;
        padding: 1rem 1.5rem;
        border-bottom: 1px solid var(--border-dark);
        transition: all 0.3s ease;
        align-items: center;
        color: var(--text-primary);
        font-size: 0.875rem;
      }

      .table-row:hover {
        background: rgba(255, 255, 255, 0.1);
      }

      .table-row:last-child {
        border-bottom: none;
      }

      .email-link {
        color: #64b5f6;
        text-decoration: none;
        transition: color 0.3s ease;
      }

      .email-link:hover {
        color: #93cbf9;
      }

      .phoneNum-field {
        display: flex;
        align-items: center;
        gap: 0.5rem;
      }

      .phoneNum-detail {
        color: var(--text-secondary);
      }

      .actions {
        display: flex;
        gap: 0.5rem;
      }

      .action-btn {
        width: 32px;
        height: 32px;
        border-radius: 8px;
        border: none;
        cursor: pointer;
        transition: all 0.3s ease;
        display: flex;
        align-items: center;
        justify-content: center;
      }

      .lock-btn {
        background: rgba(255, 193, 7, 0.2);
        color: #ffc107;
      }

      .lock-btn:hover {
        background: rgba(255, 193, 7, 0.3);
        box-shadow: var(--shadow);
      }

      .edit-btn {
        background: rgba(40, 167, 69, 0.2);
        color: var(--success-green);
      }

      .edit-btn:hover {
        background: rgba(40, 167, 69, 0.3);
        box-shadow: var(--shadow);
      }

      ::-webkit-scrollbar {
        width: 8px;
      }

      ::-webkit-scrollbar-track {
        background: var(--border-dark);
        border-radius: 10px;
      }

      ::-webkit-scrollbar-thumb {
        background: #0f67ff;
        border-radius: 10px;
      }

      ::-webkit-scrollbar-thumb:hover {
        background: #0d55cc;
      }

      .opt {
        background-color: #4c5563ff;
        color: white;
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

      .hamburger {
        display: none;
        position: fixed;
        top: 1.5rem;
        right: 1.5rem;
        z-index: 1200;
        background: rgba(255, 255, 255, 0.08);
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
        transform: rotate(-45deg) translate(11px, -10px);
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

      .charts-container {
        display: flex;
        gap: 1.5rem;
        margin-bottom: 1.5rem;
      }

      .chart-wrapper {
        background: rgba(255, 255, 255, 0.08);
        border-radius: 12px;
        padding: 1.5rem;
        border: 1px solid var(--border-dark);
        box-shadow: var(--shadow);
      }

      .chart-wrapper:first-child {
        flex: 0 0 auto;
        width: 350px;
      }

      .chart-wrapper.fill {
        flex: 1;
        min-width: 0;
        max-width: none;
      }

      .chart-wrapper h3 {
        color: var(--text-primary);
        margin-bottom: 1rem;
        font-size: 1.125rem;
        font-weight: 600;
        text-align: center;
      }

      .chart-wrapper {
        height: 300px;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
      }

      .chart-wrapper canvas {
        max-height: 250px !important;
      }

      .message-alert {
        position: fixed;
        top: 20px;
        right: 20px;
        min-width: 250px;
        max-width: 350px;
        padding: 0.75rem 1rem;
        border-radius: 8px;
        color: var(--text-primary);
        font-size: 0.875rem;
        font-weight: 500;
        display: flex;
        align-items: center;
        gap: 0.75rem;
        z-index: 2000;
        box-shadow: var(--shadow);
        opacity: 0;
        transform: translateX(100%);
        transition: opacity 0.3s ease, transform 0.3s ease;
        cursor: pointer;
      }

      .message-alert.show {
        opacity: 1;
        transform: translateX(0);
      }

      .message-success {
        background: var(--success-green);
        border: 1px solid rgba(40, 167, 69, 0.3);
      }

      .message-error {
        background: var(--error-red);
        border: 1px solid rgba(220, 53, 69, 0.3);
      }

      .message-alert::before {
        content: '';
        display: inline-block;
        width: 20px;
        height: 20px;
        background-size: cover;
        flex-shrink: 0;
      }

      .message-success::before {
        background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="white"><path d="M9 16.2l-3.5-3.5 1.4-1.4L9 13.8l8.6-8.6 1.4 1.4L9 16.2z"/></svg>');
      }

      .message-error::before {
        background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="white"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm5 13.59L15.59 17 12 13.41 8.41 17 7 15.59 10.59 12 7 8.41 8.41 7 12 10.59 15.59 7 17 8.41 13.41 12 17 15.59z"/></svg>');
      }

      @media (max-width: 1400px) {
        .main-content {
          padding: 1.5rem 2rem;
        }
      }

      @media (max-width: 1200px) {
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
          flex-direction: column;
        }

        .search-container, .filter-container {
          max-width: 100%;
        }

        .table-columns,
        .table-row {
          grid-template-columns: 50px 1fr 1fr 120px;
          gap: 0.75rem;
        }

        .table-columns div:nth-child(4),
        .table-row div:nth-child(4) {
          display: none;
        }

        .charts-container {
          flex-direction: column;
          align-items: center;
        }

        .message-alert {
          right: 0.5rem;
        }
      }

      @media (max-width: 768px) {
        .main-content {
          padding: 1rem;
        }

        .page-title {
          font-size: 1.25rem;
        }

        .control-panel {
          padding: 0.5rem 1rem;
          font-size: 0.875rem;
        }

        .table-columns,
        .table-row {
          grid-template-columns: 1fr 1fr;
          gap: 0.5rem;
          padding: 0.75rem;
        }

        .table-columns div:nth-child(1),
        .table-row div:nth-child(1),
        .table-columns div:nth-child(5),
        .table-row div:nth-child(5) {
          display: none;
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

        .actions {
          justify-content: center;
        }

        .message-alert {
          max-width: calc(100% - 1rem);
          min-width: 200px;
          right: 0.5rem;
        }
      }

      @media (max-width: 576px) {
        .sidebar {
          width: 100%;
        }

        .main-content {
          padding: 0.75rem;
        }

        .header {
          flex-direction: column;
          gap: 1rem;
          align-items: flex-start;
        }

        .table-header {
          grid-template-columns: 1fr;
          gap: 0.5rem;
        }

        .table-columns,
        .table-row {
          grid-template-columns: 1fr;
          gap: 0.5rem;
          padding: 0.5rem;
        }

        .table-columns div:nth-child(3),
        .table-row div:nth-child(3) {
          display: none;
        }

        .table-columns {
          display: flex;
          flex-direction: row;
          align-items: center;
          justify-content: space-between;
        }

        .table-row div {
          text-align: left;
        }

        .actions {
          justify-content: flex-end;
        }

        .action-btn {
          width: 28px;
          height: 28px;
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

        .logout {
          left: 0.5rem;
          bottom: 0.5rem;
          font-size: 0.875rem;
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
          <div class="admin-name">Admin</div>
          <div class="admin-role">Quản lý website MasterTicket</div>
        </div>
        <nav>
          <ul class="nav-menu">
            <li class="nav-item">
              <a href="${pageContext.request.contextPath}/admin-servlet/dashboard" class="nav-link">Bảng điều khiển</a>
            </li>
            <li class="nav-item">
              <a href="${pageContext.request.contextPath}/admin-servlet/event-management" class="nav-link">Danh sách sự kiện</a>
            </li>
            <li class="nav-item">
              <a href="${pageContext.request.contextPath}/admin-servlet/user-management" class="nav-link active">Danh sách tài khoản</a>
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
      <!-- Main Content -->
      <div class="main-content">
        <header class="header">
          <div class="control-panel">Quản lí người dùng</div>
        </header>
        <div class="charts-container">
          <div class="chart-wrapper">
            <h3>Phân bố vai trò người dùng</h3>
            <canvas id="roleChart"></canvas>
          </div>
          <div class="chart-wrapper fill">
            <h3>Số lượt đăng nhập theo tháng</h3>
            <canvas id="loginMonthChart"></canvas>
          </div>
        </div>
        <c:if test="${not empty sessionScope.message}">
          <div class="message-alert message-${sessionScope.messageType}">
            ${sessionScope.message}
          </div>
          <c:remove var="message" scope="session" />
          <c:remove var="messageType" scope="session" />
        </c:if>
        <div class="data-table">
          <div class="table-header">
            <div class="page-title">Danh sách người dùng</div>
            <div class="search-container">
              <input type="text" class="search-box" placeholder="Bạn muốn tìm gì?" />
              <div class="search-icon">🔍</div>
            </div>
          </div>
          <div class="table-columns">
            <div>#</div>
            <div>Tên người dùng</div>
            <div>Email</div>
            <div>Số di động</div>
            <div>Ngày tạo tài khoản</div>
            <div>Hành động</div>
          </div>
          <c:forEach var="user" items="${users}" varStatus="status">
            <div class="table-row">
              <div>${status.count}</div>
              <div>
                <span class="status-indicator ${user.isLocked ? 'status-locked' : 'status-active'}"></span>
                <c:out value="${user.name}" />
              </div>
              <div>
                <a href="mailto:${user.email}" class="email-link">
                  <c:out value="${user.email}" />
                </a>
              </div>
              <div class="phoneNum-field">
                <span class="phoneNum-detail">${user.phoneNumber}</span>
              </div>
              <div><c:out value="${user.createdAt}" /></div>
              <div class="actions">
                <c:choose>
                  <c:when test="${user.isLocked}">
                    <button class="action-btn lock-btn locked" onclick="toggleUserLock(${user.id}, 'unlock', '${user.email}')" title="Unlock user">
                      <img src="${pageContext.request.contextPath}/asset/image/UnLock.svg" alt="UnLock" />
                    </button>
                  </c:when>
                  <c:otherwise>
                    <button class="action-btn lock-btn unlocked" onclick="toggleUserLock(${user.id}, 'lock', '${user.email}')" title="Lock user">
                      <img src="${pageContext.request.contextPath}/asset/image/Lock.svg" alt="Lock" />
                    </button>
                  </c:otherwise>
                </c:choose>
                <button class="action-btn edit-btn" onclick="editUser(${user.id})">
                  <img src="${pageContext.request.contextPath}/asset/image/Edit_fill.svg" alt="Edit" />
                </button>
              </div>
            </div>
          </c:forEach>
        </div>
      </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>
      // Animate ellipses
      function animateEllipses() {
        const ellipses = document.querySelectorAll(".bg_elips");
        ellipses.forEach((ellipse, index) => {
          const duration = 8000 + index * 2000;
          ellipse.style.animation = `float ${duration}ms ease-in-out infinite`;
        });
      }
      animateEllipses();

      // Navigation active state
      document.querySelectorAll(".nav-item").forEach((item) => {
        item.addEventListener("click", function () {
          document.querySelectorAll(".nav-item").forEach((nav) => nav.classList.remove("active"));
          this.classList.add("active");
        });
      });

      // Search functionality
      document.querySelector(".search-box").addEventListener("input", function () {
        const searchTerm = this.value.toLowerCase();
        const rows = document.querySelectorAll(".table-row");
        rows.forEach((row) => {
          const name = row.children[1].textContent.toLowerCase();
          const email = row.children[2].textContent.toLowerCase();
          const phoneNum = row.children[3].textContent.toLowerCase();
          if (name.includes(searchTerm) || email.includes(searchTerm) || phoneNum.includes(searchTerm)) {
            row.style.display = "grid";
          } else {
            row.style.display = "none";
          }
        });
      });

      // Hamburger menu functionality
      const hamburger = document.querySelector(".hamburger");
      const sidebar = document.querySelector(".sidebar");
      const overlay = document.querySelector(".overlay");
      hamburger.addEventListener("click", () => {
        hamburger.classList.toggle("active");
        sidebar.classList.toggle("active");
        overlay.classList.toggle("active");
      });

      // Close sidebar and overlay when clicking a nav link on mobile
      document.querySelectorAll(".nav-link").forEach((link) => {
        link.addEventListener("click", () => {
          if (window.innerWidth <= 992) {
            hamburger.classList.remove("active");
            sidebar.classList.remove("active");
            overlay.classList.remove("active");
          }
        });
      });

      // Close sidebar and overlay when clicking outside
      document.addEventListener("click", (e) => {
        if (window.innerWidth <= 992 && !sidebar.contains(e.target) && !hamburger.contains(e.target)) {
          hamburger.classList.remove("active");
          sidebar.classList.remove("active");
          overlay.classList.remove("active");
        }
      });

      // Toast notification functionality
      document.addEventListener("DOMContentLoaded", () => {
        const messages = document.querySelectorAll(".message-alert");
        messages.forEach((message) => {
          // Show toast
          setTimeout(() => {
            message.classList.add("show");
          }, 100);

          // Auto-dismiss after 3 seconds
          setTimeout(() => {
            message.classList.remove("show");
            setTimeout(() => {
              message.remove();
            }, 300); // Wait for transition to complete
          }, 3000);
        });
      });

      // Parse JSON data
      var roleDistributionJson = '<%= request.getAttribute("roleDistributionJson") %>';
      var loginDistributionByMonthJson = '<%= request.getAttribute("loginDistributionByMonthJson") %>';
      let roleDistribution = {};
      let loginDistributionByMonth = {};
      try {
        roleDistribution = JSON.parse(roleDistributionJson.replace(/&quot;/g, '"').trim() || "{}");
        loginDistributionByMonth = JSON.parse(loginDistributionByMonthJson.replace(/&quot;/g, '"').trim() || "{}");
      } catch (e) {
        console.error("Failed to parse JSON data:", e);
        roleDistribution = {};
        loginDistributionByMonth = {};
      }
      console.log("Parsed roleDistribution:", roleDistribution);
      console.log("Parsed loginDistributionByMonth:", loginDistributionByMonth);

      // Chart initialization
      const chartColors = {
        primary: "#6366f1",
        success: "#10b981",
        warning: "#f59e0b",
        danger: "#ef4444",
        info: "#06b6d4",
        purple: "#8b5cf6",
        pink: "#ec4899",
        orange: "#f97316",
      };

      if (Object.keys(roleDistribution).length > 0) {
        const roleChart = new Chart(document.getElementById("roleChart"), {
          type: "pie",
          data: {
            labels: Object.keys(roleDistribution),
            datasets: [{
              data: Object.values(roleDistribution),
              backgroundColor: Object.keys(roleDistribution).map((_, index) =>
                [chartColors.success, chartColors.warning, chartColors.danger, chartColors.info][index % 4]
              ),
              borderColor: "#1b1c21",
              borderWidth: 2,
            }],
          },
          options: {
            responsive: true,
            plugins: {
              legend: { position: "top", labels: { color: "white" } },
              title: { display: false },
            },
          },
        });
      }

      if (Object.keys(loginDistributionByMonth).length > 0) {
        const currentDate = new Date();
        const months = [];
        const monthLabels = [];
        for (let i = 11; i >= 0; i--) {
          const date = new Date(currentDate.getFullYear(), currentDate.getMonth() - i, 1);
          const monthKey = date.toISOString().slice(0, 7);
          const monthLabel = date.toLocaleDateString("vi-VN", { month: "short", year: "numeric" });
          months.push(monthKey);
          monthLabels.push(monthLabel);
        }
        const newData = months.map((month) => loginDistributionByMonth.new[month] || 0);
        const oldData = months.map((month) => loginDistributionByMonth.old[month] || 0);
        const loginMonthChart = new Chart(document.getElementById("loginMonthChart"), {
          type: "bar",
          data: {
            labels: monthLabels,
            datasets: [
              {
                label: "Người dùng mới",
                data: newData,
                backgroundColor: "#8b5cf6",
                borderColor: "#1b1c21",
                borderWidth: 1,
              },
              {
                label: "Người dùng cũ",
                data: oldData,
                backgroundColor: "rgba(255, 255, 255, 0.5)",
                borderColor: "#1b1c21",
                borderWidth: 1,
              },
            ],
          },
          options: {
            responsive: true,
            plugins: {
              legend: { position: "top", labels: { color: "white" } },
              title: { display: false },
            },
            scales: {
              y: {
                beginAtZero: true,
                ticks: { color: "white", stepSize: 1 },
                grid: { color: "rgba(255, 255, 255, 0.1)" },
              },
              x: {
                ticks: { color: "white", maxRotation: 45, minRotation: 45 },
                grid: { color: "rgba(255, 255, 255, 0.1)" },
              },
            },
          },
        });
      }

      // Toggle user lock/unlock
      function toggleUserLock(userId, action, email) {
        const actionText = action === "lock" ? "khóa" : "mở khóa";
        const icon = action === "lock" ? "warning" : "question";
        console.log("current action: ", actionText);
        console.log("email:", email);
        const title = "Xác nhận " + actionText + " tài khoản";
        const text = "Bạn có chắc muốn " + actionText + " tài khoản " + (email || "unknown") + "?";
        Swal.fire({
          title: title,
          text: text,
          icon: icon,
          showCancelButton: true,
          confirmButtonText: "Có",
          cancelButtonText: "Hủy",
          confirmButtonColor: action === "lock" ? "#dc3545" : "#28a745",
        }).then((result) => {
          if (result.isConfirmed) {
            const url = "${pageContext.request.contextPath}/admin-servlet/user-management/lock-user?userId=" + userId + "&action=" + action;
            fetch(url, {
              method: "POST",
            })
              .then((response) => response.json().then((data) => ({ status: response.status, data })))
              .then(({ status, data }) => {
                if (status === 200 && data.success) {
                  const messageDiv = document.createElement("div");
                  messageDiv.className = "message-alert message-success";
                  messageDiv.textContent = data.message || `Tài khoản đã được ${actionText} thành công!`;
                  document.body.appendChild(messageDiv);
                  setTimeout(() => {
                    messageDiv.classList.add("show");
                  }, 100);
                  setTimeout(() => {
                    messageDiv.classList.remove("show");
                    setTimeout(() => {
                      messageDiv.remove();
                      window.location.reload();
                    }, 300);
                  }, 2000);
                } else {
                  const messageDiv = document.createElement("div");
                  messageDiv.className = "message-alert message-error";
                  messageDiv.textContent = data.message || `Không thể ${actionText} tài khoản.`;
                  document.body.appendChild(messageDiv);
                  setTimeout(() => {
                    messageDiv.classList.add("show");
                  }, 100);
                  setTimeout(() => {
                    messageDiv.classList.remove("show");
                    setTimeout(() => {
                      messageDiv.remove();
                    }, 300);
                  }, 2000);
                }
              })
              .catch((error) => {
                console.error(`Error ${actionText} user:`, error);
                const messageDiv = document.createElement("div");
                messageDiv.className = "message-alert message-error";
                messageDiv.textContent = `Lỗi hệ thống khi ${actionText} tài khoản.`;
                document.body.appendChild(messageDiv);
                setTimeout(() => {
                  messageDiv.classList.add("show");
                }, 100);
                setTimeout(() => {
                  messageDiv.classList.remove("show");
                  setTimeout(() => {
                    messageDiv.remove();
                  }, 300);
                }, 2000);
              });
          }
        });
      }

      // Display server message if present
      const message = '<%= session.getAttribute("message") != null ? session.getAttribute("message") : "" %>';
      if (message) {
        const messageType = '<%= session.getAttribute("messageType") != null ? session.getAttribute("messageType") : "success" %>';
        const messageDiv = document.createElement("div");
        messageDiv.className = `message-alert message-${messageType}`;
        messageDiv.textContent = message;
        document.body.appendChild(messageDiv);
        setTimeout(() => {
          messageDiv.classList.add("show");
        }, 100);
        setTimeout(() => {
          messageDiv.classList.remove("show");
          setTimeout(() => {
            messageDiv.remove();
          }, 300);
        }, 3000);
      }

      function editUser(userId) {
        const url = "${pageContext.request.contextPath}/admin-servlet/user-management/edit-user?userId=" + userId;
        window.location.href = url;
      }
    </script>
  </body>
</html>