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
        
        .progress-bar {
            background: rgba(26, 26, 46, 0.9);
            padding: 1.5rem 2rem;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }
        
        .progress-content {
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 2rem;
        }
        
        .progress-step {
            display: flex;
            align-items: center;
            gap: 0.8rem;
            font-size: 1rem;
            color: rgba(255,255,255,0.7);
        }
        
        .step-number {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            font-size: 1rem;
            transition: all 0.3s;
        }
        
        .step-number.completed {
            background: #4CAF50;
            color: white;
        }
        
        .step-number.active {
            background: #8b5fbf;
            color: white;
            box-shadow: 0 0 15px rgba(139, 95, 191, 0.5);
        }
        
        .step-number.inactive {
            background: rgba(255,255,255,0.1);
            color: rgba(255,255,255,0.5);
        }
        
        .step-connector {
            width: 60px;
            height: 2px;
            background: rgba(255,255,255,0.1);
        }
        
        .step-connector.completed {
            background: #4CAF50;
        }
        
        /* Main Content Styles */
        .main-content {
            max-width: 800px;
            margin: 40px auto;
            padding: 30px;
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            border: 1px solid rgba(255, 255, 255, 0.1);
        }
        
        .page-title {
            font-size: 1.8rem;
            margin-bottom: 20px;
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
        
        /* Form Styles */
        .form-section {
            margin-bottom: 25px;
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
            color: #fff;
            font-weight: 500;
        }
        
        .form-input {
            width: 100%;
            padding: 12px;
            border-radius: 8px;
            border: 1px solid rgba(255,255,255,0.2);
            background: rgba(255,255,255,0.1);
            color: #fff;
            font-size: 1rem;
            transition: all 0.3s;
        }
        
        .form-input:focus {
            outline: none;
            border-color: #4CAF50;
            box-shadow: 0 0 10px rgba(76, 175, 80, 0.3);
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
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 1rem;
            font-weight: 500;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }
        
        .btn-secondary {
            background: rgba(255,255,255,0.1);
            color: white;
            border: 1px solid rgba(255,255,255,0.2);
        }
        
        .btn-secondary:hover {
            background: rgba(255,255,255,0.2);
            transform: translateY(-2px);
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
        
        .alert {
            padding: 15px;
            margin-bottom: 25px;
            border-radius: 10px;
            background-color: rgba(244, 67, 54, 0.2);
            color: #fff;
            border-left: 4px solid #f44336;
            backdrop-filter: blur(5px);
        }
        
        .error-message {
            padding: 12px;
            margin-bottom: 20px;
            border-radius: 8px;
            background-color: #ff5252;
            color: #000;
            display: none;
            border-left: 4px solid #ff0000;
            font-weight: bold;
        }
        
        .error-message.show {
            display: block;
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .progress-content {
                flex-wrap: wrap;
                gap: 1rem;
            }
            
            .step-connector {
                display: none;
            }
            
            .form-row {
                grid-template-columns: 1fr;
            }
            
            .main-content {
                margin: 20px;
                padding: 20px;
            }
            
            .action-buttons {
                flex-direction: column;
                gap: 15px;
            }
            
            .btn {
                width: 100%;
            }
        }
    </style>
</head>
<body>
    <!-- Progress Bar -->
    <div class="progress-bar">
        <div class="progress-content">
            <div class="progress-step">
                <div class="step-number completed">1</div>
                <span>Thông tin</span>
            </div>
            <div class="step-connector completed"></div>
            <div class="progress-step">
                <div class="step-number active">2</div>
                <span>Thời gian & Thể loại</span>
            </div>
            <div class="step-connector"></div>
            <div class="progress-step">
                <div class="step-number inactive">3</div>
                <span>Cài đặt</span>
            </div>
            <div class="step-connector"></div>
            <div class="progress-step">
                <div class="step-number inactive">4</div>
                <span>Thông tin vé</span>
            </div>
        </div>
    </div>

    <!-- Main Form Content -->
    <div class="main-content">
        <h1 class="page-title">Thời gian & Thể loại</h1>
        <p class="page-subtitle">Thiết lập thời gian cho sự kiện của bạn!</p>
        
        <div id="toast-container" class="toast-container"></div>
        <c:if test="${not empty errorMessage}">
            <div class="alert">${errorMessage}</div>
        </c:if>
        
        <form action="${pageContext.request.contextPath}/organizer-servlet" method="post" id="eventForm">
            <input type="hidden" name="action" value="step2"/>
            
            <div class="form-section">
                <h3 class="section-title">📅 Lịch trình sự kiện</h3>
                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label">Thời gian bắt đầu *</label>
                        <input type="datetime-local" class="form-input" name="startTime" 
                               value="${event.startTime != null ? event.startTime.toInstant().toString().substring(0, 16) : ''}" required>
                        <div class="time-zone-selector">
                            <span class="timezone-display">GMT+7 (Vietnam)</span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Thời gian kết thúc *</label>
                        <input type="datetime-local" class="form-input" name="endTime" 
                               value="${event.endTime != null ? event.endTime.toInstant().toString().substring(0, 16) : ''}" required>
                        <div class="time-zone-selector">
                            <span class="timezone-display">GMT+7 (Vietnam)</span>
                        </div>
                    </div>
                </div>
                <div id="error-message" class="error-message"></div>
            </div>
            
           <div class="action-buttons">
    <a href="${pageContext.request.contextPath}/organizer-servlet?action=step1" class="btn btn-secondary" style="text-decoration: none;">← Back</a>
    <button type="submit" class="btn btn-primary">Continue →</button>
</div>
        </form>
    </div>

    <script>
        document.getElementById('eventForm').addEventListener('submit', function(e) {
            const startTimeInput = document.querySelector('input[name="startTime"]');
            const endTimeInput = document.querySelector('input[name="endTime"]');
            const errorMessage = document.getElementById('error-message');
            
            // Ensure GMT+7 timezone by appending offset
            const startTime = new Date(startTimeInput.value + ':00+07:00');
            const endTime = new Date(endTimeInput.value + ':00+07:00');
            
            // Use real-time current time
            const currentTime = new Date();

            // Check for valid dates
            if (isNaN(startTime.getTime()) || isNaN(endTime.getTime())) {
                errorMessage.textContent = 'Please enter valid dates and times';
                errorMessage.classList.add('show');
                e.preventDefault();
                return;
            }

            // Check if end time is after start time
            if (startTime >= endTime) {
                errorMessage.textContent = 'End date/time must be after start date/time';
                errorMessage.classList.add('show');
                e.preventDefault();
                return;
            }

            // Check if start time is before current time
            if (startTime < currentTime) {
                errorMessage.textContent = `Start date/time cannot be before current time (${currentTime.toLocaleString('en-US', { timeZone: 'Asia/Ho_Chi_Minh' })} GMT+7)`;
                errorMessage.classList.add('show');
                e.preventDefault();
                return;
            }

            // Clear error message if validation passes
            errorMessage.classList.remove('show');
        });
    </script>
</body>
</html> 