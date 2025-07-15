package models;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Promotion {
    private int promotionID;
    private int eventID;
    private String promotionName;
    private String promotionCode;
    private String promotionType;
    private Timestamp startTime;
    private Timestamp endTime;
    private BigDecimal discountPercentage;
    private BigDecimal discountAmount;
    private BigDecimal minOrderAmount;
    private BigDecimal maxDiscountAmount;
    private int maxUsageCount;
    private int currentUsageCount;
    private boolean isActive;

    public Promotion() {}

    public Promotion(int promotionID, int eventID, String promotionName, String promotionCode, String promotionType, Timestamp startTime, Timestamp endTime, BigDecimal discountPercentage, BigDecimal discountAmount, BigDecimal minOrderAmount, BigDecimal maxDiscountAmount, int maxUsageCount, int currentUsageCount, boolean isActive) {
        this.promotionID = promotionID;
        this.eventID = eventID;
        this.promotionName = promotionName;
        this.promotionCode = promotionCode;
        this.promotionType = promotionType;
        this.startTime = startTime;
        this.endTime = endTime;
        this.discountPercentage = discountPercentage;
        this.discountAmount = discountAmount;
        this.minOrderAmount = minOrderAmount;
        this.maxDiscountAmount = maxDiscountAmount;
        this.maxUsageCount = maxUsageCount;
        this.currentUsageCount = currentUsageCount;
        this.isActive = isActive;
    }

    

    public int getPromotionID() {
        return promotionID;
    }

    public void setPromotionID(int promotionID) {
        this.promotionID = promotionID;
    }

    public int getEventID() {
        return eventID;
    }

    public void setEventID(int eventID) {
        this.eventID = eventID;
    }

    public String getPromotionName() {
        return promotionName;
    }

    public void setPromotionName(String promotionName) {
        this.promotionName = promotionName;
    }

    public String getPromotionCode() {
        return promotionCode;
    }

    public void setPromotionCode(String promotionCode) {
        this.promotionCode = promotionCode;
    }

    public String getPromotionType() {
        return promotionType;
    }

    public void setPromotionType(String promotionType) {
        this.promotionType = promotionType;
    }

    public Timestamp getStartTime() {
        return startTime;
    }

    public void setStartTime(Timestamp startTime) {
        this.startTime = startTime;
    }

    public Timestamp getEndTime() {
        return endTime;
    }

    public void setEndTime(Timestamp endTime) {
        this.endTime = endTime;
    }

    public BigDecimal getDiscountPercentage() {
        return discountPercentage;
    }

    public void setDiscountPercentage(BigDecimal discountPercentage) {
        this.discountPercentage = discountPercentage;
    }

    public BigDecimal getDiscountAmount() {
        return discountAmount;
    }

    public void setDiscountAmount(BigDecimal discountAmount) {
        this.discountAmount = discountAmount;
    }

    public BigDecimal getMinOrderAmount() {
        return minOrderAmount;
    }

    public void setMinOrderAmount(BigDecimal minOrderAmount) {
        this.minOrderAmount = minOrderAmount;
    }

    public BigDecimal getMaxDiscountAmount() {
        return maxDiscountAmount;
    }

    public void setMaxDiscountAmount(BigDecimal maxDiscountAmount) {
        this.maxDiscountAmount = maxDiscountAmount;
    }

    public int getMaxUsageCount() {
        return maxUsageCount;
    }

    public void setMaxUsageCount(int maxUsageCount) {
        this.maxUsageCount = maxUsageCount;
    }

    public int getCurrentUsageCount() {
        return currentUsageCount;
    }

    public void setCurrentUsageCount(int currentUsageCount) {
        this.currentUsageCount = currentUsageCount;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }
}
