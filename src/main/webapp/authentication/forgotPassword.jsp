<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quên mật khẩu - MasterTicket</title>
    <style>
        /* CSS from MasterTicket - Vé Sự Kiện page, adapted for Forgot Password */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(to bottom, #161b22, #0d1117);
            color: var(--text-light);
            min-height: 100vh;
            display: flex; /* Use flexbox for centering */
            justify-content: center; /* Center horizontally */
            align-items: center; /* Center vertically */
        }

        /* Color Scheme from EventDetails.jsp (or your main page) */
        :root {
            --primary: #667aff;      /* Primary color */
            --secondary: #e06bce;    /* Secondary color */
            --dark-bg: #161b22;      /* Gradient start */
            --darker-bg: #0d1117;    /* Gradient end */
            --card-bg: #21262d;      /* Card background */
            --border-color: #30363d; /* Border color */
            --text-light: #e6edf3;   /* Main text color */
            --text-muted: #8b949e;   /* Muted text color */
            --success: #00cc66;      /* Success/price color */
            --warning: #ffcc00;      /* Warning color */
            --danger: #ff3333;       /* Error color */
        }

        /* Form Container Styling */
        .forgot-password-container {
            background: var(--card-bg);
            padding: 2.5rem;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.4);
            max-width: 450px;
            width: 90%;
            text-align: center;
            border: 1px solid var(--border-color);
        }

        .forgot-password-container h2 {
            color: var(--primary);
            margin-bottom: 2rem;
            font-size: 2rem;
            font-weight: bold;
        }

        /* Error Message Styling */
        .error-message {
            color: var(--danger);
            background-color: rgba(255, 51, 51, 0.1);
            border: 1px solid var(--danger);
            padding: 10px 15px;
            border-radius: 8px;
            margin-bottom: 1.5rem;
            font-size: 0.95rem;
        }

        /* Form Group (Label + Input) */
        .form-group {
            margin-bottom: 1.5rem;
            text-align: left; /* Align labels and inputs to the left */
        }

        .form-group label {
            display: block; /* Make label take full width */
            margin-bottom: 0.75rem;
            color: var(--text-light);
            font-weight: 600;
            font-size: 1.05rem;
        }

        .form-group input[type="email"] {
            width: 100%;
            padding: 0.8rem 1rem;
            background: var(--darker-bg);
            border: 1px solid var(--border-color);
            border-radius: 8px;
            color: var(--text-light);
            font-size: 1rem;
            outline: none;
            transition: border-color 0.3s, box-shadow 0.3s;
        }

        .form-group input[type="email"]:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(102, 122, 255, 0.2);
        }

        /* Button Styling (reusing .btn classes from your main page) */
        .btn {
            padding: 0.8rem 2rem;
            border: none;
            border-radius: 25px;
            cursor: pointer;
            font-weight: 500;
            font-size: 1rem;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-width: 150px; /* Adjust as needed */
            color: var(--text-light);
        }

        .btn-primary {
            background: var(--primary);
            margin-top: 1rem; /* Add some space above the button */
        }

        .btn-primary:hover {
            background: #5566dd;
            transform: translateY(-2px);
        }

        /* Back to Login Link */
        .back-to-login {
            display: block; /* Make it a block-level element for spacing */
            margin-top: 1.5rem;
            color: var(--text-muted);
            text-decoration: none;
            font-size: 0.95rem;
            transition: color 0.3s;
        }

        .back-to-login:hover {
            color: var(--primary);
        }

        /* Responsive adjustments */
        @media (max-width: 480px) {
            .forgot-password-container {
                padding: 1.5rem;
            }

            .forgot-password-container h2 {
                font-size: 1.8rem;
                margin-bottom: 1.5rem;
            }

            .form-group label {
                font-size: 0.95rem;
            }

            .form-group input[type="email"] {
                padding: 0.6rem 0.8rem;
                font-size: 0.9rem;
            }

            .btn {
                padding: 0.6rem 1.5rem;
                font-size: 0.9rem;
                min-width: unset; /* Remove min-width on smaller screens */
            }
        }
    </style>
</head>
<body>
    <div class="forgot-password-container">
        <h2>Quên mật khẩu</h2>

        <c:if test="${not empty error}">
            <p class="error-message">${error}</p>
        </c:if>

        <form action="${pageContext.request.contextPath}/sendResetOTP" method="post">
            <div class="form-group">
                <label for="email">Nhập email đã đăng ký:</label>
                <input type="email" id="email" name="email" required>
            </div>
            <button type="submit" class="btn btn-primary">Gửi mã xác nhận</button>
        </form>

        <a href="${pageContext.request.contextPath}/login.jsp" class="back-to-login">Quay lại đăng nhập</a>
    </div>
</body>
</html>