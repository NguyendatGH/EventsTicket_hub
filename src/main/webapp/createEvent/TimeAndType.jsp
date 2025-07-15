<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Event - Time & Type</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 50%, #0f0f23 100%);
            color: #ffffff;
            min-height: 100vh;
            overflow-x: hidden;
        }

        .header {
            background: rgba(26, 26, 46, 0.9);
            backdrop-filter: blur(20px);
            padding: 1rem 2rem;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .header-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
            max-width: 1200px;
            margin: 0 auto;
        }

        .logo {
            font-size: 1.5rem;
            font-weight: bold;
            color: #8b5fbf;
        }

        .nav-links {
            display: flex;
            gap: 2rem;
            font-size: 0.9rem;
        }

        .nav-links a {
            color: #ffffff;
            text-decoration: none;
            opacity: 0.7;
            transition: opacity 0.3s ease;
        }

        .nav-links a:hover {
            opacity: 1;
        }
        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            transition: all 0.3s;
        }
        .Logout-btn {
            background: linear-gradient(45deg, #8b5fbf, #a855f7);
            color: white;
            padding: 0.5rem 1.5rem;
            border: none;
            border-radius: 25px;
            font-size: 0.9rem;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .Logout-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(139, 95, 191, 0.3);
        }

        .progress-bar {
            background: rgba(26, 26, 46, 0.9);
            backdrop-filter: blur(20px);
            padding: 1rem 2rem;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }

        .progress-content {
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            align-items: center;
            gap: 2rem;
        }

        .progress-step {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 0.9rem;
        }

        .step-number {
            width: 30px;
            height: 30px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            font-size: 0.8rem;
        }

        .step-number.completed {
            background: #10b981;
            color: white;
        }

        .step-number.active {
            background: #8b5fbf;
            color: white;
        }

        .step-number.inactive {
            background: rgba(255, 255, 255, 0.1);
            color: rgba(255, 255, 255, 0.5);
        }

        .step-connector {
            width: 40px;
            height: 2px;
            background: rgba(255, 255, 255, 0.1);
        }

        .step-connector.completed {
            background: #10b981;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 2rem;
            display: grid;
            grid-template-columns: 250px 1fr;
            gap: 2rem;
        }

        .sidebar {
            background: rgba(26, 26, 46, 0.6);
            backdrop-filter: blur(20px);
            border-radius: 20px;
            padding: 2rem;
            height: fit-content;
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        .sidebar h3 {
            color: #8b5fbf;
            margin-bottom: 1.5rem;
            font-size: 1.1rem;
        }

        .sidebar-menu {
            list-style: none;
        }

        .sidebar-menu li {
            margin-bottom: 1rem;
        }

        .sidebar-menu a {
            color: rgba(255, 255, 255, 0.7);
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.5rem;
            border-radius: 10px;
            transition: all 0.3s ease;
        }

        .sidebar-menu a:hover {
            background: rgba(139, 95, 191, 0.1);
            color: #8b5fbf;
        }

        .sidebar-menu a.active {
            background: rgba(139, 95, 191, 0.2);
            color: #8b5fbf;
        }

        .main-content {
            background: rgba(26, 26, 46, 0.6);
            backdrop-filter: blur(20px);
            border-radius: 20px;
            padding: 2rem;
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        .page-title {
            font-size: 1.8rem;
            margin-bottom: 0.5rem;
            color: #ffffff;
        }

        .page-subtitle {
            color: rgba(255, 255, 255, 0.6);
            margin-bottom: 2rem;
        }

        .form-section {
            margin-bottom: 2rem;
        }

        .section-title {
            font-size: 1.2rem;
            margin-bottom: 1rem;
            color: #8b5fbf;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
        }

        .form-label {
            display: block;
            margin-bottom: 0.5rem;
            color: rgba(255, 255, 255, 0.8);
            font-size: 0.9rem;
        }

        .form-input {
            width: 100%;
            padding: 0.8rem;
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 10px;
            color: #ffffff;
            font-size: 0.9rem;
            transition: all 0.3s ease;
        }

        .form-input:focus {
            outline: none;
            border-color: #8b5fbf;
            box-shadow: 0 0 0 3px rgba(139, 95, 191, 0.1);
        }

        .form-input::placeholder {
            color: rgba(255, 255, 255, 0.4);
        }

        .datetime-input {
            position: relative;
        }

        .datetime-input input[type="datetime-local"] {
            color-scheme: dark;
        }

        .event-type-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
        }

        .event-type-card {
            background: rgba(255, 255, 255, 0.05);
            border: 2px solid rgba(255, 255, 255, 0.1);
            border-radius: 15px;
            padding: 1.5rem;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
            position: relative;
        }

        .event-type-card:hover {
            border-color: #8b5fbf;
            background: rgba(139, 95, 191, 0.1);
            transform: translateY(-2px);
        }

        .event-type-card.selected {
            border-color: #8b5fbf;
            background: rgba(139, 95, 191, 0.2);
        }

        .event-type-icon {
            font-size: 2rem;
            margin-bottom: 0.5rem;
        }

        .event-type-title {
            font-size: 1rem;
            margin-bottom: 0.3rem;
            color: #ffffff;
        }

        .event-type-desc {
            font-size: 0.8rem;
            color: rgba(255, 255, 255, 0.6);
        }

        .ticket-type-section {
            background: rgba(255, 255, 255, 0.05);
            border-radius: 15px;
            padding: 1.5rem;
            margin-bottom: 2rem;
        }

        .ticket-type-options {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1rem;
        }

        .ticket-option {
            background: rgba(255, 255, 255, 0.05);
            border: 2px solid rgba(255, 255, 255, 0.1);
            border-radius: 10px;
            padding: 1rem;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .ticket-option:hover {
            border-color: #8b5fbf;
            background: rgba(139, 95, 191, 0.1);
        }

        .ticket-option.selected {
            border-color: #8b5fbf;
            background: rgba(139, 95, 191, 0.2);
        }

        .ticket-option-title {
            font-size: 1rem;
            margin-bottom: 0.5rem;
            color: #ffffff;
        }

        .ticket-option-desc {
            font-size: 0.8rem;
            color: rgba(255, 255, 255, 0.6);
        }

        .time-zone-selector {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-top: 0.5rem;
        }

        .timezone-display {
            background: rgba(139, 95, 191, 0.2);
            padding: 0.3rem 0.8rem;
            border-radius: 20px;
            font-size: 0.8rem;
            color: #8b5fbf;
        }

        .duration-inputs {
            display: flex;
            gap: 1rem;
            align-items: center;
        }

        .duration-input {
            flex: 1;
        }

        .duration-label {
            color: rgba(255, 255, 255, 0.6);
            font-size: 0.9rem;
        }

        .action-buttons {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 3rem;
            padding-top: 2rem;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
        }

        .btn-secondary {
            background: rgba(255, 255, 255, 0.1);
            color: #ffffff;
            padding: 0.8rem 2rem;
            border: none;
            border-radius: 25px;
            cursor: pointer;
            transition: all 0.3s ease;
            font-size: 0.9rem;
        }

        .btn-secondary:hover {
            background: rgba(255, 255, 255, 0.2);
        }

        .btn-primary {
            background: linear-gradient(45deg, #8b5fbf, #a855f7);
            color: white;
            padding: 0.8rem 2rem;
            border: none;
            border-radius: 25px;
            cursor: pointer;
            transition: all 0.3s ease;
            font-size: 0.9rem;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(139, 95, 191, 0.3);
        }
    </style>
</head>
<body>
    <!-- Header -->
    <div class="header">
        <div class="header-content">
            <div class="logo">MasterTicket</div>
            <div class="nav-links">
                <a href="#">Home</a>
                <a href="#">Shows</a>
                <a href="#">Offers & Discount</a>
                <a href="#">Create Event</a>
            </div>
           
            <a href="${pageContext.request.contextPath}/logout" class="btn Logout-btn">Logout</a>
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
                <li><a href="#" class="active">📅 My event</a></li>
                <li><a href="#">📊 Manage Report</a></li>
                <li><a href="#">⚙️ Rules</a></li>
            </ul>
        </div>

        <!-- Main Content -->
        <div class="main-content">
            <h1 class="page-title">Time & Type</h1>
            <p class="page-subtitle">Set up your event schedule and choose the event type</p>

            <!-- Event Schedule Section -->
            <div class="form-section">
                <h3 class="section-title">📅 Event Schedule</h3>
                
                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label">Start Date & Time</label>
                        <div class="datetime-input">
                            <input type="datetime-local" class="form-input" value="2025-07-15T10:00">
                        </div>
                        <div class="time-zone-selector">
                            <span class="timezone-display">GMT+7 (Vietnam)</span>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">End Date & Time</label>
                        <div class="datetime-input">
                            <input type="datetime-local" class="form-input" value="2025-07-15T18:00">
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
                            <input type="number" class="form-input" placeholder="8" value="8">
                            <div class="duration-label">Hours</div>
                        </div>
                        <div class="duration-input">
                            <input type="number" class="form-input" placeholder="0" value="0">
                            <div class="duration-label">Minutes</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Event Type Section -->
            <div class="form-section">
                <h3 class="section-title">🎭 Event Type</h3>
                
                <div class="event-type-grid">
                    <div class="event-type-card selected">
                        <div class="event-type-icon">🎵</div>
                        <div class="event-type-title">Concert</div>
                        <div class="event-type-desc">Live music performances</div>
                    </div>
                    
                    <div class="event-type-card">
                        <div class="event-type-icon">🎪</div>
                        <div class="event-type-title">Festival</div>
                        <div class="event-type-desc">Multi-day cultural events</div>
                    </div>
                    
                    <div class="event-type-card">
                        <div class="event-type-icon">🎭</div>
                        <div class="event-type-title">Theater</div>
                        <div class="event-type-desc">Drama & performing arts</div>
                    </div>
                    
                    <div class="event-type-card">
                        <div class="event-type-icon">⚽</div>
                        <div class="event-type-title">Sports</div>
                        <div class="event-type-desc">Athletic competitions</div>
                    </div>
                    
                    <div class="event-type-card">
                        <div class="event-type-icon">💼</div>
                        <div class="event-type-title">Conference</div>
                        <div class="event-type-desc">Business & networking</div>
                    </div>
                    
                    <div class="event-type-card">
                        <div class="event-type-icon">🎨</div>
                        <div class="event-type-title">Exhibition</div>
                        <div class="event-type-desc">Art & cultural displays</div>
                    </div>
                </div>
            </div>

            <!-- Ticket Type Section -->
            <div class="form-section">
                <h3 class="section-title">🎫 Ticket Type</h3>
                
                <div class="ticket-type-section">
                    <div class="ticket-type-options">
                        <div class="ticket-option selected">
                            <div class="ticket-option-title">💰 Paid Event</div>
                            <div class="ticket-option-desc">Sell tickets with different pricing tiers</div>
                        </div>
                        
                        <div class="ticket-option">
                            <div class="ticket-option-title">🆓 Free Event</div>
                            <div class="ticket-option-desc">Free admission with registration</div>
                        </div>
                        
                        <div class="ticket-option">
                            <div class="ticket-option-title">🎁 Invitation Only</div>
                            <div class="ticket-option-desc">Private event with invite codes</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Event Frequency Section -->
            <div class="form-section">
                <h3 class="section-title">🔄 Event Frequency</h3>
                
                <div class="form-group">
                    <label class="form-label">Event Type</label>
                    <select class="form-input">
                        <option value="single">Single Event</option>
                        <option value="recurring">Recurring Event</option>
                        <option value="series">Event Series</option>
                    </select>
                </div>
            </div>

            <!-- Action Buttons -->
            <div class="action-buttons">
                <button class="btn-secondary">← Back</button>
                <button class="btn-primary">Continue →</button>
            </div>
        </div>
    </div>

    <script>
        // Event type selection
        document.querySelectorAll('.event-type-card').forEach(card => {
            card.addEventListener('click', function() {
                document.querySelectorAll('.event-type-card').forEach(c => c.classList.remove('selected'));
                this.classList.add('selected');
            });
        });

        // Ticket type selection
        document.querySelectorAll('.ticket-option').forEach(option => {
            option.addEventListener('click', function() {
                document.querySelectorAll('.ticket-option').forEach(o => o.classList.remove('selected'));
                this.classList.add('selected');
            });
        });

        // Auto-calculate duration when dates change
        function calculateDuration() {
            const startInput = document.querySelector('input[type="datetime-local"]:first-of-type');
            const endInput = document.querySelector('input[type="datetime-local"]:last-of-type');
            const hoursInput = document.querySelector('input[type="number"]:first-of-type');
            const minutesInput = document.querySelector('input[type="number"]:last-of-type');
            
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
            const startInput = document.querySelector('input[type="datetime-local"]:first-of-type');
            const endInput = document.querySelector('input[type="datetime-local"]:last-of-type');
            const hoursInput = document.querySelector('input[type="number"]:first-of-type');
            const minutesInput = document.querySelector('input[type="number"]:last-of-type');
            
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
    </script>
</body>
</html>