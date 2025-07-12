package models;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class TicketInfo { 

    private int ticketInfoID;
    private String ticketName;
    private String ticketDescription;
    private String category;
    private BigDecimal price;
    private LocalDateTime salesStartTime;
    private LocalDateTime salesEndTime;
    private int eventID;
    private int maxQuantityPerOrder;
    private boolean isActive;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;


    private TicketInventory inventory;

    public TicketInfo() {
    }

    public int getTicketInfoID() {
        return ticketInfoID;
    }

    public void setTicketInfoID(int ticketInfoID) {
        this.ticketInfoID = ticketInfoID;
    }

    public String getTicketName() {
        return ticketName;
    }

    public void setTicketName(String ticketName) {
        this.ticketName = ticketName;
    }

    public String getTicketDescription() {
        return ticketDescription;
    }

    public void setTicketDescription(String ticketDescription) {
        this.ticketDescription = ticketDescription;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public LocalDateTime getSalesStartTime() {
        return salesStartTime;
    }

    public void setSalesStartTime(LocalDateTime salesStartTime) {
        this.salesStartTime = salesStartTime;
    }

    public LocalDateTime getSalesEndTime() {
        return salesEndTime;
    }

    public void setSalesEndTime(LocalDateTime salesEndTime) {
        this.salesEndTime = salesEndTime;
    }

    public int getEventID() {
        return eventID;
    }

    public void setEventID(int eventID) {
        this.eventID = eventID;
    }

    public int getMaxQuantityPerOrder() {
        return maxQuantityPerOrder;
    }

    public void setMaxQuantityPerOrder(int maxQuantityPerOrder) {
        this.maxQuantityPerOrder = maxQuantityPerOrder;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        this.isActive = active;
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

    public TicketInventory getInventory() {
        return inventory;
    }

    public void setInventory(TicketInventory inventory) {
        this.inventory = inventory;
    }

    public int getAvailableQuantity() {
        if (this.inventory != null) {
            return this.inventory.getAvailableQuantity();
        }
        return 0;
    }

    @Override
    public String toString() {
        return "TicketInfo{" 
                + "ticketInfoID=" + ticketInfoID 
                + ", ticketName='" + ticketName + '\''
                + ", ticketDescription='" + ticketDescription + '\''
                + ", category='" + category + '\''
                + ", price=" + price
                + ", salesStartTime=" + salesStartTime
                + ", salesEndTime=" + salesEndTime
                + ", eventID=" + eventID
                + ", maxQuantityPerOrder=" + maxQuantityPerOrder
                + ", isActive=" + isActive
                + ", createdAt=" + createdAt
                + ", updatedAt=" + updatedAt
                + '}';
    }
}
