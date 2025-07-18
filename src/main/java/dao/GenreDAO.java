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
                genre.setGenreID(rs.getInt("GenreID"));
                genre.setGenreName(rs.getString("GenreName"));
                genre.setDescription(rs.getString("Description"));
                genre.setCreatedAt(rs.getTimestamp("CreatedAt"));
                genres.add(genre);
            }
            System.out.println("Fetched " + genres.size() + " genres from database");
        } catch (SQLException e) {
            System.out.println("Error fetching genres: " + e.getMessage());
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
                genre.setGenreID(rs.getInt("GenreID"));
                genre.setGenreName(rs.getString("GenreName"));
                genre.setDescription(rs.getString("Description"));
                genre.setCreatedAt(rs.getTimestamp("CreatedAt"));
                System.out.println("Fetched genre with ID: " + genreId);
                return genre;
            } else {
                System.out.println("No genre found with ID: " + genreId);
            }
        } catch (SQLException e) {
            System.out.println("Error fetching genre by ID: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
}
