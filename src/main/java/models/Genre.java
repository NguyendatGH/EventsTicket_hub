package models;

public class Genre {
    private int genreID;
    private String genreName;
    private String description;
    
    public Genre() {}
    
    public Genre(int genreID, String genreName, String description) {
        this.genreID = genreID;
        this.genreName = genreName;
        this.description = description;
    }
    
    public int getGenreID() { return genreID; }
    public void setGenreID(int genreID) { this.genreID = genreID; }
    
    public String getGenreName() { return genreName; }
    public void setGenreName(String genreName) { this.genreName = genreName; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
}