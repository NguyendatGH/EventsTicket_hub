package dao;

import models.Event;
import context.DBConnection;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class EventDAO {

    public List<Event> getAllApprovedEvents() {
        List<Event> list = new ArrayList<>();
        String sql = "SELECT * FROM Events WHERE isDeleted = 0 AND isApproved = 1";

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

    public Event getEventById(int eventId) {
        Event event = null;
        String sql = "SELECT * FROM Events WHERE EventID = ? AND isDeleted = 0";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

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

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

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

        try (Connection conn = DBConnection.getConnection();
             CallableStatement stmt = conn.prepareCall(sql)) {

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
                        rs.getLong("Ranking")
                );
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

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

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

            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {

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

            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {

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

    public boolean deleteEvent(int event_id){
        String sqlString = "Delete from Events e where e.EventID = ?";
            
        return true;
    }
}
