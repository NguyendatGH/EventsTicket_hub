package dao;

import models.Notification;
import java.util.List;

public class TestNotificationDAO {
    
    public static void main(String[] args) {
        NotificationDAO notificationDAO = new NotificationDAO();
        
        System.out.println("=== Testing NotificationDAO ===");
        
        // Test 1: Get all notifications for admin (ID = 1)
        System.out.println("\n1. Testing getAllNotifications for admin (ID = 1):");
        List<Notification> notifications = notificationDAO.getNotificationsByUserId(1);
        System.out.println("Số lượng notifications: " + notifications.size());
        
        for (Notification notif : notifications) {
            System.out.println("ID: " + notif.getNotificationID());
            System.out.println("Title: " + notif.getTitle());
            System.out.println("Content: " + notif.getContent());
            System.out.println("Type: " + notif.getNotificationType());
            System.out.println("IsRead: " + notif.isIsRead());
            System.out.println("Priority: " + notif.getPriority());
            System.out.println("CreatedAt: " + notif.getCreatedAt());
            System.out.println("---");
        }
        
        // Test 2: Get unread count
        System.out.println("\n2. Testing getUnreadNotificationCount:");
        int unreadCount = notificationDAO.getUnreadNotificationCount(1);
        System.out.println("Unread count: " + unreadCount);
        
        // Test 3: Test with different user IDs
        System.out.println("\n3. Testing with different user IDs:");
        for (int userId = 1; userId <= 5; userId++) {
            List<Notification> userNotifications = notificationDAO.getNotificationsByUserId(userId);
            int userUnreadCount = notificationDAO.getUnreadNotificationCount(userId);
            System.out.println("User " + userId + ": " + userNotifications.size() + " notifications, " + userUnreadCount + " unread");
        }
        
        System.out.println("\n=== Test completed ===");
    }
} 