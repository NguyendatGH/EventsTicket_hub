<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Promotion Settings - MasterTicket</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" />
    <style>
        body {
            margin: 0;
            padding: 0;
            display: flex;
            font-family: 'Segoe UI', sans-serif;
            background-color: #1c1533;
            color: white;
        }

        /* Sidebar */
        .sidebar {
            width: 230px;
            height: 100vh;
            background: linear-gradient(to bottom, #1f1c2c, #2c274d);
            padding: 20px 10px;
            box-sizing: border-box;
        }

        .logo {
            font-size: 20px;
            font-weight: bold;
            color: #2ecc71;
            margin-bottom: 30px;
            display: flex;
            align-items: center;
        }

        .logo-text {
            margin-left: 5px;
        }

        .menu {
            list-style-type: none;
            padding: 0;
            margin: 0;
        }

        .menu li {
            padding: 12px 10px;
            margin-bottom: 10px;
            border-radius: 8px;
            cursor: pointer;
            display: flex;
            align-items: center;
            font-size: 14px;
            transition: background 0.3s;
        }

        .menu li i {
            margin-right: 10px;
        }

        .menu li:hover,
        .menu li.active {
            background-color: rgba(255, 255, 255, 0.1);
        }

        /* Main content */
        .main-content {
            flex: 1;
            padding: 40px;
            box-sizing: border-box;
        }

        .promotion-section {
            background: #3e276d;
            padding: 20px;
            border-radius: 10px;
            max-width: 900px;
        }

        .promotion-header {
            font-size: 18px;
            font-weight: bold;
            margin-bottom: 15px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .toggle-promo {
            font-size: 14px;
        }

        .toggle-promo input {
            margin-right: 5px;
        }

        .promotion-group {
            margin-bottom: 15px;
            display: flex;
            flex-direction: column;
        }

        .promotion-group label {
            margin-bottom: 5px;
        }

        .promotion-group input {
            padding: 10px;
            border-radius: 6px;
            border: none;
            font-size: 14px;
        }

        .promotion-datetime {
            display: flex;
            gap: 20px;
        }

        .promotion-group.half {
            flex: 1;
        }

        .warning-text {
            font-size: 12px;
            color: #ffcc00;
            margin-top: 4px;
        }

        .promotion-note {
            background: rgba(255, 255, 255, 0.1);
            padding: 10px;
            margin-top: 15px;
            font-size: 13px;
            color: #ffdf66;
            border: 1px solid #ffdf66;
            border-radius: 8px;
        }

        .submit-button {
            background-color: #00c853;
            border: none;
            padding: 12px 20px;
            font-size: 16px;
            border-radius: 8px;
            color: white;
            cursor: pointer;
            float: right;
            margin-top: 20px;
        }

        .submit-button:hover {
            background-color: #00b34a;
        }
    </style>
</head>
<body>
    <!-- Sidebar -->
    <div class="sidebar">
        <div class="logo">🎟️ <span class="logo-text">MasterTicket</span></div>
        <ul class="menu">
            <li class="active"><i class="fa fa-calendar"></i> Sự kiện của tôi</li>
            <li><i class="fa fa-bar-chart"></i> Quản lí báo cáo</li>
            <li><i class="fa fa-file-alt"></i> Điều khoản</li>
        </ul>
    </div>

    <!-- Main content -->
    <div class="main-content">
        <form action="CreatePromotionServlet" method="post">
            <div class="promotion-section">
                <div class="promotion-header">
                    🎁 Promotion Settings
                    <label class="toggle-promo">
                        <input type="checkbox" name="enablePromotion" checked />
                        Enable Promotion for this event
                    </label>
                </div>

                <div class="promotion-group">
                    <label for="promotionName">Promotion Name</label>
                    <input type="text" id="promotionName" name="promotionName" placeholder="Enter promotion name" required />
                </div>

                <div class="promotion-group">
                    <label for="promotionDescription">Description</label>
                    <input type="text" id="promotionDescription" name="promotionDescription" placeholder="Enter promotion description" />
                </div>

                <div class="promotion-group">
                    <label for="promotionCode">Promotion Code</label>
                    <input type="text" id="promotionCode" name="promotionCode" placeholder="Enter promotion code (e.g., SAVE20)" required />
                </div>

                <div class="promotion-datetime">
                    <div class="promotion-group half">
                        <label for="promotionStart">Promotion Start Time</label>
                        <input type="datetime-local" id="promotionStart" name="promotionStart" required />
                    </div>
                    <div class="promotion-group half">
                        <label for="promotionEnd">Promotion End Time</label>
                        <input type="datetime-local" id="promotionEnd" name="promotionEnd" />
                        <small class="warning-text">⚠️ If no end time is specified, promotion will run indefinitely until manually stopped</small>
                    </div>
                </div>

                <div class="promotion-note">
                    <strong>✨ Promotion End Time Handling:</strong><br />
                    • If you don't set an end time, the promotion will continue indefinitely<br />
                    • You can always update or stop the promotion later in the event management section<br />
                    • Consider setting a reasonable end time to create urgency for customers
                </div>

                <button type="submit" class="submit-button">Next Step →</button>
            </div>
        </form>
    </div>
</body>
</html>
