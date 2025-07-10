<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Event - Time & Type</title>
    <style>
        * {
            margin: 0; padding: 0; box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        body {
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 50%, #0f0f23 100%);
            color: #ffffff; min-height: 100vh; overflow-x: hidden;
        }
        .header {
            background: rgba(26, 26, 46, 0.9); backdrop-filter: blur(20px);
            padding: 1rem 2rem; border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            position: sticky; top: 0; z-index: 100;
        }
        .header-content {
            display: flex; justify-content: space-between; align-items: center;
            max-width: 1200px; margin: 0 auto;
        }
        .logo {
            font-size: 1.5rem; font-weight: bold; color: #8b5fbf;
        }
        .nav-links {
            display: flex; gap: 2rem; font-size: 0.9rem;
        }
        .nav-links a {
            color: #ffffff; text-decoration: none; opacity: 0.7;
            transition: opacity 0.3s ease;
        }
        .nav-links a:hover { opacity: 1; }
        .login-btn {
            background: linear-gradient(45deg, #8b5fbf, #a855f7);
            color: white; padding: 0.5rem 1.5rem; border: none;
            border-radius: 25px; font-size: 0.9rem; cursor: pointer;
            transition: all 0.3s ease; text-decoration: none; display: inline-block;
        }
        .login-btn:hover {
            transform: translateY(-2px); box-shadow: 0 10px 20px rgba(139, 95, 191, 0.3);
        }
        .progress-bar {
            background: rgba(26, 26, 46, 0.9); backdrop-filter: blur(20px);
            padding: 1rem 2rem; border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }
        .progress-content {
            max-width: 1200px; margin: 0 auto;
            display: flex; align-items: center; gap: 2rem;
        }
        .progress-step {
            display: flex; align-items: center; gap: 0.5rem; font-size: 0.9rem;
        }
        .step-number {
            width: 30px; height: 30px; border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            font-weight: bold; font-size: 0.8rem;
        }
        .step-number.completed { background: #10b981; color: white; }
        .step-number.active { background: #8b5fbf; color: white; }
        .step-number.inactive {
            background: rgba(255, 255, 255, 0.1);
            color: rgba(255, 255, 255, 0.5);
        }
        .step-connector {
            width: 40px; height: 2px; background: rgba(255, 255, 255, 0.1);
        }
        .step-connector.completed { background: #10b981; }
        .container {
            max-width: 1200px; margin: 0 auto; padding: 2rem;
            display: grid; grid-template-columns: 250px 1fr; gap: 2rem;
        }
        .sidebar {
            background: rgba(26, 26, 46, 0.6); backdrop-filter: blur(20px);
            border-radius: 20px; padding: 2rem; height: fit-content;
            border: 1px solid rgba(255, 255, 255, 0.1);
        }
        .sidebar h3 {
            color: #8b5fbf; margin-bottom: 1.5rem; font-size: 1.1rem;
        }
        .sidebar-menu { list-style: none; }
        .sidebar-menu li { margin-bottom: 1rem; }
        .sidebar-menu a {
            color: rgba(255, 255, 255, 0.7); text-decoration: none;
            display: flex; align-items: center; gap: 0.5rem;
            padding: 0.5rem; border-radius: 10px; transition: all 0.3s ease;
        }
        .sidebar-menu a:hover {
            background: rgba(139, 95, 191, 0.1); color: #8b5fbf;
        }
        .sidebar-menu a.active {
            background: rgba(139, 95, 191, 0.2); color: #8b5fbf;
        }
        .main-content {
            background: rgba(26, 26, 46, 0.6); backdrop-filter: blur(20px);
            border-radius: 20px; padding: 2rem;
            border: 1px solid rgba(255, 255, 255, 0.1);
        }
        .page-title {
            font-size: 1.8rem; margin-bottom: 0.5rem; color: #ffffff;
        }
        .page-subtitle {
            color: rgba(255, 255, 255, 0.6); margin-bottom: 2rem;
        }
        .form-section { margin-bottom: 2rem; }
        .section-title {
            font-size: 1.2rem; margin-bottom: 1rem; color: #8b5fbf;
        }
        .form-group { margin-bottom: 1.5rem; }
        .form-row {
            display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;
        }
        .form-label {
            display: block; margin-bottom: 0.5rem;
            color: rgba(255, 255, 255, 0.8); font-size: 0.9rem;
        }
        .form-input {
            width: 100%; padding: 0.8rem; background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2); border-radius: 10px;
            color: #ffffff; font-size: 0.9rem; transition: all 0.3s ease;
        }
        .form-input:focus {
            outline: none; border-color: #8b5fbf;
            box-shadow: 0 0 0 3px rgba(139, 95, 191, 0.1);
        }
        .form-input::placeholder { color: rgba(255, 255, 255, 0.4); }
        .datetime-input { position: relative; }
        .datetime-input input[type="datetime-local"] { color-scheme: dark; }
        .event-type-grid {
            display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
        }
        .event-type-card {
            background: rgba(255, 255, 255, 0.05);
            border: 2px solid rgba(255, 255, 255, 0.1); border-radius: 15px;
            padding: 1.5rem; text-align: center; cursor: pointer;
            transition: all 0.3s ease; position: relative;
        }
        .event-type-card:hover {
            border-color: #8b5fbf; background: rgba(139, 95, 191, 0.1);
            transform: translateY(-2px);
        }
        .event-type-card.selected {
            border-color: #8b5fbf; background: rgba(139, 95, 191, 0.2);
        }
        .event-type-icon { font-size: 2rem; margin-bottom: 0.5rem; }
        .event-type-title {
            font-size: 1rem; margin-bottom: 0.3rem; color: #ffffff;
        }
        .event-type-desc {
            font-size: 0.8rem; color: rgba(255, 255, 255, 0.6);
        }
        .ticket-type-section {
            background: rgba(255, 255, 255, 0.05); border-radius: 15px;
            padding: 1.5rem; margin-bottom: 2rem;
        }
        .ticket-type-options {
            display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1rem;
        }
        .ticket-option {
            background: rgba(255, 255, 255, 0.05);
            border: 2px solid rgba(255, 255, 255, 0.1); border-radius: 10px;
            padding: 1rem; cursor: pointer; transition: all 0.3s ease;
        }
        .ticket-option:hover {
            border-color: #8b5fbf; background: rgba(139, 95, 191, 0.1);
        }
        .ticket-option.selected {
            border-color: #8b5fbf; background: rgba(139, 95, 191, 0.2);
        }
        .ticket-option-title {
            font-size: 1rem; margin-bottom: 0.5rem; color: #ffffff;
        }
        .ticket-option-desc {
            font-size: 0.8rem; color: rgba(255, 255, 255, 0.6);
        }
        .time-zone-selector {
            display: flex; align-items: center; gap: 0.5rem; margin-top: 0.5rem;
        }
        .timezone-display {
            background: rgba(139, 95, 191, 0.2); padding: 0.3rem 0.8rem;
            border-radius: 20px; font-size: 0.8rem; color: #8b5fbf;
        }
        .duration-inputs {
            display: flex; gap: 1rem; align-items: center;
        }
        .duration-input { flex: 1; }
        .duration-label {
            color: rgba(255, 255, 255, 0.6); font-size: 0.9rem;
        }
        .action-buttons {
            display: flex; justify-content: space-between; align-items: center;
            margin-top: 3rem; padding-top: 2rem;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
        }
        .btn-secondary {
            background: rgba(255, 255, 255, 0.1); color: #ffffff;
            padding: 0.8rem 2rem; border: none; border-radius: 25px;
            cursor: pointer; transition: all 0.3s ease; font-size: 0.9rem;
            text-decoration: none; display: inline-block;
        }
        .btn-secondary:hover { background: rgba(255, 255, 255, 0.2); }
        .btn-primary {
            background: linear-gradient(45deg, #8b5fbf, #a855f7);
            color: white; padding: 0.8rem 2rem; border: none;
            border-radius: 25px; cursor: pointer; transition: all 0.3s ease;
            font-size: 0.9rem;
        }
        .btn-primary:hover {
            transform: translateY(-2px); box-shadow: 0 10px 20px rgba(139, 95, 191, 0.3);
        }
        .alert {
            padding: 1rem; margin-bottom: 1.5rem; border-radius: 10px;
            background-color: rgba(220, 53, 69, 0.2); color: #ffffff;
            border-left: 4px solid #dc3545;
        }
    </style>
</head>
<body>
    <!-- Header -->
    <div class="header">
        <div class="header-content">
            <div class="logo">MasterTicket</div>
            <div class="nav-links">
                <a href="<%=contextPath%>/">Home</a>
                <a href="<%=contextPath%>/shows">Shows</a>
                <a href="<%=contextPath%>/offers">Offers & Discount</a>
                <a href="<%=contextPath%>/events/create">Create Event</a>
            </div>
            <c:choose>
                <c:when test="${not empty sessionScope.user}">
                    <a href="<%=contextPath%>/logout" class="login-btn">Logout</a>
                </c:when>
                <c:otherwise>
                    <a href="<%=contextPath%>/login" class="login-btn">Login</a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- Progress Bar -->
    <div class="progress-bar">
        <div class="progress-content">
            <div class="progress-step">
                <div class="step-number completed">1</div>
                <span>Information Event</span>
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

    <!-- Main Container -->
    <div class="container">
        <!-- Sidebar -->
        <div class="sidebar">
            <h3>🎟️ MasterTicket</h3>
            <ul class="sidebar-menu">
                <li><a href="<%=contextPath%>/events" class="active">📅 My event</a></li>
                <li><a href="<%=contextPath%>/reports">📊 Manage Report</a></li>
                <li><a href="<%=contextPath%>/rules">⚙️ Rules</a></li>
            </ul>
        </div>

        <!-- Main Content -->
        <div class="main-content">
            <h1 class="page-title">Time & Type</h1>
            <p class="page-subtitle">Set up your event schedule and choose the event type</p>

            <c:if test="${not empty errorMessage}">
                <div class="alert">${errorMessage}</div>
            </c:if>

            <form action="<%=contextPath%>/events/create/time-type" method="post" id="eventForm">
                <!-- Event Schedule Section -->
                <div class="form-section">
                    <h3 class="section-title">📅 Event Schedule</h3>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Start Date & Time</label>
                            <div class="datetime-input">
                                <input type="datetime-local" class="form-input" name="startDateTime" 
                                    value="${not empty param.startDateTime ? param.startDateTime : (not empty event.startDateTime ? event.startDateTime : '2025-07-15T10:00')}" required>
                            </div>
                            <div class="time-zone-selector">
                                <span class="timezone-display">GMT+7 (Vietnam)</span>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label">End Date & Time</label>
                            <div class="datetime-input">
                                <input type="datetime-local" class="form-input" name="endDateTime" 
                                    value="${not empty param.endDateTime ? param.endDateTime : (not empty event.endDateTime ? event.endDateTime : '2025-07-15T18:00')}" required>
                            </div>
                            <div class="time-zone-selector">
                                <span class="timezone-display">GMT+7 (Vietnam)</span>
                            </div>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Event Duration</label>
                        <div class="duration-inputs">
                            <div class="duration-input">
                                <input type="number" class="form-input" name="durationHours" placeholder="8" 
                                    value="${not empty param.durationHours ? param.durationHours : (not empty event.durationHours ? event.durationHours : '8')}" min="0" required>
                                <div class="duration-label">Hours</div>
                            </div>
                            <div class="duration-input">
                                <input type="number" class="form-input" name="durationMinutes" placeholder="0" 
                                    value="${not empty param.durationMinutes ? param.durationMinutes : (not empty event.durationMinutes ? event.durationMinutes : '0')}" min="0" max="59" required>
                                <div class="duration-label">Minutes</div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Event Type Section -->
                <div class="form-section">
                    <h3 class="section-title">🎭 Event Type</h3>
                    
                    <div class="event-type-grid">
                        <c:forEach var="type" items="${eventTypes}">
                            <div class="event-type-card ${(not empty param.eventType && param.eventType eq type.value) || (empty param.eventType && event.eventType eq type.value) ? 'selected' : ''}" 
                                data-value="${type.value}">
                                <div class="event-type-icon">${type.icon}</div>
                                <div class="event-type-title">${type.name}</div>
                                <div class="event-type-desc">${type.description}</div>
                                <input type="radio" name="eventType" value="${type.value}" 
                                    ${(not empty param.eventType && param.eventType eq type.value) || (empty param.eventType && event.eventType eq type.value) ? 'checked' : ''} style="display: none;">
                            </div>
                        </c:forEach>
                    </div>
                </div>

                <!-- Ticket Type Section -->
                <div class="form-section">
                    <h3 class="section-title">🎫 Ticket Type</h3>
                    
                    <div class="ticket-type-section">
                        <div class="ticket-type-options">
                            <c:forEach var="ticketType" items="${ticketTypes}">
                                <div class="ticket-option ${(not empty param.ticketType && param.ticketType eq ticketType.value) || (empty param.ticketType && event.ticketType eq ticketType.value) ? 'selected' : ''}" 
                                    data-value="${ticketType.value}">
                                    <div class="ticket-option-title">${ticketType.name}</div>
                                    <div class="ticket-option-desc">${ticketType.description}</div>
                                    <input type="radio" name="ticketType" value="${ticketType.value}" 
                                        ${(not empty param.ticketType && param.ticketType eq ticketType.value) || (empty param.ticketType && event.ticketType eq ticketType.value) ? 'checked' : ''} style="display: none;">
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>

                <!-- Event Frequency Section -->
                <div class="form-section">
                    <h3 class="section-title">🔄 Event Frequency</h3>
                    
                    <div class="form-group">
                        <label class="form-label">Event Type</label>
                        <select class="form-input" name="frequency">
                            <c:forEach var="frequency" items="${frequencies}">
                                <option value="${frequency.value}" 
                                    ${(not empty param.frequency && param.frequency eq frequency.value) || (empty param.frequency && event.frequency eq frequency.value) ? 'selected' : ''}>${frequency.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <!-- Hidden fields -->
                <input type="hidden" name="eventId" value="${event.id}">
                <input type="hidden" name="step" value="2">

                <!-- Action Buttons -->
                <div class="action-buttons">
                    <a href="<%=contextPath%>/events/create/info?eventId=${event.id}" class="btn-secondary">← Back</a>
                    <button type="submit" class="btn-primary">Continue →</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        // Wait for DOM to be fully loaded
        document.addEventListener('DOMContentLoaded', function() {
            // Event type selection
            document.querySelectorAll('.event-type-card').forEach(card => {
                card.addEventListener('click', function() {
                    document.querySelectorAll('.event-type-card').forEach(c => c.classList.remove('selected'));
                    this.classList.add('selected');
                    const radio = this.querySelector('input[type="radio"]');
                    radio.checked = true;
                });
            });

            // Ticket type selection
            document.querySelectorAll('.ticket-option').forEach(option => {
                option.addEventListener('click', function() {
                    document.querySelectorAll('.ticket-option').forEach(o => o.classList.remove('selected'));
                    this.classList.add('selected');
                    const radio = this.querySelector('input[type="radio"]');
                    radio.checked = true;
                });
            });

            // Auto-calculate duration when dates change
            function calculateDuration() {
                const startInput = document.querySelector('input[name="startDateTime"]');
                const endInput = document.querySelector('input[name="endDateTime"]');
                const hoursInput = document.querySelector('input[name="durationHours"]');
                const minutesInput = document.querySelector('input[name="durationMinutes"]');
                
                if (startInput.value && endInput.value) {
                    const start = new Date(startInput.value);
                    const end = new Date(endInput.value);
                    
                    if (start > end) {
                        alert('End time must be after start time');
                        endInput.value = '';
                        return;
                    }
                    
                    const diff = end - start;
                    const hours = Math.floor(diff / (1000 * 60 * 60));
                    const minutes = Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60));
                    
                    hoursInput.value = hours;
                    minutesInput.value = minutes;
                }
            }

            // Update end time when duration changes
            function updateEndTime() {
                const startInput = document.querySelector('input[name="startDateTime"]');
                const endInput = document.querySelector('input[name="endDateTime"]');
                const hoursInput = document.querySelector('input[name="durationHours"]');
                const minutesInput = document.querySelector('input[name="durationMinutes"]');
                
                if (startInput.value && hoursInput.value && minutesInput.value) {
                    const start = new Date(startInput.value);
                    const hours = parseInt(hoursInput.value) || 0;
                    const minutes = parseInt(minutesInput.value) || 0;
                    
                    const end = new Date(start.getTime() + (hours * 60 * 60 * 1000) + (minutes * 60 * 1000));
                    
                    const year = end.getFullYear();
                    const month = String(end.getMonth() + 1).padStart(2, '0');
                    const day = String(end.getDate()).padStart(2, '0');
                    const hour = String(end.getHours()).padStart(2, '0');
                    const minute = String(end.getMinutes()).padStart(2, '0');
                    
                    endInput.value = `${year}-${month}-${day}T${hour}:${minute}`;
                }
            }

            // Form validation
            document.getElementById('eventForm').addEventListener('submit', function(e) {
                const startDateTime = new Date(document.querySelector('input[name="startDateTime"]').value);
                const endDateTime = new Date(document.querySelector('input[name="endDateTime"]').value);
                
                if (startDateTime >= endDateTime) {
                    alert('End date/time must be after start date/time');
                    e.preventDefault();
                    return false;
                }
                
                if (!document.querySelector('input[name="eventType"]:checked')) {
                    alert('Please select an event type');
                    e.preventDefault();
                    return false;
                }
                
                if (!document.querySelector('input[name="ticketType"]:checked')) {
                    alert('Please select a ticket type');
                    e.preventDefault();
                    return false;
                }
            });

            // Initialize event listeners
            document.querySelectorAll('input[type="datetime-local"]').forEach(input => {
                input.addEventListener('change', calculateDuration);
            });

            document.querySelectorAll('input[type="number"]').forEach(input => {
                input.addEventListener('change', updateEndTime);
            });
        });
    </script>
</body>
</html>