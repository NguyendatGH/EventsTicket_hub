<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Event Dashboard - MasterTicket</title>
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
            color: #fff;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
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
        }

        .sidebar .brand {
            color: #4CAF50;
            font-size: 20px;
            font-weight: bold;
            margin-bottom: 30px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .sidebar .menu {
            list-style: none;
        }

        .sidebar .menu li {
            margin-bottom: 15px;
        }

        .sidebar .menu a {
            color: #d8cbcb;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 10px;
            border-radius: 5px;
            transition: all 0.3s;
        }

        .sidebar .menu a:hover,
        .sidebar .menu a.active {
            background: rgba(76, 175, 80, 0.2);
            color: #4CAF50;
            transform: translateX(5px);
        }

        .main-content {
            margin-left: 270px;
            padding: 20px;
        }

        .navbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 0;
            border-bottom: 1px solid rgba(255,255,255,0.1);
            margin-bottom: 30px;
        }

        .navbar .nav-links {
            display: flex;
            gap: 30px;
            list-style: none;
        }

        .navbar .nav-links a {
            color: #fff;
            text-decoration: none;
            opacity: 0.8;
            transition: all 0.3s;
            padding: 8px 16px;
            border-radius: 20px;
        }

        .navbar .nav-links a:hover,
        .navbar .nav-links a.active {
            opacity: 1;
            color: #4CAF50;
            background: rgba(76, 175, 80, 0.1);
        }

        .navbar .user-info {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-block;
        }

        .btn-primary {
            background: #4CAF50;
            color: white;
        }

        .btn-primary:hover {
            background: #45a049;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(76, 175, 80, 0.3);
        }

        .btn-logout {
            background: linear-gradient(45deg, #ff6b6b, #ee5a24);
            color: white;
            border-radius: 20px;
            padding: 8px 16px;
            font-size: 12px;
        }

        .btn-logout:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(255, 107, 107, 0.3);
        }

        .dashboard-header {
            background: rgba(255,255,255,0.1);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 30px;
            text-align: center;
        }

        .dashboard-header h1 {
            font-size: 2.5rem;
            margin-bottom: 10px;
            background: linear-gradient(45deg, #4CAF50, #45a049);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: rgba(255,255,255,0.1);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            padding: 25px;
            text-align: center;
            transition: all 0.3s;
            border: 1px solid rgba(255,255,255,0.1);
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.2);
            border-color: #4CAF50;
        }

        .stat-card .icon {
            font-size: 3rem;
            margin-bottom: 15px;
        }

        .stat-card .number {
            font-size: 2rem;
            font-weight: bold;
            color: #4CAF50;
            margin-bottom: 5px;
        }

        .stat-card .label {
            color: rgba(255,255,255,0.8);
            font-size: 0.9rem;
        }

        .content-section {
            background: rgba(255,255,255,0.1);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 30px;
        }

        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
        }

        .section-header h2 {
            color: #4CAF50;
            font-size: 1.5rem;
        }

        .event-list {
            display: grid;
            gap: 15px;
        }

        .event-item {
            background: rgba(255,255,255,0.05);
            border-radius: 10px;
            padding: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            transition: all 0.3s;
            border: 1px solid rgba(255,255,255,0.1);
        }

        .event-item:hover {
            background: rgba(255,255,255,0.1);
            transform: translateX(5px);
        }

        .event-info h3 {
            color: #4CAF50;
            margin-bottom: 5px;
        }

        .event-info p {
            color: rgba(255,255,255,0.7);
            font-size: 0.9rem;
        }

        .event-status {
            padding: 5px 12px;
            border-radius: 15px;
            font-size: 0.8rem;
            font-weight: bold;
        }

        .status-active {
            background: rgba(76, 175, 80, 0.2);
            color: #4CAF50;
            border: 1px solid #4CAF50;
        }

        .status-pending {
            background: rgba(255, 193, 7, 0.2);
            color: #ffc107;
            border: 1px solid #ffc107;
        }

        .status-ended {
            background: rgba(244, 67, 54, 0.2);
            color: #f44336;
            border: 1px solid #f44336;
        }

        .quick-actions {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-top: 20px;
        }

        .action-btn {
            background: rgba(255,255,255,0.1);
            border: 1px solid rgba(255,255,255,0.2);
            color: #fff;
            padding: 15px;
            border-radius: 10px;
            text-align: center;
            text-decoration: none;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            gap: 10px;
            justify-content: center;
        }

        .action-btn:hover {
            background: rgba(76, 175, 80, 0.2);
            border-color: #4CAF50;
            color: #4CAF50;
            transform: translateY(-2px);
        }

        .footer {
            background: rgba(0,0,0,0.5);
            margin-top: 50px;
            padding: 40px 0;
            color: rgba(255,255,255,0.8);
        }

        .footer-content {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 30px;
        }

        .footer-section h3 {
            color: #4CAF50;
            margin-bottom: 15px;
        }

        .footer-section ul {
            list-style: none;
        }

        .footer-section ul li {
            margin-bottom: 8px;
        }

        .footer-section ul li a {
            color: rgba(255,255,255,0.7);
            text-decoration: none;
            transition: color 0.3s;
        }

        .footer-section ul li a:hover {
            color: #4CAF50;
        }

        .email-subscribe {
            display: flex;
            gap: 10px;
            margin-top: 15px;
        }

        .email-subscribe input {
            flex: 1;
            padding: 10px;
            border: 1px solid rgba(255,255,255,0.3);
            border-radius: 5px;
            background: rgba(255,255,255,0.1);
            color: #fff;
        }

        .social-icons {
            display: flex;
            gap: 10px;
            margin-top: 15px;
        }

        .social-icons a {
            width: 35px;
            height: 35px;
            background: rgba(255,255,255,0.2);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            text-decoration: none;
            transition: all 0.3s;
        }

        .social-icons a:hover {
            background: #4CAF50;
            transform: translateY(-2px);
        }

        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.8);
            z-index: 2000;
            backdrop-filter: blur(5px);
        }

        .modal-content {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background: linear-gradient(135deg, #122536 0%, #764ba2 100%);
            padding: 30px;
            border-radius: 15px;
            max-width: 500px;
            width: 90%;
            text-align: center;
        }

        .close-btn {
            position: absolute;
            top: 10px;
            right: 15px;
            background: none;
            border: none;
            color: #fff;
            font-size: 24px;
            cursor: pointer;
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
            box-shadow: 0 4px 12px rgba(0,0,0,0.2);
            opacity: 0;
            transform: translateX(100%);
            transition: opacity 0.3s ease, transform 0.3s ease;
        }

        .toast.show {
            opacity: 1;
            transform: translateX(0);
        }

        .toast.success {
            background: #4CAF50;
            border: 1px solid #1f8a38;
        }

        .toast.error {
            background: #f44336;
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

        @media (max-width: 768px) {
            .sidebar {
                transform: translateX(-100%);
                transition: transform 0.3s;
            }

            .main-content {
                margin-left: 0;
            }

            .stats-grid {
                grid-template-columns: 1fr;
            }

            .navbar {
                flex-direction: column;
                gap: 15px;
            }

            .navbar .nav-links {
                flex-wrap: wrap;
                justify-content: center;
            }
        }

        .animate-bounce {
            animation: bounce 2s infinite;
        }

        .pagination {
            display: flex;
            justify-content: center;
            margin-top: 20px;
        }

        .pagination a, .pagination span {
            margin: 0 5px;
            padding: 8px 16px;
            text-decoration: none;
            border-radius: 5px;
            transition: all 0.3s;
        }

        .pagination a {
            background: rgba(255,255,255,0.1);
            color: white;
        }

        .pagination a:hover {
            background: rgba(76, 175, 80, 0.2);
            color: #4CAF50;
        }

        .pagination .btn-primary {
            background: #4CAF50;
            color: white;
            cursor: default;
        }

        .event-actions {
            display: flex;
            gap: 10px;
        }

        .btn-edit {
            background: rgba(255, 193, 7, 0.2);
            color: #ffc107;
            border: 1px solid #ffc107;
            padding: 5px 10px;
            border-radius: 5px;
            font-size: 0.8rem;
            cursor: pointer;
            transition: all 0.3s;
        }

        .btn-edit:hover {
            background: rgba(255, 193, 7, 0.4);
            transform: translateY(-2px);
        }

        .btn-delete {
            background: rgba(244, 67, 54, 0.2);
            color: #f44336;
            border: 1px solid #f44336;
            padding: 5px 10px;
            border-radius: 5px;
            font-size: 0.8rem;
            cursor: pointer;
            transition: all 0.3s;
        }

        .btn-delete:hover {
            background: rgba(244, 67, 54, 0.4);
            transform: translateY(-2px);
        }

        @keyframes bounce {
            0%, 20%, 50%, 80%, 100% {
                transform: translateY(0);
            }
            40% {
                transform: translateY(-10px);
            }
            60% {
                transform: translateY(-5px);
            }
        }

        .pulse {
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0% {
                box-shadow: 0 0 0 0 rgba(76, 175, 80, 0.7);
            }
            70% {
                box-shadow: 0 0 0 10px rgba(76, 175, 80, 0);
            }
            100% {
                box-shadow: 0 0 0 0 rgba(76, 175, 80, 0);
            }
        }
    </style>
</head>
<body>
    <!-- Sidebar -->
    <div class="sidebar">
        <div class="brand">🎟️ MasterTicket</div>
        <ul class="menu">
            <li><a href="#" class="active">📅 My Events</a></li>
            <li><a href="#">📊 Manage Reports</a></li>
            <li><a href="#">📋 Rules</a></li>
            <li><a href="#">⚙️ Settings</a></li>
            <li><a href="#">📈 Analytics</a></li>
            <li><a href="${pageContext.request.contextPath}/support-owner">🎧 Support</a></li>
        </ul>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <!-- Toast Container -->
        <div id="toast-container" class="toast-container"></div>

        <!-- Navigation -->
        <nav class="navbar">
            <div class="nav-links">
                <a href="#">Home</a>
                <a href="#">Shows</a>
                <a href="#">Offers & Discount</a>
                <a href="#" class="active">Dashboard</a>
                <button class="chat-btn" onclick="window.location.href = '${pageContext.request.contextPath}/chat'">
                    💬 Go to Chat
                </button>
            </div>
            <div class="user-info">
                <span>Welcome, Event Manager</span>
                <a href="${pageContext.request.contextPath}/eventOwner/updateEventOwnerProfile.jsp" class="btn btn-primary" style="margin-right: 10px;">Edit Profile</a>
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-logout">Logout</a>
            </div>
        </nav>

        <!-- My Created Events Section -->
        <div class="content-section">
            <div class="section-header">
                <h2>📌 My Created Events</h2>
                <button class="btn btn-primary" onclick="openModal()">+ Create New Event</button>
            </div>

            <div class="event-list">
                <c:choose>
                    <c:when test="${not empty myEvents}">
                        <c:forEach var="event" items="${myEvents}" begin="${(myEventsCurrentPage-1)*myEventsPageSize}" end="${myEventsCurrentPage*myEventsPageSize-1}">
                            <div class="event-item">
                                <div class="event-info">
                                    <h3><c:out value="${event.name}" /></h3>
                                    <p>
                                        <c:if test="${not empty event.physicalLocation}">
                                            📍 <c:out value="${event.physicalLocation}" /> • 
                                        </c:if>
                                        📅 <fmt:formatDate value="${event.startTime}" pattern="dd/MM/yyyy" /> - 
                                        <fmt:formatDate value="${event.endTime}" pattern="dd/MM/yyyy" />
                                        <c:if test="${not empty event.totalTicketCount}">
                                            • 🎫 <c:out value="${event.totalTicketCount}" /> tickets
                                        </c:if>
                                    </p>
                                </div>
                                <div style="display: flex; align-items: center; gap: 10px;">
                                    <div class="event-status 
                                         <c:choose>
                                             <c:when test="${event.status eq 'active'}">status-active</c:when>
                                             <c:when test="${event.status eq 'pending'}">status-pending</c:when>
                                             <c:otherwise>status-ended</c:otherwise>
                                         </c:choose>">
                                        <c:choose>
                                            <c:when test="${event.status eq 'active'}">Active</c:when>
                                            <c:when test="${event.status eq 'pending'}">Pending</c:when>
                                            <c:otherwise>Ended</c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="event-actions">
                                        <button class="btn-edit" onclick="editEvent(${event.eventID})">Edit</button>
                                        <button class="btn-delete" onclick="deleteEvent(${event.eventID})">Delete</button>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="event-item" style="text-align: center;">
                            <p style="color: #9ca3af;">You haven't created any events yet.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Pagination for My Events -->
            <div class="pagination">
                <c:if test="${myEventsCurrentPage > 1}">
                    <a href="?myEventsPage=${myEventsCurrentPage-1}" class="btn">&laquo; Previous</a>
                </c:if>

                <c:forEach begin="1" end="${myEventsTotalPages}" var="i">
                    <c:choose>
                        <c:when test="${i == myEventsCurrentPage}">
                            <span class="btn btn-primary">${i}</span>
                        </c:when>
                        <c:otherwise>
                            <a href="?myEventsPage=${i}" class="btn">${i}</a>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>

                <c:if test="${myEventsCurrentPage < myEventsTotalPages}">
                    <a href="?myEventsPage=${myEventsCurrentPage+1}" class="btn">Next &raquo;</a>
                </c:if>
            </div>
        </div>

        <!-- Statistics Grid -->
        <div class="stats-grid">
            <div class="stat-card pulse">
                <div class="icon">🎫</div>
                <div class="number">${totalEvents}</div>
                <div class="label">Total Events</div>
            </div>
            <div class="stat-card">
                <div class="icon">👥</div>
                <div class="number">${totalTicketsSold}</div>
                <div class="label">Total Attendees</div>
            </div>
            <div class="stat-card">
                <div class="icon">💰</div>
                <div class="number">$${totalRevenue}</div>
                <div class="label">Total Revenue</div>
            </div>
        </div>

        <!-- Quick Actions -->
        <div class="content-section">
            <div class="section-header">
                <h2>⚡ Quick Actions</h2>
            </div>

            <div class="quick-actions">
                <a href="#" class="action-btn" onclick="openModal()">
                    <span>📝</span>
                    Create Event
                </a>
                <a href="#" class="action-btn">
                    <span>📊</span>
                    View Reports
                </a>
                <a href="#" class="action-btn">
                    <span>🎫</span>
                    Manage Tickets
                </a>
                <a href="#" class="action-btn">
                    <span>💬</span>
                    Customer Support
                </a>
                <a href="#" class="action-btn">
                    <span>📈</span>
                    Analytics
                </a>
                <a href="#" class="action-btn">
                    <span>⚙️</span>
                    Settings
                </a>
            </div>
        </div>
    </div>

    <!-- Modal -->
    <div id="eventModal" class="modal">
        <div class="modal-content">
            <button class="close-btn" onclick="closeModal()">&times;</button>
            <h2 style="color: #4CAF50; margin-bottom: 20px;">🎭 Create New Event</h2>
            <p style="margin-bottom: 20px;">Ready to create an amazing event experience?</p>
            <div style="display: flex; gap: 15px; justify-content: center;">
                <button class="btn btn-primary" onclick="window.location.href = 'eventOwner/NotesWhenPostEvent.jsp'">Start Creating</button>
                <button class="btn" style="background: rgba(255,255,255,0.2); color: white;" onclick="closeModal()">Cancel</button>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="footer">
        <div class="footer-content">
            <div class="footer-section">
                <h3>Customer Services</h3>
                <ul>
                    <li><a href="#">FAQS</a></li>
                    <li><a href="#">Contact us</a></li>
                    <li><a href="#">Privacy Policy</a></li>
                    <li><a href="#">Terms of Service</a></li>
                </ul>
            </div>

            <div class="footer-section">
                <h3>SiteMap</h3>
                <ul>
                    <li><a href="#">Create Account</a></li>
                    <li><a href="#">News</a></li>
                    <li><a href="#">Top-Rated Events</a></li>
                </ul>
            </div>

            <div class="footer-section">
                <h3>Subscribe for event updates</h3>
                <p>Get the latest news about upcoming events</p>
                <div class="email-subscribe">
                    <input type="email" placeholder="Your email...">
                    <button class="btn btn-primary">Subscribe</button>
                </div>

                <h4 style="margin-top: 20px;">Follow us:</h4>
                <div class="social-icons">
                    <a href="#" title="Facebook">📘</a>
                    <a href="#" title="Instagram">📷</a>
                    <a href="#" title="Twitter">🐦</a>
                    <a href="#" title="YouTube">📺</a>
                </div>
            </div>

            <div class="footer-section">
                <h3>Contact Information</h3>
                <p>📧 Email: <a href="mailto:support@masterticket.vn">support@masterticket.vn</a></p>
                <p>📱 Phone: +84 123 456 789</p>
                <p>🏢 Address: FPTU, Da Nang</p>
            </div>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>
        function showToast(message, type) {
            const toastContainer = document.getElementById('toast-container');
            const toast = document.createElement('div');
            toast.className = `toast ${type}`;
            
            // Add icon based on type
            const icon = type === 'success' ? '✅' : '❌';
            toast.innerHTML = `
                <span class="toast-icon">${icon}</span>
                <span class="toast-message">${message}</span>
                <button class="toast-close">&times;</button>
            `;
            
            toastContainer.appendChild(toast);
            
            // Show toast with animation
            setTimeout(() => {
                toast.classList.add('show');
            }, 100);
            
            // Auto-remove toast after 4 seconds
            setTimeout(() => {
                toast.style.animation = 'toast-slide-out 0.3s ease forwards';
                setTimeout(() => toast.remove(), 300);
            }, 4000);
            
            // Close button functionality
            toast.querySelector('.toast-close').addEventListener('click', () => {
                toast.style.animation = 'toast-slide-out 0.3s ease forwards';
                setTimeout(() => toast.remove(), 300);
            });
        }

        function openModal() {
            document.getElementById('eventModal').style.display = 'block';
        }

        function closeModal() {
            document.getElementById('eventModal').style.display = 'none';
        }

        // Close modal when clicking outside
        window.onclick = function (event) {
            const modal = document.getElementById('eventModal');
            if (event.target == modal) {
                modal.style.display = 'none';
            }
        }

        // Add some interactive effects
        document.querySelectorAll('.stat-card').forEach(card => {
            card.addEventListener('mouseenter', function () {
                this.style.transform = 'translateY(-10px) scale(1.02)';
            });

            card.addEventListener('mouseleave', function () {
                this.style.transform = 'translateY(-5px) scale(1)';
            });
        });

        function deleteEvent(eventId) {
            console.log("event", eventId);
            Swal.fire({
                title: 'Are you sure?',
                text: "You won't be able to revert this!",
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#4CAF50',
                cancelButtonColor: '#f44336',
                confirmButtonText: 'Yes, delete it!',
                cancelButtonText: 'No, cancel!'
            }).then((result) => {
                if (result.isConfirmed) {
                    // Send request to delete the event
                    fetch('${pageContext.request.contextPath}/organizer-servlet?action=delete&eventID=' + eventId, {
                        method: 'POST'
                    })
                        .then(response => response.json())
                        .then(data => {
                            if (data.success) {
                                Swal.fire(
                                    'Deleted!',
                                    'Your event has been deleted.',
                                    'success'
                                ).then(() => {
                                    // Reload the page to see changes
                                    window.location.reload();
                                });
                            } else {
                                Swal.fire(
                                    'Error!',
                                    data.message,
                                    'error'
                                );
                            }
                        })
                        .catch(error => {
                            Swal.fire(
                                'Error!',
                                'An error occurred while deleting the event.',
                                'error'
                            );
                            console.error('Error:', error);
                        });
                }
            });
        }

        function editEvent(eventId) {
            Swal.fire({
                title: 'Xác nhận',
                text: 'Bạn có muốn chỉnh sửa sự kiện này?',
                icon: 'question',
                showCancelButton: true,
                confirmButtonText: 'Có',
                cancelButtonText: 'Không'
            }).then((result) => {
                if (result.isConfirmed) {
                    window.location.href = '${pageContext.request.contextPath}/organizer-servlet?action=edit&eventID=' + eventId;
                }
            });
        }

        // Animate numbers on load
        window.addEventListener('load', function () {
            const numbers = document.querySelectorAll('.number');
            numbers.forEach(num => {
                const finalValue = num.textContent;
                let currentValue = 0;
                const increment = parseInt(finalValue.replace(/[^0-9]/g, '')) / 50;

                const timer = setInterval(() => {
                    currentValue += increment;
                    if (currentValue >= parseInt(finalValue.replace(/[^0-9]/g, ''))) {
                        num.textContent = finalValue;
                        clearInterval(timer);
                    } else {
                        if (finalValue.includes('$')) {
                            num.textContent = '$' + Math.floor(currentValue).toLocaleString();
                        } else if (finalValue.includes('.')) {
                            num.textContent = (currentValue / 1000).toFixed(1);
                        } else {
                            num.textContent = Math.floor(currentValue).toLocaleString();
                        }
                    }
                }, 50);
            });

            // Show toast if successMessage is present
            <c:if test="${not empty successMessage}">
                showToast('${successMessage}', 'success');
            </c:if>
        });
    </script>
</body>
</html>