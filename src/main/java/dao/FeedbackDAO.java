package dao;

import context.DBConnection;
import models.Feedback;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class FeedbackDAO {

    public boolean insertFeedback(Feedback feedback) {
        String sql = "INSERT INTO Feedback (UserID, EventID, OrderID, Rating, Content, IsApproved, AdminResponse, CreatedAt, UpdatedAt) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            System.out.println("Insert Feedback: " + feedback.toString()); // Debug feedback trước khi insert

            ps.setInt(1, feedback.getUserID());
            ps.setInt(2, feedback.getEventID());
            ps.setInt(3, feedback.getOrderID());
            ps.setInt(4, feedback.getRating());
            ps.setString(5, feedback.getContent());
            ps.setBoolean(6, feedback.isApprove());

            if (feedback.getAdminResponse() == null) {
                ps.setNull(7, java.sql.Types.VARCHAR);
            } else {
                ps.setString(7, feedback.getAdminResponse());
            }

            ps.setTimestamp(8, Timestamp.valueOf(feedback.getCreatedAt()));
            ps.setTimestamp(9, Timestamp.valueOf(feedback.getUpdatedAt()));

            int rowsAffected = ps.executeUpdate();
            System.out.println("Rows inserted: " + rowsAffected); // Debug số dòng insert thành công

            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace(); // In lỗi chi tiết
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
        String sql = "SELECT * FROM Feedback WHERE UserID = ?";
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
                        rs.getTimestamp("UpdatedAt").toLocalDateTime()
                );
                list.add(fb);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Feedback> getFeedbackByEventId(int eventId) {
        List<Feedback> list = new ArrayList<>();
        String sql = "SELECT f.*, u.Username FROM Feedback f JOIN Users u ON f.UserID = u.Id WHERE f.EventID = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, eventId);
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
                    rs.getTimestamp("UpdatedAt").toLocalDateTime()
                );
                fb.setUserName(rs.getString("Username"));
                list.add(fb);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public static void main(String[] args) {
        FeedbackDAO dao = new FeedbackDAO();
        int testEventId = 1; // Thay bằng EventID bạn muốn test
        System.out.println("--- Test getFeedbackByEventId(" + testEventId + ") ---");
        List<Feedback> feedbacks = dao.getFeedbackByEventId(testEventId);
        for (Feedback fb : feedbacks) {
            System.out.println("FeedbackID: " + fb.getFeedbackID()
                + ", UserID: " + fb.getUserID()
                + ", EventID: " + fb.getEventID()
                + ", Rating: " + fb.getRating()
                + ", Content: " + fb.getContent()
                + ", CreatedAt: " + fb.getCreatedAt());
        }
        if (feedbacks.isEmpty()) {
            System.out.println("Không có feedback nào cho event này.");
        }
    }

    // Bạn có thể viết thêm: getFeedbackByOrderID, approveFeedback, respondToFeedback,...
}
