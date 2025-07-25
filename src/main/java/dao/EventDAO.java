package dao;

import models.Event;
import models.TicketInfo;
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

import org.json.JSONArray;
import org.json.JSONObject;

import models.TicketType;

public class EventDAO {

    private static final Logger logger = Logger.getLogger(EventDAO.class.getName());

    /**
     * Gets the total count of approved and non-deleted events.
     * Connection is managed via try-with-resources.
     * 
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
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Event event = mapRowToEvent(rs);
                list.add(event);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<Event> getActiveEvents() {
        List<Event> list = new ArrayList<>();
        String sql = "SELECT * FROM Events WHERE isDeleted = 0 AND isApproved = 1 AND Status = 'active'";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
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
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
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
            sql = "SELECT TOP 3 * FROM Events WHERE GenreID = ? AND EventID != ? AND isDeleted = 0 AND isApproved = 1 ORDER BY StartTime DESC";
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
                    + " ORDER BY StartTime DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

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
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

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
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
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

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery();) {
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

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

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

    public ToggleEvent createEvent(Event event, List<TicketInfo> ticketInfos) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            logger.info("Creating event: " + event.getName());

            // Step 1: Insert into Events table
            String eventSql = "INSERT INTO Events (Name, Description, PhysicalLocation, StartTime, EndTime, TotalTicketCount, IsApproved, Status, GenreID, OwnerID, ImageURL, HasSeatingChart, IsDeleted, CreatedAt, UpdatedAt) "
                    +
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

                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        eventId = generatedKeys.getInt(1);
                        logger.info("Created event with EventID: " + eventId);
                    } else {
                        conn.rollback();
                        return new ToggleEvent(false, "Failed to retrieve event ID");
                    }
                }
            }

            // Step 2: Insert into TicketInfo table for each ticket info
            String ticketInfoSql = "INSERT INTO TicketInfo (TicketName, TicketDescription, Category, Price, SalesStartTime, SalesEndTime, EventID, MaxQuantityPerOrder, IsActive, CreatedAt, UpdatedAt) "
                    +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            Map<String, Integer> ticketInfoIdMap = new HashMap<>();
            for (TicketInfo ticketInfo : ticketInfos) {
                int ticketInfoId;
                try (PreparedStatement ps = conn.prepareStatement(ticketInfoSql,
                        PreparedStatement.RETURN_GENERATED_KEYS)) {
                    ps.setString(1, ticketInfo.getTicketName());
                    ps.setString(2, ticketInfo.getTicketDescription() != null ? ticketInfo.getTicketDescription()
                            : "Ticket for " + event.getName());
                    ps.setString(3, ticketInfo.getCategory() != null ? ticketInfo.getCategory() : "General");
                    ps.setBigDecimal(4, ticketInfo.getPrice());
                    ps.setTimestamp(5,
                            ticketInfo.getSalesStartTime() != null ? Timestamp.valueOf(ticketInfo.getSalesStartTime())
                                    : new Timestamp(event.getStartTime().getTime()));
                    ps.setTimestamp(6,
                            ticketInfo.getSalesEndTime() != null ? Timestamp.valueOf(ticketInfo.getSalesEndTime())
                                    : new Timestamp(event.getEndTime().getTime()));
                    ps.setInt(7, eventId);
                    ps.setInt(8, ticketInfo.getMaxQuantityPerOrder());
                    ps.setBoolean(9, ticketInfo.isActive());
                    ps.setTimestamp(10, ticketInfo.getCreatedAt() != null ? Timestamp.valueOf(ticketInfo.getCreatedAt())
                            : new Timestamp(System.currentTimeMillis()));
                    ps.setTimestamp(11, ticketInfo.getUpdatedAt() != null ? Timestamp.valueOf(ticketInfo.getUpdatedAt())
                            : new Timestamp(System.currentTimeMillis()));

                    int affectedRows = ps.executeUpdate();
                    if (affectedRows == 0) {
                        conn.rollback();
                        return new ToggleEvent(false, "Failed to create ticket info for " + ticketInfo.getTicketName());
                    }

                    try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                        if (generatedKeys.next()) {
                            ticketInfoId = generatedKeys.getInt(1);
                            ticketInfoIdMap.put(ticketInfo.getCategory() + "-" + ticketInfo.getTicketName(),
                                    ticketInfoId);
                            logger.info("Created TicketInfo: " + ticketInfo.getTicketName() + ", TicketInfoID: "
                                    + ticketInfoId);
                        } else {
                            conn.rollback();
                            return new ToggleEvent(false,
                                    "Failed to retrieve ticket info ID for " + ticketInfo.getTicketName());
                        }
                    }

                    // Step 3: Insert into TicketInventory table
                    String inventorySql = "INSERT INTO TicketInventory (TicketInfoID, TotalQuantity, SoldQuantity, ReservedQuantity, LastUpdated) "
                            +
                            "VALUES (?, ?, ?, ?, ?)";
                    try (PreparedStatement invPs = conn.prepareStatement(inventorySql)) {
                        invPs.setInt(1, ticketInfoId);
                        invPs.setInt(2, ticketInfo.getMaxQuantityPerOrder());
                        invPs.setInt(3, 0);
                        invPs.setInt(4, 0);
                        invPs.setTimestamp(5, new Timestamp(System.currentTimeMillis()));

                        int invAffectedRows = invPs.executeUpdate();
                        if (invAffectedRows == 0) {
                            conn.rollback();
                            return new ToggleEvent(false,
                                    "Failed to create ticket inventory for " + ticketInfo.getTicketName());
                        }
                    }
                }
            }

            conn.commit();
            return new ToggleEvent(true, "Event created successfully", eventId, ticketInfoIdMap);
        } catch (SQLException e) {
            logger.severe("Error creating event: " + e.getMessage() + ", SQLState: " + e.getSQLState() + ", ErrorCode: "
                    + e.getErrorCode());
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

    public ToggleEvent saveSeats(int eventId, JSONObject seatMapData, Map<String, Integer> ticketInfoIdMap,
            JSONArray ticketNames) {
        logger.info("ticketInfoIdMap contents: in save seat dao " + ticketInfoIdMap.toString());
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            logger.info("Saving zones and seats for EventID: " + eventId);
            logger.info("seatMapData: " + seatMapData.toString());

            // Validate seatMapData
            if (!seatMapData.has("zones") || !seatMapData.has("seats")) {
                conn.rollback();
                return new ToggleEvent(false, "Invalid seatMapData: missing zones or seats");
            }

            JSONArray zones = seatMapData.getJSONArray("zones");
            JSONArray seats = seatMapData.getJSONArray("seats");
            if (zones.length() == 0 || seats.length() == 0) {
                conn.rollback();
                return new ToggleEvent(false, "No zones or seats provided in seatMapData");
            }

            // Validate ticketInfoIdMap
            if (ticketInfoIdMap == null || ticketInfoIdMap.isEmpty()) {
                conn.rollback();
                return new ToggleEvent(false, "No TicketInfoID map provided for EventID: " + eventId);
            }

            // Step 1: Insert into Zones table
            String zoneSql = "INSERT INTO Zones (event_id, name, shape, color, rows, seats_per_row, total_seats, x, y, rotation, ticket_price, vertices) "
                    + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            Map<Integer, Integer> zoneIdMap = new HashMap<>();
            try (PreparedStatement ps = conn.prepareStatement(zoneSql, PreparedStatement.RETURN_GENERATED_KEYS)) {
                for (int i = 0; i < zones.length(); i++) {
                    JSONObject zone = zones.getJSONObject(i);
                    int clientZoneId = zone.getInt("id");
                    ps.setInt(1, eventId);
                    ps.setString(2, zone.getString("name"));
                    ps.setString(3, zone.getString("shape"));
                    ps.setString(4, zone.getString("color"));
                    ps.setInt(5, zone.getInt("rows"));
                    ps.setInt(6, zone.getInt("seatsPerRow"));
                    ps.setInt(7, zone.getInt("totalSeats"));
                    ps.setInt(8, zone.getInt("x"));
                    ps.setInt(9, zone.getInt("y"));
                    ps.setInt(10, zone.getInt("rotation"));
                    ps.setDouble(11, zone.getDouble("ticketPrice"));
                    ps.setString(12, zone.has("vertices") ? zone.getJSONArray("vertices").toString() : "[]");

                    int affectedRows = ps.executeUpdate();
                    if (affectedRows == 0) {
                        conn.rollback();
                        return new ToggleEvent(false, "Failed to insert zone: " + zone.getString("name"));
                    }

                    try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                        if (generatedKeys.next()) {
                            int zoneId = generatedKeys.getInt(1);
                            zoneIdMap.put(clientZoneId, zoneId);
                            logger.info("Inserted zone: " + zone.getString("name") + ", zoneId: " + zoneId);
                        } else {
                            conn.rollback();
                            return new ToggleEvent(false,
                                    "Failed to retrieve zoneId for zone: " + zone.getString("name"));
                        }
                    }
                }
            }

            // Step 2: Insert into Seat table
            String seatSql = "INSERT INTO Seat (ZoneID, Label, Color, Price, X, Y, Relative_X, Relative_Y, SeatStatus, CreatedAt) "
                    + "VALUES ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            try (PreparedStatement ps = conn.prepareStatement(seatSql, PreparedStatement.RETURN_GENERATED_KEYS)) {
                for (int i = 0; i < seats.length(); i++) {
                    JSONObject seat = seats.getJSONObject(i);
                    int clientZoneId = seat.getInt("zoneId");
                    Integer zoneId = zoneIdMap.get(clientZoneId);
                    if (zoneId == null) {
                        conn.rollback();
                        return new ToggleEvent(false, "Invalid ZoneID for seat: " + seat.getString("label"));
                    }

                    // Find TicketInfoID using zone name and ticket name
                    String zoneName = null;
                    int zoneIndex = -1;
                    for (int j = 0; j < zones.length(); j++) {
                        JSONObject zone = zones.getJSONObject(j);
                        if (zone.getInt("id") == clientZoneId) {
                            zoneName = zone.getString("name");
                            zoneIndex = j;
                            break;
                        }
                    }
                    if (zoneName == null) {
                        conn.rollback();
                        return new ToggleEvent(false, "Zone not found for clientZoneId: " + clientZoneId);
                    }

                    ps.setInt(1, zoneId);
                    ps.setString(2, seat.getString("label"));
                    ps.setString(3, seat.getString("color"));
                    ps.setDouble(4, seat.getDouble("price"));
                    ps.setInt(5, seat.getInt("x"));
                    ps.setInt(6, seat.getInt("y"));
                    ps.setDouble(7, seat.getDouble("relativeX"));
                    ps.setDouble(8, seat.getDouble("relativeY"));
                    ps.setString(9, seat.getString("status"));
                    ps.setTimestamp(10, new Timestamp(System.currentTimeMillis()));

                    int affectedRows = ps.executeUpdate();
                    if (affectedRows == 0) {
                        conn.rollback();
                        return new ToggleEvent(false, "Failed to insert seat: " + seat.getString("label"));
                    }

                    try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                        if (generatedKeys.next()) {
                            logger.info("Inserted seat: " + seat.getString("label") + ", seatId: "
                                    + generatedKeys.getInt(1));
                        } else {
                            conn.rollback();
                            return new ToggleEvent(false,
                                    "Failed to retrieve seatId for seat: " + seat.getString("label"));
                        }
                    }
                }
            }

            conn.commit();
            return new ToggleEvent(true, "Zones and seats saved successfully");
        } catch (SQLException e) {
            logger.severe("Error saving zones and seats for EventID: " + eventId + " - " + e.getMessage()
                    + ", SQLState: " + e.getSQLState() + ", ErrorCode: " + e.getErrorCode());
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException re) {
                    logger.severe("Rollback failed: " + re.getMessage());
                }
            }
            return new ToggleEvent(false, "Error saving zones and seats: " + e.getMessage());
        } catch (Exception e) {
            logger.severe("Unexpected error in saveSeats: " + e.getMessage());
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException re) {
                    logger.severe("Rollback failed: " + re.getMessage());
                }
            }
            return new ToggleEvent(false, "Unexpected error: " + e.getMessage());
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

    public ToggleEvent deleteEvent(int event_id) {
        Connection conn = null;
        boolean success = false;
        System.out.println("event id to delete: " + event_id);
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

            String eventQuery = "DELETE FROM Events WHERE EventID = ?";
            try (PreparedStatement ps = conn.prepareStatement(eventQuery)) {
                ps.setInt(1, event_id);
                int rows = ps.executeUpdate();
                System.out.println("fuck");
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
            e.printStackTrace();
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

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

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
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                res = rs.getInt("eventCount");
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
                            rs.getString("Status"));
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
        String allColumns = "EventID, Name, Description, PhysicalLocation, StartTime, EndTime, " +
                "TotalTicketCount, IsApproved, Status, GenreID, OwnerID, ImageURL, " +
                "HasSeatingChart, IsDeleted, CreatedAt, UpdatedAt";

        String sql = "SELECT " + allColumns + " FROM Events WHERE IsApproved = 1 AND IsDeleted = 0 AND EndTime > GETDATE() " +
                "ORDER BY StartTime DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, limit);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    events.add(mapRowToEvent(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Lỗi khi lấy sự kiện phân trang từ cơ sở dữ liệu.", e);
        }
        return events;
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
                    // event.setRanking(rs.getLong("Ranking"));

                    res.add(event);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            // Consider throwing a custom exception or returning null/empty list based on
            // your error handling strategy
        }

        return res;
    }

    public List<Event> searchEvents(String keyword) {
        List<Event> list = new ArrayList<>();
        String sql = "SELECT * FROM Events WHERE IsApproved = 1 AND IsDeleted = 0 AND EndTime > GETDATE() AND (Name LIKE ? OR Description LIKE ?) ORDER BY StartTime DESC";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            String kw = "%" + keyword + "%";
            ps.setString(1, kw);
            ps.setString(2, kw);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRowToEvent(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Event> searchEvents(String keyword, String location) {
        List<Event> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM Events WHERE IsApproved = 1 AND IsDeleted = 0 AND EndTime > GETDATE()");
        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (Name LIKE ? OR Description LIKE ?)");
            String kw = "%" + keyword.trim() + "%";
            params.add(kw);
            params.add(kw);
        }
        if (location != null && !location.trim().isEmpty()) {
            sql.append(" AND PhysicalLocation LIKE ?");
            params.add("%" + location.trim() + "%");
        }
        sql.append(" ORDER BY StartTime DESC");

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRowToEvent(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Event> searchEvents(String keyword, String location, Integer genreId) {
        List<Event> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM Events WHERE IsApproved = 1 AND IsDeleted = 0 AND EndTime > GETDATE()");
        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (Name LIKE ? OR Description LIKE ?)");
            String kw = "%" + keyword.trim() + "%";
            params.add(kw);
            params.add(kw);
        }
        if (location != null && !location.trim().isEmpty()) {
            sql.append(" AND PhysicalLocation LIKE ?");
            params.add("%" + location.trim() + "%");
        }
        if (genreId != null && genreId > 0) {
            sql.append(" AND GenreID = ?");
            params.add(genreId);
        }
        sql.append(" ORDER BY StartTime DESC");

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRowToEvent(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<String> getAvailableLocations() {
        List<String> locations = new ArrayList<>();
        String sql = "SELECT DISTINCT PhysicalLocation FROM Events WHERE IsApproved = 1 AND IsDeleted = 0 AND EndTime > GETDATE() ORDER BY PhysicalLocation";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                String location = rs.getString("PhysicalLocation");
                if (location != null && !location.trim().isEmpty()) {
                    locations.add(location);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return locations;
    }

    public List<Event> searchEventsForAdmin(String keyword, String location, boolean activeOnly) {
        List<Event> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM Events WHERE IsDeleted = 0");
        List<Object> params = new ArrayList<>();

        // Thêm điều kiện active/non-active
        if (activeOnly) {
            sql.append(" AND IsApproved = 1 AND EndTime > GETDATE()");
        } else {
            sql.append(" AND (IsApproved = 0 OR EndTime <= GETDATE())");
        }

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (Name LIKE ? OR Description LIKE ?)");
            String kw = "%" + keyword.trim() + "%";
            params.add(kw);
            params.add(kw);
        }
        if (location != null && !location.trim().isEmpty()) {
            sql.append(" AND PhysicalLocation LIKE ?");
            params.add("%" + location.trim() + "%");
        }
        sql.append(" ORDER BY StartTime DESC");

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRowToEvent(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}