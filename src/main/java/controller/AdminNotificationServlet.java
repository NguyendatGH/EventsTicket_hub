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