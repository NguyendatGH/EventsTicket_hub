package controller;

import dao.NotificationDAO;
import models.Notification;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/test-notification-load")
public class TestNotificationLoadServlet extends HttpServlet {
    
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
            response.getWriter().println("<h1>Test Notification Load</h1>");
            
            // Step 1: Test DAO connection
            response.getWriter().println("<h2>Step 1: Testing DAO</h2>");
            List<Notification> notifications = notificationDAO.getAllNotifications();
            response.getWriter().println("<p>✅ Successfully loaded " + notifications.size() + " notifications from DAO</p>");
            
            // Step 2: Print each notification details
            response.getWriter().println("<h2>Step 2: Notification Details</h2>");
            for (int i = 0; i < notifications.size(); i++) {
                Notification n = notifications.get(i);
                response.getWriter().println("<div style='border: 1px solid #ccc; margin: 10px; padding: 10px;'>");
                response.getWriter().println("<h3>Notification " + (i + 1) + "</h3>");
                response.getWriter().println("<p><strong>ID:</strong> " + n.getNotificationID() + "</p>");
                response.getWriter().println("<p><strong>Title:</strong> " + (n.getTitle() != null ? n.getTitle() : "NULL") + "</p>");
                response.getWriter().println("<p><strong>Content:</strong> " + (n.getContent() != null ? n.getContent() : "NULL") + "</p>");
                response.getWriter().println("<p><strong>Type:</strong> " + (n.getNotificationType() != null ? n.getNotificationType() : "NULL") + "</p>");
                response.getWriter().println("<p><strong>UserID:</strong> " + n.getUserID() + "</p>");
                response.getWriter().println("<p><strong>IsRead:</strong> " + n.isIsRead() + "</p>");
                response.getWriter().println("<p><strong>Priority:</strong> " + (n.getPriority() != null ? n.getPriority() : "NULL") + "</p>");
                response.getWriter().println("<p><strong>CreatedAt:</strong> " + (n.getCreatedAt() != null ? n.getCreatedAt().toString() : "NULL") + "</p>");
                response.getWriter().println("<p><strong>ReadAt:</strong> " + (n.getReadAt() != null ? n.getReadAt().toString() : "NULL") + "</p>");
                response.getWriter().println("<p><strong>ExpiresAt:</strong> " + (n.getExpiresAt() != null ? n.getExpiresAt().toString() : "NULL") + "</p>");
                response.getWriter().println("<p><strong>RelatedID:</strong> " + (n.getRelatedID() != null ? n.getRelatedID() : "NULL") + "</p>");
                response.getWriter().println("</div>");
            }
            
            // Step 3: Test JSON conversion
            response.getWriter().println("<h2>Step 3: Testing JSON Conversion</h2>");
            try {
                com.google.gson.Gson gson = new com.google.gson.GsonBuilder()
                        .setDateFormat("yyyy-MM-dd HH:mm:ss")
                        .serializeNulls()
                        .create();
                
                String json = gson.toJson(notifications);
                response.getWriter().println("<p>✅ JSON conversion successful</p>");
                response.getWriter().println("<p><strong>JSON length:</strong> " + json.length() + "</p>");
                response.getWriter().println("<p><strong>JSON preview:</strong> " + json.substring(0, Math.min(500, json.length())) + "...</p>");
                
            } catch (Exception e) {
                response.getWriter().println("<p style='color: red;'>❌ JSON conversion failed: " + e.getMessage() + "</p>");
                e.printStackTrace();
            }
            
            response.getWriter().println("<br><a href='${pageContext.request.contextPath}/managerPage/TestNotifications.jsp'>Back to Test Page</a>");
            
        } catch (Exception e) {
            response.getWriter().println("<h1 style='color: red;'>❌ Error</h1>");
            response.getWriter().println("<p style='color: red;'>Error: " + e.getMessage() + "</p>");
            e.printStackTrace();
        }
    }
} 