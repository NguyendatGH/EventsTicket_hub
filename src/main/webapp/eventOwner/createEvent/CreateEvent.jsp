
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

            .main-content {
                max-width: 800px;
                margin: 40px auto;
                padding: 30px;
                background: rgba(255, 255, 255, 0.1);
                backdrop-filter: blur(10px);
                border-radius: 15px;
                border: 1px solid rgba(255, 255, 255, 0.1);
            }

            h2 {
                color: #4CAF50;
                margin-bottom: 20px;
                font-size: 1.8rem;
                background: linear-gradient(45deg, #4CAF50, #45a049);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                background-clip: text;
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

            .step-number.active {
                background: #4CAF50;
                color: white;
                box-shadow: 0 0 15px rgba(139, 95, 191, 0.5);
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

            .form-group {
                margin-bottom: 20px;
            }

            .form-group label {
                display: block;
                margin-bottom: 8px;
                color: #fff;
                font-weight: 500;
            }

            .form-control {
                width: 100%;
                padding: 12px;
                border-radius: 8px;
                border: 1px solid rgba(255, 255, 255, 0.2);
                background: rgba(255, 255, 255, 0.1);
                color: #fff;
                font-size: 1rem;
                transition: all 0.3s;
            }

            .form-control:focus {
                outline: none;
                border-color: #4CAF50;
                box-shadow: 0 0 10px rgba(76, 175, 80, 0.3);
            }

            textarea.form-control {
                min-height: 120px;
                resize: vertical;
            }

            select.form-control {
                appearance: none;
                background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='16' height='16' fill='%23ffffff' viewBox='0 0 16 16'%3E%3Cpath d='M7.247 11.14 2.451 5.658C1.885 5.013 2.345 4 3.204 4h9.592a1 1 0 0 1 .753 1.659l-4.796 5.48a1 1 0 0 1-1.506 0z'/%3E%3C/svg%3E");
                background-repeat: no-repeat;
                background-position: right 12px center;
                background-size: 16px;
            }

            input[type="file"] {
                width: 100%;
                padding: 12px;
                border-radius: 8px;
                border: 1px dashed rgba(255, 255, 255, 0.3);
                background: rgba(255, 255, 255, 0.05);
                color: #fff;
            }

            input[type="file"]::file-selector-button {
                padding: 8px 16px;
                border-radius: 4px;
                border: none;
                background: #4CAF50;
                color: white;
                cursor: pointer;
                margin-right: 12px;
                transition: all 0.3s;
            }

            input[type="file"]::file-selector-button:hover {
                background: #45a049;
            }

            .form-actions {
                margin-top: 30px;
                display: flex;
                gap: 15px;
            }

            .btn {
                padding: 12px 24px;
                border: none;
                border-radius: 8px;
                cursor: pointer;
                font-size: 1rem;
                font-weight: 500;
                transition: all 0.3s;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                gap: 8px;
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
                background: rgba(255, 255, 255, 0.1);
                color: white;
                border: 1px solid rgba(255, 255, 255, 0.2);
            }

            .btn-secondary:hover {
                background: rgba(255, 255, 255, 0.2);
                transform: translateY(-2px);
            }

            .error-message {
                color: #ff6b6b;
                margin-bottom: 20px;
                padding: 12px;
                background: rgba(255, 107, 107, 0.1);
                border-radius: 8px;
                border: 1px solid #ff6b6b;
            }
            .select-css{
                background: gray;
            }
            .image-preview {
                max-width: 100%;
                max-height: 200px;
                margin-top: 10px;
                border-radius: 8px;
                display: none; /* Ẩn ban đầu */
                border: 1px solid rgba(255,255,255,0.2);
            }
            @media (max-width: 768px) {
                .main-content {
                    margin: 20px;
                    padding: 20px;
                }

                .progress-content {
                    flex-wrap: wrap;
                    gap: 1rem;
                }

                .step-connector {
                    display: none;
                }

                .form-row {
                    flex-direction: column;
                    gap: 15px;
                }

                .form-actions {
                    flex-direction: column;
                }

                .btn {
                    width: 100%;
                }
            }
        </style>
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
                <span>TicketInfo</span>
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
                <label  for="genreID">Event Genre *</label>
                <select id="genreID" name="genreID" class="form-control" required>
                    <option class="select-css" value="">Select a genre</option>
                    <c:forEach var="genre" items="${genres}">
                        <option class="select-css" value="${genre.genreID}" ${event.genreID eq genre.genreID ? 'selected' : ''}>${genre.genreName}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="form-group">
                <label for="description">Event Description</label>
                <textarea id="description" name="description" class="form-control">${event.description}</textarea>
            </div>
            <div class="form-group">
                <label for="imageURL">Event Image URL</label>
                <input type="url" id="imageURL" name="imageURL" class="form-control" 
                       placeholder="https://example.com/image.jpg" value="${event.imageURL}">
                <img id="imagePreview" class="image-preview" alt="Image preview" 
                     style="max-width: 100%; max-height: 200px; margin-top: 10px; display: none;">
            </div>
            <div class="form-actions">
                <button type="submit" class="btn btn-primary">Continue →</button>
                <a href="${pageContext.request.contextPath}/organizer-servlet" class="btn btn-secondary">❌ Cancel</a>
            </div>
        </form>
    </div>

    <script>
        document.getElementById('imageURL').addEventListener('input', function () {
            const url = this.value.trim();
            const preview = document.getElementById('imagePreview');

            if (url) {
                preview.src = url;
                preview.style.display = 'block';
                preview.onerror = function () {
                    preview.style.display = 'none';
                    alert('Không thể tải ảnh từ URL này. Vui lòng kiểm tra lại!');
                };
            } else {
                preview.style.display = 'none';
            }
        });

        // Hiển thị preview ngay nếu đã có URL (khi load lại trang)
        if (document.getElementById('imageURL').value) {
            document.getElementById('imagePreview').src = document.getElementById('imageURL').value;
            document.getElementById('imagePreview').style.display = 'block';
        }
    </script>
</body>
</html>