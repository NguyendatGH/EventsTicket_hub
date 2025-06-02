// File: src/main/java/Models/TicketInfor.java
package Models;

import java.math.BigDecimal; // Import BigDecimal
import java.time.LocalDateTime;

public class TicketInfor {
    private int ticketInfoID;
    private String ticketName;
    private String ticketDescription;
    private String category;
    private BigDecimal price; // Changed from double to BigDecimal
    private LocalDateTime salesStartTime;
    private LocalDateTime salesEndTime;
    private int eventID;
    private int maxQuantityPerOrder;
    private boolean isActive;
    // Thêm trường CreatedAt và UpdatedAt nếu bạn muốn đọc từ DB
    // private LocalDateTime createdAt;
    // private LocalDateTime updatedAt;

    public TicketInfor() {
    }

    public TicketInfor(int ticketInfoID, String ticketName, String ticketDescription, String category, BigDecimal price, // Changed to BigDecimal
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
        // this.createdAt = createdAt; // Nếu thêm vào constructor
        // this.updatedAt = updatedAt; // Nếu thêm vào constructor
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

    public BigDecimal getPrice() { // Changed to BigDecimal
        return price;
    }

    public void setPrice(BigDecimal price) { // Changed to BigDecimal
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
        isActive = active;
    }

    /* Nếu bạn muốn đọc CreatedAt và UpdatedAt từ DB, uncomment các phần này
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
    */

    @Override
    public String toString() {
        return "TicketInfor{" +
                "ticketInfoID=" + ticketInfoID +
                ", ticketName='" + ticketName + '\'' +
                ", ticketDescription='" + ticketDescription + '\'' +
                ", category='" + category + '\'' +
                ", price=" + price +
                ", salesStartTime=" + salesStartTime +
                ", salesEndTime=" + salesEndTime +
                ", eventID=" + eventID +
                ", maxQuantityPerOrder=" + maxQuantityPerOrder +
                ", isActive=" + isActive +
                '}';
    }
}