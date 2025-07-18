
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%> <%@ taglib uri="http://java.sun.com/jsp/jstl/core"
         prefix="c" %> <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Ticket Transactions - MasterTicket</title>
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

            .btn-secondary {
                background: #6c757d;
                color: white;
            }

            .btn-secondary:hover {
                background: #5a6268;
                transform: translateY(-2px);
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

            .filters {
                display: flex;
                gap: 15px;
                margin-bottom: 20px;
                flex-wrap: wrap;
            }

            .filter-group {
                display: flex;
                flex-direction: column;
                min-width: 200px;
            }

            .filter-group label {
                margin-bottom: 8px;
                font-weight: 500;
                color: #4CAF50;
            }

            .filter-control {
                padding: 10px 15px;
                background: rgba(0,0,0,0.2);
                border: 1px solid rgba(255,255,255,0.1);
                border-radius: 5px;
                color: #fff;
                font-size: 14px;
            }

            .transaction-table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 20px;
            }

            .transaction-table th {
                text-align: left;
                padding: 15px;
                background: rgba(76, 175, 80, 0.2);
                color: #4CAF50;
                border-bottom: 2px solid rgba(76, 175, 80, 0.5);
            }

            .transaction-table td {
                padding: 15px;
                border-bottom: 1px solid rgba(255,255,255,0.1);
                vertical-align: middle;
            }

            .transaction-table tr:hover {
                background: rgba(255,255,255,0.05);
            }

            .transaction-status {
                padding: 5px 12px;
                border-radius: 15px;
                font-size: 0.8rem;
                font-weight: bold;
                display: inline-block;
            }

            .status-completed {
                background: rgba(76, 175, 80, 0.2);
                color: #4CAF50;
                border: 1px solid #4CAF50;
            }

            .status-pending {
                background: rgba(255, 193, 7, 0.2);
                color: #ffc107;
                border: 1px solid #ffc107;
            }

            .status-refunded {
                background: rgba(244, 67, 54, 0.2);
                color: #f44336;
                border: 1px solid #f44336;
            }

            .action-btn {
                background: rgba(255,255,255,0.1);
                border: 1px solid rgba(255,255,255,0.2);
                color: #fff;
                padding: 8px 12px;
                border-radius: 5px;
                text-decoration: none;
                transition: all 0.3s;
                font-size: 0.9rem;
                margin-right: 5px;
            }

            .action-btn:hover {
                background: rgba(76, 175, 80, 0.2);
                border-color: #4CAF50;
                color: #4CAF50;
            }

            .pagination {
                display: flex;
                justify-content: center;
                gap: 5px;
                margin-top: 20px;
            }

            .pagination a {
                padding: 8px 12px;
                background: rgba(255,255,255,0.1);
                color: #fff;
                text-decoration: none;
                border-radius: 5px;
                transition: all 0.3s;
            }

            .pagination a:hover,
            .pagination a.active {
                background: #4CAF50;
            }

            .summary-cards {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                gap: 20px;
                margin-bottom: 25px;
            }

            .summary-card {
                background: rgba(255,255,255,0.1);
                border-radius: 15px;
                padding: 20px;
            }

            .summary-card h3 {
                font-size: 14px;
                color: #4CAF50;
                margin-bottom: 10px;
            }

            .summary-card p {
                font-size: 24px;
                font-weight: 600;
            }

            @media (max-width: 768px) {
                .sidebar {
                    transform: translateX(-100%);
                    transition: transform 0.3s;
                }

                .main-content {
                    margin-left: 0;
                }

                .filters {
                    flex-direction: column;
                }

                .transaction-table {
                    display: block;
                    overflow-x: auto;
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
        </style>
    </head>
    <body>
        <!-- Sidebar -->
        <div class="sidebar">
            <div class="brand">🎟️ MasterTicket</div>
            <ul class="menu">
                <li><a href="#">📅 My Events</a></li>
                <li><a href="dashboard.jsp">📊 Dashboard</a></li>
                <li><a href="#" class="active">💰 Transactions</a></li>
                <li><a href="#">📋 Reports</a></li>
                <li><a href="#">⚙️ Settings</a></li>
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
                    <a href="dashboard.jsp">Dashboard</a>
                    <a href="#" class="active">Transactions</a>
                </div>
                <div class="user-info">
                    <span>Welcome, Event Manager</span>
                    <a href="${pageContext.request.contextPath}/logout" class="btn btn-logout">Logout</a>
                </div>
            </nav>

            <!-- Page Header -->
            <div class="dashboard-header">
                <h1>💰 Ticket Transactions</h1>
                <p>View and manage all ticket purchases for your events</p>
            </div>

            <!-- Summary Cards -->
            <div class="summary-cards">
                <div class="summary-card">
                    <h3>TOTAL SALES</h3>
                    <p><fmt:formatNumber value="${totalSales}" type="currency"/></p>
                </div>
                <div class="summary-card">
                    <h3>TOTAL TICKETS SOLD</h3>
                    <p>${totalTickets}</p>
                </div>
                <div class="summary-card">
                    <h3>AVERAGE ORDER VALUE</h3>
                    <p>
                        <c:choose>
                            <c:when test="${totalTickets > 0}">
                                <fmt:formatNumber value="${totalSales.doubleValue() / totalTickets}" type="currency"/>
                            </c:when>
                            <c:otherwise>$0.00</c:otherwise>
                        </c:choose>
                    </p>
                </div>
                <div class="summary-card">
                    <h3>REFUND REQUESTS</h3>
                    <p>${refundRequests}</p>
                </div>
            </div>

            <!-- Transaction Table -->
            <tbody>
                <c:choose>
                    <c:when test="${not empty transactions}">
                        <c:forEach var="transaction" items="${transactions}">
                            <tr>
                                <td>#TRX-${transaction.transactionId}</td>
                                <td>${transaction.eventName}</td>
                                <td>${transaction.eventOwner}<br><small>${transaction.ownerEmail}</small></td>
                                <td><fmt:formatDate value="${transaction.transactionDate}" pattern="MMMM dd, yyyy" /></td>
                                <td><fmt:formatNumber value="${transaction.amount}" type="currency"/></td>
                                <td>${transaction.ticketCount}</td>
                                <td>
                                    <span class="transaction-status 
                                          <c:choose>
                                              <c:when test="${transaction.status eq 'completed'}">status-completed</c:when>
                                              <c:when test="${transaction.status eq 'pending'}">status-pending</c:when>
                                              <c:otherwise>status-refunded</c:otherwise>
                                          </c:choose>">
                                        ${transaction.status}
                                    </span>
                                </td>
                                <td>
                                    <a href="#" class="action-btn">View</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="8" style="text-align: center;">No transactions found.</td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </tbody>

            <!-- Pagination -->
            <div class="pagination">
                <c:if test="${currentPage > 1}">
                    <a href="?action=transactions&page=${currentPage-1}" class="btn">&laquo;</a>
                </c:if>

                <c:forEach begin="1" end="${totalPages}" var="i">
                    <c:choose>
                        <c:when test="${i == currentPage}">
                            <span class="btn btn-primary">${i}</span>
                        </c:when>
                        <c:otherwise>
                            <a href="?action=transactions&page=${i}" class="btn">${i}</a>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>

                <c:if test="${currentPage < totalPages}">
                    <a href="?action=transactions&page=${currentPage+1}" class="btn">&raquo;</a>
                </c:if>
            </div>

            <script>
                // Add interactive effects to table rows
                document.querySelectorAll('.transaction-table tbody tr').forEach(row => {
                    row.addEventListener('mouseenter', function () {
                        this.style.transform = 'translateX(5px)';
                        this.style.transition = 'transform 0.3s';
                    });

                    row.addEventListener('mouseleave', function () {
                        this.style.transform = 'translateX(0)';
                    });
                });

                // Filter functionality
                document.querySelectorAll('.filter-control').forEach(control => {
                    control.addEventListener('change', filterTransactions);
                });

                document.getElementById('searchFilter').addEventListener('input', filterTransactions);

                function filterTransactions() {
                    const eventFilter = document.getElementById('eventFilter').value;
                    const statusFilter = document.getElementById('statusFilter').value;
                    const searchTerm = document.getElementById('searchFilter').value.toLowerCase();

                    const rows = document.querySelectorAll('.transaction-table tbody tr');

                    rows.forEach(row => {
                        const event = row.cells[1].textContent;
                        const status = row.querySelector('.transaction-status').textContent.toLowerCase();
                        const customer = row.cells[2].textContent.toLowerCase();

                        const eventMatch = !eventFilter || event.includes(document.getElementById('eventFilter').options[document.getElementById('eventFilter').selectedIndex].text);
                        const statusMatch = !statusFilter || status.includes(statusFilter);
                        const searchMatch = !searchTerm || customer.includes(searchTerm);

                        if (eventMatch && statusMatch && searchMatch) {
                            row.style.display = '';
                        } else {
                            row.style.display = 'none';
                        }
                    });
                }
            </script>
    </body>
</html>