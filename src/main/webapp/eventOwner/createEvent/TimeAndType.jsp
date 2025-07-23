//timeandtype
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Event - Step 2: Time & Type - MasterTicket</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        body {
            background: linear-gradient(135deg, #122536 0%, #764ba2 100%);
            color: #fff;
            min-height: 100vh;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        
        /* Sidebar */
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
        
        .sidebar-menu {
            list-style: none;
        }
        
        .sidebar-menu li {
            margin-bottom: 15px;
        }
        
        .sidebar-menu a {
            color: #d8cbcb;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 10px;
            border-radius: 5px;
            transition: all 0.3s;
        }
        
        .sidebar-menu a:hover,
        .sidebar-menu a.active {
            background: rgba(76, 175, 80, 0.2);
            color: #4CAF50;
            transform: translateX(5px);
        }
        
        .main-content {
            margin-left: 270px;
            padding: 20px;
        }
        
        /* Progress Bar */
        .progress-bar {
            background: rgba(0,0,0,0.3);
            padding: 1rem 2rem;
            border-bottom: 1px solid rgba(255,255,255,0.1);
            backdrop-filter: blur(10px);
            margin-bottom: 30px;
        }
        
        .progress-content {
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            align-items: center;
            gap: 2rem;
        }
        
        .progress-step {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 0.9rem;
            color: rgba(255,255,255,0.8);
        }
        
        .step-number {
            width: 30px;
            height: 30px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            font-size: 0.8rem;
        }
        
        .step-number.completed {
            background: #4CAF50;
            color: white;
        }
        
        .step-number.active {
            background: #8b5fbf;
            color: white;
            box-shadow: 0 0 0 3px rgba(76, 175, 80, 0.3);
        }
        
        .step-number.inactive {
            background: rgba(255,255,255,0.1);
            color: rgba(255,255,255,0.5);
        }
        
        .step-connector {
            width: 40px;
            height: 2px;
            background: rgba(255,255,255,0.1);
        }
        
        .step-connector.completed {
            background: #4CAF50;
        }
        
        /* Form Styles */
        .page-title {
            font-size: 2rem;
            margin-bottom: 10px;
            background: linear-gradient(45deg, #4CAF50, #45a049);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        
        .page-subtitle {
            color: rgba(255,255,255,0.7);
            margin-bottom: 30px;
            font-size: 1rem;
        }
        
        .form-section {
            background: rgba(255,255,255,0.1);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 30px;
            border: 1px solid rgba(255,255,255,0.1);
        }
        
        .section-title {
            font-size: 1.3rem;
            margin-bottom: 20px;
            color: #4CAF50;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-label {
            display: block;
            margin-bottom: 8px;
            color: rgba(255,255,255,0.8);
            font-size: 0.95rem;
        }
        
        .form-input {
            width: 100%;
            padding: 12px 15px;
            background: rgba(255,255,255,0.1);
            border: 1px solid rgba(255,255,255,0.2);
            border-radius: 10px;
            color: #fff;
            font-size: 0.95rem;
            transition: all 0.3s;
        }
        
        .form-input:focus {
            outline: none;
            border-color: #4CAF50;
            box-shadow: 0 0 0 3px rgba(76, 175, 80, 0.2);
            background: rgba(76, 175, 80, 0.1);
        }
        
        .time-zone-selector {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-top: 10px;
        }
        
        .timezone-display {
            background: rgba(76, 175, 80, 0.2);
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 0.8rem;
            color: #4CAF50;
            border: 1px solid rgba(76, 175, 80, 0.5);
        }
        
        .action-buttons {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid rgba(255,255,255,0.1);
        }
        
        .btn {
            padding: 12px 25px;
            border: none;
            border-radius: 25px;
            cursor: pointer;
            font-size: 0.95rem;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        
        .btn-secondary {
            background: rgba(255,255,255,0.1);
            color: #fff;
        }
        
        .btn-secondary:hover {
            background: rgba(255,255,255,0.2);
            transform: translateY(-2px);
        }
        
        .btn-primary {
            background: linear-gradient(45deg, #4CAF50, #45a049);
            color: white;
        }
        
        .btn-primary:hover {
            background: linear-gradient(45deg, #45a049, #4CAF50);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(76, 175, 80, 0.3);
        }
        
        .alert {
            padding: 15px;
            margin-bottom: 25px;
            border-radius: 10px;
            background-color: rgba(244, 67, 54, 0.2);
            color: #fff;
            border-left: 4px solid #f44336;
            backdrop-filter: blur(5px);
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .sidebar {
                transform: translateX(-100%);
                transition: transform 0.3s;
            }
            
            .main-content {
                margin-left: 0;
            }
            
            .form-row {
                grid-template-columns: 1fr;
            }
            
            .progress-content {
                flex-wrap: wrap;
                gap: 1rem;
            }
            
            .step-connector {
                display: none;
            }
        }
    </style>
</head>
<body>
    <!-- Sidebar -->
    <div class="sidebar">
        <div class="brand">🎟️ MasterTicket</div>
        <ul class="sidebar-menu">
            <li><a href="${pageContext.request.contextPath}/events" class="active">📅 My Events</a></li>
            <li><a href="${pageContext.request.contextPath}/reports">📊 Manage Reports</a></li>
            <li><a href="${pageContext.request.contextPath}/rules">📋 Rules</a></li>
            <li><a href="#">⚙️ Settings</a></li>
            <li><a href="#">📈 Analytics</a></li>
        </ul>
    </div>

    <div class="main-content">
        <!-- Progress Bar -->
        <div class="progress-bar">
            <div class="progress-content">
                <div class="progress-step">
                    <div class="step-number completed">1</div>
                    <span>Information</span>
                </div>
                <div class="step-connector completed"></div>
                <div class="progress-step">
                    <div class="step-number active">2</div>
                    <span>Time & Type</span>
                </div>
                <div class="step-connector"></div>
                <div class="progress-step">
                    <div class="step-number inactive">3</div>
                    <span>Settings</span>
                </div>
                <div class="step-connector"></div>
                <div class="progress-step">
                    <div class="step-number inactive">4</div>
                    <span>Payment</span>
                </div>
            </div>
        </div>

        <!-- Main Form Content -->
        <h1 class="page-title">Time & Type</h1>
        <p class="page-subtitle">Set up your event schedule</p>
        
        <c:if test="${not empty errorMessage}">
            <div class="alert">${errorMessage}</div>
        </c:if>
        
        <form action="${pageContext.request.contextPath}/organizer-servlet" method="post" id="eventForm">
            <input type="hidden" name="action" value="step2"/>
            
            <div class="form-section">
                <h3 class="section-title">📅 Event Schedule</h3>
                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label">Start Date & Time *</label>
                        <input type="datetime-local" class="form-input" name="startTime" 
                               value="${event.startTime != null ? event.startTime.toInstant().toString().substring(0, 16) : ''}" required>
                        <div class="time-zone-selector">
                            <span class="timezone-display">GMT+7 (Vietnam)</span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="form-label">End Date & Time *</label>
                        <input type="datetime-local" class="form-input" name="endTime" 
                               value="${event.endTime != null ? event.endTime.toInstant().toString().substring(0, 16) : ''}" required>
                        <div class="time-zone-selector">
                            <span class="timezone-display">GMT+7 (Vietnam)</span>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="action-buttons">
                <a href="${pageContext.request.contextPath}/organizer-servlet?action=step1" class="btn btn-secondary">← Back</a>
                <button type="submit" class="btn btn-primary">Continue →</button>
            </div>
        </form>
    </div>

    <script>
        document.getElementById('eventForm').addEventListener('submit', function(e) {
            const startTime = new Date(document.querySelector('input[name="startTime"]').value);
            const endTime = new Date(document.querySelector('input[name="endTime"]').value);
            if (startTime >= endTime) {
                alert('End date/time must be after start date/time');
                e.preventDefault();
            }
        });
    </script>
</body>
</html>
