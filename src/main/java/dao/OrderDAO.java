package dao;

import context.DBConnection;
import java.math.BigDecimal;
import models.Order;
import models.OrderItem;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import models.Event;

public class OrderDAO {

    public int createOrder(Order order) throws SQLException {
        String insertOrderSQL = "INSERT INTO dbo.Orders (OrderNumber, UserID, TotalQuantity, SubtotalAmount, DiscountAmount, TotalAmount, PaymentStatus, OrderStatus, PaymentMethodID, DeliveryMethod, ContactPhone, ContactEmail, Notes, TransactionID) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        String insertTicketSQL = "INSERT INTO dbo.Ticket (TicketInfoID, TicketCode, Status) VALUES (?, ?, ?)";

        String insertOrderItemSQL = "INSERT INTO dbo.OrderItems (OrderID, TicketInfoID, EventID, TicketID, UnitPrice, Quantity, TotalPrice) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";

        Connection conn = null;
        int generatedOrderId = -1;

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            try (PreparedStatement psOrder = conn.prepareStatement(insertOrderSQL, Statement.RETURN_GENERATED_KEYS)) {
                psOrder.setString(1, order.getOrderNumber());
                psOrder.setInt(2, order.getUserId());
                psOrder.setInt(3, order.getTotalQuantity());
                psOrder.setBigDecimal(4, order.getSubtotalAmount());
                psOrder.setBigDecimal(5, order.getDiscountAmount());
                psOrder.setBigDecimal(6, order.getTotalAmount());
                psOrder.setString(7, order.getPaymentStatus());
                psOrder.setString(8, order.getOrderStatus());
                psOrder.setInt(9, order.getPaymentMethodId());
                psOrder.setString(10, order.getDeliveryMethod());
                psOrder.setString(11, order.getContactPhone());
                psOrder.setString(12, order.getContactEmail());
                psOrder.setString(13, order.getNotes());
                psOrder.setString(14, order.getTransactionId());
                psOrder.executeUpdate();

                try (ResultSet rs = psOrder.getGeneratedKeys()) {
                    if (rs.next()) {
                        generatedOrderId = rs.getInt(1);
                    } else {
                        throw new SQLException("Tạo đơn hàng thất bại, không lấy được OrderID.");
                    }
                }
            }

            try (PreparedStatement psTicket = conn.prepareStatement(insertTicketSQL, Statement.RETURN_GENERATED_KEYS); PreparedStatement psItem = conn.prepareStatement(insertOrderItemSQL)) {

                for (OrderItem item : order.getItems()) {
                    for (int i = 0; i < item.getQuantity(); i++) {
                        psTicket.setInt(1, item.getTicketInfoId());
                        String uniqueTicketCode = java.util.UUID.randomUUID().toString().substring(0, 8).toUpperCase();
                        psTicket.setString(2, uniqueTicketCode);
                        psTicket.setString(3, "Available");
                        psTicket.executeUpdate();

                        int generatedTicketId = -1;
                        try (ResultSet rsTicket = psTicket.getGeneratedKeys()) {
                            if (rsTicket.next()) {
                                generatedTicketId = rsTicket.getInt(1);
                            } else {
                                throw new SQLException("Tạo vé thất bại, không lấy được TicketID.");
                            }
                        }

                        psItem.setInt(1, generatedOrderId);
                        psItem.setInt(2, item.getTicketInfoId());
                        psItem.setInt(3, item.getEventId());
                        psItem.setInt(4, generatedTicketId);
                        psItem.setBigDecimal(5, item.getUnitPrice());
                        psItem.setInt(6, 1);
                        psItem.setBigDecimal(7, item.getUnitPrice());
                        psItem.addBatch();
                    }
                }
                psItem.executeBatch();
            }

            TicketInventoryDAO ticketInventoryDAO = new TicketInventoryDAO();
            for (OrderItem item : order.getItems()) {
                boolean updateSuccess = ticketInventoryDAO.updateInventoryAfterSale(item.getTicketInfoId(), item.getQuantity(), conn);
                if (!updateSuccess) {
                    throw new SQLException("Không đủ vé trong kho cho TicketInfoID: " + item.getTicketInfoId());
                }
            }

            conn.commit();

        } catch (Exception e) {
            if (conn != null) {
                System.err.println("Transaction đang được rollback do có lỗi: " + e.getMessage());
                conn.rollback();
            }
            throw new SQLException("Lỗi khi tạo đơn hàng.", e);
        } finally {
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        }
        return generatedOrderId;
    }

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

    public List<Order> getOrdersByUserId(int userId) {
        List<Order> orderList = new ArrayList<>();
        String sql = "SELECT o.OrderID, o.OrderNumber, o.TotalAmount, o.OrderStatus, o.CreatedAt "
                + "FROM Orders o WHERE o.UserID = ? ORDER BY o.CreatedAt DESC";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order order = new Order();
                    order.setOrderId(rs.getInt("OrderID"));
                    order.setOrderNumber(rs.getString("OrderNumber"));
                    order.setTotalAmount(rs.getBigDecimal("TotalAmount"));
                    order.setOrderStatus(rs.getString("OrderStatus"));
                    order.setCreatedAt(rs.getTimestamp("CreatedAt").toLocalDateTime());

                    OrderItemDAO itemDAO = new OrderItemDAO();
                    List<OrderItem> items = itemDAO.getOrderItemsByOrderId(order.getOrderId());
                    order.setItems(items);

               
                    if (!items.isEmpty()) {
                        int eventId = items.get(0).getEventId();
                        EventDAO eventDAO = new EventDAO();
                        Event event = eventDAO.getEventById(eventId);
                        order.setEvent(event);
                    }

                    orderList.add(order);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return orderList;
    }

    public List<Map<String, Object>> getSimpleOrdersByUserId(int userId) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT o.OrderID, SUM(oi.Quantity) AS TotalQuantity, o.TotalAmount, o.CreatedAt, "
                + "MIN(e.EventID) AS EventID, MIN(e.Name) AS EventName, "
                + "MIN(e.StartTime) AS StartTime, MIN(e.PhysicalLocation) AS PhysicalLocation "
                + "FROM Orders o "
                + "JOIN OrderItems oi ON o.OrderID = oi.OrderID "
                + "JOIN Events e ON oi.EventID = e.EventID "
                + "WHERE o.UserID = ? "
                + "GROUP BY o.OrderID, o.TotalAmount, o.CreatedAt "
                + "ORDER BY o.CreatedAt DESC";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            java.time.format.DateTimeFormatter dateTimeFormatter = java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
            java.time.format.DateTimeFormatter dateOnlyFormatter = java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy");

            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("orderId", rs.getInt("OrderID"));
                map.put("totalQuantity", rs.getInt("TotalQuantity"));
                map.put("totalAmount", rs.getBigDecimal("TotalAmount"));

                java.time.LocalDateTime createdAt = rs.getTimestamp("CreatedAt").toLocalDateTime();
                java.time.LocalDateTime startTime = rs.getTimestamp("StartTime").toLocalDateTime();
                LocalDateTime now = LocalDateTime.now();
                LocalDateTime refundDeadline = startTime.minusDays(1).withHour(23).withMinute(59).withSecond(59);
                map.put("canRefund", now.isBefore(refundDeadline));

                map.put("createdAt", createdAt.format(dateTimeFormatter));
                map.put("createdAtShort", createdAt.format(dateOnlyFormatter));
                map.put("startTime", startTime.format(dateTimeFormatter));

                map.put("eventId", rs.getInt("EventID"));
                map.put("eventName", rs.getString("EventName"));
                map.put("physicalLocation", rs.getString("PhysicalLocation"));
                map.put("canRefund", now.isBefore(startTime.minusDays(1).withHour(23).withMinute(59).withSecond(59)));

                list.add(map);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public BigDecimal getOrderTotalAmount(int orderId) {
        String sql = "SELECT TotalAmount FROM Orders WHERE OrderID = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getBigDecimal("TotalAmount");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return BigDecimal.ZERO;
    }

}
