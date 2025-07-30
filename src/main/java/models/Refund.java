/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package models;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 *
 * @author admin
 */
public class Refund {

    private int refundId;
    private int orderId;
    private Integer orderItemId;
    private int userId;
    private Integer adminId;
    private BigDecimal refundAmount;
    private String refundReason;
    private String refundStatus;
    private Integer paymentMethodId;
    private LocalDateTime refundRequestDate;
    private LocalDateTime refundProcessedDate;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private boolean isDeleted;
    private String userName;
    private String orderNumber;

    public Refund() {
    }

    public Refund(int refundId, int orderId, Integer orderItemId, int userId, Integer adminId, BigDecimal refundAmount, String refundReason, String refundStatus, Integer paymentMethodId, LocalDateTime refundRequestDate, LocalDateTime refundProcessedDate, LocalDateTime createdAt, LocalDateTime updatedAt, boolean isDeleted) {
        this.refundId = refundId;
        this.orderId = orderId;
        this.orderItemId = orderItemId;
        this.userId = userId;
        this.adminId = adminId;
        this.refundAmount = refundAmount;
        this.refundReason = refundReason;
        this.refundStatus = refundStatus;
        this.paymentMethodId = paymentMethodId;
        this.refundRequestDate = refundRequestDate;
        this.refundProcessedDate = refundProcessedDate;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.isDeleted = isDeleted;
    }

    public int getRefundId() {
        return refundId;
    }

    public void setRefundId(int refundId) {
        this.refundId = refundId;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public Integer getOrderItemId() {
        return orderItemId;
    }

    public void setOrderItemId(Integer orderItemId) {
        this.orderItemId = orderItemId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public Integer getAdminId() {
        return adminId;
    }

    public void setAdminId(Integer adminId) {
        this.adminId = adminId;
    }

    public BigDecimal getRefundAmount() {
        return refundAmount;
    }

    public void setRefundAmount(BigDecimal refundAmount) {
        this.refundAmount = refundAmount;
    }

    public String getRefundReason() {
        return refundReason;
    }

    public void setRefundReason(String refundReason) {
        this.refundReason = refundReason;
    }

    public String getRefundStatus() {
        return refundStatus;
    }

    public void setRefundStatus(String refundStatus) {
        this.refundStatus = refundStatus;
    }

    public Integer getPaymentMethodId() {
        return paymentMethodId;
    }

    public void setPaymentMethodId(Integer paymentMethodId) {
        this.paymentMethodId = paymentMethodId;
    }

    public LocalDateTime getRefundRequestDate() {
        return refundRequestDate;
    }

    public void setRefundRequestDate(LocalDateTime refundRequestDate) {
        this.refundRequestDate = refundRequestDate;
    }

    public LocalDateTime getRefundProcessedDate() {
        return refundProcessedDate;
    }

    public void setRefundProcessedDate(LocalDateTime refundProcessedDate) {
        this.refundProcessedDate = refundProcessedDate;
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

    public boolean isIsDeleted() {
        return isDeleted;
    }

    public void setIsDeleted(boolean isDeleted) {
        this.isDeleted = isDeleted;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getOrderNumber() {
        return orderNumber;
    }

    public void setOrderNumber(String orderNumber) {
        this.orderNumber = orderNumber;
    }
}
