package models;

import java.sql.Timestamp;

public class Genre {
    private int genreID;
    private String genreName;
    private String description;
    private Timestamp createdAt;

    public Genre() {}

    public Genre(int genreID, String genreName, String description, Timestamp createdAt) {
        this.genreID = genreID;
        this.genreName = genreName;
        this.description = description;
        this.createdAt = createdAt;
    }

    public int getGenreID() {
        return genreID;
    }

    public void setGenreID(int genreID) {
        this.genreID = genreID;
    }

    public String getGenreName() {
        return genreName;
    }

    public void setGenreName(String genreName) {
        this.genreName = genreName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}