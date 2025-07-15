<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
                <p>$12,450.00</p>
            </div>
            <div class="summary-card">
                <h3>TOTAL TICKETS SOLD</h3>
                <p>186</p>
            </div>
            <div class="summary-card">
                <h3>AVERAGE ORDER VALUE</h3>
                <p>$66.94</p>
            </div>
            <div class="summary-card">
                <h3>REFUND REQUESTS</h3>
                <p>3</p>
            </div>
        </div>

        <!-- Transaction List Section -->
        <div class="content-section">
            <div class="section-header">
                <h2>Recent Transactions</h2>
                <div>
                    <button class="btn btn-secondary">Export CSV</button>
                    <button class="btn btn-primary">Generate Report</button>
                </div>
            </div>
            
            <div class="filters">
                <div class="filter-group">
                    <label for="eventFilter">Event</label>
                    <select id="eventFilter" class="filter-control">
                        <option value="">All Events</option>
                        <option value="1">SÂN KHẤU THIÊN ĐĂNG: XÓM VỊT TRỜI</option>
                        <option value="2">Địa Đạo Củ Chi : Trăng Chiến Khu</option>
                        <option value="3">Nhà Hát Kịch IDECAF: 12 Bà Mụ</option>
                    </select>
                </div>
                
                <div class="filter-group">
                    <label for="dateFilter">Date Range</label>
                    <select id="dateFilter" class="filter-control">
                        <option value="7">Last 7 days</option>
                        <option value="30" selected>Last 30 days</option>
                        <option value="90">Last 90 days</option>
                        <option value="custom">Custom Range</option>
                    </select>
                </div>
                
                <div class="filter-group">
                    <label for="statusFilter">Status</label>
                    <select id="statusFilter" class="filter-control">
                        <option value="">All Statuses</option>
                        <option value="completed">Completed</option>
                        <option value="pending">Pending</option>
                        <option value="refunded">Refunded</option>
                    </select>
                </div>
                
                <div class="filter-group">
                    <label for="searchFilter">Search</label>
                    <input type="text" id="searchFilter" class="filter-control" placeholder="Customer name or email">
                </div>
            </div>

            <table class="transaction-table">
                <thead>
                    <tr>
                        <th>Transaction ID</th>
                        <th>Event</th>
                        <th>Event Owner</th>
                        <th>Date</th>
                        <th>Amount</th>
                        <th>Tickets</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>#TRX-78945</td>
                        <td>SÂN KHẤU THIÊN ĐĂNG: XÓM VỊT TRỜI</td>
                        <td>Nguyễn Văn A<br><small>nguyenvana@email.com</small></td>
                        <td>June 15, 2025</td>
                        <td>$45.00</td>
                        <td>2</td>
                        <td><span class="transaction-status status-completed">Completed</span></td>
                        <td>
                            <a href="#" class="action-btn">View</a>
                            
                        </td>
                    </tr>
                    <tr>
                        <td>#TRX-78944</td>
                        <td>Địa Đạo Củ Chi : Trăng Chiến Khu</td>
                        <td>Trần Thị B<br><small>tranthib@email.com</small></td>
                        <td>June 14, 2025</td>
                        <td>$60.00</td>
                        <td>3</td>
                        <td><span class="transaction-status status-completed">Completed</span></td>
                        <td>
                            <a href="#" class="action-btn">View</a>
                            
                        </td>
                    </tr>
                    
                    
                </tbody>
            </table>

            <div class="pagination">
                <a href="#">&laquo;</a>
                <a href="#" class="active">1</a>
                <a href="#">2</a>
                <a href="#">3</a>
                <a href="#">4</a>
                <a href="#">5</a>
                <a href="#">&raquo;</a>
            </div>
        </div>
    </div>

    <script>
        // Add interactive effects to table rows
        document.querySelectorAll('.transaction-table tbody tr').forEach(row => {
            row.addEventListener('mouseenter', function() {
                this.style.transform = 'translateX(5px)';
                this.style.transition = 'transform 0.3s';
            });
            
            row.addEventListener('mouseleave', function() {
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