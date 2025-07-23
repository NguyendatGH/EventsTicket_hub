package models;

public class Seat {
    private int seatId;
    private int zoneId;
    private String label;
    private String color;
    private double price;
    private int x;
    private int y;
    private double relativeX;
    private double relativeY;
    private String status;

    // Constructors
    public Seat() {
    }

    public Seat(int zoneId, String label, String color, double price, int x, int y, double relativeX, double relativeY,
            String status) {
        this.zoneId = zoneId;
        this.label = label;
        this.color = color;
        this.price = price;
        this.x = x;
        this.y = y;
        this.relativeX = relativeX;
        this.relativeY = relativeY;
        this.status = status;
    }

    // Getters and Setters
    public int getSeatId() {
        return seatId;
    }

    public void setSeatId(int seatId) {
        this.seatId = seatId;
    }

    public int getZoneId() {
        return zoneId;
    }

    public void setZoneId(int zoneId) {
        this.zoneId = zoneId;
    }

    public String getLabel() {
        return label;
    }

    public void setLabel(String label) {
        this.label = label;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public double getSeatPrice() {
        return this.price;
    }

    public void setSeatPrice(double price) {
        this.price = price;
    }

    public int getX() {
        return x;
    }

    public void setX(int x) {
        this.x = x;
    }

    public int getY() {
        return y;
    }

    public void setY(int y) {
        this.y = y;
    }

    public double getRelativeX() {
        return relativeX;
    }

    public void setRelativeX(double relativeX) {
        this.relativeX = relativeX;
    }

    public double getRelativeY() {
        return relativeY;
    }

    public void setRelativeY(double relativeY) {
        this.relativeY = relativeY;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "Seat{" +
                "seatId=" + seatId +
                ", zoneId=" + zoneId +
                ", label='" + label + '\'' +
                ", color='" + color + '\'' +
                 ", price='" + price + '\'' +
                ", x=" + x +
                ", y=" + y +
                ", relativeX=" + relativeX +
                ", relativeY=" + relativeY +
                ", status='" + status + '\'' +
                '}';
    }
}