<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Event - Step 3.5: Customize Seat Tickets - MasterTicket</title>
    <style>
    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    }

    body {
        background: linear-gradient(135deg, #122536 0%, #764ba2 100%);
        min-height: 100vh;
        color: #fff;
    }

    .header {
        background: rgba(0, 0, 0, 0.3);
        backdrop-filter: blur(10px);
        padding: 15px 0;
        border-bottom: 1px solid rgba(255, 255, 255, 0.1);
    }

    .header-content {
        max-width: 1200px;
        margin: 0 auto;
        padding: 0 20px;
        display: flex;
        align-items: center;
        justify-content: space-between;
    }

    .logo {
        font-size: 24px;
        font-weight: bold;
        color: #4CAF50;
        display: flex;
        align-items: center;
        gap: 10px;
    }

    .nav-links {
        display: flex;
        gap: 25px;
    }

    .nav-links a {
        color: rgba(255, 255, 255, 0.8);
        text-decoration: none;
        transition: all 0.3s;
        padding: 8px 0;
        position: relative;
    }

    .nav-links a:hover {
        color: #4CAF50;
    }

    .nav-links a::after {
        content: '';
        position: absolute;
        bottom: 0;
        left: 0;
        width: 0;
        height: 2px;
        background: #4CAF50;
        transition: width 0.3s;
    }

    .nav-links a:hover::after {
        width: 100%;
    }

    .btn-primary {
        padding: 8px 20px;
        background: #4CAF50;
        color: white;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        transition: all 0.3s;
        text-decoration: none;
        display: inline-block;
    }

    .btn-primary:hover {
        background: #45a049;
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(76, 175, 80, 0.3);
    }

    .progress-bar {
        background: rgba(26, 26, 46, 0.9);
        padding: 1.5rem 2rem;
        border-bottom: 1px solid rgba(255, 255, 255, 0.1);
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
        color: rgba(255, 255, 255, 0.7);
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
        box-shadow: 0 0 15px rgba(76, 175, 80, 0.5);
    }

    .step-number.active {
        background: rgba(76, 175, 80, 0.3);
        color: #4CAF50;
        border: 2px solid #4CAF50;
    }

    .step-number.inactive {
        background: rgba(255, 255, 255, 0.1);
        color: rgba(255, 255, 255, 0.5);
    }

    .step-connector {
        width: 60px;
        height: 2px;
        background: rgba(255, 255, 255, 0.1);
    }

    .step-connector.completed {
        background: #4CAF50;
    }

    .container {
        max-width: 1200px;
        margin: 30px auto;
        display: flex;
        gap: 20px;
        padding: 0 20px;
    }

    .sidebar {
        width: 250px;
        background: rgba(0, 0, 0, 0.3);
        backdrop-filter: blur(10px);
        border-radius: 15px;
        padding: 20px;
        height: fit-content;
    }

    .sidebar h3 {
        color: #4CAF50;
        font-size: 20px;
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
        flex: 1;
        background: rgba(255, 255, 255, 0.1);
        backdrop-filter: blur(10px);
        border-radius: 15px;
        padding: 30px;
        border: 1px solid rgba(255, 255, 255, 0.1);
    }

    .page-title {
        font-size: 2rem;
        margin-bottom: 10px;
        background: linear-gradient(45deg, #4CAF50, #45a049);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
    }

    .page-subtitle {
        color: rgba(255, 255, 255, 0.7);
        margin-bottom: 30px;
        font-size: 1rem;
    }

    .alert {
        color: #ff6b6b;
        background: rgba(255, 107, 107, 0.1);
        padding: 15px;
        border-radius: 8px;
        margin-bottom: 20px;
        border: 1px solid #ff6b6b;
    }

    .form-section {
        margin-bottom: 30px;
    }

    .section-title {
        color: #4CAF50;
        font-size: 1.5rem;
        margin-bottom: 20px;
        display: flex;
        align-items: center;
        gap: 10px;
    }

    .form-group {
        margin-bottom: 20px;
    }

    .form-label {
        display: block;
        margin-bottom: 10px;
        color: rgba(255, 255, 255, 0.8);
        font-size: 14px;
    }

    .form-input {
        width: 100%;
        padding: 12px 15px;
        background: rgba(255, 255, 255, 0.1);
        border: 1px solid rgba(255, 255, 255, 0.2);
        border-radius: 8px;
        color: white;
        font-size: 14px;
        transition: all 0.3s;
    }

    .form-input:focus {
        outline: none;
        border-color: #4CAF50;
        box-shadow: 0 0 0 3px rgba(76, 175, 80, 0.2);
    }

    .action-buttons {
        display: flex;
        justify-content: space-between;
        margin-top: 30px;
    }

    .btn-secondary {
        padding: 12px 24px;
        background: rgba(255, 255, 255, 0.1);
        color: white;
        border: 1px solid rgba(255, 255, 255, 0.2);
        border-radius: 8px;
        cursor: pointer;
        transition: all 0.3s;
        text-decoration: none;
        display: inline-flex;
        align-items: center;
        gap: 8px;
    }

    .btn-secondary:hover {
        background: rgba(255, 255, 255, 0.2);
        transform: translateY(-2px);
    }

    @media (max-width: 768px) {
        .container {
            flex-direction: column;
        }
        
        .sidebar {
            width: 100%;
            margin-bottom: 20px;
        }
        
        .progress-content {
            flex-wrap: wrap;
            gap: 1rem;
        }
        
        .step-connector {
            display: none;
        }
        
        .action-buttons {
            flex-direction: column;
            gap: 15px;
        }
        
        .btn-primary, .btn-secondary {
            width: 100%;
            text-align: center;
        }
    }

    @media (max-width: 480px) {
        .header-content {
            flex-direction: column;
            gap: 15px;
        }
        
        .nav-links {
            flex-wrap: wrap;
            justify-content: center;
        }
        
        .page-title {
            font-size: 1.5rem;
        }
    }
</style>
</head>
<body>
    
    <div class="progress-bar">
        <div class="progress-content">
            <div class="progress-step">
                <div class="step-number completed">1</div>
                <span>Thông tin</span>
            </div>
            <div class="step-connector completed"></div>
            <div class="progress-step">
                <div class="step-number completed">2</div>
                <span>Thời gian & Địa điểm</span>
            </div>
            <div class="step-connector completed"></div>
            <div class="progress-step">
                <div class="step-number active">3</div>
                <span>Cài đặt</span>
            </div>
            <div class="step-connector"></div>
            <div class="progress-step">
                <div class="step-number inactive">4</div>
                <span>Thông tin vé</span>
            </div>
        </div>
    </div>
    <div class="container">

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