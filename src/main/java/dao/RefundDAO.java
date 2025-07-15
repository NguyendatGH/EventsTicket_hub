package dao;

import context.DBConnection;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.Optional;
import models.Refund;

public class RefundDAO {

    public boolean insertRefund(Refund refund) {
        String sql = "INSERT INTO Refunds (OrderID, OrderItemID, UserID, RefundAmount, RefundReason, RefundStatus, PaymentMethodID, RefundRequestDate, CreatedAt, UpdatedAt) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, refund.getOrderId());
            if (refund.getOrderItemId() != null) {
                ps.setInt(2, refund.getOrderItemId());
            } else {
                ps.setNull(2, Types.INTEGER);
            }
            ps.setInt(3, refund.getUserId());
            ps.setBigDecimal(4, refund.getRefundAmount());
            ps.setString(5, refund.getRefundReason());
            ps.setString(6, refund.getRefundStatus());
            ps.setObject(7, Optional.ofNullable(refund.getPaymentMethodId()).orElse(null), Types.INTEGER);
            ps.setTimestamp(8, Timestamp.valueOf(refund.getRefundRequestDate()));
            ps.setTimestamp(9, Timestamp.valueOf(refund.getCreatedAt()));
            ps.setTimestamp(10, Timestamp.valueOf(refund.getUpdatedAt()));
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean refundOrder(int orderId, int userId) {
        String sql = "UPDATE Orders SET OrderStatus = 'refunded', PaymentStatus = 'refunded' WHERE OrderID = ? AND UserID = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean checkCanRefund(int orderId, int userId) {
        String sql = "SELECT MIN(e.StartTime) AS StartTime "
                   + "FROM Orders o "
                   + "JOIN OrderItems oi ON o.OrderID = oi.OrderID "
                   + "JOIN Events e ON oi.EventID = e.EventID "
                   + "WHERE o.OrderID = ? AND o.UserID = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ps.setInt(2, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                LocalDateTime startTime = rs.getTimestamp("StartTime").toLocalDateTime();
                LocalDateTime deadline = startTime.minusDays(1).withHour(23).withMinute(59).withSecond(59);
                return LocalDateTime.now().isBefore(deadline);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
