package dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;
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

    
//    public boolean updateInventoryAfterSale(int ticketInfoId, int quantitySold, Connection conn) throws SQLException {
//        String sql = "UPDATE TicketInventory SET SoldQuantity = SoldQuantity + ? "
//                + "WHERE TicketInfoID = ? AND (TotalQuantity - SoldQuantity - ReservedQuantity) >= ?";
//
//        try (PreparedStatement ps = conn.prepareStatement(sql)) {
//            ps.setInt(1, quantitySold);
//            ps.setInt(2, ticketInfoId);
//            ps.setInt(3, quantitySold);
//
//            int affectedRows = ps.executeUpdate();
//            return affectedRows > 0;
//        }
//    }
}
