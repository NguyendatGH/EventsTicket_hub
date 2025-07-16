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
    <title>Yêu cầu hoàn vé</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .form-container {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            padding: 40px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 500px;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .form-header {
            text-align: center;
            margin-bottom: 30px;
        }

        .form-header h2 {
            color: #4a5568;
            font-size: 28px;
            font-weight: 600;
            margin-bottom: 8px;
        }

        .form-header::after {
            content: '';
            display: block;
            width: 60px;
            height: 4px;
            background: linear-gradient(90deg, #667eea, #764ba2);
            margin: 15px auto;
            border-radius: 2px;
        }

        .form-group {
            margin-bottom: 25px;
        }

        .form-label {
            display: block;
            color: #4a5568;
            font-weight: 500;
            margin-bottom: 8px;
            font-size: 16px;
        }

        .form-textarea {
            width: 100%;
            padding: 15px;
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            font-size: 16px;
            font-family: inherit;
            resize: vertical;
            min-height: 120px;
            transition: all 0.3s ease;
            background: #f8fafc;
        }

        .form-textarea:focus {
            outline: none;
            border-color: #667eea;
            background: #ffffff;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .form-textarea::placeholder {
            color: #a0aec0;
        }

        .submit-btn {
            width: 100%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            padding: 16px 24px;
            border-radius: 12px;
            font-size: 18px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .submit-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(102, 126, 234, 0.3);
        }

        .submit-btn:active {
            transform: translateY(0);
        }

        .info-text {
            background: #e6fffa;
            border-left: 4px solid #38b2ac;
            padding: 15px;
            margin-bottom: 25px;
            border-radius: 0 8px 8px 0;
            color: #234e52;
            font-size: 14px;
        }

        .order-info {
            background: #f0f4f8;
            border: 1px solid #cbd5e0;
            border-radius: 8px;
            padding: 12px;
            margin-bottom: 20px;
            color: #4a5568;
            font-size: 14px;
        }

        .error-message {
            background: #fed7d7;
            border-left: 4px solid #e53e3e;
            padding: 12px;
            margin-bottom: 20px;
            border-radius: 0 8px 8px 0;
            color: #742a2a;
            font-size: 14px;
        }

        .success-message {
            background: #c6f6d5;
            border-left: 4px solid #38a169;
            padding: 12px;
            margin-bottom: 20px;
            border-radius: 0 8px 8px 0;
            color: #22543d;
            font-size: 14px;
        }

        @media (max-width: 480px) {
            .form-container {
                padding: 25px;
                margin: 10px;
            }
            
            .form-header h2 {
                font-size: 24px;
            }
            
            .submit-btn {
                font-size: 16px;
                padding: 14px 20px;
            }
        }

        /* Animation for form appearance */
        .form-container {
            animation: slideUp 0.6s ease-out;
        }

        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* Loading state */
        .submit-btn:disabled {
            opacity: 0.7;
            cursor: not-allowed;
            transform: none;
        }

        .loading {
            display: inline-block;
            width: 20px;
            height: 20px;
            border: 3px solid #ffffff;
            border-radius: 50%;
            border-top-color: transparent;
            animation: spin 1s ease-in-out infinite;
            margin-right: 8px;
        }

        @keyframes spin {
            to { transform: rotate(360deg); }
        }
    </style>
</head>
<body>
    <div class="form-container">
        <div class="form-header">
            <h2>Yêu cầu hoàn trả vé</h2>
        </div>
        
        <%-- Display error message if exists --%>
        <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="error-message">
                <strong>Lỗi:</strong> <%= request.getAttribute("errorMessage") %>
            </div>
        <% } %>
        
        <%-- Display success message if exists --%>
        <% if (request.getAttribute("successMessage") != null) { %>
            <div class="success-message">
                <strong>Thành công:</strong> <%= request.getAttribute("successMessage") %>
            </div>
        <% } %>
        
        <%-- Display order info if available --%>
        <% if (request.getAttribute("orderId") != null) { %>
            <div class="order-info">
                <strong>Mã đơn hàng:</strong> <%= request.getAttribute("orderId") %>
            </div>
        <% } %>
        
        <div class="info-text">
            <strong>Lưu ý:</strong> Vui lòng mô tả chi tiết lý do hoàn vé để chúng tôi có thể xử lý yêu cầu của bạn một cách nhanh chóng.
        </div>

        <form method="post" action="${pageContext.request.contextPath}/SubmitRefundServlet" id="refundForm">
            <input type="hidden" name="orderId" value="${orderId}" />
            
            <div class="form-group">
                <label for="refundReason" class="form-label">Lý do hoàn vé *</label>
                <textarea 
                    id="refundReason"
                    name="refundReason" 
                    class="form-textarea"
                    placeholder="Vui lòng nhập lý do chi tiết cho việc hoàn vé của bạn..."
                    required
                    maxlength="500"
                ><%= request.getParameter("refundReason") != null ? request.getParameter("refundReason") : "" %></textarea>
                <small style="color: #718096; font-size: 12px;">Tối đa 500 ký tự</small>
            </div>
            
            <button type="submit" class="submit-btn" id="submitBtn">
                <span id="btnText">Gửi yêu cầu hoàn vé</span>
            </button>
        </form>
    </div>

    <script>
        // Add loading state when form is submitted
        document.getElementById('refundForm').addEventListener('submit', function(e) {
            const submitBtn = document.getElementById('submitBtn');
            const btnText = document.getElementById('btnText');
            
            // Disable button and show loading
            submitBtn.disabled = true;
            btnText.innerHTML = '<span class="loading"></span>Đang xử lý...';
        });

        // Character counter for textarea
        const textarea = document.getElementById('refundReason');
        const maxLength = 500;
        
        // Create character counter element
        const counter = document.createElement('div');
        counter.style.cssText = 'text-align: right; font-size: 12px; color: #718096; margin-top: 5px;';
        textarea.parentNode.appendChild(counter);
        
        function updateCounter() {
            const remaining = maxLength - textarea.value.length;
            counter.textContent = remaining + ' ký tự còn lại';
            counter.style.color = remaining < 50 ? '#e53e3e' : '#718096';
        }
        
        textarea.addEventListener('input', updateCounter);
        updateCounter(); // Initial call
        
        // Auto-resize textarea
        textarea.addEventListener('input', function() {
            this.style.height = 'auto';
            this.style.height = Math.max(120, this.scrollHeight) + 'px';
        });
    </script>
</body>
</html>
