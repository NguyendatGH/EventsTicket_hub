package controller;

import dao.NotificationDAO;
import models.Notification;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/admin-notifications")
public class AdminNotificationServlet extends HttpServlet {
    
    private NotificationDAO notificationDAO;
    private Gson gson;
    
    @Override
    public void init() throws ServletException {
        notificationDAO = new NotificationDAO();
        gson = new GsonBuilder()
                .setDateFormat("yyyy-MM-dd HH:mm:ss")
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
            // Check session and get admin user ID
            HttpSession session = request.getSession(false);
            if (session == null) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                out.print("{\"error\": \"Session not found. Please login again.\"}");
                return;
            }
            
            // Get user ID from session - assuming admin has userID stored in session
            Integer userId = (Integer) session.getAttribute("userId");
            String userRole = (String) session.getAttribute("role");
            
            // Check if user is admin
            if (userId == null || (userRole != null && !userRole.equals("admin"))) {
                // If no userId in session or not admin, try to get admin notifications (UserID = 1)
                userId = 1; // Default admin ID
                System.out.println("AdminNotificationServlet: Using default admin ID = 1");
            }
            
            System.out.println("AdminNotificationServlet: Loading notifications for user ID: " + userId);
            
            // Get notifications for admin - multiple strategies
            List<Notification> notifications;
            
            // Strategy 1: Try to get admin-specific notifications
            try {
                notifications = notificationDAO.getAdminDashboardNotifications();
                System.out.println("AdminNotificationServlet: Retrieved " + notifications.size() + " admin dashboard notifications");
                
                // If no admin dashboard notifications, try admin user notifications
                if (notifications.isEmpty()) {
                    notifications = notificationDAO.getAdminUserNotifications();
                    System.out.println("AdminNotificationServlet: Retrieved " + notifications.size() + " admin user notifications");
                }
                
                // If still empty, get recent system notifications
                if (notifications.isEmpty()) {
                    notifications = notificationDAO.getSystemNotifications();
                    System.out.println("AdminNotificationServlet: Retrieved " + notifications.size() + " system notifications");
                }
                
                // Final fallback: get notifications for UserID = 1
                if (notifications.isEmpty()) {
                    notifications = notificationDAO.getNotificationsByUserId(1);
                    System.out.println("AdminNotificationServlet: Retrieved " + notifications.size() + " notifications for UserID=1");
                }
                
            } catch (Exception e) {
                System.err.println("Error with admin notification methods, falling back to basic method: " + e.getMessage());
                notifications = notificationDAO.getNotificationsByUserId(userId);
            }
            
            // Debug: Print each notification
            for (int i = 0; i < Math.min(notifications.size(), 5); i++) { // Only print first 5 for debugging
                Notification n = notifications.get(i);
                System.out.println("Admin Notification " + i + ": ID=" + n.getNotificationID() + 
                                 ", Title=" + n.getTitle() + 
                                 ", UserID=" + n.getUserID() +
                                 ", IsRead=" + n.isIsRead() +
                                 ", CreatedAt=" + n.getCreatedAt());
            }
            
            // Convert to JSON
            String jsonResponse = gson.toJson(notifications);
            
            System.out.println("AdminNotificationServlet: JSON response length: " + jsonResponse.length());
            if (jsonResponse.length() < 1000) { // Only print if response is small
                System.out.println("AdminNotificationServlet: JSON response: " + jsonResponse);
            }
            
            out.print(jsonResponse);
            
        } catch (Exception e) {
            System.err.println("Error in AdminNotificationServlet: " + e.getMessage());
            e.printStackTrace();
            
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\": \"Failed to load notifications: " + e.getMessage() + "\"}");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        PrintWriter out = response.getWriter();
        
        try {
            // Check session
            HttpSession session = request.getSession(false);
            if (session == null) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                out.print("{\"success\": false, \"message\": \"Session expired. Please login again.\"}");
                return;
            }
            
            String action = request.getParameter("action");
            
            if ("markAsRead".equals(action)) {
                String notificationIdStr = request.getParameter("notificationId");
                if (notificationIdStr == null || notificationIdStr.trim().isEmpty()) {
                    out.print("{\"success\": false, \"message\": \"Missing notification ID\"}");
                    return;
                }
                
                try {
                    int notificationId = Integer.parseInt(notificationIdStr);
                    boolean success = notificationDAO.markAsRead(notificationId);
                    
                    if (success) {
                        out.print("{\"success\": true, \"message\": \"Notification marked as read\"}");
                    } else {
                        out.print("{\"success\": false, \"message\": \"Failed to mark notification as read\"}");
                    }
                } catch (NumberFormatException e) {
                    out.print("{\"success\": false, \"message\": \"Invalid notification ID format\"}");
                }
                
            } else if ("markAllAsRead".equals(action)) {
                Integer userId = (Integer) session.getAttribute("userId");
                String userRole = (String) session.getAttribute("role");
                
                // If no userId in session or not admin, use default admin ID
                if (userId == null || (userRole != null && !userRole.equals("admin"))) {
                    userId = 1; // Default admin ID
                }
                
                if (userId != null) {
                    boolean success = notificationDAO.markAllAsRead(userId);
                    
                    if (success) {
                        out.print("{\"success\": true, \"message\": \"All notifications marked as read\"}");
                    } else {
                        out.print("{\"success\": false, \"message\": \"Failed to mark all notifications as read\"}");
                    }
                } else {
                    out.print("{\"success\": false, \"message\": \"User not authenticated\"}");
                }
                
            } else {
                out.print("{\"success\": false, \"message\": \"Invalid action: " + action + "\"}");
            }
            
        } catch (Exception e) {
            System.err.println("Error in AdminNotificationServlet POST: " + e.getMessage());
            e.printStackTrace();
            
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"success\": false, \"message\": \"Server error: " + e.getMessage() + "\"}");
        }
    }
}