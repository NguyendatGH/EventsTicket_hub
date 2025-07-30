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
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
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

      /* Simple Notification Styles */
      .notification-container {
        position: relative;
      }

      .notification-bell {
        position: relative;
        cursor: pointer;
        padding: 8px;
        border-radius: 50%;
        background: rgba(255, 255, 255, 0.1);
        transition: all 0.3s ease;
        display: flex;
        align-items: center;
        justify-content: center;
        width: 40px;
        height: 40px;
      }

      .notification-bell:hover {
        background: rgba(255, 255, 255, 0.2);
        transform: scale(1.1);
      }

      .notification-bell i {
        color: white;
        font-size: 18px;
      }

      .notification-badge {
        position: absolute;
        top: -5px;
        right: -5px;
        background: #ff4757;
        color: white;
        border-radius: 50%;
        width: 20px;
        height: 20px;
        display: none;
        align-items: center;
        justify-content: center;
        font-size: 12px;
        font-weight: bold;
        min-width: 20px;
      }

      .notification-badge.show {
        display: flex;
      }

      .notification-dropdown {
        position: absolute;
        top: 100%;
        right: 0;
        width: 350px;
        max-height: 400px;
        background: rgba(15, 23, 42, 0.95);
        backdrop-filter: blur(20px);
        border: 1px solid rgba(255, 255, 255, 0.1);
        border-radius: 12px;
        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
        z-index: 1000;
        display: none;
        overflow: hidden;
      }

      .notification-dropdown.show {
        display: block;
      }

      .notification-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 16px 20px;
        border-bottom: 1px solid rgba(255, 255, 255, 0.1);
      }

      .notification-header h3 {
        color: white;
        font-size: 16px;
        font-weight: 600;
        margin: 0;
      }

      .mark-all-read {
        background: none;
        border: none;
        color: #64f3ff;
        font-size: 12px;
        cursor: pointer;
        padding: 4px 8px;
        border-radius: 4px;
        transition: all 0.3s ease;
      }

      .mark-all-read:hover {
        background: rgba(100, 243, 255, 0.1);
      }

      .notification-list {
        max-height: 300px;
        overflow-y: auto;
      }

      .notification-item {
        padding: 16px 20px;
        border-bottom: 1px solid rgba(255, 255, 255, 0.05);
        cursor: pointer;
        transition: all 0.3s ease;
      }

      .notification-item:hover {
        background: rgba(255, 255, 255, 0.05);
      }

      .notification-item.unread {
        background: rgba(100, 243, 255, 0.1);
      }

      .notification-item.unread:hover {
        background: rgba(100, 243, 255, 0.15);
      }

      .notification-title {
        color: white;
        font-weight: 600;
        font-size: 14px;
        margin-bottom: 4px;
        display: block;
      }

      .notification-content {
        color: rgba(255, 255, 255, 0.8);
        font-size: 12px;
        line-height: 1.4;
        margin-bottom: 8px;
        display: block;
        word-wrap: break-word;
        max-width: 100%;
      }

      .notification-meta {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-top: 0.5rem;
        font-size: 0.75rem;
        color: var(--text-secondary);
      }
      
      .notification-type {
        background: rgba(255, 255, 255, 0.1);
        padding: 0.25rem 0.5rem;
        border-radius: 0.25rem;
        font-size: 0.7rem;
        text-transform: uppercase;
        font-weight: 500;
      }
      
      .notification-time {
        color: rgba(255, 255, 255, 0.6);
        font-size: 11px;
        display: block;
      }

      .notification-empty {
        padding: 20px;
        text-align: center;
        color: rgba(255, 255, 255, 0.6);
        font-size: 14px;
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

      .popup-header {
         display: flex;
         justify-content: space-between;
         align-items: center;
         margin-bottom: 8px;
       }

       .popup-header strong {
         font-size: 14px;
         font-weight: 600;
       }

       .popup-close {
         background: none;
         border: none;
         color: white;
         font-size: 18px;
         cursor: pointer;
         padding: 0;
         width: 20px;
         height: 20px;
         display: flex;
         align-items: center;
         justify-content: center;
         border-radius: 50%;
         transition: background-color 0.2s;
       }

       .popup-close:hover {
         background-color: rgba(255, 255, 255, 0.2);
       }

       .popup-body {
         font-size: 13px;
         line-height: 1.4;
         opacity: 0.9;
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
        <header class="header">
          <h1 class="page-title">Bảng điều khiển</h1>
          <div class="control-panel">
            <div class="notification-container">
              <button class="notification-bell" id="notificationBell">
                <i class="fas fa-bell"></i>
                <span class="notification-badge" id="notificationBadge">0</span>
              </button>
              <div class="notification-dropdown" id="notificationDropdown">
                <div class="notification-header">
                  <h3>Thông báo</h3>
                  <button class="mark-all-read" id="markAllRead">Đánh dấu tất cả đã đọc</button>
                </div>
                <div class="notification-list" id="notificationList">
                  <div class="notification-loading">Đang tải...</div>
                </div>
              </div>
            </div>
            <button id="testNotificationBtn" style="margin-left: 10px; padding: 8px 16px; background: #007bff; color: white; border: none; border-radius: 4px; cursor: pointer;">Test Notification</button>
            <button id="testParsingBtn" style="margin-left: 10px; padding: 8px 16px; background: #28a745; color: white; border: none; border-radius: 4px; cursor: pointer;">Test Parsing</button>
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
          <div class="stat-card">
            <div class="stat-title">Yêu cầu hoàn tiền chờ xử lý</div>
            <div class="stat-content">
              <img
                src="${pageContext.request.contextPath}/asset/image/Property1=Done.svg"
                alt=""
                class="stat-icon"
              />
              <div class="stat-value">${pendingRefundsCount}</div>
            </div>
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

            // ===== SIMPLE NOTIFICATION SYSTEM =====
      
      // Notification elements
      const notificationBell = document.getElementById('notificationBell');
      const notificationDropdown = document.getElementById('notificationDropdown');
      const notificationList = document.getElementById('notificationList');
      const notificationBadge = document.getElementById('notificationBadge');
      const markAllRead = document.getElementById('markAllRead');
      const testNotificationBtn = document.getElementById('testNotificationBtn');
      const testParsingBtn = document.getElementById('testParsingBtn');

      // WebSocket connection
      let adminNotificationSocket = null;

      // Initialize WebSocket
      function initAdminNotificationWebSocket() {
        const adminId = 1; // Admin ID
        console.log('🔌 Initializing Admin WebSocket for Admin ID:', adminId);
        
        const wsProtocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
        const wsUrl = wsProtocol + "//" + window.location.host + '${pageContext.request.contextPath}/websocket/notifications?userId=' + adminId;
        console.log('🔗 Connecting to Admin Notification WebSocket:', wsUrl);

        adminNotificationSocket = new WebSocket(wsUrl);

        adminNotificationSocket.onopen = function(event) {
          console.log('✅ Admin WebSocket connection opened');
        };

        adminNotificationSocket.onmessage = function(event) {
          console.log('📨 Admin received notification:', event.data);
          try {
            const notification = JSON.parse(event.data);
            console.log('📋 Parsed notification:', notification);
            
            // Add to dropdown if open
            if (notificationDropdown.classList.contains('show')) {
              addNotificationToDropdown(notification);
            }
            
            // Update badge
            updateNotificationBadgeFromWebSocket();
            
          } catch (e) {
            console.error('❌ Error parsing notification:', e);
          }
        };

        adminNotificationSocket.onerror = function(error) {
          console.error('❌ Admin WebSocket Error:', error);
        };

        adminNotificationSocket.onclose = function(event) {
          console.log('🔌 Admin WebSocket connection closed');
          // Reconnect after 5 seconds
          setTimeout(() => {
            console.log('🔄 Attempting to reconnect...');
            initAdminNotificationWebSocket();
          }, 5000);
        };
      }

      // Toggle notification dropdown
      notificationBell.addEventListener('click', function(e) {
        e.stopPropagation();
        notificationDropdown.classList.toggle('show');
        if (notificationDropdown.classList.contains('show')) {
          loadNotifications();
        }
      });

      // Close dropdown when clicking outside
      document.addEventListener('click', function(e) {
        if (!notificationBell.contains(e.target) && !notificationDropdown.contains(e.target)) {
          notificationDropdown.classList.remove('show');
        }
      });

      // Test parsing function
      function testParsing() {
        console.log('🧪 Testing parsing logic...');
        
        // Test refund notification content
        const refundContent = "Người gửi: Nguyễn Văn A (ID: 15) | Lý do: Vé bị hủy do sự kiện bị hoãn | Số tiền: 500,000 VNĐ | Đơn hàng: #123";
        console.log('🧪 Testing refund content:', refundContent);
        
        const senderMatch1 = refundContent.match(/Người gửi: ([^|]+?)(?=\s*\|\s*Lý do:)/);
        if (senderMatch1) {
          console.log('✅ Refund sender parsed:', senderMatch1[1].trim());
        } else {
          console.log('❌ Failed to parse refund sender');
        }
        
        const reasonMatch1 = refundContent.match(/Lý do: ([^|]+?)(?=\s*\|\s*(?:Số tiền:|Loại hỗ trợ:|Đơn hàng:|Mô tả:))/);
        if (reasonMatch1) {
          console.log('✅ Refund reason parsed:', reasonMatch1[1].trim());
        } else {
          console.log('❌ Failed to parse refund reason');
        }
        
        const amountMatch1 = refundContent.match(/Số tiền: ([^|]+?)(?=\s*\|\s*Đơn hàng:)/);
        if (amountMatch1) {
          console.log('✅ Refund amount parsed:', amountMatch1[1].trim());
        } else {
          console.log('❌ Failed to parse refund amount');
        }
        
        const orderMatch1 = refundContent.match(/Đơn hàng: #(\d+)/);
        if (orderMatch1) {
          console.log('✅ Refund order ID parsed:', orderMatch1[1]);
        } else {
          console.log('❌ Failed to parse refund order ID');
        }
        
        // Test support notification content
        const supportContent = "Người gửi: Trần Thị B (ID: 23) | Lý do: Không thể thanh toán qua PayOS | Loại hỗ trợ: Thanh toán | Mô tả: Lỗi khi nhập thông tin thẻ";
        console.log('🧪 Testing support content:', supportContent);
        
        const senderMatch2 = supportContent.match(/Người gửi: ([^|]+?)(?=\s*\|\s*Lý do:)/);
        if (senderMatch2) {
          console.log('✅ Support sender parsed:', senderMatch2[1].trim());
        } else {
          console.log('❌ Failed to parse support sender');
        }
        
        const reasonMatch2 = supportContent.match(/Lý do: ([^|]+?)(?=\s*\|\s*(?:Số tiền:|Loại hỗ trợ:|Đơn hàng:|Mô tả:))/);
        if (reasonMatch2) {
          console.log('✅ Support reason parsed:', reasonMatch2[1].trim());
        } else {
          console.log('❌ Failed to parse support reason');
        }
        
        const supportTypeMatch2 = supportContent.match(/Loại hỗ trợ: ([^|]+?)(?=\s*\|\s*Mô tả:)/);
        if (supportTypeMatch2) {
          console.log('✅ Support type parsed:', supportTypeMatch2[1].trim());
        } else {
          console.log('❌ Failed to parse support type');
        }
      }

      // Load notifications from server
      function loadNotifications() {
        fetch('${pageContext.request.contextPath}/admin-notifications')
          .then(response => {
            console.log('📡 Response status:', response.status);
            console.log('📡 Response headers:', response.headers);
            return response.text();
          })
          .then(text => {
            console.log('📡 Raw response text:', text);
            try {
              const data = JSON.parse(text);
              console.log('📋 Parsed notifications:', data);
              console.log('📋 Data type:', typeof data);
              console.log('📋 Is array:', Array.isArray(data));
              if (Array.isArray(data)) {
                console.log('📋 Number of notifications:', data.length);
                if (data.length > 0) {
                  console.log('📋 First notification:', data[0]);
                  console.log('📋 First notification keys:', Object.keys(data[0]));
                  console.log('📋 First notification title:', data[0].title);
                  console.log('📋 First notification content:', data[0].content);
                  console.log('📋 First notification isIsRead:', data[0].isIsRead);
                }
                displayNotifications(data);
                updateNotificationBadge(data);
              } else {
                console.log('📋 Data is not an array:', data);
              }
            } catch (e) {
              console.error('❌ Error parsing JSON:', e);
              console.error('❌ Raw text was:', text);
            }
          })
          .catch(error => {
            console.error('❌ Error loading notifications:', error);
          });
      }

      // Display notifications in dropdown
      function displayNotifications(notifications) {
        console.log('🔍 Displaying notifications:', notifications);
        
        if (!notifications || notifications.length === 0) {
          notificationList.innerHTML = '<div class="notification-empty">Không có thông báo nào</div>';
          return;
        }

        notificationList.innerHTML = '';
        notifications.forEach((notification, index) => {
          console.log(`📋 Notification ${index + 1}:`, notification);
          console.log(`📋 All keys:`, Object.keys(notification));
          console.log(`📋 isIsRead:`, notification.isIsRead);
          console.log(`📋 isRead:`, notification.isRead);
          console.log(`📋 title:`, notification.title);
          console.log(`📋 content:`, notification.content);
          console.log(`📋 notificationID:`, notification.notificationID);
          console.log(`📋 userID:`, notification.userID);
          console.log(`📋 notificationType:`, notification.notificationType);
          
          const notificationItem = document.createElement('div');
          notificationItem.className = `notification-item ${!notification.isIsRead ? 'unread' : ''}`;
          
          const timeAgo = formatTimeAgo(notification.createdAt);
          
          // Ensure we have proper content
          const title = notification.title || 'Không có tiêu đề';
          const content = notification.content || 'Không có nội dung';
          const type = notification.notificationType || 'system';
          const notificationId = notification.notificationID || 'N/A';
          const priority = notification.priority || 'normal';
          const relatedId = notification.relatedID || null;
          
          console.log(`📋 Final display values - Title: "${title}", Content: "${content}", Type: "${type}", ID: "${notificationId}", Priority: "${priority}", RelatedID: "${relatedId}"`);
          
          // Add more detailed logging
          if (!title || title === 'null' || title === 'undefined') {
            console.warn(`⚠️ Notification ${index + 1} has invalid title:`, title);
          }
          if (!content || content === 'null' || content === 'undefined') {
            console.warn(`⚠️ Notification ${index + 1} has invalid content:`, content);
          }
          
          // Parse content to extract sender and reason
          let sender = 'Không xác định';
          let reason = 'Không có lý do';
          let amount = '';
          let orderId = '';
          
          if (content && content !== 'null' && content !== 'undefined') {
            console.log('🔍 Parsing content:', content);
            
            // Parse content for sender and reason
            const senderMatch = content.match(/Người gửi: ([^|]+?)(?=\s*\|\s*Lý do:)/);
            if (senderMatch) {
              sender = senderMatch[1].trim();
              console.log('✅ Parsed sender:', sender);
            } else {
              console.log('❌ Failed to parse sender from:', content);
            }
            
            const reasonMatch = content.match(/Lý do: ([^|]+?)(?=\s*\|\s*(?:Số tiền:|Loại hỗ trợ:|Đơn hàng:|Mô tả:))/);
            if (reasonMatch) {
              reason = reasonMatch[1].trim();
              console.log('✅ Parsed reason:', reason);
            } else {
              console.log('❌ Failed to parse reason from:', content);
            }
            
            // Try to parse amount (for refund notifications)
            const amountMatch = content.match(/Số tiền: ([^|]+?)(?=\s*\|\s*Đơn hàng:)/);
            if (amountMatch) {
              amount = amountMatch[1].trim();
              console.log('✅ Parsed amount:', amount);
            } else {
              console.log('❌ Failed to parse amount from:', content);
            }
            
            // Try to parse order ID (for refund notifications)
            const orderMatch = content.match(/Đơn hàng: #(\d+)/);
            if (orderMatch) {
              orderId = orderMatch[1];
              console.log('✅ Parsed orderId:', orderId);
            } else {
              console.log('❌ Failed to parse orderId from:', content);
            }
            
            // Try to parse support type (for support notifications)
            const supportTypeMatch = content.match(/Loại hỗ trợ: ([^|]+?)(?=\s*\|\s*Mô tả:)/);
            if (supportTypeMatch) {
              const supportType = supportTypeMatch[1].trim();
              console.log('✅ Parsed support type:', supportType);
              // Add support type to the display if it's a support notification
              if (content.includes('Loại hỗ trợ:')) {
                reason += ' (' + supportType + ')';
              }
            }
          }
          
          notificationItem.innerHTML = `
            <div class="notification-title">${title}</div>
            <div class="notification-content">
              <div style="margin-bottom: 8px;">
                <strong>Người gửi:</strong> ${sender}
              </div>
              <div style="margin-bottom: 8px;">
                <strong>Lý do:</strong> ${reason}
              </div>
                          ${amount ? '<div style="margin-bottom: 8px;"><strong>Số tiền:</strong> ' + amount + '</div>' : ''}
            ${orderId ? '<div style="margin-bottom: 8px;"><strong>Đơn hàng:</strong> #' + orderId + '</div>' : ''}
            </div>
            <div class="notification-meta">
              <span class="notification-type">${type}</span>
              <span class="notification-time">${timeAgo}</span>
            </div>
            <div class="notification-details" style="font-size: 10px; color: rgba(255,255,255,0.4); margin-top: 4px;">
              ID: ${notificationId} | Priority: ${priority} ${relatedId ? '| Related ID: ' + relatedId : ''}
            </div>
          `;
          
          notificationItem.addEventListener('click', () => {
            markNotificationAsRead(notification.notificationID);
            notificationItem.classList.remove('unread');
            
            // Handle redirect based on notification type
            if (notification.notificationType === 'order') {
              if (notification.content && notification.content.includes('hoàn tiền')) {
                window.location.href = '${pageContext.request.contextPath}/admin/refund';
              } else {
                window.location.href = '${pageContext.request.contextPath}/AdminEventManagement.jsp';
              }
            }
          });
          
          notificationList.appendChild(notificationItem);
        });
      }

      // Add new notification to dropdown
      function addNotificationToDropdown(notification) {
        const notificationItem = document.createElement('div');
        notificationItem.className = 'notification-item unread';
        
        const timeAgo = formatTimeAgo(notification.createdAt);
        
        // Ensure we have proper content
        const title = notification.title || 'Không có tiêu đề';
        const content = notification.content || 'Không có nội dung';
        const type = notification.notificationType || 'system';
        const notificationId = notification.notificationID || 'N/A';
        const priority = notification.priority || 'normal';
        const relatedId = notification.relatedID || null;
        
        console.log(`📋 Adding new notification - Title: "${title}", Content: "${content}", Type: "${type}", ID: "${notificationId}", Priority: "${priority}", RelatedID: "${relatedId}"`);
        
        // Add more detailed logging
        if (!title || title === 'null' || title === 'undefined') {
          console.warn(`⚠️ New notification has invalid title:`, title);
        }
        if (!content || content === 'null' || content === 'undefined') {
          console.warn(`⚠️ New notification has invalid content:`, content);
        }
        
        // Parse content to extract sender and reason
        let sender = 'Không xác định';
        let reason = 'Không có lý do';
        let amount = '';
        let orderId = '';
        
        if (content && content !== 'null' && content !== 'undefined') {
          console.log('🔍 Parsing content for new notification:', content);
          
          // Parse content for sender and reason
          const senderMatch = content.match(/Người gửi: ([^|]+?)(?=\s*\|\s*Lý do:)/);
          if (senderMatch) {
            sender = senderMatch[1].trim();
            console.log('✅ Parsed sender for new notification:', sender);
          } else {
            console.log('❌ Failed to parse sender from new notification:', content);
          }
          
          const reasonMatch = content.match(/Lý do: ([^|]+?)(?=\s*\|\s*(?:Số tiền:|Loại hỗ trợ:|Đơn hàng:|Mô tả:))/);
          if (reasonMatch) {
            reason = reasonMatch[1].trim();
            console.log('✅ Parsed reason for new notification:', reason);
          } else {
            console.log('❌ Failed to parse reason from new notification:', content);
          }
          
          // Try to parse amount (for refund notifications)
          const amountMatch = content.match(/Số tiền: ([^|]+?)(?=\s*\|\s*Đơn hàng:)/);
          if (amountMatch) {
            amount = amountMatch[1].trim();
            console.log('✅ Parsed amount for new notification:', amount);
          } else {
            console.log('❌ Failed to parse amount from new notification:', content);
          }
          
          // Try to parse order ID (for refund notifications)
          const orderMatch = content.match(/Đơn hàng: #(\d+)/);
          if (orderMatch) {
            orderId = orderMatch[1];
            console.log('✅ Parsed orderId for new notification:', orderId);
          } else {
            console.log('❌ Failed to parse orderId from new notification:', content);
          }
          
          // Try to parse support type (for support notifications)
          const supportTypeMatch = content.match(/Loại hỗ trợ: ([^|]+?)(?=\s*\|\s*Mô tả:)/);
          if (supportTypeMatch) {
            const supportType = supportTypeMatch[1].trim();
            console.log('✅ Parsed support type for new notification:', supportType);
            // Add support type to the display if it's a support notification
            if (content.includes('Loại hỗ trợ:')) {
              reason += ' (' + supportType + ')';
            }
          }
        }
        
        notificationItem.innerHTML = `
          <div class="notification-title">${title}</div>
          <div class="notification-content">
            <div style="margin-bottom: 8px;">
              <strong>Người gửi:</strong> ${sender}
            </div>
            <div style="margin-bottom: 8px;">
              <strong>Lý do:</strong> ${reason}
            </div>
            ${amount ? '<div style="margin-bottom: 8px;"><strong>Số tiền:</strong> ' + amount + '</div>' : ''}
            ${orderId ? '<div style="margin-bottom: 8px;"><strong>Đơn hàng:</strong> #' + orderId + '</div>' : ''}
          </div>
          <div class="notification-meta">
            <span class="notification-type">${type}</span>
            <span class="notification-time">${timeAgo}</span>
          </div>
          <div class="notification-details" style="font-size: 10px; color: rgba(255,255,255,0.4); margin-top: 4px;">
            ID: ${notificationId} | Priority: ${priority} ${relatedId ? '| Related ID: ' + relatedId : ''}
          </div>
        `;
        
        notificationItem.addEventListener('click', () => {
          markNotificationAsRead(notification.notificationID);
          notificationItem.classList.remove('unread');
          
          if (notification.notificationType === 'order') {
            if (notification.content && notification.content.includes('hoàn tiền')) {
              window.location.href = '${pageContext.request.contextPath}/admin/refund';
            } else {
              window.location.href = '${pageContext.request.contextPath}/AdminEventManagement.jsp';
            }
          }
        });
        
        // Add to beginning of list
        const firstItem = notificationList.querySelector('.notification-item');
        if (firstItem) {
          notificationList.insertBefore(notificationItem, firstItem);
        } else {
          notificationList.appendChild(notificationItem);
        }
      }

      // Update notification badge
      function updateNotificationBadge(notifications) {
        const unreadCount = notifications.filter(n => !n.isIsRead).length;
        console.log('🔢 Updating badge count:', unreadCount, 'from', notifications.length, 'notifications');
        notificationBadge.textContent = unreadCount;
        if (unreadCount > 0) {
          notificationBadge.classList.add('show');
        } else {
          notificationBadge.classList.remove('show');
        }
      }

      // Update badge from WebSocket
      function updateNotificationBadgeFromWebSocket() {
        const currentCount = parseInt(notificationBadge.textContent || '0');
        const newCount = currentCount + 1;
        console.log('🔢 WebSocket badge update:', currentCount, '->', newCount);
        notificationBadge.textContent = newCount;
        notificationBadge.classList.add('show');
      }

      // Mark notification as read
      function markNotificationAsRead(notificationId) {
        console.log('📝 Marking notification as read:', notificationId);
        fetch('${pageContext.request.contextPath}/notification-servlet', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
          },
          body: `action=markRead&notificationId=${notificationId}&userId=1`
        })
        .then(response => response.json())
        .then(data => {
          if (data.message) {
            console.log('✅ Notification marked as read');
            // Reload notifications to update the badge count
            loadNotifications();
          } else {
            console.error('❌ Failed to mark notification as read:', data.error);
          }
        })
        .catch(error => {
          console.error('❌ Error marking notification as read:', error);
        });
      }

      // Mark all notifications as read
      markAllRead.addEventListener('click', function() {
        console.log('📝 Marking all notifications as read');
        fetch('${pageContext.request.contextPath}/notification-servlet', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
          },
          body: 'action=markAllRead&userId=1'
        })
        .then(response => response.json())
        .then(data => {
          if (data.message) {
            console.log('✅ All notifications marked as read');
            // Reload notifications to update the badge count
            loadNotifications();
          } else {
            console.error('❌ Failed to mark all notifications as read:', data.error);
          }
        })
        .catch(error => {
          console.error('❌ Error marking all notifications as read:', error);
        });
      });

      // Format time ago
      function formatTimeAgo(dateString) {
        if (!dateString) return 'Không xác định';
        
        try {
          const date = new Date(dateString);
          if (isNaN(date.getTime())) return 'Không xác định';
          
          const now = new Date();
          const diffInSeconds = Math.floor((now - date) / 1000);
          
          if (diffInSeconds < 60) {
            return 'Vừa xong';
          } else if (diffInSeconds < 3600) {
            const minutes = Math.floor(diffInSeconds / 60);
            return `${minutes} phút trước`;
          } else if (diffInSeconds < 86400) {
            const hours = Math.floor(diffInSeconds / 3600);
            return `${hours} giờ trước`;
          } else {
            const days = Math.floor(diffInSeconds / 86400);
            return `${days} ngày trước`;
          }
        } catch (e) {
          return 'Không xác định';
        }
      }

      // Initialize everything
      document.addEventListener('DOMContentLoaded', function() {
        console.log('Admin Dashboard page loaded successfully');
        
        // Initialize WebSocket
        initAdminNotificationWebSocket();
        
        // Load initial notifications
        loadNotifications();
        
        // Test notification object
        console.log('🧪 Testing notification object structure...');
        const testNotification = {
          notificationID: 1,
          userID: 1,
          title: "Test Title",
          content: "Test Content",
          notificationType: "order",
          isIsRead: false,
          isRead: false,
          createdAt: "2024-01-01T00:00:00"
        };
        console.log('🧪 Test notification:', testNotification);
        console.log('🧪 Test notification keys:', Object.keys(testNotification));
        
        // Test parsing function
        testParsing();

        // Test notification button
        testNotificationBtn.addEventListener('click', function() {
          console.log('🧪 Simulating WebSocket notification...');
          
          // First, let's load the actual notifications and see what we get
          fetch('${pageContext.request.contextPath}/admin-notifications')
            .then(response => response.json())
            .then(data => {
              console.log('📋 Actual notifications loaded:', data);
              
              if (Array.isArray(data) && data.length > 0) {
                console.log('📋 First notification content:', data[0].content);
                console.log('📋 First notification title:', data[0].title);
                console.log('📋 First notification type:', data[0].notificationType);
                console.log('📋 First notification isRead:', data[0].isIsRead);
                
                // Test parsing the first notification
                const firstNotification = data[0];
                if (firstNotification.content) {
                  console.log('🧪 Testing parsing for first notification...');
                  const content = firstNotification.content;
                  console.log('🧪 Raw content:', content);
                  
                  const senderMatch = content.match(/Người gửi: ([^|]+?)(?=\s*\|\s*Lý do:)/);
                  if (senderMatch) {
                    console.log('✅ Sender parsed:', senderMatch[1].trim());
                  } else {
                    console.log('❌ Failed to parse sender from:', content);
                  }
                  
                  const reasonMatch = content.match(/Lý do: ([^|]+?)(?=\s*\|\s*(?:Số tiền:|Loại hỗ trợ:|Đơn hàng:|Mô tả:))/);
                  if (reasonMatch) {
                    console.log('✅ Reason parsed:', reasonMatch[1].trim());
                  } else {
                    console.log('❌ Failed to parse reason from:', content);
                  }
                }
              }
            })
            .catch(error => {
              console.error('❌ Error loading notifications:', error);
            });
          
          const newNotification = {
            notificationID: Date.now(), // Unique ID
            userID: 1, // Admin ID
            title: "Test Notification",
            content: "This is a test notification content. It can be a refund request, support request, or any other type. It should be parsed correctly.",
            notificationType: "test", // Custom type for testing
            isIsRead: false,
            isRead: false,
            createdAt: new Date().toISOString()
          };
          console.log('🧪 New notification to add:', newNotification);
          addNotificationToDropdown(newNotification);
          updateNotificationBadgeFromWebSocket(); // Update badge from WebSocket
        });

        // Test parsing button
        testParsingBtn.addEventListener('click', function() {
          console.log('🧪 Simulating parsing test...');
          testParsing();
          
          // Also test with the exact content that should be generated
          console.log('🧪 Testing with exact content format...');
          const testContent = "Người gửi: DEBUG User (ID: 999) | Lý do: This is a debug test | Số tiền: 999,999 VNĐ | Đơn hàng: #999";
          console.log('🧪 Test content:', testContent);
          
          const senderMatch = testContent.match(/Người gửi: ([^|]+?)(?=\s*\|\s*Lý do:)/);
          if (senderMatch) {
            console.log('✅ Test sender parsed:', senderMatch[1].trim());
          } else {
            console.log('❌ Test failed to parse sender');
          }
          
          const reasonMatch = testContent.match(/Lý do: ([^|]+?)(?=\s*\|\s*(?:Số tiền:|Loại hỗ trợ:|Đơn hàng:|Mô tả:))/);
          if (reasonMatch) {
            console.log('✅ Test reason parsed:', reasonMatch[1].trim());
          } else {
            console.log('❌ Test failed to parse reason');
          }
          
          const amountMatch = testContent.match(/Số tiền: ([^|]+?)(?=\s*\|\s*Đơn hàng:)/);
          if (amountMatch) {
            console.log('✅ Test amount parsed:', amountMatch[1].trim());
          } else {
            console.log('❌ Test failed to parse amount');
          }
          
          const orderMatch = testContent.match(/Đơn hàng: #(\d+)/);
          if (orderMatch) {
            console.log('✅ Test order ID parsed:', orderMatch[1]);
          } else {
            console.log('❌ Test failed to parse order ID');
          }
          
          alert('Parsing test completed. Check console for results.');
        });
      });
     </script>
   </body>
 </html>