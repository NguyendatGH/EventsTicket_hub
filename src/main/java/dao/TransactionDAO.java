package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

import context.DBConnection;
import models.Transaction;
import models.OwnerRevenue;
import dto.UserDTO;

public class TransactionDAO {
    private static final Logger logger = Logger.getLogger(TransactionDAO.class.getName());

    public List<Transaction> getTransactionList() {
        List<Transaction> transactions = new ArrayList<>();
        String sql = "SELECT DISTINCT o.OrderID, o.OrderNumber, u.Username AS CustomerName, " +
                     "e.Name AS EventName, STRING_AGG(ti.TicketName, ', ') AS TicketName, " +
                     "o.TotalQuantity, o.TotalAmount, o.PaymentStatus, o.OrderStatus, o.CreatedAt " +
                     "FROM Orders o " +
                     "JOIN OrderItems oi ON o.OrderID = oi.OrderID " +
                     "JOIN Events e ON oi.EventID = e.EventID " +
                     "JOIN TicketInfo ti ON oi.TicketInfoID = ti.TicketInfoID " +
                     "JOIN Users u ON o.UserID = u.Id " +
                     "GROUP BY o.OrderID, o.OrderNumber, u.Username, e.Name, " +
                     "o.TotalQuantity, o.TotalAmount, o.PaymentStatus, o.OrderStatus, o.CreatedAt " +
                     "ORDER BY o.CreatedAt DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Transaction transaction = new Transaction();
                transaction.setOrderID(rs.getInt("OrderID"));
                transaction.setOrderNumber(rs.getString("OrderNumber"));
                transaction.setCustomerName(rs.getString("CustomerName"));
                transaction.setEventName(rs.getString("EventName"));
                transaction.setTicketName(rs.getString("TicketName"));
                transaction.setTotalQuantity(rs.getInt("TotalQuantity"));
                transaction.setTotalAmount(rs.getDouble("TotalAmount"));
                transaction.setPaymentStatus(rs.getString("PaymentStatus"));
                transaction.setOrderStatus(rs.getString("OrderStatus"));
                Timestamp createdAt = rs.getTimestamp("CreatedAt");
                transaction.setCreatedAt(createdAt != null ? new Date(createdAt.getTime()) : null);
                transactions.add(transaction);
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error fetching transactions", e);
        }
        return transactions;
    }

    public Map<String, Double> getDailyRevenue() {
        Map<String, Double> dailyRevenue = new HashMap<>();
        String sql = "SELECT CONVERT(date, o.CreatedAt) AS TransactionDate, " +
                     "SUM(o.TotalAmount) AS TotalRevenue " +
                     "FROM Orders o " +
                     "GROUP BY CONVERT(date, o.CreatedAt) " +
                     "ORDER BY TransactionDate DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                String date = rs.getString("TransactionDate");
                double revenue = rs.getDouble("TotalRevenue");
                dailyRevenue.put(date, revenue);
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error fetching daily revenue", e);
        }
        return dailyRevenue;
    }

    public List<OwnerRevenue> getOwnerRevenueDetailsByEmail(String ownerEmail, String timePeriod) {
        List<OwnerRevenue> ownerRevenues = new ArrayList<>();
        String sql;
        if ("monthly".equals(timePeriod)) {
            sql = "SELECT u.Id AS OwnerID, u.Username AS OwnerName, e.EventID, e.Name AS EventName, " +
                  "DATEPART(YEAR, o.CreatedAt) AS RevenueYear, DATEPART(MONTH, o.CreatedAt) AS RevenueMonth, " +
                  "COUNT(DISTINCT o.OrderID) AS OrderCount, SUM(oi.Quantity) AS TotalTicketsSold, " +
                  "SUM(oi.TotalPrice) AS EventRevenue " +
                  "FROM Users u " +
                  "INNER JOIN Events e ON u.Id = e.OwnerID " +
                  "INNER JOIN OrderItems oi ON e.EventID = oi.EventID " +
                  "INNER JOIN Orders o ON oi.OrderID = o.OrderID " +
                  "WHERE u.Email = ? AND o.PaymentStatus = 'paid' AND o.OrderStatus != 'cancelled' AND e.IsDeleted = 0 " +
                  "GROUP BY u.Id, u.Username, e.EventID, e.Name, DATEPART(YEAR, o.CreatedAt), DATEPART(MONTH, o.CreatedAt) " +
                  "ORDER BY DATEPART(YEAR, o.CreatedAt) DESC, DATEPART(MONTH, o.CreatedAt) DESC";
        } else if ("yearly".equals(timePeriod)) {
            sql = "SELECT u.Id AS OwnerID, u.Username AS OwnerName, e.EventID, e.Name AS EventName, " +
                  "DATEPART(YEAR, o.CreatedAt) AS RevenueYear, " +
                  "COUNT(DISTINCT o.OrderID) AS OrderCount, SUM(oi.Quantity) AS TotalTicketsSold, " +
                  "SUM(oi.TotalPrice) AS EventRevenue " +
                  "FROM Users u " +
                  "INNER JOIN Events e ON u.Id = e.OwnerID " +
                  "INNER JOIN OrderItems oi ON e.EventID = oi.EventID " +
                  "INNER JOIN Orders o ON oi.OrderID = o.OrderID " +
                  "WHERE u.Email = ? AND o.PaymentStatus = 'paid' AND o.OrderStatus != 'cancelled' AND e.IsDeleted = 0 " +
                  "GROUP BY u.Id, u.Username, e.EventID, e.Name, DATEPART(YEAR, o.CreatedAt) " +
                  "ORDER BY DATEPART(YEAR, o.CreatedAt) DESC";
        } else {
            sql = "SELECT u.Id AS OwnerID, u.Username AS OwnerName, e.EventID, e.Name AS EventName, " +
                  "e.StartTime, e.EndTime, COUNT(DISTINCT o.OrderID) AS OrderCount, " +
                  "SUM(oi.Quantity) AS TotalTicketsSold, SUM(oi.TotalPrice) AS EventRevenue " +
                  "FROM Users u " +
                  "INNER JOIN Events e ON u.Id = e.OwnerID " +
                  "INNER JOIN OrderItems oi ON e.EventID = oi.EventID " +
                  "INNER JOIN Orders o ON oi.OrderID = o.OrderID " +
                  "WHERE u.Email = ? AND o.PaymentStatus = 'paid' AND o.OrderStatus != 'cancelled' AND e.IsDeleted = 0 " +
                  "GROUP BY u.Id, u.Username, e.EventID, e.Name, e.StartTime, e.EndTime " +
                  "ORDER BY e.StartTime DESC";
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, ownerEmail);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    OwnerRevenue ownerRevenue = new OwnerRevenue();
                    ownerRevenue.setOwnerId(rs.getInt("OwnerID"));
                    ownerRevenue.setOwnerName(rs.getString("OwnerName"));
                    ownerRevenue.setEventId(rs.getInt("EventID"));
                    ownerRevenue.setEventName(rs.getString("EventName"));
                    if ("monthly".equals(timePeriod)) {
                        ownerRevenue.setRevenuePeriod(rs.getInt("RevenueYear") + "-" + String.format("%02d", rs.getInt("RevenueMonth")));
                    } else if ("yearly".equals(timePeriod)) {
                        ownerRevenue.setRevenuePeriod(String.valueOf(rs.getInt("RevenueYear")));
                    } else {
                        Timestamp startTime = rs.getTimestamp("StartTime");
                        ownerRevenue.setEndTime(startTime != null ? new Date(startTime.getTime()) : null);
                        Timestamp endTime = rs.getTimestamp("EndTime");
                        ownerRevenue.setEndTime(endTime != null ? new Date(endTime.getTime()) : null);
                    }
                    ownerRevenue.setOrderCount(rs.getInt("OrderCount"));
                    ownerRevenue.setTotalTicketsSold(rs.getInt("TotalTicketsSold"));
                    ownerRevenue.setEventRevenue(rs.getDouble("EventRevenue"));
                    ownerRevenues.add(ownerRevenue);
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error fetching owner revenue details by email for time period: " + timePeriod, e);
        }
        return ownerRevenues;
    }

    public UserDTO getOwnerProfileByEmail(String ownerEmail) {
        UserDTO user = null;
        String sql = "SELECT Id, Username, Email, Avatar,  Role FROM Users WHERE Email = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, ownerEmail);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    user = new UserDTO();
                    user.setId(rs.getInt("Id"));
                    user.setName(rs.getString("Username"));
                    user.setEmail(rs.getString("Email"));
                    user.setRole(rs.getString("Role"));
                    user.setAvatar(rs.getString("Avatar"));
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error fetching owner profile by email: " + ownerEmail, e);
        }
        return user;
    }

    public Map<String, Double> getOwnerRevenueChartData(String ownerEmail, String timePeriod) {
        Map<String, Double> revenueData = new HashMap<>();
        String sql;
        if ("monthly".equals(timePeriod)) {
            sql = "SELECT DATEPART(YEAR, o.CreatedAt) AS RevenueYear, DATEPART(MONTH, o.CreatedAt) AS RevenueMonth, " +
                  "SUM(oi.TotalPrice) AS TotalRevenue " +
                  "FROM Users u " +
                  "INNER JOIN Events e ON u.Id = e.OwnerID " +
                  "INNER JOIN OrderItems oi ON e.EventID = oi.EventID " +
                  "INNER JOIN Orders o ON oi.OrderID = o.OrderID " +
                  "WHERE u.Email = ? AND o.PaymentStatus = 'paid' AND o.OrderStatus != 'cancelled' AND e.IsDeleted = 0 " +
                  "GROUP BY DATEPART(YEAR, o.CreatedAt), DATEPART(MONTH, o.CreatedAt) " +
                  "ORDER BY DATEPART(YEAR, o.CreatedAt) DESC, DATEPART(MONTH, o.CreatedAt) DESC";
        } else if ("yearly".equals(timePeriod)) {
            sql = "SELECT DATEPART(YEAR, o.CreatedAt) AS RevenueYear, " +
                  "SUM(oi.TotalPrice) AS TotalRevenue " +
                  "FROM Users u " +
                  "INNER JOIN Events e ON u.Id = e.OwnerID " +
                  "INNER JOIN OrderItems oi ON e.EventID = oi.EventID " +
                  "INNER JOIN Orders o ON oi.OrderID = o.OrderID " +
                  "WHERE u.Email = ? AND o.PaymentStatus = 'paid' AND o.OrderStatus != 'cancelled' AND e.IsDeleted = 0 " +
                  "GROUP BY DATEPART(YEAR, o.CreatedAt) " +
                  "ORDER BY DATEPART(YEAR, o.CreatedAt) DESC";
        } else {
            sql = "SELECT CONVERT(date, o.CreatedAt) AS RevenueDate, " +
                  "SUM(oi.TotalPrice) AS TotalRevenue " +
                  "FROM Users u " +
                  "INNER JOIN Events e ON u.Id = e.OwnerID " +
                  "INNER JOIN OrderItems oi ON e.EventID = oi.EventID " +
                  "INNER JOIN Orders o ON oi.OrderID = o.OrderID " +
                  "WHERE u.Email = ? AND o.PaymentStatus = 'paid' AND o.OrderStatus != 'cancelled' AND e.IsDeleted = 0 " +
                  "GROUP BY CONVERT(date, o.CreatedAt) " +
                  "ORDER BY CONVERT(date, o.CreatedAt) DESC";
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, ownerEmail);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    String period;
                    if ("monthly".equals(timePeriod)) {
                        period = rs.getInt("RevenueYear") + "-" + String.format("%02d", rs.getInt("RevenueMonth"));
                    } else if ("yearly".equals(timePeriod)) {
                        period = String.valueOf(rs.getInt("RevenueYear"));
                    } else {
                        period = rs.getString("RevenueDate");
                    }
                    double revenue = rs.getDouble("TotalRevenue");
                    revenueData.put(period, revenue);
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error fetching owner revenue chart data for email: " + ownerEmail + ", time period: " + timePeriod, e);
        }
        return revenueData;
    }

    public String getHighestRevenueOwnerEmail() {
        String ownerEmail = null;
        String sql = "SELECT TOP 1 u.Email, SUM(oi.TotalPrice) AS TotalRevenue " +
                     "FROM Users u " +
                     "INNER JOIN Events e ON u.Id = e.OwnerID " +
                     "INNER JOIN OrderItems oi ON e.EventID = oi.EventID " +
                     "INNER JOIN Orders o ON oi.OrderID = o.OrderID " +
                     "WHERE o.PaymentStatus = 'paid' AND o.OrderStatus != 'cancelled' AND e.IsDeleted = 0 " +
                     "GROUP BY u.Email " +
                     "ORDER BY TotalRevenue DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                ownerEmail = rs.getString("Email");
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error fetching highest revenue owner", e);
        }
        return ownerEmail;
    }
}