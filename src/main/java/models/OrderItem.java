package models;

import java.math.BigDecimal;
import java.time.LocalDateTime;


public class OrderItem {

    private int orderItemId;
    private int orderId;
    private int ticketInfoId;
    private int eventId;
    private int ticketId;
    private int quantity;
    private LocalDateTime assignedAt; 
    private LocalDateTime createdAt;  

    private BigDecimal unitPrice;    
    private BigDecimal totalPrice;    
    private String eventName;
    private String ticketTypeName;
    private String seatInfo;
    private TicketInfo ticketInfo; 

    public OrderItem() {
    }

    public OrderItem(int orderItemId, int orderId, int ticketInfoId, int eventId, int ticketId, int quantity, LocalDateTime assignedAt, LocalDateTime createdAt, BigDecimal unitPrice, BigDecimal totalPrice, String eventName, String ticketTypeName, String seatInfo, TicketInfo ticketInfo) {
        this.orderItemId = orderItemId;
        this.orderId = orderId;
        this.ticketInfoId = ticketInfoId;
        this.eventId = eventId;
        this.ticketId = ticketId;
        this.quantity = quantity;
        this.assignedAt = assignedAt;
        this.createdAt = createdAt;
        this.unitPrice = unitPrice;
        this.totalPrice = totalPrice;
        this.eventName = eventName;
        this.ticketTypeName = ticketTypeName;
        this.seatInfo = seatInfo;
        this.ticketInfo = ticketInfo;
    }


    public int getOrderItemId() { return orderItemId; }
    public void setOrderItemId(int orderItemId) { this.orderItemId = orderItemId; }

    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }

    public int getTicketInfoId() { return ticketInfoId; }
    public void setTicketInfoId(int ticketInfoId) { this.ticketInfoId = ticketInfoId; }

    public int getEventId() { return eventId; }
    public void setEventId(int eventId) { this.eventId = eventId; }

    public int getTicketId() { return ticketId; }
    public void setTicketId(int ticketId) { this.ticketId = ticketId; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public LocalDateTime getAssignedAt() { return assignedAt; }
    public void setAssignedAt(LocalDateTime assignedAt) { this.assignedAt = assignedAt; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public BigDecimal getUnitPrice() { return unitPrice; }
    public void setUnitPrice(BigDecimal unitPrice) { this.unitPrice = unitPrice; }

    public BigDecimal getTotalPrice() { return totalPrice; }
    public void setTotalPrice(BigDecimal totalPrice) { this.totalPrice = totalPrice; }

    public String getEventName() { return eventName; }
    public void setEventName(String eventName) { this.eventName = eventName; }

    public String getTicketTypeName() { return ticketTypeName; }
    public void setTicketTypeName(String ticketTypeName) { this.ticketTypeName = ticketTypeName; }

    public String getSeatInfo() { return seatInfo; }
    public void setSeatInfo(String seatInfo) { this.seatInfo = seatInfo; }
    
    public TicketInfo getTicketInfo() { return ticketInfo; }
    public void setTicketInfo(TicketInfo ticketInfo) { this.ticketInfo = ticketInfo; }
}