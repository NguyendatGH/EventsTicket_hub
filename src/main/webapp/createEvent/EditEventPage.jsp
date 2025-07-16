<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Edit Event - MasterTicket</title>
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
                background: rgba(255,255,255,0.1);
                color: white;
            }

            .btn-secondary:hover {
                background: rgba(255,255,255,0.2);
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

            .edit-form-container {
                background: rgba(255,255,255,0.1);
                backdrop-filter: blur(10px);
                border-radius: 15px;
                padding: 30px;
                margin-bottom: 30px;
            }

            .form-header {
                text-align: center;
                margin-bottom: 30px;
            }

            .form-header h1 {
                font-size: 2rem;
                margin-bottom: 10px;
                background: linear-gradient(45deg, #4CAF50, #45a049);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                background-clip: text;
            }

            .form-group {
                margin-bottom: 20px;
            }

            .form-group label {
                display: block;
                margin-bottom: 8px;
                color: #4CAF50;
                font-weight: 500;
            }

            .form-control {
                width: 100%;
                padding: 12px 15px;
                background: rgba(255,255,255,0.1);
                border: 1px solid rgba(255,255,255,0.2);
                border-radius: 8px;
                color: white;
                font-size: 16px;
                transition: all 0.3s;
            }

            .form-control:focus {
                outline: none;
                border-color: #4CAF50;
                background: rgba(76, 175, 80, 0.1);
            }

            .form-row {
                display: flex;
                gap: 20px;
            }

            .form-col {
                flex: 1;
            }

            .form-actions {
                display: flex;
                justify-content: flex-end;
                gap: 15px;
                margin-top: 30px;
            }

            textarea.form-control {
                min-height: 120px;
                resize: vertical;
            }

            .checkbox-group {
                display: flex;
                align-items: center;
                gap: 10px;
                margin-bottom: 10px;
            }

            .checkbox-group input[type="checkbox"] {
                width: 18px;
                height: 18px;
            }

            @media (max-width: 768px) {
                .sidebar {
                    transform: translateX(-100%);
                    transition: transform 0.3s;
                }

                .main-content {
                    margin-left: 0;
                }

                .form-row {
                    flex-direction: column;
                    gap: 0;
                }
            }
        </style>
    </head>
    <body>
        <!-- Sidebar -->
        <div class="sidebar">
            <div class="brand">🎟️ MasterTicket</div>
            <ul class="menu">
                <li><a href="${pageContext.request.contextPath}/dashboard.jsp">📅 My Events</a></li>
                <li><a href="#">📊 Manage Reports</a></li>
                <li><a href="#">📋 Rules</a></li>
                <li><a href="#">⚙️ Settings</a></li>
                <li><a href="#">📈 Analytics</a></li>
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
                    <a href="${pageContext.request.contextPath}/dashboard.jsp" class="active">Dashboard</a>
                </div>
                <div class="user-info">
                    <span>Welcome, Event Manager</span>
                    <a href="${pageContext.request.contextPath}/logout" class="btn btn-logout">Logout</a>
                </div>
            </nav>

            <!-- Edit Event Form -->
            <div class="edit-form-container">
                <div class="form-header">
                    <h1>✏️ Edit Event</h1>
                    <p>Update your event details below</p>
                </div>

                <form action="${pageContext.request.contextPath}/organizer-servlet?action=update" method="POST">
                    <input type="hidden" name="eventID" value="${event.eventID}">

                    <div class="form-row">
                        <div class="form-col">
                            <div class="form-group">
                                <label for="eventName">Event Name</label>
                                <input type="text" class="form-control" id="eventName" name="eventName" 
                                       value="<c:out value='${event.name}' />" required>
                            </div>
                        </div>
<!--                        <div class="form-col">
                            <div class="form-group">
                                <label for="eventCategory">Category</label>
                                <select class="form-control" id="eventCategory" name="eventCategory" required>
                                    <option value="">Select a category</option>
                                    <option value="concert" ${event.category eq 'concert' ? 'selected' : ''}>Concert</option>
                                    <option value="theater" ${event.category eq 'theater' ? 'selected' : ''}>Theater</option>
                                    <option value="sports" ${event.category eq 'sports' ? 'selected' : ''}>Sports</option>
                                    <option value="conference" ${event.category eq 'conference' ? 'selected' : ''}>Conference</option>
                                    <option value="festival" ${event.category eq 'festival' ? 'selected' : ''}>Festival</option>
                                </select>
                            </div>
                        </div>-->
                    </div>

                    <div class="form-group">
                        <label for="eventDescription">Description</label>
                        <textarea class="form-control" id="eventDescription" name="eventDescription" 
                                  required><c:out value='${event.description}' /></textarea>
                    </div>

<!--                    <div class="form-row">
                        <div class="form-col">
                            <div class="form-group">
                                <label for="startDate">Start Date & Time</label>
                                <input type="datetime-local" class="form-control" id="startDate" name="startDate" 
                                       value="<fmt:formatDate value='${event.startTime}' pattern='yyyy-MM-dd&#39;T&#39;HH:mm' />"
                            </div>
                        </div>
                        <div class="form-col">
                            <div class="form-group">
                                <label for="endDate">End Date & Time</label>
                                <input type="datetime-local" class="form-control" id="endDate" name="endDate" 
                                       <fmt:formatDate var="formattedEndTime" value="${event.endTime}" pattern="yyyy-MM-dd'T'HH:mm" />
                                       <input type="datetime-local" class="form-control" id="endDate" name="endDate"
                                       value="${formattedEndTime}" required>
                            </div>
                        </div>
                    </div>


                    <div class="form-row">
                        <div class="form-col">
                            <div class="form-group">
                                <label for="locationType">Location Type</label>
                                <select class="form-control" id="locationType" name="locationType" required>
                                    <option value="physical" ${not empty event.physicalLocation ? 'selected' : ''}>Physical Location</option>
                                    <option value="online" ${not empty event.onlineLink ? 'selected' : ''}>Online Event</option>
                                </select>
                            </div>
                        </div>
                        <div class="form-col">
                            <div class="form-group" id="physicalLocationGroup" 
                                 style="${empty event.physicalLocation ? 'display: none;' : ''}">
                                <label for="physicalLocation">Physical Location</label>
                                <input type="text" class="form-control" id="physicalLocation" name="physicalLocation" 
                                       value="<c:out value='${event.physicalLocation}' />">
                            </div>
                            <div class="form-group" id="onlineLinkGroup" 
                                 style="${empty event.onlineLink ? 'display: none;' : ''}">
                                <label for="onlineLink">Online Link</label>
                                <input type="url" class="form-control" id="onlineLink" name="onlineLink" 
                                       value="<c:out value='${event.onlineLink}' />">
                            </div>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-col">
                            <div class="form-group">
                                <label for="totalTickets">Total Tickets Available</label>
                                <input type="number" class="form-control" id="totalTickets" name="totalTickets" 
                                       value="<c:out value='${event.totalTicketCount}' />" min="1" required>
                            </div>
                        </div>
                        <div class="form-col">
                            <div class="form-group">
                                <label for="ticketPrice">Ticket Price ($)</label>
                                <input type="number" class="form-control" id="ticketPrice" name="ticketPrice" 
                                       value="<c:out value='${event.ticketPrice}' />" min="0" step="0.01" required>
                            </div>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Event Status</label>
                        <div class="checkbox-group">
                            <input type="radio" id="statusActive" name="eventStatus" value="active" 
                                   ${event.status eq 'active' ? 'checked' : ''}>
                            <label for="statusActive">Active</label>
                        </div>
                        <div class="checkbox-group">
                            <input type="radio" id="statusPending" name="eventStatus" value="pending" 
                                   ${event.status eq 'pending' ? 'checked' : ''}>
                            <label for="statusPending">Pending</label>
                        </div>
                        <div class="checkbox-group">
                            <input type="radio" id="statusEnded" name="eventStatus" value="ended" 
                                   ${event.status eq 'ended' ? 'checked' : ''}>
                            <label for="statusEnded">Ended</label>
                        </div>
                    </div>

                    <div class="form-actions">
                        <button type="button" class="btn btn-secondary" 
                                onclick="window.location.href = '${pageContext.request.contextPath}/dashboard.jsp'">
                            Cancel
                        </button>
                        <button type="submit" class="btn btn-primary">
                            Save Changes
                        </button>
                    </div>
                </form>
            </div>
        </div>-->

        <script>
            // Toggle between physical and online location fields
            document.getElementById('locationType').addEventListener('change', function () {
                const locationType = this.value;
                const physicalGroup = document.getElementById('physicalLocationGroup');
                const onlineGroup = document.getElementById('onlineLinkGroup');

                if (locationType === 'physical') {
                    physicalGroup.style.display = 'block';
                    onlineGroup.style.display = 'none';
                    document.getElementById('onlineLink').value = '';
                } else {
                    physicalGroup.style.display = 'none';
                    onlineGroup.style.display = 'block';
                    document.getElementById('physicalLocation').value = '';
                }
            });

            // Form validation
            document.querySelector('form').addEventListener('submit', function (e) {
                const startDate = new Date(document.getElementById('startDate').value);
                const endDate = new Date(document.getElementById('endDate').value);

                if (startDate >= endDate) {
                    e.preventDefault();
                    alert('End date must be after start date');
                    return false;
                }

                const locationType = document.getElementById('locationType').value;
                if (locationType === 'physical' && !document.getElementById('physicalLocation').value) {
                    e.preventDefault();
                    alert('Please enter a physical location');
                    return false;
                }

                if (locationType === 'online' && !document.getElementById('onlineLink').value) {
                    e.preventDefault();
                    alert('Please enter an online link');
                    return false;
                }

                return true;
            });
        </script>
    </body>
</html>