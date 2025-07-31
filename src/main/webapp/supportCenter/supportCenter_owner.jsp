<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hỗ trợ chủ sự kiện - EventTicketHub</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: linear-gradient(135deg, #122536 0%, #764ba2 100%); min-height: 100vh; color: #fff; }
        .sidebar { position: fixed; left: 0; top: 0; width: 250px; height: 100vh; background: rgba(0,0,0,0.3); backdrop-filter: blur(10px); padding: 20px; z-index: 1000; }
        .sidebar .brand { color: #4CAF50; font-size: 20px; font-weight: bold; margin-bottom: 30px; display: flex; align-items: center; gap: 10px; }
        .sidebar .menu { list-style: none; }
        .sidebar .menu li { margin-bottom: 15px; }
        .sidebar .menu a { color: #d8cbcb; text-decoration: none; display: flex; align-items: center; gap: 10px; padding: 10px; border-radius: 5px; transition: all 0.3s; }
        .sidebar .menu a:hover, .sidebar .menu a.active { background: rgba(76, 175, 80, 0.2); color: #4CAF50; transform: translateX(5px); }
        .sidebar .menu a.support-active { background: #667aff; color: #fff; }
        .main-content { margin-left: 270px; padding: 20px; }
        .navbar { display: flex; justify-content: space-between; align-items: center; padding: 15px 0; border-bottom: 1px solid rgba(255,255,255,0.1); margin-bottom: 30px; }
        .navbar .nav-links { display: flex; gap: 30px; list-style: none; }
        .navbar .nav-links a { color: #fff; text-decoration: none; opacity: 0.8; transition: all 0.3s; padding: 8px 16px; border-radius: 20px; }
        .navbar .nav-links a:hover, .navbar .nav-links a.active { opacity: 1; color: #4CAF50; background: rgba(76, 175, 80, 0.1); }
        .navbar .user-info { display: flex; align-items: center; gap: 15px; }
        .btn { padding: 10px 20px; border: none; border-radius: 5px; cursor: pointer; font-size: 14px; transition: all 0.3s; text-decoration: none; display: inline-block; }
        .btn-primary { background: #4CAF50; color: white; }
        .btn-primary:hover { background: #45a049; transform: translateY(-2px); box-shadow: 0 4px 12px rgba(76, 175, 80, 0.3); }
        .btn-logout { background: linear-gradient(45deg, #ff6b6b, #ee5a24); color: white; border-radius: 20px; padding: 8px 16px; font-size: 12px; }
        .btn-logout:hover { transform: translateY(-2px); box-shadow: 0 4px 12px rgba(255, 107, 107, 0.3); }
        /* Support page specific styles below */
        .container { max-width: 900px; margin: 0 auto; padding: 2rem; }
        .header { text-align: center; margin-bottom: 3rem; }
        .header h1 { font-size: 2.5rem; color: #667aff; margin-bottom: 1rem; }
        .header p { font-size: 1.1rem; color: #8b949e; }
        .support-tabs { display: flex; justify-content: center; margin-bottom: 2rem; background: #21262d; border-radius: 10px; padding: 0.5rem; }
        .tab-button { background: none; border: none; color: #8b949e; padding: 1rem 2rem; cursor: pointer; border-radius: 8px; transition: all 0.3s; font-size: 1rem; }
        .tab-button.active { background: #667aff; color: white; }
        .tab-button:hover { background: #5566dd; color: white; }
        .tab-content { display: none; }
        .tab-content.active { display: block; }
        .support-form { background: #21262d; padding: 2rem; border-radius: 10px; margin-bottom: 2rem; }
        .form-group { margin-bottom: 1.5rem; }
        .form-group label { display: block; margin-bottom: 0.5rem; color: #e6edf3; font-weight: 500; }
        .form-group input, .form-group select, .form-group textarea { width: 100%; padding: 0.75rem; border: 1px solid #30363d; border-radius: 6px; background: #161b22; color: #e6edf3; font-size: 1rem; }
        .form-group textarea { resize: vertical; min-height: 120px; }
        .form-group input:focus, .form-group select:focus, .form-group textarea:focus { outline: none; border-color: #667aff; }
        .submit-btn { background: #667aff; color: white; border: none; padding: 1rem 2rem; border-radius: 6px; cursor: pointer; font-size: 1rem; font-weight: 500; transition: background 0.3s; }
        .submit-btn:hover { background: #5566dd; }
        .support-requests { background: #21262d; border-radius: 10px; overflow: hidden; }
        .request-item { padding: 1.5rem; border-bottom: 1px solid #30363d; transition: background 0.3s; }
        .request-item:last-child { border-bottom: none; }
        .request-item:hover { background: #2d3748; }
        .request-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem; }
        .request-subject { font-size: 1.1rem; font-weight: 600; color: #e6edf3; }
        .request-status { padding: 0.25rem 0.75rem; border-radius: 20px; font-size: 0.875rem; font-weight: 500; }
        .status-pending { background: #ffcc00; color: #000; }
        .status-replied { background: #667aff; color: white; }
        .status-resolved { background: #00cc66; color: white; }
        .status-closed { background: #8b949e; color: white; }
        .request-meta { display: flex; gap: 2rem; margin-bottom: 1rem; font-size: 0.875rem; color: #8b949e; }
        .request-content { color: #e6edf3; line-height: 1.6; }
        .admin-response { margin-top: 1rem; padding: 1rem; background: #161b22; border-radius: 6px; border-left: 4px solid #667aff; }
        .admin-response h4 { color: #667aff; margin-bottom: 0.5rem; }
        .alert { padding: 1rem; border-radius: 6px; margin-bottom: 1rem; }
        .alert-success { background: rgba(0, 204, 102, 0.1); border: 1px solid #00cc66; color: #00cc66; }
        .alert-error { background: rgba(255, 51, 51, 0.1); border: 1px solid #ff3333; color: #ff3333; }
        .empty-state { text-align: center; padding: 3rem; color: #8b949e; }
        .empty-state i { font-size: 3rem; margin-bottom: 1rem; color: #667aff; }
        
        /* File upload styles */
        .file-input {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid #30363d;
            border-radius: 6px;
            background: #161b22;
            color: #e6edf3;
            font-size: 1rem;
        }

        .file-info {
            margin-top: 0.5rem;
            color: #8b949e;
            font-size: 0.875rem;
        }

        .file-info small {
            display: block;
            margin-bottom: 0.25rem;
        }

        .file-list {
            margin-top: 1rem;
        }

        .file-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0.75rem;
            background: #161b22;
            border: 1px solid #30363d;
            border-radius: 6px;
            margin-bottom: 0.5rem;
        }

        .file-item-info {
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .file-icon {
            font-size: 1.25rem;
            color: #667aff;
        }

        .file-details {
            flex: 1;
        }

        .file-name {
            color: #e6edf3;
            font-weight: 500;
            margin-bottom: 0.25rem;
        }

        .file-size {
            color: #8b949e;
            font-size: 0.875rem;
        }

        .file-remove {
            background: #dc3545;
            color: white;
            border: none;
            padding: 0.5rem;
            border-radius: 4px;
            cursor: pointer;
            font-size: 0.875rem;
            transition: background 0.3s;
        }

        .file-remove:hover {
            background: #c82333;
        }

        .attachment-list {
            margin-top: 1rem;
        }

        .attachment-item {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            padding: 0.5rem;
            background: #161b22;
            border-radius: 4px;
            margin-bottom: 0.5rem;
        }

        .attachment-icon {
            color: #667aff;
            font-size: 1rem;
        }

        .attachment-name {
            color: #e6edf3;
            font-size: 0.875rem;
        }

        .attachment-download {
            color: #667aff;
            text-decoration: none;
            font-size: 0.875rem;
        }

        .attachment-download:hover {
            text-decoration: underline;
        }
        
        @media (max-width: 768px) { .sidebar { transform: translateX(-100%); transition: transform 0.3s; } .main-content { margin-left: 0; } }
    </style>
</head>
<body>
    <!-- Sidebar -->
    <div class="sidebar">
        <div class="brand">🎟️ EventTicketHub</div>
        <ul class="menu">
            <li><a href="#">📅 My Events</a></li>
            <li><a href="#">📊 Manage Reports</a></li>
            <li><a href="#">📋 Rules</a></li>
            <li><a href="#">⚙️ Settings</a></li>
            <li><a href="#">📈 Analytics</a></li>
            <li><a href="${pageContext.request.contextPath}/support-owner" class="support-active">🎧 Support</a></li>
        </ul>
    </div>
    <!-- Main Content -->
    <div class="main-content">
        <!-- Navigation -->
        <nav class="navbar">
            <div class="nav-links">
                <a href="#">Home</a>
                <a href="#">Shows</a>
                <a href="#">Offers & Discount</a>
                <a href="#">Dashboard</a>
                <button class="chat-btn" onclick="window.location.href = '${pageContext.request.contextPath}/chat'">
                    💬 Go to Chat
                </button>
            </div>
            <div class="user-info">
                <span>Welcome, Event Manager</span>
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-logout">Logout</a>
            </div>
        </nav>
        <!-- Support Center Content -->
        <div class="container">
            <div class="header">
                <h1><i class="fas fa-headset"></i> Hỗ trợ dành cho chủ sự kiện</h1>
                <p>Gửi yêu cầu hỗ trợ tới admin nếu bạn gặp khó khăn khi quản lý sự kiện.</p>
            </div>
            <c:if test="${not empty success}">
                <div class="alert alert-success"><i class="fas fa-check-circle"></i> ${success}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> ${error}</div>
            </c:if>
            <div class="support-tabs">
                <button class="tab-button active" onclick="showTab('new-request')"><i class="fas fa-plus"></i> Gửi yêu cầu mới</button>
                <button class="tab-button" onclick="showTab('my-requests')"><i class="fas fa-list"></i> Yêu cầu của tôi</button>
            </div>
            <!-- Tab: Gửi yêu cầu mới -->
            <div id="new-request" class="tab-content active">
                <div class="support-form">
                    <h2><i class="fas fa-edit"></i> Gửi yêu cầu hỗ trợ</h2>
                    <form action="${pageContext.request.contextPath}/support-owner" method="post" enctype="multipart/form-data">
                        <input type="hidden" name="action" value="submit-request">
                        <div class="form-group">
                            <label for="subject">Tiêu đề *</label>
                            <input type="text" id="subject" name="subject" required placeholder="Nhập tiêu đề yêu cầu hỗ trợ...">
                        </div>
                        <div class="form-group">
                            <label for="category">Danh mục</label>
                            <select id="category" name="category">
                                <option value="GENERAL">Chung</option>
                                <option value="TECHNICAL">Kỹ thuật</option>
                                <option value="PAYMENT">Thanh toán</option>
                                <option value="EVENT">Sự kiện</option>
                                <option value="ACCOUNT">Tài khoản</option>
                                <option value="OTHER">Khác</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="priority">Mức độ ưu tiên</label>
                            <select id="priority" name="priority">
                                <option value="LOW">Thấp</option>
                                <option value="MEDIUM" selected>Trung bình</option>
                                <option value="HIGH">Cao</option>
                                <option value="URGENT">Khẩn cấp</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="content">Nội dung *</label>
                            <textarea id="content" name="content" required placeholder="Mô tả chi tiết vấn đề của bạn..."></textarea>
                        </div>
                        <div class="form-group">
                            <label for="attachments">Tệp đính kèm</label>
                            <input type="file" id="attachments" name="attachments" multiple 
                                   accept=".jpg,.jpeg,.png,.gif,.bmp,.pdf,.doc,.docx,.txt,.zip,.rar,.exe"
                                   class="file-input">
                            <div class="file-info">
                                <small>Hỗ trợ: Ảnh (JPG, PNG, GIF), Tài liệu (PDF, DOC, DOCX, TXT), Nén (ZIP, RAR), Thực thi (EXE)</small>
                                <small>Tối đa 5 file, mỗi file tối đa 10MB</small>
                            </div>
                            <div id="file-list" class="file-list"></div>
                        </div>
                        <button type="submit" class="submit-btn">
                            <i class="fas fa-paper-plane"></i> Gửi yêu cầu
                        </button>
                    </form>
                </div>
            </div>
            <!-- Tab: Yêu cầu của tôi -->
            <div id="my-requests" class="tab-content">
                <div class="support-requests">
                    <c:choose>
                        <c:when test="${not empty supportRequests}">
                            <c:forEach var="request" items="${supportRequests}">
                                <div class="request-item">
                                    <div class="request-header">
                                        <div class="request-subject">${request.subject}</div>
                                        <span class="request-status status-${fn:toLowerCase(request.status)}">
                                            <c:choose>
                                                <c:when test="${request.status == 'PENDING'}">Chờ xử lý</c:when>
                                                <c:when test="${request.status == 'REPLIED'}">Đã phản hồi</c:when>
                                                <c:when test="${request.status == 'RESOLVED'}">Đã giải quyết</c:when>
                                                <c:when test="${request.status == 'CLOSED'}">Đã đóng</c:when>
                                                <c:otherwise>${request.status}</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                    <div class="request-meta">
                                        <span><i class="fas fa-calendar"></i> ${request.getFormattedSendDate()}</span>
                                        <span><i class="fas fa-tag"></i> ${request.category}</span>
                                        <span><i class="fas fa-flag"></i> ${request.priority}</span>
                                    </div>
                                    <div class="request-content">${request.content}</div>

                                    <!-- Hiển thị file đính kèm -->
                                    <c:if test="${not empty request.attachments}">
                                        <div class="attachment-list">
                                            <h4><i class="fas fa-paperclip"></i> Tệp đính kèm:</h4>
                                            <c:forEach var="attachment" items="${request.attachments}">
                                                <div class="attachment-item">
                                                    <i class="attachment-icon ${attachment.iconClass}"></i>
                                                    <span class="attachment-name">${attachment.originalFileName}</span>
                                                    <a href="${pageContext.request.contextPath}/support-owner?action=download&fileId=${attachment.attachmentId}" 
                                                       class="attachment-download">
                                                        <i class="fas fa-download"></i> Tải xuống
                                                    </a>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </c:if>

                                    <c:if test="${not empty request.adminResponse}">
                                        <div class="admin-response">
                                            <h4><i class="fas fa-reply"></i> Phản hồi từ Admin</h4>
                                            <p>${request.adminResponse}</p>
                                            <small>Phản hồi bởi: ${request.assignedAdmin}</small>
                                        </div>
                                    </c:if>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-state">
                                <i class="fas fa-inbox"></i>
                                <h3>Chưa có yêu cầu hỗ trợ nào</h3>
                                <p>Bạn chưa gửi yêu cầu hỗ trợ nào. Hãy tạo yêu cầu mới nếu cần hỗ trợ!</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
    <script>
        function showTab(tabName) {
            const tabContents = document.querySelectorAll('.tab-content');
            tabContents.forEach(content => content.classList.remove('active'));
            const tabButtons = document.querySelectorAll('.tab-button');
            tabButtons.forEach(button => button.classList.remove('active'));
            document.getElementById(tabName).classList.add('active');
            event.target.classList.add('active');
        }

        // File upload handling
        document.getElementById('attachments').addEventListener('change', function(e) {
            console.log('File input changed');
            const fileList = document.getElementById('file-list');
            fileList.innerHTML = '';
            
            const files = e.target.files;
            console.log('Number of files selected:', files.length);
            
            if (files.length > 5) {
                alert('Chỉ được chọn tối đa 5 file!');
                e.target.value = '';
                return;
            }
            
            for (let i = 0; i < files.length; i++) {
                const file = files[i];
                console.log('Processing file:', file.name, 'Size:', file.size);
                
                // Check file size (10MB = 10 * 1024 * 1024 bytes)
                if (file.size > 10 * 1024 * 1024) {
                    alert(`File ${file.name} quá lớn! Kích thước tối đa là 10MB.`);
                    continue;
                }
                
                const fileItem = document.createElement('div');
                fileItem.className = 'file-item';
                
                const fileIcon = getFileIcon(file.name);
                const fileSize = formatFileSize(file.size);
                
                fileItem.innerHTML = `
                    <div class="file-item-info">
                        <i class="file-icon ${fileIcon}"></i>
                        <div class="file-details">
                            <div class="file-name">${file.name}</div>
                            <div class="file-size">${fileSize}</div>
                        </div>
                    </div>
                    <button type="button" class="file-remove" onclick="removeFile(${i})">
                        <i class="fas fa-times"></i>
                    </button>
                `;
                
                fileList.appendChild(fileItem);
                console.log('File item added to list');
            }
        });

        function getFileIcon(fileName) {
            const extension = fileName.split('.').pop().toLowerCase();
            switch (extension) {
                case 'jpg':
                case 'jpeg':
                case 'png':
                case 'gif':
                case 'bmp':
                    return 'fas fa-image';
                case 'pdf':
                    return 'fas fa-file-pdf';
                case 'doc':
                case 'docx':
                    return 'fas fa-file-word';
                case 'txt':
                    return 'fas fa-file-alt';
                case 'zip':
                case 'rar':
                    return 'fas fa-file-archive';
                case 'exe':
                    return 'fas fa-cog';
                default:
                    return 'fas fa-file';
            }
        }

        function formatFileSize(bytes) {
            if (bytes === 0) return '0 Bytes';
            const k = 1024;
            const sizes = ['Bytes', 'KB', 'MB', 'GB'];
            const i = Math.floor(Math.log(bytes) / Math.log(k));
            return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
        }

        function removeFile(index) {
            const input = document.getElementById('attachments');
            const dt = new DataTransfer();
            const { files } = input;
            
            for (let i = 0; i < files.length; i++) {
                if (i !== index) {
                    dt.items.add(files[i]);
                }
            }
            
            input.files = dt.files;
            input.dispatchEvent(new Event('change'));
        }

        // Load user requests when page loads
        window.onload = function() {
            console.log('Page loaded');
            const fileInput = document.getElementById('attachments');
            const fileList = document.getElementById('file-list');
            console.log('File input found:', fileInput);
            console.log('File list found:', fileList);
        };
    </script>
</body>
</html> 