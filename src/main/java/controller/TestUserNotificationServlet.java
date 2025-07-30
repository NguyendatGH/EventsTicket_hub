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

@WebServlet("/test-user-notification")
public class TestUserNotificationServlet extends HttpServlet {
    
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
            // Create test notifications for different users
            String[] userNames = {"Nguyễn Văn A", "Trần Thị B", "Lê Văn C", "Phạm Thị D"};
            String[] notificationTypes = {"order", "event", "promotion", "system"};
            String[] priorities = {"low", "normal", "high", "urgent"};
            
            response.getWriter().println("<h1>Creating Test Notifications for Different Users</h1>");
            
            for (int i = 2; i <= 5; i++) { // User IDs 2-5
                Notification testNotification = new Notification();
                testNotification.setUserID(i);
                testNotification.setTitle("Thông báo test cho User " + userNames[i-2]);
                testNotification.setContent("Đây là thông báo test cho user ID " + i + " - " + userNames[i-2]);
                testNotification.setNotificationType(notificationTypes[(i-2) % notificationTypes.length]);
                testNotification.setIsRead(false);
                testNotification.setPriority(priorities[(i-2) % priorities.length]);
                testNotification.setCreatedAt(LocalDateTime.now());
                
                boolean success = notificationDAO.insertNotification(testNotification);
                
                if (success) {
                    response.getWriter().println("<p style='color: green;'>✅ Created notification for User " + i + " (" + userNames[i-2] + ")</p>");
                    response.getWriter().println("<ul>");
                    response.getWriter().println("<li>Title: " + testNotification.getTitle() + "</li>");
                    response.getWriter().println("<li>Type: " + testNotification.getNotificationType() + "</li>");
                    response.getWriter().println("<li>Priority: " + testNotification.getPriority() + "</li>");
                    response.getWriter().println("<li>Created at: " + testNotification.getCreatedAt() + "</li>");
                    response.getWriter().println("</ul>");
                } else {
                    response.getWriter().println("<p style='color: red;'>❌ Failed to create notification for User " + i + "</p>");
                }
            }
            
            response.getWriter().println("<br><h2>Summary:</h2>");
            response.getWriter().println("<p>Created test notifications for users 2-5</p>");
            response.getWriter().println("<p>Admin (User ID 1) should only see notifications for User ID 1</p>");
            response.getWriter().println("<p>Other users should only see their own notifications</p>");
            
            response.getWriter().println("<br><a href='${pageContext.request.contextPath}/managerPage/TestNotifications.jsp'>Back to Test Page</a>");
            
        } catch (Exception e) {
            System.err.println("Error creating test user notifications: " + e.getMessage());
            e.printStackTrace();
            response.getWriter().println("<h1>❌ Error</h1>");
            response.getWriter().println("<p>Error: " + e.getMessage() + "</p>");
        }
    }
} 