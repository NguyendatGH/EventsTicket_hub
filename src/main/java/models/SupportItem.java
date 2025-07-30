package  models;

import java.sql.Date;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;


public class SupportItem {
    private int supportId;
    private String fromEmail;
    private String toEmail;
    private String subject;
    private Date sendDate;
    private Timestamp sendTimestamp;
    private String content;
    private String status; 
    private String priority; 
    private String category; 
    private Date createdDate;
    private Date lastModified;
    private String adminResponse;
    private String assignedAdmin;
    private int userId;
    private int assignedAdminId;
    private Integer eventId;
    private Integer orderId;
    private java.util.List<SupportAttachment> attachments;

  
    public SupportItem() {
    }

   
    public SupportItem(String fromEmail, String subject, String content) {
        this.fromEmail = fromEmail;
        this.subject = subject;
        this.content = content;
        this.status = "PENDING";
        this.priority = "MEDIUM";
        this.category = "GENERAL";
        this.sendDate = new Date(System.currentTimeMillis());
        this.sendTimestamp = new Timestamp(System.currentTimeMillis());
        this.createdDate = new Date(System.currentTimeMillis());
        this.lastModified = new Date(System.currentTimeMillis());
    }

    public SupportItem(int userId, String fromEmail, String subject, String content) {
        this.userId = userId;
        this.fromEmail = fromEmail;
        this.subject = subject;
        this.content = content;
        this.status = "PENDING";
        this.priority = "MEDIUM";
        this.category = "GENERAL";
        this.sendDate = new Date(System.currentTimeMillis());
        this.sendTimestamp = new Timestamp(System.currentTimeMillis());
        this.createdDate = new Date(System.currentTimeMillis());
        this.lastModified = new Date(System.currentTimeMillis());
    }

   
    public SupportItem(String fromEmail, String toEmail, String subject, String content, String status) {
        this.fromEmail = fromEmail;
        this.toEmail = toEmail;
        this.subject = subject;
        this.content = content;
        this.status = status;
        this.priority = "MEDIUM";
        this.category = "GENERAL";
        this.sendDate = new Date(System.currentTimeMillis());
        this.sendTimestamp = new Timestamp(System.currentTimeMillis());
        this.createdDate = new Date(System.currentTimeMillis());
        this.lastModified = new Date(System.currentTimeMillis());
    }

   
    public SupportItem(int supportId, String fromEmail, String toEmail, String subject, 
                      Date sendDate, Timestamp sendTimestamp, String content, String status, 
                      String priority, String category, Date createdDate, Date lastModified, 
                      String adminResponse, String assignedAdmin) {
        this.supportId = supportId;
        this.fromEmail = fromEmail;
        this.toEmail = toEmail;
        this.subject = subject;
        this.sendDate = sendDate;
        this.sendTimestamp = sendTimestamp;
        this.content = content;
        this.status = status;
        this.priority = priority;
        this.category = category;
        this.createdDate = createdDate;
        this.lastModified = lastModified;
        this.adminResponse = adminResponse;
        this.assignedAdmin = assignedAdmin;
        this.attachments = new java.util.ArrayList<>();
    }

  
    public int getSupportId() {
        return supportId;
    }

    public void setSupportId(int supportId) {
        this.supportId = supportId;
    }

    public String getFromEmail() {
        return fromEmail;
    }

    public void setFromEmail(String fromEmail) {
        this.fromEmail = fromEmail;
    }

    public String getToEmail() {
        return toEmail;
    }

    public void setToEmail(String toEmail) {
        this.toEmail = toEmail;
    }

    public String getSubject() {
        return subject;
    }

    public void setSubject(String subject) {
        this.subject = subject;
    }

    public Date getSendDate() {
        return sendDate;
    }

    public void setSendDate(Date sendDate) {
        this.sendDate = sendDate;
    }

    public Timestamp getSendTimestamp() {
        return sendTimestamp;
    }

    public void setSendTimestamp(Timestamp sendTimestamp) {
        this.sendTimestamp = sendTimestamp;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
        this.lastModified = new Date(System.currentTimeMillis());
    }

    public String getPriority() {
        return priority;
    }

    public void setPriority(String priority) {
        this.priority = priority;
        this.lastModified = new Date(System.currentTimeMillis());
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public Date getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Date createdDate) {
        this.createdDate = createdDate;
    }

    public Date getLastModified() {
        return lastModified;
    }

    public void setLastModified(Date lastModified) {
        this.lastModified = lastModified;
    }

    public String getAdminResponse() {
        return adminResponse;
    }

    public void setAdminResponse(String adminResponse) {
        this.adminResponse = adminResponse;
        this.lastModified = new Date(System.currentTimeMillis());
    }

    public String getAssignedAdmin() {
        return assignedAdmin;
    }

    public void setAssignedAdmin(String assignedAdmin) {
        this.assignedAdmin = assignedAdmin;
        this.lastModified = new Date(System.currentTimeMillis());
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getAssignedAdminId() {
        return assignedAdminId;
    }

    public void setAssignedAdminId(int assignedAdminId) {
        this.assignedAdminId = assignedAdminId;
    }

    public Integer getEventId() {
        return eventId;
    }

    public void setEventId(Integer eventId) {
        this.eventId = eventId;
    }

    public Integer getOrderId() {
        return orderId;
    }

    public void setOrderId(Integer orderId) {
        this.orderId = orderId;
    }

    public java.util.List<SupportAttachment> getAttachments() {
        return attachments;
    }

    public void setAttachments(java.util.List<SupportAttachment> attachments) {
        this.attachments = attachments;
    }

    public void addAttachment(SupportAttachment attachment) {
        if (this.attachments == null) {
            this.attachments = new java.util.ArrayList<>();
        }
        this.attachments.add(attachment);
    }

    // Utility methods
    public boolean isPending() {
        return "PENDING".equals(this.status);
    }

    public boolean isResolved() {
        return "RESOLVED".equals(this.status) || "CLOSED".equals(this.status);
    }

    public boolean isHighPriority() {
        return "HIGH".equals(this.priority) || "URGENT".equals(this.priority);
    }

    public void markAsReplied() {
        this.status = "REPLIED";
        this.lastModified = new Date(System.currentTimeMillis());
    }

    public void markAsResolved() {
        this.status = "RESOLVED";
        this.lastModified = new Date(System.currentTimeMillis());
    }

    public void markAsClosed() {
        this.status = "CLOSED";
        this.lastModified = new Date(System.currentTimeMillis());
    }

    // Date conversion methods
    /**
     * Converts a date string in dd/MM/yyyy format to java.sql.Date
     * @param dateString String in format dd/MM/yyyy (e.g., "25/12/2023")
     * @return java.sql.Date object or null if parsing fails
     */
    public static Date stringToDate(String dateString) {
        if (dateString == null || dateString.trim().isEmpty()) {
            return null;
        }
        
        try {
            SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
            dateFormat.setLenient(false); // Strict parsing
            java.util.Date utilDate = dateFormat.parse(dateString.trim());
            return new Date(utilDate.getTime());
        } catch (ParseException e) {
            System.err.println("Error parsing date string '" + dateString + "': " + e.getMessage());
            return null;
        }
    }
    
    /**
     * Converts a date string in dd/MM/yyyy HH:mm format to java.sql.Timestamp
     * @param dateTimeString String in format dd/MM/yyyy HH:mm (e.g., "25/12/2023 14:30")
     * @return java.sql.Timestamp object or null if parsing fails
     */
    public static Timestamp stringToTimestamp(String dateTimeString) {
        if (dateTimeString == null || dateTimeString.trim().isEmpty()) {
            return null;
        }
        
        try {
            SimpleDateFormat dateTimeFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm");
            dateTimeFormat.setLenient(false); // Strict parsing
            java.util.Date utilDate = dateTimeFormat.parse(dateTimeString.trim());
            return new Timestamp(utilDate.getTime());
        } catch (ParseException e) {
            System.err.println("Error parsing datetime string '" + dateTimeString + "': " + e.getMessage());
            return null;
        }
    }
    
    /**
     * Converts java.sql.Date to string in dd/MM/yyyy format
     * @param date java.sql.Date object
     * @return String in format dd/MM/yyyy or empty string if date is null
     */
    public static String dateToString(Date date) {
        if (date == null) {
            return "";
        }
        
        SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
        return dateFormat.format(date);
    }
    
    /**
     * Converts java.sql.Timestamp to string in dd/MM/yyyy HH:mm format
     * @param timestamp java.sql.Timestamp object
     * @return String in format dd/MM/yyyy HH:mm or empty string if timestamp is null
     */
    public static String timestampToString(Timestamp timestamp) {
        if (timestamp == null) {
            return "";
        }
        
        SimpleDateFormat dateTimeFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm");
        return dateTimeFormat.format(timestamp);
    }
    
    /**
     * Sets the send date from a string in dd/MM/yyyy format
     * @param dateString String in format dd/MM/yyyy
     */
    public void setSendDateFromString(String dateString) {
        Date convertedDate = stringToDate(dateString);
        if (convertedDate != null) {
            this.sendDate = convertedDate;
        }
    }
    
    /**
     * Sets the send timestamp from a string in dd/MM/yyyy HH:mm format
     * @param dateTimeString String in format dd/MM/yyyy HH:mm
     */
    public void setSendTimestampFromString(String dateTimeString) {
        Timestamp convertedTimestamp = stringToTimestamp(dateTimeString);
        if (convertedTimestamp != null) {
            this.sendTimestamp = convertedTimestamp;
        }
    }

    // Format methods for display
    public String getFormattedSendDate() {
        if (sendTimestamp != null) {
            return timestampToString(sendTimestamp);
        }
        return sendDate != null ? dateToString(sendDate) : "N/A";
    }

    public String getShortSubject(int maxLength) {
        if (subject == null) return "";
        return subject.length() > maxLength ? subject.substring(0, maxLength) + "..." : subject;
    }

    public String getShortContent(int maxLength) {
        if (content == null) return "";
        return content.length() > maxLength ? content.substring(0, maxLength) + "..." : content;
    }

    // toString method for debugging
    @Override
    public String toString() {
        return "SupportItem{" +
                "supportId=" + supportId +
                ", fromEmail='" + fromEmail + '\'' +
                ", toEmail='" + toEmail + '\'' +
                ", subject='" + subject + '\'' +
                ", sendDate=" + sendDate +
                ", content='" + (content != null ? content.substring(0, Math.min(50, content.length())) + "..." : null) + '\'' +
                ", status='" + status + '\'' +
                ", priority='" + priority + '\'' +
                ", category='" + category + '\'' +
                ", assignedAdmin='" + assignedAdmin + '\'' +
                '}';
    }

    // equals and hashCode for proper object comparison
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        SupportItem that = (SupportItem) obj;
        return supportId == that.supportId;
    }

    @Override
    public int hashCode() {
        return Integer.hashCode(supportId);
    }
}