<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib uri="http://java.sun.com/jsp/jstl/core"
prefix="c" %> <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>EventTicketHub Admin</title>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/3.9.1/chart.min.js"></script>
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

      .header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 2rem;
      }

      .page-title {
        color: white;
        font-size: 24px;
        font-weight: 700;
      }

      .control-panel {
        background: rgba(255, 255, 255, 0.18);
        border-radius: 12px;
        padding: 12px 24px;
        color: #e2e8f0;
        font-weight: 600;
        backdrop-filter: blur(20px);
      }

      .stats-grid {
        display: flex;
        gap: 30px;
        flex-wrap: wrap;
      }

      .stat-card {
        flex: 1;
        min-width: 200px;
        background: rgba(255, 255, 255, 0.18);
        border-radius: 12px;
        padding: 2rem;
        backdrop-filter: blur(20px);
        transition: all 0.3s ease;
        border: 1px solid rgba(255, 255, 255, 0.1);
      }

      .stat-card:hover {
        transform: translateY(-2px);
        border-color: rgba(255, 255, 255, 0.2);
      }

      .stat-title {
        color: #94a3b8;
        font-size: 0.875rem;
        margin-bottom: 0.5rem;
      }

      .stat-value {
        color: white;
        font-size: 1.5rem;
        font-weight: 700;
      }

      .stat-content {
        display: flex;
        flex-direction: row;
        align-items: center;
      }

      .content-grid {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 30px;
      }

      .chart-section,
      .table-section {
        background: rgba(255, 255, 255, 0.18);
        border-radius: 12px;
        padding: 2rem;
        backdrop-filter: blur(20px);
        border: 1px solid rgba(255, 255, 255, 0.1);
        height: 450px;
        display: flex;
        flex-direction: column;
      }
      .chart-container {
        flex: 1;
        position: relative;
        height: 350px;
        max-height: 350px;
      }

      #userStatsChart {
        background: rgba(0, 0, 0, 0.1);
        border-radius: 8px;
        width: 100% !important;
        height: 100% !important;
      }

      .section-title {
        color: white;
        font-size: 1.25rem;
        font-weight: 600;
        margin-bottom: 1rem;
      }

      /* .chart-placeholder {
        height: 200px;
        background: rgba(0, 0, 0, 0.2);
        border-radius: 8px;
        display: flex;
        align-items: center;
        justify-content: center;
        color: #94a3b8;
      } */

      .table-container {
        height: 350px;
        max-height: 350px;
        overflow-x: auto;
        overflow-y: auto;
      }

      table {
        width: 100%;
        border-collapse: collapse;
        color: white;
      }

      th,
      td {
        padding: 1rem;
        text-align: left;
        border-bottom: 1px solid rgba(255, 255, 255, 0.1);
      }

      th {
        font-weight: 600;
        color: #e2e8f0;
      }

      tbody tr:hover {
        background: rgba(255, 255, 255, 0.05);
      }

      .status-tag {
        padding: 0.25rem 0.5rem;
        border-radius: 4px;
        font-size: 0.75rem;
        font-weight: 500;
        text-wrap: nowrap;
      }

      .status-active {
        background: rgba(40, 167, 69, 0.2);
        color: #28a745;
      }

      .status-pending {
        background: rgba(255, 193, 7, 0.2);
        color: #ffc107;
      }

      .status-inactive {
        background: rgba(220, 53, 69, 0.2);
        color: #dc3545;
      }

      .hamburger {
        display: none;
        position: fixed;
        top: 34px;
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

      @media (max-width: 1400px) {
        .header {
          margin-top: 30px;
        }
        .main-content {
          padding: 0 50px;
        }

        .stats-grid {
          gap: 20px;
        }

        .content-grid {
          gap: 20px;
        }
      }

      @media (max-width: 1200px) {
        .header {
          margin-top: 30px;
        }

        .content-grid {
          grid-template-columns: 1fr;
        }

        .sidebar {
          width: 20%;
        }

        .main-content {
          padding: 0 30px;
        }
        .chart-section,
        .table-section {
          height: 400px;
        }

        .chart-container,
        .table-container {
          height: 300px;
          max-height: 300px;
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
        .control-panel {
          display: none;
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

        .page-title {
          font-size: 1.5rem;
        }

        .control-panel {
          margin-top: 30px;
          padding: 8px 16px;
          font-size: 0.875rem;
        }
        .chart-section,
        .table-section {
          height: 350px;
        }

        .chart-container,
        .table-container {
          height: 250px;
          max-height: 250px;
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

        .header {
          flex-direction: column;
          gap: 1rem;
          align-items: flex-start;
        }

        .stats-grid {
          gap: 15px;
        }

        .content-grid {
          gap: 15px;
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
        .content-grid {
          display: flex;
          flex-direction: column;
          align-items: stretch;
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
      alt="Background Ellipse 1"
    />
    <img
      class="bg_elips secondElement"
      src="${pageContext.request.contextPath}/asset/image/full2.svg"
      alt="Background Ellipse 2"
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
        <header class="header">
          <h1 class="page-title">Bảng điều khiển</h1>
          <div style="display: flex; align-items: center; gap: 24px;">
            <div id="notification-bell" style="position: relative; cursor: pointer;">
              <svg width="28" height="28" fill="white" viewBox="0 0 24 24">
                <path d="M12 2C9.243 2 7 4.243 7 7v2.071C7 10.13 6.37 11.09 5.44 11.58A1 1 0 0 0 5 12.5V17l-1 1v1h16v-1l-1-1v-4.5a1 1 0 0 0-.44-.92C17.63 11.09 17 10.13 17 9.071V7c0-2.757-2.243-5-5-5zm0 18c-1.104 0-2-.896-2-2h4c0 1.104-.896 2-2 2z"/>
              </svg>
              <span id="notification-badge" style="position: absolute; top: 0; right: 0; background: #ff3333; color: white; border-radius: 50%; padding: 2px 7px; font-size: 12px; display: none;">0</span>
              <div id="notification-popup" style="display: none; position: absolute; right: 0; top: 36px; background: #222; color: white; min-width: 300px; border-radius: 8px; box-shadow: 0 4px 16px rgba(0,0,0,0.2); z-index: 9999;">
                <div id="notification-list" style="max-height: 300px; overflow-y: auto;"></div>
              </div>
            </div>
            <div class="control-panel">Tổng quan</div>
          </div>
        </header>
        <section class="stats-grid">
          <div class="stat-card">
            <div class="stat-title">Sự kiện tháng này</div>
            <div class="stat-content">
              <img
                src="${pageContext.request.contextPath}/asset/image/Ticket_duotone.svg"
                alt=""
                class="stat-icon"
              />
              <div class="stat-value">${eventThisMonth}</div>
            </div>
          </div>
          <div class="stat-card">
            <div class="stat-title">Tổng số người dùng</div>
            <div class="stat-content">
              <img
                src="${pageContext.request.contextPath}/asset/image/Property1=Group_light.svg"
                alt=""
                class="stat-icon"
              />
              <div class="stat-value">${totalUser}</div>
            </div>
          </div>
          <div class="stat-card">
            <div class="stat-title">Tổng doanh thu:</div>
            <span class="stat-content">
              <img
                src="${pageContext.request.contextPath}/asset/image/Wallet.svg"
                alt=""
                class="stat-icon"
              />
              <div class="stat-value">
                ${totalRevenue} vnđ
              </div>
            </span>
          </div>
        </section>
        <section class="content-grid">
          <div class="chart-section">
            <h2 class="section-title">Doanh thu từ nhà tổ chức</h2>
            <div class="chart-container">
              <canvas id="revenueChart"></canvas>
            </div>
          </div>
          <div class="table-section">
            <h2 class="section-title">Top sự kiện hot</h2>
            <div class="table-container">
              <table>
                <thead>
                  <tr>
                    <th>Tên sự kiện</th>
                    <th>Ngày bắt đầu</th>
                    <th>Trạng thái</th>
                  </tr>
                </thead>
                <tbody>
                  <c:forEach var="event" items="${events}">
                    <tr onclick="handleEditEvent('${event.eventID}')">
                      <td>${event.name}</td>
                      <td>
                        <fmt:formatDate
                          value="${event.startTime}"
                          pattern="dd/MM/yyyy"
                        />
                      </td>
                      <td>
                        <span class="status-tag status-${event.status}">
                          ${event.status == 'active' ? 'Đang hoạt động' :
                          event.status == 'pending' ? 'Đang chờ duyệt' : 'Đã
                          dừng'}
                        </span>
                      </td>
                    </tr>
                  </c:forEach>
                </tbody>
              </table>
            </div>
          </div>
        </section>
      </main>
    </div>
    <script>

      function handleEditEvent(eventID) {
        window.location.href = "${pageContext.request.contextPath}/admin-servlet/event-management?action=edit-event&eventId=" + eventID;
      }
      const hamburger = document.querySelector(".hamburger");
      const sidebar = document.querySelector(".sidebar");
      const overlay = document.querySelector(".overlay");

      hamburger.addEventListener("click", () => {
        hamburger.classList.toggle("active");
        sidebar.classList.toggle("active");
        overlay.classList.toggle("active");
      });

      document.querySelectorAll(".nav-link").forEach((link) => {
        link.addEventListener("click", () => {
          if (window.innerWidth <= 992) {
            hamburger.classList.remove("active");
            sidebar.classList.remove("active");
            overlay.classList.remove("active");
          }
        });
      });

      document.addEventListener("click", (e) => {
        if (
          window.innerWidth <= 992 &&
          !sidebar.contains(e.target) &&
          !hamburger.contains(e.target)
        ) {
          hamburger.classList.remove("active");
          sidebar.classList.remove("active");
          overlay.classList.remove("active");
        }
      });

      function animateEllipses() {
        const ellipses = document.querySelectorAll(".bg_elips");
        ellipses.forEach((ellipse, index) => {
          const duration = 8000 + index * 2000;
          ellipse.style.animation = `float ${duration}ms ease-in-out infinite`;
        });
      }
      animateEllipses();

            const organizerNames = [
        <c:forEach var="organizer" items="${topEventOrganizers}" varStatus="loop">
          "${organizer.name}"${loop.last ? '' : ','}
        </c:forEach>
      ];
      const organizerRevenues = [
        <c:forEach var="organizer" items="${topEventOrganizers}" varStatus="loop">
          ${organizer.totalRevenue}${loop.last ? '' : ','}
        </c:forEach>
      ];

      const revenueData = {
        labels: organizerNames,
        datasets: [
          {
            label: "Doanh thu (VNĐ)",
            data: organizerRevenues,
            backgroundColor: [
              "rgba(59, 130, 246, 0.7)",
              "rgba(16, 185, 129, 0.7)",
              "rgba(255, 193, 7, 0.7)",
              "rgba(220, 53, 69, 0.7)",
              "rgba(147, 51, 234, 0.7)"
            ],
            borderColor: [
              "rgba(59, 130, 246, 1)",
              "rgba(16, 185, 129, 1)",
              "rgba(255, 193, 7, 1)",
              "rgba(220, 53, 69, 1)",
              "rgba(147, 51, 234, 1)"
            ],
            borderWidth: 1
          }
        ]
      };

      const config = {
        type: "bar",
        data: revenueData,
        options: {
          responsive: true,
          maintainAspectRatio: false,
          plugins: {
            legend: {
              labels: {
                color: "#e2e8f0",
                font: {
                  size: 12
                }
              }
            },
            tooltip: {
              callbacks: {
                label: function(context) {
                  let label = context.dataset.label || '';
                  if (label) {
                    label += ': ';
                  }
                  if (context.parsed.y !== null) {
                    label += new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(context.parsed.y);
                  }
                  return label;
                }
              }
            }
          },
          scales: {
            y: {
              beginAtZero: true,
              grid: {
                color: "rgba(255, 255, 255, 0.1)"
              },
              ticks: {
                color: "#94a3b8",
                callback: function(value) {
                  return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND', notation: 'compact' }).format(value);
                }
              }
            },
            x: {
              grid: {
                color: "rgba(255, 255, 255, 0.1)"
              },
              ticks: {
                color: "#94a3b8",
                maxRotation: 45,
                minRotation: 45
              }
            }
          }
        }
      };

      const ctx = document.getElementById("revenueChart").getContext("2d");
      const revenueChart = new Chart(ctx, config);

      // Notification Bell WebSocket
      const notificationBell = document.getElementById('notification-bell');
      const notificationBadge = document.getElementById('notification-badge');
      const notificationPopup = document.getElementById('notification-popup');
      const notificationList = document.getElementById('notification-list');
      let notificationCount = 0;
      let notifications = [];

      notificationBell.addEventListener('click', function() {
        if (notificationPopup.style.display === 'none' || notificationPopup.style.display === '') {
          notificationPopup.style.display = 'block';
          notificationBadge.style.display = 'none';
          notificationCount = 0;
          // Hiển thị thông báo hoặc "Không có thông báo nào cả"
          renderNotificationList();
        } else {
          notificationPopup.style.display = 'none';
        }
      });

      function renderNotificationList() {
        notificationList.innerHTML = '';
        // Lọc chỉ thông báo khi eventowner tạo event mới
        const eventNotifications = notifications.filter(n => n.notificationType === 'event');
        if (eventNotifications.length === 0) {
          notificationList.innerHTML = '<div style="padding: 16px; color: #aaa; text-align: center;">Không có thông báo nào cả</div>';
        } else {
          eventNotifications.forEach(notification => addNotificationToList(notification));
        }
      }

      function addNotificationToList(notification) {
        const div = document.createElement('div');
        div.style.padding = '12px';
        div.style.borderBottom = '1px solid #333';
        div.innerHTML = '<b>' + notification.title + '</b><br>' +
          "<span style='font-size: 13px;'>" + notification.content + '</span><br>' +
          "<span style='font-size: 11px; color: #aaa;'>" + new Date(notification.createdAt).toLocaleString('vi-VN') + '</span>';
        notificationList.appendChild(div);
      }

      // WebSocket connection
      const ws = new WebSocket("ws://" + window.location.host + "${pageContext.request.contextPath}/websocket/admin-notification");
      ws.onmessage = function(event) {
        const notification = JSON.parse(event.data);
        notifications.unshift(notification);
        notificationCount++;
        notificationBadge.textContent = notificationCount;
        notificationBadge.style.display = 'block';
        // Nếu popup đang mở, cập nhật lại danh sách
        if (notificationPopup.style.display === 'block') {
          renderNotificationList();
        }
      };
    </script>
  </body>
</html>