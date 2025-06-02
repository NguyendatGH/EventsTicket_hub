package Dao;

import context.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Event;

public class EventDAO {

    public EventDAO() {
    }

    // Lấy tất cả sự kiện trong database
    public List<Event> getAllEvents() {
        List<Event> events = new ArrayList<>();
        String sql = "SELECT * FROM Events WHERE IsDeleted = 0"; // Example query to get events
        try (Connection conn = new DBConnection().getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Event event = new Event();
                event.setEventID(rs.getInt("EventID"));
                event.setName(rs.getString("Name"));
                event.setDescription(rs.getString("Description"));
                event.setPhysicalLocation(rs.getString("PhysicalLocation"));
                event.setStartTime(rs.getTimestamp("StartTime"));
                event.setEndTime(rs.getTimestamp("EndTime"));
                event.setTotalTicketCount(rs.getInt("TotalTicketCount"));
                event.setImageURL(rs.getString("ImageURL"));
                events.add(event);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return events;
    }

    public Event getEventById(int eventID) {
        Event event = null;
        String sql = "SELECT * FROM Events WHERE eventID = ?";
        try (Connection conn = new DBConnection().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, eventID);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                event = new Event();
                event.setEventID(rs.getInt("eventID"));
                event.setName(rs.getString("name"));
                event.setDescription(rs.getString("description"));
                event.setPhysicalLocation(rs.getString("physicalLocation"));
                event.setStartTime(rs.getTimestamp("startTime"));
                event.setEndTime(rs.getTimestamp("endTime"));
                event.setTotalTicketCount(rs.getInt("totalTicketCount"));
                event.setApproved(rs.getBoolean("isApproved"));
                event.setStatus(rs.getString("status"));
                event.setGenreID(rs.getInt("genreID"));
                event.setOwnerID(rs.getInt("ownerID"));
                event.setImageURL(rs.getString("imageURL"));
                event.setHasSeatingChart(rs.getBoolean("hasSeatingChart"));
                event.setDeleted(rs.getBoolean("isDeleted"));
                event.setCreatedAt(rs.getTimestamp("createdAt"));
                event.setUpdatedAt(rs.getTimestamp("updatedAt"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return event;
    }

    public List<Event> getSuggestedEvents(int currentEventId) {
        List<Event> events = new ArrayList<>();
        String sql = "SELECT * FROM Events WHERE IsDeleted = 0 AND EventID != ?"; // Exclude the current event
        try (Connection conn = new DBConnection().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, currentEventId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Event event = new Event();
                event.setEventID(rs.getInt("EventID"));
                event.setName(rs.getString("Name"));
                event.setDescription(rs.getString("Description"));
                event.setPhysicalLocation(rs.getString("PhysicalLocation"));
                event.setStartTime(rs.getTimestamp("StartTime"));
                event.setEndTime(rs.getTimestamp("EndTime"));
                event.setTotalTicketCount(rs.getInt("TotalTicketCount"));
                event.setImageURL(rs.getString("ImageURL"));
                events.add(event);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return events;
    }

}
