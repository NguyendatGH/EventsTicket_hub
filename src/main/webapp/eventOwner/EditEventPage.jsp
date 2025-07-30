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
            /* Toast Container */
            .toast-container {
                position: fixed;
                top: 20px;
                right: 20px;
                z-index: 9999;
                display: flex;
                flex-direction: column;
                gap: 10px;
            }

            /* Toast Styles */
            .toast {
                display: flex;
                align-items: center;
                padding: 12px 20px;
                border-radius: 8px;
                min-width: 250px;
                max-width: 400px;
                color: #fff;
                font-size: 0.9rem;
                font-weight: 500;
                box-shadow: var(--shadow);
                opacity: 0;
                transform: translateX(100%);
                transition: opacity 0.3s ease, transform 0.3s ease;
            }

            .toast.show {
                opacity: 1;
                transform: translateX(0);
            }

            .toast.success {
                background: var(--success-green);
                border: 1px solid #1f8a38;
            }

            .toast.error {
                background: var(--error-red);
                border: 1px solid #cc0a0a;
            }

            .toast .toast-icon {
                margin-right: 10px;
                font-size: 1.2rem;
            }

            .toast .toast-message {
                flex: 1;
            }

            .toast .toast-close {
                background: none;
                border: none;
                color: #fff;
                font-size: 1rem;
                cursor: pointer;
                margin-left: 10px;
                opacity: 0.7;
                transition: opacity 0.3s ease;
            }

            .toast .toast-close:hover {
                opacity: 1;
            }

            /* Animation for toast dismissal */
            @keyframes toast-slide-out {
                to {
                    opacity: 0;
                    transform: translateX(100%);
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

            <main class="main-content">
                <div class="top-bar">
                    <div class="breadcrumb">
                        <span class="breadcrumb-item">Bảng điều khiển</span>
                        <span>/</span>
                        <span class="breadcrumb-current">Chi tiết sự kiện</span>
                    </div>
                </div>
                <div id="toast-container" class="toast-container"></div>
                <c:if test="${not empty error}">
                    <div class="error-message">${error}</div>
                </c:if>
                <c:if test="${not empty success}">
                    <div class="success-message">${success}</div>
                </c:if>

                <form id="updateEventForm" action="${pageContext.request.contextPath}/organizer-servlet" method="POST" enctype="multipart/form-data" onsubmit="return validateForm()">
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
                                <img id="imagePreview" src="${pageContext.request.contextPath}/uploads/event_banners/${event.imageURL}" alt="Hình ảnh chính" onerror="this.src='${pageContext.request.contextPath}/asset/image/MayLangThangAvt.svg'" />
                                <input type="file" class="detail-value" id="imageFile" name="imageFile" accept="image/jpeg,image/jpg,image/png,image/gif,image/svg+xml" />
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

        <script>
            <script>
    function showToast(message, type) {
                    const toastContainer = document.getElementById('toast-container');
            const toast = document.createElement('div');
            toast.className = `toast ${type}`;
            const icon = type === 'success' ? '✅' : '❌';
            toast.innerHTML = `
            <span class="toast-icon">${icon}</span>
            <span class="toast-message">${message}</span>
            <button class="toast-close">&times;</button>
        `;
            toastContainer.appendChild(toast);
            setTimeout(() => {
            toast.classList.add('show');
            }, 100);
            setTimeout(() => {
            toast.style.animation = 'toast-slide-out 0.3s ease forwards';
            setTimeout(() => toast.remove(), 300);
            }, 4000);
            toast.querySelector('.toast-close').addEventListener('click', () => {
            toast.style.animation = 'toast-slide-out 0.3s ease forwards';
                setTimeout(() => toast.remove(), 300);
            });
                }
            
                function animateEllipses() {
                    const ellipses = document.querySelectorAll(".bg_elips");
            ellipses.forEach((ellipse, index) => {
                const duration = 8000 + index * 2000;
                ellipse.style.animation = `float ${duration}ms ease-in-out infinite`;
            });
                }
            
                const hamburger = document.querySelector('.hamburger');
          
                    const sidebar = document.querySelector('.sidebar');
                const overlay = document.querySelector('.overlay');
        
            if (hamburger && sidebar && overlay) {
                    hamburger.addEventListener('click', () => {
                    hamburger.classList.toggle('active');
                    sidebar.classList.toggle('active');
                    overlay.classList.toggle('active');
                    });
            document.querySelectorAll('.nav-link').forEach(link => {
            link.addEventListener('click', () => {
            if (window.innerWidth <= 992) {
            hamburger.classList.remove('active');
            sidebar.classList.remove('active');
            overlay.classList.remove('active');
            }
            });
            });
            document.addEventListener('click', (e) => {
                if (window.innerWidth <= 992 && !sidebar.contains(e.target) && !hamburger.contains(e.target)) {
            hamburger.classList.remove('active');
            sidebar.classList.remove('active');
            overlay.classList.remove('active');
            }
            });
                }
            
                function previewImage(input) {
                    const file = input.files[0];
            const reader = new FileReader();
            reader.onloadend = function() {
            const preview = document.getElementById('imagePreview');
            if (preview) {
            preview.src = reader.result;
            }
            }

            if (file) {
            reader.readAsDataURL(file);
            } else {
                const preview = document.getElementById('imagePreview');
            i f (preview) {
                preview.src = '${pageContext.request.contextPath}/asset/image/MayLangThangAvt.svg';
            }
            }
                }
            
                // Add event listener for image file input
            document.getElementById('imageFile').addEventListener('change', function() {
                    previewImage(this);
            });
        
            function validateForm() {
                    const name = document.querySelector('input[name="name"]').value.trim();
            const description = document.querySelector('textarea[name="description"]').value.trim();
            const physicalLocation = document.querySelector('input[name="physicalLocation"]').value.trim();
            const startTime = document.querySelector('input[name="startTime"]').value;
            const endTime = document.querySelector('input[name="endTime"]').value;
            const totalTicketCount = document.querySelector('input[name="totalTicketCount"]').value;
            const imageFile = document.querySelector('input[name="imageFile"]').files[0];
            if (!name) {
            showToast('Tên sự kiện không được để trống', 'error');
            return false;
            }
            if (name.length > 100) {
            showToast('Tên sự kiện không được vượt quá 100 ký tự', 'error');
            return false;
            }

            if (description.length > 1000) {
            showToast('Mô tả không được vượt quá 1000 ký tự', 'error');
            return false;
            }

            if (!physicalLocation) {
            showToast('Địa điểm không được để trống', 'error');
            return false;
            }
            if (physicalLocation.length > 200) {
            showToast('Địa điểm không được vượt quá 200 ký tự', 'error');
            return false;
            }

            if (!startTime) {
            showToast('Thời gian bắt đầu không được để trống', 'error');
            return false;
            }
            if (!endTime) {
            showToast('Thời gian kết thúc không được để trống', 'error');
            return false;
            }
            if (new Date(startTime) >= new Date(endTime)) {
            showToast('Thời gian bắt đầu phải trước thời gian kết thúc', 'error');
            return false;
            }

            if (isNaN(totalTicketCount) || totalTicketCount < 0) {
            showToast('Số lượng vé phải là số không âm', 'error');
            return false;
            }

            if (!imageFile) {
            showToast('Vui lòng chọn ảnh cho sự kiện', 'error');
            return false;
            }

            const validTypes = ['image/jpeg', 'image/png', 'image/gif'];
                    if (!validTypes.includes(imageFile.type)) {
                    showToast('Chỉ chấp nhận file ảnh định dạng JPG, PNG hoặc GIF', 'error');
            return false;
            }

            const maxSize = 5 * 1024 * 1024;
            if (imageFile.size > maxSize) {
            showToast('Kích thước ảnh không được vượt quá 5MB', 'error');
            return false;
            }

            showToast('Đang xử lý cập nhật sự kiện...', 'success');
            return true;
                }
            
            <c:if test="${not empty error}">
                showToast('${error}', 'error');
            </c:if>
            <c:if test="${not empty success}">
                showToast('${success}', 'success');
            </c:if>
            
                animateEllipses();
        </script>
    </body>
</html>