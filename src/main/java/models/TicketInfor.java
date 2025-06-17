

package models;


import java.math.BigDecimal; 
import java.time.LocalDateTime;

public class TicketInfor {
    private int ticketInforID;
    private String ticketName;
    private String ticketDescription;
    private String category;
    private BigDecimal price; 
    private LocalDateTime salesStartTime;
    private LocalDateTime salesEndTime;
    private int eventID;
    private int maxQuantityPerOrder;
    private boolean isActive;
    

    public TicketInfor() {
    }

    public TicketInfor(int ticketInforID, String ticketName, String ticketDescription, String category, BigDecimal price, // Changed to BigDecimal
                       LocalDateTime salesStartTime, LocalDateTime salesEndTime, int eventID, int maxQuantityPerOrder, boolean isActive) {
        this.ticketInforID = ticketInforID;
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

    public int getTicketInforID() {
        return ticketInforID;
    }

    public void setTicketInforID(int ticketInfoID) {
        this.ticketInforID = ticketInfoID;
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
                "ticketInfoID=" + ticketInforID +
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