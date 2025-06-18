/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package models;

import java.time.LocalDateTime;

public class Seat {
    private int seatId;
    private int eventId;
    private String seatNumber;
    private String seatRow;
    private String seatSection;
    private String seatStatus; 
    private LocalDateTime createdAt;

    public Seat() {
    }

    public Seat(int seatId, int eventId, String seatNumber, String seatRow,
                String seatSection, String seatStatus, LocalDateTime createdAt) {
        this.seatId = seatId;
        this.eventId = eventId;
        this.seatNumber = seatNumber;
        this.seatRow = seatRow;
        this.seatSection = seatSection;
        this.seatStatus = seatStatus;
        this.createdAt = createdAt;
    }

    // Getters and Setters

    public int getSeatId() {
        return seatId;
    }

    public void setSeatId(int seatId) {
        this.seatId = seatId;
    }

    public int getEventId() {
        return eventId;
    }

    public void setEventId(int eventId) {
        this.eventId = eventId;
    }

    public String getSeatNumber() {
        return seatNumber;
    }

    public void setSeatNumber(String seatNumber) {
        this.seatNumber = seatNumber;
    }

    public String getSeatRow() {
        return seatRow;
    }

    public void setSeatRow(String seatRow) {
        this.seatRow = seatRow;
    }

    public String getSeatSection() {
        return seatSection;
    }

    public void setSeatSection(String seatSection) {
        this.seatSection = seatSection;
    }

    public String getSeatStatus() {
        return seatStatus;
    }

    public void setSeatStatus(String seatStatus) {
        this.seatStatus = seatStatus;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "Seat{" +
                "seatId=" + seatId +
                ", eventId=" + eventId +
                ", seatNumber='" + seatNumber + '\'' +
                ", seatRow='" + seatRow + '\'' +
                ", seatSection='" + seatSection + '\'' +
                ", seatStatus='" + seatStatus + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}
