// File: src/main/java/Dao/TicketInforDAO.java
package Dao;

import java.math.BigDecimal; // Import BigDecimal
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException; // Import SQLException
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import Models.TicketInfor;
import context.DBConnection; // Đảm bảo đúng tên package của DBConnection

public class TicketInforDAO {

    // Lấy tất cả thông tin vé đang hoạt động, sắp xếp theo giá giảm dần
    private static final String SELECT_ALL_ACTIVE_TICKETS = "SELECT * FROM TicketInfo WHERE IsActive = 1 ORDER BY Price DESC";
    // Lấy thông tin vé theo EventID, sắp xếp theo giá giảm dần
    private static final String SELECT_TICKET_BY_EVENTID = "SELECT * FROM TicketInfo WHERE EventID = ? AND IsActive = 1 ORDER BY Price DESC";


    public List<TicketInfor> getAllTicketInfo() {
        List<TicketInfor> list = new ArrayList<>();
        // Sử dụng try-with-resources để đảm bảo Connection, PreparedStatement, ResultSet được đóng tự động
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_ALL_ACTIVE_TICKETS);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                TicketInfor ticket = new TicketInfor();
                ticket.setTicketInfoID(rs.getInt("TicketInfoID"));
                ticket.setTicketName(rs.getString("TicketName"));
                ticket.setTicketDescription(rs.getString("TicketDescription"));
                ticket.setCategory(rs.getString("Category"));
                ticket.setPrice(rs.getBigDecimal("Price")); // Get as BigDecimal
                ticket.setSalesStartTime(rs.getTimestamp("SalesStartTime").toLocalDateTime());
                ticket.setSalesEndTime(rs.getTimestamp("SalesEndTime").toLocalDateTime());
                ticket.setEventID(rs.getInt("EventID"));
                ticket.setMaxQuantityPerOrder(rs.getInt("MaxQuantityPerOrder"));
                ticket.setActive(rs.getBoolean("IsActive"));
                // Nếu bạn có cột CreatedAt và UpdatedAt trong DB và muốn dùng trong model, thêm vào đây:
                // ticket.setCreatedAt(rs.getTimestamp("CreatedAt").toLocalDateTime());
                // ticket.setUpdatedAt(rs.getTimestamp("UpdatedAt").toLocalDateTime());

                list.add(ticket);
            }
        } catch (SQLException e) { // Bắt SQLException thay vì Exception chung chung
            e.printStackTrace();
            // Có thể log chi tiết hơn hoặc throw một BusinessException tùy vào kiến trúc
        }
        return list;
    }

    public List<TicketInfor> getTicketInfosByEventID(int eventID) {
        List<TicketInfor> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_TICKET_BY_EVENTID)) {

            ps.setInt(1, eventID);
            try (ResultSet rs = ps.executeQuery()) { // ResultSet cũng nên trong try-with-resources

                while (rs.next()) {
                    TicketInfor ticket = new TicketInfor();
                    ticket.setTicketInfoID(rs.getInt("TicketInfoID"));
                    ticket.setTicketName(rs.getString("TicketName"));
                    ticket.setTicketDescription(rs.getString("TicketDescription"));
                    ticket.setCategory(rs.getString("Category"));
                    ticket.setPrice(rs.getBigDecimal("Price")); // Get as BigDecimal
                    ticket.setSalesStartTime(rs.getTimestamp("SalesStartTime").toLocalDateTime());
                    ticket.setSalesEndTime(rs.getTimestamp("SalesEndTime").toLocalDateTime());
                    ticket.setEventID(rs.getInt("EventID"));
                    ticket.setMaxQuantityPerOrder(rs.getInt("MaxQuantityPerOrder"));
                    ticket.setActive(rs.getBoolean("IsActive"));
                    // ticket.setCreatedAt(rs.getTimestamp("CreatedAt").toLocalDateTime());
                    // ticket.setUpdatedAt(rs.getTimestamp("UpdatedAt").toLocalDateTime());

                    list.add(ticket);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}