package models;

import java.util.Date;
import java.util.List;

public class Message {
    private int messageID;
    private int conversationID;
    private int senderID;
    private String messageContent;
    private String messageType;
    private boolean isRead;
    private Date readAt;
    private boolean isEdited;
    private Date editedAt;
    private Date createdAt;
    private Date updatedAt;
    private List<FileAttachment> attachments;

    public Message() {
        this.messageType = "text";
        this.isRead = false;
        this.isEdited = false;
        this.createdAt = new Date();
        this.updatedAt = new Date();
    }

    // Constructor (all fields except attachments)
    public Message(int messageID, int conversationID, int senderID, String messageContent, String messageType,
            boolean isRead, Date readAt, boolean isEdited, Date editedAt,
            Date createdAt, Date updatedAt) {
        this.messageID = messageID;
        this.conversationID = conversationID;
        this.senderID = senderID;
        this.messageContent = messageContent;
        this.messageType = messageType != null ? messageType : "text";
        this.isRead = isRead;
        this.readAt = readAt;
        this.isEdited = isEdited;
        this.editedAt = editedAt;
        this.createdAt = createdAt != null ? createdAt : new Date();
        this.updatedAt = updatedAt != null ? updatedAt : new Date();
    }

    // Getters and Setters
    public int getMessageID() {
        return messageID;
    }

    public void setMessageID(int messageID) {
        this.messageID = messageID;
    }

    public int getConversationID() {
        return conversationID;
    }

    public void setConversationID(int conversationID) {
        this.conversationID = conversationID;
    }

    public int getSenderID() {
        return senderID;
    }

    public void setSenderID(int senderID) {
        this.senderID = senderID;
    }

    public String getMessageContent() {
        return messageContent;
    }

    public void setMessageContent(String messageContent) {
        this.messageContent = messageContent;
    }

    public String getMessageType() {
        return messageType;
    }

    public void setMessageType(String messageType) {
        this.messageType = messageType;
    }

    public boolean isRead() {
        return isRead;
    }

    public void setRead(boolean read) {
        this.isRead = read;
    }

    public Date getReadAt() {
        return readAt;
    }

    public void setReadAt(Date readAt) {
        this.readAt = readAt;
    }

    public boolean isEdited() {
        return isEdited;
    }

    public void setEdited(boolean edited) {
        this.isEdited = edited;
    }

    public Date getEditedAt() {
        return editedAt;
    }

    public void setEditedAt(Date editedAt) {
        this.editedAt = editedAt;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public Date getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Date updatedAt) {
        this.updatedAt = updatedAt;
    }

    public List<FileAttachment> getAttachments() {
        return attachments;
    }

    public void setAttachments(List<FileAttachment> attachments) {
        this.attachments = attachments;
    }

    public boolean hasAttachments() {
        return attachments != null && !attachments.isEmpty();
    }

    @Override
    public String toString() {
        return "Message{" +
                "messageID=" + messageID +
                ", conversationID=" + conversationID +
                ", senderID=" + senderID +
                ", messageContent='" + messageContent + '\'' +
                ", messageType='" + messageType + '\'' +
                ", isRead=" + isRead +
                ", readAt=" + readAt +
                ", isEdited=" + isEdited +
                ", editedAt=" + editedAt +
                ", createdAt=" + createdAt +
                ", updatedAt=" + updatedAt +
                ", attachments=" + (attachments != null ? attachments.size() : 0) +
                '}';
    }
}