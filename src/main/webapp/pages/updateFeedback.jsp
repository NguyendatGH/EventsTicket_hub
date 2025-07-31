<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.Feedback" %>
<%@ page import="dao.FeedbackDAO" %>
<%@ page import="dto.UserDTO" %>
<%
    String feedbackIdParam = request.getParameter("feedbackId");
    FeedbackDAO dao = new FeedbackDAO();
    Feedback fb = null;
    UserDTO currentUser = (UserDTO) session.getAttribute("user");
    
    if (feedbackIdParam != null) {
        int feedbackId = Integer.parseInt(feedbackIdParam);
        fb = dao.getFeedbackById(feedbackId);
        if (fb == null || currentUser == null || currentUser.getId() != fb.getUserID()) {
            response.sendRedirect("access-denied.jsp");
            return;
        }
    } else {
        response.sendRedirect("error.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chỉnh sửa phản hồi</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
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
            --glass-bg: rgba(30, 41, 59, 0.8);
            --gradient-1: linear-gradient(135deg, var(--primary), var(--secondary));
            --gradient-2: linear-gradient(135deg, var(--accent), var(--primary));
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: linear-gradient(135deg, var(--darker-bg) 0%, var(--dark-bg) 50%, var(--card-bg) 100%);
            color: var(--text-light);
            min-height: 100vh;
            padding: 1rem;
        }

        /* Back Button - Top Left Corner */
        .back-button {
            position: fixed;
            top: 2rem;
            left: 2rem;
            z-index: 1000;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.75rem 1.5rem;
            background: var(--glass-bg);
            backdrop-filter: blur(12px);
            border: 1px solid var(--border-color);
            border-radius: 50px;
            color: var(--text-light);
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
            box-shadow: 0 8px 25px -8px rgba(0, 0, 0, 0.3);
        }

        .back-button:hover {
            background: var(--card-hover);
            transform: translateY(-2px);
            box-shadow: 0 12px 35px -8px rgba(0, 0, 0, 0.4);
            color: var(--text-light);
            text-decoration: none;
        }

        .back-button i {
            font-size: 1.1rem;
        }

        /* Main Container */
        .container {
            max-width: 800px;
            margin: 6rem auto 2rem;
            padding: 0 1rem;
        }

        /* Glass Card */
        .glass-card {
            position: relative;
            background: var(--glass-bg);
            backdrop-filter: blur(20px);
            border: 1px solid var(--border-color);
            border-radius: 24px;
            padding: 3rem;
            box-shadow: 
                0 25px 50px -12px rgba(0, 0, 0, 0.5),
                0 0 0 1px rgba(255, 255, 255, 0.05);
        }

        .glass-card::before {
            content: "";
            position: absolute;
            inset: 0;
            border-radius: 24px;
            background: var(--gradient-1);
            opacity: 0.03;
            pointer-events: none;
        }

        /* Header */
        .header {
            border-bottom: 1px solid var(--border-color);
            padding-bottom: 2rem;
            margin-bottom: 2.5rem;
        }

        .header h1 {
            font-size: 2.5rem;
            font-weight: 700;
            background: var(--gradient-1);
            -webkit-background-clip: text;
            background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 0.5rem;
        }

        .header p {
            color: var(--text-muted);
            font-size: 1.1rem;
        }

        /* Form Styles */
        .form-group {
            margin-bottom: 2.5rem;
        }

        .form-label {
            display: block;
            font-size: 1.2rem;
            font-weight: 600;
            color: var(--text-light);
            margin-bottom: 1rem;
        }

        /* Star Rating */
        .star-rating {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-top: 1rem;
        }

        .star-container {
            display: flex;
            gap: 0.25rem;
        }

        .star {
            position: relative;
            cursor: pointer;
            font-size: 2rem;
            color: var(--text-muted);
            transition: all 0.2s ease;
        }

        .star:hover,
        .star.active {
            color: var(--warning);
            transform: scale(1.1);
        }

        .star input[type="radio"] {
            position: absolute;
            opacity: 0;
            cursor: pointer;
        }

        .rating-text {
            margin-left: 1rem;
            font-weight: 500;
            color: var(--text-light);
        }

        .rating-label {
            position: absolute;
            bottom: -2.5rem;
            left: 50%;
            transform: translateX(-50%);
            font-size: 0.875rem;
            color: var(--text-muted);
            opacity: 0;
            transition: opacity 0.2s ease;
            white-space: nowrap;
        }

        .star:hover .rating-label {
            opacity: 1;
        }

        /* Textarea */
        .form-textarea {
            width: 100%;
            min-height: 150px;
            padding: 1.5rem;
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 16px;
            color: var(--text-light);
            font-size: 1rem;
            font-family: inherit;
            resize: vertical;
            transition: all 0.2s ease;
        }

        .form-textarea:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.1);
        }

        .form-textarea:hover {
            border-color: var(--card-hover);
        }

        .form-textarea::placeholder {
            color: var(--text-muted);
        }

        .textarea-container {
            position: relative;
        }

        .char-counter {
            position: absolute;
            bottom: 1rem;
            right: 1rem;
            font-size: 0.875rem;
            color: var(--text-muted);
        }

        /* Buttons */
        .form-actions {
            display: flex;
            gap: 1rem;
            padding-top: 2rem;
            flex-wrap: wrap;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 1rem 2rem;
            border-radius: 16px;
            font-size: 1rem;
            font-weight: 600;
            text-decoration: none;
            border: none;
            cursor: pointer;
            transition: all 0.2s ease;
            transform: translateY(0);
        }

        .btn:hover {
            transform: translateY(-2px);
        }

        .btn:active {
            transform: translateY(0);
        }

        .btn-primary {
            background: var(--gradient-1);
            color: white;
            box-shadow: 0 10px 25px -5px rgba(99, 102, 241, 0.4);
            flex: 1;
        }

        .btn-primary:hover {
            box-shadow: 0 15px 35px -5px rgba(99, 102, 241, 0.6);
        }

        .btn-secondary {
            background: var(--card-bg);
            color: var(--text-light);
            border: 1px solid var(--border-color);
        }

        .btn-secondary:hover {
            background: var(--card-hover);
            border-color: var(--card-hover);
            color: var(--text-light);
            text-decoration: none;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .back-button {
                top: 1rem;
                left: 1rem;
                padding: 0.5rem 1rem;
                font-size: 0.9rem;
            }

            .container {
                margin-top: 5rem;
                padding: 0 0.5rem;
            }

            .glass-card {
                padding: 2rem 1.5rem;
            }

            .header h1 {
                font-size: 2rem;
            }

            .form-actions {
                flex-direction: column;
            }

            .btn {
                justify-content: center;
            }
        }
    </style>
</head>
<body>
    <!-- Back Button - Top Left Corner -->
    <a href="EventServlet?id=<%= fb.getEventID() %>" class="back-button">
        <i class="fas fa-arrow-left"></i>
        <span>Quay lại sự kiện</span>
    </a>

    <div class="container">
        <div class="glass-card">
            <!-- Header -->
            <div class="header">
                <h1>Chỉnh sửa phản hồi</h1>
                <p>Cập nhật đánh giá và nhận xét của bạn về sự kiện</p>
            </div>

            <!-- Form -->
            <form action="${pageContext.request.contextPath}/UpdateFeedbackServlet" method="post">
                <input type="hidden" name="feedbackID" value="<%= fb.getFeedbackID() %>"/>
                
                <!-- Rating Section -->
                <div class="form-group">
                    <label class="form-label">Mức đánh giá của bạn</label>
                    <div class="star-rating">
                        <div class="star-container">
                            <% 
                            String[] ratingLabels = {"", "Rất tệ", "Tệ", "Bình thường", "Tốt", "Xuất sắc"};
                            for (int i = 1; i <= 5; i++) { 
                            %>
                            <label class="star <%= (i <= fb.getRating()) ? "active" : "" %>" data-rating="<%= i %>">
                                <input type="radio" name="rating" value="<%= i %>" <%= (i == fb.getRating()) ? "checked" : "" %> />
                                <i class="fas fa-star"></i>
                                <span class="rating-label"><%= ratingLabels[i] %></span>
                            </label>
                            <% } %>
                        </div>
                        <span class="rating-text"><span id="current-rating"><%= fb.getRating() %></span>/5 sao</span>
                    </div>
                </div>

                <!-- Content Section -->
                <div class="form-group">
                    <label for="content" class="form-label">Nội dung phản hồi</label>
                    <div class="textarea-container">
                        <textarea 
                            id="content" 
                            name="content" 
                            class="form-textarea" 
                            required 
                            maxlength="500"
                            placeholder="Chia sẻ trải nghiệm của bạn về sự kiện..."
                        ><%= fb.getContent() %></textarea>
                        <div class="char-counter">
                            <span id="char-count"><%= fb.getContent().length() %></span>/500
                        </div>
                    </div>
                </div>

                <!-- Action Buttons -->
                <div class="form-actions">
                    <a href="EventServlet?id=<%= fb.getEventID() %>" class="btn btn-secondary">
                        <i class="fas fa-times"></i>
                        Hủy bỏ
                    </a>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save"></i>
                        Lưu thay đổi
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script>
        // Star rating interaction
        document.addEventListener('DOMContentLoaded', function() {
            const stars = document.querySelectorAll('.star');
            const currentRatingSpan = document.getElementById('current-rating');
            
            stars.forEach((star, index) => {
                star.addEventListener('click', function() {
                    const rating = parseInt(this.dataset.rating);
                    currentRatingSpan.textContent = rating;
                    
                    // Update visual state
                    stars.forEach((s, i) => {
                        if (i < rating) {
                            s.classList.add('active');
                        } else {
                            s.classList.remove('active');
                        }
                    });
                });
                
                star.addEventListener('mouseenter', function() {
                    const rating = parseInt(this.dataset.rating);
                    stars.forEach((s, i) => {
                        if (i < rating) {
                            s.style.color = 'var(--warning)';
                            s.style.transform = 'scale(1.1)';
                        } else {
                            s.style.color = 'var(--text-muted)';
                            s.style.transform = 'scale(1)';
                        }
                    });
                });
                
                star.addEventListener('mouseleave', function() {
                    stars.forEach((s, i) => {
                        if (s.classList.contains('active')) {
                            s.style.color = 'var(--warning)';
                            s.style.transform = 'scale(1.1)';
                        } else {
                            s.style.color = 'var(--text-muted)';
                            s.style.transform = 'scale(1)';
                        }
                    });
                });
            });
            
            // Character counter
            const textarea = document.getElementById('content');
            const charCount = document.getElementById('char-count');
            
            textarea.addEventListener('input', function() {
                charCount.textContent = this.value.length;
            });
        });
    </script>
</body>
</html>
