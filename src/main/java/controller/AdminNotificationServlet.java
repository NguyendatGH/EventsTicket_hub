package controller;

import dao.NotificationDAO;
import models.Notification;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import utils.LocalDateTimeAdapter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet("/admin-notifications")
public class AdminNotificationServlet extends HttpServlet {
    
    private NotificationDAO notificationDAO;
    private Gson gson;
    
    @Override
    public void init() throws ServletException {
        notificationDAO = new NotificationDAO();
        gson = new GsonBuilder()
                .registerTypeAdapter(LocalDateTime.class, new LocalDateTimeAdapter())
                .serializeNulls()
                .create();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        PrintWriter out = response.getWriter();
        
        try {
            // Get notifications for admin (UserID = 1)
            List<Notification> notifications = notificationDAO.getNotificationsByUserId(1);
            
            System.out.println("🔍 AdminNotificationServlet - Found " + notifications.size() + " notifications");
            
            // If no notifications exist, create some test notifications
            if (notifications.isEmpty()) {
                System.out.println("📝 No notifications found, creating test notifications...");

                // Create test refund notification with detailed content
                Notification refundNotification = new Notification();
                refundNotification.setUserID(1);
                refundNotification.setNotificationType("order");
                refundNotification.setTitle("Yêu cầu hoàn tiền mới");
                refundNotification.setContent("Người gửi: Nguyễn Văn A (ID: 15) | Lý do: Vé bị hủy do sự kiện bị hoãn | Số tiền: 500,000 VNĐ | Đơn hàng: #123");
                refundNotification.setRelatedID(123);
                refundNotification.setIsRead(false);
                refundNotification.setCreatedAt(LocalDateTime.now());
                refundNotification.setPriority("high");

                notificationDAO.insertNotification(refundNotification);
                notifications.add(refundNotification);

                // Create test support notification with detailed content
                Notification supportNotification = new Notification();
                supportNotification.setUserID(1);
                supportNotification.setNotificationType("system");
                supportNotification.setTitle("Yêu cầu hỗ trợ mới");
                supportNotification.setContent("Người gửi: Trần Thị B (ID: 23) | Lý do: Không thể thanh toán qua PayOS | Loại hỗ trợ: Thanh toán | Mô tả: Lỗi khi nhập thông tin thẻ");
                supportNotification.setRelatedID(null);
                supportNotification.setIsRead(false);
                supportNotification.setCreatedAt(LocalDateTime.now());
                supportNotification.setPriority("normal");

                notificationDAO.insertNotification(supportNotification);
                notifications.add(supportNotification);

                // Create more test notifications to test the count
                for (int i = 1; i <= 4; i++) {
                    Notification testNotification = new Notification();
                    testNotification.setUserID(1);
                    testNotification.setNotificationType("order");
                    testNotification.setTitle("Yêu cầu hoàn tiền #" + (i + 1));
                    testNotification.setContent("Người gửi: User " + (i + 10) + " | Lý do: Không hài lòng với dịch vụ | Số tiền: " + (100000 + i * 50000) + " VNĐ | Đơn hàng: #" + (200 + i));
                    testNotification.setRelatedID(200 + i);
                    testNotification.setIsRead(false);
                    testNotification.setCreatedAt(LocalDateTime.now().minusMinutes(i * 30));
                    testNotification.setPriority("normal");

                    notificationDAO.insertNotification(testNotification);
                    notifications.add(testNotification);
                }

                System.out.println("✅ Created " + notifications.size() + " test notifications");
            }
            
            
            
            for (int i = 0; i < notifications.size(); i++) {
                Notification n = notifications.get(i);
                System.out.println("📋 Notification " + (i+1) + ": ID=" + n.getNotificationID() + 
                                 ", Title='" + n.getTitle() + "'" +
                                 ", Content='" + n.getContent() + "'" +
                                 ", IsRead=" + n.isIsRead() +
                                 ", Type='" + n.getNotificationType() + "'");
                
                // Test individual serialization
                String individualJson = gson.toJson(n);
                System.out.println("📋 Individual JSON for notification " + (i+1) + ": " + individualJson);
                
                // Test content parsing
                String content = n.getContent();
                if (content != null && !content.isEmpty()) {
                    System.out.println("🔍 Testing content parsing for notification " + (i+1) + ":");
                    System.out.println("   Raw content: '" + content + "'");
                    
                    // Test sender parsing
                    java.util.regex.Pattern senderPattern = java.util.regex.Pattern.compile("Người gửi: ([^|]+?)(?=\\s*\\|\\s*Lý do:)");
                    java.util.regex.Matcher senderMatcher = senderPattern.matcher(content);
                    if (senderMatcher.find()) {
                        System.out.println("   ✅ Parsed sender: '" + senderMatcher.group(1).trim() + "'");
                    } else {
                        System.out.println("   ❌ Failed to parse sender");
                    }
                    
                    // Test reason parsing
                    java.util.regex.Pattern reasonPattern = java.util.regex.Pattern.compile("Lý do: ([^|]+?)(?=\\s*\\|\\s*(?:Số tiền:|Loại hỗ trợ:|Đơn hàng:|Mô tả:))");
                    java.util.regex.Matcher reasonMatcher = reasonPattern.matcher(content);
                    if (reasonMatcher.find()) {
                        System.out.println("   ✅ Parsed reason: '" + reasonMatcher.group(1).trim() + "'");
                    } else {
                        System.out.println("   ❌ Failed to parse reason");
                    }
                    
                    // Test amount parsing
                    java.util.regex.Pattern amountPattern = java.util.regex.Pattern.compile("Số tiền: ([^|]+?)(?=\\s*\\|\\s*Đơn hàng:)");
                    java.util.regex.Matcher amountMatcher = amountPattern.matcher(content);
                    if (amountMatcher.find()) {
                        System.out.println("   ✅ Parsed amount: '" + amountMatcher.group(1).trim() + "'");
                    } else {
                        System.out.println("   ❌ Failed to parse amount");
                    }
                    
                    // Test order ID parsing
                    java.util.regex.Pattern orderPattern = java.util.regex.Pattern.compile("Đơn hàng: #(\\d+)");
                    java.util.regex.Matcher orderMatcher = orderPattern.matcher(content);
                    if (orderMatcher.find()) {
                        System.out.println("   ✅ Parsed order ID: '" + orderMatcher.group(1) + "'");
                    } else {
                        System.out.println("   ❌ Failed to parse order ID");
                    }
                    
                    // Test support type parsing
                    java.util.regex.Pattern supportTypePattern = java.util.regex.Pattern.compile("Loại hỗ trợ: ([^|]+?)(?=\\s*\\|\\s*Mô tả:)");
                    java.util.regex.Matcher supportTypeMatcher = supportTypePattern.matcher(content);
                    if (supportTypeMatcher.find()) {
                        System.out.println("   ✅ Parsed support type: '" + supportTypeMatcher.group(1).trim() + "'");
                    } else {
                        System.out.println("   ❌ Failed to parse support type");
                    }
                }
            }
            
            String jsonResponse = gson.toJson(notifications);
            System.out.println("📋 Full JSON Response: " + jsonResponse);
            
            out.print(jsonResponse);
            
        } catch (Exception e) {
            System.err.println("❌ Error loading admin notifications: " + e.getMessage());
            e.printStackTrace();
            out.print(gson.toJson(new ErrorResponse("Failed to load notifications: " + e.getMessage())));
        }
    }
    
    private static class ErrorResponse {
        private String error;
        
        public ErrorResponse(String error) {
            this.error = error;
        }
        
        public String getError() { return error; }
    }
} 