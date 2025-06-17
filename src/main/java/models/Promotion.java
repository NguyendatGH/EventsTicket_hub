package models;

import java.sql.Timestamp;

public class Promotion {
    private int promotionID;
    private int eventID;
    private String promotionName;
    private String promotionCode;
    private Timestamp startTime;
    private Timestamp endTime;
    private boolean isActive;
    
    public Promotion() {}
    
    public int getPromotionID() { return promotionID; }
    public void setPromotionID(int promotionID) { this.promotionID = promotionID; }
    
    public int getEventID() { return eventID; }
    public void setEventID(int eventID) { this.eventID = eventID; }
    
    public String getPromotionName() { return promotionName; }
    public void setPromotionName(String promotionName) { this.promotionName = promotionName; }
    
    public String getPromotionCode() { return promotionCode; }
    public void setPromotionCode(String promotionCode) { this.promotionCode = promotionCode; }
    
    public Timestamp getStartTime() { return startTime; }
    public void setStartTime(Timestamp startTime) { this.startTime = startTime; }
    
    public Timestamp getEndTime() { return endTime; }
    public void setEndTime(Timestamp endTime) { this.endTime = endTime; }
    
    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }
}