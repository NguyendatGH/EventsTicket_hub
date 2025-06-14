<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%> <%@ taglib uri="http://java.sun.com/jsp/jstl/core"
         prefix="c" %> <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
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
                position: relative;
                background-color: #070a17;
                overflow-x: hidden;
            }

            .container {
                display: flex;
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

            .stat-item,
            .stat-header {
                display: flex;
                flex-direction: column;
                box-sizing: border-box;
                color: #ffffff;
            }

            .stat-item {
                width: fit-content;
                min-width: 230px;
                max-width: 100%;
                background: rgba(255, 255, 255, 0.18);
                border-radius: 12px;
                padding: 2rem;
                backdrop-filter: blur(20px);
                transition: all 0.3s ease;
            }

            .stat-item:hover {
                transform: translateY(-2px);
                border-color: rgba(255, 255, 255, 0.2);
            }

            .stat-wrapper {
                display: flex;
                flex-direction: row;
                width: 100%;
                gap: 10px;
                align-items: stretch;
            }

            .stat-header {
                display: flex;
                align-items: flex-start;
                gap: 0.75rem;
                margin-bottom: 1rem;
                width: 50%;
            }

            .stat-header h1 {
                font-size: 40px;
                font-weight: bold;
            }

            .stat-content {
                width: 100%;
                object-fit: cover;
            }

            .stat-title {
                color: #ffffff;
                font-size: 1rem;
                font-weight: bold;
                word-wrap: break-word;
            }

            .stat-value {
                color: white;
                font-size: 24px;
                font-weight: 700;
                word-wrap: break-word;
                max-width: 100%;
            }

            .table-section {
                display: flex;
                flex-direction: row;
                color: white;
                width: 100%;
                gap: 3rem;
            }

            .Top-EventOwner {
                width: 100%;
                height: 100%;
            }

            .dashboard-container {
                display: flex;
                flex-direction: column;
                align-items: start;
                width: 100%;
                gap: 16px;
                margin-bottom: 1.75rem;
            }

            .table-header {
                color: white;
            }

            .table-container {
                border-radius: 8px;
                overflow: hidden;
                width: 64%;
                flex: 1;
            }

            table {
                width: 100%;
                border-collapse: collapse;
                color: white;
            }

            .table_head {
                background: rgba(21, 0, 97, 0.78);
            }

            th {
                padding: 18px 16px;
                text-align: left;
                font-weight: bold;
                font-size: 15px;
                color: #e5e7eb;
                border: none;
            }

            td {
                padding: 12px 19px;
                font-size: 14px;
                color: white;
            }

            .td_head {
                font-weight: bold;
            }

            tbody tr {
                background: rgba(255, 255, 255, 0.18);
                border-bottom: 1px solid #555555;
            }

            tbody tr:hover {
                transition: all 0.3s ease;
                background: rgba(255, 255, 255, 0.1);
            }

            tbody tr:nth-child(even) {
                transition: all 0.3s ease;
                background: rgba(255, 255, 255, 0.18);
            }

            tbody tr:nth-child(even):hover {
                transition: all 0.3s ease;
                background: rgba(255, 255, 255, 0.1);
            }

            .actived {
                background-color: #0d457c;
            }

            .status-tag {
                background: rgba(255, 255, 255, 0.12);
                border: none;
                padding: 6px 12px;
                border-radius: 4px;
                font-size: 11px;
                font-weight: 500;
                cursor: pointer;
            }

            .data-table {
                background: #1b1c21;
                border-radius: 15px;
                overflow: hidden;
                border: 1px solid rgba(255, 255, 255, 0.1);
            }

            .table-header-secondary {
                display: grid;
                grid-template-columns: 1fr auto;
                gap: 20px;
                align-items: center;
                background: rgba(21, 0, 97, 0.78);
                padding: 20px;
            }

            .page-title {
                font-size: 24px;
                font-weight: 600;
                color: #fff;
            }

            .search-container {
                position: relative;
                width: 100%;
                max-width: 300px;
                justify-self: end;
            }

            .search-box {
                width: 100%;
                padding: 8px 50px 8px 20px;
                background: rgba(255, 255, 255, 0.1);
                border: 1px solid rgba(255, 255, 255, 0.2);
                border-radius: 10px;
                color: white;
                font-size: 14px;
                outline: none;
                transition: all 0.3s ease;
            }

            .search-box:focus {
                background: rgba(255, 255, 255, 0.15);
                border-color: rgba(100, 150, 255, 0.5);
            }

            .search-box::placeholder {
                color: rgba(255, 255, 255, 0.6);
            }

            .search-icon {
                position: absolute;
                right: 15px;
                top: 50%;
                transform: translateY(-50%);
                color: rgba(255, 255, 255, 0.6);
            }

            .table-row {
                display: grid;
                grid-template-columns: 50px 2fr 1fr 1fr 100px;
                gap: 20px;
                padding: 20px;
                border-bottom: 1px solid #3e3e3e;
                transition: all 0.3s ease;
                align-items: center;
                color: white;
            }

            .table-row:hover {
                background: rgba(255, 255, 255, 0.1);
            }

            .table-row:last-child {
                border-bottom: none;
            }

            .event-status {
                padding: 6px 30px;
                border-radius: 8px;
                font-size: 14px;
                width: 164px;
                text-align: center;
            }

            .success {
                background-color: rgba(169, 223, 216, 0.12);
                color: #3ad33a;
                border: 1px solid #3ec73e;
            }

            .error {
                background-color: rgba(95, 67, 42, 0.12);
                color: #ff0c0c;
                border: 1px solid #c53131;
            }

            .warning {
                background-color: rgba(95, 67, 42, 0.12);
                color: #c9bc04;
                border: 1px solid #c9bc04;
            }

            .actions {
                display: flex;
                gap: 10px;
            }

            .action-btn {
                width: 35px;
                height: 35px;
                border-radius: 8px;
                border: none;
                cursor: pointer;
                transition: all 0.3s ease;
                display: flex;
                align-items: center;
                justify-content: center;
            }

            .edit-btn {
                background: rgba(40, 167, 69, 0.2);
                color: #28a745;
            }

            .edit-btn:hover {
                background: rgba(40, 167, 69, 0.3);
            }

            .delete-btn {
                background: rgba(220, 53, 69, 0.2);
                color: #dc3545;
            }

            .delete-btn:hover {
                background: rgba(220, 53, 69, 0.3);
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

                .stat-item {
                    display: none;
                }

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
        <img
            class="bg_elips firstElement"
            src="${pageContext.request.contextPath}/asset/image/full.svg"
            />
        <img
            class="bg_elips secondElement"
            src="${pageContext.request.contextPath}/asset/image/full2.svg"
            />
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
                        <path
                            d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"
                            />
                        </svg>
                    </div>
                    <div class="admin-name">Admin</div>
                    <div class="admin-role">Quản lí website masterTicket</div>
                </div>

                <nav>
                    <ul class="nav-menu">
                        <li class="nav-item">
                            <a
                                href="${pageContext.request.contextPath}/admin-servlet/dashboard"
                                class="nav-link"
                                >Bảng điều khiển</a
                            >
                        </li>
                        <li class="nav-item">
                            <a
                                href="${pageContext.request.contextPath}/admin-servlet/event-management"
                                class="nav-link active"
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
                    <path
                        d="M20 3h-9c-1.103 0-2 .897-2 2v4h2V5h9v14h-9v-4H9v4c0 1.103.897 2 2 2h9c1.103 0 2-.897 2-2V5c0-1.103-.897-2-2-2z"
                        />
                    </svg>
                    Đăng xuất
                </a>
            </aside>
            <div class="main-content">
                <header class="header">
                    <div class="control-panel">Danh sách sự kiện</div>
                </header>
                <div class="dashboard-container">
                    <h2 class="table-header">Bảng xếp hạng</h2>
                    <div class="table-section">
                        <div class="table-container">
                            <table>
                                <thead>
                                    <tr class="table_head">
                                        <th>Tên tổ chức</th>
                                        <th>Số sự kiện</th>
                                        <th>Vé đã bán</th>
                                        <th>Trạng thái</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty topOrganizers}">
                                            <c:forEach
                                                var="organizer"
                                                items="${topOrganizers}"
                                                varStatus="status"
                                                >
                                                <tr class="${status.first ? 'active' : ''}">
                                                    <td class="td_head">
                                                        <c:out value="${organizer.name}" />
                                                    </td>
                                                    <td><c:out value="${organizer.numsOfEvent}" /></td>
                                                    <td>
                                                        <c:out value="${organizer.numsOfTicketSelled}" />
                                                    </td>
                                                    <td>
                                                        <button class="status-tag">
                                                            <c:choose>
                                                                <c:when test="${organizer.status}">Khóa</c:when>
                                                                <c:otherwise>Đang hoạt động</c:otherwise>
                                                            </c:choose>
                                                        </button>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="4">Không có tổ chức sự kiện nào.</td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                        <div class="stat-item">
                            <div class="stat-wrapper">
                                <div class="stat-header">
                                    <c:choose>
                                        <c:when test="${not empty topOrganizers}">
                                            <h1>1st</h1>
                                            <span class="stat-title"
                                                  ><c:out value="${topOrganizers[0].name}"
                                                   /></span>
                                            </c:when>
                                            <c:otherwise>
                                            <h1>1st</h1>
                                            <span class="stat-title">Không có tổ chức</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <span class="stat-content">
                                    <img src="<c:choose
                                             ><c:when
                                                 test="${not empty topOrganizers and not empty topOrganizers[0].avatarURL}"
                                                 >${pageContext.request.contextPath}/${topOrganizers[0].avatarURL}</c:when
                                             ><c:otherwise
                                                 >${pageContext.request.contextPath}/asset/image/MayLangThangAvt.svg</c:otherwise
                                             ></c:choose
                                         >" class="Top-EventOwner" alt="Top Organizer"
                                         onerror="this.src='${pageContext.request.contextPath}/asset/image/MayLangThangAvt.svg'"
                                         />
                                </span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="data-table">
                    <div class="table-header-secondary">
                        <div class="page-title">Recent Events</div>
                        <div class="search-container">
                            <input
                                type="text"
                                class="search-box"
                                placeholder="What are you looking for?"
                                />
                            <div class="search-icon">🔍</div>
                        </div>
                    </div>
                    <c:if test="${empty events}">
                        <p style="color: white; padding: 20px">No events found.</p>
                    </c:if>
                    <c:forEach var="event" items="${events}" varStatus="status">
                        <div class="table-row">
                            <div>${status.count}</div>
                            <div>${event.name}</div>
                            <div class="date">
                                <fmt:formatDate
                                    value="${event.startTime}"
                                    pattern="dd/MM/yyyy"
                                    />
                                -
                                <fmt:formatDate value="${event.endTime}" pattern="dd/MM/yyyy" />
                            </div>
                            <div>
                                <div
                                    class="event-status ${event.status == 'active' ? 'success' : event.status == 'pending' ? 'warning' : 'error'}"
                                    >
                                    ${event.status == 'active' ? 'Đang hoạt động' : event.status
                                      == 'pending' ? 'Đang chờ duyệt' : 'Đã dừng'}
                                </div>
                            </div>
                            <div class="actions">
                                <button
                                    class="action-btn edit-btn"
                                    onclick="handleEditEvent(${event.eventID})"
                                    >
                                    <img
                                        src="${pageContext.request.contextPath}/asset/image/Edit_fill.svg"
                                        alt="Edit"
                                        />
                                </button>
                                <button
                                    class="action-btn delete-btn"
                                    onclick="handleDeleteEvent(${event.eventID})"
                                    >
                                    <img
                                        src="${pageContext.request.contextPath}/asset/image/Trash.svg"
                                        alt="Delete"
                                        />
                                </button>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script>
             document
                    .querySelector(".search-box")
                    .addEventListener("input", function () {
                        const searchTerm = this.value.toLowerCase();
                        const rows = document.querySelectorAll(".table-row");
                        rows.forEach((row) => {
                            const eventName = row.children[1].textContent.toLowerCase();
                            const date = row.children[2].textContent.toLowerCase();
                            if (eventName.includes(searchTerm) || date.includes(searchTerm)) {
                                row.style.display = "grid";
                            } else {
                                row.style.display = "none";
                            }
                        });
                    });

            function handleEditEvent(eventID) {
                console.log("Redirecting to edit event:", eventID);
                window.location.href =
                        "${pageContext.request.contextPath}/admin-servlet/event-management/event-detail?actio=?eventID=" +
                        eventID;
            }

            function handleDeleteEvent(eventID) {
                Swal.fire({
                    title: "Xác nhận xóa",
                    text: "Bạn có chắc muốn xóa sự kiện này?",
                    icon: "warning",
                    showCancelButton: true,
                    confirmButtonText: "Có",
                    cancelButtonText: "Hủy",
                }).then((result) => {
                    if (result.isConfirmed) {
                        fetch(
                                "${pageContext.request.contextPath}/admin-servlet/event-management?action=delete&eventID=" +
                                eventID,
                                {
                                    method: "POST",
                                }
                        ).then((response) => {
                            if (response.ok) {
                                Swal.fire("Xóa thành công!", "", "success").then(() => {
                                    window.location.reload();
                                });
                            } else {
                                Swal.fire("Lỗi!", "Không thể xóa sự kiện.", "error");
                            }
                        });
                    }
                });
            }

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