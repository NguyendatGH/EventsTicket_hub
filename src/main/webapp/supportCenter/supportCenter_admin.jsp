<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý hỗ trợ - Admin</title>
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
     
      .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem; }
      .page-title { color: #667aff; font-size: 1.5rem; font-weight: 700; }
      /* ... giữ lại các style bảng, badge, tab, ... từ file cũ ... */
      .support-tabs { display: flex; margin-bottom: 2rem; background: #21262d; border-radius: 10px; padding: 0.5rem; }
      .tab-button { background: none; border: none; color: #8b949e; padding: 1rem 2rem; cursor: pointer; border-radius: 8px; transition: all 0.3s; font-size: 1rem; }
      .tab-button.active { background: #667aff; color: white; }
      .tab-button:hover { background: #5566dd; color: white; }
      .tab-content { display: none; }
      .tab-content.active { display: block; }
      .support-table { background: #21262d; border-radius: 10px; overflow: hidden; }
      .table-header { display: grid; grid-template-columns: 2fr 1fr 1fr 1fr 1fr 120px; gap: 1rem; padding: 1rem; background: #161b22; font-weight: 600; color: #e6edf3; }
      .table-row { display: grid; grid-template-columns: 2fr 1fr 1fr 1fr 1fr 120px; gap: 1rem; padding: 1rem; border-bottom: 1px solid #30363d; align-items: center; transition: background 0.3s; }
      .table-row:hover { background: #2d3748; }
      .table-row:last-child { border-bottom: none; }
      .status-badge { padding: 0.25rem 0.75rem; border-radius: 20px; font-size: 0.875rem; font-weight: 500; text-align: center; }
      .status-pending { background: #ffcc00; color: #000; }
      .status-replied { background: #667aff; color: white; }
      .status-resolved { background: #00cc66; color: white; }
      .status-closed { background: #8b949e; color: white; }
      .priority-badge { padding: 0.25rem 0.5rem; border-radius: 12px; font-size: 0.75rem; font-weight: 500; }
      .priority-low { background: #00cc66; color: white; }
      .priority-medium { background: #ffcc00; color: #000; }
      .priority-high { background: #ff6b35; color: white; }
      .priority-urgent { background: #ff3333; color: white; }
      .action-btn { background: #667aff; color: white; border: none; padding: 0.5rem 1rem; border-radius: 6px; cursor: pointer; font-size: 0.875rem; transition: background 0.3s; }
      .action-btn:hover { background: #5566dd; }
      .action-btn.view { background: #667aff; }
      .empty-state { text-align: center; padding: 3rem; color: #8b949e; }
      .empty-state i { font-size: 3rem; margin-bottom: 1rem; color: #667aff; }
      .alert { padding: 1rem; border-radius: 6px; margin-bottom: 1rem; }
      .alert-success { background: rgba(0, 204, 102, 0.1); border: 1px solid #00cc66; color: #00cc66; }
      .alert-error { background: rgba(255, 51, 51, 0.1); border: 1px solid #ff3333; color: #ff3333; }
    </style>
</head>
<body>
  <div class="container">
    <aside class="sidebar">
      <div class="logo">EventTicketHub</div>
      <div class="admin-section">
        <div class="admin-avatar">
          <svg fill="currentColor" viewBox="0 0 24 24">
            <path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/>
          </svg>
        </div>
        <div class="admin-name">Admin</div>
        <div class="admin-role">Quản lý website EventTicketHub</div>
      </div>
       <nav>
          <ul class="nav-menu">
            <li class="nav-item">
              <a href="${pageContext.request.contextPath}/admin-servlet/dashboard" class="nav-link ">Bảng điều khiển</a>
            </li>
            <li class="nav-item">
              <a href="${pageContext.request.contextPath}/admin-servlet/event-management" class="nav-link ">Danh sách sự kiện</a>
            </li>
            <li class="nav-item">
              <a href="${pageContext.request.contextPath}/admin-servlet/user-management" class="nav-link">Danh sách tài khoản</a>
            </li>
            <li class="nav-item">
              <a href="${pageContext.request.contextPath}/admin-servlet/transaction-management" class="nav-link">Danh sách giao dịch</a>
            </li>
            <li class="nav-item">
              <a href="${pageContext.request.contextPath}/admin-servlet/owner-revenue" class="nav-link ">Doanh thu chủ sự kiện</a>
            </li>
            <li class="nav-item">
              <a href="${pageContext.request.contextPath}/admin/refund" class="nav-link ">Quản lý hoàn tiền</a>
            </li>
            <li class="nav-item">
              <a href="${pageContext.request.contextPath}/admin-servlet/support-center" class="nav-link active">Hỗ trợ khách hàng</a>
            </li>
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
      <div class="header">
        <h1 class="page-title"><i class="fas fa-headset"></i> Quản lý hỗ trợ</h1>
      </div>

        <c:if test="${not empty success}">
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i> ${success}
            </div>
        </c:if>

        <c:if test="${not empty error}">
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle"></i> ${error}
            </div>
        </c:if>

        <div class="support-tabs">
            <button class="tab-button active" onclick="showTab('all-requests')">
                <i class="fas fa-list"></i> Tất cả yêu cầu
            </button>
            <button class="tab-button" onclick="showTab('pending-requests')">
                <i class="fas fa-clock"></i> Chờ xử lý
            </button>
        </div>

        <!-- Tab: Tất cả yêu cầu -->
        <div id="all-requests" class="tab-content active">
            <div class="support-table">
                <div class="table-header">
                    <div>Tiêu đề</div>
                    <div>Người gửi</div>
                    <div>Danh mục</div>
                    <div>Mức độ</div>
                    <div>Trạng thái</div>
                    <div>Thao tác</div>
                </div>

                <c:choose>
                    <c:when test="${not empty allRequests}">
                        <c:forEach var="request" items="${allRequests}">
                            <div class="table-row">
                                <div>${request.subject}</div>
                                <div>${request.fromEmail}</div>
                                <div>${request.category}</div>
                                <div>
                                    <span class="priority-badge priority-${fn:toLowerCase(request.priority)}">
                                        <c:choose>
                                            <c:when test="${request.priority == 'LOW'}">Thấp</c:when>
                                            <c:when test="${request.priority == 'MEDIUM'}">Trung bình</c:when>
                                            <c:when test="${request.priority == 'HIGH'}">Cao</c:when>
                                            <c:when test="${request.priority == 'URGENT'}">Khẩn cấp</c:when>
                                            <c:otherwise>${request.priority}</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                                <div>
                                    <span class="status-badge status-${fn:toLowerCase(request.status)}">
                                        <c:choose>
                                            <c:when test="${request.status == 'PENDING'}">Chờ xử lý</c:when>
                                            <c:when test="${request.status == 'REPLIED'}">Đã phản hồi</c:when>
                                            <c:when test="${request.status == 'RESOLVED'}">Đã giải quyết</c:when>
                                            <c:when test="${request.status == 'CLOSED'}">Đã đóng</c:when>
                                            <c:otherwise>${request.status}</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                                <div>
                                    <button class="action-btn view" onclick="viewDetail(${request.supportId})">
                                        <i class="fas fa-eye"></i> Xem
                                    </button>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <i class="fas fa-inbox"></i>
                            <h3>Chưa có yêu cầu hỗ trợ nào</h3>
                            <p>Hiện tại chưa có yêu cầu hỗ trợ nào được gửi.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Tab: Chờ xử lý -->
        <div id="pending-requests" class="tab-content">
            <div class="support-table">
                <div class="table-header">
                    <div>Tiêu đề</div>
                    <div>Người gửi</div>
                    <div>Danh mục</div>
                    <div>Mức độ</div>
                    <div>Trạng thái</div>
                    <div>Thao tác</div>
                </div>

                <c:choose>
                    <c:when test="${not empty pendingRequests}">
                        <c:forEach var="request" items="${pendingRequests}">
                            <div class="table-row">
                                <div>${request.subject}</div>
                                <div>${request.fromEmail}</div>
                                <div>${request.category}</div>
                                <div>
                                    <span class="priority-badge priority-${fn:toLowerCase(request.priority)}">
                                        <c:choose>
                                            <c:when test="${request.priority == 'LOW'}">Thấp</c:when>
                                            <c:when test="${request.priority == 'MEDIUM'}">Trung bình</c:when>
                                            <c:when test="${request.priority == 'HIGH'}">Cao</c:when>
                                            <c:when test="${request.priority == 'URGENT'}">Khẩn cấp</c:when>
                                            <c:otherwise>${request.priority}</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                                <div>
                                    <span class="status-badge status-${fn:toLowerCase(request.status)}">
                                        <c:choose>
                                            <c:when test="${request.status == 'PENDING'}">Chờ xử lý</c:when>
                                            <c:when test="${request.status == 'REPLIED'}">Đã phản hồi</c:when>
                                            <c:when test="${request.status == 'RESOLVED'}">Đã giải quyết</c:when>
                                            <c:when test="${request.status == 'CLOSED'}">Đã đóng</c:when>
                                            <c:otherwise>${request.status}</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                                <div>
                                    <button class="action-btn view" onclick="viewDetail(${request.supportId})">
                                        <i class="fas fa-eye"></i> Xem
                                    </button>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <i class="fas fa-check-circle"></i>
                            <h3>Không có yêu cầu chờ xử lý</h3>
                            <p>Tất cả yêu cầu hỗ trợ đã được xử lý!</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </main>
  </div>

    <script>
        function showTab(tabName) {
            // Hide all tab contents
            const tabContents = document.querySelectorAll('.tab-content');
            tabContents.forEach(content => content.classList.remove('active'));
            
            // Remove active class from all tab buttons
            const tabButtons = document.querySelectorAll('.tab-button');
            tabButtons.forEach(button => button.classList.remove('active'));
            
            // Show selected tab content
            document.getElementById(tabName).classList.add('active');
            
            // Add active class to clicked button
            event.target.classList.add('active');
        }

        function viewDetail(supportId) {
            window.location.href = '${pageContext.request.contextPath}/admin-servlet/support-center?action=view-detail&id=' + supportId;
        }
    </script>
</body>
</html>