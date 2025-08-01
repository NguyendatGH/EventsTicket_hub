package dao;

import context.DBConnection;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import models.Refund;

public class RefundDAO {

    public boolean insertRefund(Refund refund) {
        String sql = "INSERT INTO Refunds (OrderID, OrderItemID, UserID, RefundAmount, RefundReason, RefundStatus, PaymentMethodID, RefundRequestDate, CreatedAt, UpdatedAt) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
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
            
            int affectedRows = ps.executeUpdate();
            
            if (affectedRows > 0) {
                // Lấy refundId được tạo
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        refund.setRefundId(rs.getInt(1));
                        System.out.println("Refund created successfully with ID: " + refund.getRefundId());
                    }
                }
                return true;
            } else {
                System.out.println("Failed to create refund");
                return false;
            }
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

    // Thêm các phương thức mới cho admin
    public List<Refund> getAllRefunds() {
        List<Refund> refunds = new ArrayList<>();
        String sql = "SELECT r.*, u.Username as UserName, o.OrderNumber " +
                    "FROM Refunds r " +
                    "LEFT JOIN Users u ON r.UserID = u.Id " +
                    "LEFT JOIN Orders o ON r.OrderID = o.OrderID " +
                    "WHERE r.IsDeleted = 0 " +
                    "ORDER BY r.RefundRequestDate DESC";

        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Refund refund = new Refund();
                refund.setRefundId(rs.getInt("RefundID"));
                refund.setOrderId(rs.getInt("OrderID"));
                refund.setOrderItemId(rs.getObject("OrderItemID", Integer.class));
                refund.setUserId(rs.getInt("UserID"));
                refund.setAdminId(rs.getObject("AdminID", Integer.class));
                refund.setRefundAmount(rs.getBigDecimal("RefundAmount"));
                refund.setRefundReason(rs.getString("RefundReason"));
                refund.setRefundStatus(rs.getString("RefundStatus"));
                refund.setPaymentMethodId(rs.getObject("PaymentMethodID", Integer.class));
                refund.setRefundRequestDate(rs.getObject("RefundRequestDate", Timestamp.class) != null ? 
                    rs.getTimestamp("RefundRequestDate").toLocalDateTime() : null);
                refund.setRefundProcessedDate(rs.getObject("RefundProcessedDate", Timestamp.class) != null ? 
                    rs.getTimestamp("RefundProcessedDate").toLocalDateTime() : null);
                refund.setCreatedAt(rs.getObject("CreatedAt", Timestamp.class) != null ? 
                    rs.getTimestamp("CreatedAt").toLocalDateTime() : null);
                refund.setUpdatedAt(rs.getObject("UpdatedAt", Timestamp.class) != null ? 
                    rs.getTimestamp("UpdatedAt").toLocalDateTime() : null);
                refund.setIsDeleted(rs.getBoolean("IsDeleted"));
                refund.setUserName(rs.getString("UserName"));
                refund.setOrderNumber(rs.getString("OrderNumber"));
                refunds.add(refund);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return refunds;
    }

    public Refund getRefundById(int refundId) {
        String sql = "SELECT r.*, u.Username as UserName, o.OrderNumber " +
                    "FROM Refunds r " +
                    "LEFT JOIN Users u ON r.UserID = u.Id " +
                    "LEFT JOIN Orders o ON r.OrderID = o.OrderID " +
                    "WHERE r.RefundID = ? AND r.IsDeleted = 0";

        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, refundId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                Refund refund = new Refund();
                refund.setRefundId(rs.getInt("RefundID"));
                refund.setOrderId(rs.getInt("OrderID"));
                refund.setOrderItemId(rs.getObject("OrderItemID", Integer.class));
                refund.setUserId(rs.getInt("UserID"));
                refund.setAdminId(rs.getObject("AdminID", Integer.class));
                refund.setRefundAmount(rs.getBigDecimal("RefundAmount"));
                refund.setRefundReason(rs.getString("RefundReason"));
                refund.setRefundStatus(rs.getString("RefundStatus"));
                refund.setPaymentMethodId(rs.getObject("PaymentMethodID", Integer.class));
                refund.setRefundRequestDate(rs.getObject("RefundRequestDate", Timestamp.class) != null ? 
                    rs.getTimestamp("RefundRequestDate").toLocalDateTime() : null);
                refund.setRefundProcessedDate(rs.getObject("RefundProcessedDate", Timestamp.class) != null ? 
                    rs.getTimestamp("RefundProcessedDate").toLocalDateTime() : null);
                refund.setCreatedAt(rs.getObject("CreatedAt", Timestamp.class) != null ? 
                    rs.getTimestamp("CreatedAt").toLocalDateTime() : null);
                refund.setUpdatedAt(rs.getObject("UpdatedAt", Timestamp.class) != null ? 
                    rs.getTimestamp("UpdatedAt").toLocalDateTime() : null);
                refund.setIsDeleted(rs.getBoolean("IsDeleted"));
                refund.setUserName(rs.getString("UserName"));
                refund.setOrderNumber(rs.getString("OrderNumber"));
                return refund;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateRefundStatus(int refundId, String status, int adminId) {
        String sql = "UPDATE Refunds SET RefundStatus = ?, AdminID = ?, RefundProcessedDate = ?, UpdatedAt = ? WHERE RefundID = ?";
        
        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status);
            ps.setInt(2, adminId);
            ps.setTimestamp(3, Timestamp.valueOf(LocalDateTime.now()));
            ps.setTimestamp(4, Timestamp.valueOf(LocalDateTime.now()));
            ps.setInt(5, refundId);
            
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Refund> getRefundsByStatus(String status) {
        List<Refund> refunds = new ArrayList<>();
        String sql = "SELECT r.*, u.Username as UserName, o.OrderNumber " +
                    "FROM Refunds r " +
                    "LEFT JOIN Users u ON r.UserID = u.Id " +
                    "LEFT JOIN Orders o ON r.OrderID = o.OrderID " +
                    "WHERE r.RefundStatus = ? AND r.IsDeleted = 0 " +
                    "ORDER BY r.RefundRequestDate DESC";

        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Refund refund = new Refund();
                refund.setRefundId(rs.getInt("RefundID"));
                refund.setOrderId(rs.getInt("OrderID"));
                refund.setOrderItemId(rs.getObject("OrderItemID", Integer.class));
                refund.setUserId(rs.getInt("UserID"));
                refund.setAdminId(rs.getObject("AdminID", Integer.class));
                refund.setRefundAmount(rs.getBigDecimal("RefundAmount"));
                refund.setRefundReason(rs.getString("RefundReason"));
                refund.setRefundStatus(rs.getString("RefundStatus"));
                refund.setPaymentMethodId(rs.getObject("PaymentMethodID", Integer.class));
                refund.setRefundRequestDate(rs.getObject("RefundRequestDate", Timestamp.class) != null ? 
                    rs.getTimestamp("RefundRequestDate").toLocalDateTime() : null);
                refund.setRefundProcessedDate(rs.getObject("RefundProcessedDate", Timestamp.class) != null ? 
                    rs.getTimestamp("RefundProcessedDate").toLocalDateTime() : null);
                refund.setCreatedAt(rs.getObject("CreatedAt", Timestamp.class) != null ? 
                    rs.getTimestamp("CreatedAt").toLocalDateTime() : null);
                refund.setUpdatedAt(rs.getObject("UpdatedAt", Timestamp.class) != null ? 
                    rs.getTimestamp("UpdatedAt").toLocalDateTime() : null);
                refund.setIsDeleted(rs.getBoolean("IsDeleted"));
                refund.setUserName(rs.getString("UserName"));
                refund.setOrderNumber(rs.getString("OrderNumber"));
                refunds.add(refund);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return refunds;
    }

    public List<Refund> getRefundsByUserId(int userId) {
        List<Refund> refunds = new ArrayList<>();
        String sql = "SELECT r.*, u.Username as UserName, o.OrderNumber " +
                    "FROM Refunds r " +
                    "LEFT JOIN Users u ON r.UserID = u.Id " +
                    "LEFT JOIN Orders o ON r.OrderID = o.OrderID " +
                    "WHERE r.IsDeleted = 0 AND r.UserID = ? " +
                    "ORDER BY r.RefundRequestDate DESC";

        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Refund refund = new Refund();
                refund.setRefundId(rs.getInt("RefundID"));
                refund.setOrderId(rs.getInt("OrderID"));
                refund.setOrderItemId(rs.getObject("OrderItemID", Integer.class));
                refund.setUserId(rs.getInt("UserID"));
                refund.setAdminId(rs.getObject("AdminID", Integer.class));
                refund.setRefundAmount(rs.getBigDecimal("RefundAmount"));
                refund.setRefundReason(rs.getString("RefundReason"));
                refund.setRefundStatus(rs.getString("RefundStatus"));
                refund.setPaymentMethodId(rs.getObject("PaymentMethodID", Integer.class));
                refund.setRefundRequestDate(rs.getObject("RefundRequestDate", Timestamp.class) != null ? 
                    rs.getTimestamp("RefundRequestDate").toLocalDateTime() : null);
                refund.setRefundProcessedDate(rs.getObject("RefundProcessedDate", Timestamp.class) != null ? 
                    rs.getTimestamp("RefundProcessedDate").toLocalDateTime() : null);
                refund.setCreatedAt(rs.getObject("CreatedAt", Timestamp.class) != null ? 
                    rs.getTimestamp("CreatedAt").toLocalDateTime() : null);
                refund.setUpdatedAt(rs.getObject("UpdatedAt", Timestamp.class) != null ? 
                    rs.getTimestamp("UpdatedAt").toLocalDateTime() : null);
                refund.setIsDeleted(rs.getBoolean("IsDeleted"));
                refund.setUserName(rs.getString("UserName"));
                refund.setOrderNumber(rs.getString("OrderNumber"));
                refunds.add(refund);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return refunds;
    }

    // Thêm phương thức tìm kiếm và filter với phân trang
    public List<Refund> searchRefunds(String searchTerm, String statusFilter, String amountFilter, 
                                     String reasonFilter, int page, int pageSize) {
        List<Refund> refunds = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT r.*, u.Username as UserName, o.OrderNumber ");
        sql.append("FROM Refunds r ");
        sql.append("LEFT JOIN Users u ON r.UserID = u.Id ");
        sql.append("LEFT JOIN Orders o ON r.OrderID = o.OrderID ");
        sql.append("WHERE r.IsDeleted = 0 ");
        
        List<Object> params = new ArrayList<>();
        int paramIndex = 1;
        
        // Tìm kiếm theo tên khách hàng hoặc mã đơn hàng
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            sql.append("AND (u.Username LIKE ? OR o.OrderNumber LIKE ?) ");
            params.add("%" + searchTerm.trim() + "%");
            params.add("%" + searchTerm.trim() + "%");
            paramIndex += 2;
        }
        
        // Filter theo trạng thái
        if (statusFilter != null && !statusFilter.trim().isEmpty() && !"all".equals(statusFilter)) {
            sql.append("AND r.RefundStatus = ? ");
            params.add(statusFilter.trim());
            paramIndex++;
        }
        
        // Filter theo số tiền
        if (amountFilter != null && !amountFilter.trim().isEmpty()) {
            switch (amountFilter) {
                case "0-100000":
                    sql.append("AND r.RefundAmount BETWEEN 0 AND 100000 ");
                    break;
                case "100000-500000":
                    sql.append("AND r.RefundAmount BETWEEN 100000 AND 500000 ");
                    break;
                case "500000-1000000":
                    sql.append("AND r.RefundAmount BETWEEN 500000 AND 1000000 ");
                    break;
                case "1000000+":
                    sql.append("AND r.RefundAmount >= 1000000 ");
                    break;
            }
        }
        
        // Filter theo lý do
        if (reasonFilter != null && !reasonFilter.trim().isEmpty() && !"all".equals(reasonFilter)) {
            sql.append("AND r.RefundReason LIKE ? ");
            params.add("%" + reasonFilter.trim() + "%");
            paramIndex++;
        }
        
        sql.append("ORDER BY r.RefundRequestDate DESC ");
        sql.append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add((page - 1) * pageSize);
        params.add(pageSize);

        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Refund refund = new Refund();
                refund.setRefundId(rs.getInt("RefundID"));
                refund.setOrderId(rs.getInt("OrderID"));
                refund.setOrderItemId(rs.getObject("OrderItemID", Integer.class));
                refund.setUserId(rs.getInt("UserID"));
                refund.setAdminId(rs.getObject("AdminID", Integer.class));
                refund.setRefundAmount(rs.getBigDecimal("RefundAmount"));
                refund.setRefundReason(rs.getString("RefundReason"));
                refund.setRefundStatus(rs.getString("RefundStatus"));
                refund.setPaymentMethodId(rs.getObject("PaymentMethodID", Integer.class));
                refund.setRefundRequestDate(rs.getObject("RefundRequestDate", Timestamp.class) != null ? 
                    rs.getTimestamp("RefundRequestDate").toLocalDateTime() : null);
                refund.setRefundProcessedDate(rs.getObject("RefundProcessedDate", Timestamp.class) != null ? 
                    rs.getTimestamp("RefundProcessedDate").toLocalDateTime() : null);
                refund.setCreatedAt(rs.getObject("CreatedAt", Timestamp.class) != null ? 
                    rs.getTimestamp("CreatedAt").toLocalDateTime() : null);
                refund.setUpdatedAt(rs.getObject("UpdatedAt", Timestamp.class) != null ? 
                    rs.getTimestamp("UpdatedAt").toLocalDateTime() : null);
                refund.setIsDeleted(rs.getBoolean("IsDeleted"));
                refund.setUserName(rs.getString("UserName"));
                refund.setOrderNumber(rs.getString("OrderNumber"));
                refunds.add(refund);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return refunds;
    }

    // Đếm tổng số refund theo điều kiện tìm kiếm
    public int countRefunds(String searchTerm, String statusFilter, String amountFilter, String reasonFilter) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(*) FROM Refunds r ");
        sql.append("LEFT JOIN Users u ON r.UserID = u.Id ");
        sql.append("LEFT JOIN Orders o ON r.OrderID = o.OrderID ");
        sql.append("WHERE r.IsDeleted = 0 ");
        
        List<Object> params = new ArrayList<>();
        int paramIndex = 1;
        
        // Tìm kiếm theo tên khách hàng hoặc mã đơn hàng
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            sql.append("AND (u.Username LIKE ? OR o.OrderNumber LIKE ?) ");
            params.add("%" + searchTerm.trim() + "%");
            params.add("%" + searchTerm.trim() + "%");
            paramIndex += 2;
        }
        
        // Filter theo trạng thái
        if (statusFilter != null && !statusFilter.trim().isEmpty() && !"all".equals(statusFilter)) {
            sql.append("AND r.RefundStatus = ? ");
            params.add(statusFilter.trim());
            paramIndex++;
        }
        
        // Filter theo số tiền
        if (amountFilter != null && !amountFilter.trim().isEmpty()) {
            switch (amountFilter) {
                case "0-100000":
                    sql.append("AND r.RefundAmount BETWEEN 0 AND 100000 ");
                    break;
                case "100000-500000":
                    sql.append("AND r.RefundAmount BETWEEN 100000 AND 500000 ");
                    break;
                case "500000-1000000":
                    sql.append("AND r.RefundAmount BETWEEN 500000 AND 1000000 ");
                    break;
                case "1000000+":
                    sql.append("AND r.RefundAmount >= 1000000 ");
                    break;
            }
        }
        
        // Filter theo lý do
        if (reasonFilter != null && !reasonFilter.trim().isEmpty() && !"all".equals(reasonFilter)) {
            sql.append("AND r.RefundReason LIKE ? ");
            params.add("%" + reasonFilter.trim() + "%");
            paramIndex++;
        }

        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }


}
