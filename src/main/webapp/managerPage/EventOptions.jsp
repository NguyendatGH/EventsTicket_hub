<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Event management</title>

    <style>
      * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
        font-family: Inter;
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

      .top-bar {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 40px;
      }

      .breadcrumb {
        display: flex;
        align-items: center;
        gap: 10px;
        font-size: 16px;
        font-weight: 500;
        background: rgba(255, 255, 255, 0.18);
        border-radius: 12px;
        padding: 10px 20px;
      }

      .breadcrumb-item {
        color: #a8a8a8;
      }

      .breadcrumb-current {
        color: white;
      }

      .notification-icon {
        width: 24px;
        height: 24px;
        color: #64b5f6;
        cursor: pointer;
      }

      .section {
        margin-bottom: 30px;
      }

      .section-title {
        font-size: 20px;
        font-weight: 600;
        margin-bottom: 20px;
        color: white;
      }

      .overview-section {
        border-radius: 12px;
        margin-bottom: 30px;
        width: 40%;
      }

      .link-container {
        display: flex;
        align-items: center;
        gap: 50px;
        background-color: rgba(217, 217, 217, 0.08);
        border: 1px solid rgba(184, 195, 188, 0.71);
        border-radius: 14px;
      }

      .link-label {
        font-size: 14px;
        color: #e6e6e6;
        min-width: 80px;
        padding-left: 20px;
      }

      .link-input {
        flex: 1;
        padding: 12px 16px;
        background: transparent;
        border: none;
        color: white;
        font-size: 14px;
      }

      .event-name-section {
        background: rgba(255, 255, 255, 0.08);
        border-radius: 12px;
        padding: 20px;
        margin-bottom: 30px;
        border: 1px solid rgba(255, 255, 255, 0.15);
        width: 50%;
      }

      .event-input-group {
        display: flex;
        align-items: center;
        gap: 20px;
      }

      .event-label {
        font-size: 15px;
        font-weight: 500;
        color: #e0e0e0;
        min-width: 100px;
      }

      .event-input {
        flex: 1;
        padding: 12px 20px;
        background: transparent;
        border: none;
        color: white;
        font-size: 24px;
        font-weight: 500;
      }

      .event-input:active {
        border: none;
      }
      .description-section {
        background: rgba(255, 255, 255, 0.08);
        border-radius: 12px;
        padding: 25px;
        margin-bottom: 34px;
        border: 1px solid rgba(255, 255, 255, 0.15);
      }

      .description-title {
        font-size: 16px;
        font-weight: 600;
        margin-bottom: 15px;
        color: #ffffff;
      }

      .description-text {
        font-size: 18px;
        line-height: 1.6;
        color: #ffffff;
      }

      .details-grid {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 34px;
        margin-bottom: 34px;
      }

      .details-section {
        background: rgba(255, 255, 255, 0.08);
        border-radius: 12px;
        padding: 20px;
        border: 1px solid rgba(255, 255, 255, 0.15);
      }

      .detail-item {
        display: flex;

        align-items: flex-start;
        margin-bottom: 34px;
        font-size: 14px;
      }

      .detail-item:last-child {
        margin-bottom: 0;
      }

      .detail-label {
        color: #dbdbdb;
        font-weight: 500;
        min-width: 80px;
        font-size: 14px;
      }

      .detail-value {
        color: white;
        text-align: start;
        font-size: 16px;
        padding-left: 10px;
      }

      .info-section {
        background: rgba(255, 255, 255, 0.08);
        border-radius: 12px;
        padding: 30px 20px;
        border: 1px solid rgba(255, 255, 255, 0.15);
        margin-bottom: 40px;
      }

      .info-title {
        font-size: 16px;
        font-weight: 600;
        margin-bottom: 15px;
        color: #e0e0e0;
      }

      .info-text {
        font-size: 16px;
        line-height: 1.7;
        color: #ffffff;
      }

      .bell-icon {
        width: 20px;
        height: 20px;
        color: #60a5fa;
      }

      .events-material {
        color: white;
      }
      .events-material h1 {
      }
      .material-header {
        margin-bottom: 12px;
      }
      .material-wrapper {
        border-style: dotted;
        border-color: rgba(79, 102, 206, 0.94);
        border-width: 4px;
        border-radius: 12px;
        padding: 40px 20px;
        margin-bottom: 34px;
      }
      .Banner {
      }
      .banner-header {
      }
      .content {
        display: flex;
        flex-direction: column;
        align-items: center;
      }
      .banner-content {
      }
      .img-wrapper {
        width: 80%;
        box-sizing: border-box;
        object-fit: cover;
      }
      .img-wrapper img {
        width: 100%;
        height: 100%;
      }
      .sm-img-wrapper {
        width: 40%;
      }
      .Poster {
      }
      .poster-header {
      }
      .poster-content {
      }
      .content-wrapper {
        width: 80%;
        display: flex;
        flex-direction: row;
        align-items: center;
        gap: 34px;
        object-fit: cover;
        box-sizing: border-box;
      }
      .poster-primary {
      }
      .poster-secondary {
      }
      .event-organizer-logo {
      }
      .event-organizer-header {
      }
      .event-organizer-wrapper {
      }
      .autoGap {
        margin-top: 40px;
      }
      .event-option {
        display: flex;
        flex-direction: row;
        align-items: center;
        gap: 34px;
        margin-bottom: 34px;
      }
      .btn {
        padding: 12px 18px;
        display: flex;
        flex-direction: row;
        align-items: center;
        color: white;
        font-size: 16px;
        font-weight: 600;
        gap: 14px;
        border-radius: 12px;
        border: 1px solid transparent;
      }
      .approve {
        background-color: #0f67ff;
      }
      .btn-img {
      }
      .reject {
        background-color: transparent;
        border: 1px solid #0f67ff;
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
     <img
            class="bg_elips firstElement"
            src="${pageContext.request.contextPath}/asset/full.svg"
            />
        <img
            class="bg_elips secondElement"
            src="${pageContext.request.contextPath}/asset/full2.svg"
            /> 

    <div class="container">
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
                href="${pageContext.request.contextPath}/AdminServlet?action=adminDashboard"
                class="nav-link active"
                >Bảng điều khiển</a
              >
            </li>
            <li class="nav-item">
              <a
                href="${pageContext.request.contextPath}/AdminServlet?action=manageEvents"
                class="nav-link"
                >Danh sách sự kiện</a
              >
            </li>
            <li class="nav-item">
              <a
                href="${pageContext.request.contextPath}/AdminServlet?action=manageUserAccount"
                class="nav-link"
                >Danh sách tài khoản</a
              >
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

      <main class="main-content">
        <div class="top-bar">
          <div class="breadcrumb">
            <span class="breadcrumb-item">Bảng điều khiển</span>
            <span style="color: white">/</span>
            <span class="breadcrumb-current">Chi tiết sự kiện</span>
          </div>
         
        </div>

        <div class="section">
          <h2 class="section-title">Tổng quan</h2>
          <div class="overview-section">
            <div class="link-container">
              <span class="link-label">Link sự kiện</span>
              <input
                type="text"
                class="link-input"
                value="https://teamocadystartitutivittrithuamhye.com"
                readonly
              />
            </div>
          </div>
        </div>

        <div class="event-name-section">
          <div class="event-input-group">
            <span class="event-label">Tên sự kiện:</span>
            <input
              type="text"
              class="event-input"
              value="Sự kiện vẽ tranh hoạt hình"
              readonly
            />
          </div>
        </div>

        <div class="description-section">
          <h3 class="description-title">Đơn vị tổ chức</h3>
          <p class="description-text">
            Trung tâm Văn hóa Thanh thiếu niên Thành phố phối hợp cùng Câu lạc
            bộ Mỹ thuật Sáng tạo Trẻ.
          </p>
        </div>

        <div class="details-grid">
          <div class="details-section">
            <div class="detail-item">
              <span class="detail-label">Thời gian:</span>
              <span class="detail-value"
                >08:00 – 17:00, ngày 15 tháng 6 năm 2025.</span
              >
            </div>
            <div class="detail-item">
              <span class="detail-label">Địa điểm:</span>
              <span class="detail-value"
                >Nhà Văn hóa Thanh niên, số 4 Phạm Ngọc Thạch, Quận 1,
                TP.HCM.</span
              >
            </div>
          </div>

          <div class="details-section">
            <div class="detail-item">
              <span class="detail-label">Số lượng:</span>
              <span class="detail-value">120 vé</span>
            </div>
            <div class="detail-item">
              <span class="detail-label">Giới hạn tuổi:</span>
              <span class="detail-value">0</span>
            </div>
            <div class="detail-item">
              <span class="detail-label">Dress code:</span>
              <span class="detail-value">không có</span>
            </div>
          </div>
        </div>

        <div class="info-section">
          <h3 class="info-title">Thông tin sự kiện</h3>
          <p class="info-text">
            Sự kiện Vẽ Tranh Hoạt Hình là một hoạt động sáng tạo dành cho các
            bạn yêu thích hội họa và đam mê thế giới hoạt hình. Trong gia sự
            kiện, người chơi sẽ được thỏa sức thể hiện tài năng qua việc sáng
            tác nhân vật, tạo bối cảnh và kể câu chuyện bằng nét vẽ sinh động.
            Đây không chỉ là sân chơi nghệ thuật mà còn là cơ hội giao lưu, học
            hỏi và truyền cảm hứng giữa những người có cùng sở thích.
          </p>
        </div>

        <div class="events-material">
          <h3 class="material-header">Hình ảnh</h3>
          <div class="material-wrapper">
            <div class="Banner">
              <h3 class="banner-header">Banner</h3>
              <div class="banner-content content">
                <div class="img-wrapper"><img src="${pageContext.request.contextPath}/asset/Banner_main.svg" alt=""/></div>
              </div>
            </div>
            <div class="Poster">
              <h3 class="poster-header autoGap">Banner</h3>
              <div class="poster-content content">
                <div class="content-wrapper">
                  <div class="">
                    <img src="${pageContext.request.contextPath}/asset/Banner_primary.svg" class="poster-primary" alt=""/>
                  </div>
                  <div class="">
                    <img src="${pageContext.request.contextPath}/asset/Banner_secondary.svg" class="poster-secondary" alt=""/>
                  </div>
                </div>
              </div>
            </div>
            <div class="event-organizer-logo">
              <h3 class="event-organizer-header autoGap">Logo</h3>
              <div class="event-organizer-wrapper content">
                <div class="content-wrapper">
                  <img src="${pageContext.request.contextPath}/asset/Logo.svg" alt="" />
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="event-option">
          <button class="btn approve">
            Phê Duyệt
            <img src="${pageContext.request.contextPath}/asset/accept.svg" class="btn-img" alt=""/>
          </button>
          <button class="btn reject">
            Phê Duyệt
            <img src="${pageContext.request.contextPath}/asset/Trash.svg" class="btn-img" alt=""/>
          </button>
        </div>
      </main>
    </div>

    <script>
      function animateEllipses() {
        const ellipses = document.querySelectorAll(".bg_elips");
        ellipses.forEach((ellipse, index) => {
          const duration = 8000 + index * 2000;
          ellipse.style.animation = `float ${duration}ms ease-in-out infinite`;
        });
      }
    </script>
  </body>
</html>
