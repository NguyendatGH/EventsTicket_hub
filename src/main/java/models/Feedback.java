
package models;

import java.time.LocalDateTime;


public class Feedback {

    private int feedbackID;
    private int userID;
    private int eventID;
    private int orderID;
    private int rating;
    private String content;
    private boolean isApprove;
    private String adminResponse;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private String userName;

    public Feedback() {
    }

    public Feedback(int feedbackID, int userID, int eventID, int orderID, int rating,
            String content, boolean isApprove, String adminResponse,
            LocalDateTime createdAt, LocalDateTime updatedAt) {
        this.feedbackID = feedbackID;
        this.userID = userID;
        this.eventID = eventID;
        this.orderID = orderID;
        this.rating = rating;
        this.content = content;
        this.isApprove = isApprove;
        this.adminResponse = adminResponse;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public int getFeedbackID() {
        return feedbackID;
    }

    public void setFeedbackID(int feedbackID) {
        this.feedbackID = feedbackID;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public int getEventID() {
        return eventID;
    }

    public void setEventID(int eventID) {
        this.eventID = eventID;
    }

    public int getOrderID() {
        return orderID;
    }

    public void setOrderID(int orderID) {
        this.orderID = orderID;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public boolean isApprove() {
        return isApprove;
    }

    public void setApprove(boolean isApprove) {
        this.isApprove = isApprove;
    }

    public String getAdminResponse() {
        return adminResponse;
    }

    public void setAdminResponse(String adminResponse) {
        this.adminResponse = adminResponse;
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
    
    public java.util.Date getCreatedAtDate() {
        return java.sql.Timestamp.valueOf(this.createdAt);
    }
    public java.util.Date getUpdatedAtDate() {
        return java.sql.Timestamp.valueOf(this.updatedAt);
    }
    
    public String getUserName() {
        return userName;
    }
    public void setUserName(String userName) {
        this.userName = userName;
    }
    
    @Override
    public String toString() {
        return "Feedback{" +
                "feedbackID=" + feedbackID +
                ", userID=" + userID +
                ", eventID=" + eventID +
                ", orderID=" + orderID +
                ", rating=" + rating +
                ", content='" + content + '\'' +
                ", isApprove=" + isApprove +
                ", adminResponse='" + adminResponse + '\'' +
                ", createdAt=" + createdAt +
                ", updatedAt=" + updatedAt +
                '}';
    }
}
