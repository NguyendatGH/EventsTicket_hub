/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
// models/Notification.java
package models;

import java.sql.Timestamp;
import java.time.LocalDateTime;

public class Notification {
    private int notificationID;
    private int userID;
    private String title;
    private String content;
    private String notificationType; 
    private Integer relatedID;
    private boolean isRead;
    private LocalDateTime readAt;
    private String priority; 
    private LocalDateTime createdAt;
    private LocalDateTime expiresAt;

    public Notification() {
    }

    public Notification(int notificationID, int userID, String title, String content, String notificationType, Integer relatedID, boolean isRead, LocalDateTime readAt, String priority, LocalDateTime createdAt, LocalDateTime expiresAt) {
        this.notificationID = notificationID;
        this.userID = userID;
        this.title = title;
        this.content = content;
        this.notificationType = notificationType;
        this.relatedID = relatedID;
        this.isRead = isRead;
        this.readAt = readAt;
        this.priority = priority;
        this.createdAt = createdAt;
        this.expiresAt = expiresAt;
    }

    // --- Getters ---
    public int getNotificationID() {
        return notificationID;
    }

    public int getUserID() {
        return userID;
    }

    public String getTitle() {
        return title;
    }

    public String getContent() {
        return content;
    }

    public String getNotificationType() {
        return notificationType;
    }

    public Integer getRelatedID() {
        return relatedID;
    }

    public boolean isIsRead() { // Note the 'is' prefix for boolean getter
        return isRead;
    }

    public LocalDateTime getReadAt() {
        return readAt;
    }

    public String getPriority() {
        return priority;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public LocalDateTime getExpiresAt() {
        return expiresAt;
    }

    // --- Setters ---
    public void setNotificationID(int notificationID) {
        this.notificationID = notificationID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public void setNotificationType(String notificationType) {
        this.notificationType = notificationType;
    }

    public void setRelatedID(Integer relatedID) {
        this.relatedID = relatedID;
    }

    public void setIsRead(boolean isRead) {
        this.isRead = isRead;
    }

    public void setReadAt(LocalDateTime readAt) {
        this.readAt = readAt;
    }

    public void setPriority(String priority) {
        this.priority = priority;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public void setExpiresAt(LocalDateTime expiresAt) {
        this.expiresAt = expiresAt;
    }
}