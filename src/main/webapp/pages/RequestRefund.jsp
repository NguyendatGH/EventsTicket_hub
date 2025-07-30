<%--
    Document   : refund
    Created on : May 26, 2025, 7:18:58 PM
    Author     : admin
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Yêu cầu hoàn vé - MasterTicket</title>
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

        /* Enhanced Form Container */
        .form-container {
            background: var(--glass-bg);
            backdrop-filter: blur(20px);
            border: 1px solid var(--border-color);
            border-radius: 32px;
            padding: 3rem 2.5rem;
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.3);
            width: 100%;
            max-width: 600px;
            position: relative;
            overflow: hidden;
            animation: slideUp 0.8s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        }

        .form-container::before {
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

        /* Enhanced Form Header */
        .form-header {
            text-align: center;
            margin-bottom: 2.5rem;
            position: relative;
        }

        .form-header h2 {
            font-size: 2.5rem;
            font-weight: 700;
            background: var(--gradient-1);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 1rem;
            line-height: 1.2;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 1rem;
        }

        .form-header h2 i {
            color: var(--primary);
            font-size: 2rem;
        }

        .form-header::after {
            content: '';
            display: block;
            width: 80px;
            height: 4px;
            background: var(--gradient-1);
            margin: 1rem auto;
            border-radius: 2px;
            box-shadow: 0 0 20px rgba(99, 102, 241, 0.3);
        }

        /* Enhanced Messages */
        .error-message {
            background: rgba(239, 68, 68, 0.1);
            border: 1px solid var(--danger);
            border-left: 4px solid var(--danger);
            padding: 1.25rem;
            margin-bottom: 1.5rem;
            border-radius: 12px;
            color: var(--danger);
            font-size: 0.95rem;
            backdrop-filter: blur(10px);
            display: flex;
            align-items: center;
            gap: 0.75rem;
            animation: messageSlideIn 0.5s ease;
        }

        .success-message {
            background: rgba(16, 185, 129, 0.1);
            border: 1px solid var(--success);
            border-left: 4px solid var(--success);
            padding: 1.25rem;
            margin-bottom: 1.5rem;
            border-radius: 12px;
            color: var(--success);
            font-size: 0.95rem;
            backdrop-filter: blur(10px);
            display: flex;
            align-items: center;
            gap: 0.75rem;
            animation: messageSlideIn 0.5s ease;
        }

        @keyframes messageSlideIn {
            from {
                opacity: 0;
                transform: translateX(-20px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }

        .order-info {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: 1.25rem;
            margin-bottom: 1.5rem;
            color: var(--text-light);
            font-size: 0.95rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            transition: all 0.3s ease;
        }

        .order-info:hover {
            background: var(--card-hover);
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.2);
        }

        .info-text {
            background: rgba(6, 182, 212, 0.1);
            border: 1px solid var(--accent);
            border-left: 4px solid var(--accent);
            padding: 1.25rem;
            margin-bottom: 2rem;
            border-radius: 12px;
            color: var(--accent);
            font-size: 0.95rem;
            backdrop-filter: blur(10px);
            display: flex;
            align-items: flex-start;
            gap: 0.75rem;
            line-height: 1.6;
        }

        /* Enhanced Form Elements */
        .form-group {
            margin-bottom: 2rem;
            position: relative;
        }

        .form-label {
            display: block;
            color: var(--text-light);
            font-weight: 600;
            margin-bottom: 0.75rem;
            font-size: 1.1rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .form-label i {
            color: var(--primary);
        }

        .form-textarea {
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

        .form-textarea:focus {
            outline: none;
            border-color: var(--primary);
            background: var(--card-hover);
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.1);
            transform: translateY(-2px);
        }

        .form-textarea::placeholder {
            color: var(--text-muted);
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

        /* Enhanced Submit Button */
        .submit-btn {
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
        }

        .submit-btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
            transition: left 0.5s;
        }

        .submit-btn:hover:not(:disabled)::before {
            left: 100%;
        }

        .submit-btn:hover:not(:disabled) {
            transform: translateY(-3px);
            box-shadow: 0 12px 35px rgba(99, 102, 241, 0.4);
        }

        .submit-btn:active:not(:disabled) {
            transform: translateY(-1px);
        }

        .submit-btn:disabled {
            opacity: 0.7;
            cursor: not-allowed;
            transform: none;
            box-shadow: none;
        }

        .submit-btn:disabled::before {
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

        /* Enhanced Small Text */
        small {
            color: var(--text-muted);
            font-size: 0.85rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-top: 0.5rem;
        }

        small i {
            color: var(--accent);
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            body {
                padding: 1rem;
            }
            
            .form-container {
                padding: 2rem 1.5rem;
                border-radius: 24px;
            }
            
            .form-header h2 {
                font-size: 2rem;
                flex-direction: column;
                gap: 0.5rem;
            }
            
            .form-header h2 i {
                font-size: 1.5rem;
            }
            
            .submit-btn {
                font-size: 1rem;
                padding: 1rem 1.5rem;
            }
            
            .form-textarea {
                min-height: 120px;
                padding: 1rem;
            }
        }

        @media (max-width: 480px) {
            .form-container {
                padding: 1.5rem 1rem;
                margin: 0.5rem;
            }
            
            .form-header h2 {
                font-size: 1.75rem;
            }
            
            .submit-btn {
                font-size: 0.95rem;
                padding: 0.875rem 1.25rem;
            }
        }

        /* Focus States for Accessibility */
        .form-textarea:focus,
        .submit-btn:focus {
            outline: 2px solid var(--primary);
            outline-offset: 2px;
        }

        /* Hover Effects for Interactive Elements */
        .order-info,
        .info-text,
        .error-message,
        .success-message {
            transition: all 0.3s ease;
        }

        .order-info:hover,
        .info-text:hover {
            transform: translateY(-1px);
        }

        /* Auto-resize Animation */
        .form-textarea {
            transition: height 0.3s ease, border-color 0.3s ease, background-color 0.3s ease, transform 0.3s ease;
        }

        /* Enhanced Icons */
        .fas, .far {
            transition: all 0.3s ease;
        }

        .form-label:hover i,
        .error-message i,
        .success-message i,
        .info-text i,
        .order-info i {
            transform: scale(1.1);
        }
    </style>
</head>

<body>
    <div class="form-container">
        <div class="form-header">
            <h2>
                <i class="fas fa-undo-alt"></i>
                Yêu cầu hoàn trả vé
            </h2>
        </div>
        
        <%-- Display error message if exists --%>
        <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="error-message">
                <i class="fas fa-exclamation-circle"></i>
                <div>
                    <strong>Lỗi:</strong> <%= request.getAttribute("errorMessage") %>
                </div>
            </div>
        <% } %>
        
        <%-- Display success message if exists --%>
        <% if (request.getAttribute("successMessage") != null) { %>
            <div class="success-message">
                <i class="fas fa-check-circle"></i>
                <div>
                    <strong>Thành công:</strong> <%= request.getAttribute("successMessage") %>
                </div>
            </div>
        <% } %>
        
        <%-- Display order info if available --%>
        <% if (request.getAttribute("orderId") != null) { %>
            <div class="order-info">
                <i class="fas fa-receipt"></i>
                <div>
                    <strong>Mã đơn hàng:</strong> <%= request.getAttribute("orderId") %>
                </div>
            </div>
        <% } %>
        
        <div class="info-text">
            <i class="fas fa-info-circle"></i>
            <div>
                <strong>Lưu ý:</strong> Vui lòng mô tả chi tiết lý do hoàn vé để chúng tôi có thể xử lý yêu cầu của bạn một cách nhanh chóng.
            </div>
        </div>

        <form method="post" action="${pageContext.request.contextPath}/SubmitRefundServlet" id="refundForm">
            <input type="hidden" name="orderId" value="${orderId}" />
            
            <div class="form-group">
                <label for="refundReason" class="form-label">
                    <i class="fas fa-comment-alt"></i>
                    Lý do hoàn vé *
                </label>
                <textarea 
                    id="refundReason"
                    name="refundReason" 
                    class="form-textarea"
                    placeholder="Vui lòng nhập lý do chi tiết cho việc hoàn vé của bạn..."
                    required
                    maxlength="500"
                ><%= request.getParameter("refundReason") != null ? request.getParameter("refundReason") : "" %></textarea>
                <div class="char-counter" id="charCounter">
                    <small>
                        <i class="fas fa-keyboard"></i>
                        Tối đa 500 ký tự
                    </small>
                    <span id="charCount">500 ký tự còn lại</span>
                </div>
            </div>
            
            <button type="submit" class="submit-btn" id="submitBtn">
                <span id="btnText">
                    <i class="fas fa-paper-plane"></i>
                    Gửi yêu cầu hoàn vé
                </span>
            </button>
        </form>
    </div>

    <script>

        document.getElementById('refundForm').addEventListener('submit', function(e) {
            const submitBtn = document.getElementById('submitBtn');
            const btnText = document.getElementById('btnText');

            submitBtn.disabled = true;
            btnText.innerHTML = '<span class="loading"></span>Đang xử lý...';
        });

        const textarea = document.getElementById('refundReason');
        const maxLength = 500;
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

        document.addEventListener('keydown', function(e) {
            if ((e.ctrlKey || e.metaKey) && e.key === 'Enter') {
                document.getElementById('refundForm').dispatchEvent(new Event('submit'));
            }
        });

        document.addEventListener('DOMContentLoaded', function() {
            setTimeout(() => {
                textarea.focus();
            }, 500);
        });
    </script>
</body>
</html>