<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>MasterTicket Admin - Doanh Thu Chủ Sự Kiện</title>
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
      .content-grid {
        display: grid;
        grid-template-columns: 1fr 2fr;
        gap: 30px;
      }
      .profile-section,
      .chart-section,
      .table-section,
      .stats-section {
        background: rgba(255, 255, 255, 0.18);
        border-radius: 12px;
        padding: 2rem;
        backdrop-filter: blur(20px);
        border: 1px solid rgba(255, 255, 255, 0.1);
        display: flex;
        flex-direction: column;
      }
      .profile-section {
        height: 300px;
      }
      .chart-section {
        height: 400px;
      }
      .table-section {
        height: 450px;
      }
      .stats-section {
        height: 300px;
      }
      .section-title {
        color: white;
        font-size: 1.25rem;
        font-weight: 600;
        margin-bottom: 1rem;
      }
      .profile-container {
        flex: 1;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        text-align: center;
      }
      .profile-avatar {
        width: 80px;
        height: 80px;
        background: rgba(255, 255, 255, 0.08);
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        margin-bottom: 1rem;
        box-shadow: var(--shadow);
      }
      .profile-avatar svg {
        width: 50px;
        height: 50px;
        color: var(--text-secondary);
      }
      .profile-name {
        color: var(--text-primary);
        font-size: 1.2rem;
        font-weight: 600;
        margin-bottom: 0.5rem;
      }
      .profile-email,
      .profile-role {
        color: var(--text-secondary);
        font-size: 0.9rem;
        margin-bottom: 0.5rem;
      }
      .chart-container {
        flex: 1;
        position: relative;
        height: 300px;
        max-height: 300px;
      }
      #revenueChart {
        background: rgba(0, 0, 0, 0.1);
        border-radius: 8px;
        width: 100% !important;
        height: 100% !important;
      }
      .table-container {
        height: 350px;
        max-height: 350px;
        overflow-x: auto;
        overflow-y: auto;
      }
      .stats-container {
        flex: 1;
        display: grid;
        grid-template-columns: repeat(2, 1fr);
        gap: 1rem;
      }
      .stat-item {
        background: rgba(255, 255, 255, 0.08);
        border-radius: 8px;
        padding: 1rem;
        text-align: center;
      }
      .stat-label {
        color: var(--text-secondary);
        font-size: 0.875rem;
        margin-bottom: 0.5rem;
      }
      .stat-value {
        color: var(--text-primary);
        font-size: 1.2rem;
        font-weight: 600;
      }
      table {
        width: 100%;
        border-collapse: collapse;
        color: white;
      }
      .table-header {
        background-color: #00adff33;
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
      .no-data {
        color: #94a3b8;
        text-align: center;
        padding: 2rem;
        font-size: 1.1rem;
      }
      .owner-filter {
        display: flex;
        gap: 1rem;
        align-items: center;
        margin-bottom: 1rem;
      }
      .owner-filter input,
      .owner-filter select {
        padding: 0.5rem;
        border: 1px solid var(--border-light);
        border-radius: 4px;
        background: rgba(255, 255, 255, 0.08);
        color: var(--text-primary);
        font-size: 0.875rem;
      }
      .owner-filter button {
        padding: 0.5rem 1rem;
        border: none;
        border-radius: 4px;
        background: #0f67ff;
        color: var(--text-primary);
        font-weight: 500;
        cursor: pointer;
        transition: background 0.3s ease;
      }
      .owner-filter button:hover {
        background: #0a4cb2;
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
        .profile-section,
        .chart-section,
        .table-section,
        .stats-section {
          height: 350px;
        }
        .chart-container,
        .table-container {
          height: 250px;
          max-height: 250px;
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
        .profile-section,
        .chart-section,
        .table-section,
        .stats-section {
          height: 300px;
        }
        .chart-container,
        .table-container {
          height: 200px;
          max-height: 200px;
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
        .owner-filter {
          flex-direction: column;
          align-items: flex-start;
        }
      }
      @keyframes float {
        0% { transform: translateY(0); }
        50% { transform: translateY(-20px); }
        100% { transform: translateY(0); }
      }
      .sm{
        width: 120px;
        height:120px;
        border-radius: 50%;
      }
      .otp{
        background-color: transparent;
        color: white;
      }
    </style>
  </head>
  <body>
    <img class="bg_elips firstElement" src="${pageContext.request.contextPath}/asset/image/full.svg" alt="Background Ellipse 1" />
    <img class="bg_elips secondElement" src="${pageContext.request.contextPath}/asset/image/full2.svg" alt="Background Ellipse 2" />
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
              <path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z" />
            </svg>
          </div>
          <div class="admin-name">Admin</div>
          <div class="admin-role">Quản lý website</div>
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
              <a href="${pageContext.request.contextPath}/admin-servlet/user-management" class="nav-link">Danh sách tài khoản</a>
            </li>
            <li class="nav-item">
              <a href="${pageContext.request.contextPath}/admin-servlet/transaction-management" class="nav-link">Danh sách giao dịch</a>
            </li>
            <li class="nav-item">
              <a href="${pageContext.request.contextPath}/admin-servlet/owner-revenue" class="nav-link active">Doanh thu chủ sự kiện</a>
            </li>
            <li class="nav-item">
              <a href="${pageContext.request.contextPath}/admin/refund" class="nav-link">Quản lý hoàn tiền</a>
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
        <header class="header">
          <h1 class="page-title">Doanh Thu Chủ Sự Kiện</h1>
          <div class="control-panel">Tổng quan doanh thu</div>
        </header>
        <section>
          <div class="owner-filter">
            <input type="email" id="ownerEmail" name="ownerEmail" placeholder="Nhập email chủ sự kiện" value="${ownerEmail != null ? ownerEmail : ''}" />
            <select id="timePeriod" name="timePeriod">
              <option class="opt" value="all" ${timePeriod == 'all' ? 'selected' : ''}>Toàn thời gian</option>
              <option  class="opt" value="monthly" ${timePeriod == 'monthly' ? 'selected' : ''}>Theo tháng</option>
              <option   class="opt" value="yearly" ${timePeriod == 'yearly' ? 'selected' : ''}>Theo năm</option>
            </select>
            <button onclick="filterOwnerRevenue()">Lọc</button>
          </div>
          <c:choose>
            <c:when test="${ownerNotFound}">
              <div class="no-data">Không tìm thấy chủ sự kiện với email này</div>
            </c:when>
            <c:otherwise>
              <div class="content-grid">
                <div class="profile-section">
                  <h2 class="section-title">Hồ sơ chủ sự kiện</h2>
                  <div class="profile-container">
                    <c:choose>
                      <c:when test="${not empty ownerProfile}">
                        <div class="profile-avatar">
                          <img  class="profile-avatar sm" src="${pageContext.request.contextPath}/uploads/user_avatar/${ownerProfile.avatar}"/>
                        </div>
                        <div class="profile-name">${ownerProfile.name}</div>
                        <div class="profile-email">${ownerProfile.email}</div>
                        <div class="profile-role">Chủ sự kiện</div>
                      </c:when>
                      <c:otherwise>
                        <div class="no-data">Không có thông tin hồ sơ</div>
                      </c:otherwise>
                    </c:choose>
                  </div>
                </div>
                <div class="stats-section">
                  <h2 class="section-title">Thống kê</h2>
                  <div class="stats-container">
                    <div class="stat-item">
                      <div class="stat-label">Tổng doanh thu</div>
                      <div class="stat-value"><fmt:formatNumber value="${totalRevenue}" type="currency" currencyCode="VND" /></div>
                    </div>
                    <div class="stat-item">
                      <div class="stat-label">Số sự kiện</div>
                      <div class="stat-value">${eventCount}</div>
                    </div>
                    <div class="stat-item">
                      <div class="stat-label">Tổng vé bán</div>
                      <div class="stat-value">${totalTicketsSold}</div>
                    </div>
                    <div class="stat-item">
                      <div class="stat-label">Số đơn hàng</div>
                      <div class="stat-value">${orderCount}</div>
                    </div>
                  </div>
                </div>
                <div class="chart-section">
                  <h2 class="section-title">Doanh thu theo thời gian</h2>
                  <div class="chart-container">
                    <c:choose>
                      <c:when test="${not empty revenueData}">
                        <canvas id="revenueChart"></canvas>
                      </c:when>
                      <c:otherwise>
                        <div class="no-data">Không có dữ liệu doanh thu</div>
                      </c:otherwise>
                    </c:choose>
                  </div>
                </div>
                <div class="table-section">
                  <h2 class="section-title">Chi tiết doanh thu</h2>
                  <div class="table-container">
                    <c:choose>
                      <c:when test="${not empty ownerRevenues}">
                        <table>
                          <thead class="table-header">
                            <tr>
                              <th>Chủ sự kiện</th>
                              <c:choose>
                                <c:when test="${timePeriod == 'monthly' || timePeriod == 'yearly'}">
                                  <th>Thời kỳ</th>
                                </c:when>
                                <c:otherwise>
                                  <th>Sự kiện</th>
                                  <th>Thời gian bắt đầu</th>
                                  <th>Thời gian kết thúc</th>
                                </c:otherwise>
                              </c:choose>
                              <th>Số đơn hàng</th>
                              <th>Tổng vé bán</th>
                              <th>Doanh thu</th>
                            </tr>
                          </thead>
                          <tbody>
                            <c:forEach var="revenue" items="${ownerRevenues}">
                              <tr>
                                <td>${revenue.ownerName}</td>
                                <c:choose>
                                  <c:when test="${timePeriod == 'monthly' || timePeriod == 'yearly'}">
                                    <td>${revenue.revenuePeriod}</td>
                                  </c:when>
                                  <c:otherwise>
                                    <td>${revenue.eventName}</td>
                                    <td>
                                      <c:choose>
                                        <c:when test="${not empty revenue.startTime}">
                                          <fmt:formatDate value="${revenue.startTime}" pattern="dd/MM/yyyy HH:mm" />
                                        </c:when>
                                        <c:otherwise>N/A</c:otherwise>
                                      </c:choose>
                                    </td>
                                    <td>
                                      <c:choose>
                                        <c:when test="${not empty revenue.endTime}">
                                          <fmt:formatDate value="${revenue.endTime}" pattern="dd/MM/yyyy HH:mm" />
                                        </c:when>
                                        <c:otherwise>N/A</c:otherwise>
                                      </c:choose>
                                    </td>
                                  </c:otherwise>
                                </c:choose>
                                <td>${revenue.orderCount}</td>
                                <td>${revenue.totalTicketsSold}</td>
                                <td>
                                  <fmt:formatNumber value="${revenue.eventRevenue}" type="currency" currencyCode="VND" />
                                </td>
                              </tr>
                            </c:forEach>
                          </tbody>
                        </table>
                      </c:when>
                      <c:otherwise>
                        <div class="no-data">Không có dữ liệu doanh thu</div>
                      </c:otherwise>
                    </c:choose>
                  </div>
                </div>
              </div>
            </c:otherwise>
          </c:choose>
        </section>
      </main>
    </div>
    <script>
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

      function filterOwnerRevenue() {
        const ownerEmail = document.getElementById("ownerEmail").value;
        const timePeriod = document.getElementById("timePeriod").value;
        if (ownerEmail) {
          window.location.href = "${pageContext.request.contextPath}/admin-servlet/owner-revenue?ownerEmail=" + 
            encodeURIComponent(ownerEmail) + "&timePeriod=" + timePeriod;
        }
      }

      <c:if test="${not empty revenueData}">
        const revenueData = {
          labels: [
            <c:forEach var="entry" items="${revenueData}" varStatus="loop">
              "${entry.key}"${loop.last ? '' : ','}
            </c:forEach>
          ],
          datasets: [
            {
              label: "Doanh thu (VNĐ)",
              data: [
                <c:forEach var="entry" items="${revenueData}" varStatus="loop">
                  ${entry.value}${loop.last ? '' : ','}
                </c:forEach>
              ],
              borderColor: "rgba(59, 130, 246, 1)",
              backgroundColor: "rgba(59, 130, 246, 0.1)",
              borderWidth: 2,
              fill: true,
              tension: 0.4
            }
          ]
        };

        const config = {
          type: "line",
          data: revenueData,
          options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
              legend: {
                labels: {
                  color: "#e2e8f0",
                  font: { size: 12 }
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
                grid: { color: "rgba(255, 255, 255, 0.1)" },
                ticks: {
                  color: "#94a3b8",
                  callback: function(value) {
                    return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND', notation: 'compact' }).format(value);
                  }
                }
              },
              x: {
                grid: { color: "rgba(255, 255, 255, 0.1)" },
                ticks: { color: "#94a3b8" }
              }
            }
          }
        };

        const ctx = document.getElementById("revenueChart").getContext("2d");
        const revenueChart = new Chart(ctx, config);
      </c:if>
    </script>
  </body>
</html>