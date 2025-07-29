<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hỗ trợ khách hàng / Chi tiết / Phản hồi</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
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
        position: relative;
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
      .breadcrumb { color: #fff; font-size: 1.2rem; font-weight: 600; margin: 2.5rem 0 1.5rem 0; letter-spacing: 0.5px; }
      .back-btn { display: inline-block; background: #2563eb; color: #fff; border: none; border-radius: 10px; padding: 0.7rem 2.2rem; font-size: 1.1rem; font-weight: 500; margin-bottom: 2rem; text-decoration: none; transition: background 0.2s; }
      .back-btn:hover { background: #174ea6; }
      .info-bar { display: flex; justify-content: space-between; align-items: center; background: #232b36; color: #fff; border-radius: 10px 10px 0 0; padding: 1.1rem 2.2rem; font-size: 1rem; font-weight: 500; max-width: 800px; width: 100%; margin: 0 auto; }
      .reply-card { background: #fff; border-radius: 0 0 18px 18px; box-shadow: 0 2px 16px rgba(0,0,0,0.10); padding: 2.5rem 2.2rem 2rem 2.2rem; max-width: 800px; width: 100%; margin: 0 auto 2rem auto; }
      .reply-card textarea { width: 100%; min-height: 260px; font-size: 1.1rem; border: none; outline: none; border-radius: 12px; background: #f5f6fa; color: #222; padding: 1.5rem; margin-bottom: 2rem; box-shadow: 0 1px 4px rgba(0,0,0,0.04); resize: vertical; }
      .reply-card textarea:focus { background: #fff; border: 1.5px solid #2563eb; }
      .reply-card .btn-primary { display: block; margin-left: auto; background: #2563eb; color: #fff; border: none; border-radius: 10px; padding: 0.9rem 2.5rem; font-size: 1.1rem; font-weight: 600; cursor: pointer; transition: background 0.2s; }
      .reply-card .btn-primary:hover { background: #174ea6; }
      @media (max-width: 900px) { .info-bar, .reply-card { max-width: 98vw; padding: 1rem; } }
    </style>
</head>
<body>
  <div class="container">
    <aside class="sidebar">
      <div class="logo">MasterTicket</div>
      <div class="admin-section">
        <div class="admin-avatar">
          <svg fill="currentColor" viewBox="0 0 24 24">
            <path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/>
          </svg>
        </div>
        <div class="admin-name">Admin</div>
        <div class="admin-role">Quản lý website MasterTicket</div>
      </div>
      <nav>
        <ul class="nav-menu">
          <li class="nav-item"><a href="${pageContext.request.contextPath}/admin-servlet/dashboard" class="nav-link">Bảng điều khiển</a></li>
          <li class="nav-item"><a href="${pageContext.request.contextPath}/admin-servlet/event-management" class="nav-link">Danh sách sự kiện</a></li>
          <li class="nav-item"><a href="${pageContext.request.contextPath}/admin-servlet/user-management" class="nav-link">Danh sách tài khoản</a></li>
          <li class="nav-item"><a href="${pageContext.request.contextPath}/admin-servlet/support-center" class="nav-link active">Hỗ trợ khách hàng</a></li>
        </ul>
      </nav>
      <a href="${pageContext.request.contextPath}/logout" class="logout">
        <svg width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
          <path d="M16 13v-2H7V8l-5 4 5 4v-3z" />
          <path d="M20 3h-9c-1.103 0-2 .897-2 2v4h2V5h9v14h-9v-4H9v4c0 1.103.897 2 2 2h9c1.103 0 2-.897 2-2V5c0-1.103-.897-2-2-2z" />
        </svg> Đăng xuất
      </a>
    </aside>
    <main class="main-content">
      <div class="breadcrumb">Hỗ trợ khách hàng / Chi tiết/ Phản hồi</div>
      <a href="${pageContext.request.contextPath}/admin/support" class="back-btn"><i class="fas fa-arrow-left"></i> Quay lại</a>
      <div class="info-bar">
        <span><b>Từ:</b> admin@customerService.com</span>
        <span><b>Tới:</b> ${supportItem.fromEmail}</span>
      </div>
      <div class="reply-card">
        <form action="${pageContext.request.contextPath}/admin/support" method="post">
          <textarea name="adminResponse" required placeholder="Nhập nội dung phản hồi cho người dùng...">${supportItem.adminResponse}</textarea>
          <button type="submit" name="action" value="reply" class="btn-primary">Gửi</button>
        </form>
      </div>
    </main>
  </div>
</body>
</html>