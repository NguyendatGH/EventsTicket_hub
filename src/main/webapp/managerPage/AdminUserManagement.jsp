<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib uri="http://java.sun.com/jsp/jstl/core"
prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>MasterTicket Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/asset/css/AdminUserManagement.css"/>
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
                  <a href="${pageContext.request.contextPath}/">
                    <img
                      src="${pageContext.request.contextPath}/asset/image/Lock_duotone_line.svg"
                      alt="Lock"
                  /></a>
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
    </script>
  </body>
</html>
