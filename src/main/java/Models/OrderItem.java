package models;

import java.util.Date;

public class OrderItem {

    private int orderItemId;
    private int orderId;
    private int ticketInfoId;
    private int eventId;
    private int ticketId; // Có thể là SeatId nếu là vé ghế ngồi
    private double unitPrice;
    private int quantity;
    private double totalPrice;
    private Date assignedAt;
    private Date createdAt;
    
    // Thêm các thuộc tính phụ để hiển thị trên giao diện (tùy chọn nhưng rất hữu ích)
    private String eventName;
    private String ticketTypeName;
    private String seatInfo;

    // Constructor không tham số
    public OrderItem() {
    }

    // Constructor đầy đủ tham số (dựa trên bảng CSDL)
    public OrderItem(int orderItemId, int orderId, int ticketInfoId, int eventId, int ticketId, double unitPrice, int quantity, double totalPrice, Date assignedAt, Date createdAt) {
        this.orderItemId = orderItemId;
        this.orderId = orderId;
        this.ticketInfoId = ticketInfoId;
        this.eventId = eventId;
        this.ticketId = ticketId;
        this.unitPrice = unitPrice;
        this.quantity = quantity;
        this.totalPrice = totalPrice;
        this.assignedAt = assignedAt;
        this.createdAt = createdAt;
    }

    public int getOrderItemId() {
        return orderItemId;
    }

    public void setOrderItemId(int orderItemId) {
        this.orderItemId = orderItemId;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public int getTicketInfoId() {
        return ticketInfoId;
    }

    public void setTicketInfoId(int ticketInfoId) {
        this.ticketInfoId = ticketInfoId;
    }

    public int getEventId() {
        return eventId;
    }

    public void setEventId(int eventId) {
        this.eventId = eventId;
    }

    public int getTicketId() {
        return ticketId;
    }

    public void setTicketId(int ticketId) {
        this.ticketId = ticketId;
    }

    public double getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(double unitPrice) {
        this.unitPrice = unitPrice;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public double getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(double totalPrice) {
        this.totalPrice = totalPrice;
    }

    public Date getAssignedAt() {
        return assignedAt;
    }

    public void setAssignedAt(Date assignedAt) {
        this.assignedAt = assignedAt;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public String getEventName() {
        return eventName;
    }

    public void setEventName(String eventName) {
        this.eventName = eventName;
    }

    public String getTicketTypeName() {
        return ticketTypeName;
    }

    public void setTicketTypeName(String ticketTypeName) {
        this.ticketTypeName = ticketTypeName;
    }

    public String getSeatInfo() {
        return seatInfo;
    }

    public void setSeatInfo(String seatInfo) {
        this.seatInfo = seatInfo;
    }
    
    
}