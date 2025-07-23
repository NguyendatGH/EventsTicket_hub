<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Event - Step 4: Ticket Info - MasterTicket</title>
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
                <div class="step-number completed">3</div>
                <span>Settings</span>
            </div>
            <div class="step-connector completed"></div>
            <div class="progress-step">
                <div class="step-number active">4</div>
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
            <h1 class="page-title">Ticket Info Settings</h1>
            <p class="page-subtitle">Review and confirm ticket information</p>
            <c:if test="${not empty successMessage}">
                <div class="alert alert-success">${successMessage}</div>
            </c:if>
            <c:if test="${not empty errorMessage}">
                <div class="alert">${errorMessage}</div>
            </c:if>
            <form action="${pageContext.request.contextPath}/organizer-servlet" method="post" id="ticketForm">
                <input type="hidden" name="action" value="create"/>
                <div class="form-section">
                    <h3 class="section-title">Ticket Information</h3>
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
                                <label class="form-label">Total Ticket Count *</label>
                                <input type="number" class="form-input" name="totalTicketCount" value="${event.totalTicketCount != null ? event.totalTicketCount : ''}" required>
                            </div>
                            <div id="ticketTypes">
                                <div class="ticket-type">
                                    <div class="form-row">
                                        <div class="form-group">
                                            <label class="form-label">Ticket Name *</label>
                                            <input type="text" class="form-input" name="ticketName[]" required>
                                        </div>
                                        <div class="form-group">
                                            <label class="form-label">Price (VND) *</label>
                                            <input type="number" step="0.01" class="form-input" name="ticketPrice[]" required>
                                        </div>
                                        <div class="form-group">
                                            <label class="form-label">Quantity *</label>
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
                        <label class="form-label">Ticket Name *</label>
                        <input type="text" class="form-input" name="ticketName[]" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Price (VND) *</label>
                        <input type="number" step="0.01" class="form-input" name="ticketPrice[]" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Quantity *</label>
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
                    alert('Sum of ticket quantities must equal total ticket count');
                    e.preventDefault();
                }
            }
        });
    </script>
</body>
</html>