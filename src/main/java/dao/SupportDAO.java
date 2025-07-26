package dao;

import models.SupportItem;
import context.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

public class SupportDAO {
    private static final Logger logger = Logger.getLogger(SupportDAO.class.getName());

    public boolean createSupportRequest(SupportItem supportItem) {
        String sql = "INSERT INTO SupportItems (FromEmail, ToEmail, Subject, SendDate, SendTimestamp, Content, Status, Priority, Category, CreatedDate, LastModified) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, supportItem.getFromEmail());
            ps.setString(2, supportItem.getToEmail());
            ps.setString(3, supportItem.getSubject());
            ps.setDate(4, supportItem.getSendDate());
            ps.setTimestamp(5, supportItem.getSendTimestamp());
            ps.setString(6, supportItem.getContent());
            ps.setString(7, supportItem.getStatus());
            ps.setString(8, supportItem.getPriority());
            ps.setString(9, supportItem.getCategory());
            ps.setDate(10, supportItem.getCreatedDate());
            ps.setDate(11, supportItem.getLastModified());
            
            int result = ps.executeUpdate();
            return result > 0;
            
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
                return mapRowToSupportItem(rs);
            }
            
        } catch (SQLException e) {
            logger.severe("Error getting support request by ID: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }

    public boolean updateSupportRequest(SupportItem supportItem) {
        String sql = "UPDATE SupportItems SET Status = ?, AdminResponse = ?, AssignedAdmin = ?, LastModified = ? WHERE SupportID = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, supportItem.getStatus());
            ps.setString(2, supportItem.getAdminResponse());
            ps.setString(3, supportItem.getAssignedAdmin());
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
        String sql = "SELECT * FROM SupportItems WHERE FromEmail = ? ORDER BY SendTimestamp DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, userEmail);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                SupportItem item = mapRowToSupportItem(rs);
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
        return new SupportItem(
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
            rs.getString("AssignedAdmin")
        );
    }
} 