<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib uri="http://java.sun.com/jsp/jstl/core"
prefix="c" %> <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/asset/css/AdminEventManagement.css"
    />
    <title>MasterTicket Admin</title>
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
      <div class="main-content">
        <header class="header">
          <div class="control-panel">Danh sách sự kiện</div>
        </header>
        <div class="dashboard-container">
          <h2 class="table-header">Bảng xếp hạng</h2>
          <div class="table-section">
            <div class="table-container">
              <table>
                <thead>
                  <tr class="table_head">
                    <th>Tên tổ chức</th>
                    <th>Số sự kiện</th>
                    <th>Vé đã bán</th>
                    <th>Trạng thái</th>
                  </tr>
                </thead>
                <tbody>
                  <c:choose>
                    <c:when test="${not empty topOrganizers}">
                      <c:forEach
                        var="organizer"
                        items="${topOrganizers}"
                        varStatus="status"
                      >
                        <tr class="${status.first ? 'active' : ''}">
                          <td class="td_head">
                            <c:out value="${organizer.name}" />
                          </td>
                          <td><c:out value="${organizer.numsOfEvent}" /></td>
                          <td>
                            <c:out value="${organizer.numsOfTicketSelled}" />
                          </td>
                          <td>
                            <button class="status-tag">
                              <c:choose>
                                <c:when test="${organizer.status}">Khóa</c:when>
                                <c:otherwise>Đang hoạt động</c:otherwise>
                              </c:choose>
                            </button>
                          </td>
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
            <div class="stat-item">
              <div class="stat-wrapper">
                <div class="stat-header">
                  <c:choose>
                    <c:when test="${not empty topOrganizers}">
                      <h1>1st</h1>
                      <span class="stat-title"
                        ><c:out value="${topOrganizers[0].name}"
                      /></span>
                    </c:when>
                    <c:otherwise>
                      <h1>1st</h1>
                      <span class="stat-title">Không có tổ chức</span>
                    </c:otherwise>
                  </c:choose>
                </div>
                <span class="stat-content">
                  <img src="<c:choose
                    ><c:when
                      test="${not empty topOrganizers and not empty topOrganizers[0].avatarURL}"
                      >${pageContext.request.contextPath}/${topOrganizers[0].avatarURL}</c:when
                    ><c:otherwise
                      >${pageContext.request.contextPath}/asset/image/MayLangThangAvt.svg</c:otherwise
                    ></c:choose
                  >" class="Top-EventOwner" alt="Top Organizer"
                  onerror="this.src='${pageContext.request.contextPath}/asset/image/MayLangThangAvt.svg'"
                  />
                </span>
              </div>
            </div>
          </div>
        </div>
        <div class="data-table">
          <div class="table-header-secondary">
            <div class="page-title">Recent Events</div>
            <div class="search-container">
              <input
                type="text"
                class="search-box"
                placeholder="What are you looking for?"
              />
              <div class="search-icon">🔍</div>
            </div>
          </div>
          <c:if test="${empty events}">
            <p style="color: white; padding: 20px">No events found.</p>
          </c:if>
          <c:forEach var="event" items="${events}" varStatus="status">
            <div class="table-row">
              <div>${status.count}</div>
              <div>${event.name}</div>
              <div class="date">
                <fmt:formatDate
                  value="${event.startTime}"
                  pattern="dd/MM/yyyy"
                />
                -
                <fmt:formatDate value="${event.endTime}" pattern="dd/MM/yyyy" />
              </div>
              <div>
                <div
                  class="event-status ${event.status == 'active' ? 'success' : event.status == 'pending' ? 'warning' : 'error'}"
                >
                  ${event.status == 'active' ? 'Đang hoạt động' : event.status
                  == 'pending' ? 'Đang chờ duyệt' : 'Đã dừng'}
                </div>
              </div>
              <div class="actions">
                <button
                  class="action-btn edit-btn"
                  onclick="handleEditEvent(${event.eventID})"
                >
                  <img
                    src="${pageContext.request.contextPath}/asset/image/Edit_fill.svg"
                    alt="Edit"
                  />
                </button>
                <button
                  class="action-btn delete-btn"
                  onclick="handleDeleteEvent(${event.eventID})"
                >
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
      document
        .querySelector(".search-box")
        .addEventListener("input", function () {
          const searchTerm = this.value.toLowerCase();
          const rows = document.querySelectorAll(".table-row");
          rows.forEach((row) => {
            const eventName = row.children[1].textContent.toLowerCase();
            const date = row.children[2].textContent.toLowerCase();
            if (eventName.includes(searchTerm) || date.includes(searchTerm)) {
              row.style.display = "grid";
            } else {
              row.style.display = "none";
            }
          });
        });

      function handleEditEvent(eventID) {
        console.log("Redirecting to edit event:", eventID);
        window.location.href =
          "${pageContext.request.contextPath}/admin-servlet/event-management/event-detail?actio=?eventID=" +
          eventID;
      }

      function handleDeleteEvent(eventID) {
        Swal.fire({
          title: "Xác nhận xóa",
          text: "Bạn có chắc muốn xóa sự kiện này?",
          icon: "warning",
          showCancelButton: true,
          confirmButtonText: "Có",
          cancelButtonText: "Hủy",
        }).then((result) => {
          if (result.isConfirmed) {
            fetch(
              "${pageContext.request.contextPath}/admin-servlet/event-management?action=delete&eventID=" +
                eventID,
              {
                method: "POST",
              }
            ).then((response) => {
              if (response.ok) {
                Swal.fire("Xóa thành công!", "", "success").then(() => {
                  window.location.reload();
                });
              } else {
                Swal.fire("Lỗi!", "Không thể xóa sự kiện.", "error");
              }
            });
          }
        });
      }
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
