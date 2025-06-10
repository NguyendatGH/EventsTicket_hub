package dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import context.DBConnection;
import models.TicketInfor;

public class TicketInforDAO {

    // Câu lệnh SQL mới để lấy cả EventName bằng cách JOIN với bảng Events
    private static final String SELECT_TICKET_BY_ID_SQL = 
        "SELECT ti.*, e.Name AS EventName FROM TicketInfo ti JOIN Events e ON ti.EventID = e.EventID WHERE ti.TicketInfoID = ? AND ti.IsActive = 1";
    
    private static final String SELECT_TICKET_BY_EVENTID_SQL = 
        "SELECT ti.*, e.Name AS EventName FROM TicketInfo ti JOIN Events e ON ti.EventID = e.EventID WHERE ti.EventID = ? AND ti.IsActive = 1 ORDER BY ti.Price DESC";

    /**
     * TẠO MỚI: Phương thức quan trọng còn thiếu để lấy thông tin một vé cụ thể bằng ID.
     * @param ticketId ID của loại vé cần lấy.
     * @return một đối tượng TicketInfor hoặc null nếu không tìm thấy.
     */
    public TicketInfor getTicketInfoById(int ticketId) {
        TicketInfor ticket = null;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_TICKET_BY_ID_SQL)) {
            
            ps.setInt(1, ticketId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    ticket = new TicketInfor();
                    ticket.setTicketInforID(rs.getInt("TicketInfoID"));
                    ticket.setTicketName(rs.getString("TicketName"));
                    ticket.setTicketDescription(rs.getString("TicketDescription"));
                    ticket.setCategory(rs.getString("Category"));
                    ticket.setPrice(rs.getBigDecimal("Price"));
                    ticket.setSalesStartTime(rs.getTimestamp("SalesStartTime").toLocalDateTime());
                    ticket.setSalesEndTime(rs.getTimestamp("SalesEndTime").toLocalDateTime());
                    ticket.setEventID(rs.getInt("EventID"));
                    ticket.setMaxQuantityPerOrder(rs.getInt("MaxQuantityPerOrder"));
                    ticket.setActive(rs.getBoolean("IsActive"));                                     
                    ticket.setTicketName(rs.getString("EventName"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return ticket;
    }

    /**
     * Cập nhật lại phương thức này để sử dụng câu lệnh JOIN mới.
     */
    public List<TicketInfor> getTicketInfosByEventID(int eventID) {
        List<TicketInfor> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_TICKET_BY_EVENTID_SQL)) {

            ps.setInt(1, eventID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    TicketInfor ticket = new TicketInfor();
                    ticket.setTicketInforID(rs.getInt("TicketInfoID"));
                    ticket.setTicketName(rs.getString("TicketName"));
                    ticket.setTicketDescription(rs.getString("TicketDescription"));
                    ticket.setCategory(rs.getString("Category"));
                    ticket.setPrice(rs.getBigDecimal("Price"));
                    ticket.setSalesStartTime(rs.getTimestamp("SalesStartTime").toLocalDateTime());
                    ticket.setSalesEndTime(rs.getTimestamp("SalesEndTime").toLocalDateTime());
                    ticket.setEventID(rs.getInt("EventID"));
                    ticket.setMaxQuantityPerOrder(rs.getInt("MaxQuantityPerOrder"));
                    ticket.setActive(rs.getBoolean("IsActive"));
                     ticket.setTicketName(rs.getString("EventName"));
                    list.add(ticket);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
}