package models;

import java.time.LocalDateTime;

public class Conversation {
    private int conversationID;
    private int customerID;
    private int eventOwnerID;
    private Integer eventID;
    private String subject;
    private String status;
    private LocalDateTime lastMessageAt;
    private int createdBy;
    private String customerName;
    private String eventOwnerName;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

       public Conversation() {
        this.subject = "Event Discussion";
        this.status = "active";
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }


    public Conversation(int conversationID, int customerID, int eventOwnerID, Integer eventID, String subject,
            String status, LocalDateTime lastMessageAt, int createdBy, LocalDateTime createdAt,
            LocalDateTime updatedAt) {
        this.conversationID = conversationID;
        this.customerID = customerID;
        this.eventOwnerID = eventOwnerID;
        this.eventID = eventID;
        this.subject = subject != null ? subject : "Event Discussion";
        this.status = status != null ? status : "active";
        this.lastMessageAt = lastMessageAt;
        this.createdBy = createdBy;
        this.createdAt = createdAt != null ? createdAt : LocalDateTime.now();
        this.updatedAt = updatedAt != null ? updatedAt : LocalDateTime.now();
    }

    // Getters and Setters
    public int getConversationID() {
        return conversationID;
    }

    public void setConversationID(int conversationID) {
        this.conversationID = conversationID;
    }

    public int getCustomerID() {
        return customerID;
    }

    public void setCustomerID(int customerID) {
        this.customerID = customerID;
    }

    public int getEventOwnerID() {
        return eventOwnerID;
    }

    public void setEventOwnerID(int eventOwnerID) {
        this.eventOwnerID = eventOwnerID;
    }

    public Integer getEventID() {
        return eventID;
    }

    public void setEventID(Integer eventID) {
        this.eventID = eventID;
    }

    public String getSubject() {
        return subject;
    }

    public void setSubject(String subject) {
        this.subject = subject;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public LocalDateTime getLastMessageAt() {
        return lastMessageAt;
    }

    public void setLastMessageAt(LocalDateTime lastMessageAt) {
        this.lastMessageAt = lastMessageAt;
    }

    public int getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(int createdBy) {
        this.createdBy = createdBy;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public String getCustomerName() {
        return this.customerName;
    }

    public void setCustomerName(String name) {
        this.customerName = name;
    }

    public String getEventOwnerName() {
        return this.eventOwnerName;
    }

    public void setEventOwnerName(String name) {
        this.eventOwnerName = name;
    }

    @Override
    public String toString() {
        return "Conversation{" +
                "conversationID=" + conversationID +
                ", customerID=" + customerID +
                ", eventOwnerID=" + eventOwnerID +
                ", eventID=" + eventID +
                ", subject='" + subject + '\'' +
                ", status='" + status + '\'' +
                ", lastMessageAt=" + lastMessageAt +
                ", createdBy=" + createdBy +
                ", createdAt=" + createdAt +
                ", updatedAt=" + updatedAt +
                '}';
    }
}