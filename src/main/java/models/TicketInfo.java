package models;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class TicketInfo { // ĐỔI TÊN CLASS

    private int ticketInfoID; // ĐỔI TÊN FIELD
    private String ticketName;
    private String ticketDescription;
    private String category;
    private BigDecimal price;
    private LocalDateTime salesStartTime;
    private LocalDateTime salesEndTime;
    private int eventID;
    private int maxQuantityPerOrder;
    private boolean isActive;

    private int availableQuantity;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public TicketInfo() {
    }

    // Sửa constructor
    public TicketInfo(int ticketInfoID, String ticketName, String ticketDescription, String category, BigDecimal price,
                      LocalDateTime salesStartTime, LocalDateTime salesEndTime, int eventID, int maxQuantityPerOrder, boolean isActive) {
        this.ticketInfoID = ticketInfoID;
        this.ticketName = ticketName;
        this.ticketDescription = ticketDescription;
        this.category = category;
        this.price = price;
        this.salesStartTime = salesStartTime;
        this.salesEndTime = salesEndTime;
        this.eventID = eventID;
        this.maxQuantityPerOrder = maxQuantityPerOrder;
        this.isActive = isActive;
    }

    // Sửa constructor
    public TicketInfo(int ticketInfoID, String ticketName, String ticketDescription, String category, BigDecimal price,
                      LocalDateTime salesStartTime, LocalDateTime salesEndTime, int eventID,
                      int maxQuantityPerOrder, boolean isActive, int availableQuantity,
                      LocalDateTime createdAt, LocalDateTime updatedAt) {
        this.ticketInfoID = ticketInfoID;
        this.ticketName = ticketName;
        this.ticketDescription = ticketDescription;
        this.category = category;
        this.price = price;
        this.salesStartTime = salesStartTime;
        this.salesEndTime = salesEndTime;
        this.eventID = eventID;
        this.maxQuantityPerOrder = maxQuantityPerOrder;
        this.isActive = isActive;
        this.availableQuantity = availableQuantity;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    // Sửa getter và setter cho ID
    public int getTicketInfoID() {
        return ticketInfoID;
    }

    public void setTicketInfoID(int ticketInfoID) {
        this.ticketInfoID = ticketInfoID;
    }
    
    // Các getters và setters khác giữ nguyên

    public String getTicketName() { return ticketName; }
    public void setTicketName(String ticketName) { this.ticketName = ticketName; }
    public String getTicketDescription() { return ticketDescription; }
    public void setTicketDescription(String ticketDescription) { this.ticketDescription = ticketDescription; }
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }
    public LocalDateTime getSalesStartTime() { return salesStartTime; }
    public void setSalesStartTime(LocalDateTime salesStartTime) { this.salesStartTime = salesStartTime; }
    public LocalDateTime getSalesEndTime() { return salesEndTime; }
    public void setSalesEndTime(LocalDateTime salesEndTime) { this.salesEndTime = salesEndTime; }
    public int getEventID() { return eventID; }
    public void setEventID(int eventID) { this.eventID = eventID; }
    public int getMaxQuantityPerOrder() { return maxQuantityPerOrder; }
    public void setMaxQuantityPerOrder(int maxQuantityPerOrder) { this.maxQuantityPerOrder = maxQuantityPerOrder; }
    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }
    public int getAvailableQuantity() { return availableQuantity; }
    public void setAvailableQuantity(int availableQuantity) { this.availableQuantity = availableQuantity; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }

    @Override
    public String toString() {
        return "TicketInfo{" // Sửa tên class
                + "ticketInfoID=" + ticketInfoID // Sửa tên field
                + ", ticketName='" + ticketName + '\''
                + ", ticketDescription='" + ticketDescription + '\''
                + ", category='" + category + '\''
                + ", price=" + price
                + ", salesStartTime=" + salesStartTime
                + ", salesEndTime=" + salesEndTime
                + ", eventID=" + eventID
                + ", maxQuantityPerOrder=" + maxQuantityPerOrder
                + ", isActive=" + isActive
                + ", availableQuantity=" + availableQuantity
                + ", createdAt=" + createdAt
                + ", updatedAt=" + updatedAt
                + '}';
    }
}