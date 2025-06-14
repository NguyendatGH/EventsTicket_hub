<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib uri="http://java.sun.com/jsp/jstl/core"
prefix="c" %> <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>MasterTicket Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/asset/css/AdminDashboard.css"/>
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
          <div class="admin-role">MasterTicket Website Manager</div>
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

        <a href="#" class="logout">
          <svg width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
            <path d="M16 13v-2H7V8l-5 4 5 4v-3z" />
            <path
              d="M20 3h-9c-1.103 0-2 .897-2 2v4h2V5h9v14h-9v-4H9v4c0 1.103.897 2 2 2h9c1.103 0 2-.897 2-2V5c0-1.103-.897-2-2-2z"
            />
          </svg>
          Logout
        </a>
      </aside>

      <main class="main-content">
        <header class="header">
          <div class="control-panel">Control Panel</div>
        </header>

        <div class="stats-grid">
          <div class="stat-card">
            <div class="stat-wrapper">
              <div class="stat-header">
                <span class="stat-title">Total Users</span>
              </div>
              <span class="stat-content">
                <img
                  src="${pageContext.request.contextPath}/asset/Property1=Group_light.svg"
                  alt=""
                  class="stat-icon"
                />
                <div class="stat-value">${totalUser}</div>
              </span>
            </div>
          </div>
          <div class="stat-card">
            <div class="stat-wrapper">
              <div class="stat-header">
                <span class="stat-title">Events This Month</span>
              </div>
              <span class="stat-content">
                <img
                  src="${pageContext.request.contextPath}/asset/image/Ticket_duotone.svg"
                  alt=""
                  class="stat-icon"
                />
                <div class="stat-value">${eventThisMonth}</div>
              </span>
            </div>
          </div>
          <div class="stat-card">
            <div class="stat-wrapper">
              <div class="stat-header">
                <span class="stat-title">Total Visits</span>
              </div>
              <span class="stat-content">
                <img
                  src="${pageContext.request.contextPath}/asset/image/Property1=Send_fill.svg"
                  alt=""
                  class="stat-icon"
                />
                <div class="stat-value">100,000</div>
              </span>
            </div>
          </div>
        </div>

        <!-- Content Grid -->
        <div class="content-grid">
          <!-- Hot Events -->
          <div class="content-card">
            <h2 class="card-title">Top sự kiện hot</h2>
            <ul class="event-list">
              <c:forEach var="event" items="${events}">
                <li class="event-item">
                  <div class="event-info">
                    <div class="event-number">${event.ranking}</div>
                    <span class="event-name">${event.name}</span>
                  </div>
                  <div class="event-date">
                    <fmt:formatDate
                      value="${event.startTime}"
                      pattern="yyyy-MM-dd HH:mm:ss"
                    />
                  </div>
                </li>
              </c:forEach>
            </ul>
          </div>

          <div class="content-card">
            <div class="request-header">
              <h2 class="card-title">Approval Requests</h2>
              <img
                class="bell_img"
                src="${pageContext.request.contextPath}/asset/image/Property1=Bell_pin_light.svg"
                alt=""
              />
            </div>
            <c:if test="${empty pendingList}">
              <p>No pending events found.</p>
            </c:if>
            <c:if test="${not empty pendingList}">
              <p style="color: white; margin-top: 14px; margin-bottom: 14px">
                Found ${pendingList.size()} pending events.
              </p>
            </c:if>
            <c:forEach var="event" items="${pendingList}" varStatus="status">
              <div class="request-item">
                <div class="request-info">
                  <div class="request-number">${status.count}</div>
                  <span class="request-text">${event.name}</span>
                </div>
                <div class="request-actions">
                  <button
                    class="btn-detail"
                    onclick="handleEditEvent(${event.eventID})"
                  >
                    Chi tiết
                  </button>
                </div>
              </div>
            </c:forEach>
            <a href="#" class="view-more">Xem thêm ></a>
          </div>
        </div>
      </main>
    </div>

    <script>
      document.querySelectorAll(".stat-card").forEach((card) => {
        card.addEventListener("mouseenter", () => {
          card.style.transform = "translateY(-4px)";
          card.style.boxShadow = "0 20px 40px rgba(0,0,0,0.3)";
        });

        card.addEventListener("mouseleave", () => {
          card.style.transform = "translateY(0)";
          card.style.boxShadow = "none";
        });
      });

      // Animate ellipses
      function animateEllipses() {
        const ellipses = document.querySelectorAll(".bg_elips");
        ellipses.forEach((ellipse, index) => {
          const duration = 8000 + index * 2000;
          ellipse.style.animation = `float ${duration}ms ease-in-out infinite`;
        });
      }
      function handleEditEvent(eventId) {
        console.log("Redirecting to edit event:", eventId);

        window.location.href =
          "admin-servlet?action=viewEventDetail&eventId=" + eventId;
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
