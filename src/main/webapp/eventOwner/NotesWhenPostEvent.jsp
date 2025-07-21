<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>MasterTicket</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: linear-gradient(135deg, #122536 0%, #764ba2 100%);
                min-height: 100vh;
                color: white;
            }

            /* Header */
            .header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 1rem 2rem;
                background: rgba(0, 0, 0, 0.2);
                backdrop-filter: blur(10px);
            }

            .logo {
                font-size: 1.5rem;
                font-weight: bold;
                color: white;
            }

            .nav-menu {
                display: flex;
                gap: 2rem;
                list-style: none;
            }

            .nav-menu a {
                color: white;
                text-decoration: none;
                transition: color 0.3s;
            }

            .nav-menu a:hover {
                color: #ff6b6b;
            }

            .nav-menu .create-event {
                color: #ff6b6b;
            }

            .header-actions {
                display: flex;
                gap: 1rem;
                align-items: center;
            }

            .create-event-btn {
                background: linear-gradient(45deg, #ff6b6b, #ff8e8e);
                border: none;
                padding: 0.7rem 1.5rem;
                border-radius: 25px;
                color: white;
                cursor: pointer;
                font-weight: 500;
                font-size: 0.9rem;
                display: flex;
                align-items: center;
                gap: 0.5rem;
                transition: all 0.3s ease;
                box-shadow: 0 4px 15px rgba(255, 107, 107, 0.3);
                 text-decoration: none;
            }

            .create-event-btn:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(255, 107, 107, 0.4);
                background: linear-gradient(45deg, #ff5252, #ff6b6b);
            }

            .create-event-btn:active {
                transform: translateY(0);
            }

            .logout-btn {
                background: linear-gradient(45deg, #667eea, #764ba2);
                border: none;
                padding: 0.5rem 1rem;
                border-radius: 20px;
                color: white;
                cursor: pointer;
                transition: transform 0.3s;
            }

            .logout-btn:hover {
                transform: translateY(-2px);
            }

            /* Main Container */
            .container {
                display: flex;
                min-height: calc(100vh - 80px);
            }

            /* Sidebar */
            .sidebar {
                width: 250px;
                background: rgba(0, 0, 0, 0.3);
                backdrop-filter: blur(10px);
                padding: 2rem 0;
            }

            .sidebar-header {
                display: flex;
                align-items: center;
                gap: 0.5rem;
                padding: 0 2rem;
                margin-bottom: 2rem;
            }

            .sidebar-header .icon {
                width: 12px;
                height: 12px;
                background: #4CAF50;
                border-radius: 50%;
            }

            .sidebar-menu {
                list-style: none;
            }

            .sidebar-menu li {
                padding: 1rem 2rem;
                display: flex;
                align-items: center;
                gap: 1rem;
                cursor: pointer;
                transition: background 0.3s;
            }

            .sidebar-menu li:hover {
                background: rgba(255, 255, 255, 0.1);
            }

            .sidebar-menu li.active {
                background: rgba(255, 255, 255, 0.2);
                border-right: 3px solid #ff6b6b;
            }

            /* Main Content */
            .main-content {
                flex: 1;
                display: flex;
                align-items: center;
                justify-content: center;
                position: relative;
            }

            /* Modal Overlay */
            .modal-overlay {
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0, 0, 0, 0.5);
                display: flex;
                align-items: center;
                justify-content: center;
                z-index: 1000;
            }

            .modal {
                background: #f0f0f0;
                padding: 2rem;
                border-radius: 10px;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
                max-width: 600px;
                width: 90%;
                color: #333;
                text-align: left;
            }

            .modal h3 {
                text-align: center;
                margin-bottom: 1.5rem;
                color: #333;
                font-size: 1.2rem;
            }

            .modal-content {
                line-height: 1.6;
                font-size: 14px;
            }

            .modal-content ol {
                padding-left: 1.5rem;
            }

            .modal-content li {
                margin-bottom: 0.8rem;
            }

            .modal-btn {
                background: #ccc;
                border: none;
                padding: 0.5rem 2rem;
                border-radius: 5px;
                color: #666;
                cursor: pointer;
                margin-top: 2rem;
                transition: background 0.3s;
            }

            .modal-btn:hover {
                background: #bbb;
            }

            /* Footer */
            .footer {
                background: rgba(0, 0, 0, 0.8);
                padding: 3rem 2rem 2rem;
                margin-top: auto;
            }

            .footer-content {
                display: grid;
                grid-template-columns: 1fr 1fr 2fr;
                gap: 3rem;
                max-width: 1200px;
                margin: 0 auto;
            }

            .footer-section h3 {
                margin-bottom: 1rem;
                color: #ccc;
            }

            .footer-section ul {
                list-style: none;
            }

            .footer-section ul li {
                margin-bottom: 0.5rem;
            }

            .footer-section ul li a {
                color: #aaa;
                text-decoration: none;
                transition: color 0.3s;
            }

            .footer-section ul li a:hover {
                color: white;
            }

            .newsletter {
                margin-bottom: 2rem;
            }

            .newsletter-form {
                display: flex;
                margin-top: 1rem;
            }

            .newsletter-input {
                flex: 1;
                padding: 0.8rem;
                border: none;
                border-radius: 5px 0 0 5px;
                background: rgba(255, 255, 255, 0.1);
                color: white;
            }

            .newsletter-input::placeholder {
                color: #ccc;
            }

            .newsletter-btn {
                background: #4CAF50;
                border: none;
                padding: 0.8rem 1rem;
                border-radius: 0 5px 5px 0;
                color: white;
                cursor: pointer;
            }

            .language-flags {
                display: flex;
                gap: 0.5rem;
                margin-top: 1rem;
            }

            .flag {
                width: 30px;
                height: 20px;
                cursor: pointer;
                border-radius: 3px;
            }

            .flag.vn {
                background: linear-gradient(to bottom, #da020e 50%, #ffff00 50%);
                position: relative;
            }

            .flag.vn::after {
                content: '★';
                position: absolute;
                top: 50%;
                left: 50%;
                transform: translate(-50%, -50%);
                color: #ffff00;
                font-size: 12px;
            }

            .flag.uk {
                background: linear-gradient(45deg, #012169 25%, transparent 25%, transparent 75%, #012169 75%),
                    linear-gradient(-45deg, #012169 25%, transparent 25%, transparent 75%, #012169 75%),
                    linear-gradient(45deg, transparent 37.5%, #C8102E 37.5%, #C8102E 62.5%, transparent 62.5%),
                    linear-gradient(-45deg, transparent 37.5%, #C8102E 37.5%, #C8102E 62.5%, transparent 62.5%);
                background-size: 8px 8px;
            }

            .social-icons {
                display: flex;
                gap: 1rem;
                margin-top: 1rem;
            }

            .social-icon {
                width: 35px;
                height: 35px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                cursor: pointer;
                transition: transform 0.3s;
            }

            .social-icon:hover {
                transform: translateY(-2px);
            }

            .social-icon.facebook {
                background: #3b5998;
            }
            .social-icon.instagram {
                background: linear-gradient(45deg, #f09433, #e6683c, #dc2743, #cc2366, #bc1888);
            }
            .social-icon.thread {
                background: #000;
            }
            .social-icon.tiktok {
                background: #000;
            }

            .contact-info {
                margin-top: 2rem;
                color: #aaa;
            }

            .contact-info a {
                color: #4CAF50;
                text-decoration: none;
            }

            /* Responsive */
            @media (max-width: 768px) {
                .container {
                    flex-direction: column;
                }

                .sidebar {
                    width: 100%;
                    order: 2;
                }

                .header-actions {
                    flex-direction: column;
                    gap: 0.5rem;
                }

                .create-event-btn {
                    padding: 0.5rem 1rem;
                    font-size: 0.8rem;
                }

                .footer-content {
                    grid-template-columns: 1fr;
                    gap: 2rem;
                }

                .newsletter-form {
                    flex-direction: column;
                    gap: 0.5rem;
                }

                .newsletter-btn {
                    border-radius: 5px;
                }
            }
        </style>
    </head>
    <body>
        <!-- Header -->
        <header class="header">
            <div class="logo">MasterTicket</div>
            <nav>
                <ul class="nav-menu">
                    <li><a href="${pageContext.request.contextPath}/home">Trang chủ</a></li>
                    <li><a href="${pageContext.request.contextPath}/buy">Các sự kiện hot</a></li>
                    <li><a href="${pageContext.request.contextPath}/shows">Săn voucher giảm giá</a></li>
                    <li><a href="${pageContext.request.contextPath}/create-event" class="create-event">Tạo sự kiện</a></li>
                    <li><a href="${pageContext.request.contextPath}/offers">Hỗ trợ</a></li>
                </ul>
            </nav>
         <a href="${pageContext.request.contextPath}/organizer-servlet?action=createForm" class="create-event-btn">
            <i class="fas fa-plus"></i>
            Tạo sự kiện
        </a>

        </header>

        <!-- Main Container -->
        <div class="container">
            <!-- Sidebar -->
            <aside class="sidebar">
                <div class="sidebar-header">
                    <div class="icon"></div>
                    <span>MasterTicket</span>
                </div>
                <ul class="sidebar-menu">
                    <li class="active">
                        <i class="fas fa-calendar"></i>
                        <span> Sự kiện của tôi</span>
                    </li>
                    <li>
                        <i class="fas fa-chart-bar"></i>
                        <span>Quản lí báo cáo</span>
                    </li>
                    <li>
                        <i class="fas fa-cog"></i>
                        <span>Điều khoản</span>
                    </li>
                </ul>
            </aside>

            <!-- Main Content -->
            <main class="main-content">
                <!-- Modal -->
                <div class="modal-overlay" id="modalOverlay">
                    <div class="modal">
                        <h3>NOTES WHEN POSTING AN EVENT</h3>
                        <div class="modal-content">
                            <ol>
                                <li>Please do not display the Organizer's contact information (e.g., phone number/ email/ social media page) on the event page on the banner or in the content of the post. Only use the Ticketbox Hotline - 1900.6408</li>
                                <li>If the Organizer creates or updates the event in violation of the above rules, Ticketbox reserves the right to reject event approval.</li>
                                <li>Ticketbox regularly checks the information of events displayed on the platform. If the information violates the above rules, Ticketbox has the right to remove or refuse to provide services for those events, based on clause 2.9 in the Service Agreement.</li>
                            </ol>
                        </div>
                        <div style="text-align: center;">
                            <button class="modal-btn" onclick="closeModal()">OK</button>
                        </div>
                    </div>
                </div>
            </main>
        </div>

        <!-- Footer -->
        <footer class="footer">
            <div class="footer-content">
                <!-- Customer Services -->
                <div class="footer-section">
                    <h3>Customer Services</h3>
                    <ul>
                        <li><a href="${pageContext.request.contextPath}/faqs">FAQS</a></li>
                        <li><a href="${pageContext.request.contextPath}/contact">Contact us</a></li>
                        <li><a href="${pageContext.request.contextPath}/privacy">Privacy Policy</a></li>
                        <li><a href="${pageContext.request.contextPath}/terms">Terms of Service</a></li>
                    </ul>
                </div>

                <!-- SiteMap -->
                <div class="footer-section">
                    <h3>SiteMap</h3>
                    <ul>
                        <li><a href="${pageContext.request.contextPath}/create-account">Create Account</a></li>
                        <li><a href="${pageContext.request.contextPath}/news">News</a></li>
                        <li><a href="${pageContext.request.contextPath}/top-events">Top-Rated Event</a></li>
                    </ul>
                </div>

                <!-- Newsletter & Contact -->
                <div class="footer-section">
                    <div class="newsletter">
                        <h3>Subscribe for event updates.</h3>
                        <form class="newsletter-form" onsubmit="subscribe(event)">
                            <input type="email" class="newsletter-input" placeholder="Your email..." required>
                            <button type="submit" class="newsletter-btn">
                                <i class="fas fa-arrow-right"></i>
                            </button>
                        </form>
                    </div>

                    <div>
                        <h3>Language:</h3>
                        <div class="language-flags">
                            <div class="flag vn" onclick="changeLanguage('vi')" title="Tiếng Việt"></div>
                            <div class="flag uk" onclick="changeLanguage('en')" title="English"></div>
                        </div>
                    </div>

                    <div>
                        <h3>Follow us:</h3>
                        <div class="social-icons">
                            <div class="social-icon facebook" onclick="openSocial('facebook')">
                                <i class="fab fa-facebook-f"></i>
                            </div>
                            <div class="social-icon instagram" onclick="openSocial('instagram')">
                                <i class="fab fa-instagram"></i>
                            </div>
                            <div class="social-icon thread" onclick="openSocial('thread')">
                                <i class="fab fa-threads"></i>
                            </div>
                            <div class="social-icon tiktok" onclick="openSocial('tiktok')">
                                <i class="fab fa-tiktok"></i>
                            </div>
                        </div>
                    </div>

                    <div class="contact-info">
                        <p>Email: <a href="mailto:support@masterTicket.vn">support@masterTicket.vn</a></p>
                    </div>
                </div>
            </div>
        </footer>

        <script>
            // Modal functionality
            function closeModal() {
                document.getElementById('modalOverlay').style.display = 'none';
            }

            function showModal(content) {
                document.querySelector('.modal p').textContent = content;
                document.getElementById('modalOverlay').style.display = 'flex';
            }

            // Navigation functions
            function logout() {
                if (confirm('Bạn có chắc chắn muốn đăng xuất?')) {
                    window.location.href = '${pageContext.request.contextPath}/logout';
                }
            }

            function createEvent() {
                // Redirect to create event page
                window.location.href = '${pageContext.request.contextPath}/create-event';
            }

            function subscribe(event) {
                event.preventDefault();
                const email = event.target.querySelector('input').value;
                alert('Cảm ơn bạn đã đăng ký nhận thông tin với email: ' + email);
                event.target.reset();
            }

            function changeLanguage(lang) {
                // Implement language change functionality
                console.log('Changing language to:', lang);
                // You can redirect to different language versions or use i18n
            }

            function openSocial(platform) {
                const urls = {
                    facebook: 'https://facebook.com/masterticket',
                    instagram: 'https://instagram.com/masterticket',
                    thread: 'https://threads.net/@masterticket',
                    tiktok: 'https://tiktok.com/@masterticket'
                };
                window.open(urls[platform], '_blank');
            }

            // Sidebar menu functionality
            document.querySelectorAll('.sidebar-menu li').forEach(item => {
                item.addEventListener('click', function () {
                    document.querySelectorAll('.sidebar-menu li').forEach(li => li.classList.remove('active'));
                    this.classList.add('active');

                    const menuText = this.querySelector('span').textContent;
                    showModal('Bạn đã chọn: ' + menuText);
                });
            });

            // Close modal when clicking outside
            document.getElementById('modalOverlay').addEventListener('click', function (e) {
                if (e.target === this) {
                    closeModal();
                }
            });

            // Initialize modal display
            document.addEventListener('DOMContentLoaded', function () {
                // Modal is visible by default, no need to show it again
            });
        </script>
    </body>
</html>