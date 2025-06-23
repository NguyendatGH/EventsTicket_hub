package dao;

import context.DBConnection;
import models.OrderItem;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Types;

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
}