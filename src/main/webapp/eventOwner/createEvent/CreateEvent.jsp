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
                padding: 12px;
                margin-bottom: 20px;
                border-radius: 8px;
                background-color: #ff5252;
                color: #000;
                display: none; /* Hidden by default */
                border-left: 4px solid #ff0000;
                font-weight: bold;
            }

            .error-message.show {
                display: block;
            }

            .select-css {
                background: gray;
            }

            .image-preview {
                max-width: 100%;
                max-height: 200px;
                margin-top: 10px;
                border-radius: 8px;
                display: none;
                border: 1px solid rgba(255,255,255,0.2);
            }

            /* Removed toast-related styles as they are no longer needed */

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

                .form-actions {
                    flex-direction: column;
                }

                .btn {
                    width: 100%;
                }
            }
        </style>
    </head>
    <body>
        <div class="progress-bar">
            <div class="progress-content">
                <div class="progress-step">
                    <div class="step-number active">1</div>
                    <span>Thông tin</span>
                </div>
                <div class="step-connector"></div>
                <div class="progress-step">
                    <div class="step-number inactive">2</div>
                    <span>Thời gian & Thể loại</span>
                </div>
                <div class="step-connector"></div>
                <div class="progress-step">
                    <div class="step-number inactive">3</div>
                    <span>Cài đặt</span>
                </div>
                <div class="step-connector"></div>
                <div class="progress-step">
                    <div class="step-number inactive">4</div>
                    <span>Thông tin vé</span>
                </div>
            </div>
        </div>
        <div class="main-content">
            <h2 style="margin-bottom: 20px; color: #fff;">🎭 Tạo sự kiện - Bước 1</h2>
            <div id="toast-container" class="toast-container"></div>
            <c:if test="${not empty errorMessage}">
                <div class="error-message">${errorMessage}</div>
            </c:if>
            <c:if test="${empty genres}">
                <div class="error-message">Thể loại không khả dụng. Liên hệ hỗ trợ!</div>
            </c:if>
            <form id="createEventForm" action="${pageContext.request.contextPath}/organizer-servlet" method="POST" enctype="multipart/form-data" onsubmit="return validateForm()">
                <input type="hidden" name="action" value="step1"/>
                <div class="form-group">
                    <label for="name">Nhập tên sự kiện *</label>
                    <input type="text" id="name" name="name" class="form-control" value="${event.name}" required maxlength="100">
                </div>
                <div class="form-group">
                    <label for="physicalLocation">Physical Location (Tỉnh/Thành phố)</label>
                    <select id="physicalLocation" name="physicalLocation" class="form-control">
                        <option value="" class="select-css">-- Chọn Tỉnh/Thành phố --</option>
                        <option class="select-css" value="An Giang" ${event.physicalLocation == 'An Giang' ? 'selected' : ''}>An Giang</option>
                        <option class="select-css" value="Bắc Ninh" ${event.physicalLocation == 'Bắc Ninh' ? 'selected' : ''}>Bắc Ninh</option>
                        <option class="select-css" value="Cà Mau" ${event.physicalLocation == 'Cà Mau' ? 'selected' : ''}>Cà Mau</option>
                        <option class="select-css" value="Cao Bằng" ${event.physicalLocation == 'Cao Bằng' ? 'selected' : ''}>Cao Bằng</option>
                        <option class="select-css" value="Cần Thơ" ${event.physicalLocation == 'Cần Thơ' ? 'selected' : ''}>Cần Thơ</option>
                        <option class="select-css" value="Đà Nẵng" ${event.physicalLocation == 'Đà Nẵng' ? 'selected' : ''}>Đà Nẵng</option>
                        <option class="select-css" value="Đắk Lắk" ${event.physicalLocation == 'Đắk Lắk' ? 'selected' : ''}>Đắk Lắk</option>
                        <option class="select-css" value="Điện Biên" ${event.physicalLocation == 'Điện Biên' ? 'selected' : ''}>Điện Biên</option>
                        <option class="select-css" value="Đồng Nai" ${event.physicalLocation == 'Đồng Nai' ? 'selected' : ''}>Đồng Nai</option>
                        <option class="select-css" value="Đồng Tháp" ${event.physicalLocation == 'Đồng Tháp' ? 'selected' : ''}>Đồng Tháp</option>
                        <option class="select-css" value="Gia Lai" ${event.physicalLocation == 'Gia Lai' ? 'selected' : ''}>Gia Lai</option>
                        <option class="select-css" value="Hà Nội" ${event.physicalLocation == 'Hà Nội' ? 'selected' : ''}>Hà Nội</option>
                        <option class="select-css" value="Hà Tĩnh" ${event.physicalLocation == 'Hà Tĩnh' ? 'selected' : ''}>Hà Tĩnh</option>
                        <option class="select-css" value="Hải Phòng" ${event.physicalLocation == 'Hải Phòng' ? 'selected' : ''}>Hải Phòng</option>
                        <option class="select-css" value="Hưng Yên" ${event.physicalLocation == 'Hưng Yên' ? 'selected' : ''}>Hưng Yên</option>
                        <option class="select-css" value="Huế" ${event.physicalLocation == 'Huế' ? 'selected' : ''}>Huế</option>
                        <option class="select-css" value="Khánh Hòa" ${event.physicalLocation == 'Khánh Hòa' ? 'selected' : ''}>Khánh Hòa</option>
                        <option class="select-css" value="Lai Châu" ${event.physicalLocation == 'Lai Châu' ? 'selected' : ''}>Lai Châu</option>
                        <option class="select-css" value="Lâm Đồng" ${event.physicalLocation == 'Lâm Đồng' ? 'selected' : ''}>Lâm Đồng</option>
                        <option class="select-css" value="Lạng Sơn" ${event.physicalLocation == 'Lạng Sơn' ? 'selected' : ''}>Lạng Sơn</option>
                        <option class="select-css" value="Lào Cai" ${event.physicalLocation == 'Lào Cai' ? 'selected' : ''}>Lào Cai</option>
                        <option class="select-css" value="Nghệ An" ${event.physicalLocation == 'Nghệ An' ? 'selected' : ''}>Nghệ An</option>
                        <option class="select-css" value="Ninh Bình" ${event.physicalLocation == 'Ninh Bình' ? 'selected' : ''}>Ninh Bình</option>
                        <option class="select-css" value="Phú Thọ" ${event.physicalLocation == 'Phú Thọ' ? 'selected' : ''}>Phú Thọ</option>
                        <option class="select-css" value="Quảng Ngãi" ${event.physicalLocation == 'Quảng Ngãi' ? 'selected' : ''}>Quảng Ngãi</option>
                        <option class="select-css" value="Quảng Ninh" ${event.physicalLocation == 'Quảng Ninh' ? 'selected' : ''}>Quảng Ninh</option>
                        <option class="select-css" value="Quảng Trị" ${event.physicalLocation == 'Quảng Trị' ? 'selected' : ''}>Quảng Trị</option>
                        <option class="select-css" value="Sơn La" ${event.physicalLocation == 'Sơn La' ? 'selected' : ''}>Sơn La</option>
                        <option class="select-css" value="Tây Ninh" ${event.physicalLocation == 'Tây Ninh' ? 'selected' : ''}>Tây Ninh</option>
                        <option class="select-css" value="Thái Nguyên" ${event.physicalLocation == 'Thái Nguyên' ? 'selected' : ''}>Thái Nguyên</option>
                        <option class="select-css" value="Thanh Hóa" ${event.physicalLocation == 'Thanh Hóa' ? 'selected' : ''}>Thanh Hóa</option>
                        <option class="select-css" value="Thành phố Hồ Chí Minh" ${event.physicalLocation == 'Thành phố Hồ Chí Minh' ? 'selected' : ''}>Thành phố Hồ Chí Minh</option>
                        <option class="select-css" value="Tuyên Quang" ${event.physicalLocation == 'Tuyên Quang' ? 'selected' : ''}>Tuyên Quang</option>
                        <option class="select-css" value="Vĩnh Long" ${event.physicalLocation == 'Vĩnh Long' ? 'selected' : ''}>Vĩnh Long</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="genreID">Nhập thể loại sự kiện *</label>
                    <select id="genreID" name="genreID" class="form-control" required>
                        <option value="" class="select-css">Select a genre</option>
                        <c:forEach var="genre" items="${genres}">
                            <option class="select-css" value="${genre.genreID}" ${event.genreID eq genre.genreID ? 'selected' : ''}>${genre.genreName}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group">
                    <label for="description">Nhập mô tả sự kiện</label>
                    <textarea id="description" name="description" class="form-control">${event.description}</textarea>
                </div>
                <div class="form-group">
                    <label for="imageFile">Ảnh sự kiện *</label>
                    <img id="imagePreview" src="${pageContext.request.contextPath}/asset/image/MayLangThangAvt.svg" alt="Hình ảnh sự kiện" class="image-preview" />
                    <input type="file" id="imageFile" name="imageFile" class="form-control" accept="image/jpeg,image/jpg,image/png,image/gif" required />
                </div>
                <div id="error-message" class="error-message"></div>
                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">Continue →</button>
                    <a href="${pageContext.request.contextPath}/organizer-servlet" class="btn btn-secondary">❌ Cancel</a>
                </div>
            </form>
        </div>

        <script>
            function previewImage(input) {
                const file = input.files[0];
                const preview = document.getElementById('imagePreview');
                const reader = new FileReader();

                reader.onloadend = function () {
                    if (preview) {
                        preview.src = reader.result;
                        preview.style.display = 'block';
                    }
                }

                if (file) {
                    reader.readAsDataURL(file);
                } else {
                    if (preview) {
                        preview.src = '${pageContext.request.contextPath}/asset/image/MayLangThangAvt.svg';
                        preview.style.display = 'none';
                    }
                }
            }

            function validateForm() {
                const name = document.querySelector('#name').value.trim();
                const physicalLocation = document.querySelector('#physicalLocation').value;
                const genreID = document.querySelector('#genreID').value;
                const description = document.querySelector('#description').value.trim();
                const imageFile = document.querySelector('#imageFile').files[0];
                const errorMessage = document.getElementById('error-message');

                if (!name) {
                    errorMessage.textContent = 'Tên sự kiện không được để trống';
                    errorMessage.classList.add('show');
                    return false;
                }
                if (name.length > 100) {
                    errorMessage.textContent = 'Tên sự kiện không được vượt quá 100 ký tự';
                    errorMessage.classList.add('show');
                    return false;
                }

                if (!physicalLocation) {
                    errorMessage.textContent = 'Vui lòng chọn địa điểm';
                    errorMessage.classList.add('show');
                    return false;
                }

                if (!genreID) {
                    errorMessage.textContent = 'Vui lòng chọn thể loại sự kiện';
                    errorMessage.classList.add('show');
                    return false;
                }

                if (description.length > 1000) {
                    errorMessage.textContent = 'Mô tả không được vượt quá 1000 ký tự';
                    errorMessage.classList.add('show');
                    return false;
                }

                if (!imageFile) {
                    errorMessage.textContent = 'Vui lòng chọn ảnh sự kiện';
                    errorMessage.classList.add('show');
                    return false;
                }

                const validTypes = ['image/jpeg', 'image/png', 'image/gif'];
                if (!validTypes.includes(imageFile.type)) {
                    errorMessage.textContent = 'Chỉ chấp nhận ảnh JPG, PNG hoặc GIF';
                    errorMessage.classList.add('show');
                    return false;
                }

                const maxSize = 5 * 1024 * 1024; // 5MB
                if (imageFile.size > maxSize) {
                    errorMessage.textContent = 'Kích thước ảnh không được vượt quá 5MB';
                    errorMessage.classList.add('show');
                    return false;
                }

                // Clear error message if validation passes
                errorMessage.classList.remove('show');
                return true;
            }

            document.getElementById('imageFile').addEventListener('change', function () {
                previewImage(this);
            });

            <c:if test="${not empty errorMessage}">
            document.getElementById('error-message').textContent = '${errorMessage}';
            document.getElementById('error-message').classList.add('show');
            </c:if>
        </script>
    </body>
</html>