package dao;

import context.DBConnection;
import models.Feedback;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.time.format.DateTimeFormatter;

public class FeedbackDAO {

    public boolean insertFeedback(Feedback feedback) {
        String sql = "INSERT INTO Feedback (UserID, EventID, OrderID, Rating, Content, IsApproved, AdminResponse, CreatedAt, UpdatedAt) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            System.out.println("Insert Feedback: " + feedback.toString());

            ps.setInt(1, feedback.getUserID());
            ps.setInt(2, feedback.getEventID());
            ps.setInt(3, feedback.getOrderID());
            ps.setInt(4, feedback.getRating());
            ps.setString(5, feedback.getContent());
            ps.setBoolean(6, true);

            if (feedback.getAdminResponse() == null) {
                ps.setNull(7, java.sql.Types.VARCHAR);
            } else {
                ps.setString(7, feedback.getAdminResponse());
            }

            ps.setTimestamp(8, Timestamp.valueOf(feedback.getCreatedAt()));
            ps.setTimestamp(9, Timestamp.valueOf(feedback.getUpdatedAt()));

            int rowsAffected = ps.executeUpdate();
            System.out.println("Rows inserted: " + rowsAffected);

            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateFeedbackContent(int feedbackID, String newContent, LocalDateTime updatedAt) {
        String sql = "UPDATE Feedback SET Content = ?, UpdatedAt = ? WHERE FeedbackID = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newContent);
            ps.setTimestamp(2, Timestamp.valueOf(updatedAt));
            ps.setInt(3, feedbackID);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Feedback> getFeedbackByUser(int userID) {
        List<Feedback> list = new ArrayList<>();
        String sql = "SELECT f.*, u.FullName AS UserName FROM Feedback f JOIN Users u ON f.UserID = u.Id WHERE f.UserID = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Feedback fb = new Feedback(
                        rs.getInt("FeedbackID"),
                        rs.getInt("UserID"),
                        rs.getInt("EventID"),
                        rs.getInt("OrderID"),
                        rs.getInt("Rating"),
                        rs.getString("Content"),
                        rs.getBoolean("IsApproved"),
                        rs.getString("AdminResponse"),
                        rs.getTimestamp("CreatedAt").toLocalDateTime(),
                        rs.getTimestamp("UpdatedAt").toLocalDateTime(),
                        rs.getString("UserName"));

                list.add(fb);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Feedback> getApprovedFeedbackByEvent(int eventId) {
        List<Feedback> list = new ArrayList<>();
        String sql = "SELECT f.*, u.Username AS UserName "
                + "FROM Feedback f "
                + "JOIN Users u ON f.UserID = u.Id "
                + "WHERE f.EventID = ? AND f.IsApproved = 1 "
                + "ORDER BY f.CreatedAt DESC";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            ResultSet rs = ps.executeQuery();

            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");

            while (rs.next()) {
                LocalDateTime createdAt = rs.getTimestamp("CreatedAt").toLocalDateTime();
                LocalDateTime updatedAt = rs.getTimestamp("UpdatedAt").toLocalDateTime();

                Feedback fb = new Feedback(
                        rs.getInt("FeedbackID"),
                        rs.getInt("UserID"),
                        rs.getInt("EventID"),
                        rs.getInt("OrderID"),
                        rs.getInt("Rating"),
                        rs.getString("Content"),
                        rs.getBoolean("IsApproved"),
                        rs.getString("AdminResponse"),
                        createdAt,
                        updatedAt,
                        rs.getString("UserName"));

                // Thêm ngày định dạng sẵn
                fb.setFormattedDate(createdAt.format(formatter));

                list.add(fb);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public boolean approveAllFeedback() {
        String sql = "UPDATE Feedback SET IsApproved = 1 WHERE IsApproved = 0";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            int updated = ps.executeUpdate();
            System.out.println("Updated " + updated + " feedback(s) to approved.");
            return updated > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Feedback> getApprovedFeedbackByEventAndRating(int eventId, int rating) {
        List<Feedback> list = new ArrayList<>();
        String sql = "SELECT f.*, u.Username AS UserName "
                + "FROM Feedback f "
                + "JOIN Users u ON f.UserID = u.Id "
                + "WHERE f.EventID = ? AND f.IsApproved = 1 AND f.Rating = ? "
                + "ORDER BY f.CreatedAt DESC";

        System.out.println("[DAO] Feedback filtered for EventID = " + eventId + ", Rating = " + rating);

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            ps.setInt(2, rating);
            ResultSet rs = ps.executeQuery();

            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");

            while (rs.next()) {
                LocalDateTime createdAt = rs.getTimestamp("CreatedAt").toLocalDateTime();
                LocalDateTime updatedAt = rs.getTimestamp("UpdatedAt").toLocalDateTime();

                Feedback fb = new Feedback(
                        rs.getInt("FeedbackID"),
                        rs.getInt("UserID"),
                        rs.getInt("EventID"),
                        rs.getInt("OrderID"),
                        rs.getInt("Rating"),
                        rs.getString("Content"),
                        rs.getBoolean("IsApproved"),
                        rs.getString("AdminResponse"),
                        createdAt,
                        updatedAt,
                        rs.getString("UserName")
                );

                fb.setFormattedDate(createdAt.format(formatter));

                // LOG feedback info
                System.out.println("-> " + fb.getUserName() + " | Rating: " + fb.getRating() + " | Content: " + fb.getContent());

                list.add(fb);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public Feedback getFeedbackById(int feedbackId) {
        String sql = "SELECT * FROM Feedback WHERE FeedbackID = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, feedbackId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Feedback(
                        rs.getInt("FeedbackID"),
                        rs.getInt("UserID"),
                        rs.getInt("EventID"),
                        rs.getInt("OrderID"),
                        rs.getInt("Rating"),
                        rs.getString("Content"),
                        rs.getBoolean("IsApproved"),
                        rs.getString("AdminResponse"),
                        rs.getTimestamp("CreatedAt").toLocalDateTime(),
                        rs.getTimestamp("UpdatedAt").toLocalDateTime(),
                        null 
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateFeedbackContentAndRating(int feedbackID, String newContent, int newRating, LocalDateTime updatedAt) {
        String sql = "UPDATE Feedback SET Content = ?, Rating = ?, UpdatedAt = ? WHERE FeedbackID = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newContent);
            ps.setInt(2, newRating);
            ps.setTimestamp(3, Timestamp.valueOf(updatedAt));
            ps.setInt(4, feedbackID);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

}
