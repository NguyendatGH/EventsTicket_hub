/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;
import dao.NotificationDAO;
import models.Notification;

import java.util.List;

public class NotificationService {

    private final NotificationDAO notificationDAO;

    public NotificationService() {
        this.notificationDAO = new NotificationDAO();
    }

    // Fetches all active notifications for a user
    public List<Notification> getUserNotifications(int userId) {
        return notificationDAO.getNotificationsByUserId(userId);
    }

    // Gets the count of unread notifications for a user
    public int getUnreadNotificationsCount(int userId) {
        return notificationDAO.getUnreadNotificationCount(userId);
    }

    // Marks a specific notification as read
    public boolean markNotificationRead(int notificationId, int userId) {
        // You could add more business logic here, e.g., validation, logging specific read events
        if (notificationId <= 0 || userId <= 0) {
            System.err.println("Invalid notificationId or userId for marking as read.");
            return false;
        }
        return notificationDAO.markAsRead(notificationId, userId);
    }

    // Marks all unread notifications for a user as read
    public boolean markAllNotificationsRead(int userId) {
        if (userId <= 0) {
            System.err.println("Invalid userId for marking all as read.");
            return false;
        }
        return notificationDAO.markAllAsRead(userId);
    }

}
