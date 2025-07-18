package dao;

import models.Event;
import service.UserService;
import utils.ToggleEvent;
import context.DBConnection;
import dto.TransactionDTO;
import dto.UserDTO;

import java.math.BigDecimal;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.sql.Types;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;
import models.TicketType;

public class EventDAO {

    private static final Logger logger = Logger.getLogger(EventDAO.class.getName());
    

    /**
     * Gets the total count of approved and non-deleted events.
     * Connection is managed via try-with-resources.
     * @return The total count of events.
     */
    public int getTotalApprovedEventsCount() {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM Events WHERE IsApproved = 1 AND IsDeleted = 0"; 
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Error getting total approved events count from database.", e);
        }
        return count;
    }

    public List<Event> getAllApprovedEvents() {
        List<Event> list = new ArrayList<>();
        String sql = "SELECT * FROM Events WHERE status != 'completed' AND isApproved = 1";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Event event = mapRowToEvent(rs);
                list.add(event);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }
    public ToggleEvent createEvent(Event event, List<TicketType> ticketTypes) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // Step 1: Insert into Events table
            String eventSql = "INSERT INTO Events (Name, Description, PhysicalLocation, StartTime, EndTime, TotalTicketCount, IsApproved, Status, GenreID, OwnerID, ImageURL, HasSeatingChart, IsDeleted, CreatedAt, UpdatedAt) " +
                             "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            int eventId;
            try (PreparedStatement ps = conn.prepareStatement(eventSql, PreparedStatement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, event.getName());
                ps.setString(2, event.getDescription());
                ps.setString(3, event.getPhysicalLocation());
                ps.setTimestamp(4, new Timestamp(event.getStartTime().getTime()));
                ps.setTimestamp(5, new Timestamp(event.getEndTime().getTime()));
                ps.setInt(6, event.getTotalTicketCount());
                ps.setBoolean(7, event.getIsApproved() != null ? event.getIsApproved() : false);
                ps.setString(8, "pending");
                ps.setObject(9, event.getGenreID(), Types.INTEGER);
                ps.setInt(10, event.getOwnerID());
                ps.setString(11, event.getImageURL());
                ps.setBoolean(12, event.getHasSeatingChart() != null ? event.getHasSeatingChart() : false);
                ps.setBoolean(13, event.getIsDeleted() != null ? event.getIsDeleted() : false);
                ps.setTimestamp(14, new Timestamp(event.getCreatedAt().getTime()));
                ps.setTimestamp(15, new Timestamp(event.getUpdatedAt().getTime()));

                int affectedRows = ps.executeUpdate();
                if (affectedRows == 0) {
                    conn.rollback();
                    return new ToggleEvent(false, "Failed to create event");
                }

                // Retrieve the generated EventID
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        eventId = generatedKeys.getInt(1);
                    } else {
                        conn.rollback();
                        return new ToggleEvent(false, "Failed to retrieve event ID");
                    }
                }
            }

            // Step 2: Insert into TicketInfo table (default ticket type)
            String ticketInfoSql = "INSERT INTO TicketInfo (TicketName, TicketDescription, Category, Price, SalesStartTime, SalesEndTime, EventID, MaxQuantityPerOrder, IsActive, CreatedAt, UpdatedAt) " +
                                  "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            int ticketInfoId;
            try (PreparedStatement ps = conn.prepareStatement(ticketInfoSql, PreparedStatement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, "General Admission");
                ps.setString(2, "Standard ticket for event: " + event.getName());
                ps.setString(3, "General");
                ps.setBigDecimal(4, new java.math.BigDecimal("0.00")); // Default price
                ps.setTimestamp(5, new Timestamp(event.getStartTime().getTime()));
                ps.setTimestamp(6, new Timestamp(event.getEndTime().getTime()));
                ps.setInt(7, eventId);
                ps.setInt(8, 10); // Default max quantity per order
                ps.setBoolean(9, true);
                ps.setTimestamp(10, new Timestamp(System.currentTimeMillis()));
                ps.setTimestamp(11, new Timestamp(System.currentTimeMillis()));

                int affectedRows = ps.executeUpdate();
                if (affectedRows == 0) {
                    conn.rollback();
                    return new ToggleEvent(false, "Failed to create ticket info");
                }

                // Retrieve the generated TicketInfoID
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        ticketInfoId = generatedKeys.getInt(1);
                    } else {
                        conn.rollback();
                        return new ToggleEvent(false, "Failed to retrieve ticket info ID");
                    }
                }
            }

            // Step 3: Insert into TicketInventory table
            String inventorySql = "INSERT INTO TicketInventory (TicketInfoID, TotalQuantity, SoldQuantity, ReservedQuantity, LastUpdated) " +
                                 "VALUES (?, ?, ?, ?, ?)";
            try (PreparedStatement ps = conn.prepareStatement(inventorySql)) {
                ps.setInt(1, ticketInfoId);
                ps.setInt(2, event.getTotalTicketCount());
                ps.setInt(3, 0);
                ps.setInt(4, 0);
                ps.setTimestamp(5, new Timestamp(System.currentTimeMillis()));

                int affectedRows = ps.executeUpdate();
                if (affectedRows == 0) {
                    conn.rollback();
                    return new ToggleEvent(false, "Failed to create ticket inventory");
                }
            }

            conn.commit();
            return new ToggleEvent(true, "Event created successfully");
        } catch (SQLException e) {
            logger.severe("Error creating event: " + e.getMessage());
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException re) {
                    logger.severe("Rollback failed: " + re.getMessage());
                }
            }
            return new ToggleEvent(false, "Error creating event: " + e.getMessage());
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException ce) {
                    logger.severe("Error closing connection: " + ce.getMessage());
                }
            }
        }
    }

    public List<Event> getActiveEvents() {
        List<Event> list = new ArrayList<>();
        String sql = "SELECT * FROM Events WHERE isDeleted = 0 AND isApproved = 1 AND Status = 'active'";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRowToEvent(rs));
            }
        } catch (SQLException e) {
            logger.severe("Error fetching active events: " + e.getMessage());
        }
        return list;
    }

    public List<Event> getNonActiveEvents() {
        List<Event> list = new ArrayList<>();
        String sql = "SELECT * FROM Events WHERE isDeleted = 0 AND isApproved = 1 AND Status IN ('pending', 'cancelled', 'completed')";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRowToEvent(rs));
            }
        } catch (SQLException e) {
            logger.severe("Error fetching non-active events: " + e.getMessage());
        }
        return list;
    }

    public Event getEventById(int eventId) {
        Event event = null;
        String sql = "SELECT * FROM Events WHERE EventID = ? AND isDeleted = 0";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    event = mapRowToEvent(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return event;
    }

    public int getAllEventCreatedThisMonthNums() {
        int res = 0;
        String sql = "EXEC GetEventsCountThisMonth";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                res = rs.getInt("EventCount");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return res;
    }

    public List<Event> getListTopEvents() {
        List<Event> list = new ArrayList<>();
        String sql = "{CALL GetTopHotEvents(?)}";
        int topCount = 5;
        try (Connection conn = DBConnection.getConnection(); CallableStatement stmt = conn.prepareCall(sql)) {

            stmt.setInt(1, topCount);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Event event = new Event(
                        rs.getInt("EventID"),
                        rs.getString("Name"),
                        rs.getTimestamp("StartTime"),
                        rs.getTimestamp("EndTime"),
                        rs.getInt("TotalTicketCount"),
                        rs.getString("Status"),
                        rs.getLong("Ranking"));
                list.add(event);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Event> getPendingEvents() {
        List<Event> list = new ArrayList<>();
        String sql = "SELECT * FROM Events WHERE Status = 'pending'";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Event event = mapRowToEvent(rs);
                list.add(event);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<Event> getSuggestedEvents(int currentEventId) {
        List<Event> suggestedList = new ArrayList<>();
        Event currentEvent = getEventById(currentEventId);

        String sql;

        if (currentEvent != null && currentEvent.getGenreID() != null) {
            sql = "SELECT * FROM Events WHERE GenreID = ? AND EventID != ? AND isDeleted = 0 AND isApproved = 1 ORDER BY StartTime DESC LIMIT 3";
            try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, currentEvent.getGenreID());
                ps.setInt(2, currentEventId);

                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        suggestedList.add(mapRowToEvent(rs));
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        if (suggestedList.size() < 3) {
            int limit = 3 - suggestedList.size();
            List<Integer> excludeIds = new ArrayList<>();
            excludeIds.add(currentEventId);
            for (Event e : suggestedList) {
                excludeIds.add(e.getEventID());
            }

            StringBuilder excludeClause = new StringBuilder();
            if (!excludeIds.isEmpty()) {
                excludeClause.append(" AND EventID NOT IN (");
                for (int i = 0; i < excludeIds.size(); i++) {
                    excludeClause.append("?");
                    if (i < excludeIds.size() - 1) {
                        excludeClause.append(",");
                    }
                }
                excludeClause.append(")");
            }

            sql = "SELECT * FROM Events WHERE isDeleted = 0 AND isApproved = 1"
                    + excludeClause.toString()
                    + " ORDER BY StartTime DESC LIMIT ?";

            try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

                int paramIndex = 1;
                for (Integer excludeId : excludeIds) {
                    ps.setInt(paramIndex++, excludeId);
                }
                ps.setInt(paramIndex, limit);

                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        final int eventIdFromRs = rs.getInt("EventID");

                        if (suggestedList.stream().noneMatch(e -> e.getEventID() == eventIdFromRs)) {
                            suggestedList.add(mapRowToEvent(rs));
                            if (suggestedList.size() >= 3) {
                                break;
                            }
                        }
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return suggestedList;
    }

    private Event mapRowToEvent(ResultSet rs) throws SQLException {
        Event event = new Event();
        event.setEventID(rs.getInt("EventID"));
        event.setName(rs.getString("Name"));
        event.setDescription(rs.getString("Description"));
        event.setPhysicalLocation(rs.getString("PhysicalLocation"));
        event.setStartTime(rs.getTimestamp("StartTime"));
        event.setEndTime(rs.getTimestamp("EndTime"));
        event.setTotalTicketCount(rs.getObject("TotalTicketCount") != null ? rs.getInt("TotalTicketCount") : null);
        event.setIsApproved(rs.getObject("IsApproved") != null ? rs.getBoolean("IsApproved") : null);
        event.setStatus(rs.getString("Status"));
        event.setGenreID(rs.getObject("GenreID") != null ? rs.getInt("GenreID") : null);
        event.setOwnerID(rs.getObject("OwnerID") != null ? rs.getInt("OwnerID") : null);
        event.setImageURL(rs.getString("ImageURL"));
        event.setHasSeatingChart(rs.getObject("HasSeatingChart") != null ? rs.getBoolean("HasSeatingChart") : null);
        event.setIsDeleted(rs.getObject("IsDeleted") != null ? rs.getBoolean("IsDeleted") : null);
        event.setCreatedAt(rs.getTimestamp("CreatedAt"));
        event.setUpdatedAt(rs.getTimestamp("UpdatedAt"));
        return event;
    }

    public List<Event> getUpcomingEvents() {
        List<Event> list = new ArrayList<>();
        String sql = "SELECT TOP 4 * FROM Events WHERE StartTime > GETDATE() ORDER BY StartTime ASC";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Map<String, Integer> getEventByStatus() {
        Map<String, Integer> stats = new HashMap<>();

        String sql = "Select status, count(*) as count from Events where IsDeleted = 0 group by status";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                stats.put(rs.getString("status"), rs.getInt("count"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stats;
    }

    public Map<String, Integer> getEventStatsByGenre() {
        Map<String, Integer> stats = new HashMap<>();
        String sql = "SELECT g.GenreName as GenreName, COUNT(e.EventID) as count FROM Genres g  LEFT JOIN Events e ON g.GenreID = e.GenreID AND e.isDeleted = 0  GROUP BY g.GenreID, g.GenreName  ORDER BY count DESC";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery();) {
            while (rs.next()) {
                stats.put(rs.getString("GenreName"), rs.getInt("count"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return stats;
    }

    public List<Map<String, Object>> getMonthlyEventStats() {
        List<Map<String, Object>> stats = new ArrayList<>();
        String sql = "SELECT YEAR(CreatedAt) as year, MONTH(CreatedAt) as month, COUNT(*) as count FROM Events WHERE isDeleted = 0 AND CreatedAt >= DATEADD(MONTH, -6, GETDATE()) GROUP BY YEAR(CreatedAt), MONTH(CreatedAt) ORDER BY year, month";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> monthData = new HashMap<>();
                monthData.put("year", rs.getInt("year"));
                monthData.put("month", rs.getInt("month"));
                monthData.put("count", rs.getInt("count"));
                stats.add(monthData);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return stats;
    }

    public boolean createEvent(Event event) {
        return false;
    }

    public ToggleEvent deleteEvent(int event_id) {
        Connection conn = null;
        boolean success = false;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // Check for sold tickets (for hard delete)
            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT COUNT(*) FROM Ticket t JOIN TicketInfo ti ON t.TicketInfoID = ti.TicketInfoID WHERE ti.EventID = ? AND t.Status = 'sold'")) {
                ps.setInt(1, event_id);
                ResultSet rs = ps.executeQuery();
                if (rs.next() && rs.getInt(1) > 0) {
                    logger.warning("Cannot hard delete EventID: " + event_id + " due to sold tickets");
                    conn.rollback();
                    return new ToggleEvent(false, "Không thể xóa sự kiện vì đã có vé được bán");
                }
            }

            // Delete or update dependent records
            String[] deleteQueries = {
                "DELETE FROM Ticket WHERE TicketInfoID IN (SELECT TicketInfoID FROM TicketInfo WHERE EventID = ?)",
                "DELETE FROM TicketInventory WHERE TicketInfoID IN (SELECT TicketInfoID FROM TicketInfo WHERE EventID = ?)",
                "DELETE FROM OrderItems WHERE EventID = ?",
                "DELETE FROM Refunds WHERE OrderID IN (SELECT OrderID FROM OrderItems WHERE EventID = ?)",
                "DELETE FROM TicketInfo WHERE EventID = ?",
                "DELETE FROM Seat WHERE EventID = ?",
                "DELETE FROM Feedback WHERE EventID = ?",
                "DELETE FROM Report WHERE EventID = ?",
                "DELETE FROM Conversations WHERE EventID = ?",
                "DELETE FROM Promotions WHERE EventID = ?"
            };

            for (String query : deleteQueries) {
                try (PreparedStatement ps = conn.prepareStatement(query)) {
                    ps.setInt(1, event_id);
                    ps.executeUpdate();
                }
            }

            // Delete or update event
            String eventQuery = "DELETE FROM Events WHERE EventID = ?";
            try (PreparedStatement ps = conn.prepareStatement(eventQuery)) {
                ps.setInt(1, event_id);
                int rows = ps.executeUpdate();
                if (rows == 0) {
                    conn.rollback();
                    return new ToggleEvent(false, "Sự kiện không tồn tại");
                }
            }

            // Log to AuditLog
            try (PreparedStatement ps = conn.prepareStatement(
                    "INSERT INTO AuditLog (TableName, RecordID, Action, UserID, CreatedAt) VALUES (?, ?, ?, ?, ?)")) {
                ps.setString(1, "Events");
                ps.setInt(2, event_id);
                ps.setString(3, "DELETE");
                ps.setInt(4, 1);
                ps.setTimestamp(5, new Timestamp(System.currentTimeMillis()));
                ps.executeUpdate();
            }

            conn.commit();
            success = true;
            return new ToggleEvent(true, "Xóa sự kiện thành công");
        } catch (SQLException e) {
            logger.severe("Error during " + "hard" + " delete of EventID: " + event_id + " - "
                    + e.getMessage());
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException re) {
                    logger.severe("Rollback failed: " + re.getMessage());
                }
            }
            return new ToggleEvent(false, "Lỗi hệ thống khi xóa sự kiện");
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException ce) {
                    logger.severe("Error closing connection: " + ce.getMessage());
                }
            }
        }

    }

    // Existing updateEvent method remains unchanged
    public ToggleEvent updateEvent(Event event) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            // Check if event exists
            String checkSql = "SELECT COUNT(*) FROM Events WHERE EventID = ? AND IsDeleted = 0";
            try (PreparedStatement checkPs = conn.prepareStatement(checkSql)) {
                checkPs.setInt(1, event.getEventID());
                ResultSet rs = checkPs.executeQuery();
                if (rs.next() && rs.getInt(1) == 0) {
                    conn.rollback();
                    return new ToggleEvent(false, "Sự kiện không tồn tại");
                }
            }

            // Update event
            String sql = "UPDATE Events SET Name = ?, Description = ?, PhysicalLocation = ?, StartTime = ?, EndTime = ?, TotalTicketCount = ?, Status = ?, ImageURL = ?, UpdatedAt = ? WHERE EventID = ? AND IsDeleted = 0";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, event.getName());
                ps.setString(2, event.getDescription());
                ps.setString(3, event.getPhysicalLocation());
                ps.setTimestamp(4, new Timestamp(event.getStartTime().getTime()));
                ps.setTimestamp(5, new Timestamp(event.getEndTime().getTime()));
                ps.setInt(6, event.getTotalTicketCount());
                ps.setString(7, event.getStatus());
                ps.setString(8, event.getImageURL());
                ps.setTimestamp(9, new Timestamp(System.currentTimeMillis()));
                ps.setInt(10, event.getEventID());

                int affectedRows = ps.executeUpdate();
                if (affectedRows == 0) {
                    conn.rollback();
                    return new ToggleEvent(false, "Không thể cập nhật sự kiện");
                }
            }

            // Log to AuditLog
            try (PreparedStatement ps = conn.prepareStatement(
                    "INSERT INTO AuditLog (TableName, RecordID, Action, UserID, CreatedAt) VALUES (?, ?, ?, ?, ?)")) {
                ps.setString(1, "Events");
                ps.setInt(2, event.getEventID());
                ps.setString(3, "UPDATE");
                ps.setInt(4, 1); // Assuming admin user ID is 1
                ps.setTimestamp(5, new Timestamp(System.currentTimeMillis()));
                ps.executeUpdate();
            }

            conn.commit();
            return new ToggleEvent(true, "Cập nhật sự kiện thành công");
        } catch (SQLException e) {
            logger.severe("Error updating EventID: " + event.getEventID() + " - " + e.getMessage());
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException re) {
                    logger.severe("Rollback failed: " + re.getMessage());
                }
            }
            return new ToggleEvent(false, "Lỗi hệ thống khi cập nhật sự kiện");
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException ce) {
                    logger.severe("Error closing connection: " + ce.getMessage());
                }
            }
        }
    }

    public BigDecimal getTotalRevenueOfAllEvent() {
        String sql = "SELECT SUM(TotalAmount) AS TotalRevenue FROM Orders WHERE PaymentStatus = 'paid'";
        BigDecimal totalRevenue = BigDecimal.ZERO;

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                totalRevenue = rs.getBigDecimal("TotalRevenue");
                if (rs.wasNull()) {
                    totalRevenue = BigDecimal.ZERO;
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return totalRevenue;
    }

    public int getTotalEventsCount() {
        int res = 0;
        String sql = "SELECT COUNT(EventID) AS eventCount FROM Events;";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                res =  rs.getInt("eventCount");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        System.out.println("total event");
        return 0;
    }
    public BigDecimal getTotalRevenueByOwner(int ownerId) {
    String sql = "SELECT SUM(t.Amount) FROM Transactions t " +
                 "JOIN Events e ON t.EventID = e.EventID " +
                 "WHERE e.OwnerID = ? AND t.Status = 'completed'";
    BigDecimal total = BigDecimal.ZERO;
    
    try (Connection conn = DBConnection.getConnection(); 
         PreparedStatement ps = conn.prepareStatement(sql)) {
        
        ps.setInt(1, ownerId);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                total = rs.getBigDecimal(1);
                if (rs.wasNull()) {
                    total = BigDecimal.ZERO;
                }
            }
        }
    } catch (SQLException e) {
        logger.severe("Error getting total revenue: " + e.getMessage());
    }
    return total;
}

public int getTotalTicketsSoldByOwner(int ownerId) {
    String sql = "SELECT SUM(t.TicketCount) FROM Transactions t " +
                 "JOIN Events e ON t.EventID = e.EventID " +
                 "WHERE e.OwnerID = ? AND t.Status = 'completed'";
    int count = 0;
    
    try (Connection conn = DBConnection.getConnection(); 
         PreparedStatement ps = conn.prepareStatement(sql)) {
        
        ps.setInt(1, ownerId);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                count = rs.getInt(1);
            }
        }
    } catch (SQLException e) {
        logger.severe("Error getting total tickets sold: " + e.getMessage());
    }
    return count;
}

public int getRefundRequestsCountByOwner(int ownerId) {
    String sql = "SELECT COUNT(*) FROM Refunds r " +
                 "JOIN Transactions t ON r.TransactionID = t.TransactionID " +
                 "JOIN Events e ON t.EventID = e.EventID " +
                 "WHERE e.OwnerID = ? AND r.Status = 'pending'";
    int count = 0;
    
    try (Connection conn = DBConnection.getConnection(); 
         PreparedStatement ps = conn.prepareStatement(sql)) {
        
        ps.setInt(1, ownerId);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                count = rs.getInt(1);
            }
        }
    } catch (SQLException e) {
        logger.severe("Error getting refund requests count: " + e.getMessage());
    }
    return count;
}
    public UserDTO getEventOwnerId(int eventId) {
        String sql = "SELECT OwnerID FROM Events WHERE EventID = ?;";
        UserService u = new UserService();
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, eventId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int ownerId = rs.getInt("OwnerID");
                    return u.findDTOUserID(ownerId);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }
    public List<TransactionDTO> getTransactionsByOwner(int ownerId, int page, int pageSize) {
    List<TransactionDTO> transactions = new ArrayList<>();
    String sql = "SELECT t.TransactionID, e.Name AS EventName, u.FullName AS EventOwner, u.Email AS OwnerEmail, " +
                 "t.TransactionDate, t.Amount, t.TicketCount, t.Status " +
                 "FROM Transactions t " +
                 "JOIN Events e ON t.EventID = e.EventID " +
                 "JOIN Users u ON e.OwnerID = u.UserID " +
                 "WHERE e.OwnerID = ? " +
                 "ORDER BY t.TransactionDate DESC " +
                 "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
    
    try (Connection conn = DBConnection.getConnection(); 
         PreparedStatement ps = conn.prepareStatement(sql)) {
        
        ps.setInt(1, ownerId);
        ps.setInt(2, (page - 1) * pageSize);
        ps.setInt(3, pageSize);
        
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                TransactionDTO transaction = new TransactionDTO(
                    rs.getInt("TransactionID"),
                    rs.getString("EventName"),
                    rs.getString("EventOwner"),
                    rs.getString("OwnerEmail"),
                    rs.getTimestamp("TransactionDate"),
                    rs.getBigDecimal("Amount"),
                    rs.getInt("TicketCount"),
                    rs.getString("Status")
                );
                transactions.add(transaction);
            }
        }
    } catch (SQLException e) {
        logger.severe("Error fetching transactions: " + e.getMessage());
    }
    return transactions;
}

public int getTransactionCountByOwner(int ownerId) {
    int count = 0;
    String sql = "SELECT COUNT(*) FROM Transactions t JOIN Events e ON t.EventID = e.EventID WHERE e.OwnerID = ?";
    
    try (Connection conn = DBConnection.getConnection(); 
         PreparedStatement ps = conn.prepareStatement(sql)) {
        
        ps.setInt(1, ownerId);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                count = rs.getInt(1);
            }
        }
    } catch (SQLException e) {
        logger.severe("Error counting transactions: " + e.getMessage());
    }

    return count;
}
 
   public List<Event> getApprovedEventsPaginated(int offset, int limit) {
        List<Event> events = new ArrayList<>();
        // Đảm bảo chỉ chọn các trường CÓ THẬT trong bảng Events của bạn
        // Đã loại bỏ 'Ranking'
        String allColumns = "EventID, Name, Description, PhysicalLocation, StartTime, EndTime, " +
                            "TotalTicketCount, IsApproved, Status, GenreID, OwnerID, ImageURL, " +
                            "HasSeatingChart, IsDeleted, CreatedAt, UpdatedAt"; 
                     
        String sql = "SELECT " + allColumns + " FROM Events WHERE IsApproved = 1 AND IsDeleted = 0 " +
                     "ORDER BY StartTime DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY"; 
                     
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, offset);          
            ps.setInt(2, limit);  
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    events.add(mapRowToEvent(rs)); // Sử dụng phương thức helper mapRowToEvent
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Lỗi khi lấy sự kiện phân trang từ cơ sở dữ liệu.", e);
        }
        return events;
    }
}

    public List<Event> getAllMyEvent(int userID) {
        List<Event> res = new ArrayList<>();
        String sql = "SELECT * FROM Events WHERE OwnerID = ? AND IsDeleted = 0"; // Added IsDeleted check

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userID);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Event event = new Event();
                    event.setEventID(rs.getInt("EventID"));
                    event.setName(rs.getString("Name"));
                    event.setDescription(rs.getString("Description"));
                    event.setPhysicalLocation(rs.getString("PhysicalLocation"));
                    event.setStartTime(rs.getTimestamp("StartTime"));
                    event.setEndTime(rs.getTimestamp("EndTime"));
                    event.setTotalTicketCount(rs.getInt("TotalTicketCount"));
                    event.setIsApproved(rs.getBoolean("IsApproved"));
                    event.setStatus(rs.getString("Status"));
                    event.setGenreID(rs.getInt("GenreID"));
                    event.setOwnerID(rs.getInt("OwnerID"));
                    event.setImageURL(rs.getString("ImageURL"));
                    event.setHasSeatingChart(rs.getBoolean("HasSeatingChart"));
                    event.setIsDeleted(rs.getBoolean("IsDeleted"));
                    event.setCreatedAt(rs.getTimestamp("CreatedAt"));
                    event.setUpdatedAt(rs.getTimestamp("UpdatedAt"));
                    //event.setRanking(rs.getLong("Ranking"));

                    res.add(event);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            // Consider throwing a custom exception or returning null/empty list based on your error handling strategy
        }

        return res;
    }

}