<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
     <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <title>Create Event - MasterTicket</title>
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

        .navbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 0;
            border-bottom: 1px solid rgba(255,255,255,0.1);
            margin-bottom: 30px;
        }

        .navbar .brand {
            font-size: 24px;
            font-weight: bold;
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
            transition: opacity 0.3s;
        }

        .navbar .nav-links a:hover {
            opacity: 1;
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
        }

        .btn-primary {
            background: #4CAF50;
            color: white;
        }

        .btn-primary:hover {
            background: #45a049;
        }

        .btn-secondary {
            background: rgba(255,255,255,0.2);
            color: rgb(192, 177, 177);
            border: 1px solid rgba(255,255,255,0.3);
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
            transition: background 0.3s;
        }

        .sidebar .menu a:hover,
        .sidebar .menu a.active {
            background: rgba(204, 185, 185, 0.1);
        }

        .main-content {
            margin-left: 270px;
            padding: 20px;
        }

        .progress-bar {
            display: flex;
            justify-content: center;
            margin-bottom: 30px;
        }

        .progress-step {
            display: flex;
            align-items: center;
            gap: 10px;
            margin: 0 20px;
        }

        .step-number {
            width: 30px;
            height: 30px;
            border-radius: 50%;
            background: rgba(255,255,255,0.3);
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
        }

        .step-number.active {
            background: #4CAF50;
        }

        .form-container {
            background: rgba(255,255,255,0.1);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 20px;
        }

        .form-row {
            display: flex;
            gap: 20px;
            margin-bottom: 20px;
        }

        .form-group {
            flex: 1;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
        }

        .color-select {
            background-color: #0d0e0d;
        }

        .form-control {
            width: 100%;
            padding: 12px;
            border: 1px solid rgba(26, 24, 24, 0.3);
            border-radius: 8px;
            background: rgba(12, 12, 12, 0.1);
            color: #d8cfcf;
            font-size: 14px;
        }

        .form-control::placeholder {
            color: rgba(255,255,255,0.6);
        }

        .form-control:focus {
            outline: none;
            border-color: #0d0e0d;
            box-shadow: 0 0 10px rgba(19, 20, 19, 0.3);
        }

        textarea.form-control {
            min-height: 120px;
            resize: vertical;
        }

        .image-upload-area {
            border: 2px dashed rgba(255,255,255,0.3);
            border-radius: 10px;
            padding: 40px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s;
            margin-bottom: 20px;
        }

        .image-upload-area:hover {
            border-color: #4CAF50;
            background: rgba(76, 175, 80, 0.1);
        }

        .image-upload-area .upload-icon {
            font-size: 48px;
            color: rgba(255,255,255,0.5);
            margin-bottom: 10px;
        }

        .radio-group {
            display: flex;
            gap: 20px;
            margin-bottom: 20px;
        }

        .radio-item {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .radio-item input[type="radio"] {
            accent-color: #4CAF50;
        }

        .checkbox-group {
            margin-bottom: 20px;
        }

        .checkbox-item {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 10px;
        }

        .checkbox-item input[type="checkbox"] {
            accent-color: #141614;
        }

        .promotion-section {
            background: rgba(255,255,255,0.05);
            border-radius: 10px;
            padding: 20px;
            margin-top: 20px;
        }

        .promotion-header {
            display: flex;
            justify-content: space-between; /* Sửa lỗi từ "between" thành "space-between" */
            align-items: center;
            margin-bottom: 20px;
        }

        .form-actions {
            display: flex;
            justify-content: space-between;
            margin-top: 30px;
        }

        .alert {
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
        }

        .alert-success {
            background: rgba(76, 175, 80, 0.2);
            border: 1px solid #4CAF50;
            color: #4CAF50;
        }

        .alert-danger {
            background: rgba(244, 67, 54, 0.2);
            border: 1px solid #f44336;
            color: #f44336;
        }

        .alert-warning {
            background: rgba(255, 193, 7, 0.2);
            border: 1px solid #ffc107;
            color: #ffc107;
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
            }
        }
    </style>
</head>
<body>
    <!-- Sidebar -->
    <div class="sidebar">
        <div class="brand">🎟️ MasterTicket</div>
        <ul class="menu">
            <li><a href="#" class="active">📅 Sự kiện của tôi</a></li>
            <li><a href="#">📊 Quản lí báo cáo</a></li>
            <li><a href="#"> 📋 Điều khoản</a></li>
        </ul>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <!-- Navigation -->
        <nav class="navbar">
            <div class="nav-links">
                <a href="#">Trang chủ</a>
                <a href="#">Các sự kiện hot</a>
                <a href="#">Săn voucher giảm giá</a>
                <a href="#" class="active">Create Event</a>
                <a href="#">Hỗ trợ</a>
            </div>
            <div class="user-info">
 
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-logout">Logout</a>
            </div>
        </nav>

        <!-- Progress Bar -->
        <div class="progress-bar">
            <div class="progress-step">
                <div class="step-number active">1</div>
                <span>Thông tin sự kiện</span>
            </div>
            <div class="progress-step">
                <div class="step-number">2</div>
                <span>Thời gian & Thể loại</span>
            </div>
            <div class="progress-step">
                <div class="step-number">3</div>
                <span>Cài đặt</span>
            </div>
            <div class="progress-step">
                <div class="step-number">4</div>
                <span>Thanh toán</span>
            </div>
        </div>

        <!-- Event Creation Form -->
        <form action="${pageContext.request.contextPath}/createEvent" method="post" enctype="multipart/form-data">
            <div class="form-container">
                <!-- Upload hình ảnh Section -->
                <h3 style="margin-bottom: 20px; color: #1a1818;">📷 Upload hình ảnh</h3>
                <div class="form-row">
                    <div class="form-group">
                        <label>Logo event</label>
                        <div class="image-upload-area" onclick="document.getElementById('logoUpload').click()">
                            <div class="upload-icon">📷</div>
                            <div>(720x480)</div>
                            <div style="margin-top: 10px; font-size: 12px; opacity: 0.7;">Click to upload logo</div>
                        </div>
                        <input type="file" id="logoUpload" name="logoImage" accept="image/*" style="display: none;">
                    </div>
                    <div class="form-group">
                        <label>Background</label>
                        <div class="image-upload-area" onclick="document.getElementById('backgroundUpload').click()">
                            <div class="upload-icon">🖼️</div>
                            <div>(1280x720)</div>
                            <div style="margin-top: 10px; font-size: 12px; opacity: 0.7;">Click to upload background</div>
                        </div>
                        <input type="file" id="backgroundUpload" name="backgroundImage" accept="image/*" style="display: none;">
                    </div>
                </div>

                <!-- Event Name -->
                <div class="form-group">
                    <label for="eventName">Name event *</label>
                    <input type="text" id="eventName" name="eventName" class="form-control" 
                           placeholder="Enter event name">
                </div>

                <!-- Event Address Selection -->
                <div class="form-group">
                    <label>Event address</label>
                    <div class="radio-group">
                        <div class="radio-item">
                            <input type="radio" id="offline" name="eventType" value="offline" 
                                   ${param.eventType == 'offline' || empty param.eventType ? 'checked' : ''}>
                            <label for="offline">🏢 Offline events</label>
                        </div>
                        <div class="radio-item">
                            <input type="radio" id="online" name="eventType" value="online"
                                   ${param.eventType == 'online' ? 'checked' : ''}>
                            <label for="online">🌐 Online events</label>
                        </div>
                    </div>
                </div>

                <!-- Location Details -->
                <div id="locationDetails">
                    <div class="form-group">
                        <label for="locationName">Name location</label>
                        <input type="text" id="locationName" name="locationName" class="form-control" 
                               placeholder="Enter location name">
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="province">Province/City</label>
                            <select id="province" name="province" class="form-control">
                                <option class="color-select" value="">Select Province/City</option>
                                <option class="color-select" value="hanoi" ${param.province == 'hanoi' ? 'selected' : ''}>Hà Nội</option>
                                <option class="color-select" value="hcm" ${param.province == 'hcm' ? 'selected' : ''}>TP. Hồ Chí Minh</option>
                                <option class="color-select" value="danang" ${param.province == 'danang' ? 'selected' : ''}>Đà Nẵng</option>
                                <option class="color-select" value="haiphong" ${param.province == 'haiphong' ? 'selected' : ''}>Hải Phòng</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="district">District</label>
                            <select id="district" name="district" class="form-control">
                                <option value="">Select District</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="ward">Ward/Commune</label>
                            <select id="ward" name="ward" class="form-control">
                                <option value="">Select Ward/Commune</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="streetNumber">House/Street number</label>
                            <input type="text" id="streetNumber" name="streetNumber" class="form-control" 
                                   placeholder="Enter house/street number">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="fullAddress">Address</label>
                        <input type="text" id="fullAddress" name="fullAddress" class="form-control" 
                               placeholder="Complete address will be auto-generated" readonly>
                    </div>
                </div>

                <!-- Event Type/Genre -->
                <div class="form-group">
                    <label for="eventGenre">Type of Event</label>
                    <select id="eventGenre" name="genreId" class="form-control" required>
                        <option value="">Select Event Type</option>
                        <c:forEach var="genre" items="${genres}">
                            <option value="${genre.genreID}" ${param.genreId == genre.genreID ? 'selected' : ''}>
                                ${genre.genreName}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <!-- Event Information -->
                <div class="form-group">
                    <label for="eventInfo">Event Information</label>
                    <textarea id="eventInfo" name="eventInfo" class="form-control" 
                              placeholder="Describe your event..."></textarea>
                </div>

                <!-- Event Time -->
                <div class="form-row">
                    <div class="form-group">
                        <label for="startTime">Start Time *</label>
                        <input type="datetime-local" id="startTime" name="startTime" class="form-control" 
                               required value="${param.startTime}">
                    </div>
                    <div class="form-group">
                        <label for="endTime">End Time *</label>
                        <input type="datetime-local" id="endTime" name="endTime" class="form-control" 
                               required value="${param.endTime}">
                    </div>
                </div>

                <!-- Seating Options -->
                <div class="checkbox-group">
                    <div class="checkbox-item">
                        <input type="checkbox" id="hasSeat" name="hasSeat" value="true"
                               ${param.hasSeat == 'true' ? 'checked' : ''}>
                        <label for="hasSeat">This event has assigned seating</label>
                    </div>
                </div>
                <!-- Seating Plan Upload (show if hasSeat checked) -->
                <div class="form-group" id="seatingPlanUploadCheckbox" style="display: ${param.hasSeat == 'true' ? 'block' : 'none'};">
                    <label for="seatingPlanImageCheckbox">Sơ đồ khán phòng (nếu có ghế ngồi)</label>
                    <div class="image-upload-area" onclick="document.getElementById('seatingPlanImageCheckbox').click()">
                        <div class="upload-icon">🗺️</div>
                        <div>(Tải lên ảnh sơ đồ khán phòng)</div>
                        <div style="margin-top: 10px; font-size: 12px; opacity: 0.7;">Click để upload sơ đồ</div>
                    </div>
                    <input type="file" id="seatingPlanImageCheckbox" name="seatingPlanImageCheckbox" accept="image/*" style="display: none;">
                </div>

                <!-- Total Tickets -->
                <div class="form-group">
                    <label for="totalTickets">Total Tickets Available</label>
                    <input type="number" id="totalTickets" name="totalTickets" class="form-control" 
                           min="1" placeholder="Enter total number of tickets" value="${param.totalTickets}">
                </div>

                <!-- Organizer Information -->
                <div class="form-row">
                    <div class="form-group">
                        <label>Logo Sponsor</label>
                        <div class="image-upload-area" onclick="document.getElementById('sponsorUpload').click()">
                            <div class="upload-icon">🏢</div>
                            <div>(374x298)</div>
                        </div>
                        <input type="file" id="sponsorUpload" name="sponsorImage" accept="image/*" style="display: none;">
                    </div>
                    <div class="form-group">
                        <label for="organizerName">Name of the Organizing Committee</label>
                        <input type="text" id="organizerName" name="organizerName" class="form-control" 
                               placeholder="Enter organizer name">
                        
                        <label for="organizerInfo" style="margin-top: 15px;">Organizing Committee Information</label>
                        <textarea id="organizerInfo" name="organizerInfo" class="form-control" 
                                  placeholder="Information about the organizing committee..."></textarea>
                    </div>
                </div>

                <!-- Promotion Section -->
                <div class="promotion-section">
                    <div class="promotion-header">
                        <h3>🎁 Promotion Settings</h3>
                        <div class="checkbox-item">
                            <input type="checkbox" id="enablePromotion" name="enablePromotion" value="true"
                                   ${param.enablePromotion == 'true' ? 'checked' : ''}>
                            <label for="enablePromotion">Enable Promotion for this event</label>
                        </div>
                    </div>

                    <div id="promotionDetails" style="display: ${param.enablePromotion == 'true' ? 'block' : 'none'};">
                        <div class="form-group">
                            <label for="promotionName">Promotion Name</label>
                            <input type="text" id="promotionName" name="promotionName" class="form-control" 
                                   placeholder="Enter promotion name">
                        </div>

                        <div class="form-group">
                            <label for="promotionCode">Promotion Code</label>
                            <input type="text" id="promotionCode" name="promotionCode" class="form-control" 
                                   placeholder="Enter promotion code (e.g., SAVE20)">
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="promotionStart">Promotion Start Time</label>
                                <input type="datetime-local" id="promotionStart" name="promotionStart" class="form-control" 
                                       value="${param.promotionStart}">
                            </div>
                            <div class="form-group">
                                <label for="promotionEnd">Promotion End Time</label>
                                <input type="datetime-local" id="promotionEnd" name="promotionEnd" class="form-control" 
                                       value="${param.promotionEnd}">
                                <small style="color: #ffc107; display: block; margin-top: 5px;">
                                    ⚠️ If no end time is specified, promotion will run indefinitely until manually stopped
                                </small>
                            </div>
                        </div>

                        <div class="alert alert-warning">
                            📌 <strong>Promotion End Time Handling:</strong><br>
                            • If you don't set an end time, the promotion will continue indefinitely<br>
                            • You can always update or stop the promotion later in the event management section<br>
                            • Consider setting a reasonable end time to create urgency for customers
                        </div>
                    </div>
                </div>
            </div>

            <!-- Form Actions -->
           <div class="form-actions">
    <button type="button" class="btn btn-secondary" onclick="history.back()">← Previous</button>
    <button type="button" class="btn btn-primary" onclick="window.location.href='TimeAndType.jsp'">Next Step →</button>
</div>
        </form>
    </div>
    
    <script>
        // Toggle promotion details
        document.getElementById('enablePromotion').addEventListener('change', function() {
            const promotionDetails = document.getElementById('promotionDetails');
            promotionDetails.style.display = this.checked ? 'block' : 'none';
        });

        // Toggle location details based on event type
        document.querySelectorAll('input[name="eventType"]').forEach(radio => {
            radio.addEventListener('change', function() {
                const locationDetails = document.getElementById('locationDetails');
                locationDetails.style.display = this.value === 'offline' ? 'block' : 'none';
            });
        });

        // Toggle seating plan upload based on assigned seating checkbox
        document.getElementById('hasSeat').addEventListener('change', function() {
            const seatingPlanDiv = document.getElementById('seatingPlanUploadCheckbox');
            seatingPlanDiv.style.display = this.checked ? 'block' : 'none';
        });

        // Setup image preview for seating plan (checkbox)
        setupImagePreview('seatingPlanImageCheckbox');

        // Auto-generate full address
        function updateFullAddress() {
            const province = document.getElementById('province').selectedOptions[0]?.text || '';
            const district = document.getElementById('district').selectedOptions[0]?.text || '';
            const ward = document.getElementById('ward').selectedOptions[0]?.text || '';
            const streetNumber = document.getElementById('streetNumber').value;
            const locationName = document.getElementById('locationName').value;

            let fullAddress = '';
            if (locationName) fullAddress += locationName + ', ';
            if (streetNumber) fullAddress += streetNumber + ', ';
            if (ward && ward !== 'Select Ward/Commune') fullAddress += ward + ', ';
            if (district && district !== 'Select District') fullAddress += district + ', ';
            if (province && province !== 'Select Province/City') fullAddress += province;

            document.getElementById('fullAddress').value = fullAddress.replace(/,\s*$/, '');
        }

        // Add event listeners for address fields
        ['province', 'district', 'ward', 'streetNumber', 'locationName'].forEach(id => {
            document.getElementById(id).addEventListener('change', updateFullAddress);
            document.getElementById(id).addEventListener('input', updateFullAddress);
        });

        // Image upload preview với tên file
        function setupImagePreview(inputId) {
            document.getElementById(inputId).addEventListener('change', function(e) {
                const file = e.target.files[0];
                const uploadArea = this.parentNode.querySelector('.image-upload-area');
                
                if (file) {
                    const reader = new FileReader();
                    reader.onload = function(e) {
                        uploadArea.style.backgroundImage = `url(${e.target.result})`;
                        uploadArea.style.backgroundSize = 'cover';
                        uploadArea.style.backgroundPosition = 'center';
                        uploadArea.innerHTML = `<div style="background: rgba(0,0,0,0.7); padding: 10px; border-radius: 5px; color: white;">
                                                ${file.name}<br>
                                                <small>Click to change</small>
                                              </div>`;
                    };
                    reader.readAsDataURL(file);
                } else {
                    // Reset to original state
                    uploadArea.style.backgroundImage = 'none';
                    const icon = inputId.includes('logo') ? '📷' : 
                                inputId.includes('background') ? '🖼️' : '🏢';
                    const size = inputId.includes('logo') ? '(720x480)' : 
                                inputId.includes('background') ? '(1280x720)' : '(374x298)';
                    uploadArea.innerHTML = `<div class="upload-icon">${icon}</div>
                                          <div>${size}</div>
                                          <div style="margin-top: 10px; font-size: 12px; opacity: 0.7;">Click to upload</div>`;
                }
            });
        }

        // Setup image previews
        setupImagePreview('logoUpload');
        setupImagePreview('backgroundUpload');
        setupImagePreview('sponsorUpload');
        setupImagePreview('seatingPlanImage');

        // Form validation
        document.querySelector('form').addEventListener('submit', function(e) {
            const startTime = new Date(document.getElementById('startTime').value);
            const endTime = new Date(document.getElementById('endTime').value);
            
            if (startTime >= endTime) {
                e.preventDefault();
                alert('End time must be after start time!');
                return false;
            }

            // Validate promotion times if promotion is enabled
            if (document.getElementById('enablePromotion').checked) {
                const promotionStart = document.getElementById('promotionStart').value;
                const promotionEnd = document.getElementById('promotionEnd').value;
                
                if (promotionStart && promotionEnd) {
                    const promStartTime = new Date(promotionStart);
                    const promEndTime = new Date(promotionEnd);
                    
                    if (promStartTime >= promEndTime) {
                        e.preventDefault();
                        alert('Promotion end time must be after promotion start time!');
                        return false;
                    }
                }
            }
        });

        // Initialize page
        document.addEventListener('DOMContentLoaded', function() {
            // Set default promotion start time to now
            const now = new Date();
            now.setMinutes(now.getMinutes() - now.getTimezoneOffset());
            document.getElementById('promotionStart').value = now.toISOString().slice(0, 16);
            
            // Update full address on page load
            updateFullAddress();
        });
    </script>
</body>
</html>