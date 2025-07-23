package dto;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class TransactionDTO {
    private int transactionId;
    private String eventName;
    private String eventOwner;
    private String ownerEmail;
    private Timestamp transactionDate;
    private BigDecimal amount;
    private int ticketCount;
    private String status;

    // Constructors
    public TransactionDTO() {}

    public TransactionDTO(int transactionId, String eventName, String eventOwner, String ownerEmail, 
                         Timestamp transactionDate, BigDecimal amount, int ticketCount, String status) {
        this.transactionId = transactionId;
        this.eventName = eventName;
        this.eventOwner = eventOwner;
        this.ownerEmail = ownerEmail;
        this.transactionDate = transactionDate;
        this.amount = amount;
        this.ticketCount = ticketCount;
        this.status = status;
    }

    // Getters and Setters
    public int getTransactionId() {
        return transactionId;
    }

    public void setTransactionId(int transactionId) {
        this.transactionId = transactionId;
    }

    public String getEventName() {
        return eventName;
    }

    public void setEventName(String eventName) {
        this.eventName = eventName;
    }

    public String getEventOwner() {
        return eventOwner;
    }

    public void setEventOwner(String eventOwner) {
        this.eventOwner = eventOwner;
    }

    public String getOwnerEmail() {
        return ownerEmail;
    }

    public void setOwnerEmail(String ownerEmail) {
        this.ownerEmail = ownerEmail;
    }

    public Timestamp getTransactionDate() {
        return transactionDate;
    }

    public void setTransactionDate(Timestamp transactionDate) {
        this.transactionDate = transactionDate;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public int getTicketCount() {
        return ticketCount;
    }

    public void setTicketCount(int ticketCount) {
        this.ticketCount = ticketCount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}