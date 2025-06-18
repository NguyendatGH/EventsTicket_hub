<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
            min-height: 100vh;
            overflow-x: hidden;
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
            transition: transform 0.3s ease;
            z-index: 1100;
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

        .greeting {
            font-weight: 600;
            margin-bottom: 20px;
            font-size: 16px;
            color: #2d3748;
        }

        .email-body {
            margin-bottom: 25px;
            color: #4a5568;
        }

        .email-body textarea {
            width: 100%;
            min-height: 200px;
            padding: 12px;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            font-size: 15px;
            resize: vertical;
        }

        .step-list {
            margin: 20px 0;
            padding-left: 25px;
        }

        .step-list li {
            margin-bottom: 12px;
            padding-left: 8px;
            font-weight: 500;
        }

        .email-footer {
            margin-top: 35px;
            padding-top: 25px;
            border-top: 2px solid #e2e8f0;
        }

        .signature {
            font-style: italic;
            color: #718096;
            margin-bottom: 15px;
            font-size: 16px;
            font-weight: 500;
        }

        .admin-info {
            color: #a0aec0;
            font-size: 14px;
            margin-bottom: 5px;
        }

        .reply-button {
            background: linear-gradient(135deg, #3b82f6 0%, #1d4ed8 100%);
            color: white;
            border: none;
            padding: 16px 32px;
            border-radius: 12px;
            cursor: pointer;
            font-size: 15px;
            font-weight: 600;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(59, 130, 246, 0.4);
            letter-spacing: 0.5px;
        }

        .reply-button:hover {
            background: linear-gradient(135deg, #3568f4 0%, #1641d0 100%);
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(65, 125, 221, 0.6);
        }

        .button-container {
            display: flex;
            justify-content: flex-end;
            margin-top: 30px;
        }

        .hamburger {
            display: none;
            position: fixed;
            top: 20px;
            right: 34px;
            z-index: 1100;
            background: none;
            border: none;
            padding: 8px;
            cursor: pointer;
            width: 32px;
            height: 32px;
            flex-direction: column;
            justify-content: space-around;
        }

        .hamburger span {
            display: block;
            width: 20px;
            height: 2px;
            background: white;
            transition: all 0.3s ease;
        }

        .hamburger.active span:nth-child(1) {
            transform: rotate(45deg) translate(2px, 2px);
        }

        .hamburger.active span:nth-child(2) {
            opacity: 0;
        }

        .hamburger.active span:nth-child(3) {
            transform: rotate(-45deg) translate(5px, -6px);
        }

        .overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(21, 27, 58, 0.384);
            backdrop-filter: blur(5px);
            z-index: 950;
            transition: opacity 0.3s ease;
        }

        .overlay.active {
            display: block;
            opacity: 1;
        }

        .bg_elips {
            width: 800px;
            height: 800px;
            object-fit: cover;
            position: fixed;
            z-index: -1;
            pointer-events: none;
            opacity: 0.7;
        }

        .firstElement {
            top: -200px;
            left: -50px;
        }

        .secondElement {
            bottom: -400px;
            right: -200px;
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

            .wrapper {
                padding: 24px 30px;
            }

            .email-header {
                padding: 24px 30px;
            }

            .email-content {
                padding: 20px 20px;
            }

            .bg_elips {
                width: 600px;
                height: 600px;
            }

            .firstElement {
                top: -150px;
                left: -30px;
            }

            .secondElement {
                bottom: -300px;
                right: -150px;
            }
        }

        @media (max-width: 992px) {
            .control-panel {
                margin-top: 30px;
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
            }

            .admin-avatar {
                width: 100px;
                height: 100px;
            }

            .admin-avatar svg {
                width: 60px;
                height: 60px;
            }

            .admin-name {
                font-size: 20px;
            }

            .logo {
                font-size: 1.3rem;
            }

            .bg_elips {
                width: 500px;
                height: 500px;
            }

            .firstElement {
                top: -120px;
                left: -20px;
            }

            .secondElement {
                bottom: -250px;
                right: -120px;
            }

            .hamburger {
                display: flex;
            }
        }

        @media (max-width: 768px) {
            .main-content {
                padding: 0 15px;
            }

            .header {
                gap: 20px;
            }

            .page-title {
                font-size: 20px;
            }

            .wrapper {
                max-width: 100%;
                padding: 16px 20px;
            }

            .email-header {
                padding: 16px 20px;
                font-size: 14px;
                flex-direction: column;
                gap: 8px;
            }

            .email-content {
                margin-top: 100px;
                padding: 15px;
            }

            .greeting {
                font-size: 14px;
            }

            .email-body {
                font-size: 14px;
            }

            .bg_elips {
                width: 400px;
                height: 400px;
                opacity: 0.5;
            }

            .firstElement {
                top: -100px;
                left: -15px;
            }

            .secondElement {
                bottom: -200px;
                right: -100px;
            }
        }

        @media (max-width: 576px) {
            .sidebar {
                width: 100%;
            }

            .main-content {
                padding: 0 10px;
            }

            .header {
                flex-direction: column;
                gap: 10px;
            }

            .control-panel {
                padding: 8px 15px;
                font-size: 14px;
            }

            .back-button {
                padding: 6px 12px;
                font-size: 12px;
            }

            .back-button img {
                width: 20px;
                height: 20px;
            }

            .email-header {
                font-size: 12px;
            }

            .email-content {
                margin-top: 80px;
                padding: 10px;
            }

            .reply-button {
                padding: 8px 16px;
                font-size: 12px;
            }

            .bg_elips {
                width: 300px;
                height: 300px;
                opacity: 0.4;
            }

            .firstElement {
                top: -80px;
                left: -10px;
            }

            .secondElement {
                bottom: -150px;
                right: -50px;
            }
        }

        @keyframes float {
            0% {
                transform: translateY(0);
            }
            50% {
                transform: translateY(-20px);
            }
            100% {
                transform: translateY(0);
            }
        }
    </style>
</head>
<body>
    <img class="bg_elips firstElement" src="${pageContext.request.contextPath}/asset/image/full.svg" alt="Background Ellipse 1" />
    <img class="bg_elips secondElement" src="${pageContext.request.contextPath}/asset/image/full2.svg" alt="Background Ellipse 2" />
    <button class="hamburger">
        <span></span>
        <span></span>
        <span></span>
    </button>
    <div class="container">
        <div class="overlay"></div>
        <aside class="sidebar">
            <div class="logo">MasterTicket</div>
            <div class="admin-section">
                <div class="admin-avatar">
                    <svg fill="currentColor" viewBox="0 0 24 24">
                        <path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z" />
                    </svg>
                </div>
                <div class="admin-name">Admin</div>
                <div class="admin-role">Quản lí website MasterTicket</div>
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
                        <a href="${pageContext.request.contextPath}/admin-servlet/support-center" class="nav-link active">Hỗ trợ khách hàng</a>
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
        <div class="main-content">
            <header class="header">
                <div class="header-wrapper">
                    <h3 class="control-panel">Hỗ Trợ Khách Hàng</h3>
                    <div class="breadcrumb">Hỗ Trợ / Chi tiết / Phản hồi</div>
                </div>
                <button class="back-button" onclick="history.back()">
                    <img src="${pageContext.request.contextPath}/asset/image/back.svg" alt="Back Icon" />
                    Quay lại
                </button>
            </header>
            <div class="card-content">
                <div class="wrapper">
                    <form action="${pageContext.request.contextPath}/admin-servlet/support-center/reply" method="POST">
                        <input type="hidden" name="supportId" value="${support.id}" />
                        <div class="email-header">
                            <span>From: admin@customerService.com</span>
                            <span>Reply: ${support.email}</span>
                        </div>
                        <div class="email-content">
                            <div class="greeting">
                                <input type="text" name="greeting" value="Chào Anh/Chị," style="width: 100%; border: none; font-weight: 600; font-size: 16px; color: #2d3748;" required />
                            </div>
                            <div class="email-body">
                                <textarea name="response" required>
Cảm ơn Anh/Chị đã liên hệ với chúng tôi.

Để đặt vé trên nền tảng MasterTicket, Anh/Chị vui lòng thực hiện theo các bước sau:
1. Truy cập website tại địa chỉ [website].
2. Chọn mục "Sự kiện" và tìm sự kiện Anh/Chị muốn tham gia.
3. Nhấn vào "Đặt vé" ở trang thông tin sự kiện.
4. Chọn loại vé, số lượng và điền thông tin cá nhân (tên, v.v.).
5. Điền đầy đủ thông tin cá nhân theo yêu cầu.
6. Chọn phương thức thanh toán và hoàn tất giao dịch.

Sau khi đặt vé thành công, Anh/Chị sẽ nhận được email xác nhận kèm mã vé. Nếu không nhận được email xác nhận, vui lòng kiểm tra thư mục Spam/Junk hoặc liên hệ qua [hotline/email hỗ trợ].

Nếu cần hỗ trợ thêm, Anh/Chị vui lòng cung cấp thêm thông tin để chúng tôi hỗ trợ tốt nhất.
                                </textarea>
                            </div>
                            <div class="email-footer">
                                <div class="signature">
                                    <input type="text" name="signature" value="Trân trọng," style="width: 100%; border: none; font-style: italic; color: #718096; font-size: 16px; font-weight: 500;" required />
                                </div>
                                <div class="admin-info">
                                    <input type="text" name="adminName" value="${adminName}" placeholder="[Tên admin hoặc bộ phận hỗ trợ]" style="width: 100%; border: none; color: #a0aec0; font-size: 14px;" required />
                                </div>
                                <div class="admin-info">
                                    <input type="text" name="adminRole" value="Ban Tổ Chức Sự Kiện" style="width: 100%; border: none; color: #a0aec0; font-size: 14px;" required />
                                </div>
                            </div>
                            <div class="button-container">
                                <button type="submit" class="reply-button">Gửi</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
    <script>
        // Hamburger Menu
        const hamburger = document.querySelector(".hamburger");
        const sidebar = document.querySelector(".sidebar");
        const overlay = document.querySelector(".overlay");

        hamburger.addEventListener("click", () => {
            hamburger.classList.toggle("active");
            sidebar.classList.toggle("active");
            overlay.classList.toggle("active");
        });

        document.querySelectorAll(".nav-link").forEach((link) => {
            link.addEventListener("click", () => {
                if (window.innerWidth <= 992) {
                    hamburger.classList.remove("active");
                    sidebar.classList.remove("active");
                    overlay.classList.remove("active");
                }
            });
        });

        document.addEventListener("click", (e) => {
            if (
                window.innerWidth <= 992 &&
                !sidebar.contains(e.target) &&
                !hamburger.contains(e.target)
            ) {
                hamburger.classList.remove("active");
                sidebar.classList.remove("active");
                overlay.classList.remove("active");
            }
        });

        // Animate Ellipses
        function animateEllipses() {
            const ellipses = document.querySelectorAll(".bg_elips");
            ellipses.forEach((ellipse, index) => {
                const duration = 8000 + index * 2000;
                ellipse.style.animation = `float ${duration}ms ease-in-out infinite`;
            });
        }
        animateEllipses();
    </script>
</body>
</html>