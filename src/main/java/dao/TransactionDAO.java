package dao;

import java.sql.Connection;
import java.util.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

import context.DBConnection;
import models.Transaction;

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
}
