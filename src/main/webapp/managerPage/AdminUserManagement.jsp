<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib uri="http://java.sun.com/jsp/jstl/core"
prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>MasterTicket Admin</title>
    <style>
      * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
      }

      body {
        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto,
          sans-serif;
        position: relative;
        background-color: #070a17;
        overflow-x: hidden;
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
        position: fixed;
        bottom: 2rem;
        left: 2rem;
        right: auto;
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

      .search-container {
        position: relative;
        width: 100%;
        max-width: 300px;
        justify-self: end;
      }

      .search-box {
        width: 100%;
        padding: 8px 50px 8px 20px;
        background: rgba(255, 255, 255, 0.1);
        border: 1px solid rgba(255, 255, 255, 0.2);
        border-radius: 10px;
        color: white;
        font-size: 14px;
        outline: none;
        transition: all 0.3s ease;
      }

      .search-box:focus {
        background: rgba(255, 255, 255, 0.15);
        border-color: rgba(100, 150, 255, 0.5);
      }

      .search-box::placeholder {
        color: rgba(255, 255, 255, 0.6);
      }

      .search-icon {
        position: absolute;
        right: 15px;
        top: 50%;
        transform: translateY(-50%);
        color: rgba(255, 255, 255, 0.6);
      }

      .data-table {
        background: #1b1c21;
        border-radius: 15px;
        overflow: hidden;
        border: 1px solid rgba(255, 255, 255, 0.1);
      }

      .table-header {
        display: grid;
        grid-template-columns: 1fr auto;
        gap: 20px;
        align-items: center;
        background: rgba(21, 0, 97, 0.78);
        padding: 20px;
      }

      .table-columns {
        display: grid;
        grid-template-columns: 50px 1fr 1fr 1fr 1fr 120px;
        gap: 20px;
        padding: 10px;
        background: rgba(87, 87, 87, 0.34);
        border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        color: white;
      }

      .table-row {
        display: grid;
        grid-template-columns: 50px 1fr 1fr 1fr 1fr 120px;
        gap: 20px;
        padding: 20px;
        border-bottom: 1px solid #3e3e3e;
        transition: all 0.3s ease;
        align-items: center;
        color: white;
      }

      .table-row:hover {
        background: rgba(255, 255, 255, 0.1);
      }

      .table-row:last-child {
        border-bottom: none;
      }

      .email-link {
        color: #64b5f6;
        text-decoration: underline;
      }

      .phoneNum-field {
        display: flex;
        align-items: center;
        gap: 10px;
      }

      .phoneNum-detail {
        color: rgba(255, 255, 255, 0.7);
      }

      .actions {
        display: flex;
        gap: 10px;
      }

      .action-btn {
        width: 35px;
        height: 35px;
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
      }

      .edit-btn {
        background: rgba(40, 167, 69, 0.2);
        color: #28a745;
      }

      .edit-btn:hover {
        background: rgba(40, 167, 69, 0.3);
      }

      .delete-btn {
        background: rgba(220, 53, 69, 0.2);
        color: #dc3545;
      }

      .delete-btn:hover {
        background: rgba(220, 53, 69, 0.3);
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

      .charts-container {
        display: flex;
        gap: 2rem;
        margin-bottom: 2rem;
      }

      .chart-wrapper {
        background: #1b1c21;
        border-radius: 15px;
        padding: 20px;
        object-fit: cover;
        border: 1px solid rgba(255, 255, 255, 0.1);
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
        color: white;
        margin-bottom: 1rem;
        font-size: 1.2rem;
        text-align: center;
      }

      .chart-wrapper {
        height: 300px;
        padding: 20px;
      }

      .chart-wrapper canvas {
        max-height: 250px !important;
      }

      .chart-wrapper {
        overflow: hidden;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
      }

      @media (max-width: 1400px) {
        .main-content {
          padding: 0 50px;
        }
      }

      @media (max-width: 1200px) {
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
        .hamburger {
          display: flex;
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
        .control-panel {
          margin-top: 30px;
        }

        .search-container {
          max-width: 100%;
          justify-self: center;
        }

        .bg_elips {
          width: 500px;
          height: 500px;
        }

        .table-columns,
        .table-row {
          grid-template-columns: 50px 1fr 1fr 120px;
          gap: 10px;
        }

        .table-columns div:nth-child(4),
        .table-row div:nth-child(4) {
          display: none;
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
        .logout {
          left: 1rem;
          bottom: 1rem;
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

        .table-columns,
        .table-row {
          grid-template-columns: 1fr 1fr;
          gap: 10px;
          padding: 15px;
        }

        .table-columns div:nth-child(1),
        .table-row div:nth-child(1),
        .table-columns div:nth-child(5),
        .table-row div:nth-child(5) {
          display: none;
        }

        .search-box {
          padding: 6px 40px 6px 15px;
          font-size: 12px;
        }

        .search-icon {
          right: 10px;
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

        .table-columns,
        .table-row {
          grid-template-columns: 1fr;
          gap: 8px;
          padding: 10px;
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
          width: 30px;
          height: 30px;
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
          padding: 0.5rem 0.75rem;
          font-size: 0.875rem;
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
          <div class="admin-role">Quản lí website masterTicket</div>
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
                class="nav-link"
                >Danh sách sự kiện</a
              >
            </li>
            <li class="nav-item">
              <a
                href="${pageContext.request.contextPath}/admin-servlet/user-management"
                class="nav-link active"
                >Danh sách tài khoản</a
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
            <path
              d="M20 3h-9c-1.103 0-2 .897-2 2v4h2V5h9v14h-9v-4H9v4c0 1.103.897 2 2 2h9c1.103 0 2-.897 2-2V5c0-1.103-.897-2-2-2z"
            />
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
        <div class="data-table">
          <div class="table-header">
            <div class="page-title">Danh sách người dùng</div>
            <div class="search-container">
              <input
                type="text"
                class="search-box"
                placeholder="Bạn muốn tìm gì?"
              />
              <div class="search-icon">🔍</div>
            </div>
          </div>
          <div class="table-columns">
            <div>#</div>
            <div>Vai trò</div>
            <div>Email</div>
            <div>Số di động</div>
            <div>Ngày tạo tài khoản</div>
            <div>Hành động</div>
          </div>

          <c:forEach var="user" items="${users}" varStatus="status">
            <div class="table-row">
              <div>${status.count}</div>
              <div><c:out value="${user.role}" /></div>
              <div>
                <a href="mailto:${user.email}" class="email-link"
                  ><c:out value="${user.email}"
                /></a>
              </div>
              <div class="phoneNum-field">
                <span class="phoneNum-detail">${user.phoneNumber}</span>
              </div>
              <div><c:out value="${user.createdAt}" /></div>
              <div class="actions">
                <button class="action-btn lock-btn">
                  <a href="${pageContext.request.contextPath}/">
                    <img
                      src="${pageContext.request.contextPath}/asset/image/Lock_duotone_line.svg"
                      alt="Lock"
                    />
                  </a>
                </button>
                <button class="action-btn edit-btn">
                  <img
                    src="${pageContext.request.contextPath}/asset/image/Edit_fill.svg"
                    alt="Edit"
                  />
                </button>
                <button class="action-btn delete-btn">
                  <img
                    src="${pageContext.request.contextPath}/asset/image/Trash.svg"
                    alt="Delete"
                  />
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

      // Navigation active state
      document.querySelectorAll(".nav-item").forEach((item) => {
        item.addEventListener("click", function () {
          document
            .querySelectorAll(".nav-item")
            .forEach((nav) => nav.classList.remove("active"));
          this.classList.add("active");
        });
      });

      // Action buttons with SweetAlert
      document.querySelectorAll(".action-btn").forEach((btn) => {
        btn.addEventListener("click", function () {
          const action = this.classList.contains("lock-btn")
            ? "Khóa"
            : this.classList.contains("edit-btn")
            ? "Chỉnh sửa"
            : this.classList.contains("delete-btn")
            ? "Xóa"
            : "Không xác định";
          const row = this.closest(".table-row");
          const email = row.children[2].textContent;
          Swal.fire({
            title: `Xác nhận ${action}`,
            text: `Bạn có chắc muốn ${action.toLowerCase()} người dùng "${email}"?`,
            icon: "warning",
            showCancelButton: true,
            confirmButtonText: "Có",
            cancelButtonText: "Hủy",
          }).then((result) => {
            if (result.isConfirmed) {
              Swal.fire(`${action} thành công!`, "", "success");
            }
          });
        });
      });

      // Search functionality
      document
        .querySelector(".search-box")
        .addEventListener("input", function () {
          const searchTerm = this.value.toLowerCase();
          const rows = document.querySelectorAll(".table-row");

          rows.forEach((row) => {
            const role = row.children[1].textContent.toLowerCase();
            const email = row.children[2].textContent.toLowerCase();
            const phoneNum = row.children[3].textContent.toLowerCase();

            if (
              role.includes(searchTerm) ||
              email.includes(searchTerm) ||
              phoneNum.includes(searchTerm)
            ) {
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

      animateEllipses();

      // Parse JSON data

      var roleDistributionJson =
        '<%= request.getAttribute("roleDistributionJson") %>';
      var loginDistributionByMonthJson =
        '<%= request.getAttribute("loginDistributionByMonthJson") %>';

      let roleDistribution = {};
      let loginDistributionByMonth = {};

      try {
        roleDistribution = JSON.parse(
          roleDistributionJson.replace(/&quot;/g, '"').trim() || "{}"
        );
        loginDistributionByMonth = JSON.parse(
          loginDistributionByMonthJson.replace(/"/g, '"').trim() || "{}"
        );
      } catch (e) {
        console.error("Failed to parse JSON data:", e);
        roleDistribution = {};
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
            datasets: [
              {
                data: Object.values(roleDistribution),
                backgroundColor: Object.keys(roleDistribution).map(
                  (_, index) =>
                    [
                      chartColors.success,
                      chartColors.warning,
                      chartColors.danger,
                      chartColors.info,
                    ][index % 4]
                ),
                borderColor: "#1b1c21",
                borderWidth: 2,
              },
            ],
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
        // Tạo danh sách 12 tháng gần nhất
        const currentDate = new Date();
        const months = [];
        const monthLabels = [];

        for (let i = 11; i >= 0; i--) {
          const date = new Date(
            currentDate.getFullYear(),
            currentDate.getMonth() - i,
            1
          );
          const monthKey = date.toISOString().slice(0, 7); // Format: yyyy-MM
          const monthLabel = date.toLocaleDateString("vi-VN", {
            month: "short",
            year: "numeric",
          });
          months.push(monthKey);
          monthLabels.push(monthLabel);
        }

        const newData = months.map(
          (month) => loginDistributionByMonth.new[month] || 0
        );
        const oldData = months.map(
          (month) => loginDistributionByMonth.old[month] || 0
        );

        const loginMonthChart = new Chart(
          document.getElementById("loginMonthChart"),
          {
            type: "bar",
            data: {
              labels: monthLabels, // Sử dụng nhãn tháng thân thiện
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
                  ticks: {
                    color: "white",
                    maxRotation: 45,
                    minRotation: 45,
                  },
                  grid: { color: "rgba(255, 255, 255, 0.1)" },
                },
              },
            },
          }
        );
      }
    </script>
  </body>
</html>
