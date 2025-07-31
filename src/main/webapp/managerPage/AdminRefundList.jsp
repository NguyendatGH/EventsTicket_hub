<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý hoàn tiền - MasterTicket Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
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
        min-height: 100vh;
        overflow-x: hidden;
      }

      .container {
        display: flex;
        min-height: 100vh;
        position: relative;
        z-index: 1;
      }

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
        padding: 0 94px;
        padding-top: 2rem;
        padding-bottom: 2rem;
        overflow-y: auto;
        display: flex;
        flex-direction: column;
        gap: 2rem;
        min-height: 100vh;
            margin-left: 240px;
      }

      .main-content::-webkit-scrollbar {
        width: 8px;
      }

      .main-content::-webkit-scrollbar-track {
        background: rgba(255, 255, 255, 0.1);
        border-radius: 4px;
      }

      .main-content::-webkit-scrollbar-thumb {
        background: rgba(255, 255, 255, 0.3);
        border-radius: 4px;
      }

      .main-content::-webkit-scrollbar-thumb:hover {
        background: rgba(255, 255, 255, 0.5);
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

      .stats-grid {
        display: flex;
        gap: 30px;
        flex-wrap: wrap;
      }

      .stat-card {
        flex: 1;
        min-width: 200px;
        background: rgba(255, 255, 255, 0.18);
        border-radius: 12px;
        padding: 2rem;
        backdrop-filter: blur(20px);
        transition: all 0.3s ease;
        border: 1px solid rgba(255, 255, 255, 0.1);
      }

      .stat-card:hover {
        transform: translateY(-2px);
        border-color: rgba(255, 255, 255, 0.2);
      }

      .stat-title {
        color: #94a3b8;
        font-size: 0.875rem;
        margin-bottom: 0.5rem;
      }

      .stat-value {
        color: white;
        font-size: 1.5rem;
        font-weight: 700;
      }

      .stat-content {
        display: flex;
        flex-direction: row;
        align-items: center;
      }

      .stat-icon {
        width: 40px;
        height: 40px;
        margin-right: 1rem;
      }

      /* Search and Filter Section */
      .search-filter-section {
        background: rgba(255, 255, 255, 0.18);
        border-radius: 12px;
        padding: 2rem;
        backdrop-filter: blur(20px);
        border: 1px solid rgba(255, 255, 255, 0.1);
      }

      .search-filter-title {
        color: white;
        font-size: 1.25rem;
        font-weight: 600;
        margin-bottom: 1.5rem;
      }

      .search-filter-form {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        gap: 1rem;
        margin-bottom: 1rem;
      }

      .form-group {
        display: flex;
        flex-direction: column;
      }

      .form-label {
        color: #94a3b8;
        font-size: 0.875rem;
        margin-bottom: 0.5rem;
      }

      .form-input, .form-select {
        background: rgba(255, 255, 255, 0.9);
        border: 1px solid rgba(255, 255, 255, 0.2);
        border-radius: 8px;
        padding: 0.75rem;
        color: black;
        font-size: 0.875rem;
      }

      .form-input:focus, .form-select:focus {
        outline: none;
        border-color: rgba(255, 255, 255, 0.4);
        color: black;
      }

      .form-input::placeholder {
        color: #6b7280;
      }

      .search-btn, .clear-btn {
        background: rgba(255, 255, 255, 0.1);
        border: 1px solid rgba(255, 255, 255, 0.2);
        border-radius: 8px;
        padding: 0.75rem 1.5rem;
        color: white;
        text-decoration: none;
        display: inline-flex;
        align-items: center;
        gap: 0.5rem;
        font-size: 0.875rem;
        transition: all 0.3s ease;
      }

      .search-btn:hover, .clear-btn:hover {
        background: rgba(255, 255, 255, 0.2);
      }

      /* Refund List */
      .refund-list {
        background: rgba(255, 255, 255, 0.18);
        border-radius: 12px;
        padding: 2rem;
        backdrop-filter: blur(20px);
        border: 1px solid rgba(255, 255, 255, 0.1);
      }

      .refund-item {
        background: rgba(255, 255, 255, 0.1);
        border-radius: 8px;
        padding: 1.5rem;
        margin-bottom: 1rem;
        border: 1px solid rgba(255, 255, 255, 0.1);
        transition: all 0.3s ease;
      }

      .refund-item:hover {
        background: rgba(255, 255, 255, 0.15);
        border-color: rgba(255, 255, 255, 0.2);
      }

      .refund-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 1rem;
      }

      .refund-id {
        color: #94a3b8;
        font-size: 0.875rem;
      }

      .refund-status {
        padding: 0.25rem 0.75rem;
        border-radius: 20px;
        font-size: 0.75rem;
        font-weight: 600;
      }

      .status-pending {
        background: rgba(255, 193, 7, 0.2);
        color: #fbbf24;
      }

      .status-approved {
        background: rgba(16, 185, 129, 0.2);
        color: #10b981;
      }

      .status-rejected {
        background: rgba(239, 68, 68, 0.2);
        color: #ef4444;
      }

      .status-completed {
        background: rgba(59, 130, 246, 0.2);
        color: #3b82f6;
      }

      .refund-details {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        gap: 1rem;
        margin-bottom: 1rem;
      }

      .detail-item {
        display: flex;
        flex-direction: column;
      }

      .detail-label {
        color: #94a3b8;
        font-size: 0.75rem;
        margin-bottom: 0.25rem;
      }

      .detail-value {
        color: white;
        font-weight: 500;
      }

      .action-buttons {
        display: flex;
        gap: 0.5rem;
        flex-wrap: wrap;
      }

      .btn {
        padding: 0.5rem 1rem;
        border-radius: 6px;
        text-decoration: none;
        font-size: 0.875rem;
        font-weight: 500;
        display: inline-flex;
        align-items: center;
        gap: 0.5rem;
        transition: all 0.3s ease;
        border: none;
        cursor: pointer;
      }

      .btn-primary {
        background: rgba(59, 130, 246, 0.2);
        color: #3b82f6;
        border: 1px solid rgba(59, 130, 246, 0.3);
      }

      .btn-primary:hover {
        background: rgba(59, 130, 246, 0.3);
      }

      .btn-success {
        background: rgba(16, 185, 129, 0.2);
        color: #10b981;
        border: 1px solid rgba(16, 185, 129, 0.3);
      }

      .btn-success:hover {
        background: rgba(16, 185, 129, 0.3);
      }

      .btn-danger {
        background: rgba(239, 68, 68, 0.2);
        color: #ef4444;
        border: 1px solid rgba(239, 68, 68, 0.3);
      }

      .btn-danger:hover {
        background: rgba(239, 68, 68, 0.3);
      }

      .btn-warning {
        background: rgba(245, 158, 11, 0.2);
        color: #f59e0b;
        border: 1px solid rgba(245, 158, 11, 0.3);
      }

      .btn-warning:hover {
        background: rgba(245, 158, 11, 0.3);
      }

      /* Bảng refund với màu chữ trắng */
      .refund-table {
        background: rgba(255, 255, 255, 0.05);
        border-radius: 12px;
        overflow: hidden;
        border: 1px solid rgba(255, 255, 255, 0.1);
      }

      .table-header {
        background: rgba(255, 255, 255, 0.1);
        padding: 1rem;
        display: grid;
        grid-template-columns: 1fr 2fr 2fr 1fr 1fr 1fr 1fr;
        gap: 1rem;
        font-weight: 600;
        color: white;
      }

      .refund-row {
        padding: 1rem;
        display: grid;
        grid-template-columns: 1fr 2fr 2fr 1fr 1fr 1fr 1fr;
        gap: 1rem;
        border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        transition: background 0.3s ease;
        color: white;
      }

      .refund-row:hover {
        background: rgba(255, 255, 255, 0.05);
      }

      .refund-row:last-child {
        border-bottom: none;
      }

      /* Đảm bảo tất cả text trong bảng có màu trắng */
      .refund-table * {
        color: white;
      }

      /* Status badges giữ nguyên màu riêng */
      .status-badge {
        color: inherit;
      }

      .status-badge {
        padding: 0.25rem 0.75rem;
        border-radius: 20px;
        font-size: 0.75rem;
        font-weight: 600;
        text-align: center;
      }

      .status-pending {
        background: #fbbf24;
        color: #92400e;
      }

      .status-approved {
        background: #10b981;
        color: #064e3b;
      }

      .status-rejected {
        background: #ef4444;
        color: #7f1d1d;
      }

      .status-completed {
        background: #3b82f6;
        color: #1e3a8a;
      }

      .btn {
        padding: 0.5rem 1rem;
        border-radius: 6px;
        text-decoration: none;
        font-size: 0.875rem;
        font-weight: 500;
        transition: all 0.3s ease;
        border: none;
        cursor: pointer;
        display: inline-flex;
        align-items: center;
        gap: 0.25rem;
        margin: 0.25rem;
      }

      .action-buttons {
        display: flex;
        flex-wrap: wrap;
        gap: 0.5rem;
        align-items: center;
      }

      .btn-primary {
        background: #6366f1;
        color: white;
      }

      .btn-primary:hover {
        background: #5855eb;
      }

      .btn-success {
        background: #10b981;
        color: white;
      }

      .btn-success:hover {
        background: #059669;
      }

      .btn-danger {
        background: #ef4444;
        color: white;
      }

      .btn-danger:hover {
        background: #dc2626;
      }

      .btn-warning {
        background: #f59e0b;
        color: white;
      }

      .btn-warning:hover {
        background: #d97706;
      }

      /* Alert styles */
      .alert {
        padding: 1rem;
        border-radius: 8px;
        margin-bottom: 1rem;
      }

      .alert-success {
        background: rgba(16, 185, 129, 0.2);
        border: 1px solid rgba(16, 185, 129, 0.3);
        color: #10b981;
      }

      .alert-error {
        background: rgba(239, 68, 68, 0.2);
        border: 1px solid rgba(239, 68, 68, 0.3);
        color: #ef4444;
      }

      /* Pagination */
      .pagination {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-top: 2rem;
        padding: 1.5rem;
        background: rgba(255, 255, 255, 0.05);
        border-radius: 12px;
        border: 1px solid rgba(255, 255, 255, 0.1);
      }

      .pagination-info {
        color: #60a5fa;
        font-size: 0.875rem;
        font-weight: 500;
      }

      .pagination-controls {
        display: flex;
        align-items: center;
        gap: 0.5rem;
      }

      .page-link {
        background: rgba(255, 255, 255, 0.1);
        border: 1px solid rgba(255, 255, 255, 0.2);
        color: white;
        padding: 0.75rem 1rem;
        border-radius: 8px;
        text-decoration: none;
        font-size: 0.875rem;
        font-weight: 500;
        transition: all 0.3s ease;
        min-width: 40px;
        text-align: center;
        display: flex;
        align-items: center;
        justify-content: center;
      }

      .page-link:hover {
        background: rgba(255, 255, 255, 0.2);
        transform: translateY(-1px);
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
      }

      .page-link.active {
        background: #6366f1;
        border-color: #6366f1;
        color: white;
        font-weight: 600;
      }

      .page-link.disabled {
        opacity: 0.5;
        pointer-events: none;
        cursor: not-allowed;
      }

      .page-link.prev, .page-link.next {
        background: rgba(99, 102, 241, 0.1);
        border-color: rgba(99, 102, 241, 0.3);
        color: #6366f1;
      }

      .page-link.prev:hover, .page-link.next:hover {
        background: rgba(99, 102, 241, 0.2);
      }

      .page-link.prev.disabled, .page-link.next.disabled {
        opacity: 0.3;
        pointer-events: none;
      }

      .page-dots {
        color: #a1a1aa;
        padding: 0.75rem 0.5rem;
        font-weight: 500;
      }

      /* Responsive */
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
      }

      @media (max-width: 992px) {
        .control-panel {
          display: none;
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
          height: auto;
          min-height: 100vh;
        }
        .stats-grid {
          flex-direction: column;
          align-items: stretch;
        }
        .stat-card {
          min-width: 100%;
        }
        .refund-list {
          max-height: none;
        }
      }

      @media (max-width: 768px) {
        .main-content {
          padding: 0 15px;
          height: auto;
          min-height: 100vh;
        }
        .page-title {
          font-size: 1.5rem;
        }
        .search-filter-form {
          grid-template-columns: 1fr;
        }
        .refund-details {
          grid-template-columns: 1fr;
        }
        .action-buttons {
          flex-direction: column;
        }
        .refund-list {
          max-height: none;
        }
        .pagination {
          flex-direction: column;
          gap: 1rem;
        }
        .pagination-controls {
          flex-wrap: wrap;
          justify-content: center;
        }
        .page-link {
          min-width: 35px;
          padding: 0.5rem 0.75rem;
        }
      }
    </style>
</head>
<body>
    <div class="container">
         <aside class="sidebar">
        <div class="logo">EventTicketHub</div>
        <div class="admin-section">
          <div class="admin-avatar">
            <svg fill="currentColor" viewBox="0 0 24 24">
              <path
                d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"
              />
            </svg>
          </div>
          <div class="admin-name">Admin</div>
          <div class="admin-role">Quản lý website </div>
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
                href="${pageContext.request.contextPath}/admin-servlet/transaction-management"
                class="nav-link"
                >Danh sách giao dịch</a
              >
            </li>
            <li class="nav-item">
              <a
                href="${pageContext.request.contextPath}/admin/refund"
                class="nav-link"
                >Quản lý hoàn tiền</a
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
            <path d="M20 3h-9c-1.103 0-2 .897-2 2v4h2V5h9v14h-9v-4H9v4c0 1.103.897 2 2 2h9c1.103 0 2-.897 2-2V5c0-1.103-.897-2-2-2z" />
          </svg>
          Đăng xuất
        </a>
      </aside>

        <main class="main-content">
            <header class="header">
                <h1 class="page-title">Quản lý hoàn tiền</h1>
                <div style="display: flex; align-items: center; gap: 24px;">
                    <div class="control-panel">Quản lý hoàn tiền</div>
                </div>
            </header>



            <!-- Thông báo -->
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle"></i>
                    ${errorMessage}
                </div>
            </c:if>
            <c:if test="${not empty successMessage}">
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i>
                    ${successMessage}
                </div>
            </c:if>

            <!-- Thống kê -->
            <section class="stats-grid">
                <div class="stat-card">
                    <div class="stat-title">Tổng yêu cầu</div>
                    <div class="stat-content">
                        <img src="${pageContext.request.contextPath}/asset/image/Ticket_duotone.svg" alt="" class="stat-icon" />
                        <div class="stat-value">${totalRefunds}</div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-title">Chờ xử lý</div>
                    <div class="stat-content">
                        <img src="${pageContext.request.contextPath}/asset/image/Property1=Done.svg" alt="" class="stat-icon" />
                        <div class="stat-value">${pendingRefunds}</div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-title">Đã phê duyệt</div>
                    <div class="stat-content">
                        <img src="${pageContext.request.contextPath}/asset/image/Property1=Done.svg" alt="" class="stat-icon" />
                        <div class="stat-value">${approvedRefunds}</div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-title">Đã hoàn thành</div>
                    <div class="stat-content">
                        <img src="${pageContext.request.contextPath}/asset/image/Property1=Done.svg" alt="" class="stat-icon" />
                        <div class="stat-value">${completedRefunds}</div>
                    </div>
                </div>
            </section>

            <!-- Tìm kiếm và Filter -->
            <div class="search-filter-section">
                <div class="search-filter-title">
                    <i class="fas fa-search"></i>
                    Tìm kiếm và Lọc
                </div>
                
                <form method="get" action="${pageContext.request.contextPath}/admin/refund" class="search-filter-form">
                    <div class="form-group">
                        <label for="search" class="form-label">Tìm kiếm</label>
                        <input type="text" id="search" name="search" class="form-input" 
                               placeholder="Tên khách hàng hoặc mã đơn hàng..." 
                               value="${searchTerm != null ? searchTerm : ''}">
                    </div>
                    
                    <div class="form-group">
                        <label for="status" class="form-label">Trạng thái</label>
                        <select id="status" name="status" class="form-select">
                            <option value="all" ${statusFilter == null || statusFilter == 'all' ? 'selected' : ''}>Tất cả</option>
                            <option value="pending" ${statusFilter == 'pending' ? 'selected' : ''}>Chờ xử lý</option>
                            <option value="approved" ${statusFilter == 'approved' ? 'selected' : ''}>Đã phê duyệt</option>
                            <option value="rejected" ${statusFilter == 'rejected' ? 'selected' : ''}>Đã từ chối</option>
                            <option value="completed" ${statusFilter == 'completed' ? 'selected' : ''}>Đã hoàn thành</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="amount" class="form-label">Số tiền</label>
                        <select id="amount" name="amount" class="form-select">
                            <option value="" ${amountFilter == null || amountFilter == '' ? 'selected' : ''}>Tất cả</option>
                            <option value="0-100000" ${amountFilter == '0-100000' ? 'selected' : ''}>0 - 100,000 ₫</option>
                            <option value="100000-500000" ${amountFilter == '100000-500000' ? 'selected' : ''}>100,000 - 500,000 ₫</option>
                            <option value="500000-1000000" ${amountFilter == '500000-1000000' ? 'selected' : ''}>500,000 - 1,000,000 ₫</option>
                            <option value="1000000+" ${amountFilter == '1000000+' ? 'selected' : ''}>Trên 1,000,000 ₫</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="reason" class="form-label">Lý do</label>
                        <input type="text" id="reason" name="reason" class="form-input" 
                               placeholder="Từ khóa trong lý do..." 
                               value="${reasonFilter != null ? reasonFilter : ''}">
                    </div>
                    
                    <div class="form-group" style="align-self: end;">
                        <button type="submit" class="search-btn">
                            <i class="fas fa-search"></i>
                            Tìm kiếm
                        </button>
                        <a href="${pageContext.request.contextPath}/admin/refund" class="clear-btn">
                            <i class="fas fa-times"></i>
                            Xóa bộ lọc
                        </a>
                    </div>
                </form>
            </div>

            <!-- Bảng danh sách -->
            <div class="refund-table">
                <c:choose>
                    <c:when test="${empty refunds}">
                        <div class="empty-state">
                            <div class="empty-icon">
                                <i class="fas fa-inbox"></i>
                            </div>
                            <h3>Chưa có yêu cầu hoàn tiền nào</h3>
                            <p>Khi có yêu cầu hoàn tiền mới, chúng sẽ xuất hiện ở đây.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="table-header">
                            <div>ID</div>
                            <div>Khách hàng</div>
                            <div>Đơn hàng</div>
                            <div>Số tiền</div>
                            <div>Trạng thái</div>
                            <div>Ngày yêu cầu</div>
                            <div>Thao tác</div>
                        </div>
                        
                        <c:forEach var="refund" items="${refunds}">
                            <div class="refund-row">
                                <div>#${refund.refundId}</div>
                                <div>
                                    <div style="font-weight: 600;">${refund.userName != null ? refund.userName : 'N/A'}</div>
                                    <div style="font-size: 0.875rem; color: #a1a1aa;">ID: ${refund.userId}</div>
                                </div>
                                <div>
                                    <div style="font-weight: 600;">${refund.orderNumber != null ? refund.orderNumber : 'N/A'}</div>
                                    <div style="font-size: 0.875rem; color: #a1a1aa;">Order ID: ${refund.orderId}</div>
                                </div>
                                <div>
                                    <c:choose>
                                        <c:when test="${refund.refundAmount != null and refund.refundAmount > 0}">
                                            ${refund.refundAmount} ₫
                                        </c:when>
                                        <c:otherwise>N/A</c:otherwise>
                                    </c:choose>
                                </div>
                                <div>
                                    <span class="status-badge status-${refund.refundStatus}">
                                        <c:choose>
                                            <c:when test="${refund.refundStatus == 'pending'}">Chờ xử lý</c:when>
                                            <c:when test="${refund.refundStatus == 'approved'}">Đã phê duyệt</c:when>
                                            <c:when test="${refund.refundStatus == 'rejected'}">Đã từ chối</c:when>
                                            <c:when test="${refund.refundStatus == 'completed'}">Đã hoàn thành</c:when>
                                            <c:otherwise>${refund.refundStatus}</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                                <div>
                                    <c:choose>
                                        <c:when test="${refund.refundRequestDate != null}">
                                            ${refund.refundRequestDate}
                                        </c:when>
                                        <c:otherwise>N/A</c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="action-buttons">
                                    <a href="${pageContext.request.contextPath}/admin/refund?action=detail&refundId=${refund.refundId}" 
                                       class="btn btn-primary">
                                        <i class="fas fa-eye"></i>
                                        Chi tiết
                                    </a>
                                    
                                    <c:if test="${refund.refundStatus == 'pending'}">
                                        <form method="post" action="${pageContext.request.contextPath}/admin/refund" 
                                              style="display: inline;" class="refund-action-form">
                                            <input type="hidden" name="action" value="approve">
                                            <input type="hidden" name="refundId" value="${refund.refundId}">
                                            <button type="submit" class="btn btn-success" 
                                                    onclick="return handleRefundAction(this, 'Bạn có chắc chắn muốn phê duyệt yêu cầu hoàn tiền này?')">
                                                <i class="fas fa-check"></i>
                                                Phê duyệt
                                            </button>
                                        </form>
                                        
                                        <form method="post" action="${pageContext.request.contextPath}/admin/refund" 
                                              style="display: inline;" class="refund-action-form">
                                            <input type="hidden" name="action" value="reject">
                                            <input type="hidden" name="refundId" value="${refund.refundId}">
                                            <button type="submit" class="btn btn-danger" 
                                                    onclick="return handleRefundAction(this, 'Bạn có chắc chắn muốn từ chối yêu cầu hoàn tiền này?')">
                                                <i class="fas fa-times"></i>
                                                Từ chối
                                            </button>
                                        </form>
                                    </c:if>
                                    
                                    <c:if test="${refund.refundStatus == 'approved'}">
                                        <form method="post" action="${pageContext.request.contextPath}/admin/refund" 
                                              style="display: inline;" class="refund-action-form">
                                            <input type="hidden" name="action" value="complete">
                                            <input type="hidden" name="refundId" value="${refund.refundId}">
                                            <button type="submit" class="btn btn-warning" 
                                                    onclick="return handleRefundAction(this, 'Bạn có chắc chắn muốn hoàn thành xử lý yêu cầu hoàn tiền này?')">
                                                <i class="fas fa-check-double"></i>
                                                Hoàn thành
                                            </button>
                                        </form>
                                    </c:if>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Phân trang -->
            <c:if test="${totalPages > 1}">
                <div class="pagination">
                    <div class="pagination-info">
                        <i class="fas fa-info-circle"></i>
                        Hiển thị ${(currentPage - 1) * pageSize + 1} - ${currentPage * pageSize > totalRefunds ? totalRefunds : currentPage * pageSize} 
                        trong tổng số ${totalRefunds} yêu cầu
                    </div>
                    
                    <div class="pagination-controls">
                        <!-- Nút First Page -->
                        <c:if test="${currentPage > 1}">
                            <a href="${pageContext.request.contextPath}/admin/refund?page=1&search=${searchTerm}&status=${statusFilter}&amount=${amountFilter}&reason=${reasonFilter}" 
                               class="page-link prev" title="Trang đầu">
                                <i class="fas fa-angle-double-left"></i>
                            </a>
                        </c:if>
                        
                        <!-- Nút Previous -->
                        <c:if test="${currentPage > 1}">
                            <a href="${pageContext.request.contextPath}/admin/refund?page=${currentPage - 1}&search=${searchTerm}&status=${statusFilter}&amount=${amountFilter}&reason=${reasonFilter}" 
                               class="page-link prev">
                                <i class="fas fa-chevron-left"></i>
                                Trước
                            </a>
                        </c:if>
                        
                        <!-- Dots trước -->
                        <c:if test="${startPage > 1}">
                            <span class="page-dots">...</span>
                        </c:if>
                        
                        <!-- Các nút trang -->
                        <c:forEach begin="${startPage}" end="${endPage}" var="pageNum">
                            <a href="${pageContext.request.contextPath}/admin/refund?page=${pageNum}&search=${searchTerm}&status=${statusFilter}&amount=${amountFilter}&reason=${reasonFilter}" 
                               class="page-link ${pageNum == currentPage ? 'active' : ''}">
                                ${pageNum}
                            </a>
                        </c:forEach>
                        
                        <!-- Dots sau -->
                        <c:if test="${endPage < totalPages}">
                            <span class="page-dots">...</span>
                        </c:if>
                        
                        <!-- Nút Next -->
                        <c:if test="${currentPage < totalPages}">
                            <a href="${pageContext.request.contextPath}/admin/refund?page=${currentPage + 1}&search=${searchTerm}&status=${statusFilter}&amount=${amountFilter}&reason=${reasonFilter}" 
                               class="page-link next">
                                Sau
                                <i class="fas fa-chevron-right"></i>
                            </a>
                        </c:if>
                        
                        <!-- Nút Last Page -->
                        <c:if test="${currentPage < totalPages}">
                            <a href="${pageContext.request.contextPath}/admin/refund?page=${totalPages}&search=${searchTerm}&status=${statusFilter}&amount=${amountFilter}&reason=${reasonFilter}" 
                               class="page-link next" title="Trang cuối">
                                <i class="fas fa-angle-double-right"></i>
                            </a>
                        </c:if>
                    </div>
                </div>
            </c:if>
        </main>
    </div>

    <script>
        // Global variable to track form submission
        let isSubmitting = false;
        
        // Function to handle refund actions and prevent double submission
        function handleRefundAction(button, confirmMessage) {
            // Prevent double submission
            if (isSubmitting) {
                return false;
            }
            
            // Show confirmation dialog
            if (!confirm(confirmMessage)) {
                return false;
            }
            
            // Set submitting flag
            isSubmitting = true;
            
            // Disable the button and show loading state
            const originalText = button.innerHTML;
            button.disabled = true;
            button.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang xử lý...';
            button.style.opacity = '0.7';
            button.style.cursor = 'not-allowed';
            
            // Disable all other refund action buttons
            const allRefundButtons = document.querySelectorAll('.refund-action-form button[type="submit"]');
            allRefundButtons.forEach(btn => {
                if (btn !== button) {
                    btn.disabled = true;
                    btn.style.opacity = '0.5';
                    btn.style.cursor = 'not-allowed';
                }
            });
            
            // Submit the form
            const form = button.closest('form');
            if (form) {
                form.submit();
            }
            
            // Reset flag after a timeout (in case of errors)
            setTimeout(() => {
                isSubmitting = false;
            }, 5000);
            
            return false; // Prevent default form submission
        }
        
        // Prevent form resubmission on page refresh
        if (window.history.replaceState) {
            window.history.replaceState(null, null, window.location.href);
        }
        
        // Page initialization
        document.addEventListener('DOMContentLoaded', function() {
            
            // Add loading state to pagination links
            const paginationLinks = document.querySelectorAll('.page-link');
            paginationLinks.forEach(link => {
                link.addEventListener('click', function(e) {
                    // Add loading indicator
                    this.innerHTML = '<i class="fas fa-spinner fa-spin"></i>';
                    this.style.pointerEvents = 'none';
                    
                    // Optional: Add a small delay to show loading
                    setTimeout(() => {
                        // The page will navigate anyway
                    }, 100);
                });
            });
            
            // Add keyboard navigation
            document.addEventListener('keydown', function(e) {
                const currentPage = parseInt('${currentPage}') || 1;
                const totalPages = parseInt('${totalPages}') || 1;
                
                if (e.key === 'ArrowLeft' && currentPage > 1) {
                    window.location.href = '${pageContext.request.contextPath}/admin/refund?page=' + (currentPage - 1) + '&search=${searchTerm}&status=${statusFilter}&amount=${amountFilter}&reason=${reasonFilter}';
                } else if (e.key === 'ArrowRight' && currentPage < totalPages) {
                    window.location.href = '${pageContext.request.contextPath}/admin/refund?page=' + (currentPage + 1) + '&search=${searchTerm}&status=${statusFilter}&amount=${amountFilter}&reason=${reasonFilter}';
                }
            });
        });
    </script>
</body>
</html> 