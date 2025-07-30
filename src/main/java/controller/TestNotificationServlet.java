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

@WebServlet("/test-notification")
public class TestNotificationServlet extends HttpServlet {
    
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
            // Create a test notification for admin
            Notification testNotification = new Notification();
            testNotification.setUserID(1); // Admin user ID
            testNotification.setTitle("Thông báo test cho Admin");
            testNotification.setContent("Đây là thông báo test để kiểm tra chức năng notification cho admin");
            testNotification.setNotificationType("system");
            testNotification.setIsRead(false);
            testNotification.setPriority("normal");
            testNotification.setCreatedAt(LocalDateTime.now());
            
            boolean success = notificationDAO.insertNotification(testNotification);
            
            if (success) {
                response.getWriter().println("<h1>✅ Test notification created successfully!</h1>");
                response.getWriter().println("<p>Notification ID: " + testNotification.getNotificationID() + "</p>");
                response.getWriter().println("<p>Title: " + testNotification.getTitle() + "</p>");
                response.getWriter().println("<p>Content: " + testNotification.getContent() + "</p>");
                response.getWriter().println("<p>Created at: " + testNotification.getCreatedAt() + "</p>");
                response.getWriter().println("<br><a href='${pageContext.request.contextPath}/admin-servlet/dashboard'>Go to Dashboard</a>");
            } else {
                response.getWriter().println("<h1>❌ Failed to create test notification</h1>");
            }
            
        } catch (Exception e) {
            System.err.println("Error creating test notification: " + e.getMessage());
            e.printStackTrace();
            response.getWriter().println("<h1>❌ Error: " + e.getMessage() + "</h1>");
        }
    }
} 