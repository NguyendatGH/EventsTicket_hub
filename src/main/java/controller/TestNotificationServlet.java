package controller;

import models.Notification;
import service.NotificationService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import utils.LocalDateTimeAdapter;

import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDateTime;
import java.util.List;
import dao.NotificationDAO;

@WebServlet("/test-notification")
public class TestNotificationServlet extends HttpServlet {

    private NotificationService notificationService;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        notificationService = new NotificationService();
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
            // First, check what's already in the database
            System.out.println("🔍 Checking existing notifications in database...");
            NotificationDAO notificationDAO = new NotificationDAO();
            List<models.Notification> existingNotifications = notificationDAO.getNotificationsByUserId(1);
            System.out.println("📋 Found " + existingNotifications.size() + " existing notifications for admin");
            
            for (int i = 0; i < existingNotifications.size(); i++) {
                models.Notification n = existingNotifications.get(i);
                System.out.println("📋 Existing notification " + (i+1) + ": ID=" + n.getNotificationID() + 
                                 ", Title='" + n.getTitle() + "'" +
                                 ", Content='" + n.getContent() + "'" +
                                 ", IsRead=" + n.isIsRead() +
                                 ", Type='" + n.getNotificationType() + "'");
            }

            System.out.println("🧪 Creating test notification for admin...");

            Notification testNotification = new Notification();
            testNotification.setUserID(1); // Admin ID
            testNotification.setNotificationType("system");
            testNotification.setTitle("Test Notification");
            testNotification.setContent("Đây là thông báo test từ server.");
            testNotification.setRelatedID(null);
            testNotification.setIsRead(false);
            testNotification.setCreatedAt(LocalDateTime.now());
            testNotification.setPriority("normal");

            boolean saved = notificationService.insertNotification(testNotification);
            System.out.println("💾 Test notification saved to database: " + saved);

            if (saved) {
                System.out.println("📡 Sending real-time test notification to admin...");
                NotificationWebSocket.sendNotificationToUser(1, testNotification);
                System.out.println("✅ Test notification sent to admin");

                // Test JSON serialization
                String testJson = gson.toJson(testNotification);
                System.out.println("📋 Test notification JSON: " + testJson);

                out.print(gson.toJson(new TestResponse(true, "Test notification created and sent successfully", testNotification)));
            } else {
                out.print(gson.toJson(new TestResponse(false, "Failed to save test notification to database", null)));
            }

        } catch (Exception e) {
            System.err.println("❌ Error creating test notification: " + e.getMessage());
            e.printStackTrace();
            out.print(gson.toJson(new TestResponse(false, "Error: " + e.getMessage(), null)));
        }
    }

    private static class TestResponse {
        private boolean success;
        private String message;
        private Notification notification;

        public TestResponse(boolean success, String message, Notification notification) {
            this.success = success;
            this.message = message;
            this.notification = notification;
        }

        public boolean isSuccess() { return success; }
        public String getMessage() { return message; }
        public Notification getNotification() { return notification; }
    }
} 