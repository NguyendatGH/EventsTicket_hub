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
                item.setTotalPrice(item.getUnitPrice() * item.getQuantity());
                orderItemDAO.addOrderItem(item, conn); // Dùng chung connection cho transaction
            }

            conn.commit(); // Hoàn tất transaction thành công

        } catch (Exception e) {
            e.printStackTrace();
            if (conn != null) {
                try {
                    System.err.println("Transaction is being rolled back");
                    conn.rollback(); // QUAN TRỌNG: Rollback lại nếu có lỗi
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

    // Phương thức cập nhật trạng thái thanh toán
    public boolean updatePaymentStatus(int orderId, String paymentStatus) {
        String sql = "UPDATE dbo.Orders SET PaymentStatus = ?, UpdatedAt = GETDATE() WHERE OrderID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, paymentStatus);
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // PHƯƠNG THỨC CÒN THIẾU GÂY LỖI
    public List<Order> getOrdersByUserId(int userId) {
        List<Order> orderList = new ArrayList<>();
        // Câu SQL này cần được điều chỉnh cho phù hợp với cấu trúc bảng của bạn
        String sql = "SELECT * FROM dbo.Orders WHERE UserID = ? ORDER BY CreatedAt DESC"; 

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order order = new Order();
                    // Lấy thông tin từ ResultSet và set vào đối tượng Order
                    order.setOrderId(rs.getInt("OrderID"));
                    order.setOrderNumber(rs.getString("OrderNumber"));
                    order.setUserId(rs.getInt("UserID"));
                    order.setTotalAmount(rs.getBigDecimal("TotalAmount"));
                    order.setOrderStatus(rs.getString("OrderStatus"));
                    order.setPaymentStatus(rs.getString("PaymentStatus"));
                    order.setCreatedAt(rs.getTimestamp("CreatedAt"));
                    
                    // Lấy các chi tiết đơn hàng tương ứng
                    // (Bạn sẽ cần tạo phương thức này trong OrderItemDAO)
                    // OrderItemDAO itemDAO = new OrderItemDAO();
                    // order.setItems(itemDAO.getOrderItemsByOrderId(order.getOrderId()));

                    orderList.add(order);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return orderList;
    }
}