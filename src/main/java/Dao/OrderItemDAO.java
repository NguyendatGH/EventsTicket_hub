package Dao;

import context.DBConnection;
import models.OrderItem;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Types;

public class OrderItemDAO extends DBConnection {

   
    public void addOrderItem(OrderItem item, Connection conn) throws SQLException {
        String sql = "INSERT INTO dbo.OrderItems (OrderID, TicketInfoID, EventID, TicketID, UnitPrice, Quantity, TotalPrice, CreatedAt) VALUES (?, ?, ?, ?, ?, ?, ?, GETDATE())";
        
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, item.getOrderId());
            ps.setInt(2, item.getTicketInfoId());
            ps.setInt(3, item.getEventId());
            
            if (item.getTicketId() != 0) {
                ps.setInt(4, item.getTicketId());
            } else {
                ps.setNull(4, Types.INTEGER); // Cho phép ticketId là null
            }
            
            ps.setDouble(5, item.getUnitPrice());
            ps.setInt(6, item.getQuantity());
            ps.setDouble(7, item.getTotalPrice());
            
            ps.executeUpdate();
        }
    }
    
}