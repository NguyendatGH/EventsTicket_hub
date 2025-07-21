package models;

import java.util.ArrayList;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONObject;

public class Zone {
    private int id;
    private String name;
    private String shape;
    private String color;
    private int rows;
    private int seatsPerRow;
    private int totalSeats;
    private int x;
    private int y;
    private int rotation;
    private double ticketPrice;
    private List<Coordinate> vertices;
    private double radiusX;
    private double radiusY;

    public Zone() {
        vertices = new ArrayList<>();
    }

    public Zone(JSONObject json) {
        this.id = json.getInt("id");
        this.name = json.getString("name");
        this.shape = json.getString("shape");
        this.color = json.getString("color");
        this.rows = json.getInt("rows");
        this.seatsPerRow = json.getInt("seatsPerRow");
        this.totalSeats = json.getInt("totalSeats");
        this.x = json.getInt("x");
        this.y = json.getInt("y");
        this.rotation = json.getInt("rotation");
        this.ticketPrice = json.getDouble("ticketPrice");
        this.vertices = new ArrayList<>();
        if (shape.equals("rectangle")) {
            JSONArray verticesArray = json.getJSONArray("vertices");
            for (int i = 0; i < verticesArray.length(); i++) {
                JSONObject vertex = verticesArray.getJSONObject(i);
                this.vertices.add(new Coordinate(vertex.getInt("x"), vertex.getInt("y")));
            }
        } else if (shape.equals("circle")) {
            this.radiusX = json.getDouble("radiusX");
            this.radiusY = json.getDouble("radiusY");
        }
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getShape() {
        return shape;
    }

    public void setShape(String shape) {
        this.shape = shape;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public int getRows() {
        return rows;
    }

    public void setRows(int rows) {
        this.rows = rows;
    }

    public int getSeatsPerRow() {
        return seatsPerRow;
    }

    public void setSeatsPerRow(int seatsPerRow) {
        this.seatsPerRow = seatsPerRow;
    }

    public int getTotalSeats() {
        return totalSeats;
    }

    public void setTotalSeats(int totalSeats) {
        this.totalSeats = totalSeats;
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

    public int getRotation() {
        return rotation;
    }

    public void setRotation(int rotation) {
        this.rotation = rotation;
    }

    public double getTicketPrice() {
        return ticketPrice;
    }

    public void setTicketPrice(double ticketPrice) {
        this.ticketPrice = ticketPrice;
    }

    public List<Coordinate> getVertices() {
        return vertices;
    }

    public void setVertices(List<Coordinate> vertices) {
        this.vertices = vertices;
    }

    public double getRadiusX() {
        return radiusX;
    }

    public void setRadiusX(double radiusX) {
        this.radiusX = radiusX;
    }

    public double getRadiusY() {
        return radiusY;
    }

    public void setRadiusY(double radiusY) {
        this.radiusY = radiusY;
    }

    public static class Coordinate {
        private int x;
        private int y;

        public Coordinate(int x, int y) {
            this.x = x;
            this.y = y;
        }

        public int getX() {
            return x;
        }

        public int getY() {
            return y;
        }
    }
}