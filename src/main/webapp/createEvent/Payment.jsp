<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Event - Step 4: Payment - MasterTicket</title>
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
        .form-label { display: block; margin-bottom: 0.5rem; color: rgba(255, 255, 255, 0.8); font-size: 0.9rem; }
        .form-input { width: 100%; padding: 0.8rem; background: rgba(255, 255, 255, 0.1); border: 1px solid rgba(255, 255, 255, 0.2); border-radius: 10px; color: #ffffff; font-size: 0.9rem; }
        .form-input:focus { outline: none; border-color: #8b5fbf; }
        .form-input[readonly] { background: rgba(255, 255, 255, 0.05); cursor: not-allowed; }
        .action-buttons { display: flex; justify-content: space-between; align-items: center; margin-top: 3rem; padding-top: 2rem; border-top: 1px solid rgba(255, 255, 255, 0.1); }
        .btn-secondary { background: rgba(255, 255, 255, 0.1); color: #ffffff; padding: 0.8rem 2rem; border: none; border-radius: 25px; cursor: pointer; font-size: 0.9rem; text-decoration: none; }
        .btn-secondary:hover { background: rgba(255, 255, 255, 0.2); }
        .btn-primary { background: linear-gradient(45deg, #8b5fbf, #a855f7); color: white; padding: 0.8rem 2rem; border: none; border-radius: 25px; cursor: pointer; font-size: 0.9rem; }
        .btn-primary:hover { transform: translateY(-2px); box-shadow: 0 10px 20px rgba(139, 95, 191, 0.3); }
        .alert { padding: 1rem; margin-bottom: 1.5rem; border-radius: 10px; background-color: rgba(220, 53, 69, 0.2); color: #ffffff; border-left: 4px solid #dc3545; }
        .alert-success { padding: 1rem; margin-bottom: 1.5rem; border-radius: 10px; background-color: rgba(16, 185, 129, 0.2); color: #ffffff; border-left: 4px solid #10b981; }
        .ticket-type { border: 1px solid rgba(255, 255, 255, 0.2); padding: 1rem; margin-bottom: 1rem; border-radius: 10px; position: relative; }
        .ticket-type-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem; }
        .remove-ticket { color: #ff6b6b; cursor: pointer; font-size: 0.9rem; }
        .remove-ticket:hover { text-decoration: underline; }
        .form-row { display: grid; grid-template-columns: repeat(3, 1fr); gap: 1rem; }
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
            <h1 class="page-title">Payment</h1>
            <p class="page-subtitle">Set up ticket availability and types</p>
           <c:if test="${not empty successMessage}">
    <div class="alert-success">${successMessage}</div>
    <script>
        console.log('Success message displayed: ${successMessage}');
        alert('${successMessage}');
        // Clear form inputs
        var form = document.getElementById('eventForm');
        if (form) {
            form.reset();
        } else {
            console.error('Form with ID "eventForm" not found');
        }

        var redirectUrl = '${pageContext.request.contextPath}/organizer-servlet';
        console.log('Redirecting to: ' + redirectUrl);
        setTimeout(function() {
            try {
                window.location.href = redirectUrl;
            } catch (e) {
                console.error('Redirect failed: ', e);
            }
        }, 2000);
    </script>
</c:if>
            <form action="${pageContext.request.contextPath}/organizer-servlet" method="post" id="eventForm">
                <input type="hidden" name="action" value="create"/>
                <div class="form-section">
                    <h3 class="section-title">🎫 Ticket Availability</h3>
                    <div class="form-group">
                        <label class="form-label">Total Tickets *</label>
                        <input type="number" class="form-input" name="totalTicketCount" id="totalTicketCount" value="${event.totalTicketCount}" min="1" readonly required>
                    </div>
                    <div class="form-group">
                        <h4 class="section-title">Ticket Types</h4>
                        <div id="ticketTypesContainer">
                            <div class="ticket-type" data-index="0">
                                <div class="ticket-type-header">
                                    <h5>Ticket Type 1</h5>
                                    <span class="remove-ticket" onclick="removeTicketType(this)">Remove</span>
                                </div>
                                <div class="form-row">
                                    <div class="form-group">
                                        <label class="form-label">Ticket Name *</label>
                                        <input type="text" class="form-input" name="ticketName[]" required>
                                    </div>
                                    <div class="form-group">
                                        <label class="form-label">Price (VND) *</label>
                                        <input type="number" class="form-input" name="ticketPrice[]" step="0.01" min="0" required>
                                    </div>
                                    <div class="form-group">
                                        <label class="form-label">Quantity *</label>
                                        <input type="number" class="form-input" name="ticketQuantity[]" min="1" required>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <button type="button" class="btn-primary" onclick="addTicketType()">Add Ticket Type</button>
                    </div>
                </div>
                <div class="action-buttons">
                    <a href="${pageContext.request.contextPath}/organizer-servlet?action=step3" class="btn-secondary">← Back</a>
                    <button type="submit" class="btn-primary">Create Event →</button>
                </div>
            </form>
        </div>
    </div>
    <script>
        let ticketTypeIndex = 1;

        function addTicketType() {
            const container = document.getElementById('ticketTypesContainer');
            const ticketTypeDiv = document.createElement('div');
            ticketTypeDiv.className = 'ticket-type';
            ticketTypeDiv.dataset.index = ticketTypeIndex;
            ticketTypeDiv.innerHTML = `
                <div class="ticket-type-header">
                    <h5>Ticket Type ${ticketTypeIndex + 1}</h5>
                    <span class="remove-ticket" onclick="removeTicketType(this)">Remove</span>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label">Ticket Name *</label>
                        <input type="text" class="form-input" name="ticketName[]" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Price (VND) *</label>
                        <input type="number" class="form-input" name="ticketPrice[]" step="0.01" min="0" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Quantity *</label>
                        <input type="number" class="form-input" name="ticketQuantity[]" min="1" required>
                    </div>
                </div>
            `;
            container.appendChild(ticketTypeDiv);
            ticketTypeIndex++;
            renumberTicketTypes();
            attachInputListeners();
            updateTotalTickets();
        }

        function removeTicketType(element) {
            if (document.querySelectorAll('.ticket-type').length > 1) {
                element.closest('.ticket-type').remove();
                renumberTicketTypes();
                updateTotalTickets();
            } else {
                alert('At least one ticket type is required.');
            }
        }

        function renumberTicketTypes() {
            const ticketTypes = document.querySelectorAll('.ticket-type');
            ticketTypes.forEach((ticketType, index) => {
                const header = ticketType.querySelector('.ticket-type-header h5');
                header.textContent = `Ticket Type ${index + 1}`;
                ticketType.dataset.index = index;
            });
        }

        function updateTotalTickets() {
            const quantities = document.querySelectorAll('input[name="ticketQuantity[]"]');
            let total = 0;
            quantities.forEach(input => {
                const value = parseInt(input.value) || 0;
                total += value;
            });
            const totalField = document.getElementById('totalTicketCount');
            totalField.value = total;
            totalField.dispatchEvent(new Event('change'));
        }

        function attachInputListeners() {
            const numberInputs = document.querySelectorAll('input[type="number"]');
            const textInputs = document.querySelectorAll('input[name="ticketName[]"]');

            numberInputs.forEach(input => {
                input.removeEventListener('input', handleNumberInput);
                input.removeEventListener('change', handleNumberChange);
                input.addEventListener('input', handleNumberInput);
                input.addEventListener('change', handleNumberChange);
            });

            textInputs.forEach(input => {
                input.removeEventListener('input', validateTicketName);
                input.addEventListener('input', validateTicketName);
            });
        }

        function handleNumberInput(e) {
            const input = e.target;
            if (input.name.includes('Price')) {
                input.value = input.value.replace(/[^0-9.]/g, '');
                const parts = input.value.split('.');
                if (parts.length > 2) {
                    input.value = parts[0] + '.' + parts.slice(1).join('');
                }
            } else {
                input.value = input.value.replace(/[^0-9]/g, '');
            }
            if (input.name.includes('ticketQuantity')) {
                updateTotalTickets();
            }
        }

        function handleNumberChange(e) {
            const input = e.target;
            const value = parseFloat(input.value) || 0;
            if (input.name.includes('Price') && value < 0) {
                input.value = 0;
            } else if (input.name.includes('Quantity') && value < 1) {
                input.value = 1;
            }
            if (input.name.includes('ticketQuantity')) {
                updateTotalTickets();
            }
        }

        function validateTicketName(e) {
            const input = e.target;
            const value = input.value.trim();
            const names = document.querySelectorAll('input[name="ticketName[]"]');
            let hasDuplicate = false;
            names.forEach((otherInput, index) => {
                if (otherInput !== input && otherInput.value.trim() === value && value !== '') {
                    hasDuplicate = true;
                }
            });
            if (hasDuplicate) {
                input.setCustomValidity('Ticket names must be unique.');
                input.reportValidity();
            } else {
                input.setCustomValidity('');
            }
        }

        function validateForm(e) {
            const totalTicketCount = parseInt(document.getElementById('totalTicketCount').value) || 0;
            const quantities = document.querySelectorAll('input[name="ticketQuantity[]"]');
            const prices = document.querySelectorAll('input[name="ticketPrice[]"]');
            const names = document.querySelectorAll('input[name="ticketName[]"]');
            let totalQuantity = 0;

            quantities.forEach(input => {
                const value = parseInt(input.value) || 0;
                totalQuantity += value;
            });

            console.log('Form Validation Debug:');
            console.log('Total Ticket Count:', totalTicketCount);
            console.log('Total Quantity:', totalQuantity);

            if (totalQuantity !== totalTicketCount) {
                console.error('Validation failed: Total quantity (' + totalQuantity + ') does not match totalTicketCount (' + totalTicketCount + ')');
                alert('Sum of ticket quantities (' + totalQuantity + ') must equal the total ticket count (' + totalTicketCount + ').');
                e.preventDefault();
                return false;
            }

            if (totalQuantity <= 0) {
                console.error('Validation failed: Total quantity must be positive');
                alert('Total ticket quantity must be positive.');
                e.preventDefault();
                return false;
            }

            for (let i = 0; i < quantities.length; i++) {
                const quantity = parseInt(quantities[i].value) || 0;
                if (quantity <= 0) {
                    console.error('Validation failed: Invalid quantity at index', i, ':', quantity);
                    alert('All ticket quantities must be positive numbers.');
                    e.preventDefault();
                    return false;
                }
            }

            for (let i = 0; i < prices.length; i++) {
                const priceValue = parseFloat(prices[i].value);
                if (isNaN(priceValue) || priceValue < 0) {
                    console.error('Validation failed: Invalid price at index', i, ':', priceValue);
                    alert('Ticket prices cannot be negative and must be valid numbers.');
                    e.preventDefault();
                    return false;
                }
            }

            for (let i = 0; i < names.length; i++) {
                const nameValue = names[i].value.trim();
                if (!nameValue) {
                    console.error('Validation failed: Empty ticket name at index', i);
                    alert('All ticket names must be filled in.');
                    e.preventDefault();
                    return false;
                }
                for (let j = i + 1; j < names.length; j++) {
                    if (nameValue === names[j].value.trim()) {
                        console.error('Validation failed: Duplicate ticket name:', nameValue);
                        alert('Ticket names must be unique. Found duplicate: "' + nameValue + '"');
                        e.preventDefault();
                        return false;
                    }
                }
            }

            if (quantities.length === 0) {
                console.error('Validation failed: No ticket types found');
                alert('At least one ticket type is required.');
                e.preventDefault();
                return false;
            }

            console.log('Form validation passed successfully');
            return true;
        }

        document.addEventListener('DOMContentLoaded', function() {
            const totalField = document.getElementById('totalTicketCount');
            totalField.setAttribute('readonly', 'readonly');
            totalField.style.backgroundColor = 'rgba(255, 255, 255, 0.05)';
            totalField.style.cursor = 'not-allowed';

            const form = document.getElementById('eventForm');
            if (form) {
                form.addEventListener('submit', validateForm);
            }

            attachInputListeners();
            updateTotalTickets();

            const initialQuantityInput = document.querySelector('input[name="ticketQuantity[]"]');
            if (initialQuantityInput && !initialQuantityInput.value) {
                initialQuantityInput.value = 1;
                updateTotalTickets();
            }
        });
    </script>
</body>
</html>