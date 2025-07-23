<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Event - Step 3.5: Customize Seat Tickets - MasterTicket</title>
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
                <div class="step-number completed">2</div>
                <span>Time & Type</span>
            </div>
            <div class="step-connector completed"></div>
            <div class="progress-step">
                <div class="step-number active">3</div>
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
            <h1 class="page-title">Customize Seat Tickets</h1>
            <p class="page-subtitle">Assign a ticket name for all seats in each zone</p>
            <c:if test="${not empty errorMessage}">
                <div class="alert">${errorMessage}</div>
            </c:if>
            <form action="${pageContext.request.contextPath}/organizer-servlet" method="post" id="customizeSeatsForm">
                <input type="hidden" name="action" value="customizeSeats"/>
                <div class="form-section">
                    <h3 class="section-title">Seat Ticket Names</h3>
                    <c:forEach var="zone" items="${zones}">
                        <div class="form-group">
                            <label class="form-label">Zone: ${zone.name} (${zone.totalSeats} seats)</label>
                            <input type="hidden" name="zoneIds[]" value="${zone.id}"/>
                            <input type="text" class="form-input" name="ticketNames[]" placeholder="Enter ticket name for seats in ${zone.name}" required>
                        </div>
                    </c:forEach>
                </div>
                <div class="action-buttons">
                    <a href="${pageContext.request.contextPath}/organizer-servlet?action=previewMap" class="btn-secondary">← Back</a>
                    <button type="submit" class="btn-primary">Continue →</button>
                </div>
            </form>
        </div>
    </div>
    <script>
document.getElementById('customizeSeatsForm').addEventListener('submit', function(e) {
    const ticketNames = document.querySelectorAll('input[name="ticketNames[]"]');
    const zoneIds = document.querySelectorAll('input[name="zoneIds[]"]');
    
    if (ticketNames.length !== zoneIds.length) {
        alert('Mismatch between ticket names and zones. Please ensure all zones have a ticket name.');
        e.preventDefault();
        return;
    }
    
    for (let input of ticketNames) {
        if (input.value.trim() === '') {
            alert('Please provide a ticket name for seats in each zone.');
            e.preventDefault();
            return;
        }
    }
});
</script>
</body>
</html>