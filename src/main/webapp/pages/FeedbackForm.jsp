<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gửi phản hồi - MasterTicket</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary: #6366f1;
            --primary-dark: #4f46e5;
            --secondary: #ec4899;
            --secondary-dark: #db2777;
            --accent: #06b6d4;
            --dark-bg: #0f172a;
            --darker-bg: #020617;
            --card-bg: #1e293b;
            --card-hover: #334155;
            --border-color: #334155;
            --text-light: #f1f5f9;
            --text-muted: #94a3b8;
            --success: #10b981;
            --warning: #f59e0b;
            --danger: #ef4444;
            --star-color: #fbbf24;
            --star-hover: #f59e0b;
            --glass-bg: rgba(30, 41, 59, 0.8);
            --gradient-1: linear-gradient(135deg, var(--primary), var(--secondary));
            --gradient-2: linear-gradient(135deg, var(--accent), var(--primary));
            --gradient-star: linear-gradient(135deg, var(--star-color), var(--star-hover));
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background: var(--darker-bg);
            color: var(--text-light);
            line-height: 1.6;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem;
            overflow-x: hidden;
        }

        /* Animated Background */
        body::before {
            content: '';
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: 
                radial-gradient(circle at 20% 80%, rgba(99, 102, 241, 0.1) 0%, transparent 50%),
                radial-gradient(circle at 80% 20%, rgba(236, 72, 153, 0.1) 0%, transparent 50%),
                radial-gradient(circle at 40% 40%, rgba(6, 182, 212, 0.05) 0%, transparent 50%);
            z-index: -1;
            animation: backgroundShift 20s ease infinite;
        }

        @keyframes backgroundShift {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.8; }
        }

        /* Enhanced Feedback Container */
        .feedback-container {
            background: var(--glass-bg);
            backdrop-filter: blur(20px);
            border: 1px solid var(--border-color);
            border-radius: 32px;
            padding: 3rem 2.5rem;
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.3);
            width: 100%;
            max-width: 700px;
            position: relative;
            overflow: hidden;
            animation: slideUp 0.8s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        }

        .feedback-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 6px;
            background: var(--gradient-1);
        }

        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(50px) scale(0.9);
            }
            to {
                opacity: 1;
                transform: translateY(0) scale(1);
            }
        }

        /* Enhanced Header */
        .feedback-container h2 {
            font-size: 2.5rem;
            font-weight: 700;
            background: var(--gradient-1);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 2.5rem;
            text-align: center;
            line-height: 1.2;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 1rem;
            animation: titleFadeIn 1s ease 0.3s both;
        }

        .feedback-container h2 i {
            color: var(--primary);
            font-size: 2rem;
        }

        @keyframes titleFadeIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* Enhanced Form Elements */
        .form-group {
            margin-bottom: 2rem;
            animation: formGroupFadeIn 0.6s ease forwards;
        }

        .form-group:nth-child(2) { animation-delay: 0.1s; }
        .form-group:nth-child(3) { animation-delay: 0.2s; }
        .form-group:nth-child(4) { animation-delay: 0.3s; }

        @keyframes formGroupFadeIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .form-label {
            display: block;
            color: var(--text-light);
            font-weight: 600;
            margin-bottom: 1rem;
            font-size: 1.1rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .form-label i {
            color: var(--primary);
            font-size: 1rem;
        }

        /* Enhanced Star Rating */
        .rating-container {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 20px;
            padding: 2rem;
            margin-bottom: 1rem;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .rating-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 3px;
            background: var(--gradient-star);
        }

        .rating-container:hover {
            background: var(--card-hover);
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.2);
        }

        .rating-stars {
            display: flex;
            justify-content: center;
            gap: 1rem;
            margin-top: 0.5rem;
        }

        .rating-stars i {
            font-size: 2.5rem;
            color: var(--border-color);
            cursor: pointer;
            transition: all 0.3s ease;
            position: relative;
            filter: drop-shadow(0 2px 4px rgba(0, 0, 0, 0.2));
        }

        .rating-stars i:hover {
            transform: scale(1.2);
            color: var(--star-hover);
        }

        .rating-stars i.selected {
            color: var(--star-color);
            transform: scale(1.1);
            animation: starGlow 0.5s ease;
        }

        .rating-stars i.selected:hover {
            color: var(--star-hover);
            transform: scale(1.3);
        }

        @keyframes starGlow {
            0% { transform: scale(1); }
            50% { transform: scale(1.3); }
            100% { transform: scale(1.1); }
        }

        .rating-text {
            text-align: center;
            margin-top: 1rem;
            font-size: 1rem;
            color: var(--text-muted);
            min-height: 1.5rem;
            transition: all 0.3s ease;
        }

        .rating-text.show {
            color: var(--star-color);
            font-weight: 600;
        }

        /* Enhanced Textarea */
        .form-control {
            width: 100%;
            padding: 1.25rem;
            border: 2px solid var(--border-color);
            border-radius: 16px;
            font-size: 1rem;
            font-family: inherit;
            resize: vertical;
            min-height: 150px;
            transition: all 0.3s ease;
            background: var(--card-bg);
            color: var(--text-light);
            backdrop-filter: blur(10px);
        }

        .form-control:focus {
            outline: none;
            border-color: var(--primary);
            background: var(--card-hover);
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.1);
            transform: translateY(-2px);
        }

        .form-control::placeholder {
            color: var(--text-muted);
        }

        /* Enhanced Alert Messages */
        .alert {
            padding: 1.25rem;
            margin-bottom: 1.5rem;
            border-radius: 12px;
            font-size: 0.95rem;
            backdrop-filter: blur(10px);
            display: flex;
            align-items: center;
            gap: 0.75rem;
            animation: alertSlideIn 0.5s ease;
            border: 1px solid;
        }

        @keyframes alertSlideIn {
            from {
                opacity: 0;
                transform: translateX(-20px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }

        .alert-danger {
            background: rgba(239, 68, 68, 0.1);
            color: var(--danger);
            border-color: var(--danger);
        }

        .alert-danger::before {
            content: '\f071';
            font-family: 'Font Awesome 6 Free';
            font-weight: 900;
            color: var(--danger);
        }

        .alert-success {
            background: rgba(16, 185, 129, 0.1);
            color: var(--success);
            border-color: var(--success);
        }

        .alert-success::before {
            content: '\f00c';
            font-family: 'Font Awesome 6 Free';
            font-weight: 900;
            color: var(--success);
        }

        /* Enhanced Submit Button */
        .btn-submit {
            width: 100%;
            background: var(--gradient-1);
            color: white;
            border: none;
            padding: 1.25rem 2rem;
            border-radius: 50px;
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            position: relative;
            overflow: hidden;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.75rem;
            animation: buttonFadeIn 0.6s ease 0.4s both;
        }

        @keyframes buttonFadeIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .btn-submit::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
            transition: left 0.5s;
        }

        .btn-submit:hover:not(:disabled)::before {
            left: 100%;
        }

        .btn-submit:hover:not(:disabled) {
            transform: translateY(-3px);
            box-shadow: 0 12px 35px rgba(99, 102, 241, 0.4);
        }

        .btn-submit:active:not(:disabled) {
            transform: translateY(-1px);
        }

        .btn-submit:disabled {
            opacity: 0.7;
            cursor: not-allowed;
            transform: none;
            box-shadow: none;
        }

        .btn-submit:disabled::before {
            display: none;
        }

        /* Loading Animation */
        .loading {
            display: inline-block;
            width: 20px;
            height: 20px;
            border: 3px solid rgba(255, 255, 255, 0.3);
            border-radius: 50%;
            border-top-color: white;
            animation: spin 1s ease-in-out infinite;
        }

        @keyframes spin {
            to { transform: rotate(360deg); }
        }

        /* Character Counter */
        .char-counter {
            text-align: right;
            font-size: 0.85rem;
            color: var(--text-muted);
            margin-top: 0.5rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .char-counter.warning {
            color: var(--warning);
        }

        .char-counter.danger {
            color: var(--danger);
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            body {
                padding: 1rem;
            }
            
            .feedback-container {
                padding: 2rem 1.5rem;
                border-radius: 24px;
            }
            
            .feedback-container h2 {
                font-size: 2rem;
                flex-direction: column;
                gap: 0.5rem;
            }
            
            .feedback-container h2 i {
                font-size: 1.5rem;
            }
            
            .rating-stars i {
                font-size: 2rem;
                gap: 0.5rem;
            }
            
            .rating-container {
                padding: 1.5rem;
            }
            
            .btn-submit {
                font-size: 1rem;
                padding: 1rem 1.5rem;
            }
            
            .form-control {
                min-height: 120px;
                padding: 1rem;
            }
        }

        @media (max-width: 480px) {
            .feedback-container {
                padding: 1.5rem 1rem;
                margin: 0.5rem;
            }
            
            .feedback-container h2 {
                font-size: 1.75rem;
            }
            
            .rating-stars {
                gap: 0.5rem;
            }
            
            .rating-stars i {
                font-size: 1.75rem;
            }
            
            .btn-submit {
                font-size: 0.95rem;
                padding: 0.875rem 1.25rem;
            }
        }

        /* Focus States for Accessibility */
        .form-control:focus,
        .btn-submit:focus,
        .rating-stars i:focus {
            outline: 2px solid var(--primary);
            outline-offset: 2px;
        }

        /* Enhanced Hover Effects */
        .rating-container,
        .form-control {
            transition: all 0.3s ease;
        }

        /* Validation States */
        .form-control.is-invalid {
            border-color: var(--danger);
            box-shadow: 0 0 0 3px rgba(239, 68, 68, 0.1);
        }

        .form-control.is-valid {
            border-color: var(--success);
            box-shadow: 0 0 0 3px rgba(16, 185, 129, 0.1);
        }
    </style>
</head>

<body>
    <div class="feedback-container">
        <h2>
            <i class="fas fa-comment-alt"></i>
            Gửi phản hồi
        </h2>
        
        <form action="${pageContext.request.contextPath}/SubmitFeedbackServlet" method="post" id="feedbackForm">
            <!-- Hidden inputs -->
            <input type="hidden" name="eventId" value="${eventId}" />
            <input type="hidden" name="orderId" value="${orderId}" />
            <input type="hidden" id="rating" name="rating" value="0"/>
            
            <!-- Rating -->
            <div class="form-group">
                <label class="form-label">
                    <i class="fas fa-star"></i>
                    Đánh giá của bạn:
                </label>
                <div class="rating-container">
                    <div class="rating-stars">
                        <i class="fa fa-star" onclick="selectStar(1)" tabindex="0" role="button" aria-label="1 sao"></i>
                        <i class="fa fa-star" onclick="selectStar(2)" tabindex="0" role="button" aria-label="2 sao"></i>
                        <i class="fa fa-star" onclick="selectStar(3)" tabindex="0" role="button" aria-label="3 sao"></i>
                        <i class="fa fa-star" onclick="selectStar(4)" tabindex="0" role="button" aria-label="4 sao"></i>
                        <i class="fa fa-star" onclick="selectStar(5)" tabindex="0" role="button" aria-label="5 sao"></i>
                    </div>
                    <div class="rating-text" id="ratingText">Nhấp để đánh giá</div>
                </div>
            </div>
            
            <!-- Feedback content -->
            <div class="form-group">
                <label for="content" class="form-label">
                    <i class="fas fa-edit"></i>
                    Nội dung phản hồi:
                </label>
                <textarea 
                    class="form-control" 
                    id="content" 
                    name="content" 
                    rows="5" 
                    required 
                    placeholder="Chia sẻ trải nghiệm của bạn về sự kiện này..."
                    maxlength="1000"
                ></textarea>
                <div class="char-counter" id="charCounter">
                    <small>
                        <i class="fas fa-keyboard"></i>
                        Tối đa 1000 ký tự
                    </small>
                    <span id="charCount">1000 ký tự còn lại</span>
                </div>
            </div>
            
            <!-- Error or success message -->
            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>
            
            <!-- Submit button -->
            <button type="submit" class="btn-submit" id="submitBtn">
                <span id="btnText">
                    <i class="fa fa-paper-plane"></i>
                    Gửi phản hồi
                </span>
            </button>
        </form>
    </div>

    <script>
        const ratingTexts = [
            'Nhấp để đánh giá',
            'Rất tệ',
            'Tệ', 
            'Bình thường',
            'Tốt',
            'Xuất sắc'
        ];

        function selectStar(rating) {
            const stars = document.querySelectorAll('.rating-stars i');
            const ratingText = document.getElementById('ratingText');
            
            stars.forEach((star, index) => {
                star.classList.toggle('selected', index < rating);
            });
            
            document.getElementById("rating").value = rating;
            ratingText.textContent = ratingTexts[rating];
            ratingText.classList.add('show');
            

            const ratingContainer = document.querySelector('.rating-container');
            ratingContainer.style.borderColor = 'var(--success)';
        }


        document.querySelectorAll('.rating-stars i').forEach((star, index) => {
            star.addEventListener('keydown', function(e) {
                if (e.key === 'Enter' || e.key === ' ') {
                    e.preventDefault();
                    selectStar(index + 1);
                }
            });
        });

        const textarea = document.getElementById('content');
        const maxLength = 1000;
        const charCounter = document.getElementById('charCounter');
        const charCount = document.getElementById('charCount');
        
        function updateCounter() {
            const remaining = maxLength - textarea.value.length;
            charCount.textContent = remaining + ' ký tự còn lại';
            

            charCounter.classList.remove('warning', 'danger');
            if (remaining < 50) {
                charCounter.classList.add('danger');
            } else if (remaining < 100) {
                charCounter.classList.add('warning');
            }
        }
        
        textarea.addEventListener('input', updateCounter);
        updateCounter(); 


        textarea.addEventListener('input', function() {
            this.style.height = 'auto';
            this.style.height = Math.max(150, this.scrollHeight) + 'px';
        });

        document.getElementById('feedbackForm').addEventListener('submit', function(e) {
            const rating = document.getElementById('rating').value;
            const content = document.getElementById('content').value.trim();
            const submitBtn = document.getElementById('submitBtn');
            const btnText = document.getElementById('btnText');

            if (rating === '0') {
                e.preventDefault();
                alert('Vui lòng chọn số sao đánh giá!');
                return;
            }
            
            if (content === '') {
                e.preventDefault();
                alert('Vui lòng nhập nội dung phản hồi!');
                return;
            }
            

            submitBtn.disabled = true;
            btnText.innerHTML = '<span class="loading"></span>Đang gửi...';
        });

        document.addEventListener('keydown', function(e) {
            if ((e.ctrlKey || e.metaKey) && e.key === 'Enter') {
                document.getElementById('feedbackForm').dispatchEvent(new Event('submit'));
            }
        });


        document.addEventListener('DOMContentLoaded', function() {
            setTimeout(() => {
                document.querySelector('.rating-stars i').focus();
            }, 500);
        });


        document.querySelectorAll('.rating-stars i').forEach((star, index) => {
            star.addEventListener('mouseenter', function() {
                const stars = document.querySelectorAll('.rating-stars i');
                stars.forEach((s, i) => {
                    if (i <= index) {
                        s.style.color = 'var(--star-hover)';
                        s.style.transform = 'scale(1.2)';
                    } else {
                        s.style.color = s.classList.contains('selected') ? 'var(--star-color)' : 'var(--border-color)';
                        s.style.transform = s.classList.contains('selected') ? 'scale(1.1)' : 'scale(1)';
                    }
                });
            });
            
            star.addEventListener('mouseleave', function() {
                const stars = document.querySelectorAll('.rating-stars i');
                stars.forEach((s) => {
                    if (s.classList.contains('selected')) {
                        s.style.color = 'var(--star-color)';
                        s.style.transform = 'scale(1.1)';
                    } else {
                        s.style.color = 'var(--border-color)';
                        s.style.transform = 'scale(1)';
                    }
                });
            });
        });
    </script>
</body>
</html>