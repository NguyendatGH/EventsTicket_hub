<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Gửi phản hồi</title>
        <!-- Link Bootstrap 5 -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

        <!-- FontAwesome for icons -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>

        <style>
            body {
                background: #f2f2f2;
                font-family: 'Segoe UI', sans-serif;
            }

            .feedback-container {
                max-width: 600px;
                margin: 40px auto;
                background: #ffffff;
                padding: 30px 40px;
                border-radius: 12px;
                box-shadow: 0 0 15px rgba(0,0,0,0.1);
            }

            .feedback-container h2 {
                margin-bottom: 25px;
                font-weight: 600;
                color: #333;
            }

            .form-control:focus {
                border-color: #0d6efd;
                box-shadow: none;
            }

            .rating-stars i {
                font-size: 24px;
                color: #ccc;
                cursor: pointer;
            }

            .rating-stars i.selected {
                color: #ffc107;
            }

            .btn-submit {
                background-color: #0d6efd;
                color: #fff;
                transition: 0.3s;
            }

            .btn-submit:hover {
                background-color: #084298;
            }
        </style>

        <script>
            function selectStar(rating) {
                const stars = document.querySelectorAll('.rating-stars i');
                stars.forEach((star, index) => {
                    star.classList.toggle('selected', index < rating);
                });
                document.getElementById("rating").value = rating;
            }
        </script>
    </head>
    <body>
        <div class="feedback-container">
            <h2><i class="fas fa-comment-alt"></i> Gửi phản hồi</h2>

            <form action="${pageContext.request.contextPath}/SubmitFeedbackServlet" method="post">
                <!-- Hidden inputs -->
                <input type="hidden" name="eventId" value="${eventId}" />
                <input type="hidden" name="orderId" value="${orderId}" />
                <input type="hidden" id="rating" name="rating" value="0"/>


                <!-- Rating -->
                <div class="mb-3">
                    <label class="form-label">Đánh giá:</label><br>
                    <div class="rating-stars">
                        <i class="fa fa-star" onclick="selectStar(1)"></i>
                        <i class="fa fa-star" onclick="selectStar(2)"></i>
                        <i class="fa fa-star" onclick="selectStar(3)"></i>
                        <i class="fa fa-star" onclick="selectStar(4)"></i>
                        <i class="fa fa-star" onclick="selectStar(5)"></i>
                    </div>
                </div>

                <!-- Feedback content -->
                <div class="mb-3">
                    <label for="content" class="form-label">Nội dung phản hồi:</label>
                    <textarea class="form-control" id="content" name="content" rows="5" required placeholder="Chia sẻ trải nghiệm của bạn..."></textarea>
                </div>

                <!-- Error or success message -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">${error}</div>
                </c:if>

                <!-- Submit button -->
                <button type="submit" class="btn btn-submit w-100">
                    <i class="fa fa-paper-plane"></i> Gửi phản hồi
                </button>
            </form>
        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
