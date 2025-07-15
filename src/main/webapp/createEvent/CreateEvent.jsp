<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@page import="models.Event"%>

<%
    Event event = (Event) request.getAttribute("event");
    // Bạn đã setAttribute("event", ...) ở servlet
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Event - ${event.eventName}</title>
    <link rel="stylesheet" href="style.css"><!-- dùng lại style hiện tại -->
</head>
<body>
<div class="main-content">
    <h2 style="margin-bottom: 20px; color: #fff;">✏️ Edit Event - ${event.eventName}</h2>

    <form action="${pageContext.request.contextPath}/updateEvent" method="post" enctype="multipart/form-data">
        <input type="hidden" name="eventId" value="${event.eventId}"/>

        <!-- Event Name -->
        <div class="form-group">
            <label for="eventName">Name event *</label>
            <input type="text" id="eventName" name="eventName" class="form-control" value="${event.eventName}">
        </div>

        <!-- Event Type -->
        <div class="form-group">
            <label>Event address</label>
            <div class="radio-group">
                <div class="radio-item">
                    <input type="radio" id="offline" name="eventType" value="offline"
                           ${event.eventType == 'offline' ? 'checked' : ''}>
                    <label for="offline">🏢 Offline</label>
                </div>
                <div class="radio-item">
                    <input type="radio" id="online" name="eventType" value="online"
                           ${event.eventType == 'online' ? 'checked' : ''}>
                    <label for="online">🌐 Online</label>
                </div>
            </div>
        </div>

        <!-- Location -->
        <div id="locationDetails" style="display: ${event.eventType == 'offline' ? 'block' : 'none'};">
            <div class="form-group">
                <label for="locationName">Name location</label>
                <input type="text" id="locationName" name="locationName" class="form-control"
                       value="${event.locationName}">
            </div>
            <!-- Add more inputs for address like province/district if needed -->
        </div>

        <!-- Genre -->
        <div class="form-group">
            <label for="genreId">Event Type</label>
            <select id="genreId" name="genreId" class="form-control">
                <c:forEach var="genre" items="${genres}">
                    <option value="${genre.genreID}"
                        ${genre.genreID == event.genreId ? 'selected' : ''}>
                        ${genre.genreName}
                    </option>
                </c:forEach>
            </select>
        </div>

        <!-- Start and End Time -->
        <div class="form-row">
            <div class="form-group">
                <label for="startTime">Start Time</label>
                <input type="datetime-local" id="startTime" name="startTime" class="form-control"
                       value="${event.startTime}">
            </div>
            <div class="form-group">
                <label for="endTime">End Time</label>
                <input type="datetime-local" id="endTime" name="endTime" class="form-control"
                       value="${event.endTime}">
            </div>
        </div>

        <!-- Total Tickets -->
        <div class="form-group">
            <label for="totalTickets">Total Tickets</label>
            <input type="number" id="totalTickets" name="totalTickets" class="form-control"
                   value="${event.totalTickets}">
        </div>

        <!-- Organizer Name -->
        <div class="form-group">
            <label for="organizerName">Organizer Name</label>
            <input type="text" id="organizerName" name="organizerName" class="form-control"
                   value="${event.organizerName}">
        </div>

        <!-- Description -->
        <div class="form-group">
            <label for="eventInfo">Event Information</label>
            <textarea id="eventInfo" name="eventInfo" class="form-control">${event.eventInfo}</textarea>
        </div>

        <!-- Action buttons -->
        <div class="form-actions">
            <button type="submit" class="btn btn-primary">💾 Save Changes</button>
            <a href="${pageContext.request.contextPath}/myEvents" class="btn btn-secondary">❌ Cancel</a>
        </div>
    </form>
</div>
</body>
</html>
