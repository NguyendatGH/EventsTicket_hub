<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Event - Step 4: Ticket Info - MasterTicket</title>
    <style>
    /* Base Styles */
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

    /* Header Styles */
    .header {
        background: rgba(0,0,0,0.3);
        backdrop-filter: blur(10px);
        padding: 15px 0;
        position: sticky;
        top: 0;
        z-index: 100;
        border-bottom: 1px solid rgba(255,255,255,0.1);
    }

    .header-content {
        max-width: 1200px;
        margin: 0 auto;
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 0 20px;
    }

    .logo {
        font-size: 24px;
        font-weight: bold;
        color: #4CAF50;
    }

    .nav-links {
        display: flex;
        gap: 25px;
    }

    .nav-links a {
        text-decoration: none;
        color: rgba(255,255,255,0.8);
        font-weight: 500;
        transition: all 0.3s;
        padding: 8px 16px;
        border-radius: 20px;
    }

    .nav-links a:hover,
    .nav-links a.active {
        opacity: 1;
        color: #4CAF50;
        background: rgba(76, 175, 80, 0.1);
    }

    /* Button Styles */
    .btn-primary, .btn-secondary {
        padding: 10px 20px;
        border-radius: 5px;
        font-weight: 500;
        cursor: pointer;
        transition: all 0.3s;
        border: none;
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
        color: #fff;
        border: 1px solid rgba(255,255,255,0.2);
    }

    .btn-secondary:hover {
        background: rgba(76, 175, 80, 0.2);
        border-color: #4CAF50;
        transform: translateY(-2px);
    }

    /* Progress Bar */
    .progress-bar {
        background: rgba(0,0,0,0.3);
        backdrop-filter: blur(10px);
        padding: 20px 0;
    }

    .progress-content {
        max-width: 1200px;
        margin: 0 auto;
        display: flex;
        justify-content: center;
        align-items: center;
        padding: 0 20px;
    }

    .progress-step {
        display: flex;
        flex-direction: column;
        align-items: center;
        position: relative;
    }

    .step-number {
        width: 30px;
        height: 30px;
        border-radius: 50%;
        display: flex;
        justify-content: center;
        align-items: center;
        font-weight: bold;
        margin-bottom: 5px;
    }

    .step-number.completed {
        background-color: #4CAF50;
        color: white;
    }

    .step-number.active {
        background-color: #4CAF50;
        color: white;
        box-shadow: 0 0 0 3px rgba(76, 175, 80, 0.3);
    }

    .step-number:not(.completed):not(.active) {
        background-color: rgba(255,255,255,0.2);
        color: rgba(255,255,255,0.7);
    }

    .step-connector {
        height: 2px;
        width: 80px;
        background-color: rgba(255,255,255,0.2);
    }

    .step-connector.completed {
        background-color: #4CAF50;
    }

    /* Main Container */
    .container {
        max-width: 1200px;
        margin: 30px auto;
        display: flex;
        gap: 20px;
        padding: 0 20px;
    }

    /* Sidebar */
    .sidebar {
        width: 250px;
        background: rgba(0,0,0,0.3);
        backdrop-filter: blur(10px);
        border-radius: 15px;
        padding: 20px;
        height: fit-content;
        border: 1px solid rgba(255,255,255,0.1);
    }

    .sidebar h3 {
        margin-bottom: 20px;
        color: #4CAF50;
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
        text-decoration: none;
        color: rgba(255,255,255,0.7);
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

    /* Main Content */
    .main-content {
        flex: 1;
        background: rgba(255,255,255,0.1);
        backdrop-filter: blur(10px);
        border-radius: 15px;
        padding: 30px;
        border: 1px solid rgba(255,255,255,0.1);
    }

    .page-title {
        font-size: 28px;
        margin-bottom: 10px;
        background: linear-gradient(45deg, #4CAF50, #45a049);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
    }

    .page-subtitle {
        color: rgba(255,255,255,0.7);
        margin-bottom: 30px;
    }

    /* Form Styles */
    .form-section {
        margin-bottom: 30px;
    }

    .section-title {
        font-size: 20px;
        margin-bottom: 20px;
        color: #4CAF50;
        padding-bottom: 10px;
        border-bottom: 1px solid rgba(255,255,255,0.1);
    }

    .form-group {
        margin-bottom: 20px;
    }

    .form-label {
        display: block;
        margin-bottom: 8px;
        font-weight: 500;
        color: rgba(255,255,255,0.8);
    }

    .form-input {
        width: 100%;
        padding: 10px 15px;
        border: 1px solid rgba(255,255,255,0.2);
        border-radius: 5px;
        font-size: 16px;
        transition: all 0.3s;
        background: rgba(255,255,255,0.1);
        color: #fff;
    }

    .form-input:focus {
        outline: none;
        border-color: #4CAF50;
        background: rgba(76, 175, 80, 0.1);
    }

    .form-input::placeholder {
        color: rgba(255,255,255,0.5);
    }

    .form-row {
        display: flex;
        gap: 15px;
        margin-bottom: 15px;
        align-items: flex-end;
    }

    .form-row .form-group {
        flex: 1;
        margin-bottom: 0;
    }

    /* Table Styles */
    table {
        width: 100%;
        border-collapse: collapse;
        margin-bottom: 20px;
        background: rgba(255,255,255,0.05);
        border-radius: 10px;
        overflow: hidden;
    }

    th, td {
        padding: 12px 15px;
        text-align: left;
        border-bottom: 1px solid rgba(255,255,255,0.1);
    }

    th {
        background: rgba(76, 175, 80, 0.2);
        font-weight: 600;
        color: #4CAF50;
    }

    tr:hover {
        background: rgba(255,255,255,0.05);
    }

    /* Alert Styles */
    .alert {
        padding: 15px;
        margin-bottom: 20px;
        border-radius: 5px;
        background: rgba(244, 67, 54, 0.2);
        color: #f44336;
        border: 1px solid rgba(244, 67, 54, 0.3);
        position: relative;
    }

    .alert-success {
        background: rgba(76, 175, 80, 0.2);
        color: #4CAF50;
        border: 1px solid rgba(76, 175, 80, 0.3);
        position: relative;
        display: flex;
        align-items: center;
        gap: 10px;
    }

    .alert-dismiss {
        position: absolute;
        right: 15px;
        top: 15px;
        cursor: pointer;
        color: inherit;
        font-size: 16px;
        background: none;
        border: none;
    }

    /* Action Buttons */
    .action-buttons {
        display: flex;
        justify-content: space-between;
        margin-top: 30px;
    }

    /* Ticket Type Styles */
    .ticket-type {
        background: rgba(255,255,255,0.05);
        padding: 15px;
        border-radius: 10px;
        margin-bottom: 15px;
        border: 1px solid rgba(255,255,255,0.1);
    }

    .remove-ticket {
        margin-left: auto;
    }

    #addTicketType {
        margin-top: 10px;
    }

    /* Responsive Styles */
    @media (max-width: 768px) {
        .container {
            flex-direction: column;
        }
        
        .sidebar {
            width: 100%;
            margin-bottom: 20px;
        }
        
        .form-row {
            flex-direction: column;
        }
        
        .nav-links {
            display: none;
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
                <span>Thời gian & Thể loại</span>
            </div>
            <div class="step-connector completed"></div>
            <div class="progress-step">
                <div class="step-number completed">3</div>
                <span>Cài đặt</span>
            </div>
            <div class="step-connector completed"></div>
            <div class="progress-step">
                <div class="step-number active">4</div>
                <span>Thông tin vé</span>
            </div>
        </div>
    </div>
    <div class="container">

        <div class="main-content">
            <h1 class="page-title">Cài đặt thông tin vé</h1>
            
            <c:if test="${not empty errorMessage}">
                <div class="alert">
                    <span>${errorMessage}</span>
                    <button class="alert-dismiss">✕</button>
                </div>
            </c:if>
           
            <form action="${pageContext.request.contextPath}/organizer-servlet" method="post" id="ticketForm">
                <input type="hidden" name="action" value="create"/>
                <div class="form-section">

                    <c:choose>
                        <c:when test="${event.hasSeatingChart}">
                            <p>Total Tickets: ${event.totalTicketCount}</p>
                            <c:choose>
                                <c:when test="${not empty ticketInfo}">
                                    <table>
                                        <tr>
                                            <th>Zone</th>
                                            <th>Ticket Name</th>
                                            <th>Quantity</th>
                                            <th>Price</th>
                                        </tr>
                                        <c:forEach var="entry" items="${ticketInfo}">
                                            <tr>
                                                <td>${entry.key}</td>
                                                <td>${entry.value.ticketName}</td>
                                                <td>${entry.value.maxQuantityPerOrder}</td>
                                                <td>${entry.value.price}</td>
                                            </tr>
                                        </c:forEach>
                                    </table>
                                </c:when>
                                <c:otherwise>
                                    <p class="alert">No ticket information available. Please assign ticket names for all zones.</p>
                                </c:otherwise>
                            </c:choose>
                            <input type="hidden" name="totalTicketCount" value="${event.totalTicketCount}"/>
                        </c:when>
                        <c:otherwise>
                            <div class="form-group">
                                <label class="form-label">Tổng số lượng vé *</label>
                                <input type="number" class="form-input" name="totalTicketCount" value="${event.totalTicketCount != null ? event.totalTicketCount : ''}" required>
                            </div>
                            <div id="ticketTypes">
                                <div class="ticket-type">
                                    <div class="form-row">
                                        <div class="form-group">
                                            <label class="form-label">Tên vé *</label>
                                            <input type="text" class="form-input" name="ticketName[]" required>
                                        </div>
                                        <div class="form-group">
                                            <label class="form-label">Giá tiền (VND) *</label>
                                            <input type="number" step="0.01" class="form-input" name="ticketPrice[]" required>
                                        </div>
                                        <div class="form-group">
                                            <label class="form-label">Số lượng *</label>
                                            <input type="number" class="form-input" name="ticketQuantity[]" required>
                                        </div>
                                        <button type="button" class="btn-secondary remove-ticket">Remove</button>
                                    </div>
                                </div>
                            </div>
                            <button type="button" class="btn-primary" id="addTicketType">Add Ticket Type</button>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="action-buttons">
                    <a href="${pageContext.request.contextPath}/organizer-servlet?action=${event.hasSeatingChart ? 'customizeSeats' : 'step3'}" class="btn-secondary">← Back</a>
                    <c:if test="${empty successMessage}">
                        <button type="submit" class="btn-primary">Create Event →</button>
                    </c:if>
                    <c:if test="${not empty successMessage}">
                        <a href="${pageContext.request.contextPath}/events" class="btn-primary">View My Events →</a>
                    </c:if>
                </div>
            </form>
        </div>
    </div>
    <script>
        document.getElementById('addTicketType')?.addEventListener('click', function() {
            const ticketTypes = document.getElementById('ticketTypes');
            const newTicketType = document.createElement('div');
            newTicketType.className = 'ticket-type';
            newTicketType.innerHTML = `
                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label">Tên vé *</label>
                        <input type="text" class="form-input" name="ticketName[]" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Giá tiền (VND) *<label>
                        <input type="number" step="0.01" class="form-input" name="ticketPrice[]" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Số lượng *</label>
                        <input type="number" class="form-input" name="ticketQuantity[]" required>
                    </div>
                    <button type="button" class="btn-secondary remove-ticket">Remove</button>
                </div>`;
            ticketTypes.appendChild(newTicketType);
        });

        document.addEventListener('click', function(e) {
            if (e.target.classList.contains('remove-ticket')) {
                if (document.querySelectorAll('.ticket-type').length > 1) {
                    e.target.closest('.ticket-type').remove();
                }
            }
        });

        document.getElementById('ticketForm')?.addEventListener('submit', function(e) {
            if (!${event.hasSeatingChart}) {
                const totalTicketCount = parseInt(document.querySelector('input[name="totalTicketCount"]').value);
                const quantities = Array.from(document.querySelectorAll('input[name="ticketQuantity[]"]')).map(input => parseInt(input.value) || 0);
                const totalQuantity = quantities.reduce((sum, qty) => sum + qty, 0);
                if (totalQuantity !== totalTicketCount) {
                    e.preventDefault();
                    const mainContent = document.querySelector('.main-content');
                    const errorAlert = document.createElement('div');
                    errorAlert.className = 'alert';
                    errorAlert.innerHTML = '<span>Tổng số lượng các vé bên dưới phải trùng khớp với tổng số vé!</span><button class="alert-dismiss">✕</button>';
                    mainContent.insertBefore(errorAlert, mainContent.firstChild);
                }
            }
        });

        document.addEventListener('click', function(e) {
            if (e.target.classList.contains('alert-dismiss')) {
                e.target.closest('.alert, .alert-success').remove();
            }
        });
    </script>
</body>
</html>