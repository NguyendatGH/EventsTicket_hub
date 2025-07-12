package models;

import java.time.LocalDateTime;


public class TicketInventory {

    private int inventoryID;
    private int ticketInfoID;
    private int totalQuantity;
    private int soldQuantity;
    private int reservedQuantity;
    private LocalDateTime lastUpdated;

    public TicketInventory() {
    }


    public TicketInventory(int inventoryID, int ticketInfoID, int totalQuantity, int soldQuantity, int reservedQuantity, LocalDateTime lastUpdated) {
        this.inventoryID = inventoryID;
        this.ticketInfoID = ticketInfoID;
        this.totalQuantity = totalQuantity;
        this.soldQuantity = soldQuantity;
        this.reservedQuantity = reservedQuantity;
        this.lastUpdated = lastUpdated;
    }


    public int getInventoryID() {
        return inventoryID;
    }

    public void setInventoryID(int inventoryID) {
        this.inventoryID = inventoryID;
    }

    public int getTicketInfoID() {
        return ticketInfoID;
    }

    public void setTicketInfoID(int ticketInfoID) {
        this.ticketInfoID = ticketInfoID;
    }

    public int getTotalQuantity() {
        return totalQuantity;
    }

    public void setTotalQuantity(int totalQuantity) {
        this.totalQuantity = totalQuantity;
    }

    public int getSoldQuantity() {
        return soldQuantity;
    }

    public void setSoldQuantity(int soldQuantity) {
        this.soldQuantity = soldQuantity;
    }

    public int getReservedQuantity() {
        return reservedQuantity;
    }

    public void setReservedQuantity(int reservedQuantity) {
        this.reservedQuantity = reservedQuantity;
    }

    public LocalDateTime getLastUpdated() {
        return lastUpdated;
    }

    public void setLastUpdated(LocalDateTime lastUpdated) {
        this.lastUpdated = lastUpdated;
    }

    public int getAvailableQuantity() {
        return this.totalQuantity - this.soldQuantity - this.reservedQuantity;
    }

    @Override
    public String toString() {
        return "TicketInventory{" +
                "inventoryID=" + inventoryID +
                ", ticketInfoID=" + ticketInfoID +
                ", totalQuantity=" + totalQuantity +
                ", soldQuantity=" + soldQuantity +
                ", reservedQuantity=" + reservedQuantity +
                ", availableQuantity=" + getAvailableQuantity() + 
                ", lastUpdated=" + lastUpdated +
                '}';
    }
}