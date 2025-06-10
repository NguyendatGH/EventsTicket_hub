package Dao;

import context.DBConnection;
import models.Order;
import models.OrderItem;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

public class OrderDAO extends DBConnection {

    
    public int createOrder(Order order) {
        
        String insertOrderSQL = "INSERT INTO dbo.Orders (OrderNumber, UserID, TotalQuantity, SubtotalAmount, DiscountAmount, TotalAmount, PaymentStatus, OrderStatus, PaymentMethodID, ContactPhone, ContactEmail, Notes, CreatedAt, UpdatedAt) " +
                                "OUTPUT INSERTED.OrderID VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, GETDATE(), GETDATE())";
        
        int generatedOrderId = -1;

      
        try (Connection conn = getConnection()) {
            conn.setAutoCommit(false); 

            try (PreparedStatement psOrder = conn.prepareStatement(insertOrderSQL)) {
             
                psOrder.setString(1, order.getOrderNumber());
                psOrder.setInt(2, order.getUserId());
                psOrder.setInt(3, order.getTotalQuantity());
                psOrder.setBigDecimal(4, order.getSubtotalAmount());
                psOrder.setBigDecimal(5, order.getDiscountAmount());
                psOrder.setBigDecimal(6, order.getTotalAmount());
                psOrder.setString(7, order.getPaymentStatus()); 
                psOrder.setString(8, order.getOrderStatus());   
                psOrder.setInt(9, order.getPaymentMethodId());
                psOrder.setString(10, order.getContactPhone());
                psOrder.setString(11, order.getContactEmail());
                psOrder.setString(12, order.getNotes());
                
                ResultSet rs = psOrder.executeQuery();
                if (rs.next()) {
                    generatedOrderId = rs.getInt(1);
                } else {
                    throw new SQLException("Tạo đơn hàng thất bại, không có ID được trả về.");
                }
            }
            

            OrderItemDAO orderItemDAO = new OrderItemDAO();
            for (OrderItem item : order.getItems()) {
                item.setOrderId(generatedOrderId);
                
                double itemTotalPrice = item.getUnitPrice() * item.getQuantity();
                item.setTotalPrice(itemTotalPrice);
                
                orderItemDAO.addOrderItem(item, conn);
            }

            conn.commit(); 

        } catch (SQLException e) {
            e.printStackTrace();
            
            generatedOrderId = -1;
        }
        
        return generatedOrderId;
    }

    
 
    public boolean updatePaymentStatus(int orderId, String paymentStatus) {
        String sql = "UPDATE dbo.Orders SET PaymentStatus = ?, UpdatedAt = GETDATE() WHERE OrderID = ?";
        try (Connection conn = getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, paymentStatus);
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}