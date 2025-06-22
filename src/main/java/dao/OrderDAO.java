package dao;

import context.DBConnection;
import models.Order;
import models.OrderItem;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {

 
    public int createOrder(Order order) {
        // Câu lệnh INSERT này dành cho SQL Server. Điều chỉnh nếu bạn dùng CSDL khác.
        String insertOrderSQL = "INSERT INTO dbo.Orders (OrderNumber, UserID, TotalQuantity, SubtotalAmount, DiscountAmount, TotalAmount, PaymentStatus, OrderStatus, PaymentMethodID, ContactPhone, ContactEmail, Notes, CreatedAt, UpdatedAt) "
                + "OUTPUT INSERTED.OrderID VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, GETDATE(), GETDATE())";
        
        int generatedOrderId = -1;
        Connection conn = null;

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Bắt đầu transaction

            // 1. Thêm vào bảng Orders
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

                try (ResultSet rs = psOrder.executeQuery()) {
                    if (rs.next()) {
                        generatedOrderId = rs.getInt(1);
                    } else {
                        throw new SQLException("Tạo đơn hàng thất bại, không có ID được trả về.");
                    }
                }
            }

            // 2. Thêm vào bảng OrderItems
            OrderItemDAO orderItemDAO = new OrderItemDAO();
            for (OrderItem item : order.getItems()) {
                item.setOrderId(generatedOrderId);
                
                // SỬA LỖI: Dùng phương thức multiply() của BigDecimal để tính toán
                BigDecimal itemTotalPrice = item.getUnitPrice().multiply(new BigDecimal(item.getQuantity()));
                item.setTotalPrice(itemTotalPrice);
                
                // Gọi DAO của OrderItem, truyền vào connection để đảm bảo transaction
                orderItemDAO.addOrderItem(item, conn);
            }

            conn.commit(); // Hoàn tất transaction thành công

        } catch (Exception e) {
            e.printStackTrace();
            if (conn != null) {
                try {
                    System.err.println("Transaction is being rolled back");
                    conn.rollback();
                } catch (SQLException excep) {
                    excep.printStackTrace();
                }
            }
            generatedOrderId = -1;
        } finally {
            try {
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return generatedOrderId;
    }

    /**
     * Cập nhật trạng thái thanh toán của đơn hàng.
     */
    public boolean updatePaymentStatus(int orderId, String paymentStatus) {
        String sql = "UPDATE dbo.Orders SET PaymentStatus = ?, UpdatedAt = GETDATE() WHERE OrderID = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, paymentStatus);
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Lấy danh sách đơn hàng của một người dùng (cần hoàn thiện logic JOIN)
     */
    public List<Order> getOrdersByUserId(int userId) {
        List<Order> orderList = new ArrayList<>();
        // TODO: Hoàn thiện câu SQL để JOIN với bảng Event và lấy các thông tin cần thiết
        String sql = "SELECT * FROM dbo.Orders WHERE UserID = ? ORDER BY CreatedAt DESC";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order order = new Order();
                    // ... Lấy dữ liệu từ ResultSet và set vào đối tượng Order ...
                    order.setOrderId(rs.getInt("OrderID"));
                    // ... các trường khác ...
                    orderList.add(order);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return orderList;
    }
}