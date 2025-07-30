package dao;

import models.SupportItem;
import models.SupportAttachment;
import context.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

public class SupportDAO {
    private static final Logger logger = Logger.getLogger(SupportDAO.class.getName());

    public boolean createSupportRequest(SupportItem supportItem) {
        String sql = "INSERT INTO SupportItems (UserID, FromEmail, ToEmail, Subject, SendDate, SendTimestamp, Content, Status, Priority, Category, CreatedDate, LastModified, EventID, OrderID) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setInt(1, supportItem.getUserId());
            ps.setString(2, supportItem.getFromEmail());
            ps.setString(3, supportItem.getToEmail());
            ps.setString(4, supportItem.getSubject());
            ps.setDate(5, supportItem.getSendDate());
            ps.setTimestamp(6, supportItem.getSendTimestamp());
            ps.setString(7, supportItem.getContent());
            ps.setString(8, supportItem.getStatus());
            ps.setString(9, supportItem.getPriority());
            ps.setString(10, supportItem.getCategory());
            ps.setDate(11, supportItem.getCreatedDate());
            ps.setDate(12, supportItem.getLastModified());
            ps.setObject(13, supportItem.getEventId());
            ps.setObject(14, supportItem.getOrderId());
            
            int result = ps.executeUpdate();
            if (result > 0) {
                // Get the generated support ID
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    supportItem.setSupportId(rs.getInt(1));
                }
                return true;
            }
            return false;
            
        } catch (SQLException e) {
            logger.severe("Error creating support request: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public List<SupportItem> getAllSupportRequests() {
        List<SupportItem> supportItems = new ArrayList<>();
        String sql = "SELECT * FROM SupportItems ORDER BY SendTimestamp DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                SupportItem item = mapRowToSupportItem(rs);
                // Load attachments for this support item
                loadAttachmentsForSupportItem(item);
                supportItems.add(item);
            }
            
        } catch (SQLException e) {
            logger.severe("Error getting all support requests: " + e.getMessage());
            e.printStackTrace();
        }
        
        return supportItems;
    }

    public List<SupportItem> getSupportRequestsByStatus(String status) {
        List<SupportItem> supportItems = new ArrayList<>();
        String sql = "SELECT * FROM SupportItems WHERE Status = ? ORDER BY SendTimestamp DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                SupportItem item = mapRowToSupportItem(rs);
                // Load attachments for this support item
                loadAttachmentsForSupportItem(item);
                supportItems.add(item);
            }
            
        } catch (SQLException e) {
            logger.severe("Error getting support requests by status: " + e.getMessage());
            e.printStackTrace();
        }
        
        return supportItems;
    }

    public SupportItem getSupportRequestById(int supportId) {
        String sql = "SELECT * FROM SupportItems WHERE SupportID = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, supportId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                SupportItem item = mapRowToSupportItem(rs);
                // Load attachments for this support item
                loadAttachmentsForSupportItem(item);
                return item;
            }
            
        } catch (SQLException e) {
            logger.severe("Error getting support request by ID: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }

    public boolean updateSupportRequest(SupportItem supportItem) {
        String sql = "UPDATE SupportItems SET Status = ?, AdminResponse = ?, AssignedAdminID = ?, LastModified = ? WHERE SupportID = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, supportItem.getStatus());
            ps.setString(2, supportItem.getAdminResponse());
            ps.setObject(3, supportItem.getAssignedAdminId() > 0 ? supportItem.getAssignedAdminId() : null);
            ps.setDate(4, supportItem.getLastModified());
            ps.setInt(5, supportItem.getSupportId());
            
            int result = ps.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            logger.severe("Error updating support request: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public List<SupportItem> getSupportRequestsByUserEmail(String userEmail) {
        List<SupportItem> supportItems = new ArrayList<>();
        String sql = "SELECT s.* FROM SupportItems s " +
                    "JOIN Users u ON s.UserID = u.Id " +
                    "WHERE u.Email = ? ORDER BY s.SendTimestamp DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, userEmail);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                SupportItem item = mapRowToSupportItem(rs);
                // Load attachments for this support item
                loadAttachmentsForSupportItem(item);
                supportItems.add(item);
            }
            
        } catch (SQLException e) {
            logger.severe("Error getting support requests by user email: " + e.getMessage());
            e.printStackTrace();
        }
        
        return supportItems;
    }

    public int getPendingSupportRequestsCount() {
        String sql = "SELECT COUNT(*) FROM SupportItems WHERE Status = 'PENDING'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (SQLException e) {
            logger.severe("Error getting pending support requests count: " + e.getMessage());
            e.printStackTrace();
        }
        
        return 0;
    }

    private SupportItem mapRowToSupportItem(ResultSet rs) throws SQLException {
        SupportItem item = new SupportItem(
            rs.getInt("SupportID"),
            rs.getString("FromEmail"),
            rs.getString("ToEmail"),
            rs.getString("Subject"),
            rs.getDate("SendDate"),
            rs.getTimestamp("SendTimestamp"),
            rs.getString("Content"),
            rs.getString("Status"),
            rs.getString("Priority"),
            rs.getString("Category"),
            rs.getDate("CreatedDate"),
            rs.getDate("LastModified"),
            rs.getString("AdminResponse"),
            null // AssignedAdmin will be set separately
        );
        
        // Set new fields
        item.setUserId(rs.getInt("UserID"));
        
        // Handle AssignedAdminID (can be null)
        Integer assignedAdminId = rs.getObject("AssignedAdminID") != null ? rs.getInt("AssignedAdminID") : null;
        item.setAssignedAdminId(assignedAdminId != null ? assignedAdminId : 0);
        
        // Set assignedAdmin to null since we don't store it as string in database
        item.setAssignedAdmin(null);
        
        // Handle nullable fields
        Integer eventId = rs.getObject("EventID") != null ? rs.getInt("EventID") : null;
        Integer orderId = rs.getObject("OrderID") != null ? rs.getInt("OrderID") : null;
        item.setEventId(eventId);
        item.setOrderId(orderId);
        
        return item;
    }

    private void loadAttachmentsForSupportItem(SupportItem supportItem) {
        SupportAttachmentDAO attachmentDAO = new SupportAttachmentDAO();
        List<SupportAttachment> attachments = attachmentDAO.getAttachmentsBySupportId(supportItem.getSupportId());
        supportItem.setAttachments(attachments);
    }
} 