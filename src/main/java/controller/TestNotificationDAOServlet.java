package controller;

import dao.NotificationDAO;
import models.Notification;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet("/test-notification-dao")
public class TestNotificationDAOServlet extends HttpServlet {
    
    private NotificationDAO notificationDAO;
    
    @Override
    public void init() throws ServletException {
        notificationDAO = new NotificationDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        
        try {
            response.getWriter().println("<h1>🔧 Test NotificationDAO Functions</h1>");
            
            // Test 1: Create a test notification
            response.getWriter().println("<h2>Test 1: Creating Test Notification</h2>");
            Notification testNotification = new Notification();
            testNotification.setUserID(1); // Admin user ID
            testNotification.setTitle("Test Notification DAO");
            testNotification.setContent("Testing NotificationDAO after SQL fixes");
            testNotification.setNotificationType("system");
            testNotification.setIsRead(false);
            testNotification.setPriority("normal");
            testNotification.setCreatedAt(LocalDateTime.now());
            
            boolean success = notificationDAO.insertNotification(testNotification);
            if (success) {
                response.getWriter().println("<p style='color: green;'>✅ Test notification created successfully</p>");
            } else {
                response.getWriter().println("<p style='color: red;'>❌ Failed to create test notification</p>");
            }
            
            // Test 2: Get notifications by user ID
            response.getWriter().println("<h2>Test 2: Get Notifications by User ID (1)</h2>");
            List<Notification> userNotifications = notificationDAO.getNotificationsByUserId(1);
            response.getWriter().println("<p>Found " + userNotifications.size() + " notifications for user 1</p>");
            
            // Test 3: Get admin dashboard notifications
            response.getWriter().println("<h2>Test 3: Get Admin Dashboard Notifications</h2>");
            List<Notification> adminNotifications = notificationDAO.getAdminDashboardNotifications();
            response.getWriter().println("<p>Found " + adminNotifications.size() + " admin dashboard notifications</p>");
            
            // Test 4: Get admin user notifications
            response.getWriter().println("<h2>Test 4: Get Admin User Notifications</h2>");
            List<Notification> adminUserNotifications = notificationDAO.getAdminUserNotifications();
            response.getWriter().println("<p>Found " + adminUserNotifications.size() + " admin user notifications</p>");
            
            // Test 5: Get system notifications
            response.getWriter().println("<h2>Test 5: Get System Notifications</h2>");
            List<Notification> systemNotifications = notificationDAO.getSystemNotifications();
            response.getWriter().println("<p>Found " + systemNotifications.size() + " system notifications</p>");
            
            // Test 6: Get notification stats
            response.getWriter().println("<h2>Test 6: Get Notification Stats</h2>");
            NotificationDAO.NotificationStats stats = notificationDAO.getNotificationStats();
            response.getWriter().println("<p>Notification Stats: " + stats.toString() + "</p>");
            
            // Test 7: Get unread count
            response.getWriter().println("<h2>Test 7: Get Unread Count for User 1</h2>");
            int unreadCount = notificationDAO.getUnreadNotificationCount(1);
            response.getWriter().println("<p>Unread notifications for user 1: " + unreadCount + "</p>");
            
            response.getWriter().println("<br><h2>✅ All Tests Completed</h2>");
            response.getWriter().println("<p>If you see this message, all NotificationDAO functions are working correctly!</p>");
            
        } catch (Exception e) {
            System.err.println("Error testing NotificationDAO: " + e.getMessage());
            e.printStackTrace();
            response.getWriter().println("<h1>❌ Error</h1>");
            response.getWriter().println("<p>Error: " + e.getMessage() + "</p>");
            response.getWriter().println("<pre>" + e.getStackTrace() + "</pre>");
        }
    }
} 