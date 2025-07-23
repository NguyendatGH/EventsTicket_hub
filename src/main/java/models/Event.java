
package models;

import java.util.Date;


public class Event {
    private int eventID;
    private String name;
    private String description;
    private String physicalLocation;
    private Date startTime;
    private Date endTime;
    private Integer totalTicketCount;
    private Boolean isApproved;
    private String status;
    private Integer genreID;
    private Integer ownerID;
    private String imageURL;
    private Boolean hasSeatingChart;
    private Boolean isDeleted;
    private Date createdAt;
    private Date updatedAt;
    private long ranking;
      public Event() {
    }

    public Event(int eventID, String name, Date startTime, Date endTime,
                 Integer totalTicketCount, String status, long ranking) {
        this.eventID = eventID;
        this.name = name;
        this.startTime = startTime;
        this.endTime = endTime;
        this.totalTicketCount = totalTicketCount;
        this.status = status;
        this.ranking = ranking;
    }
   
    public int getEventID() {
        return eventID;
    }

    public void setEventID(int eventID) {
        this.eventID = eventID;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getPhysicalLocation() {
        return physicalLocation;
    }

    public void setPhysicalLocation(String physicalLocation) {
        this.physicalLocation = physicalLocation;
    }

    public Date getStartTime() {
        return startTime;
    }

    public void setStartTime(Date startTime) {
        this.startTime = startTime;
    }

    public Date getEndTime() {
        return endTime;
    }

    public void setEndTime(Date endTime) {
        this.endTime = endTime;
    }

    public Integer getTotalTicketCount() {
        return totalTicketCount;
    }

    public void setTotalTicketCount(Integer totalTicketCount) {
        this.totalTicketCount = totalTicketCount;
    }

    public Boolean getIsApproved() {
        return isApproved;
    }

    public void setIsApproved(Boolean isApproved) {
        this.isApproved = isApproved;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Integer getGenreID() {
        return genreID;
    }

    public void setGenreID(Integer genreID) {
        this.genreID = genreID;
    }

    public Integer getOwnerID() {
        return ownerID;
    }

    public void setOwnerID(Integer ownerID) {
        this.ownerID = ownerID;
    }

    public String getImageURL() {
        return imageURL;
    }

    public void setImageURL(String imageURL) {
        this.imageURL = imageURL;
    }

    public Boolean getHasSeatingChart() {
        return hasSeatingChart;
    }

    public void setHasSeatingChart(Boolean hasSeatingChart) {
        this.hasSeatingChart = hasSeatingChart;
    }

    public Boolean getIsDeleted() {
        return isDeleted;
    }

    public void setIsDeleted(Boolean isDeleted) {
        this.isDeleted = isDeleted;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public Date getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Date updatedAt) {
        this.updatedAt = updatedAt;
    }
     public long getRanking() {
        return ranking;
    }
    public void setRanking(long ranking) {
        this.ranking = ranking;
    }
    public String toString(){
        return "e: " +this.eventID + this.name + this.status +this.imageURL;
    }
}
