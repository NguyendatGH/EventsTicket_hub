package models;

public class TopEventOwner {
    private int id;
    private String name;
    private int numsOfEvent;
    private int numsOfTicketSelled;
    private double totalRevenue;
    private boolean isLocked;
    private String avatarURL;

    public TopEventOwner() {

    }

    public TopEventOwner(int id, String name, int numOfEvent, int numOfTicketSelled, double totalRevenue,
            boolean isLocked, String avatarURL) {
        this.id = id;
        this.name = name;
        this.numsOfEvent = numOfEvent;
        this.numsOfTicketSelled = numOfTicketSelled;
        this.totalRevenue = totalRevenue;
        this.isLocked = isLocked;
        this.avatarURL = avatarURL;
    }

    public int getId() {
        return this.id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return this.name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getNumsOfEvent() {
        return this.numsOfEvent;
    }

    public void setNumsOfEvent(int numsOfEvent) {
        this.numsOfEvent = numsOfEvent;
    }

    public int getNumsOfTicketSelled() {
        return this.numsOfTicketSelled;
    }

    public void setNumsOfTicketSelled(int numsOfTicketSelled) {
        this.numsOfTicketSelled = numsOfTicketSelled;
    }

    public double getTotalRevenue() {
        return this.totalRevenue;
    }

    public void setTotalRevenue(double totalRevenue) {
        this.totalRevenue = totalRevenue;
    }

    public boolean getStatus() {
        return this.isLocked;
    }

    public void setStatus(boolean isLocked) {
        this.isLocked = isLocked;
    }

    public String getAvatarURL() {
        return this.avatarURL;
    }

    public void setAvatarURL(String avatarURL) {
        this.avatarURL = avatarURL;
    }

    @Override
    public String toString() {
        return "top event organizer: " + this.id + "/" + this.name + "," + this.isLocked + ", Avatar: "
                + this.avatarURL + "revenue: " + this.totalRevenue;
    }
}