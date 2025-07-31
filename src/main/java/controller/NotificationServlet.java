package controller;

import dao.NotificationDAO;
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

@WebServlet("/notification-servlet")
public class NotificationServlet extends HttpServlet {
    
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
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        PrintWriter out = response.getWriter();
        
        try {
            String action = request.getParameter("action");
            
            if ("markRead".equals(action)) {
                int notificationId = Integer.parseInt(request.getParameter("notificationId"));
                int userId = Integer.parseInt(request.getParameter("userId"));
                
                boolean success = notificationDAO.markAsRead(notificationId, userId);
                
                if (success) {
                    out.print(gson.toJson(new SuccessResponse("Notification marked as read")));
                } else {
                    out.print(gson.toJson(new ErrorResponse("Failed to mark notification as read")));
                }
                
            } else if ("markAllRead".equals(action)) {
                int userId = Integer.parseInt(request.getParameter("userId"));
                
                boolean success = notificationDAO.markAllAsRead(userId);
                
                if (success) {
                    out.print(gson.toJson(new SuccessResponse("All notifications marked as read")));
                } else {
                    out.print(gson.toJson(new ErrorResponse("Failed to mark all notifications as read")));
                }
                
            } else {
                out.print(gson.toJson(new ErrorResponse("Invalid action")));
            }
            
        } catch (Exception e) {
            System.err.println("❌ Error in NotificationServlet: " + e.getMessage());
            e.printStackTrace();
            out.print(gson.toJson(new ErrorResponse("Error: " + e.getMessage())));
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        PrintWriter out = response.getWriter();
        
        try {
            String action = request.getParameter("action");
            
            if ("getNotifications".equals(action)) {
                int userId = Integer.parseInt(request.getParameter("userId"));
                
                List<models.Notification> notifications = notificationDAO.getNotificationsByUserId(userId);
                int unreadCount = notificationDAO.getUnreadNotificationCount(userId);
                
                NotificationResponse notificationResponse = new NotificationResponse();
                notificationResponse.setNotifications(notifications);
                notificationResponse.setUnreadCount(unreadCount);
                
                out.print(gson.toJson(notificationResponse));
                
            } else if ("getUnreadCount".equals(action)) {
                int userId = Integer.parseInt(request.getParameter("userId"));
                
                int unreadCount = notificationDAO.getUnreadNotificationCount(userId);
                
                UnreadCountResponse unreadResponse = new UnreadCountResponse();
                unreadResponse.setUnreadCount(unreadCount);
                
                out.print(gson.toJson(unreadResponse));
                
            } else {
                out.print(gson.toJson(new ErrorResponse("Invalid action")));
            }
            
        } catch (Exception e) {
            System.err.println("❌ Error in NotificationServlet GET: " + e.getMessage());
            e.printStackTrace();
            out.print(gson.toJson(new ErrorResponse("Error: " + e.getMessage())));
        }
    }
    
    private static class SuccessResponse {
        private String message;
        
        public SuccessResponse(String message) {
            this.message = message;
        }
        
        public String getMessage() { return message; }
    }
    
    private static class ErrorResponse {
        private String error;
        
        public ErrorResponse(String error) {
            this.error = error;
        }
        
        public String getError() { return error; }
    }
    
    private static class NotificationResponse {
        private List<models.Notification> notifications;
        private int unreadCount;
        
        public List<models.Notification> getNotifications() { return notifications; }
        public void setNotifications(List<models.Notification> notifications) { this.notifications = notifications; }
        
        public int getUnreadCount() { return unreadCount; }
        public void setUnreadCount(int unreadCount) { this.unreadCount = unreadCount; }
    }
    
    private static class UnreadCountResponse {
        private int unreadCount;
        
        public int getUnreadCount() { return unreadCount; }
        public void setUnreadCount(int unreadCount) { this.unreadCount = unreadCount; }
    }
} 