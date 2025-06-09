<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %>
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
        padding: 0 120px;
        padding-top: 2rem;
        overflow-y: auto;
        display: flex;
        flex-direction: column;
        gap: 2rem;
      }
      .header {
        display: flex;
        flex-direction: column;
        align-items: flex-start;
        gap: 4rem;
        /* margin-bottom: 2rem; */
      }

      .page-title {
        color: white;
        font-size: 24px;
        font-weight: 700;
      }

      .header-wrapper {
        display: flex;
        flex-direction: column;
        gap: 14px;
        color: white;
      }
      .control-panel {
        background: rgba(255, 255, 255, 0.18);
        border-radius: 12px;
        padding: 12px 24px;
        color: #e2e8f0;
        font-weight: 600;
        backdrop-filter: blur(20px);
      }
      .breadcrumb {
        padding: 0 24px;
      }

      .back-button {
        background: transparent;
        color: white;
        border: 1px solid rgba(59, 130, 246, 1);
        padding: 8px 16px;
        font-weight: bold;
        border-radius: 12px;
        cursor: pointer;
        font-size: 14px;
        transition: background 0.3s ease;
        display: flex;
        flex-direction: row;
        align-items: center;
        gap: 10px;
        object-fit: cover;
      }
      .back-button img {
        width: 24px;
        height: 24px;
      }

      .back-button:hover {
        background: rgba(186, 186, 186, 0.375);
      }

      .card-content {
        flex: 1;
        display: flex;
        flex-direction: column;
        align-items: start;
        box-sizing: border-box;
        position: relative;
        background: transparent;
      }

      .wrapper {
        background-color: rgba(255, 255, 255, 0.18);
        color: #333;
        border-radius: 16px;
        padding: 24px 50px;
        max-width: 90%;
        width: 100%;
        box-shadow: 0 30px 60px rgba(0, 0, 0, 0.4);
        backdrop-filter: blur(15px);
        border: 1px solid rgba(255, 255, 255, 0.2);
        transform: translateY(-10px);
        transition: all 0.3s ease;
      }

      .email-header {
        background: rgba(35, 35, 35, 0.85);
        color: white;
        border-radius: 16px 16px 0 0;
        display: flex;
        justify-content: space-between;
        font-weight: 500;
        letter-spacing: 0.3px;

        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        padding: 24px 50px;

        font-size: 16px;
      }

      .email-content {
        border-radius: 12px;
        margin-top: 80px;
        padding: 20px 40px;
        line-height: 1.8;
        font-size: 15px;
        background-color: white;
      }

      .email-subject {
        font-size: 1.125rem;
        font-weight: 700;
        color: #1f2937;
        margin-bottom: 1rem;
        padding-bottom: 0.5rem;
        border-bottom: 2px solid #e5e7eb;
      }
      .email-date {
        color: #6b7280;
        font-size: 0.875rem;
        margin-bottom: 1.5rem;
        text-align: right;
      }

      .email-body {
        color: #374151;
        margin-bottom: 1.5rem;
      }
      .email-body p {
        margin-bottom: 1rem;
      }

      .reply-button {
        background: #3b82f6;
        color: white;
        border: none;
        padding: 12px 24px;
        border-radius: 8px;
        cursor: pointer;
        font-size: 14px;
        font-weight: 600;
        transition: all 0.3s ease;
        float: right;
        margin-top: 1rem;
      }

      .reply-button:hover {
        background: #2563eb;
        transform: translateY(-1px);
      }

      .clearfix::after {
        content: "";
        display: table;
        clear: both;
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
              <a href="${pageContext.request.contextPath}/admin-servlet?action=adminDashboard" class="nav-link ">Bảng điều khiển</a>
            </li>
            <li class="nav-item">
              <a href="${pageContext.request.contextPath}/admin-servlet?action=manageEvents" class="nav-link ">Danh sách sự kiện</a>
            </li>
            <li class="nav-item">
              <a
                href="${pageContext.request.contextPath}/admin-servlet?action=manageUserAccount"
                class="nav-link "
                >Danh sách tài khoản</a
              >
            </li>
            <li class="nav-item">
              <a href="${pageContext.request.contextPath}/admin-servlet?action=supportCenter" class="nav-link active">Hỗ trợ khách hàng</a>
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
      <div class="main-content">
        <header class="header">
          <div class="header-wrapper">
            <h3 class="control-panel">Hỗ Trợ Khách hàng</h3>
            <div class="breadcrumb">Hỗ Trợ / Chi tiết</div>
          </div>
          <button class="back-button">
            <img src="${pageContext.request.contextPath}/asset/back.svg" />
            Quay lại
          </button>
        </header>

        <div class="card-content">
          <div class="wrapper">
            <div class="email-header">
              <span>From: almatbiet@gmail.com</span>
              <span>To: admin@customerService.com</span>
            </div>

               <div class="email-content">
        <div class="email-subject">
            Header: Cần hỗ trợ cách sử dụng chức năng đặt vé trên nền tảng MasterTicket
        </div>

        <div class="email-date">Đã gửi lúc: 19:00 GMT, 20/4/2025</div>

        <div class="email-body">
            <p>
                Hiện tại mình đang gặp khó khăn trong việc sử dụng chức năng đặt vé trên nền tảng MasterTicket. Mình đã thử thực hiện các bước như chọn sự kiện và chỗ ngồi, nhưng không rõ sau đó cần thao tác gì để hoàn tất việc đặt vé.
            </p>

            <p>
                Ngoài ra, mình cũng không thấy thông báo xác nhận sau khi nhấn "Đặt vé".
            </p>

            <p>
                Mong admin có thể hướng dẫn chi tiết giúp mình quy trình đặt vé đúng cách, cũng như kiểm tra giúp mình xem vé đã được đặt thành công chưa.
            </p>

            <p>Mong quản trị viên sớm phản hồi!</p>
        </div>

        <div class="clearfix">
            <button class="reply-button">Phản hồi</button>
        </div>
    </div>
          </div>
        </div>
      </div>
    </div>
    <script>
      function handleEditEvent(eventId) {
       
        console.log("Redirecting to edit event:", eventId);

        
        window.location.href =
          "admin-servlet?action=viewEventDetail&eventId=" + eventId;
      }
    </script>
  </body>
</html>
