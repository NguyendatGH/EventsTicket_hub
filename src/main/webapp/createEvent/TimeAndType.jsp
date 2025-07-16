<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Event - Step 2: Time & Type - MasterTicket</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        body { background: linear-gradient(135deg, #1a1a2e 0%, #16213e 50%, #0f0f23 100%); color: #ffffff; min-height: 100vh; }
        .progress-bar { background: rgba(26, 26, 46, 0.9); padding: 1rem 2rem; border-bottom: 1px solid rgba(255, 255, 255, 0.1); }
        .progress-content { max-width: 1200px; margin: 0 auto; display: flex; align-items: center; gap: 2rem; }
        .progress-step { display: flex; align-items: center; gap: 0.5rem; font-size: 0.9rem; }
        .step-number { width: 30px; height: 30px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: bold; font-size: 0.8rem; }
        .step-number.completed { background: #10b981; color: white; }
        .step-number.active { background: #8b5fbf; color: white; }
        .step-number.inactive { background: rgba(255, 255, 255, 0.1); color: rgba(255, 255, 255, 0.5); }
        .step-connector { width: 40px; height: 2px; background: rgba(255, 255, 255, 0.1); }
        .step-connector.completed { background: #10b981; }
        .container { max-width: 1200px; margin: 0 auto; padding: 2rem; display: grid; grid-template-columns: 250px 1fr; gap: 2rem; }
        .sidebar { background: rgba(26, 26, 46, 0.6); border-radius: 20px; padding: 2rem; height: fit-content; border: 1px solid rgba(255, 255, 255, 0.1); }
        .sidebar h3 { color: #8b5fbf; margin-bottom: 1.5rem; font-size: 1.1rem; }
        .sidebar-menu { list-style: none; }
        .sidebar-menu a { color: rgba(255, 255, 255, 0.7); text-decoration: none; display: flex; align-items: center; gap: 0.5rem; padding: 0.5rem; border-radius: 10px; transition: all 0.3s ease; }
        .sidebar-menu a:hover { background: rgba(139, 95, 191, 0.1); color: #8b5fbf; }
        .sidebar-menu a.active { background: rgba(139, 95, 191, 0.2); color: #8b5fbf; }
        .main-content { background: rgba(26, 26, 46, 0.6); border-radius: 20px; padding: 2rem; border: 1px solid rgba(255, 255, 255, 0.1); }
        .page-title { font-size: 1.8rem; margin-bottom: 0.5rem; color: #ffffff; }
        .page-subtitle { color: rgba(255, 255, 255, 0.6); margin-bottom: 2rem; }
        .form-section { margin-bottom: 2rem; }
        .section-title { font-size: 1.2rem; margin-bottom: 1rem; color: #8b5fbf; }
        .form-group { margin-bottom: 1.5rem; }
        .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; }
        .form-label { display: block; margin-bottom: 0.5rem; color: rgba(255, 255, 255, 0.8); font-size: 0.9rem; }
        .form-input { width: 100%; padding: 0.8rem; background: rgba(255, 255, 255, 0.1); border: 1px solid rgba(255, 255, 255, 0.2); border-radius: 10px; color: #ffffff; font-size: 0.9rem; }
        .form-input:focus { outline: none; border-color: #8b5fbf; box-shadow: 0 0 0 3px rgba(139, 95, 191, 0.1); }
        .time-zone-selector { display: flex; align-items: center; gap: 0.5rem; margin-top: 0.5rem; }
        .timezone-display { background: rgba(139, 95, 191, 0.2); padding: 0.3rem 0.8rem; border-radius: 20px; font-size: 0.8rem; color: #8b5fbf; }
        .action-buttons { display: flex; justify-content: space-between; align-items: center; margin-top: 3rem; padding-top: 2rem; border-top: 1px solid rgba(255, 255, 255, 0.1); }
        .btn-secondary { background: rgba(255, 255, 255, 0.1); color: #ffffff; padding: 0.8rem 2rem; border: none; border-radius: 25px; cursor: pointer; font-size: 0.9rem; text-decoration: none; }
        .btn-secondary:hover { background: rgba(255, 255, 255, 0.2); }
        .btn-primary { background: linear-gradient(45deg, #8b5fbf, #a855f7); color: white; padding: 0.8rem 2rem; border: none; border-radius: 25px; cursor: pointer; font-size: 0.9rem; }
        .btn-primary:hover { transform: translateY(-2px); box-shadow: 0 10px 20px rgba(139, 95, 191, 0.3); }
        .alert { padding: 1rem; margin-bottom: 1.5rem; border-radius: 10px; background-color: rgba(220, 53, 69, 0.2); color: #ffffff; border-left: 4px solid #dc3545; }
    </style>
</head>
<body>
    <div class="header">
        <div class="header-content">
            <div class="logo">MasterTicket</div>
            <div class="nav-links">
                <a href="${pageContext.request.contextPath}/">Home</a>
                <a href="${pageContext.request.contextPath}/shows">Shows</a>
                <a href="${pageContext.request.contextPath}/offers">Offers & Discount</a>
                <a href="${pageContext.request.contextPath}/events/create">Create Event</a>
            </div>
            <c:choose>
                <c:when test="${not empty sessionScope.user}">
                    <a href="${pageContext.request.contextPath}/logout" class="btn-primary">Logout</a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/login" class="btn-primary">Login</a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
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
    <div class="container">
        <div class="sidebar">
            <h3>🎟️ MasterTicket</h3>
            <ul class="sidebar-menu">
                <li><a href="${pageContext.request.contextPath}/events" class="active">📅 My event</a></li>
                <li><a href="${pageContext.request.contextPath}/reports">📊 Manage Report</a></li>
                <li><a href="${pageContext.request.contextPath}/rules">⚙️ Rules</a></li>
            </ul>
        </div>
        <div class="main-content">
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
                            <input type="datetime-local" class="form-input" name="startTime" value="${event.startTime != null ? event.startTime.toInstant().toString().substring(0, 16) : ''}" required>
                            <div class="time-zone-selector">
                                <span class="timezone-display">GMT+7 (Vietnam)</span>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="form-label">End Date & Time *</label>
                            <input type="datetime-local" class="form-input" name="endTime" value="${event.endTime != null ? event.endTime.toInstant().toString().substring(0, 16) : ''}" required>
                            <div class="time-zone-selector">
                                <span class="timezone-display">GMT+7 (Vietnam)</span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="action-buttons">
                    <a href="${pageContext.request.contextPath}/organizer-servlet?action=step1" class="btn-secondary">← Back</a>
                    <button type="submit" class="btn-primary">Continue →</button>
                </div>
            </form>
        </div>
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