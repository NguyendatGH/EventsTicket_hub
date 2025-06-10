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
        min-height: 100vh;
        overflow: hidden;
        position: relative;
        background-color: #070a17;
      }

      .container {
        display: flex;
        height: 100vh;
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

      .header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 2rem;
      }

      .page-title {
        color: white;
        font-size: 2rem;
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
        width: 30%;
      }

      .search-box {
        width: 100%;
        padding: 15px 50px 15px 20px;
        background: rgba(255, 255, 255, 0.1);
        border: 1px solid rgba(255, 255, 255, 0.2);
        border-radius: 10px;
        color: white;
        font-size: 16px;
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

      /* Table */
      .data-table {
        background: #1b1c21;
        border-radius: 15px;
        overflow: hidden;
        border: 1px solid rgba(255, 255, 255, 0.1);
      }

      .table-header {
        display: flex;
        align-items: center;
        padding: 20px;
        gap: 10%;
        background: rgba(21, 0, 97, 0.78);
        border-bottom: 1px solid rgba(255, 255, 255, 0.1);
      }

      .table-header .page-title {
        font-size: 24px;
        font-weight: 600;
        color: #fff;
        margin: 0;
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

      /* Responsive */
      @media (max-width: 768px) {
        .container {
          flex-direction: column;
        }

        .sidebar {
          width: 100%;
          height: auto;
        }

        .table-columns,
        .table-row {
          grid-template-columns: 1fr;
          gap: 10px;
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
    </style>
  </head>
  <body>
    <img
      class="bg_elips firstElement"
      src="${pageContext.request.contextPath}/asset/full.svg"
    />
    <img
      class="bg_elips secondElement"
      src="${pageContext.request.contextPath}/asset/full2.svg"
    />
    <div class="container">
      <!-- Sidebar -->
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
                href="${pageContext.request.contextPath}/admin-servlet?action=adminDashboard"
                class="nav-link"
                >Bảng điều khiển</a
              >
            </li>
            <li class="nav-item">
              <a
                href="${pageContext.request.contextPath}/admin-servlet?action=manageEvents"
                class="nav-link"
                >Danh sách sự kiện</a
              >
            </li>
            <li class="nav-item">
              <a
                href="${pageContext.request.contextPath}/admin-servlet?action=manageUserAccount"
                class="nav-link active"
                >Danh sách tài khoản</a
              >
            </li>
            <li class="nav-item">
              <a
                href="${pageContext.request.contextPath}/admin-servlet?action=supportCenter"
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
            <div></div>
            <div>Vai trò</div>
            <div>Email</div>
            <div>Số di động</div>
            <div>Ngày tạo tài khoản</div>
            <div></div>
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
                  <img
                    src="${pageContext.request.contextPath}/asset/Lock_duotone_line.svg"
                    alt="Lock"
                  />
                </button>
                <button class="action-btn edit-btn">
                  <img
                    src="${pageContext.request.contextPath}/asset/Edit_fill.svg"
                    alt="Edit"
                  />
                </button>
                <button class="action-btn delete-btn">
                  <img
                    src="${pageContext.request.contextPath}/asset/Trash.svg"
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
    <script>
      // Navigation active state
      document.querySelectorAll(".nav-item").forEach((item) => {
        item.addEventListener("click", function () {
          document
            .querySelectorAll(".nav-item")
            .forEach((nav) => nav.classList.remove("active"));
          this.classList.add("active");
        });
      });
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
              // Gửi yêu cầu đến server (như ở bước 3)
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
            const username = row.children[1].textContent.toLowerCase();
            const email = row.children[2].textContent.toLowerCase();
            const phoneNum = row.children[3].textContent.toLowerCase();

            if (
              username.includes(searchTerm) ||
              email.includes(searchTerm) ||
              phoneNum.includes(searchTerm)
            ) {
              row.style.display = "grid";
            } else {
              row.style.display = "none";
            }
          });
        });
    </script>
  </body>
</html>
