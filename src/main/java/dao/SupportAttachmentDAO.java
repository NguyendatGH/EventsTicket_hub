package dao;

import models.SupportAttachment;
import context.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

public class SupportAttachmentDAO {
    private static final Logger logger = Logger.getLogger(SupportAttachmentDAO.class.getName());

    public boolean createAttachment(SupportAttachment attachment) {
        System.out.println("Debug: Creating attachment for SupportID: " + attachment.getSupportId());
        System.out.println("Debug: File name: " + attachment.getFileName());
        System.out.println("Debug: Original file name: " + attachment.getOriginalFileName());
        System.out.println("Debug: File path: " + attachment.getFilePath());
        System.out.println("Debug: File size: " + attachment.getFileSize());
        
        String sql = "INSERT INTO SupportAttachments (SupportID, FileName, OriginalFileName, FilePath, FileType, FileSize, UploadDate, UploadTimestamp) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setInt(1, attachment.getSupportId());
            ps.setString(2, attachment.getFileName());
            ps.setString(3, attachment.getOriginalFileName());
            ps.setString(4, attachment.getFilePath());
            ps.setString(5, attachment.getFileType());
            ps.setLong(6, attachment.getFileSize());
            ps.setDate(7, attachment.getUploadDate());
            ps.setTimestamp(8, attachment.getUploadTimestamp());
            
            int result = ps.executeUpdate();
            System.out.println("Debug: SQL result: " + result);
            
            if (result > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    int attachmentId = rs.getInt(1);
                    attachment.setAttachmentId(attachmentId);
                    System.out.println("Debug: Attachment created with ID: " + attachmentId);
                }
                return true;
            }
            
        } catch (SQLException e) {
            logger.severe("Error creating support attachment: " + e.getMessage());
            System.err.println("Debug: SQL Error: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }

    public List<SupportAttachment> getAttachmentsBySupportId(int supportId) {
        List<SupportAttachment> attachments = new ArrayList<>();
        String sql = "SELECT * FROM SupportAttachments WHERE SupportID = ? ORDER BY UploadTimestamp ASC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, supportId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                SupportAttachment attachment = mapRowToSupportAttachment(rs);
                attachments.add(attachment);
            }
            
        } catch (SQLException e) {
            logger.severe("Error getting attachments by support ID: " + e.getMessage());
            e.printStackTrace();
        }
        
        return attachments;
    }

    public SupportAttachment getAttachmentById(int attachmentId) {
        String sql = "SELECT * FROM SupportAttachments WHERE AttachmentID = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, attachmentId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return mapRowToSupportAttachment(rs);
            }
            
        } catch (SQLException e) {
            logger.severe("Error getting attachment by ID: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }

    public boolean deleteAttachment(int attachmentId) {
        String sql = "DELETE FROM SupportAttachments WHERE AttachmentID = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, attachmentId);
            int result = ps.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            logger.severe("Error deleting attachment: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }

    public boolean deleteAttachmentsBySupportId(int supportId) {
        String sql = "DELETE FROM SupportAttachments WHERE SupportID = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, supportId);
            int result = ps.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            logger.severe("Error deleting attachments by support ID: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }

    private SupportAttachment mapRowToSupportAttachment(ResultSet rs) throws SQLException {
        return new SupportAttachment(
            rs.getInt("AttachmentID"),
            rs.getInt("SupportID"),
            rs.getString("FileName"),
            rs.getString("OriginalFileName"),
            rs.getString("FilePath"),
            rs.getString("FileType"),
            rs.getLong("FileSize"),
            rs.getDate("UploadDate"),
            rs.getTimestamp("UploadTimestamp")
        );
    }
} 