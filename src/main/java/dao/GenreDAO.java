//package dao;
//
////import com.masterticket.model.Genre;
//import java.sql.*;
//import java.util.ArrayList;
//import java.util.List;
//import model.Genre;
//
//public class GenreDAO {
//    private Connection connection;
//    
//    public GenreDAO(Connection connection) {
//        this.connection = connection;
//    }
//    
//    public List<Genre> getAllGenres() {
//        List<Genre> genres = new ArrayList<>();
//        String sql = "SELECT * FROM genres ORDER BY genre_name";
//        
//        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
//            ResultSet rs = pstmt.executeQuery();
//            
//            while (rs.next()) {
//                Genre genre = new Genre();
//                genre.setGenreID(rs.getInt("genre_id"));
//                genre.setGenreName(rs.getString("genre_name"));
//                genre.setDescription(rs.getString("description"));
//                genres.add(genre);
//            }
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//        return genres;
//    }
//    
//    public Genre getGenreById(int genreId) {
//        String sql = "SELECT * FROM genres WHERE genre_id = ?";
//        
//        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
//            pstmt.setInt(1, genreId);
//            ResultSet rs = pstmt.executeQuery();
//            
//            if (rs.next()) {
//                Genre genre = new Genre();
//                genre.setGenreID(rs.getInt("genre_id"));
//                genre.setGenreName(rs.getString("genre_name"));
//                genre.setDescription(rs.getString("description"));
//                return genre;
//            }
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//        return null;
//    }
//}