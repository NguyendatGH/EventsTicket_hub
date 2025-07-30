/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import models.Notification;
import context.DBConnection; // Your DB connection utility

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class NotificationDAO {

    // Fetches all notifications for a specific user, ordered by creation date
    public List<Notification> getNotificationsByUserId(int userId) {
        List<Notification> notifications = new ArrayList<>();
        // Simplified query without GETDATE() to avoid compatibility issues
        String sql = "SELECT * FROM Notifications WHERE UserID = ? ORDER BY CreatedAt DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    notifications.add(mapRowToNotification(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error fetching notifications for user " + userId + ": " + e.getMessage());
            e.printStackTrace();
        }
        return notifications;
    }

    // Gets the count of unread notifications for a user
    public int getUnreadNotificationCount(int userId) {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM Notifications WHERE UserID = ? AND IsRead = 0";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    count = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error fetching unread notification count for user " + userId + ": " + e.getMessage());
            e.printStackTrace();
        }
        return count;
    }

    // Lấy tất cả notifications từ database (không phân biệt user)
    public List<Notification> getAllNotifications() {
        List<Notification> notifications = new ArrayList<>();
        String sql = "SELECT * FROM Notifications ORDER BY CreatedAt DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                notifications.add(mapRowToNotification(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error fetching all notifications: " + e.getMessage());
            e.printStackTrace();
        }
        return notifications;
    }

    // Lấy tổng số notifications
    public int getTotalNotificationCount() {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM Notifications";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Error fetching total notification count: " + e.getMessage());
            e.printStackTrace();
        }
        return count;
    }

    // Marks a specific notification as read
    public boolean markNotificationAsRead(int notificationId, int userId) {
        String sql = "UPDATE Notifications SET IsRead = 1, ReadAt = GETDATE() WHERE NotificationID = ? AND UserID = ? AND IsRead = 0";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, notificationId);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error marking notification " + notificationId + " as read: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // Marks all unread notifications for a user as read
    public boolean markAllNotificationsAsRead(int userId) {
        String sql = "UPDATE Notifications SET IsRead = 1, ReadAt = GETDATE() WHERE UserID = ? AND IsRead = 0";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            return ps.executeUpdate() > 0; // Returns true if any rows were updated

        } catch (SQLException e) {
            System.err.println("Error marking all notifications as read for user " + userId + ": " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // Thêm notification mới vào DB
    public boolean insertNotification(Notification notification) {
        String sql = "INSERT INTO Notifications (UserID, Title, Content, NotificationType, RelatedID, IsRead, CreatedAt, Priority) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, notification.getUserID());
            ps.setString(2, notification.getTitle());
            ps.setString(3, notification.getContent());
            
            // Đảm bảo NotificationType hợp lệ
            String notificationType = notification.getNotificationType();
            if (notificationType == null || !isValidNotificationType(notificationType)) {
                notificationType = "system"; // Default to system if invalid
            }
            ps.setString(4, notificationType);
            
            if (notification.getRelatedID() != null) {
                ps.setInt(5, notification.getRelatedID());
            } else {
                ps.setNull(5, java.sql.Types.INTEGER);
            }
            ps.setBoolean(6, notification.isIsRead());
            ps.setTimestamp(7, java.sql.Timestamp.valueOf(notification.getCreatedAt()));
            ps.setString(8, notification.getPriority());
            
            int result = ps.executeUpdate();
            System.out.println("Insert notification result: " + result);
            return result > 0;
        } catch (SQLException e) {
            System.err.println("Error inserting notification: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    // Kiểm tra NotificationType có hợp lệ không
    private boolean isValidNotificationType(String type) {
        return type != null && (type.equals("order") || type.equals("event") || 
                               type.equals("promotion") || type.equals("system") || 
                               type.equals("message"));
    }

    // Helper method to map a ResultSet row to a Notification object
    private Notification mapRowToNotification(ResultSet rs) throws SQLException {
        Notification notification = new Notification();
        notification.setNotificationID(rs.getInt("NotificationID"));
        notification.setUserID(rs.getInt("UserID"));
        notification.setTitle(rs.getString("Title"));
        notification.setContent(rs.getString("Content"));
        notification.setNotificationType(rs.getString("NotificationType"));

        // Handle nullable RelatedID
        Object relatedIdObj = rs.getObject("RelatedID");
        if (relatedIdObj instanceof Integer) {
            notification.setRelatedID((Integer) relatedIdObj);
        } else {
            notification.setRelatedID(null);
        }

        notification.setIsRead(rs.getBoolean("IsRead"));

        Timestamp readAtTimestamp = rs.getTimestamp("ReadAt");
        if (readAtTimestamp != null) {
            notification.setReadAt(readAtTimestamp.toLocalDateTime());
        }

        notification.setPriority(rs.getString("Priority"));
        notification.setCreatedAt(rs.getTimestamp("CreatedAt").toLocalDateTime());

        Timestamp expiresAtTimestamp = rs.getTimestamp("ExpiresAt");
        if (expiresAtTimestamp != null) {
            notification.setExpiresAt(expiresAtTimestamp.toLocalDateTime());
        }
        return notification;
    }
}