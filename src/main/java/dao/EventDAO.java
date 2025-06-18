package dao;

import models.Event;
import context.DBConnection;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class EventDAO {

    public List<Event> getAllApprovedEvents() {
        List<Event> list = new ArrayList<>();
        String sql = "SELECT * FROM Events WHERE isDeleted = 0 AND isApproved = 1";

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
                System.out.println("[DEBUG] EventCount found: " + res);
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
        event.setImageURL(rs.getString("ImageURL"));
        event.setStatus(rs.getString("Status"));

        
        event.setHasSeatingChart(rs.getBoolean("HasSeatingChart"));

       //Gán trực tiếp Timestamp vào Date, không cần .toLocalDateTime()
        event.setStartTime(rs.getTimestamp("StartTime"));
        event.setEndTime(rs.getTimestamp("EndTime"));
        event.setCreatedAt(rs.getTimestamp("CreatedAt"));
        event.setUpdatedAt(rs.getTimestamp("UpdatedAt"));

        // Đọc các giá trị có thể NULL một cách an toàn
        int totalTicketCount = rs.getInt("TotalTicketCount");
        if (!rs.wasNull()) {
            event.setTotalTicketCount(totalTicketCount);
        }
        int genreID = rs.getInt("GenreID");
        if (!rs.wasNull()) {
            event.setGenreID(genreID);
        }
        int ownerID = rs.getInt("OwnerID");
        if (!rs.wasNull()) {
            event.setOwnerID(ownerID);
        }
        boolean isApproved = rs.getBoolean("IsApproved");
        if (!rs.wasNull()) {
            event.setIsApproved(isApproved);
        }
        boolean isDeleted = rs.getBoolean("IsDeleted");
        if (!rs.wasNull()) {
            event.setIsDeleted(isDeleted);
        }

        return event;
    }

    public boolean deleteEvent(int event_id) {
        String sqlString = "Delete from Events e where e.EventID = ?";

        return true;
    }

    public List<Event> getUpcomingEvents() {
        List<Event> list = new ArrayList<>();
        String sql = "SELECT TOP 4 * FROM Events WHERE StartTime > GETDATE() AND isDeleted = 0 AND isApproved = 1 ORDER BY StartTime ASC";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRowToEvent(rs)); // Thêm dòng này
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

}
