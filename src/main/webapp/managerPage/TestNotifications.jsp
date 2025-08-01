<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Test Notifications</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background: #f5f5f5;
        }
        .test-container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .test-section {
            margin-bottom: 30px;
            padding: 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
        .test-button {
            background: #007bff;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
            margin: 5px;
        }
        .test-button:hover {
            background: #0056b3;
        }
        .result {
            margin-top: 10px;
            padding: 10px;
            background: #f8f9fa;
            border-radius: 5px;
            font-family: monospace;
            white-space: pre-wrap;
        }
        .success {
            background: #d4edda;
            border: 1px solid #c3e6cb;
            color: #155724;
        }
        .error {
            background: #f8d7da;
            border: 1px solid #f5c6cb;
            color: #721c24;
        }
    </style>
</head>
<body>
    <div class="test-container">
        <h1>Test Notification System</h1>
        
        <div class="test-section">
            <h3>1. Test Content Parsing</h3>
            <button class="test-button" onclick="testContentParsing()">Test Parsing Logic</button>
            <div id="parsingResult" class="result"></div>
        </div>
        
        <div class="test-section">
            <h3>2. Test Notification Loading</h3>
            <button class="test-button" onclick="testNotificationLoading()">Load Notifications</button>
            <div id="loadingResult" class="result"></div>
        </div>
        
        <div class="test-section">
            <h3>3. Create Test Notification</h3>
            <button class="test-button" onclick="createTestNotification()">Create Test Notification</button>
            <div id="createResult" class="result"></div>
        </div>
        
        <div class="test-section">
            <h3>4. Go to Admin Dashboard</h3>
            <a href="AdminDashboard.jsp" class="test-button" style="text-decoration: none; display: inline-block;">Open Admin Dashboard</a>
        </div>
    </div>

    <script>
        function testContentParsing() {
            console.log('🧪 Testing content parsing...');
            const resultDiv = document.getElementById('parsingResult');
            
            // Test refund notification content
            const refundContent = "Người gửi: Nguyễn Văn A (ID: 15) | Lý do: Vé bị hủy do sự kiện bị hoãn | Số tiền: 500,000 VNĐ | Đơn hàng: #123";
            
            let result = 'Testing refund notification parsing:\n';
            result += 'Content: ' + refundContent + '\n\n';
            
            // Test sender parsing
            const senderMatch = refundContent.match(/Người gửi: ([^|]+?)(?=\s*\|\s*Lý do:)/);
            if (senderMatch) {
                result += '✅ Sender parsed: ' + senderMatch[1].trim() + '\n';
            } else {
                result += '❌ Failed to parse sender\n';
            }
            
            // Test reason parsing
            const reasonMatch = refundContent.match(/Lý do: ([^|]+?)(?=\s*\|\s*(?:Số tiền:|Loại hỗ trợ:|Đơn hàng:|Mô tả:))/);
            if (reasonMatch) {
                result += '✅ Reason parsed: ' + reasonMatch[1].trim() + '\n';
            } else {
                result += '❌ Failed to parse reason\n';
            }
            
            // Test amount parsing
            const amountMatch = refundContent.match(/Số tiền: ([^|]+?)(?=\s*\|\s*Đơn hàng:)/);
            if (amountMatch) {
                result += '✅ Amount parsed: ' + amountMatch[1].trim() + '\n';
            } else {
                result += '❌ Failed to parse amount\n';
            }
            
            // Test order ID parsing
            const orderMatch = refundContent.match(/Đơn hàng: #(\d+)/);
            if (orderMatch) {
                result += '✅ Order ID parsed: ' + orderMatch[1] + '\n';
            } else {
                result += '❌ Failed to parse order ID\n';
            }
            
            result += '\n---\n\n';
            
            // Test support notification content
            const supportContent = "Người gửi: Trần Thị B (ID: 23) | Lý do: Không thể thanh toán qua PayOS | Loại hỗ trợ: Thanh toán | Mô tả: Lỗi khi nhập thông tin thẻ";
            
            result += 'Testing support notification parsing:\n';
            result += 'Content: ' + supportContent + '\n\n';
            
            // Test sender parsing for support
            const senderMatch2 = supportContent.match(/Người gửi: ([^|]+?)(?=\s*\|\s*Lý do:)/);
            if (senderMatch2) {
                result += '✅ Sender parsed: ' + senderMatch2[1].trim() + '\n';
            } else {
                result += '❌ Failed to parse sender\n';
            }
            
            // Test reason parsing for support
            const reasonMatch2 = supportContent.match(/Lý do: ([^|]+?)(?=\s*\|\s*(?:Số tiền:|Loại hỗ trợ:|Đơn hàng:|Mô tả:))/);
            if (reasonMatch2) {
                result += '✅ Reason parsed: ' + reasonMatch2[1].trim() + '\n';
            } else {
                result += '❌ Failed to parse reason\n';
            }
            
            // Test support type parsing
            const supportTypeMatch = supportContent.match(/Loại hỗ trợ: ([^|]+?)(?=\s*\|\s*Mô tả:)/);
            if (supportTypeMatch) {
                result += '✅ Support type parsed: ' + supportTypeMatch[1].trim() + '\n';
            } else {
                result += '❌ Failed to parse support type\n';
            }
            
            resultDiv.textContent = result;
            resultDiv.className = 'result success';
        }
        
        function testNotificationLoading() {
            console.log('🧪 Testing notification loading...');
            const resultDiv = document.getElementById('loadingResult');
            resultDiv.textContent = 'Loading notifications...';
            resultDiv.className = 'result';
            
            fetch('${pageContext.request.contextPath}/admin-notifications')
                .then(response => response.json())
                .then(data => {
                    console.log('📋 Loaded notifications:', data);
                    let result = 'Notifications loaded successfully:\n\n';
                    
                    if (Array.isArray(data)) {
                        result += 'Found ' + data.length + ' notifications:\n\n';
                        
                        data.forEach((notification, index) => {
                            result += `Notification ${index + 1}:\n`;
                            result += `  ID: ${notification.notificationID}\n`;
                            result += `  Title: ${notification.title}\n`;
                            result += `  Content: ${notification.content}\n`;
                            result += `  Type: ${notification.notificationType}\n`;
                            result += `  IsRead: ${notification.isIsRead}\n`;
                            result += `  CreatedAt: ${notification.createdAt}\n\n`;
                        });
                    } else {
                        result += 'Response is not an array: ' + JSON.stringify(data, null, 2);
                    }
                    
                    resultDiv.textContent = result;
                    resultDiv.className = 'result success';
                })
                .catch(error => {
                    console.error('❌ Error loading notifications:', error);
                    resultDiv.textContent = 'Error loading notifications: ' + error.message;
                    resultDiv.className = 'result error';
                });
        }
        
        function createTestNotification() {
            console.log('🧪 Creating test notification...');
            const resultDiv = document.getElementById('createResult');
            resultDiv.textContent = 'Creating test notification...';
            resultDiv.className = 'result';
            
            fetch('${pageContext.request.contextPath}/test-notification')
                .then(response => response.text())
                .then(data => {
                    console.log('📋 Test notification response:', data);
                    resultDiv.innerHTML = data;
                    resultDiv.className = 'result success';
                })
                .catch(error => {
                    console.error('❌ Error creating test notification:', error);
                    resultDiv.textContent = 'Error creating test notification: ' + error.message;
                    resultDiv.className = 'result error';
                });
        }
    </script>
</body>
</html> 