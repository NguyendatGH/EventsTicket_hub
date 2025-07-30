package dao;

import models.Notification;
import context.DBConnection;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class NotificationDAO {

    public boolean insertNotification(Notification notification) {
        String sql = "INSERT INTO Notifications (UserID, Title, Content, NotificationType, RelatedID, IsRead, Priority, CreatedAt, ExpiresAt) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, notification.getUserID());
            ps.setString(2, notification.getTitle());
            ps.setString(3, notification.getContent());
            ps.setString(4, notification.getNotificationType());
            ps.setObject(5, notification.getRelatedID());
            ps.setBoolean(6, notification.isIsRead());
            ps.setString(7, notification.getPriority());
            ps.setTimestamp(8, Timestamp.valueOf(notification.getCreatedAt()));
            ps.setObject(9, notification.getExpiresAt() != null ? Timestamp.valueOf(notification.getExpiresAt()) : null);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error inserting notification: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // ===== ADMIN SPECIFIC FUNCTIONS =====
    /**
     * Get all notifications in the system (for admin overview)
     *
     * @param limit Maximum number of notifications to return (0 for no limit)
     * @return List of all notifications ordered by creation date (newest first)
     */
    public List<Notification> getAllNotificationsForAdmin(int limit) {
        List<Notification> notifications = new ArrayList<>();
        String sql = "SELECT * FROM Notifications ORDER BY CreatedAt DESC";

        if (limit > 0) {
            sql = "SELECT TOP " + limit + " * FROM Notifications ORDER BY CreatedAt DESC";
        }

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                notifications.add(mapResultSetToNotification(rs));
            }

        } catch (SQLException e) {
            System.err.println("Error getting all notifications for admin: " + e.getMessage());
            e.printStackTrace();
        }

        return notifications;
    }

    /**
     * Get notifications for admin dashboard (system-wide overview) This
     * includes high priority notifications, recent notifications, etc.
     */
    public List<Notification> getAdminDashboardNotifications() {
        List<Notification> notifications = new ArrayList<>();
        String sql
                = "SELECT * FROM Notifications "
                + "WHERE (Priority = 'high' OR Priority = 'urgent' OR CreatedAt >= DATEADD(HOUR, -24, GETDATE())) "
                + "ORDER BY "
                + "    CASE Priority "
                + "        WHEN 'urgent' THEN 1 "
                + "        WHEN 'high' THEN 2 "
                + "        WHEN 'normal' THEN 3 "
                + "        WHEN 'low' THEN 4 "
                + "        ELSE 5 "
                + "    END, "
                + "    CreatedAt DESC";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                notifications.add(mapResultSetToNotification(rs));
            }

        } catch (SQLException e) {
            System.err.println("Error getting admin dashboard notifications: " + e.getMessage());
            e.printStackTrace();
        }

        return notifications;
    }

    /**
     * Get notifications specifically sent to admin users Assumes admin users
     * have UserID = 1 or role-based identification
     */
    public List<Notification> getAdminUserNotifications() {
        List<Notification> notifications = new ArrayList<>();

        String sql
                = "SELECT TOP 100 n.* FROM Notifications n "
                + "WHERE n.UserID IN ( "
                + "    SELECT u.UserID FROM Users u "
                + "    WHERE u.Role = 'admin' OR u.UserID = 1 "
                + ") "
                + "ORDER BY n.CreatedAt DESC";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                notifications.add(mapResultSetToNotification(rs));
            }

        } catch (SQLException e) {
            System.err.println("Error getting admin user notifications: " + e.getMessage());
            e.printStackTrace();

            // Fallback: get notifications for UserID = 1 (default admin)
            return getNotificationsByUserId(1);
        }

        return notifications;
    }

    /**
     * Get system notifications (notifications about system events, errors,
     * etc.)
     */
    public List<Notification> getSystemNotifications() {
        List<Notification> notifications = new ArrayList<>();
        String sql
                = "SELECT TOP 50 * FROM Notifications "
                + "WHERE NotificationType IN ('system', 'error', 'warning', 'maintenance', 'security') "
                + "ORDER BY CreatedAt DESC";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                notifications.add(mapResultSetToNotification(rs));
            }

        } catch (SQLException e) {
            System.err.println("Error getting system notifications: " + e.getMessage());
            e.printStackTrace();
        }

        return notifications;
    }

    /**
     * Get notification statistics for admin dashboard
     */
    public NotificationStats getNotificationStats() {
        NotificationStats stats = new NotificationStats();

        try (Connection conn = DBConnection.getConnection()) {

            // Total notifications
            String totalSql = "SELECT COUNT(*) FROM Notifications";
            try (PreparedStatement ps = conn.prepareStatement(totalSql); ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    stats.totalNotifications = rs.getInt(1);
                }
            }

            // Unread notifications
            String unreadSql = "SELECT COUNT(*) FROM Notifications WHERE IsRead = 0";
            try (PreparedStatement ps = conn.prepareStatement(unreadSql); ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    stats.unreadNotifications = rs.getInt(1);
                }
            }

            // High priority unread
            String highPrioritySql = "SELECT COUNT(*) FROM Notifications WHERE IsRead = 0 AND Priority IN ('high', 'urgent')";
            try (PreparedStatement ps = conn.prepareStatement(highPrioritySql); ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    stats.highPriorityUnread = rs.getInt(1);
                }
            }

            // Today's notifications
            String todaySql = "SELECT COUNT(*) FROM Notifications WHERE CAST(CreatedAt AS DATE) = CAST(GETDATE() AS DATE)";
            try (PreparedStatement ps = conn.prepareStatement(todaySql); ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    stats.todayNotifications = rs.getInt(1);
                }
            }

        } catch (SQLException e) {
            System.err.println("Error getting notification stats: " + e.getMessage());
            e.printStackTrace();
        }

        return stats;
    }

    // ===== EXISTING FUNCTIONS =====
    public List<Notification> getAllNotifications() {
        List<Notification> notifications = new ArrayList<>();
        String sql = "SELECT * FROM Notifications ORDER BY CreatedAt DESC";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                notifications.add(mapResultSetToNotification(rs));
            }

        } catch (SQLException e) {
            System.err.println("Error getting all notifications: " + e.getMessage());
            e.printStackTrace();
        }

        return notifications;
    }

    public List<Notification> getNotificationsByUserId(int userId) {
        List<Notification> notifications = new ArrayList<>();
        String sql = "SELECT * FROM Notifications WHERE UserID = ? ORDER BY CreatedAt DESC";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                notifications.add(mapResultSetToNotification(rs));
            }

        } catch (SQLException e) {
            System.err.println("Error getting notifications by user ID: " + e.getMessage());
            e.printStackTrace();
        }

        return notifications;
    }

    public int getUnreadNotificationCount(int userId) {
        String sql = "SELECT COUNT(*) FROM Notifications WHERE UserID = ? AND IsRead = 0";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (SQLException e) {
            System.err.println("Error getting unread notification count: " + e.getMessage());
            e.printStackTrace();
        }

        return 0;
    }

    public boolean markAsRead(int notificationId) {
        String sql = "UPDATE Notifications SET IsRead = 1, ReadAt = ? WHERE NotificationID = ?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setTimestamp(1, Timestamp.valueOf(LocalDateTime.now()));
            ps.setInt(2, notificationId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error marking notification as read: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean markAsRead(int notificationId, int userId) {
        String sql = "UPDATE Notifications SET IsRead = 1, ReadAt = ? WHERE NotificationID = ? AND UserID = ?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setTimestamp(1, Timestamp.valueOf(LocalDateTime.now()));
            ps.setInt(2, notificationId);
            ps.setInt(3, userId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error marking notification as read: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean markAllAsRead(int userId) {
        String sql = "UPDATE Notifications SET IsRead = 1, ReadAt = ? WHERE UserID = ? AND IsRead = 0";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setTimestamp(1, Timestamp.valueOf(LocalDateTime.now()));
            ps.setInt(2, userId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error marking all notifications as read: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteNotification(int notificationId) {
        String sql = "DELETE FROM Notifications WHERE NotificationID = ?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, notificationId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error deleting notification: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public List<Notification> getNotificationsByType(String notificationType) {
        List<Notification> notifications = new ArrayList<>();
        String sql = "SELECT * FROM Notifications WHERE NotificationType = ? ORDER BY CreatedAt DESC";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, notificationType);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                notifications.add(mapResultSetToNotification(rs));
            }

        } catch (SQLException e) {
            System.err.println("Error getting notifications by type: " + e.getMessage());
            e.printStackTrace();
        }

        return notifications;
    }

    // ===== HELPER METHODS =====
    /**
     * Map ResultSet to Notification object
     */
    private Notification mapResultSetToNotification(ResultSet rs) throws SQLException {
        Notification notification = new Notification();
        notification.setNotificationID(rs.getInt("NotificationID"));
        notification.setUserID(rs.getInt("UserID"));
        notification.setTitle(rs.getString("Title"));
        notification.setContent(rs.getString("Content"));
        notification.setNotificationType(rs.getString("NotificationType"));
        notification.setRelatedID(rs.getObject("RelatedID") != null ? rs.getInt("RelatedID") : null);
        notification.setIsRead(rs.getBoolean("IsRead"));

        Timestamp readAt = rs.getTimestamp("ReadAt");
        if (readAt != null) {
            notification.setReadAt(readAt.toLocalDateTime());
        }

        notification.setPriority(rs.getString("Priority"));

        Timestamp createdAt = rs.getTimestamp("CreatedAt");
        if (createdAt != null) {
            notification.setCreatedAt(createdAt.toLocalDateTime());
        }

        Timestamp expiresAt = rs.getTimestamp("ExpiresAt");
        if (expiresAt != null) {
            notification.setExpiresAt(expiresAt.toLocalDateTime());
        }

        return notification;
    }

    // ===== INNER CLASSES =====
    /**
     * Notification statistics for admin dashboard
     */
    public static class NotificationStats {

        public int totalNotifications = 0;
        public int unreadNotifications = 0;
        public int highPriorityUnread = 0;
        public int todayNotifications = 0;

        @Override
        public String toString() {
            return String.format("NotificationStats{total=%d, unread=%d, highPriority=%d, today=%d}",
                    totalNotifications, unreadNotifications, highPriorityUnread, todayNotifications);
        }
    }
}
