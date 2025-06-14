<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Quản lý sự kiện</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/AdminEventOption.css" />
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