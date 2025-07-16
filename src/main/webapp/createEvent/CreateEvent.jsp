<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Event - Step 1: Information - MasterTicket</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style.css">
    <style>
        * { background-color: black; }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; margin-bottom: 5px; color: #fff; }
        .form-control { width: 100%; padding: 8px; border-radius: 5px; border: 1px solid #ccc; background: rgba(255, 255, 255, 0.1); color: #fff; }
        .form-row { display: flex; gap: 20px; }
        .form-row .form-group { flex: 1; }
        .form-actions { margin-top: 20px; display: flex; gap: 10px; }
        .btn { padding: 10px 20px; border: none; border-radius: 5px; cursor: pointer; font-size: 14px; text-decoration: none; color: #fff; }
        .btn-primary { background: #4CAF50; }
        .btn-primary:hover { background: #45a049; }
        .btn-secondary { background: #666; }
        .btn-secondary:hover { background: #555; }
        .error-message { color: #ff6b6b; margin-bottom: 15px; }
        .progress-bar { background: rgba(26, 26, 46, 0.9); padding: 1rem 2rem; border-bottom: 1px solid rgba(255, 255, 255, 0.1); }
        .progress-content { max-width: 1200px; margin: 0 auto; display: flex; align-items: center; gap: 2rem; }
        .progress-step { display: flex; align-items: center; gap: 0.5rem; font-size: 0.9rem; }
        .step-number { width: 30px; height: 30px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: bold; font-size: 0.8rem; }
        .step-number.active { background: #8b5fbf; color: white; }
        .step-number.inactive { background: rgba(255, 255, 255, 0.1); color: rgba(255, 255, 255, 0.5); }
        .step-connector { width: 40px; height: 2px; background: rgba(255, 255, 255, 0.1); }
    </style>
</head>
<body>
    <div class="progress-bar">
        <div class="progress-content">
            <div class="progress-step">
                <div class="step-number active">1</div>
                <span>Information</span>
            </div>
            <div class="step-connector"></div>
            <div class="progress-step">
                <div class="step-number inactive">2</div>
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
    <div class="main-content">
        <h2 style="margin-bottom: 20px; color: #fff;">🎭 Create New Event - Step 1: Information</h2>
        <c:if test="${not empty errorMessage}">
            <div class="error-message">${errorMessage}</div>
        </c:if>
        <c:if test="${empty genres}">
            <div class="error-message">Genres are not available. Please contact support.</div>
        </c:if>
        <form action="${pageContext.request.contextPath}/organizer-servlet" method="post" enctype="multipart/form-data">
            <input type="hidden" name="action" value="step1"/>
            <div class="form-group">
                <label for="name">Event Name *</label>
                <input type="text" id="name" name="name" class="form-control" value="${event.name}" required>
            </div>
            <div class="form-group">
                <label for="physicalLocation">Physical Location</label>
                <input type="text" id="physicalLocation" name="physicalLocation" class="form-control" value="${event.physicalLocation}">
            </div>
            <div class="form-group">
                <label for="genreID">Event Genre *</label>
                <select id="genreID" name="genreID" class="form-control" required>
                    <option value="">Select a genre</option>
                    <c:forEach var="genre" items="${genres}">
                        <option value="${genre.genreID}" ${event.genreID eq genre.genreID ? 'selected' : ''}>${genre.genreName}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="form-group">
                <label for="description">Event Description</label>
                <textarea id="description" name="description" class="form-control">${event.description}</textarea>
            </div>
            <div class="form-group">
                <label for="imageURL">Event Image</label>
                <input type="file" id="imageURL" name="imageURL" accept="image/*">
            </div>
            <div class="form-actions">
                <button type="submit" class="btn btn-primary">Continue →</button>
                <a href="${pageContext.request.contextPath}/organizer-servlet" class="btn btn-secondary">❌ Cancel</a>
            </div>
        </form>
    </div>
</body>
</html>