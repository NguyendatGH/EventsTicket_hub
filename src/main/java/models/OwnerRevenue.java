package models;

import java.util.Date;

public class OwnerRevenue {
    private int ownerId;
    private String ownerName;
    private int eventId;
    private String eventName;
    private Date startTime;
    private Date endTime;
    private String revenuePeriod; // For monthly (YYYY-MM) or yearly (YYYY) aggregation
    private int orderCount;
    private int totalTicketsSold;
    private double eventRevenue;

    // Getters and Setters
    public int getOwnerId() {
        return ownerId;
    }

    public void setOwnerId(int ownerId) {
        this.ownerId = ownerId;
    }

    public String getOwnerName() {
        return ownerName;
    }

    public void setOwnerName(String ownerName) {
        this.ownerName = ownerName;
    }

    public int getEventId() {
        return eventId;
    }

    public void setEventId(int eventId) {
        this.eventId = eventId;
    }

    public String getEventName() {
        return eventName;
    }

    public void setEventName(String eventName) {
        this.eventName = eventName;
    }

    public Date getStartTime() {
        return startTime;
    }

    public void setStartTime(Date startTime) {
        this.startTime = startTime;
    }

    public Date getEndTime() {
        return endTime;
    }

    public void setEndTime(Date endTime) {
        this.endTime = endTime;
    }

    public String getRevenuePeriod() {
        return revenuePeriod;
    }

    public void setRevenuePeriod(String revenuePeriod) {
        this.revenuePeriod = revenuePeriod;
    }

    public int getOrderCount() {
        return orderCount;
    }

    public void setOrderCount(int orderCount) {
        this.orderCount = orderCount;
    }

    public int getTotalTicketsSold() {
        return totalTicketsSold;
    }

    public void setTotalTicketsSold(int totalTicketsSold) {
        this.totalTicketsSold = totalTicketsSold;
    }

    public double getEventRevenue() {
        return eventRevenue;
    }

    public void setEventRevenue(double eventRevenue) {
        this.eventRevenue = eventRevenue;
    }
}