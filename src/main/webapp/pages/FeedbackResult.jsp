<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Phản hồi thành công</title>

    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@500;700&display=swap" rel="stylesheet">

    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: 'Quicksand', sans-serif;
            background: linear-gradient(to right, #74ebd5, #ACB6E5);
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        .feedback-card {
            background-color: white;
            border-radius: 16px;
            box-shadow: 0 12px 30px rgba(0, 0, 0, 0.15);
            padding: 40px 50px;
            text-align: center;
            max-width: 520px;
            animation: fadeIn 1s ease-in-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .feedback-card .icon {
            font-size: 70px;
            color: #28a745;
            margin-bottom: 20px;
            animation: pop 0.6s ease;
        }

        @keyframes pop {
            0% { transform: scale(0.5); }
            100% { transform: scale(1); }
        }

        .feedback-card h1 {
            color: #333;
            font-weight: 700;
            margin-bottom: 15px;
        }

        .feedback-card p {
            color: #555;
            font-size: 18px;
            margin-bottom: 30px;
        }

        .btn-home {
            background: linear-gradient(to right, #00c6ff, #0072ff);
            color: white;
            border: none;
            padding: 12px 28px;
            font-size: 16px;
            border-radius: 50px;
            text-decoration: none;
            transition: 0.3s ease;
        }

        .btn-home:hover {
            background: linear-gradient(to right, #0072ff, #00c6ff);
            transform: scale(1.05);
        }
    </style>
</head>
<body>
    <div class="feedback-card">
        <div class="icon">
            <i class="fas fa-check-circle"></i>
        </div>
        <h1>Phản hồi đã được gửi!</h1>
        <p>Cảm ơn bạn đã chia sẻ trải nghiệm. Chúng tôi sẽ xem xét phản hồi của bạn trong thời gian sớm nhất.</p>
        <a href="${pageContext.request.contextPath}/" class="btn-home">
            <i class="fas fa-home"></i> Về trang chủ
        </a>
    </div>

    <!-- Bootstrap Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
