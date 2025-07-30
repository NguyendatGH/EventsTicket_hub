<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dto.UserDTO" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    UserDTO user = (UserDTO) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login");
        return;
    }
    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cập nhật hồ sơ - MasterTicket</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        :root {
            --primary: #667aff;
            --secondary: #e06bce;
            --dark-bg: #161b22;
            --darker-bg: #0d1117;
            --card-bg: #21262d;
            --border-color: #30363d;
            --text-light: #e6edf3;
            --text-muted: #8b949e;
            --success: #00cc66;
            --warning: #ffcc00;
            --danger: #ff3333;
        }
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 50%, #0f3460 100%);
            color: var(--text-light);
            min-height: 100vh;
        }
        .header {
            background: var(--darker-bg);
            backdrop-filter: blur(10px);
            padding: 1rem 2rem;
            position: sticky;
            top: 0;
            z-index: 100;
            border-bottom: 1px solid var(--border-color);
        }
        .nav {
            display: flex;
            justify-content: space-between;
            align-items: center;
            max-width: 1400px;
            margin: 0 auto;
            flex-wrap: nowrap;
        }
        .logo {
            font-size: 1.5rem;
            font-weight: bold;
            color: var(--primary);
            text-decoration: none;
            flex-shrink: 0;
        }
        .nav-center-content {
            display: flex;
            align-items: center;
            flex-grow: 1;
            justify-content: center;
            gap: 1rem;
            flex-wrap: nowrap;
        }
        .nav-links {
            display: flex;
            gap: 1.5rem;
            list-style: none;
            flex-wrap: nowrap;
        }
        .nav-links a {
            color: var(--text-light);
            text-decoration: none;
            transition: color 0.3s;
            display: flex;
            align-items: center;
            gap: 5px;
            white-space: nowrap;
        }
        .nav-links a:hover { color: var(--primary); }
        .auth-buttons {
            display: flex;
            gap: 0.75rem;
            align-items: center;
            flex-shrink: 0;
            margin-left: 1rem;
            position: relative;
        }
        .btn {
            padding: 0.6rem 1.8rem;
            border: none;
            border-radius: 25px;
            cursor: pointer;
            font-weight: 500;
            font-size: 0.9rem;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-width: 100px;
            color: var(--text-light);
        }
        .btn-outline {
            background: transparent;
            border: 1px solid var(--border-color);
        }
        .btn-outline:hover {
            background: rgba(102, 122, 255, 0.2);
            color: var(--primary);
            border-color: var(--primary);
        }
        .btn-primary {
            background: var(--primary);
        }
        .btn-primary:hover {
            background: #5566dd;
            transform: translateY(-2px);
        }
        .user-menu {
            display: flex;
            align-items: center;
            gap: 1rem;
            position: relative;
        }
        .user-info {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            cursor: pointer;
            padding: 0.5rem 1rem;
            border-radius: 25px;
            background: rgba(255, 255, 255, 0.1);
            transition: all 0.3s;
        }
        .user-info:hover { background: rgba(255,255,255,0.15); }
        .user-avatar {
            width: 35px; height: 35px; border-radius: 50%; background-size: cover; background-position: center;
            border: 1px solid rgba(255,255,255,0.3); display: flex; align-items: center; justify-content: center;
            font-weight: bold; font-size: 0.9rem; background: linear-gradient(45deg, var(--primary), var(--secondary)); color: white;
        }
        .user-avatar img { width: 100%; height: 100%; object-fit: cover; border-radius: 50%; }
        .user-dropdown {
            position: absolute; top: calc(100% + 10px); right: 0; background: var(--darker-bg); backdrop-filter: blur(10px);
            border-radius: 10px; padding: 1rem; min-width: 200px; border: 1px solid var(--border-color); opacity: 0; visibility: hidden;
            transform: translateY(-10px); transition: all 0.3s ease-in-out; z-index: 101;
        }
        .user-dropdown.show { opacity: 1; visibility: visible; transform: translateY(0); }
        .dropdown-item { display: block; color: var(--text-light); text-decoration: none; padding: 0.75rem 0.5rem; border-bottom: 1px solid var(--border-color); transition: background 0.3s, color 0.3s; }
        .dropdown-item:last-child { border-bottom: none; }
        .dropdown-item:hover { background: rgba(102,122,255,0.2); color: var(--primary); }
        .container {
            max-width: 700px;
            margin: 2rem auto 0 auto;
            padding: 2rem;
            background: var(--card-bg);
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.15);
            border: 1px solid var(--border-color);
        }
        .profile-header { text-align: center; margin-bottom: 2rem; }
        .profile-header h2 { font-size: 2rem; margin-bottom: 0.5rem; color: var(--primary); }
        .profile-header p { color: var(--text-muted); font-size: 1.1rem; }
        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 1.5rem; margin-bottom: 2rem; }
        .form-group { display: flex; flex-direction: column; }
        .form-group.full-width { grid-column: 1 / -1; }
        .form-group label { margin-bottom: 0.5rem; font-weight: 500; color: var(--text-light); }
        .form-group input, .form-group select {
            padding: 1rem;
            border: 1px solid var(--border-color);
            border-radius: 10px;
            background: var(--card-bg);
            color: var(--text-light);
            font-size: 1rem;
            transition: all 0.3s ease;
        }
        .form-group input:focus, .form-group select:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(102, 122, 255, 0.2);
        }
        .form-group input::placeholder { color: var(--text-muted); }
        .form-group select option { background: var(--card-bg); color: var(--text-light); }
        .avatar-upload-group {
            display: flex; flex-direction: column; align-items: center; gap: 1rem; margin-bottom: 2rem; grid-column: 1 / -1;
        }
        .current-avatar-preview {
            width: 120px; height: 120px; border-radius: 50%; background-size: cover; background-position: center;
            border: 3px solid var(--primary); box-shadow: 0 5px 15px rgba(0,0,0,0.3); display: flex; align-items: center; justify-content: center;
            font-size: 3rem; font-weight: bold; color: var(--text-light); background: linear-gradient(45deg, var(--primary), var(--secondary));
        }
        .current-avatar-preview img { width: 100%; height: 100%; object-fit: cover; border-radius: 50%; }
        .avatar-upload-input {
            padding: 0.75rem;
            border: 1px solid var(--border-color);
            border-radius: 10px;
            background: var(--card-bg);
            color: var(--text-light);
            font-size: 1rem;
            cursor: pointer;
            width: fit-content;
        }
        .button-group { display: flex; gap: 1rem; justify-content: center; margin-top: 2rem; }
        .btn-secondary {
            background: transparent;
            color: var(--text-light);
            border: 2px solid var(--border-color);
        }
        .btn-secondary:hover {
            background: rgba(255,255,255,0.1);
        }
        .message, .error {
            padding: 1rem;
            border-radius: 10px;
            margin-top: 1rem;
            text-align: center;
            font-weight: 500;
        }
        .message {
            background: rgba(76, 175, 80, 0.2);
            border: 1px solid rgba(76, 175, 80, 0.5);
            color: #4CAF50;
        }
        .error {
            background: rgba(244, 67, 54, 0.2);
            border: 1px solid rgba(244, 67, 54, 0.5);
            color: #f44336;
        }
        .footer {
            background: var(--darker-bg);
            padding: 3rem 2rem;
            margin-top: 4rem;
            border-top: 1px solid var(--border-color);
        }
        .footer-content {
            max-width: 1400px;
            margin: 0 auto;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 2rem;
        }
        .footer-section h3 { color: var(--primary); margin-bottom: 1rem; font-size: 1.2rem; }
        .footer-section ul { list-style: none; }
        .footer-section ul li { margin-bottom: 0.5rem; }
        .footer-section ul li a { color: var(--text-muted); text-decoration: none; transition: color 0.3s; }
        .footer-section ul li a:hover { color: var(--text-light); }
        .subscribe-box { display: flex; gap: 0.5rem; margin-top: 1rem; border: 2px solid var(--primary); border-radius: 8px; padding: 5px; background: var(--card-bg); }
        .subscribe-box input { flex: 1; padding: 0.75rem; border: none; border-radius: 25px; background: transparent; color: var(--text-light); outline: none; }
        .subscribe-box input::placeholder { color: var(--text-muted); }
        .subscribe-box button { padding: 0.75rem 1rem; border: none; border-radius: 25px; background: var(--primary); color: var(--text-light); cursor: pointer; transition: background 0.3s; }
        .subscribe-box button:hover { background: #5566dd; }
        .language { display: flex; align-items: center; gap: 0.5rem; margin-top: 1rem; }
        .language img { width: 24px; height: 16px; cursor: pointer; transition: transform 0.3s; }
        .language img:hover { transform: scale(1.1); }
        .social-icons { display: flex; align-items: center; gap: 0.5rem; margin-top: 1rem; }
        .social-images img { width: 24px; height: 24px; cursor: pointer; transition: transform 0.3s; }
        .social-images img:hover { transform: scale(1.1); }
        @media (max-width: 992px) {
            .container { padding: 1rem; }
            .form-grid { grid-template-columns: 1fr; }
        }
        @media (max-width: 768px) {
            .nav { flex-direction: column; align-items: flex-start; }
            .logo { width: 100%; text-align: center; margin-bottom: 1rem; margin-right: 0; }
            .nav-center-content { flex-direction: column; width: 100%; margin-top: 0; gap: 0; }
            .nav-links, .search-filter-container { display: none; flex-direction: column; width: 100%; padding: 1rem 0; border-top: none; box-shadow: none; background: transparent; }
            .nav-links.active, .search-filter-container.active { display: flex; }
            .auth-buttons { width: 100%; justify-content: center; margin-left: 0; margin-top: 1rem; }
        }
    </style>
</head>
<body>
<%-- HEADER --%>
<header class="header">
    <nav class="nav">
        <a href="${pageContext.request.contextPath}/home" class="logo">MasterTicket</a>
        <div class="nav-center-content">
            <ul class="nav-links" id="navLinks">
                <li><a href="${pageContext.request.contextPath}/home"><i class="fas fa-home"></i> Trang chủ</a></li>
                <li><a href="#hot-events"><i class="fas fa-fire"></i> Sự kiện hot</a></li>
                <li><a href="#vouchers"><i class="fas fa-tags"></i> Săn voucher</a></li>
                <li><a href="#contact"><i class="fas fa-question-circle"></i> Hỗ trợ</a></li>
                <li><a href="${pageContext.request.contextPath}/tickets">🎫 Vé đã mua</a></li>
                <li><a href="${pageContext.request.contextPath}/support">Hỗ trợ</a></li>
            </ul>
        </div>
        <div class="auth-buttons">
            <c:choose>
                <c:when test="${sessionScope.user != null}">
                    <div class="user-menu">
                        <div class="user-info" onclick="toggleUserDropdown()">
                            <div class="user-avatar">
                                <% if (user.getAvatar() != null && !user.getAvatar().isEmpty()) { %>
                                    <img src="${pageContext.request.contextPath}/uploads/user_avatar/<%= user.getAvatar() %>" alt="Avatar">
                                <% } else { %>
                                    <%= user.getEmail().substring(0, 1).toUpperCase() %>
                                <% } %>
                            </div>
                            Xin chào, <%= user.getName() != null && !user.getName().isEmpty() ? user.getName() : user.getEmail() %> <span style="margin-left: 0.5rem;">▼</span>
                        </div>
                        <div class="user-dropdown" id="userDropdown">
                            <a href="${pageContext.request.contextPath}/updateProfile" class="dropdown-item">👤 Thông tin cá nhân</a>
                            <a href="${pageContext.request.contextPath}/TicketOrderHistoryServlet" class="dropdown-item">🎫 Vé đã mua</a>
                            <a href="${pageContext.request.contextPath}/favoriteEvents" class="dropdown-item">❤️ Sự kiện yêu thích</a>
                            <a href="${pageContext.request.contextPath}/settings" class="dropdown-item">⚙️ Cài đặt</a>
                            <hr style="border: none; border-top: 1px solid var(--border-color); margin: 0.5rem 0;">
                            <a href="${pageContext.request.contextPath}/logout" class="dropdown-item" style="color: var(--danger);">🚪 Đăng xuất</a>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/login" class="btn btn-outline">Đăng nhập</a>
                    <a href="${pageContext.request.contextPath}/register" class="btn btn-primary">Đăng ký</a>
                </c:otherwise>
            </c:choose>
        </div>
    </nav>
</header>
<main class="container">
    <div class="profile-header">
        <h2>Cập nhật hồ sơ</h2>
        <p>Cập nhật thông tin cá nhân của bạn</p>
    </div>
    <form method="post" action="updateProfile" enctype="multipart/form-data">
        <div class="avatar-upload-group">
            <label for="avatar">Ảnh đại diện</label>
            <div class="current-avatar-preview" id="currentAvatarPreview">
                <% if (user.getAvatar() != null && !user.getAvatar().isEmpty()) { %>
                    <img src="${pageContext.request.contextPath}/uploads/user_avatar/<%= user.getAvatar() %>" alt="Avatar" style="width: 100%; height: 100%; object-fit: cover; border-radius: 50%;">
                <% } else { %>
                    <%= user.getEmail().substring(0, 1).toUpperCase() %>
                <% } %>
            </div>
            <input type="file" id="avatar" name="avatar" accept="image/*" class="avatar-upload-input">
        </div>
        <div class="form-grid">
            <div class="form-group">
                <label for="gender">Giới tính</label>
                <select id="gender" name="gender" required>
                    <option value="">-- Chọn giới tính --</option>
                    <option value="Male" <%= "Male".equals(user.getGender()) ? "selected" : "" %>>Nam</option>
                    <option value="Female" <%= "Female".equals(user.getGender()) ? "selected" : "" %>>Nữ</option>
                    <option value="Other" <%= "Other".equals(user.getGender()) ? "selected" : "" %>>Khác</option>
                </select>
            </div>
            <div class="form-group">
                <label for="birthday">Ngày sinh</label>
                <input type="date" id="birthday" name="birthday" value="<%= user.getBirthday() != null ? dateFormat.format(user.getBirthday()) : "" %>" required>
            </div>
            <div class="form-group">
                <label for="phoneNumber">Số điện thoại</label>
                <input type="tel" id="phoneNumber" name="phoneNumber" value="<%= user.getPhoneNumber() != null ? user.getPhoneNumber() : "" %>" placeholder="Nhập số điện thoại" required>
            </div>
            <div class="form-group">
                <label for="email">Email</label>
                <input type="email" id="email" name="email" value="<%= user.getEmail() != null ? user.getEmail() : "" %>" placeholder="Nhập email" readonly style="opacity: 0.7;">
            </div>
            <div class="form-group full-width">
                <label for="address">Địa chỉ</label>
                <input type="text" id="address" name="address" value="<%= user.getAddress() != null ? user.getAddress() : "" %>" placeholder="Nhập địa chỉ đầy đủ" required>
            </div>
        </div>
        <div class="button-group">
            <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
            <a href="changePassword" class="btn btn-secondary">Đổi mật khẩu</a>
        </div>
        <% if (request.getAttribute("success") != null) { %>
            <div class="message"><%= request.getAttribute("success") %></div>
        <% } else if (request.getAttribute("error") != null) { %>
            <div class="error"><%= request.getAttribute("error") %></div>
        <% } %>
    </form>
</main>
<footer class="footer">
    <div class="footer-content">
        <div class="footer-section">
            <h3>Dịch vụ khách hàng</h3>
            <ul>
                <li><a href="#">FAQ</a></li>
                <li><a href="#">Liên hệ</a></li>
                <li><a href="#">Chính sách bảo mật</a></li>
                <li><a href="#">Điều khoản dịch vụ</a></li>
            </ul>
            <p><a href="mailto:support@masterticket.vn">support@masterticket.vn</a></p>
        </div>
        <div class="footer-section">
            <h3>Sơ đồ trang</h3>
            <ul>
                <li><a href="#">Tạo tài khoản</a></li>
                <li><a href="#">Tin tức</a></li>
                <li><a href="#">Sự kiện nổi bật</a></li>
            </ul>
        </div>
        <div class="footer-section">
            <h3>Đăng ký nhận thông tin</h3>
            <form class="subscribe-box">
                <input type="email" placeholder="Email của bạn..." required value="<%=(user != null ? user.getEmail() : "")%>"/>
                <button type="submit">Gửi</button>
            </form>
            <div class="language">
                <p>Ngôn ngữ:</p>
                <img src="https://flagcdn.com/w40/vn.png" alt="Tiếng Việt" />
                <img src="https://flagcdn.com/w40/gb.png" alt="English" />
            </div>
            <div class="social-icons">
                <p>Theo dõi chúng tôi:</p>
                <div class="social-images">
                    <img src="https://cdn-icons-png.flaticon.com/512/733/733547.png" alt="Facebook" />
                    <img src="https://cdn-icons-png.flaticon.com/512/2111/2111463.png" alt="Instagram" />
                    <img src="https://cdn-icons-png.flaticon.com/512/3046/3046120.png" alt="TikTok" />
                </div>
            </div>
        </div>
    </div>
</footer>
<script>
    function toggleUserDropdown() {
        const dropdown = document.getElementById("userDropdown");
        dropdown.classList.toggle("show");
    }
    window.addEventListener("click", function (e) {
        const userInfo = document.querySelector(".user-info");
        const dropdown = document.getElementById("userDropdown");
        if (!userInfo.contains(e.target) && !dropdown.contains(e.target)) {
            dropdown.classList.remove("show");
        }
    });
    document.getElementById('avatar').addEventListener('change', function (event) {
        const file = event.target.files[0];
        const currentAvatarPreview = document.getElementById('currentAvatarPreview');
        if (file) {
            const reader = new FileReader();
            reader.onload = function (e) {
                currentAvatarPreview.innerHTML = '';
                const img = document.createElement('img');
                img.src = e.target.result;
                img.alt = 'New Avatar';
                img.style.width = '100%';
                img.style.height = '100%';
                img.style.objectFit = 'cover';
                img.style.borderRadius = '50%';
                currentAvatarPreview.appendChild(img);
            };
            reader.readAsDataURL(file);
        } else {
            // Hiển thị lại avatar cũ hoặc ký tự đầu email
            var avatarUrl = '<%= user.getAvatar() != null && !user.getAvatar().isEmpty() ? (contextPath + "/uploads/user_avatar/" + user.getAvatar()) : "" %>';
            var avatarFallback = '<%= user.getEmail().substring(0, 1).toUpperCase() %>';
            if (avatarUrl) {
                currentAvatarPreview.innerHTML = '<img src="' + avatarUrl + '" alt="Current Avatar" style="width: 100%; height: 100%; object-fit: cover; border-radius: 50%;">';
            } else {
                currentAvatarPreview.innerHTML = avatarFallback;
            }
        }
    });
</script>
</body>
</html>