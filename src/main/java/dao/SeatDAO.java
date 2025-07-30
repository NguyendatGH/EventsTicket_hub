package dao;

import context.DBConnection;
import models.Seat;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class SeatDAO {

    public List<Seat> getSeatsByEventId(int eventId) {
        System.out.println("[DEBUG-DAO] SeatDAO: Fetching seats for EventID = " + eventId);
        List<Seat> seatList = new ArrayList<>();
        String sql = "SELECT SeatID, ZoneID, Label, color, price, x, y, relative_x, relative_y, SeatStatus " +
                "FROM Seat WHERE ZoneID IN (SELECT id FROM Zones WHERE event_id = ?)";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Seat seat = new Seat();
                    seat.setSeatId(rs.getInt("SeatID"));
                    seat.setZoneId(rs.getInt("ZoneID"));
                    seat.setLabel(rs.getString("Label"));
                    seat.setColor(rs.getString("color"));
                    seat.setSeatPrice(rs.getDouble("price"));
                    seat.setX(rs.getInt("x"));
                    seat.setY(rs.getInt("y"));
                    seat.setRelativeX(rs.getFloat("relative_x"));
                    seat.setRelativeY(rs.getFloat("relative_y"));
                    seat.setStatus(rs.getString("SeatStatus"));
                    seatList.add(seat);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        System.out.println("[DEBUG-DAO] SeatDAO: Found " + seatList.size() + " seats.");
        return seatList;
    }

    public Seat getSeatById(int seatId) {
        String sql = "SELECT SeatID, ZoneID, Label, color, price, x, y, relative_x, relative_y, SeatStatus " +
                "FROM Seat WHERE SeatID = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, seatId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Seat seat = new Seat();
                    seat.setSeatId(rs.getInt("SeatID"));
                    seat.setZoneId(rs.getInt("ZoneID"));
                    seat.setLabel(rs.getString("Label"));
                    seat.setColor(rs.getString("color"));
                    seat.setSeatPrice(rs.getDouble("price"));
                    seat.setX(rs.getInt("x"));
                    seat.setY(rs.getInt("y"));
                    seat.setRelativeX(rs.getFloat("relative_x"));
                    seat.setRelativeY(rs.getFloat("relative_y"));
                    seat.setStatus(rs.getString("SeatStatus"));
                    return seat;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Seat> getSeatsByIds(List<Integer> seatIds) {
        List<Seat> seatList = new ArrayList<>();
        if (seatIds == null || seatIds.isEmpty()) {
            return seatList;
        }

        String sql = "SELECT SeatID, ZoneID, Label, color, price, x, y, relative_x, relative_y, SeatStatus " +
                "FROM Seat WHERE SeatID IN (" +
                String.join(",", seatIds.stream().map(String::valueOf).toArray(String[]::new)) + ")";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Seat seat = new Seat();
                    seat.setSeatId(rs.getInt("SeatID"));
                    seat.setZoneId(rs.getInt("ZoneID"));
                    seat.setLabel(rs.getString("Label"));
                    seat.setColor(rs.getString("color"));
                    seat.setSeatPrice(rs.getDouble("price"));
                    seat.setX(rs.getInt("x"));
                    seat.setY(rs.getInt("y"));
                    seat.setRelativeX(rs.getFloat("relative_x"));
                    seat.setRelativeY(rs.getFloat("relative_y"));
                    seat.setStatus(rs.getString("SeatStatus"));
                    seatList.add(seat);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return seatList;
    }

    public boolean reserveSeat(int seatId, Connection conn) throws SQLException {
        String sql = "UPDATE Seat SET SeatStatus = 'reserved' WHERE SeatID = ? AND SeatStatus = 'available'";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, seatId);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        }
    }

    public boolean updateSeatStatus(int seatId, String status) throws SQLException {
        String sql = "UPDATE Seat SET SeatStatus = ? WHERE SeatID = ? AND SeatStatus IN ('available', 'reserved')";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, seatId);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        }
    }
}