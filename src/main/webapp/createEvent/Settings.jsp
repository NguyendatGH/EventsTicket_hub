<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Event - Time & Type</title>
    <style>
        /* [Previous CSS content remains exactly the same] */
    </style>
</head>
<body>
    <!-- Header -->
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
                    <a href="${pageContext.request.contextPath}/logout" class="login-btn">Logout</a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/login" class="login-btn">Login</a>
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
                <li><a href="${pageContext.request.contextPath}/events" class="active">📅 My event</a></li>
                <li><a href="${pageContext.request.contextPath}/reports">📊 Manage Report</a></li>
                <li><a href="${pageContext.request.contextPath}/rules">⚙️ Rules</a></li>
            </ul>
        </div>

        <!-- Main Content -->
        <div class="main-content">
            <h1 class="page-title">Time & Type</h1>
            <p class="page-subtitle">Set up your event schedule and choose the event type</p>

            <form action="${pageContext.request.contextPath}/events/create/time-type" method="post" id="eventForm">
                <!-- Event Schedule Section -->
                <div class="form-section">
                    <h3 class="section-title">📅 Event Schedule</h3>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Start Date & Time</label>
                            <div class="datetime-input">
                                <input type="datetime-local" class="form-input" name="startDateTime" 
                                    value="<c:out value="${not empty event.startDateTime ? event.startDateTime : '2025-07-15T10:00'}"/>" required>
                            </div>
                            <div class="time-zone-selector">
                                <span class="timezone-display">GMT+7 (Vietnam)</span>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label">End Date & Time</label>
                            <div class="datetime-input">
                                <input type="datetime-local" class="form-input" name="endDateTime" 
                                    value="<c:out value="${not empty event.endDateTime ? event.endDateTime : '2025-07-15T18:00'}"/>" required>
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
                                    value="<c:out value="${not empty event.durationHours ? event.durationHours : '8'}"/>" min="0" required>
                                <div class="duration-label">Hours</div>
                            </div>
                            <div class="duration-input">
                                <input type="number" class="form-input" name="durationMinutes" placeholder="0" 
                                    value="<c:out value="${not empty event.durationMinutes ? event.durationMinutes : '0'}"/>" min="0" max="59" required>
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
                            <div class="event-type-card ${event.eventType eq type.value ? 'selected' : ''}" 
                                data-value="${type.value}">
                                <div class="event-type-icon">${type.icon}</div>
                                <div class="event-type-title">${type.name}</div>
                                <div class="event-type-desc">${type.description}</div>
                                <input type="radio" name="eventType" value="${type.value}" 
                                    ${event.eventType eq type.value ? 'checked' : ''} style="display: none;">
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
                                <div class="ticket-option ${event.ticketType eq ticketType.value ? 'selected' : ''}" 
                                    data-value="${ticketType.value}">
                                    <div class="ticket-option-title">${ticketType.name}</div>
                                    <div class="ticket-option-desc">${ticketType.description}</div>
                                    <input type="radio" name="ticketType" value="${ticketType.value}" 
                                        ${event.ticketType eq ticketType.value ? 'checked' : ''} style="display: none;">
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
                                    ${event.frequency eq frequency.value ? 'selected' : ''}>${frequency.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <!-- Hidden fields for previous step data -->
                <input type="hidden" name="eventId" value="${event.id}">
                <input type="hidden" name="step" value="2">

                <!-- Action Buttons -->
                <div class="action-buttons">
                    <a href="${pageContext.request.contextPath}/events/create/info?eventId=${event.id}" class="btn-secondary">← Back</a>
                    <button type="submit" class="btn-primary">Continue →</button>
                </div>
            </form>
        </div>
    </div>

    <script>
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
                const diff = end - start;
                
                const hours = Math.floor(diff / (1000 * 60 * 60));
                const minutes = Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60));
                
                hoursInput.value = hours;
                minutesInput.value = minutes;
            }
        }

        document.querySelectorAll('input[type="datetime-local"]').forEach(input => {
            input.addEventListener('change', calculateDuration);
        });

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

        document.querySelectorAll('input[type="number"]').forEach(input => {
            input.addEventListener('change', updateEndTime);
        });

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
    </script>
</body>
</html>