package dao;

import context.DBConnection;
import models.OrderItem;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;
import models.Seat;

public class OrderItemDAO extends DBConnection {

    public void addOrderItem(OrderItem item, Connection conn) throws SQLException {
        // Cập nhật câu lệnh SQL để khớp với các trường trong model đã tối ưu
        String sql = "INSERT INTO dbo.OrderItems (OrderID, TicketInfoID, EventID, TicketID, UnitPrice, Quantity, TotalPrice, CreatedAt) VALUES (?, ?, ?, ?, ?, ?, ?, GETDATE())";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, item.getOrderId());
            ps.setInt(2, item.getTicketInfoId());
            ps.setInt(3, item.getEventId());

            if (item.getTicketId() != 0) {
                ps.setInt(4, item.getTicketId());
            } else {
                ps.setNull(4, Types.INTEGER);
            }

            // SỬA LỖI Ở ĐÂY: Dùng setBigDecimal thay vì setDouble
            ps.setBigDecimal(5, item.getUnitPrice());
            ps.setInt(6, item.getQuantity());
            ps.setBigDecimal(7, item.getTotalPrice());

            ps.executeUpdate();
        }
    }

    public List<OrderItem> getOrderItemsByOrderId(int orderId) {
        List<OrderItem> itemList = new ArrayList<>();

        String sql
                = "SELECT oi.*, t.TicketCode, ti.TicketTypeName, e.EventName, "
                + "s.SeatNumber, s.SeatRow, s.SeatSection "
                + "FROM OrderItems oi "
                + "JOIN Ticket t ON oi.TicketID = t.TicketID "
                + "JOIN TicketInfo ti ON oi.TicketInfoID = ti.TicketInfoID "
                + "JOIN Event e ON ti.EventID = e.EventID "
                + "LEFT JOIN Seat s ON t.SeatID = s.SeatID "
                + "WHERE oi.OrderID = ?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderItem item = new OrderItem();
                    item.setOrderId(rs.getInt("OrderID"));
                    item.setTicketInfoId(rs.getInt("TicketInfoID"));
                    item.setTicketId(rs.getInt("TicketID"));
                    item.setQuantity(rs.getInt("Quantity"));
                    item.setUnitPrice(rs.getBigDecimal("UnitPrice"));
                    item.setTotalPrice(rs.getBigDecimal("TotalPrice"));
                    item.setTicketTypeName(rs.getString("TicketTypeName"));
                    item.setEventId(rs.getInt("EventID")); 
                    item.setEventName(rs.getString("EventName"));

                    // Gán seat nếu có
                    // String seatNumber = rs.getString("SeatNumber");
                    // if (seatNumber != null) {
                    //     Seat seat = new Seat();
                    //     seat.setSeatNumber(seatNumber);
                    //     seat.setSeatRow(rs.getString("SeatRow"));
                    //     seat.setSeatSection(rs.getString("SeatSection"));
                    //     item.setSeat(seat);
                    // }

                    itemList.add(item);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return itemList;
    }

}
