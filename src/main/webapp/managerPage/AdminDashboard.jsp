<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>MasterTicket Dashboard</title>
    <!-- CSS remains unchanged -->
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

      /* Sidebar */
      .sidebar {
        width: 280px;
        background: rgba(15, 23, 42, 0.9);
        backdrop-filter: blur(20px);
        border-right: 1px solid #4d4d4d;
        padding: 2rem 0;
      }

      .logo {
        color: white;
        font-size: 1.5rem;
        font-weight: 700;
        margin-bottom: 3rem;
        padding: 0 2rem;
      }

      .admin-section {
        padding: 0 2rem;
        margin-bottom: 3rem;
      }

      .admin-avatar {
        width: 80px;
        height: 80px;
        background: rgba(71, 85, 105, 0.8);
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        margin: 0 auto 1rem;
      }

      .admin-avatar svg {
        width: 40px;
        height: 40px;
        color: #94a3b8;
      }

      .admin-name {
        color: white;
        font-size: 1.25rem;
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
        background: rgba(159, 153, 153, 0.18);
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

      /* Main Content */
      .main-content {
        flex: 1;
        padding: 2rem;
        /* background: rgba(15, 23, 42, 0.5);
        backdrop-filter: blur(10px); */
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

      /* Stats Cards */
      .stats-grid {
        display: flex;
        flex-direction: row;
        align-items: center;
        gap: 37px;
        margin-bottom: 37px;
      }

      .stat-card,
      .stat-wrapper,
      .stat-content,
      .stat-header {
        box-sizing: border-box;
      }

      .stat-card {
        width: fit-content; /* Changed from fixed 20% to adapt to content */
        min-width: 230px; /* Optional: set a minimum width to avoid overly narrow cards */
        max-width: 100%; /* Ensure card doesn't exceed parent container */
        background: rgba(255, 255, 255, 0.18);
        border-radius: 12px;
        padding: 2rem;
        backdrop-filter: blur(20px);
        transition: all 0.3s ease;
      }

      .stat-card:hover {
        transform: translateY(-2px);
        border-color: rgba(255, 255, 255, 0.2);
      }

      .stat-wrapper {
        display: flex;
        flex-direction: column;
        align-items: flex-start;
        width: 100%; /* Ensure wrapper takes full card width */
      }

      .stat-header {
        display: flex;
        align-items: flex-start;
        gap: 0.75rem;
        margin-bottom: 1rem;
        width: 100%; /* Ensure header doesn't cause overflow */
      }

      .stat-icon {
        width: 52px;
        height: 52px;
        max-width: 100%;
        height: auto;
        flex-shrink: 0; /* Prevent icon from shrinking */
      }

      .stat-content {
        display: flex;
        flex-direction: row;
        align-items: center;
        justify-content: flex-start; /* Changed from center to avoid overflow */
        gap: 5px;
        width: 100%; /* Ensure content takes full width */
        flex-wrap: wrap; /* Allow content to wrap if too wide */
      }

      .stat-title {
        color: #ffffff;
        font-size: 1rem;
        font-weight: 500;
        word-wrap: break-word; /* Ensure text wraps */
      }

      .stat-value {
        color: white;
        font-size: 24px;
        font-weight: 700;
        word-wrap: break-word;
        max-width: 100%; /* Ensure value doesn't overflow */
      }
      /* Content Grid */
      .content-grid {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 37px;
      }

      .content-card {
        background: rgba(255, 255, 255, 0.18);
        border: 1px solid rgba(255, 255, 255, 0.1);
        border-radius: 16px;
        padding: 2rem;
        backdrop-filter: blur(20px);
      }

      .card-title {
        color: white;
        font-size: 24px;
        font-weight: bold;
        margin-bottom: 0.5rem;
      }

      /* Hot Events List */
      .event-list {
        list-style: none;
      }

      .event-item {
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 1rem 0;
        border-bottom: 1px solid rgba(255, 255, 255, 0.1);
      }

      .event-item:last-child {
        border-bottom: none;
      }

      .event-info {
        display: flex;
        align-items: center;
        gap: 1rem;
      }

      .event-number {
        background: rgba(59, 130, 246, 0.2);
        color: #60a5fa;
        width: 32px;
        height: 32px;
        border-radius: 8px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-weight: 700;
        font-size: 0.875rem;
      }

      .event-name {
        color: #e2e8f0;
        font-weight: 500;
      }

      .event-date {
        background: rgba(252, 184, 89, 0.12);
        color: #fcb859;
        padding: 0.25rem 0.75rem;
        border-radius: 6px;
        border: 1px solid #fcb859;
        font-size: 0.75rem;
        font-weight: 600;
      }

      /* Request List */
      .request-item {
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 1rem 0;
        border-bottom: 1px solid rgba(255, 255, 255, 0.1);
      }

      .bell-icon {
        width: 24px;
        height: 24px;
      }
      .request-item:last-child {
        border-bottom: none;
      }

      .request-info {
        display: flex;
        align-items: center;
        gap: 1rem;
      }

      .request-number {
        background: rgba(16, 185, 129, 0.2);
        color: #34d399;
        width: 32px;
        height: 32px;
        border-radius: 8px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-weight: 700;
        font-size: 0.875rem;
      }

      .request-text {
        color: #e2e8f0;
        font-weight: 500;
      }

      .request-actions {
        display: flex;
        gap: 0.75rem;
        align-items: center;
      }

      .btn-detail {
        background: rgba(71, 85, 105, 0.8);
        color: #e2e8f0;
        border: none;
        padding: 0.5rem 1rem;
        border-radius: 8px;
        font-size: 0.75rem;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s ease;
      }

      .btn-detail:hover {
        background: rgba(71, 85, 105, 1);
      }

      .check-icon {
        width: 20px;
        height: 20px;
        color: #34d399;
      }

      .view-more {
        color: #60a5fa;
        text-decoration: none;
        font-weight: 500;
        margin-top: 1rem;
        display: inline-block;
        transition: color 0.3s ease;
      }

      .view-more:hover {
        color: #93c5fd;
      }

      .request-header {
        display: flex;
        flex-direction: row;
        align-items: center;
        gap: 0.5rem;
      }

      .bell-icon {
        width: 20px;
        height: 20px;
        color: #60a5fa;
      }

      @media (max-width: 1200px) {
        .content-grid {
          grid-template-columns: 1fr;
        }
      }

      @media (max-width: 768px) {
        .stats-grid {
          grid-template-columns: 1fr;
        }

        .sidebar {
          width: 240px;
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
    <!-- Updated image paths -->
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
              <a href="#" class="nav-link active">Bảng điều khiển</a>
            </li>
            <li class="nav-item">
              <a href="#" class="nav-link">Danh sách sự kiện</a>
            </li>
            <li class="nav-item">
              <a href="#" class="nav-link">Danh sách tài khoản</a>
            </li>
            <li class="nav-item">
              <a href="#" class="nav-link">Hỗ trợ khách hàng</a>
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
          Đăng xuất
        </a>
      </aside>

      <!-- Main Content -->
      <main class="main-content">
        <header class="header">
          <div class="control-panel">Bảng điều khiển</div>
        </header>

        <!-- Stats Grid -->
        <div class="stats-grid">
          <div class="stat-card">
            <div class="stat-wrapper">
              <div class="stat-header">
                <span class="stat-title">Tổng người dùng</span>
              </div>
              <span class="stat-content">
                <img
                  src="${pageContext.request.contextPath}/asset/Property 1=Group_light.svg"
                  alt=""
                  class="stat-icon"
                />
                <div class="stat-value">100.000</div>
              </span>
            </div>
          </div>
          <div class="stat-card">
            <div class="stat-wrapper">
              <div class="stat-header">
                <span class="stat-title">Sự kiện tháng này</span>
              </div>
              <span class="stat-content">
                <img
                  src="${pageContext.request.contextPath}/asset/Ticket_duotone.svg"
                  alt=""
                  class="stat-icon"
                />
                <div class="stat-value">30</div>
              </span>
            </div>
          </div>
          <div class="stat-card">
            <div class="stat-wrapper">
              <div class="stat-header">
                <span class="stat-title">Lượt truy cập</span>
              </div>
              <span class="stat-content">
                <img
                  src="${pageContext.request.contextPath}/asset/Property 1=Send_fill.svg"
                  alt=""
                  class="stat-icon"
                />
                <div class="stat-value">100.000</div>
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
              <li class="event-item">
                <div class="event-info">
                  <div class="event-number">01</div>
                  <span class="event-name">Home Decore Range</span>
                </div>
                <div class="event-date">15/5/2025</div>
              </li>
              <li class="event-item">
                <div class="event-info">
                  <div class="event-number">01</div>
                  <span class="event-name">Home Decore Range</span>
                </div>
                <div class="event-date">15/5/2025</div>
              </li>
              <li class="event-item">
                <div class="event-info">
                  <div class="event-number">01</div>
                  <span class="event-name">Home Decore Range</span>
                </div>
                <div class="event-date">15/5/2025</div>
              </li>
              <li class="event-item">
                <div class="event-info">
                  <div class="event-number">01</div>
                  <span class="event-name">Home Decore Range</span>
                </div>
                <div class="event-date">15/5/2025</div>
              </li>
              <li class="event-item">
                <div class="event-info">
                  <div class="event-number">01</div>
                  <span class="event-name">Home Decore Range</span>
                </div>
                <div class="event-date">15/5/2025</div>
              </li>
            </ul>
          </div>

          <!-- Requests -->
          <div class="content-card">
            <div class="request-header">
              <h2 class="card-title">Yêu cầu phê duyệt</h2>
              <img
                class="bell_img"
                src="${pageContext.request.contextPath}/asset/Property 1=Bell_pin_light.svg"
                alt=""
              />
            </div>

            <div class="request-item">
              <div class="request-info">
                <div class="request-number">01</div>
                <span class="request-text">Sự kiện về tranh hoài linh</span>
              </div>
              <div class="request-actions">
                <button class="btn-detail">Chi tiết</button>
                <img
                  src="${pageContext.request.contextPath}/asset/Variant52.svg"
                  alt=""
                />
              </div>
            </div>

            <div class="request-item">
              <div class="request-info">
                <div class="request-number">01</div>
                <span class="request-text">Sự kiện về tranh hoài linh</span>
              </div>
              <div class="request-actions">
                <button class="btn-detail">Chi tiết</button>
                <img
                  src="${pageContext.request.contextPath}/asset/Variant52.svg"
                  alt=""
                />
              </div>
            </div>

            <div class="request-item">
              <div class="request-info">
                <div class="request-number">01</div>
                <span class="request-text">Sự kiện về tranh hoài linh</span>
              </div>
              <div class="request-actions">
                <button class="btn-detail">Chi tiết</button>
                <img
                  src="${pageContext.request.contextPath}/asset/Variant52.svg"
                  alt=""
                />
              </div>
            </div>

            <div class="request-item">
              <div class="request-info">
                <div class="request-number">01</div>
                <span class="request-text">Sự kiện về tranh hoài linh</span>
              </div>
              <div class="request-actions">
                <button class="btn-detail">Chi tiết</button>
                <img
                  src="${pageContext.request.contextPath}/asset/Variant52.svg"
                  alt=""
                />
              </div>
            </div>

            <div class="request-item">
              <div class="request-info">
                <div class="request-number">01</div>
                <span class="request-text">Sự kiện về tranh hoài linh</span>
              </div>
              <div class="request-actions">
                <button class="btn-detail">Chi tiết</button>
                <img
                  src="${pageContext.request.contextPath}/asset/Variant52.svg"
                  alt=""
                />
              </div>
            </div>

            <a href="#" class="view-more">Xem thêm ></a>
          </div>
        </div>
      </main>
    </div>

    <!-- JavaScript remains unchanged -->
    <script>
      // Add smooth hover effects and interactions
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

      // Add click interactions for buttons
      document.querySelectorAll(".btn-detail").forEach((btn) => {
        btn.addEventListener("click", () => {
          btn.style.transform = "scale(0.95)";
          setTimeout(() => {
            btn.style.transform = "scale(1)";
          }, 150);
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

      // Add floating animation keyframes
      const style = document.createElement("style");
      style.textContent = `
            @keyframes float {
                0%, 100% { transform: translateY(0px) rotate(0deg); }
                33% { transform: translateY(-20px) rotate(1deg); }
                66% { transform: translateY(10px) rotate(-1deg); }
            }
        `;
      document.head.appendChild(style);

      // Initialize animations
      animateEllipses();
    </script>
  </body>
</html>
