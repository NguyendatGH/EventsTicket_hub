package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import context.DBConnection;
import models.Genre;

public class GenreDAO {
    private Connection connection;

    public GenreDAO() {
        this.connection = DBConnection.getConnection();
    }
    
    public List<Genre> getAllGenres() {
        List<Genre> genres = new ArrayList<>();
        String sql = "SELECT * FROM genres ORDER BY genreName";
        
        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Genre genre = new Genre();
                genre.setGenreID(rs.getInt("genreId"));
                genre.setGenreName(rs.getString("genreName"));
                genre.setDescription(rs.getString("description"));
                genres.add(genre);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return genres;
    }
    
    public Genre getGenreById(int genreId) {
        String sql = "SELECT * FROM genres WHERE genreId = ?";
        
        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setInt(1, genreId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                Genre genre = new Genre();
                genre.setGenreID(rs.getInt("genreId"));
                genre.setGenreName(rs.getString("genreName"));
                genre.setDescription(rs.getString("description"));
                return genre;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
