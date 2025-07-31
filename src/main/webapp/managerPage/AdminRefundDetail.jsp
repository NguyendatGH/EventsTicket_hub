<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết yêu cầu hoàn tiền - MasterTicket Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
            background-color: #070a17;
            color: white;
            min-height: 100vh;
        }

        .container {
            display: flex;
            min-height: 100vh;
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
            padding: 2rem;
            overflow-y: auto;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
        }

        .page-title {
            font-size: 2rem;
            font-weight: 700;
            color: white;
        }

        .back-btn {
            background: #6366f1;
            color: white;
            padding: 0.75rem 1.5rem;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 500;
            transition: background 0.3s ease;
        }

        .back-btn:hover {
            background: #4f46e5;
        }

        .content-section {
            background: rgba(255, 255, 255, 0.18);
            border-radius: 12px;
            padding: 2rem;
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            margin-bottom: 2rem;
        }

        .section-title {
            font-size: 1.5rem;
            font-weight: 600;
            margin-bottom: 1.5rem;
            color: white;
        }

        .refund-info {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 2rem;
            margin-bottom: 2rem;
        }

        .info-card {
            background: rgba(255, 255, 255, 0.1);
            border-radius: 8px;
            padding: 1.5rem;
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        .info-label {
            color: #94a3b8;
            font-size: 0.875rem;
            margin-bottom: 0.5rem;
        }

        .info-value {
            color: white;
            font-size: 1.125rem;
            font-weight: 500;
        }

        .status-badge {
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-size: 0.875rem;
            font-weight: 500;
            text-transform: uppercase;
            display: inline-block;
        }

        .status-pending {
            background: rgba(255, 193, 7, 0.2);
            color: #ffc107;
        }

        .status-approved {
            background: rgba(40, 167, 69, 0.2);
            color: #28a745;
        }

        .status-rejected {
            background: rgba(220, 53, 69, 0.2);
            color: #dc3545;
        }

        .reason-section {
            margin-top: 2rem;
        }

        .reason-box {
            background: rgba(255, 255, 255, 0.1);
            border-radius: 8px;
            padding: 1.5rem;
            border-left: 4px solid #6366f1;
        }

        .reason-text {
            color: white;
            line-height: 1.6;
            font-size: 1rem;
        }

        .action-section {
            margin-top: 2rem;
        }

        .action-form {
            background: rgba(255, 255, 255, 0.1);
            border-radius: 8px;
            padding: 2rem;
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-label {
            display: block;
            color: #e2e8f0;
            font-weight: 500;
            margin-bottom: 0.5rem;
        }

        .form-textarea {
            width: 100%;
            min-height: 120px;
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 8px;
            padding: 1rem;
            color: white;
            font-family: inherit;
            font-size: 1rem;
            resize: vertical;
        }

        .form-textarea:focus {
            outline: none;
            border-color: #6366f1;
        }

        .form-textarea::placeholder {
            color: #94a3b8;
        }

        .action-buttons {
            display: flex;
            gap: 1rem;
            margin-top: 2rem;
        }

        .btn {
            padding: 0.75rem 2rem;
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-approve {
            background: #10b981;
            color: white;
        }

        .btn-approve:hover {
            background: #059669;
        }

        .btn-reject {
            background: #ef4444;
            color: white;
        }

        .btn-reject:hover {
            background: #dc2626;
        }

        .btn-cancel {
            background: #6b7280;
            color: white;
        }

        .btn-cancel:hover {
            background: #4b5563;
        }

        .alert {
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 1rem;
        }

        .alert-success {
            background: rgba(40, 167, 69, 0.2);
            border: 1px solid #28a745;
            color: #28a745;
        }

        .alert-error {
            background: rgba(220, 53, 69, 0.2);
            border: 1px solid #dc3545;
            color: #dc3545;
        }

        @media (max-width: 768px) {
            .container {
                flex-direction: column;
            }
            
            .sidebar {
                width: 100%;
                height: auto;
            }
            
            .main-content {
                padding: 1rem;
            }
            
            .refund-info {
                grid-template-columns: 1fr;
            }
            
            .action-buttons {
                flex-direction: column;
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
              <a href="${pageContext.request.contextPath}/admin-servlet/dashboard" class="nav-link">Bảng điều khiển</a>
            </li>
            <li class="nav-item">
              <a href="${pageContext.request.contextPath}/admin-servlet/event-management" class="nav-link">Danh sách sự kiện</a>
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
              <a href="${pageContext.request.contextPath}/admin/refund" class="nav-link active">Quản lý hoàn tiền</a>
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
            <div class="header">
                <h1 class="page-title">
                    <i class="fas fa-undo-alt"></i>
                    Chi tiết yêu cầu hoàn tiền
                </h1>
                <a href="${pageContext.request.contextPath}/admin/refund" class="back-btn">
                    <i class="fas fa-arrow-left"></i>
                    Quay lại
                </a>
            </div>

            <c:if test="${not empty success}">
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i>
                    ${success}
                </div>
            </c:if>

            <c:if test="${not empty error}">
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle"></i>
                    ${error}
                </div>
            </c:if>

            <c:if test="${not empty refund}">
                <div class="content-section">
                    <h2 class="section-title">
                        <i class="fas fa-info-circle"></i>
                        Thông tin yêu cầu hoàn tiền
                    </h2>

                    <div class="refund-info">
                        <div class="info-card">
                            <div class="info-label">ID yêu cầu</div>
                            <div class="info-value">#${refund.refundId}</div>
                        </div>

                        <div class="info-card">
                            <div class="info-label">Khách hàng</div>
                            <div class="info-value">${refund.userName != null ? refund.userName : 'N/A'}</div>
                        </div>

                        <div class="info-card">
                            <div class="info-label">Mã đơn hàng</div>
                            <div class="info-value">${refund.orderNumber != null ? refund.orderNumber : 'N/A'}</div>
                        </div>

                        <div class="info-card">
                            <div class="info-label">Số tiền hoàn</div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${refund.refundAmount != null and refund.refundAmount > 0}">
                                        ${refund.refundAmount} ₫
                                    </c:when>
                                    <c:otherwise>N/A</c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <div class="info-card">
                            <div class="info-label">Ngày yêu cầu</div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${refund.refundRequestDate != null}">
                                        ${refund.refundRequestDate}
                                    </c:when>
                                    <c:otherwise>N/A</c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <div class="info-card">
                            <div class="info-label">Trạng thái</div>
                            <div class="info-value">
                                <span class="status-badge status-${refund.refundStatus}">
                                    ${refund.refundStatus == 'pending' ? 'Chờ xử lý' : 
                                      refund.refundStatus == 'approved' ? 'Đã phê duyệt' : 'Đã từ chối'}
                                </span>
                            </div>
                        </div>
                    </div>

                    <div class="reason-section">
                        <h3 style="color: #e2e8f0; margin-bottom: 1rem;">
                            <i class="fas fa-comment"></i>
                            Lý do yêu cầu hoàn tiền
                        </h3>
                        <div class="reason-box">
                            <div class="reason-text">${refund.refundReason != null ? refund.refundReason : 'Không có lý do'}</div>
                        </div>
                    </div>

                    <c:if test="${refund.refundStatus == 'pending'}">
                        <div class="action-section">
                            <h3 style="color: #e2e8f0; margin-bottom: 1rem;">
                                <i class="fas fa-cogs"></i>
                                Xử lý yêu cầu
                            </h3>
                            <div class="action-form">
                                <form action="${pageContext.request.contextPath}/admin/refund" method="post">
                                    <input type="hidden" name="refundId" value="${refund.refundId}" />
                                    
                                    <div class="form-group">
                                        <label for="adminNote" class="form-label">
                                            <i class="fas fa-edit"></i>
                                            Ghi chú của admin (tùy chọn)
                                        </label>
                                        <textarea 
                                            id="adminNote" 
                                            name="adminNote" 
                                            class="form-textarea"
                                            placeholder="Nhập ghi chú hoặc lý do phê duyệt/từ chối yêu cầu hoàn tiền..."
                                        ></textarea>
                                    </div>

                                    <div class="action-buttons">
                                        <button type="submit" name="action" value="approve" class="btn btn-approve">
                                            <i class="fas fa-check"></i>
                                            Phê duyệt
                                        </button>
                                        <button type="submit" name="action" value="reject" class="btn btn-reject">
                                            <i class="fas fa-times"></i>
                                            Từ chối
                                        </button>
                                        <a href="${pageContext.request.contextPath}/admin/refund" class="btn btn-cancel">
                                            <i class="fas fa-arrow-left"></i>
                                            Hủy
                                        </a>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </c:if>

                    <c:if test="${refund.refundStatus != 'pending'}">
                        <div class="action-section">
                            <h3 style="color: #e2e8f0; margin-bottom: 1rem;">
                                <i class="fas fa-history"></i>
                                Thông tin xử lý
                            </h3>
                            <div class="info-card">
                                <div class="info-label">Ngày xử lý</div>
                                <div class="info-value">
                                    <c:choose>
                                        <c:when test="${refund.refundProcessedDate != null}">
                                            ${refund.refundProcessedDate}
                                        </c:when>
                                        <c:otherwise>N/A</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </c:if>
                </div>
            </c:if>

            <c:if test="${empty refund}">
                <div class="content-section">
                    <div style="text-align: center; padding: 3rem; color: #94a3b8;">
                        <i class="fas fa-exclamation-triangle" style="font-size: 3rem; margin-bottom: 1rem; opacity: 0.5;"></i>
                        <h3>Không tìm thấy yêu cầu hoàn tiền</h3>
                        <p>Yêu cầu hoàn tiền này có thể đã bị xóa hoặc không tồn tại.</p>
                        <a href="${pageContext.request.contextPath}/admin/refund" class="btn btn-cancel" style="margin-top: 1rem;">
                            <i class="fas fa-arrow-left"></i>
                            Quay lại danh sách
                        </a>
                    </div>
                </div>
            </c:if>
        </main>
    </div>
</body>
</html> 