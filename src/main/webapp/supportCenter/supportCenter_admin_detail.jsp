<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết yêu cầu hỗ trợ - Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
      * { margin: 0; padding: 0; box-sizing: border-box; }
      body {
        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
        position: relative;
        background-color: #070a17;
        min-height: 100vh;
        overflow-x: hidden;
      }
      .container { display: flex; min-height: 100vh; position: relative; z-index: 1; }
      .sidebar {
        width: 16%; background: rgba(15,23,42,0.9); backdrop-filter: blur(20px);
        border-right: 1px solid #4d4d4d; padding: 2rem 0; transition: transform 0.3s; z-index: 1100;
      }
      .logo { color: white; font-size: 1.5rem; font-weight: 700; margin-bottom: 5rem; padding: 0 2rem; }
      .admin-section { padding: 0 2rem; margin-bottom: 3rem; }
      .admin-avatar { width: 120px; height: 120px; background: rgba(71,85,105,0.8); border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 2rem; }
      .admin-avatar svg { width: 80px; height: 80px; color: #94a3b8; }
      .admin-name { color: white; font-size: 24px; font-weight: 600; text-align: center; margin-bottom: 0.5rem; }
      .admin-role { color: #94a3b8; font-size: 0.875rem; text-align: center; }
      .nav-menu { list-style: none; }
      .nav-item { border-bottom: 1px solid rgba(15,23,42,0.14); }
      .nav-link { display: block; color: white; background-color: rgba(255,255,255,0.18); text-decoration: none; padding: 1rem 2rem; font-weight: 500; transition: all 0.3s; position: relative; }
      .nav-link.active { background: rgba(255,255,255,0.05); color: white; }
      .nav-link:hover { color: white; background: rgba(255,255,255,0.05); }
      .logout { position: absolute; bottom: 2rem; left: 2rem; right: 2rem; color: #94a3b8; text-decoration: none; display: flex; align-items: center; gap: 0.5rem; font-weight: 500; transition: color 0.3s; }
      .logout:hover { color: white; }
      .main-content { flex: 1; padding: 0 94px; padding-top: 2rem; overflow-y: auto; display: flex; flex-direction: column; gap: 2rem; }
      .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem; }
      .page-title { color: #667aff; font-size: 1.5rem; font-weight: 700; }
      .card { background: #161b22; border-radius: 12px; padding: 2rem 1.5rem; margin-bottom: 2rem; box-shadow: 0 2px 8px rgba(0,0,0,0.10); }
      .row { display: flex; margin-bottom: 1.2rem; }
      .row .label { width: 160px; color: #8b949e; font-weight: 500; }
      .row .value { flex: 1; color: #e6edf3; }
      .badge { display: inline-block; padding: 0.25rem 0.9rem; border-radius: 20px; font-size: 0.95rem; font-weight: 500; margin-right: 0.5rem; }
      .status-pending { background: #ffcc00; color: #000; }
      .status-replied { background: #667aff; color: #fff; }
      .status-resolved { background: #00cc66; color: #fff; }
      .status-closed { background: #8b949e; color: #fff; }
      .priority-low { background: #00cc66; color: #fff; }
      .priority-medium { background: #ffcc00; color: #000; }
      .priority-high { background: #ff6b35; color: #fff; }
      .priority-urgent { background: #ff3333; color: #fff; }
      .content-section { background: #232b36; border-radius: 8px; padding: 1.2rem 1rem; margin: 1.2rem 0; }
      .content-section h3 { color: #667aff; margin-bottom: 0.7rem; font-size: 1.1rem; }
      .content-text { line-height: 1.7; color: #e6edf3; }
      .admin-response-form { background: #232b36; border-radius: 10px; padding: 2rem 1.5rem; margin-bottom: 2rem; }
      .form-group { margin-bottom: 1.2rem; }
      .form-group label { display: block; margin-bottom: 0.5rem; color: #e6edf3; font-weight: 500; }
      .form-group textarea { width: 100%; padding: 0.8rem; border: 1px solid #30363d; border-radius: 6px; background: #161b22; color: #e6edf3; font-size: 1rem; resize: vertical; min-height: 100px; }
      .form-group textarea:focus { outline: none; border-color: #667aff; }
      .action-buttons { display: flex; gap: 1rem; margin-top: 1.2rem; }
      .action-btn { padding: 0.7rem 1.5rem; border: none; border-radius: 8px; cursor: pointer; font-size: 1rem; font-weight: 500; transition: background 0.3s; display: flex; align-items: center; gap: 8px; }
      .action-btn.reply { background: #667aff; color: #fff; }
      .action-btn.reply:hover { background: #5566dd; }
      .action-btn.resolve { background: #00cc66; color: #fff; }
      .action-btn.resolve:hover { background: #00b359; }
      .action-btn.close { background: #8b949e; color: #fff; }
      .action-btn.close:hover { background: #7a8288; }
      
      /* Attachment styles */
      .attachments-list { margin-top: 1rem; }
      .attachment-item {
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 1rem;
        background: #161b22;
        border: 1px solid #30363d;
        border-radius: 8px;
        margin-bottom: 0.75rem;
        transition: all 0.3s;
      }
      .attachment-item:hover {
        background: #1c2128;
        border-color: #667aff;
      }
      .attachment-info {
        display: flex;
        align-items: center;
        gap: 1rem;
        flex: 1;
      }
      .attachment-icon {
        font-size: 1.5rem;
        color: #667aff;
        width: 40px;
        text-align: center;
      }
      .attachment-details {
        flex: 1;
      }
      .attachment-name {
        color: #e6edf3;
        font-weight: 500;
        margin-bottom: 0.25rem;
        word-break: break-word;
      }
      .attachment-meta {
        display: flex;
        gap: 1rem;
        font-size: 0.875rem;
        color: #8b949e;
      }
      .attachment-actions {
        display: flex;
        gap: 0.5rem;
      }
      .attachment-btn {
        display: flex;
        align-items: center;
        justify-content: center;
        width: 40px;
        height: 40px;
        border-radius: 6px;
        text-decoration: none;
        transition: all 0.3s;
        font-size: 1rem;
      }
      .attachment-btn.download {
        background: #667aff;
        color: white;
      }
      .attachment-btn.download:hover {
        background: #5566dd;
      }
      .attachment-btn.view {
        background: #00cc66;
        color: white;
      }
      .attachment-btn.view:hover {
        background: #00b359;
      }
      
      .alert { padding: 1rem; border-radius: 6px; margin-bottom: 1rem; }
      .alert-success { background: rgba(0,204,102,0.1); border: 1px solid #00cc66; color: #00cc66; }
      .alert-error { background: rgba(255,51,51,0.1); border: 1px solid #ff3333; color: #ff3333; }
      @media (max-width: 700px) { .main-content { padding: 0 10px; } .card, .admin-response-form { padding: 1rem 0.5rem; } .header h1 { font-size: 1.1rem; } .row .label { width: 100px; } }
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
          <li class="nav-item"><a href="${pageContext.request.contextPath}/admin-servlet/transaction-management" class="nav-link">Danh sách giao dịch</a></li>
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
      <div class="header">
        <h1 class="page-title"><i class="fas fa-headset"></i> Chi tiết yêu cầu hỗ trợ</h1>
      </div>
      <c:if test="${not empty success}">
        <div class="alert alert-success"><i class="fas fa-check-circle"></i> ${success}</div>
      </c:if>
      <c:if test="${not empty error}">
        <div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> ${error}</div>
      </c:if>
      <c:if test="${not empty supportItem}">
        <div class="card">
          
          <div class="row"><div class="label">Tiêu đề:</div><div class="value">${supportItem.subject}</div></div>
          <div class="row"><div class="label">Người gửi:</div><div class="value">${supportItem.fromEmail}</div></div>
          <div class="row"><div class="label">Danh mục:</div><div class="value">${supportItem.category}</div></div>
          <div class="row"><div class="label">Mức độ ưu tiên:</div><div class="value"><span class="badge priority-${fn:toLowerCase(supportItem.priority)}"><c:choose><c:when test="${supportItem.priority == 'LOW'}">Thấp</c:when><c:when test="${supportItem.priority == 'MEDIUM'}">Trung bình</c:when><c:when test="${supportItem.priority == 'HIGH'}">Cao</c:when><c:when test="${supportItem.priority == 'URGENT'}">Khẩn cấp</c:when><c:otherwise>${supportItem.priority}</c:otherwise></c:choose></span></div></div>
          <div class="row"><div class="label">Trạng thái:</div><div class="value"><span class="badge status-${fn:toLowerCase(supportItem.status)}"><c:choose><c:when test="${supportItem.status == 'PENDING'}">Chờ xử lý</c:when><c:when test="${supportItem.status == 'REPLIED'}">Đã phản hồi</c:when><c:when test="${supportItem.status == 'RESOLVED'}">Đã giải quyết</c:when><c:when test="${supportItem.status == 'CLOSED'}">Đã đóng</c:when><c:otherwise>${supportItem.status}</c:otherwise></c:choose></span></div></div>
          <div class="row"><div class="label">Thời gian gửi:</div><div class="value">${supportItem.getFormattedSendDate()}</div></div>
          <c:if test="${not empty supportItem.assignedAdmin}"><div class="row"><div class="label">Admin phụ trách:</div><div class="value">${supportItem.assignedAdmin}</div></div></c:if>
          <div class="content-section"><h3><i class="fas fa-comment"></i> Nội dung yêu cầu</h3><div class="content-text">${supportItem.content}</div></div>
          
          
          
          
          <!-- Hiển thị file đính kèm -->
          <c:if test="${not empty supportItem.attachments}">
            <div class="content-section">
              <h3><i class="fas fa-paperclip"></i> Tệp đính kèm</h3>
              <div class="attachments-list">
                <c:forEach var="attachment" items="${supportItem.attachments}">
                  <div class="attachment-item">
                    <div class="attachment-info">
                      <i class="attachment-icon ${attachment.iconClass}"></i>
                      <div class="attachment-details">
                        <div class="attachment-name">${attachment.originalFileName}</div>
                        <div class="attachment-meta">
                          <span class="attachment-size">${attachment.formattedFileSize}</span>
                          <span class="attachment-date">${attachment.formattedUploadDate}</span>
                        </div>
                      </div>
                    </div>
                    <div class="attachment-actions">
                      <a href="${pageContext.request.contextPath}/admin/support?action=download&fileId=${attachment.attachmentId}" 
                         class="attachment-btn download" title="Tải xuống">
                        <i class="fas fa-download"></i>
                      </a>
                      <a href="${pageContext.request.contextPath}/admin/support?action=view&fileId=${attachment.attachmentId}" 
                         class="attachment-btn view" title="Xem file" target="_blank">
                        <i class="fas fa-eye"></i>
                      </a>
                    </div>
                  </div>
                </c:forEach>
              </div>
            </div>
          </c:if>
          
          <c:if test="${not empty supportItem.adminResponse}"><div class="content-section"><h3><i class="fas fa-reply"></i> Phản hồi từ Admin</h3><div class="content-text">${supportItem.adminResponse}</div></div></c:if>
        </div>
        <div class="admin-response-form">
          <h2 style="color:#667aff; margin-bottom:1rem;"><i class="fas fa-edit"></i> Phản hồi yêu cầu</h2>
          <form action="${pageContext.request.contextPath}/admin/support" method="post">
            <input type="hidden" name="supportId" value="${supportItem.supportId}">
            <div class="form-group">
              <label for="adminResponse">Nội dung phản hồi *</label>
              <textarea id="adminResponse" name="adminResponse" required placeholder="Nhập nội dung phản hồi cho người dùng...">${supportItem.adminResponse}</textarea>
            </div>
            <div class="action-buttons">
              <button type="submit" name="action" value="reply" class="action-btn reply"><i class="fas fa-reply"></i> Phản hồi</button>
              <button type="submit" name="action" value="resolve" class="action-btn resolve"><i class="fas fa-check"></i> Giải quyết</button>
              <button type="submit" name="action" value="close" class="action-btn close"><i class="fas fa-times"></i> Đóng</button>
            </div>
          </form>
        </div>
      </c:if>
      <c:if test="${empty supportItem}">
        <div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> Không tìm thấy yêu cầu hỗ trợ!</div>
      </c:if>
    </main>
  </div>
</body>
</html>