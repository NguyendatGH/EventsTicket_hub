package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import context.DBConnection;
import models.TicketInfo;
import models.TicketInventory;

public class TicketInfoDAO {

    private TicketInfo mapRowToTicketInfo(ResultSet rs) throws SQLException {
        TicketInfo ticket = new TicketInfo();
        ticket.setTicketInfoID(rs.getInt("TicketInfoID"));
        ticket.setTicketName(rs.getString("TicketName"));
        ticket.setTicketDescription(rs.getString("TicketDescription"));
        ticket.setCategory(rs.getString("Category"));
        ticket.setPrice(rs.getBigDecimal("Price"));
        if (rs.getTimestamp("SalesStartTime") != null) {
            ticket.setSalesStartTime(rs.getTimestamp("SalesStartTime").toLocalDateTime());
        }
        if (rs.getTimestamp("SalesEndTime") != null) {
            ticket.setSalesEndTime(rs.getTimestamp("SalesEndTime").toLocalDateTime());
        }
        ticket.setEventID(rs.getInt("EventID"));
        ticket.setMaxQuantityPerOrder(rs.getInt("MaxQuantityPerOrder"));
        ticket.setActive(rs.getBoolean("IsActive"));
        return ticket;
    }

    private TicketInventory mapRowToInventory(ResultSet rs) throws SQLException {
        if (rs.getObject("InventoryID") == null) {
            return null;
        }
        TicketInventory inventory = new TicketInventory();
        inventory.setInventoryID(rs.getInt("InventoryID"));
        inventory.setTicketInfoID(rs.getInt("TicketInfoID"));
        inventory.setTotalQuantity(rs.getInt("TotalQuantity"));
        inventory.setSoldQuantity(rs.getInt("SoldQuantity"));
        inventory.setReservedQuantity(rs.getInt("ReservedQuantity"));
        if (rs.getTimestamp("LastUpdated") != null) {
            inventory.setLastUpdated(rs.getTimestamp("LastUpdated").toLocalDateTime());
        }
        return inventory;
    }

    public List<TicketInfo> getTicketInfosByEventID(int eventID) {
        List<TicketInfo> list = new ArrayList<>();
        String sql = "SELECT ti.*, inv.* FROM TicketInfo ti "
                + "LEFT JOIN TicketInventory inv ON ti.TicketInfoID = inv.TicketInfoID "
                + "WHERE ti.EventID = ? AND ti.IsActive = 1";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, eventID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    TicketInfo ticket = mapRowToTicketInfo(rs);
                    TicketInventory inventory = mapRowToInventory(rs);
                    ticket.setInventory(inventory);
                    list.add(ticket);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public TicketInfo getTicketInfoById(int ticketId) {
        TicketInfo ticket = null;
        String sql = "SELECT ti.*, inv.* FROM TicketInfo ti "
                + "LEFT JOIN TicketInventory inv ON ti.TicketInfoID = inv.TicketInfoID "
                + "WHERE ti.TicketInfoID = ? AND ti.IsActive = 1";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, ticketId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    ticket = mapRowToTicketInfo(rs);
                    TicketInventory inventory = mapRowToInventory(rs);
                    ticket.setInventory(inventory);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return ticket;
    }

    public TicketInfo getTicketInfoBySeat(int seatId) {
        TicketInfo ticketInfo = null;
        String sql =  "SELECT ti.*, inv.* " +
                     "FROM Seat s " +
                     "JOIN Zones z ON s.ZoneID = z.id " +
                     "JOIN TicketInfo ti ON ti.EventID = z.event_id AND ti.Category = z.name " +
                     "LEFT JOIN TicketInventory inv ON ti.TicketInfoID = inv.TicketInfoID " +
                     "WHERE s.SeatID = ? AND ti.IsActive = 1";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, seatId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    ticketInfo = new TicketInfo();
                    ticketInfo.setTicketInfoID(rs.getInt("TicketInfoID"));
                    ticketInfo.setTicketName(rs.getString("TicketName"));
                    ticketInfo.setTicketDescription(rs.getString("TicketDescription"));
                    ticketInfo.setCategory(rs.getString("Category"));
                    ticketInfo.setPrice(rs.getBigDecimal("Price"));
                    if (rs.getTimestamp("SalesStartTime") != null) {
                        ticketInfo.setSalesStartTime(rs.getTimestamp("SalesStartTime").toLocalDateTime());
                    }
                    if (rs.getTimestamp("SalesEndTime") != null) {
                        ticketInfo.setSalesEndTime(rs.getTimestamp("SalesEndTime").toLocalDateTime());
                    }
                    ticketInfo.setEventID(rs.getInt("EventID"));
                    ticketInfo.setMaxQuantityPerOrder(rs.getInt("MaxQuantityPerOrder"));
                    ticketInfo.setActive(rs.getBoolean("IsActive"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return ticketInfo;
    }
}
