<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.User" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login");
        return;
    }
    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
    // Lấy đường dẫn cơ sở của ứng dụng để hiển thị ảnh avatar
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Cập nhật hồ sơ - MasterTicket</title>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: linear-gradient(135deg, #0f1419 0%, #1a202c 50%, #2d3748 100%);
                min-height: 100vh;
                color: #fff;
            }


            /* Header Styles */
            .header {
                background: rgba(255, 255, 255, 0.1);
                backdrop-filter: blur(10px);
                padding: 1rem 0;
                position: sticky;
                top: 0;
                z-index: 1000;
            }

            .nav-container {
                max-width: 1200px;
                margin: 0 auto;
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 0 2rem;
            }

            .logo {
                font-size: 1.5rem;
                font-weight: bold;
                color: #fff;
                text-decoration: none;
            }

            .search-container {
                display: flex;
                flex: 1;
                max-width: 400px;
                margin: 0 2rem;
            }

            .search-input {
                flex: 1;
                padding: 0.75rem 1rem;
                border: none;
                border-radius: 25px 0 0 25px;
                background: rgba(255, 255, 255, 0.2);
                color: #fff;
                backdrop-filter: blur(10px);
            }

            .search-input::placeholder {
                color: rgba(255, 255, 255, 0.7);
            }

            .search-btn {
                padding: 0.75rem 1.5rem;
                border: none;
                border-radius: 0 25px 25px 0;
                background: rgba(255, 255, 255, 0.3);
                color: #fff;
                cursor: pointer;
                transition: all 0.3s ease;
            }

            .search-btn:hover {
                background: rgba(255, 255, 255, 0.4);
            }

            /* User Menu */
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

            .user-info:hover {
                background: rgba(255, 255, 255, 0.15);
            }

            .user-avatar {
                width: 35px;
                height: 35px;
                border-radius: 50%;
                background-size: cover; /* Đảm bảo ảnh lấp đầy container */
                background-position: center; /* Căn giữa ảnh */
                border: 1px solid rgba(255, 255, 255, 0.3); /* Thêm viền cho đẹp */
                display: flex; /* Để căn giữa chữ cái đầu nếu không có ảnh */
                align-items: center;
                justify-content: center;
                font-weight: bold;
                font-size: 0.9rem;
                background: linear-gradient(45deg, #ff6b6b, #4ecdc4); /* Màu nền mặc định */
            }

            .user-dropdown {
                position: absolute;
                top: 100%;
                right: 0;
                background: rgba(0, 0, 0, 0.9);
                backdrop-filter: blur(10px);
                border-radius: 10px;
                padding: 1rem;
                min-width: 200px;
                border: 1px solid rgba(255, 255, 255, 0.1);
                opacity: 0;
                visibility: hidden;
                transform: translateY(-10px);
                transition: all 0.3s;
            }

            .user-dropdown.show {
                opacity: 1;
                visibility: visible;
                transform: translateY(0);
            }

            .dropdown-item {
                display: block;
                color: white;
                text-decoration: none;
                padding: 0.5rem 0;
                border-bottom: 1px solid rgba(255, 255, 255, 0.1);
                transition: color 0.3s;
            }

            .dropdown-item:last-child {
                border-bottom: none;
            }

            .dropdown-item:hover {
                color: #ff6b6b;
            }

            .auth-buttons {
                display: flex;
                gap: 1rem;
            }

            .btn-outline, .btn-filled {
                padding: 0.75rem 1.5rem;
                border: 2px solid rgba(255, 255, 255, 0.3);
                border-radius: 25px;
                text-decoration: none;
                color: #fff;
                font-weight: 500;
                transition: all 0.3s ease;
            }

            .btn-outline {
                background: transparent;
            }

            .btn-filled {
                background: linear-gradient(45deg, #667eea 0%, #764ba2 100%);
                border-color: transparent;
            }

            .btn-outline:hover, .btn-filled:hover {
                transform: translateY(-2px);
                box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
            }

            /* Navigation Menu */
            .nav-menu {
                background: rgba(255, 255, 255, 0.05);
                padding: 1rem 0;
            }

            .nav-links {
                max-width: 1200px;
                margin: 0 auto;
                display: flex;
                justify-content: center;
                gap: 3rem;
                padding: 0 2rem;
            }

            .nav-links a {
                color: rgba(255, 255, 255, 0.8);
                text-decoration: none;
                font-weight: 500;
                transition: all 0.3s ease;
                position: relative;
            }

            .nav-links a:hover {
                color: #fff;
            }

            .nav-links a::after {
                content: '';
                position: absolute;
                bottom: -5px;
                left: 0;
                width: 0;
                height: 2px;
                background: linear-gradient(45deg, #667eea, #764ba2);
                transition: width 0.3s ease;
            }

            .nav-links a:hover::after {
                width: 100%;
            }

            /* Main Content */
            .main-content {
                max-width: 800px;
                margin: 3rem auto;
                padding: 0 2rem;
                min-height: calc(100vh - 300px);
            }

            .profile-container {
                background: rgba(255, 255, 255, 0.1);
                backdrop-filter: blur(20px);
                border-radius: 20px;
                padding: 3rem;
                box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
                border: 1px solid rgba(255, 255, 255, 0.1);
            }

            .profile-header {
                text-align: center;
                margin-bottom: 2rem;
            }

            .profile-header h2 {
                font-size: 2rem;
                margin-bottom: 0.5rem;
                background: linear-gradient(45deg, #667eea, #764ba2);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                background-clip: text;
            }

            .profile-header p {
                color: rgba(255, 255, 255, 0.7);
                font-size: 1.1rem;
            }

            .form-grid {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 1.5rem;
                margin-bottom: 2rem;
            }

            .form-group {
                display: flex;
                flex-direction: column;
            }

            .form-group.full-width {
                grid-column: 1 / -1;
            }

            .form-group label {
                margin-bottom: 0.5rem;
                font-weight: 500;
                color: rgba(255, 255, 255, 0.9);
            }

            .form-group input,
            .form-group select {
                padding: 1rem;
                border: 1px solid rgba(255, 255, 255, 0.2);
                border-radius: 10px;
                background: rgba(255, 255, 255, 0.1);
                color: #fff;
                font-size: 1rem;
                transition: all 0.3s ease;
            }

            .form-group input:focus,
            .form-group select:focus {
                outline: none;
                border-color: #667eea;
                box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.2);
            }

            .form-group input::placeholder {
                color: rgba(255, 255, 255, 0.5);
            }

            .form-group select option {
                background: #2a5298;
                color: #fff;
            }

            /* Avatar upload specific styles */
            .avatar-upload-group {
                display: flex;
                flex-direction: column;
                align-items: center; /* Căn giữa avatar và nút upload */
                gap: 1rem;
                margin-bottom: 2rem;
                grid-column: 1 / -1; /* Chiếm toàn bộ chiều rộng */
            }

            .current-avatar-preview {
                width: 120px;
                height: 120px;
                border-radius: 50%;
                background-size: cover;
                background-position: center;
                border: 3px solid rgba(255, 255, 255, 0.5);
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 3rem;
                font-weight: bold;
                color: rgba(255, 255, 255, 0.7);
                background: linear-gradient(45deg, #ff6b6b, #4ecdc4); /* Màu nền mặc định */
            }

            .avatar-upload-input {
                padding: 0.75rem;
                border: 1px solid rgba(255, 255, 255, 0.2);
                border-radius: 10px;
                background: rgba(255, 255, 255, 0.1);
                color: #fff;
                font-size: 1rem;
                cursor: pointer;
                width: fit-content; /* Giúp input không quá rộng */
            }

            .avatar-upload-input::-webkit-file-upload-button {
                background: linear-gradient(45deg, #667eea 0%, #764ba2 100%);
                color: #fff;
                border: none;
                padding: 0.75rem 1.5rem;
                border-radius: 20px;
                cursor: pointer;
                transition: all 0.3s ease;
            }

            .avatar-upload-input::-webkit-file-upload-button:hover {
                transform: translateY(-2px);
                box-shadow: 0 5px 10px rgba(0, 0, 0, 0.2);
            }


            .button-group {
                display: flex;
                gap: 1rem;
                justify-content: center;
                margin-top: 2rem;
            }

            .btn-primary, .btn-secondary {
                padding: 1rem 2rem;
                border: none;
                border-radius: 25px;
                font-size: 1rem;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                text-decoration: none;
                display: inline-block;
                text-align: center;
            }

            .btn-primary {
                background: linear-gradient(45deg, #667eea 0%, #764ba2 100%);
                color: #fff;
            }

            .btn-secondary {
                background: transparent;
                color: #fff;
                border: 2px solid rgba(255, 255, 255, 0.3);
            }

            .btn-primary:hover, .btn-secondary:hover {
                transform: translateY(-3px);
                box-shadow: 0 15px 30px rgba(0, 0, 0, 0.2);
            }

            .btn-secondary:hover {
                background: rgba(255, 255, 255, 0.1);
            }

            /* Message Styles */
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

            /* Footer */
            .footer {
                background: rgba(0, 0, 0, 0.3);
                backdrop-filter: blur(10px);
                padding: 3rem 0 1rem;
                margin-top: 4rem;
            }

            .footer-content {
                max-width: 1200px;
                margin: 0 auto;
                padding: 0 2rem;
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                gap: 2rem;
            }

            .footer-section h3 {
                margin-bottom: 1rem;
                color: #fff;
            }

            .footer-section ul {
                list-style: none;
            }

            .footer-section ul li {
                margin-bottom: 0.5rem;
            }

            .footer-section ul li a {
                color: rgba(255, 255, 255, 0.7);
                text-decoration: none;
                transition: color 0.3s ease;
            }

            .footer-section ul li a:hover {
                color: #fff;
            }

            .newsletter {
                display: flex;
                margin-top: 1rem;
            }

            .newsletter input {
                flex: 1;
                padding: 0.75rem;
                border: none;
                border-radius: 25px 0 0 25px;
                background: rgba(255, 255, 255, 0.1);
                color: #fff;
            }

            .newsletter button {
                padding: 0.75rem 1.5rem;
                border: none;
                border-radius: 0 25px 25px 0;
                background: linear-gradient(45deg, #667eea, #764ba2);
                color: #fff;
                cursor: pointer;
            }

            .social-links {
                display: flex;
                gap: 1rem;
                margin-top: 1rem;
            }

            .social-links a {
                width: 40px;
                height: 40px;
                border-radius: 50%;
                background: rgba(255, 255, 255, 0.1);
                display: flex;
                align-items: center;
                justify-content: center;
                color: #fff;
                text-decoration: none;
                transition: all 0.3s ease;
            }

            .social-links a:hover {
                background: linear-gradient(45deg, #667eea, #764ba2);
                transform: translateY(-2px);
            }

            .footer-bottom {
                text-align: center;
                padding: 2rem 0;
                border-top: 1px solid rgba(255, 255, 255, 0.1);
                margin-top: 2rem;
                color: rgba(255, 255, 255, 0.7);
            }

            .language-flags {
                display: flex;
                gap: 0.5rem;
                margin-top: 1rem;
            }

            .language-flags img {
                width: 30px;
                height: 20px;
                border-radius: 3px;
                cursor: pointer;
                transition: transform 0.3s ease;
            }

            .language-flags img:hover {
                transform: scale(1.1);
            }

            /* Responsive Design */
            @media (max-width: 768px) {
                .nav-container {
                    flex-direction: column;
                    gap: 1rem;
                }

                .search-container {
                    order: 3;
                    max-width: 100%;
                    margin: 0;
                }

                .nav-links {
                    flex-wrap: wrap;
                    gap: 1rem;
                }

                .form-grid {
                    grid-template-columns: 1fr;
                }

                .button-group {
                    flex-direction: column;
                }

                .profile-container {
                    padding: 2rem;
                }
            }
        </style>
    </head>
    <body>
        <header class="header">
            <div class="nav-container">
                <a href="/" class="logo">MasterTicket</a>
                <div class="search-container">
                    <input type="text" class="search-input" placeholder="Bạn tìm gì hôm nay ?">
                    <button class="search-btn">Tìm kiếm</button>
                </div>
                <div class="user-menu">
                    <div class="user-info" onclick="toggleUserDropdown()">
                        <% if (user.getAvatar() != null && !user.getAvatar().isEmpty()) { %>
                        <%-- Sử dụng ImageServlet để phục vụ ảnh từ đường dẫn tuyệt đối --%>
                        <div class="user-avatar" style="background-image: url('<%= request.getContextPath() %>/images/<%= user.getAvatar() %>');"></div>
                        <% } else { %>
                        <div class="user-avatar"><%= user.getEmail().substring(0, 1).toUpperCase() %></div>
                        <% } %>
                        Xin chào, <%= user.getEmail() %> <span style="margin-left: 0.5rem;">▼</span>
                    </div>
                    <div class="user-dropdown" id="userDropdown">
                        <a href="updateProfile" class="dropdown-item">👤 Thông tin cá nhân</a>
                        <a href="#tickets" class="dropdown-item">🎫 Vé đã mua</a>
                        <a href="#favorites" class="dropdown-item">❤️ Sự kiện yêu thích</a>
                        <a href="#settings" class="dropdown-item">⚙️ Cài đặt</a>
                        <hr style="border: none; border-top: 1px solid rgba(255,255,255,0.1); margin: 0.5rem 0;">
                        <a href="LogoutServlet" class="dropdown-item" style="color: #ff6b6b;">🚪 Đăng xuất</a>
                    </div>
                </div>
            </div>
        </header>

        <nav class="nav-menu">
            <div class="nav-links">
                <a href="userPage/userHomePage/">Trang Chủ</a>
                <a href="/events">Các sự kiện hot</a>
                <a href="/vouchers">Sản voucher giảm giá</a>
                <a href="/create-event">Tạo sự kiện</a>
                <a href="/support">Hỗ trợ</a>
            </div>
        </nav>

        <main class="main-content">
            <div class="profile-container">
                <div class="profile-header">
                    <h2>Cập nhật hồ sơ</h2>
                    <p>Cập nhật thông tin cá nhân của bạn</p>
                </div>

                <form method="post" action="updateProfile" enctype="multipart/form-data">
                    <div class="avatar-upload-group">
                        <label for="avatar">Ảnh đại diện</label>
                        <div class="current-avatar-preview" id="avatarPreview">
                            <% if (user.getAvatar() != null && !user.getAvatar().isEmpty()) { %>
                            <%-- Sử dụng ImageServlet để phục vụ ảnh từ đường dẫn tuyệt đối --%>
                            <img src="<%= request.getContextPath() %>/images/<%= user.getAvatar() %>" alt="Current Avatar" style="width: 100%; height: 100%; object-fit: cover; border-radius: 50%;">
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
                            <input type="date" id="birthday" name="birthday"
                                   value="<%= user.getBirthday() != null ? dateFormat.format(user.getBirthday()) : "" %>" required>
                        </div>

                        <div class="form-group">
                            <label for="phoneNumber">Số điện thoại</label>
                            <input type="tel" id="phoneNumber" name="phoneNumber"
                                   value="<%= user.getPhoneNumber() != null ? user.getPhoneNumber() : "" %>"
                                   placeholder="Nhập số điện thoại" required>
                        </div>

                        <div class="form-group">
                            <label for="email">Email</label>
                            <input type="email" id="email" name="email"
                                   value="<%= user.getEmail() != null ? user.getEmail() : "" %>"
                                   placeholder="Nhập email" readonly style="opacity: 0.7;">
                        </div>

                        <div class="form-group full-width">
                            <label for="address">Địa chỉ</label>
                            <input type="text" id="address" name="address"
                                   value="<%= user.getAddress() != null ? user.getAddress() : "" %>"
                                   placeholder="Nhập địa chỉ đầy đủ" required>
                        </div>
                    </div>

                    <div class="button-group">
                        <button type="submit" class="btn-primary">Lưu thay đổi</button>
                        <a href="changePassword" class="btn-secondary">Đổi mật khẩu</a>
                    </div>

                    <% if (request.getAttribute("success") != null) { %>
                    <div class="message"><%= request.getAttribute("success") %></div>
                    <% } else if (request.getAttribute("error") != null) { %>
                    <div class="error"><%= request.getAttribute("error") %></div>
                    <% } %>
                </form>
            </div>
        </main>

        <footer class="footer">
            <div class="footer-content">
                <div class="footer-section">
                    <h3>Customer Services</h3>
                    <ul>
                        <li><a href="/faqs">FAQs</a></li>
                        <li><a href="/contact">Contact us</a></li>
                        <li><a href="/privacy">Privacy Policy</a></li>
                        <li><a href="/terms">Terms of Service</a></li>
                    </ul>
                </div>

                <div class="footer-section">
                    <h3>SiteMap</h3>
                    <ul>
                        <li><a href="/create-account">Create Account</a></li>
                        <li><a href="/news">News</a></li>
                        <li><a href="/top-events">Top-Rated Event</a></li>
                    </ul>
                </div>

                <div class="footer-section">
                    <h3>Subscribe for event updates</h3>
                    <div class="newsletter">
                        <input type="email" placeholder="Your email...">
                        <button type="submit">📧</button>
                    </div>

                    <h3 style="margin-top: 2rem;">Language:</h3>
                    <div class="language-flags">
                        <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 30 20'%3E%3Crect width='30' height='20' fill='%23da251d'/%3E%3Cpolygon points='6,4 11,10 6,16' fill='%23ffff00'/%3E%3C/svg%3E" alt="Tiếng Việt">
                        <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 30 20'%3E%3Crect width='30' height='20' fill='%23012169'/%3E%3Cpath d='M0,0 L30,20 M30,0 L0,20' stroke='%23fff' stroke-width='3'/%3E%3Cpath d='M15,0 V20 M0,10 H30' stroke='%23fff' stroke-width='5'/%3E%3Cpath d='M15,0 V20 M0,10 H30' stroke='%23c8102e' stroke-width='3'/%3E%3C/svg%3E" alt="English">
                    </div>
                </div>

                <div class="footer-section">
                    <h3>Follow us:</h3>
                    <div class="social-links">
                        <a href="#" title="Facebook">f</a>
                        <a href="#" title="Instagram">📷</a>
                        <a href="#" title="Threads">@</a>
                        <a href="#" title="TikTok">🎵</a>
                    </div>

                    <p style="margin-top: 2rem; color: rgba(255,255,255,0.7);">
                        Email: <a href="mailto:support@masterticket.vn" style="color: rgba(255,255,255,0.7);">support@masterticket.vn</a>
                    </p>
                </div>
            </div>

            <div class="footer-bottom">
                <p>&copy; 2025 MasterTicket. All rights reserved.</p>
            </div>
        </footer>
    </body>
    <script>
        function toggleUserDropdown() {
            const dropdown = document.getElementById("userDropdown");
            dropdown.classList.toggle("show");
        }

        // Đóng dropdown nếu click ra ngoài
        window.addEventListener("click", function (e) {
            const userInfo = document.querySelector(".user-info");
            const dropdown = document.getElementById("userDropdown");

            if (!userInfo.contains(e.target) && !dropdown.contains(e.target)) {
                dropdown.classList.remove("show");
            }
        });

        // JavaScript để xem trước ảnh avatar
        document.getElementById('avatar').addEventListener('change', function (event) {
            const file = event.target.files[0];
            const avatarPreview = document.getElementById('avatarPreview');

            if (file) {
                const reader = new FileReader();
                reader.onload = function (e) {
                    // Xóa nội dung chữ cái đầu nếu có
                    avatarPreview.innerHTML = '';
                    // Tạo thẻ img và thêm vào preview
                    const img = document.createElement('img');
                    img.src = e.target.result;
                    img.alt = 'New Avatar';
                    img.style.width = '100%';
                    img.style.height = '100%';
                    img.style.objectFit = 'cover';
                    img.style.borderRadius = '50%';
                    avatarPreview.appendChild(img);
                };
                reader.readAsDataURL(file);
            } else {
                // Nếu không có file được chọn, hiển thị lại avatar cũ hoặc chữ cái đầu
                // Lấy đường dẫn avatar hiện tại từ thuộc tính data-current-avatar
                const currentAvatarPath = avatarPreview.dataset.currentAvatar;
                if (currentAvatarPath) {
                    avatarPreview.innerHTML = ''; // Xóa chữ cái đầu nếu có
                    const img = document.createElement('img');
                    img.src = currentAvatarPath;
                    img.alt = 'Current Avatar';
                    img.style.width = '100%';
                    img.style.height = '100%';
                    img.style.objectFit = 'cover';
                    img.style.borderRadius = '50%';
                    avatarPreview.appendChild(img);
                } else {
                    avatarPreview.innerHTML = '<%= user.getEmail().substring(0, 1).toUpperCase() %>';
                }
            }
        });

        // Cập nhật thuộc tính data-current-avatar khi trang tải
        document.addEventListener('DOMContentLoaded', function () {
            const avatarPreview = document.getElementById('avatarPreview');
        <% if (user.getAvatar() != null && !user.getAvatar().isEmpty()) { %>
            // Đảm bảo đường dẫn này khớp với cách ImageServlet phục vụ ảnh
        avatarPreview.dataset.currentAvatar = '<%= request.getContextPath() %>/images/<%= user.getAvatar() %>';
        <% } else { %>
                    avatarPreview.dataset.currentAvatar = ''; // Không có avatar hiện tại
        <% } %>
                });
    </script>
</html>
