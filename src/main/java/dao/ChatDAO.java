package dao;

import context.DBConnection;
import dto.UserDTO;
import models.Conversation;
import models.Message;
import models.FileAttachment;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;

public class ChatDAO {

    private static final Logger LOGGER = Logger.getLogger(ChatDAO.class.getName());

    // Fetch all conversations for a user
    public List<Conversation> getUserConversations(int userId) {
        List<Conversation> conversations = new ArrayList<>();
        String sql = "SELECT c.ConversationID, c.CustomerID, c.EventOwnerID, c.EventID, c.Subject, c.Status, " +
                "c.LastMessageAt, c.CreatedBy, c.CreatedAt, c.UpdatedAt, e.Name AS EventName " +
                "FROM Conversations c " +
                "LEFT JOIN Events e ON c.EventID = e.EventID " +
                "WHERE c.CustomerID = ? OR c.EventOwnerID = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, userId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Conversation conv = new Conversation(
                            rs.getInt("ConversationID"),
                            rs.getInt("CustomerID"),
                            rs.getInt("EventOwnerID"),
                            rs.getObject("EventID") != null ? rs.getInt("EventID") : null,
                            rs.getString("Subject") != null ? rs.getString("Subject")
                                    : (rs.getString("EventName") != null
                                            ? "Discussion about " + rs.getString("EventName")
                                            : "Event Discussion"),
                            rs.getString("Status"),
                            rs.getTimestamp("LastMessageAt") != null
                                    ? rs.getTimestamp("LastMessageAt").toLocalDateTime()
                                    : null,
                            rs.getInt("CreatedBy"),
                            rs.getTimestamp("CreatedAt").toLocalDateTime(),
                            rs.getTimestamp("UpdatedAt").toLocalDateTime());
                    conversations.add(conv);
                }
            }
        } catch (SQLException e) {
            LOGGER.severe("Error fetching conversations for user: " + userId + ": " + e.getMessage());
            e.printStackTrace();
        }
        return conversations;
    }

    // Get conversation name
    public String getConversationName(int conversationId, int currentUserId) {
        String conversationName = "Event Discussion";
        String sql = "SELECT c.CustomerID, c.EventOwnerID, c.Subject, e.Name AS EventName , u1.Username AS CustomerName,"
                +
                " u2.Username AS EventOwnerName FROM Conversations c LEFT JOIN Events e ON c.EventID = e.EventID \n" +
                "LEFT JOIN Users u1 ON c.CustomerID = u1.Id \n" +
                "LEFT JOIN Users u2 ON c.EventOwnerID = u2.Id \n" +
                "WHERE c.ConversationID = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, conversationId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    String subject = rs.getString("Subject");
                    if (subject != null && !subject.trim().isEmpty()) {
                        conversationName = subject;
                    } else if (rs.getString("EventName") != null) {
                        conversationName = "Discussion about " + rs.getString("EventName");
                    } else {
                        int customerId = rs.getInt("CustomerID");
                        int eventOwnerId = rs.getInt("EventOwnerID");
                        if (currentUserId == customerId && rs.getString("EventOwnerName") != null) {
                            conversationName = rs.getString("EventOwnerName");
                        } else if (currentUserId == eventOwnerId && rs.getString("CustomerName") != null) {
                            conversationName = rs.getString("CustomerName");
                        }
                    }
                }
            }
        } catch (SQLException e) {
            LOGGER.severe(
                    "Error fetching conversation name for ConversationID: " + conversationId + ": " + e.getMessage());
            e.printStackTrace();
        }
        return conversationName;
    }

    // Create a new conversation
    public Conversation createConversation(int customerId, int eventOwnerId, int eventId, int createdBy) {
        String sql = "INSERT INTO Conversations (CustomerID, EventOwnerID, EventID, CreatedBy, Subject, Status, CreatedAt, UpdatedAt) "
                +
                "VALUES (?, ?, ?, ?, ?, 'active', DATEADD(HOUR, 7, GETUTCDATE()), DATEADD(HOUR, 7, GETUTCDATE())); " +
                "SELECT SCOPE_IDENTITY() AS ConversationID;";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, customerId);
            stmt.setInt(2, eventOwnerId);
            stmt.setInt(3, eventId);
            stmt.setInt(4, createdBy);
            stmt.setString(5, "Discussion about Event ID: " + eventId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    int conversationId = rs.getInt("ConversationID");
                    return getConversationById(conversationId);
                }
            }
        } catch (SQLException e) {
            LOGGER.severe("Error creating conversation for CustomerID: " + customerId + ", EventOwnerID: "
                    + eventOwnerId + ": " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    // Fetch a conversation by ID
    public Conversation getConversationById(int conversationId) {
        String sql = "SELECT c.*, e.Name AS EventName FROM Conversations c " +
                "LEFT JOIN Events e ON c.EventID = e.EventID WHERE c.ConversationID = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, conversationId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new Conversation(
                            rs.getInt("ConversationID"),
                            rs.getInt("CustomerID"),
                            rs.getInt("EventOwnerID"),
                            rs.getObject("EventID") != null ? rs.getInt("EventID") : null,
                            rs.getString("Subject") != null ? rs.getString("Subject")
                                    : (rs.getString("EventName") != null
                                            ? "Discussion about " + rs.getString("EventName")
                                            : "Event Discussion"),
                            rs.getString("Status"),
                            rs.getTimestamp("LastMessageAt") != null
                                    ? rs.getTimestamp("LastMessageAt").toLocalDateTime()
                                    : null,
                            rs.getInt("CreatedBy"),
                            rs.getTimestamp("CreatedAt").toLocalDateTime(),
                            rs.getTimestamp("UpdatedAt").toLocalDateTime());
                }
            }
        } catch (SQLException e) {
            LOGGER.severe("Error fetching conversation by ID: " + conversationId + ": " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    // Save a message
    public int saveMessage(Message message, int conversationId) {
        String sql = "INSERT INTO Messages (ConversationID, SenderID, MessageContent, MessageType, IsRead, CreatedAt, UpdatedAt) "
                +
                "VALUES (?, ?, ?, ?, 0, DATEADD(HOUR, 7, GETUTCDATE()), DATEADD(HOUR, 7, GETUTCDATE())); " +
                "SELECT SCOPE_IDENTITY() AS MessageID;";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, conversationId);
            stmt.setInt(2, message.getSenderID());
            stmt.setString(3, message.getMessageContent());
            stmt.setString(4, message.getMessageType());

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    int messageId = rs.getInt("MessageID");
                    updateLastMessageAt(conversationId);
                    LOGGER.info("Saved message from SenderID: " + message.getSenderID() + " to ConversationID: "
                            + conversationId + " with MessageID: " + messageId);
                    return messageId;
                }
            }
        } catch (SQLException e) {
            LOGGER.severe("Error saving message for ConversationID: " + conversationId + ": " + e.getMessage());
            e.printStackTrace();
        }
        return -1;
    }

    public List<Message> getMessagesByConversation(int conversationId, int limit) {
        List<Message> messages = new ArrayList<>();
        String sql = "SELECT TOP (?) MessageID, ConversationID, SenderID, MessageContent, MessageType, IsRead, ReadAt, IsEdited, EditedAt, CreatedAt, UpdatedAt "
                +
                "FROM Messages " +
                "WHERE ConversationID = ? " +
                "ORDER BY CreatedAt ASC";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, limit);
            stmt.setInt(2, conversationId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Message message = new Message(
                            rs.getInt("MessageID"),
                            rs.getInt("ConversationID"),
                            rs.getInt("SenderID"),
                            rs.getString("MessageContent"),
                            rs.getString("MessageType"),
                            rs.getBoolean("IsRead"),
                            rs.getTimestamp("ReadAt"),
                            rs.getBoolean("IsEdited"),
                            rs.getTimestamp("EditedAt"),
                            rs.getTimestamp("CreatedAt"),
                            rs.getTimestamp("UpdatedAt"));
                    List<FileAttachment> attachments = getAttachmentsByMessageId(message.getMessageID());
                    message.setAttachments(attachments);
                    messages.add(message);

                }
            }
        } catch (SQLException e) {
            LOGGER.severe("Error fetching messages for ConversationID: " + conversationId + ": " + e.getMessage());
            e.printStackTrace();
        }
        return messages;
    }

    public FileAttachment saveFileAttachment(FileAttachment attachment) {
        String sql = "INSERT INTO FileAttachments (MessageID, OriginalFilename, StoredFilename, FilePath, FileSize, MimeType, UploadedAt) "
                +
                "VALUES (?, ?, ?, ?, ?, ?, DATEADD(HOUR, 7, GETUTCDATE())); " +
                "SELECT SCOPE_IDENTITY() AS AttachmentID;";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, attachment.getMessageID());
            stmt.setString(2, attachment.getOriginalFilename());
            stmt.setString(3, attachment.getStoredFilename());
            stmt.setString(4, attachment.getFilePath());
            stmt.setLong(5, attachment.getFileSize());
            stmt.setString(6, attachment.getMimeType());

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    int attachmentId = rs.getInt("AttachmentID");
                    attachment.setAttachmentID(attachmentId);
                    LOGGER.info("Saved file attachment for MessageID: " + attachment.getMessageID()
                            + " with AttachmentID: " + attachmentId);
                    return attachment;
                }
            }
        } catch (SQLException e) {
            LOGGER.severe(
                    "Error saving file attachment for MessageID: " + attachment.getMessageID() + ": " + e.getMessage());
            e.printStackTrace();
            return null;
        }
        return null;
    }

    public List<FileAttachment> getAttachmentsByMessageId(int messageId) {
        List<FileAttachment> attachments = new ArrayList<>();
        String sql = "SELECT AttachmentID, MessageID, OriginalFilename, StoredFilename, FilePath, FileSize, MimeType, UploadedAt "
                +
                "FROM FileAttachments WHERE MessageID = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, messageId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    FileAttachment attachment = new FileAttachment(
                            rs.getInt("AttachmentID"),
                            rs.getInt("MessageID"),
                            rs.getString("OriginalFilename"),
                            rs.getString("StoredFilename"),
                            rs.getString("FilePath"),
                            rs.getLong("FileSize"),
                            rs.getString("MimeType"),
                            rs.getTimestamp("UploadedAt"));
                    attachments.add(attachment);
                }
            }
        } catch (SQLException e) {
            LOGGER.severe("Error fetching attachments for MessageID: " + messageId + ": " + e.getMessage());
            e.printStackTrace();
        }
        return attachments;
    }

    private void updateLastMessageAt(int conversationId) {
        String sql = "UPDATE Conversations SET LastMessageAt = DATEADD(HOUR, 7, GETUTCDATE()), UpdatedAt = DATEADD(HOUR, 7, GETUTCDATE()) WHERE ConversationID = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, conversationId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            LOGGER.severe("Error updating LastMessageAt for ConversationID: " + conversationId + ": " + e.getMessage());
            e.printStackTrace();
        }
    }

    public Map<Integer, Map<String, Object>> getGroupedConversationsForEventOwner(int eventOwnerId) {
        Map<Integer, Map<String, Object>> groupedConversations = new HashMap<>();
        String sql = "SELECT c.ConversationID, c.CustomerID, c.EventOwnerID, c.EventID, c.Subject, c.Status, " +
                "c.LastMessageAt, c.CreatedBy, c.CreatedAt, c.UpdatedAt, e.Name AS EventName, u.Username AS CustomerName "
                +
                "FROM Conversations c " +
                "LEFT JOIN Events e ON c.EventID = e.EventID " +
                "LEFT JOIN Users u ON c.CustomerID = u.Id " +
                "WHERE c.EventOwnerID = ? " +
                "ORDER BY c.CustomerID, c.LastMessageAt DESC";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, eventOwnerId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    int customerId = rs.getInt("CustomerID");
                    Conversation conv = new Conversation(
                            rs.getInt("ConversationID"),
                            rs.getInt("CustomerID"),
                            rs.getInt("EventOwnerID"),
                            rs.getObject("EventID") != null ? rs.getInt("EventID") : null,
                            rs.getString("Subject") != null ? rs.getString("Subject")
                                    : (rs.getString("EventName") != null
                                            ? "Discussion about " + rs.getString("EventName")
                                            : "Event Discussion"),
                            rs.getString("Status"),
                            rs.getTimestamp("LastMessageAt") != null
                                    ? rs.getTimestamp("LastMessageAt").toLocalDateTime()
                                    : null,
                            rs.getInt("CreatedBy"),
                            rs.getTimestamp("CreatedAt").toLocalDateTime(),
                            rs.getTimestamp("UpdatedAt").toLocalDateTime());

                    // Group by CustomerID
                    Map<String, Object> customerData = groupedConversations.computeIfAbsent(customerId,
                            k -> new HashMap<>());
                    if (!customerData.containsKey("customerName")) {
                        customerData.put("customerName", rs.getString("CustomerName"));
                        customerData.put("conversations", new ArrayList<Conversation>());
                    }
                    ((List<Conversation>) customerData.get("conversations")).add(conv);
                }
            }
        } catch (SQLException e) {
            LOGGER.severe(
                    "Error fetching grouped conversations for EventOwnerID: " + eventOwnerId + ": " + e.getMessage());
            e.printStackTrace();
        }
        return groupedConversations;
    }

    public int getCustomerIdFromConversation(int eventId) throws SQLException {
        String sql = "SELECT customerID FROM Conversations WHERE EventID = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("customerID");
                }
            }
        }
        return -1;
    }
    public boolean softDeleteConversation(int conversationId, int userId, boolean isCustomer) {
    String sql = isCustomer
            ? "UPDATE Conversations SET IsDeletedByCustomer = 1, DeletedAt = DATEADD(HOUR, 7, GETUTCDATE()), UpdatedAt = DATEADD(HOUR, 7, GETUTCDATE()) WHERE ConversationID = ? AND CustomerID = ?"
            : "UPDATE Conversations SET IsDeletedByOwner = 1, DeletedAt = DATEADD(HOUR, 7, GETUTCDATE()), UpdatedAt = DATEADD(HOUR, 7, GETUTCDATE()) WHERE ConversationID = ? AND EventOwnerID = ?";

    try (Connection conn = DBConnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        stmt.setInt(1, conversationId);
        stmt.setInt(2, userId);
        int rowsAffected = stmt.executeUpdate();
        if (rowsAffected > 0) {
            LOGGER.info("Soft deleted conversation ID: " + conversationId + " for user ID: " + userId + " (isCustomer: " + isCustomer + ")");
            return true;
        } else {
            LOGGER.warning("No conversation found or user not authorized to delete conversation ID: " + conversationId);
            return false;
        }
    } catch (SQLException e) {
        LOGGER.severe("Error soft deleting conversation ID: " + conversationId + ": " + e.getMessage());
        e.printStackTrace();
        return false;
    }
}
}