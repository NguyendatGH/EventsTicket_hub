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
            overflow-x: hidden; /* Ngăn cuộn ngang */
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
            padding: 0 94px;
            padding-top: 2rem;
            overflow-y: auto;
            display: flex;
            flex-direction: column;
            gap: 2rem;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
        }

        .page-title {
            color: white;
            font-size: 2rem;
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

        /* Table */
        .data-table {
            border-radius: 15px;
            overflow: hidden;
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        .table-header {
            display: flex;
            align-items: center;
            padding: 20px;
            gap: 10%;
            background: rgba(21, 0, 97, 0.78);
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }

        .table-header .page-title {
            font-size: 24px;
            font-weight: 600;
            color: #fff;
            margin: 0;
        }

        .table-columns {
            display: grid;
            grid-template-columns: 60px 2fr 2fr 1.5fr 1fr;
            gap: 20px;
            padding: 15px 20px;
            background: rgba(35, 35, 35, 0.46);
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            color: white;
            font-weight: 500;
        }

        .table-row {
            display: grid;
            grid-template-columns: 60px 2fr 2fr 1.5fr 1fr;
            gap: 20px;
            padding: 20px;
            background-color: rgba(63, 62, 62, 0.46);
            border-bottom: 1px solid #3e3e3e;
            transition: all 0.3s ease;
            align-items: center;
            color: white;
        }

        .table-row:hover {
            background-color: rgba(87, 85, 85, 0.46);
        }

        .table-row.isActive {
            background-color: rgba(87, 85, 85, 0.46);
        }

        .table-row:last-child {
            border-bottom: none;
        }

        .email-link {
            color: #64b5f6;
            text-decoration: underline;
        }

        .actions {
            display: flex;
            gap: 14px;
            justify-content: flex-start;
        }

        .action-btn {
            width: 32px;
            height: 32px;
            border-radius: 6px;
            border: none;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .Respond {
            background-color: transparent;
            color: white;
            border-radius: 8px;
            border: 1px solid white;
            padding: 6px 10px;
            width: 90px;
            font-size: 14px;
            font-weight: bold;
        }

        .Respond:hover {
            background-color: #cbf9ff29;
        }

        .action-btn img {
            width: 18px;
            height: 18px;
        }

        .delete-btn {
            background: rgba(220, 53, 69, 0.2);
            color: #dc3545;
        }

        .delete-btn:hover {
            background: rgba(220, 53, 69, 0.3);
        }

        /* Scrollbar */
        ::-webkit-scrollbar {
            width: 8px;
        }

        ::-webkit-scrollbar-track {
            background: rgba(255, 255, 255, 0.1);
            border-radius: 10px;
        }

        ::-webkit-scrollbar-thumb {
            background: rgba(100, 150, 255, 0.5);
            border-radius: 10px;
        }

        ::-webkit-scrollbar-thumb:hover {
            background: rgba(100, 150, 255, 0.7);
        }

        /* Hamburger Menu */
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

        /* Overlay */
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

        /* Background Ellipses */
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

        /* Responsive Design */
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

            .page-title {
                font-size: 1.5rem;
            }

            .control-panel {
                margin-top: 30px;
                padding: 8px 16px;
                font-size: 0.875rem;
            }

            .table-columns,
            .table-row {
                grid-template-columns: 1fr;
                gap: 10px;
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
                gap: 1rem;
                align-items: flex-start;
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

        @media (max-width: 992px) {
            .hamburger {
                display: flex;
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
    <img class="bg_elips firstElement" src="${pageContext.request.contextPath}/asset/image/full.svg" />
    <img class="bg_elips secondElement" src="${pageContext.request.contextPath}/asset/image/full2.svg" />
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
                <div class="admin-role">Quản lí website masterTicket</div>
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
            <a href="${pageContext.request.contextPath}/LogoutServlet" class="logout">
                <svg width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
                    <path d="M16 13v-2H7V8l-5 4 5 4v-3z" />
                    <path d="M20 3h-9c-1.103 0-2 .897-2 2v4h2V5h9v14h-9v-4H9v4c0 1.103.897 2 2 2h9c1.103 0 2-.897 2-2V5c0-1.103-.897-2-2-2z" />
                </svg>
                Đăng xuất
            </a>
        </aside>
        <div class="main-content">
            <header class="header">
                <div class="control-panel">Hỗ trợ khách hàng</div>
            </header>
            <div class="data-table">
                <div class="table-header">
                    <div class="page-title">Danh sách hỗ trợ</div>
                </div>
                <div class="table-columns">
                    <div></div>
                    <div>Đến từ</div>
                    <div>Tiêu đề</div>
                    <div>Ngày gửi</div>
                    <div>Tùy chọn</div>
                </div>
                <c:forEach var="support" items="${supportList}" varStatus="loop">
                    <div class="table-row ${support.isActive ? 'isActive' : ''}">
                        <div>${loop.count}</div>
                        <div>
                            <a href="mailto:${support.email}" class="email-link">${support.email}</a>
                        </div>
                        <div>${support.title}</div>
                        <div>
                            <fmt:formatDate value="${support.submitDate}" pattern="dd/MM/yyyy" />
                        </div>
                        <div class="actions">
                            <button class="action-btn Respond" onclick="respondToSupport('${support.id}')">
                                Phản hồi
                            </button>
                            <button class="action-btn delete-btn" onclick="deleteSupport('${support.id}')">
                                <img src="${pageContext.request.contextPath}/asset/image/Trash.svg" />
                            </button>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>
    <script>    
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

        document.querySelectorAll(".nav-item").forEach((item) => {
            item.addEventListener("click", function () {
                document.querySelectorAll(".nav-item").forEach((nav) => {
                    nav.querySelector(".nav-link").classList.remove("active");
                });
                this.querySelector(".nav-link").classList.add("active");
            });
        });

        function respondToSupport(supportId) {
            if (confirm("Bạn có chắc muốn phản hồi yêu cầu hỗ trợ này?")) {
                window.location.href =
                    "${pageContext.request.contextPath}/AdminServlet?action=respondSupport&id=" +
                    supportId;
            }
        }

        function deleteSupport(supportId) {
            if (confirm("Bạn có chắc muốn xóa yêu cầu hỗ trợ này?")) {
                window.location.href =
                    "${pageContext.request.contextPath}/AdminServlet?action=deleteSupport&id=" +
                    supportId;
            }
        }

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