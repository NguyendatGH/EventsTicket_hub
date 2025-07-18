<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Quản lý sự kiện</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        body {
            background: linear-gradient(135deg, #122536 0%, #764ba2 100%);
            min-height: 100vh;
            color: #fff;
            position: relative;
            overflow-x: hidden;
        }

        .container {
            display: flex;
            position: relative;
            z-index: 1;
        }

        .sidebar {
            position: fixed;
            left: 0;
            top: 0;
            width: 250px;
            height: 100vh;
            background: rgba(0,0,0,0.3);
            backdrop-filter: blur(10px);
            padding: 20px;
            z-index: 1000;
            transition: transform 0.3s;
        }

        .logo {
            color: #4CAF50;
            font-size: 20px;
            font-weight: bold;
            margin-bottom: 30px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .admin-section {
            text-align: center;
            margin-bottom: 30px;
        }

        .admin-avatar {
            width: 100px;
            height: 100px;
            background: rgba(255,255,255,0.1);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
        }

        .admin-avatar svg {
            width: 50px;
            height: 50px;
            color: #4CAF50;
        }

        .admin-name {
            color: white;
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 5px;
        }

        .admin-role {
            color: rgba(255,255,255,0.7);
            font-size: 14px;
        }

        .nav-menu {
            list-style: none;
        }

        .nav-item {
            margin-bottom: 15px;
        }

        .nav-link {
            color: #d8cbcb;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 10px;
            border-radius: 5px;
            transition: all 0.3s;
        }

        .nav-link:hover,
        .nav-link.active {
            background: rgba(76, 175, 80, 0.2);
            color: #4CAF50;
            transform: translateX(5px);
        }

        .logout {
            position: absolute;
            bottom: 20px;
            left: 20px;
            right: 20px;
            color: #d8cbcb;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 10px;
            border-radius: 5px;
            transition: all 0.3s;
        }

        .logout:hover {
            background: rgba(244, 67, 54, 0.2);
            color: #f44336;
        }

        .main-content {
            margin-left: 270px;
            padding: 30px;
            flex: 1;
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .top-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 0;
            border-bottom: 1px solid rgba(255,255,255,0.1);
            margin-bottom: 20px;
        }

        .breadcrumb {
            display: flex;
            align-items: center;
            gap: 10px;
            color: rgba(255,255,255,0.7);
            font-size: 14px;
        }

        .breadcrumb-current {
            color: #4CAF50;
            font-weight: 500;
        }

        .section {
            background: rgba(255,255,255,0.1);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 20px;
            border: 1px solid rgba(255,255,255,0.1);
        }

        .section-title {
            color: #4CAF50;
            font-size: 1.5rem;
            margin-bottom: 20px;
        }

        .event-input-group {
            display: flex;
            align-items: center;
            gap: 20px;
            margin-bottom: 20px;
        }

        .event-label {
            min-width: 120px;
            color: rgba(255,255,255,0.8);
            font-size: 14px;
        }

        .event-input, 
        .detail-value,
        .description-text {
            flex: 1;
            padding: 12px 20px;
            background: rgba(255,255,255,0.1);
            border: 1px solid rgba(255,255,255,0.2);
            color: white;
            border-radius: 8px;
            font-size: 16px;
            transition: all 0.3s;
        }

        .event-input:focus,
        .detail-value:focus,
        .description-text:focus {
            outline: none;
            border-color: #4CAF50;
            box-shadow: 0 0 0 3px rgba(76, 175, 80, 0.2);
        }

        .description-text {
            width: 100%;
            min-height: 150px;
            resize: vertical;
        }

        .details-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 20px;
        }

        .detail-item {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 20px;
        }

        .material-wrapper {
            border: 2px dashed rgba(76, 175, 80, 0.5);
            border-radius: 15px;
            padding: 30px;
            text-align: center;
            margin-bottom: 20px;
        }

        .img-wrapper {
            width: 100%;
            margin-top: 20px;
        }

        .img-wrapper img {
            width: 100%;
            max-height: 300px;
            object-fit: contain;
            border-radius: 10px;
            margin-bottom: 15px;
        }

        .event-option {
            display: flex;
            gap: 15px;
            justify-content: flex-end;
        }

        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 16px;
            font-weight: 500;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .save {
            background: #4CAF50;
            color: white;
        }

        .save:hover {
            background: #45a049;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(76, 175, 80, 0.3);
        }

        .reject {
            background: rgba(244, 67, 54, 0.2);
            color: #f44336;
            border: 1px solid #f44336;
        }

        .reject:hover {
            background: rgba(244, 67, 54, 0.3);
            transform: translateY(-2px);
        }

        .error-message {
            color: #f44336;
            background: rgba(244, 67, 54, 0.1);
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            border: 1px solid rgba(244, 67, 54, 0.3);
        }

        .success-message {
            color: #4CAF50;
            background: rgba(76, 175, 80, 0.1);
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            border: 1px solid rgba(76, 175, 80, 0.3);
        }

        .hamburger {
            display: none;
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 1100;
            background: rgba(0,0,0,0.3);
            border: none;
            padding: 10px;
            border-radius: 50%;
            cursor: pointer;
            width: 40px;
            height: 40px;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            gap: 5px;
        }

        .hamburger span {
            display: block;
            width: 20px;
            height: 2px;
            background: white;
            transition: all 0.3s ease;
        }

        .hamburger.active span:nth-child(1) {
            transform: rotate(45deg) translate(5px, 5px);
        }

        .hamburger.active span:nth-child(2) {
            opacity: 0;
        }

        .hamburger.active span:nth-child(3) {
            transform: rotate(-45deg) translate(5px, -5px);
        }

        .overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.5);
            backdrop-filter: blur(5px);
            z-index: 900;
        }

        .overlay.active {
            display: block;
        }

        @media (max-width: 992px) {
            .sidebar {
                transform: translateX(-100%);
            }
            
            .sidebar.active {
                transform: translateX(0);
            }
            
            .main-content {
                margin-left: 0;
                padding: 20px;
            }
            
            .hamburger {
                display: flex;
            }
            
            .event-input-group {
                flex-direction: column;
                align-items: flex-start;
            }
            
            .detail-item {
                flex-direction: column;
                align-items: flex-start;
            }
            
            .event-option {
                justify-content: center;
            }
        }

        @media (max-width: 768px) {
            .details-grid {
                grid-template-columns: 1fr;
            }
            
            .section {
                padding: 20px;
            }
            
            .event-input, 
            .detail-value,
            .description-text {
                width: 100%;
            }
        }

        @media (max-width: 576px) {
            .main-content {
                padding: 15px;
            }
            
            .event-option {
                flex-direction: column;
            }
            
            .btn {
                width: 100%;
                justify-content: center;
            }
        }

        /* Animation for background elements */
        .bg_elips {
            position: fixed;
            z-index: -1;
            opacity: 0.2;
            animation: float 15s ease-in-out infinite;
        }

        .firstElement {
            top: -100px;
            left: -100px;
            width: 300px;
            height: 300px;
        }

        .secondElement {
            bottom: -100px;
            right: -100px;
            width: 400px;
            height: 400px;
        }

        @keyframes float {
            0%, 100% {
                transform: translateY(0);
            }
            50% {
                transform: translateY(-20px);
            }
        }
    </style>
</head>
<body>
    <img class="bg_elips firstElement" src="${pageContext.request.contextPath}/asset/image/full.svg" />
    <img class="bg_elips secondElement" src="${pageContext.request.contextPath}/asset/image/full2.svg" />
    
    <button class="hamburger">
        <span></span>
        <span></span>
        <span></span>
    </button>
    
    <div class="overlay"></div>
    
    <div class="container">
<!--        <aside class="sidebar">
            <div class="logo">🎟️ MasterTicket</div>
            <div class="admin-section">
                <div class="admin-avatar">
                    <svg fill="currentColor" viewBox="0 0 24 24">
                        <path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z" />
                    </svg>
                </div>
                <div class="admin-name">Admin</div>
                <div class="admin-role">Quản lý website MasterTicket</div>
            </div>
            <nav>
                <ul class="nav-menu">
                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/admin-servlet/dashboard" class="nav-link">📊 Bảng điều khiển</a>
                    </li>
                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/admin-servlet/event-management" class="nav-link active">📅 Danh sách sự kiện</a>
                    </li>
                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/admin-servlet/user-management" class="nav-link">👥 Danh sách tài khoản</a>
                    </li>
                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/admin-servlet/transaction-management" class="nav-link">💰 Danh sách giao dịch</a>
                    </li>
                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/admin-servlet/support-center" class="nav-link">💬 Hỗ trợ khách hàng</a>
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
        </aside>-->
        
        <main class="main-content">
            <div class="top-bar">
                <div class="breadcrumb">
                    <span class="breadcrumb-item">Bảng điều khiển</span>
                    <span>/</span>
                    <span class="breadcrumb-current">Chi tiết sự kiện</span>
                </div>
            </div>
            
            <c:if test="${not empty error}">
                <div class="error-message">${error}</div>
            </c:if>
            <c:if test="${not empty success}">
                <div class="success-message">${success}</div>
            </c:if>
            
            <form id="updateEventForm" action="${pageContext.request.contextPath}/organizer-servlet" method="POST" onsubmit="return validateForm()">
                <input type="hidden" name="action" value="update" />
                <input type="hidden" name="eventID" value="${event.eventID}" />
                
                <div class="section">
                    <h2 class="section-title">Tổng quan</h2>
                    <div class="event-input-group">
                        <span class="event-label">Tên sự kiện:</span>
                        <input type="text" class="event-input" name="name" value="${event.name}" required maxlength="100" />
                    </div>
                </div>
                
                <div class="section">
                    <h2 class="section-title">Mô tả</h2>
                    <textarea class="description-text" name="description" rows="5">${event.description}</textarea>
                </div>
                
                <div class="section">
                    <h2 class="section-title">Thông tin chi tiết</h2>
                    <div class="details-grid">
                        <div>
                            <div class="detail-item">
                                <span class="event-label">Thời gian bắt đầu:</span>
                                <input type="datetime-local" class="detail-value" name="startTime" value="<fmt:formatDate value='${event.startTime}' pattern='yyyy-MM-dd\'T\'HH:mm' />" required />
                            </div>
                            <div class="detail-item">
                                <span class="event-label">Thời gian kết thúc:</span>
                                <input type="datetime-local" class="detail-value" name="endTime" value="<fmt:formatDate value='${event.endTime}' pattern='yyyy-MM-dd\'T\'HH:mm' />" required />
                            </div>
                        </div>
                        <div>
                            <div class="detail-item">
                                <span class="event-label">Địa điểm:</span>
                                <input type="text" class="detail-value" name="physicalLocation" value="${event.physicalLocation}" required maxlength="200" />
                            </div>
                            <div class="detail-item">
                                <span class="event-label">Số lượng vé:</span>
                                <input type="number" class="detail-value" name="totalTicketCount" value="${event.totalTicketCount}" required min="0" />
                            </div>
                            
                        </div>
                    </div>
                </div>
                
                <div class="section">
                    <h2 class="section-title">Hình ảnh</h2>
                    <div class="material-wrapper">
                        <div class="img-wrapper">
                            <img id="imagePreview" src="${event.imageURL}" alt="Hình ảnh chính" onerror="this.src='${pageContext.request.contextPath}/asset/image/MayLangThangAvt.svg'" />
                            <input type="text" class="detail-value" id="imageURL" name="imageURL" value="${event.imageURL}" placeholder="Nhập URL ảnh" maxlength="500" />
                        </div>
                    </div>
                </div>
                
                <div class="event-option">
                    <button type="submit" class="btn save">💾 Cập nhật</button>
                    <a href="${pageContext.request.contextPath}/organizer-servlet?action=update" class="btn reject">↩️ Quay lại</a>
                </div>
            </form>
        </main>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>
        // Hamburger menu toggle
        const hamburger = document.querySelector('.hamburger');
        const sidebar = document.querySelector('.sidebar');
        const overlay = document.querySelector('.overlay');
        
        if (hamburger && sidebar && overlay) {
            hamburger.addEventListener('click', () => {
                hamburger.classList.toggle('active');
                sidebar.classList.toggle('active');
                overlay.classList.toggle('active');
            });
            
            overlay.addEventListener('click', () => {
                hamburger.classList.remove('active');
                sidebar.classList.remove('active');
                overlay.classList.remove('active');
            });
        }
        
        // Image URL preview
        const imageURLInput = document.getElementById('imageURL');
        const imagePreview = document.getElementById('imagePreview');
        
        if (imageURLInput && imagePreview) {
            imageURLInput.addEventListener('input', () => {
                const url = imageURLInput.value.trim();
                if (url) {
                    imagePreview.src = url;
                } else {
                    imagePreview.src = '${pageContext.request.contextPath}/asset/image/MayLangThangAvt.svg';
                }
            });
        }
        
        // Form validation
        function validateForm() {
            const name = document.querySelector('input[name="name"]').value.trim();
            const description = document.querySelector('textarea[name="description"]').value.trim();
            const physicalLocation = document.querySelector('input[name="physicalLocation"]').value.trim();
            const startTime = document.querySelector('input[name="startTime"]').value;
            const endTime = document.querySelector('input[name="endTime"]').value;
            const totalTicketCount = document.querySelector('input[name="totalTicketCount"]').value;
            const imageURL = document.querySelector('input[name="imageURL"]').value.trim();
            
            if (!name) {
                Swal.fire('Lỗi', 'Tên sự kiện không được để trống', 'error');
                return false;
            }
            
            if (name.length > 100) {
                Swal.fire('Lỗi', 'Tên sự kiện không được vượt quá 100 ký tự', 'error');
                return false;
            }
            
            if (!physicalLocation) {
                Swal.fire('Lỗi', 'Địa điểm không được để trống', 'error');
                return false;
            }
            
            if (physicalLocation.length > 200) {
                Swal.fire('Lỗi', 'Địa điểm không được vượt quá 200 ký tự', 'error');
                return false;
            }
            
            if (!startTime) {
                Swal.fire('Lỗi', 'Thời gian bắt đầu không được để trống', 'error');
                return false;
            }
            
            if (!endTime) {
                Swal.fire('Lỗi', 'Thời gian kết thúc không được để trống', 'error');
                return false;
            }
            
            if (new Date(startTime) >= new Date(endTime)) {
                Swal.fire('Lỗi', 'Thời gian bắt đầu phải trước thời gian kết thúc', 'error');
                return false;
            }
            
            if (isNaN(totalTicketCount) || totalTicketCount < 0) {
                Swal.fire('Lỗi', 'Số lượng vé phải là số không âm', 'error');
                return false;
            }
            
            if (imageURL && !isValidURL(imageURL)) {
                Swal.fire('Lỗi', 'URL ảnh không hợp lệ', 'error');
                return false;
            }
            
            // Show loading
            Swal.fire({
                title: 'Đang xử lý',
                text: 'Vui lòng chờ trong khi cập nhật sự kiện...',
                allowOutsideClick: false,
                didOpen: () => {
                    Swal.showLoading();
                }
            });
            
            return true;
        }
        
        function isValidURL(url) {
            try {
                new URL(url);
                return url.match(/\.(jpeg|jpg|gif|png|svg)$/i) != null;
            } catch (_) {
                return false;
            }
        }
        <script>
    document.getElementById('imageURL').addEventListener('input', function() {
        const url = this.value.trim();
        const preview = document.getElementById('imagePreview');
        
        // Ẩn preview trước khi kiểm tra URL mới
        preview.style.display = 'none';
        
        // Kiểm tra nếu URL không rỗng và hợp lệ
        if (url && isValidUrl(url)) {
            // Hiển thị trạng thái loading
            preview.src = '';
            preview.style.display = 'block';
            preview.alt = 'Loading image...';
            preview.style.filter = 'blur(2px)';
            
            // Tạo ảnh tạm để kiểm tra
            const tempImage = new Image();
            tempImage.onload = function() {
                // Nếu ảnh tải thành công
                preview.src = url;
                preview.alt = 'Image preview';
                preview.style.filter = 'none';
            };
            tempImage.onerror = function() {
                // Nếu ảnh không tải được
                preview.style.display = 'none';
                showImageError("Không thể tải ảnh từ URL này. Vui lòng kiểm tra lại!");
            };
            tempImage.src = url;
        }
    });

    // Hiển thị preview ngay nếu đã có URL (khi load lại trang)
    window.addEventListener('DOMContentLoaded', function() {
        const urlInput = document.getElementById('imageURL');
        if (urlInput.value) {
            urlInput.dispatchEvent(new Event('input'));
        }
    });

    // Hàm kiểm tra URL hợp lệ
    function isValidUrl(string) {
        try {
            new URL(string);
            return true;
        } catch (_) {
            return false;
        }
    }

    // Hàm hiển thị thông báo lỗi
    function showImageError(message) {
        const errorDiv = document.createElement('div');
        errorDiv.className = 'error-message';
        errorDiv.textContent = message;
        errorDiv.style.marginTop = '10px';
        errorDiv.style.color = '#ff6b6b';
        
        const formGroup = document.getElementById('imageURL').closest('.form-group');
        // Xóa thông báo lỗi cũ nếu có
        const oldError = formGroup.querySelector('.error-message');
        if (oldError) oldError.remove();
        
        formGroup.appendChild(errorDiv);
        
        // Tự động xóa thông báo sau 3 giây
        setTimeout(() => {
            errorDiv.remove();
        }, 3000);
    }
</script>
        
        // Display server messages
        <c:if test="${not empty error}">
            Swal.fire('Lỗi', '${error}', 'error');
        </c:if>
        <c:if test="${not empty success}">
            Swal.fire('Thành công', '${success}', 'success');
        </c:if>
    </script>
</body>
</html>