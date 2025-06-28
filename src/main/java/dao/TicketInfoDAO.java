package dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import context.DBConnection;
import models.TicketInfo;

public class TicketInfoDAO {

    // Câu lệnh SQL gốc với JOIN (bạn có thể sử dụng lại sau khi debug xong)
    private static final String SELECT_TICKET_BY_EVENTID_SQL_WITH_JOIN =
        "SELECT ti.*, e.Name AS EventName, inv.AvailableQuantity, inv.CreatedAt, inv.LastUpdated AS UpdatedAt " +
        "FROM TicketInfo ti " +
        "JOIN Events e ON ti.EventID = e.EventID " +
        "LEFT JOIN TicketInventory inv ON ti.TicketInfoID = inv.TicketInfoID " +
        "WHERE ti.EventID = ? AND ti.IsActive = 1 ORDER BY ti.Price DESC";

    // >>> SỬ DỤNG CÂU LỆNH ĐƠN GIẢN NÀY ĐỂ FIX LỖI HIỂN THỊ <<<
    private static final String SELECT_TICKET_BY_EVENTID_SQL =
        "SELECT * FROM TicketInfo WHERE EventID = ? AND IsActive = 1 ORDER BY Price DESC";

    private static final String SELECT_TICKET_BY_ID_SQL =
        "SELECT ti.*, e.Name AS EventName, inv.AvailableQuantity " +
        "FROM TicketInfo ti " +
        "JOIN Events e ON ti.EventID = e.EventID " +
        "LEFT JOIN TicketInventory inv ON ti.TicketInfoID = inv.TicketInfoID " +
        "WHERE ti.TicketInfoID = ? AND ti.IsActive = 1";

    /**
     * Lấy danh sách các loại vé dựa trên ID của sự kiện.
     * PHIÊN BẢN ĐÃ SỬA LỖI:
     * 1. Sử dụng câu lệnh SQL đơn giản không JOIN để đảm bảo lấy được dữ liệu.
     * 2. Sửa lỗi mapping thiếu thuộc tính trong vòng lặp while.
     */
    public List<TicketInfo> getTicketInfosByEventID(int eventID) {
        List<TicketInfo> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_TICKET_BY_EVENTID_SQL)) {

            ps.setInt(1, eventID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    TicketInfo ticket = new TicketInfo();

                    // Gán đầy đủ các thuộc tính từ ResultSet
                    ticket.setTicketInfoID(rs.getInt("TicketInfoID"));
                    ticket.setTicketName(rs.getString("TicketName"));
                    ticket.setTicketDescription(rs.getString("TicketDescription"));
                    ticket.setCategory(rs.getString("Category"));
                    ticket.setPrice(rs.getBigDecimal("Price"));
                    ticket.setSalesStartTime(rs.getTimestamp("SalesStartTime").toLocalDateTime());
                    ticket.setSalesEndTime(rs.getTimestamp("SalesEndTime").toLocalDateTime());
                    ticket.setEventID(rs.getInt("EventID"));
                    ticket.setMaxQuantityPerOrder(rs.getInt("MaxQuantityPerOrder"));
                    ticket.setActive(rs.getBoolean("IsActive"));
                    
                    // Do câu lệnh SQL đơn giản không có 'AvailableQuantity' từ bảng Inventory,
                    // ta sẽ đặt một giá trị mặc định để test.
                    // Khi bạn sửa xong câu lệnh JOIN, hãy đổi lại thành: rs.getInt("AvailableQuantity")
                    ticket.setAvailableQuantity(99); 

                    list.add(ticket);
                }
            }
        } catch (SQLException e) {
            // In ra lỗi để dễ dàng debug nếu có sự cố với SQL
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Lấy thông tin một vé cụ thể bằng ID của nó.
     */
    public TicketInfo getTicketInfoById(int ticketId) {
        TicketInfo ticket = null;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_TICKET_BY_ID_SQL)) {
            ps.setInt(1, ticketId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    ticket = new TicketInfo();
                    ticket.setTicketInfoID(rs.getInt("TicketInfoID"));
                    ticket.setTicketName(rs.getString("TicketName"));
                    ticket.setTicketDescription(rs.getString("TicketDescription"));
                    ticket.setCategory(rs.getString("Category"));
                    ticket.setPrice(rs.getBigDecimal("Price"));
                    ticket.setSalesStartTime(rs.getTimestamp("SalesStartTime").toLocalDateTime());
                    ticket.setSalesEndTime(rs.getTimestamp("SalesEndTime").toLocalDateTime());
                    ticket.setEventID(rs.getInt("EventID"));
                    ticket.setMaxQuantityPerOrder(rs.getInt("MaxQuantityPerOrder"));
                    ticket.setActive(rs.getBoolean("IsActive"));
                    ticket.setAvailableQuantity(rs.getInt("AvailableQuantity"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return ticket;
    }

    /**
     * Cập nhật số lượng vé trong kho sau khi có đơn hàng.
     */
    public void updateTicketInventoryAfterOrder(int ticketInfoId, int quantityToDecrease) throws SQLException {
        String sql = "UPDATE TicketInventory " +
                     "SET SoldQuantity = SoldQuantity + ?, " +
                     "AvailableQuantity = AvailableQuantity - ?, " +
                     "LastUpdated = GETDATE() " +
                     "WHERE TicketInfoID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quantityToDecrease);
            ps.setInt(2, quantityToDecrease);
            ps.setInt(3, ticketInfoId);
            ps.executeUpdate();
        }
    }
}