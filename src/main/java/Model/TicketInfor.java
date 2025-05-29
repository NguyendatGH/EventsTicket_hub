
package model;

import java.time.LocalDateTime;

public class TicketInfor {
    private int ticketInfoID;
    private String ticketName;
    private String ticketDescription;
    private String category;
    private double price;
    private LocalDateTime salesStartTime;
    private LocalDateTime salesEndTime;
    private int eventID;
    private int maxQuantityPerOrder;
    private boolean isActive;

    public TicketInfor() {
    }

    public TicketInfor(int ticketInfoID, String ticketName, String ticketDescription, String category, double price,
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

    // Getters and Setters

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

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
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

    @Override
    public String toString() {
        return "TicketInfo{" +
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

    public void setIsActive(boolean aBoolean) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
}

