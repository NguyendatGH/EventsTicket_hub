/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
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

/**
 *
 * @author admin
 */
public class EventDAO {

    public List<Event> getAllApprovedEvents() {
        List<Event> list = new ArrayList<>();
        String sql = "SELECT * FROM Events WHERE isDeleted = 0 AND isApproved = 1";

        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Event event = new Event();
                event.setEventID(rs.getInt("EventID"));
                event.setName(rs.getString("Name"));
                event.setDescription(rs.getString("Description"));
                event.setPhysicalLocation(rs.getString("PhysicalLocation"));
                event.setStartTime(rs.getTimestamp("StartTime"));
                event.setEndTime(rs.getTimestamp("EndTime"));
                event.setTotalTicketCount(
                        rs.getObject("TotalTicketCount") != null ? rs.getInt("TotalTicketCount") : null);
                event.setIsApproved(rs.getObject("IsApproved") != null ? rs.getBoolean("IsApproved") : null);
                event.setStatus(rs.getString("Status"));
                event.setGenreID(rs.getObject("GenreID") != null ? rs.getInt("GenreID") : null);
                event.setOwnerID(rs.getObject("OwnerID") != null ? rs.getInt("OwnerID") : null);
                event.setImageURL(rs.getString("ImageURL"));
                event.setHasSeatingChart(
                        rs.getObject("HasSeatingChart") != null ? rs.getBoolean("HasSeatingChart") : null);
                event.setIsDeleted(rs.getObject("IsDeleted") != null ? rs.getBoolean("IsDeleted") : null);
                event.setCreatedAt(rs.getTimestamp("CreatedAt"));
                event.setUpdatedAt(rs.getTimestamp("UpdatedAt"));

                list.add(event);
            }

            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
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
        int topCount = 5; // Default value for @TopCount

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

    public List<Event> getPendingEvents(){
       List<Event> list = new ArrayList<>();
        String sql = "SELECT * FROM Events WHERE Status = 'pending'";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
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
                event.setGenreID(rs.getObject("GenreID") != null ? rs.getInt("GenreID") : null);
                event.setOwnerID(rs.getInt("OwnerID"));
                event.setImageURL(rs.getString("ImageURL"));
                event.setHasSeatingChart(rs.getBoolean("HasSeatingChart"));
                event.setIsDeleted(rs.getBoolean("IsDeleted"));
                event.setCreatedAt(rs.getTimestamp("CreatedAt"));
                event.setUpdatedAt(rs.getTimestamp("UpdatedAt"));
             
                list.add(event);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}