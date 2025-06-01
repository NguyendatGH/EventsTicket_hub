/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Dao;

import Models.Event;
import context.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author admin
 */
public class EventDAO {
    
    
     public List<Event> getAllEvents() {
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

}
