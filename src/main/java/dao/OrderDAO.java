package dao;

import context.DBConnection;
import java.math.BigDecimal;
import models.Order;
import models.OrderItem;
import models.Seat;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import models.Event;
import java.sql.Timestamp;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

public class OrderDAO {

    private static final Logger LOGGER = Logger.getLogger(OrderDAO.class.getName());
    private final SeatDAO seatDAO = new SeatDAO();
    private final TicketInventoryDAO ticketInventoryDAO = new TicketInventoryDAO();
    private final OrderItemDAO orderItemDAO = new OrderItemDAO();

    /**
     * Creates Ticket records, reserves seats, and updates ticket inventory in a
     * single transaction.
     *
     * @param ticketInfoId The ID of the TicketInfo for the tickets
     * @param seats The list of seats to reserve
     * @param conn The database connection (must be in a transaction)
     * @return List of generated TicketIDs
     * @throws SQLException If any database operation fails
     */
    public List<Integer> createTicketsAndReserveSeats(int ticketInfoId, List<Seat> seats, Connection conn) throws SQLException {
        List<Integer> ticketIds = new ArrayList<>();
        try {
            String ticketSql = "INSERT INTO Ticket (TicketInfoID, TicketCode, Status, SeatID, CreatedAt, UpdatedAt) "
                    + "VALUES (?, ?, 'reserved', ?, GETDATE(), GETDATE())";
            for (Seat seat : seats) {
                String ticketCode = generateUniqueTicketCode();
                try ( PreparedStatement ps = conn.prepareStatement(ticketSql, Statement.RETURN_GENERATED_KEYS)) {
                    ps.setInt(1, ticketInfoId);
                    ps.setString(2, ticketCode);
                    ps.setInt(3, seat.getSeatId());
                    ps.executeUpdate();

                    try ( ResultSet rs = ps.getGeneratedKeys()) {
                        if (rs.next()) {
                            ticketIds.add(rs.getInt(1));
                        }
                    }
                }

                if (!seatDAO.reserveSeat(seat.getSeatId(), conn)) {
                    throw new SQLException("Không thể đặt trước ghế SeatID: " + seat.getSeatId());
                }
            }

            if (!ticketInventoryDAO.updateInventoryAfterSale(ticketInfoId, seats.size(), conn)) {
                throw new SQLException("Không đủ vé trong kho cho TicketInfoID: " + ticketInfoId);
            }

            return ticketIds;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi tạo vé và đặt trước ghế cho TicketInfoID: " + ticketInfoId, e);
            throw e;
        }
    }

    /**
     * Generates a unique ticket code.
     *
     * @return A unique ticket code
     */
    private String generateUniqueTicketCode() {
        return "TICKET-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
    }

    /**
     * Creates an Order and OrderItems, linking each OrderItem to a TicketID.
     *
     * @param order The Order object to create
     * @param ticketIdsByOrderItem List of TicketIDs for each OrderItem
     * @param conn The database connection (must be in a transaction)
     * @return The generated OrderID
     * @throws SQLException If any database operation fails
     */
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

            try ( PreparedStatement psOrder = conn.prepareStatement(insertOrderSQL, Statement.RETURN_GENERATED_KEYS)) {
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

                try ( ResultSet rs = psOrder.getGeneratedKeys()) {
                    if (rs.next()) {
                        generatedOrderId = rs.getInt(1);
                    } else {
                        throw new SQLException("Tạo đơn hàng thất bại, không lấy được OrderID.");
                    }
                }
            }

            try ( PreparedStatement psTicket = conn.prepareStatement(insertTicketSQL, Statement.RETURN_GENERATED_KEYS);  PreparedStatement psItem = conn.prepareStatement(insertOrderItemSQL)) {

                for (OrderItem item : order.getItems()) {
                    for (int i = 0; i < item.getQuantity(); i++) {
                        psTicket.setInt(1, item.getTicketInfoId());
                        String uniqueTicketCode = java.util.UUID.randomUUID().toString().substring(0, 8).toUpperCase();
                        psTicket.setString(2, uniqueTicketCode);
                        psTicket.setString(3, "Available");
                        psTicket.executeUpdate();

                        int generatedTicketId = -1;
                        try ( ResultSet rsTicket = psTicket.getGeneratedKeys()) {
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

    public int createOrder(Order order, List<List<Integer>> ticketIdsByOrderItem, Connection conn) throws SQLException {
        String insertOrderSQL = "INSERT INTO Orders (OrderNumber, UserID, TotalQuantity, SubtotalAmount, DiscountAmount, TotalAmount, PaymentStatus, OrderStatus, DeliveryMethod, ContactPhone, ContactEmail, Notes, CreatedAt, UpdatedAt) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, GETDATE(), GETDATE())";

        int generatedOrderId = -1;

        try {
            // Insert Order
            try ( PreparedStatement psOrder = conn.prepareStatement(insertOrderSQL, Statement.RETURN_GENERATED_KEYS)) {
                psOrder.setString(1, order.getOrderNumber());
                psOrder.setInt(2, order.getUserId());
                psOrder.setInt(3, order.getTotalQuantity());
                psOrder.setBigDecimal(4, order.getSubtotalAmount());
                psOrder.setBigDecimal(5, order.getDiscountAmount());
                psOrder.setBigDecimal(6, order.getTotalAmount());
                psOrder.setString(7, order.getPaymentStatus());
                psOrder.setString(8, order.getOrderStatus());
                psOrder.setString(9, order.getDeliveryMethod());
                psOrder.setString(10, order.getContactPhone());
                psOrder.setString(11, order.getContactEmail());
                psOrder.setString(12, order.getNotes());
                psOrder.executeUpdate();

                try ( ResultSet rs = psOrder.getGeneratedKeys()) {
                    if (rs.next()) {
                        generatedOrderId = rs.getInt(1);
                    } else {
                        throw new SQLException("Tạo đơn hàng thất bại, không lấy được OrderID.");
                    }
                }
            }

            // Insert OrderItems
            for (int i = 0; i < order.getItems().size(); i++) {
                OrderItem item = order.getItems().get(i);
                item.setOrderId(generatedOrderId);
                List<Integer> ticketIds = ticketIdsByOrderItem.get(i);
                if (ticketIds.size() != item.getQuantity()) {
                    throw new SQLException("Số lượng TicketID không khớp với quantity của OrderItem: " + item.getTicketInfoId());
                }
                for (Integer ticketId : ticketIds) {
                    item.setTicketId(ticketId);
                    item.setQuantity(1); // Each OrderItem corresponds to one Ticket
                    item.setTotalPrice(item.getUnitPrice()); // TotalPrice for one ticket
                    orderItemDAO.addOrderItem(item, conn);
                }
            }

            return generatedOrderId;

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi tạo đơn hàng.", e);
            throw e;
        }
    }

    /**
     * Creates tickets, reserves seats, updates inventory, and creates order in
     * a single transaction.
     *
     * @param order The Order object to create
     * @param seatsByTicketInfo Map of TicketInfoID to list of seats
     * @return The generated OrderID
     * @throws SQLException If any database operation fails
     */
    public int createOrderWithSeats(Order order, Map<Integer, List<Seat>> seatsByTicketInfo) throws SQLException {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Start transaction

            List<List<Integer>> ticketIdsByOrderItem = new ArrayList<>();
            for (Map.Entry<Integer, List<Seat>> entry : seatsByTicketInfo.entrySet()) {
                int ticketInfoId = entry.getKey();
                List<Seat> seats = entry.getValue();
                List<Integer> ticketIds = createTicketsAndReserveSeats(ticketInfoId, seats, conn);
                ticketIdsByOrderItem.add(ticketIds);
            }

            int orderId = createOrder(order, ticketIdsByOrderItem, conn);

            conn.commit();
            return orderId;

        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    LOGGER.log(Level.SEVERE, "Lỗi khi rollback transaction", ex);
                }
            }
            throw e;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException ex) {
                    LOGGER.log(Level.SEVERE, "Lỗi khi đóng connection", ex);
                }
            }
        }
    }

    public boolean updatePaymentStatus(int orderId, String paymentStatus) {
        String sql = "UPDATE Orders SET PaymentStatus = ?, UpdatedAt = GETDATE() WHERE OrderID = ?";
        try ( Connection conn = DBConnection.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
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
                + "FROM Orders o WHERE o.UserID = ? AND o.PaymentStatus = 'paid' ORDER BY o.CreatedAt DESC";

        try ( Connection conn = DBConnection.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order order = new Order();
                    order.setOrderId(rs.getInt("OrderID"));
                    order.setOrderNumber(rs.getString("OrderNumber"));
                    order.setTotalAmount(rs.getBigDecimal("TotalAmount"));
                    order.setOrderStatus(rs.getString("OrderStatus"));
                    order.setCreatedAt(rs.getTimestamp("CreatedAt").toLocalDateTime());

                    List<OrderItem> items = orderItemDAO.getOrderItemsByOrderId(order.getOrderId());
                    order.setItems(items);

                    if (!items.isEmpty()) {
                        int eventId = items.get(0).getEventId();
                        EventDAO eventDAO = new EventDAO();
                        order.setEvent(eventDAO.getEventById(eventId));
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
        
        System.out.println("=== OrderDAO Debug ===");
        System.out.println("Fetching orders for user ID: " + userId);

        String sql = "SELECT o.OrderID, SUM(oi.Quantity) AS TotalQuantity, o.TotalAmount, o.CreatedAt, "
                + "MIN(e.EventID) AS EventID, MIN(e.Name) AS EventName, "
                + "MIN(e.StartTime) AS StartTime, MIN(e.PhysicalLocation) AS PhysicalLocation, "
                + "MIN(r.RefundStatus) AS RefundStatus, MIN(r.RefundID) AS RefundID, "
                + "MIN(r.RefundAmount) AS RefundAmount, MIN(r.RefundRequestDate) AS RefundRequestDate "
                + "FROM Orders o "
                + "JOIN OrderItems oi ON o.OrderID = oi.OrderID "
                + "JOIN Events e ON oi.EventID = e.EventID "
                + "LEFT JOIN Refunds r ON o.OrderID = r.OrderID AND r.IsDeleted = 0 "
                + "WHERE o.UserID = ? AND o.PaymentStatus = 'paid' "
                + "GROUP BY o.OrderID, o.TotalAmount, o.CreatedAt "
                + "ORDER BY o.CreatedAt DESC";

        System.out.println("SQL Query: " + sql);

        try ( Connection conn = DBConnection.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            System.out.println("Database connection successful");
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            
            System.out.println("Executing query...");
            int count = 0;

            java.time.format.DateTimeFormatter dateTimeFormatter = java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
            java.time.format.DateTimeFormatter dateOnlyFormatter = java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy");

            while (rs.next()) {
                count++;
                System.out.println("Processing order #" + count);
                Map<String, Object> map = new HashMap<>();
                int orderId = rs.getInt("OrderID");
                map.put("orderId", orderId);
                map.put("totalQuantity", rs.getInt("TotalQuantity"));
                map.put("totalAmount", rs.getBigDecimal("TotalAmount"));

                java.time.LocalDateTime createdAt = rs.getTimestamp("CreatedAt").toLocalDateTime();
                java.time.LocalDateTime startTime = rs.getTimestamp("StartTime").toLocalDateTime();
                LocalDateTime now = LocalDateTime.now();
                LocalDateTime refundDeadline = startTime.minusDays(1).withHour(23).withMinute(59).withSecond(59);
                
                // Kiểm tra trạng thái refund
                String refundStatus = rs.getString("RefundStatus");
                Integer refundId = rs.getObject("RefundID", Integer.class);
                BigDecimal refundAmount = rs.getBigDecimal("RefundAmount");
                Timestamp refundRequestDate = rs.getTimestamp("RefundRequestDate");
                
                // Logic kiểm tra có thể refund hay không
                boolean canRefund = false;
                String refundInfo = null;
                
                if (refundStatus == null) {
                    // Chưa có yêu cầu refund nào
                    canRefund = now.isBefore(refundDeadline);
                } else if ("pending".equals(refundStatus)) {
                    // Đã có yêu cầu refund đang chờ xử lý
                    canRefund = false;
                    refundInfo = "Đã yêu cầu hoàn tiền - Chờ xử lý";
                } else if ("approved".equals(refundStatus) || "completed".equals(refundStatus)) {
                    // Đã được phê duyệt hoàn tiền
                    canRefund = false;
                    refundInfo = "Đã hoàn tiền thành công";
                } else if ("rejected".equals(refundStatus)) {
                    // Bị từ chối hoàn tiền
                    canRefund = now.isBefore(refundDeadline);
                    refundInfo = "Yêu cầu hoàn tiền bị từ chối";
                } else {
                    // Trường hợp khác
                    canRefund = now.isBefore(refundDeadline);
                }
                
                map.put("canRefund", canRefund);
                map.put("refundStatus", refundStatus);
                map.put("refundId", refundId);
                map.put("refundAmount", refundAmount);
                map.put("refundRequestDate", refundRequestDate);
                map.put("refundInfo", refundInfo);

                map.put("createdAt", createdAt.format(dateTimeFormatter));
                map.put("createdAtShort", createdAt.format(dateOnlyFormatter));
                map.put("startTime", startTime.format(dateTimeFormatter));

                map.put("eventId", rs.getInt("EventID"));
                map.put("eventName", rs.getString("EventName"));
                map.put("physicalLocation", rs.getString("PhysicalLocation"));

                list.add(map);
            }
            
            System.out.println("Total orders found: " + count);
        } catch (Exception e) {
            System.out.println("Error in getSimpleOrdersByUserId: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    public BigDecimal getOrderTotalAmount(int orderId) {
        String sql = "SELECT TotalAmount FROM Orders WHERE OrderID = ?";
        try ( Connection conn = DBConnection.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
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

    public BigDecimal getOrderAmount(int orderId) {
        String sql = "SELECT TotalAmount FROM Orders WHERE OrderID = ?";
        try ( Connection conn = DBConnection.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getBigDecimal("TotalAmount");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

}


