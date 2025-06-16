
package dao;


import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import models.Promotion;

public class PromotionDAO {
    private Connection connection;
    
    public PromotionDAO(Connection connection) {
        this.connection = connection;
    }
    
    public boolean createPromotion(Promotion promotion) {
        String sql = "INSERT INTO promotions (event_id, promotion_name, promotion_code, " +
                    "start_time, end_time, is_active) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setInt(1, promotion.getEventID());
            pstmt.setString(2, promotion.getPromotionName());
            pstmt.setString(3, promotion.getPromotionCode());
            pstmt.setTimestamp(4, promotion.getStartTime());
            pstmt.setTimestamp(5, promotion.getEndTime());
            pstmt.setBoolean(6, promotion.isActive());
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public List<Promotion> getPromotionsByEventId(int eventId) {
        List<Promotion> promotions = new ArrayList<>();
        String sql = "SELECT * FROM promotions WHERE event_id = ?";
        
        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setInt(1, eventId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Promotion promotion = new Promotion();
                promotion.setPromotionID(rs.getInt("promotion_id"));
                promotion.setEventID(rs.getInt("event_id"));
                promotion.setPromotionName(rs.getString("promotion_name"));
                promotion.setPromotionCode(rs.getString("promotion_code"));
                promotion.setStartTime(rs.getTimestamp("start_time"));
                promotion.setEndTime(rs.getTimestamp("end_time"));
                promotion.setActive(rs.getBoolean("is_active"));
                promotions.add(promotion);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return promotions;
    }
}
