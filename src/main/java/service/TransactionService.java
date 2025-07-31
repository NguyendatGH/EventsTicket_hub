package service;

import java.util.List;
import java.util.Map;

import dao.TransactionDAO;
import models.Transaction;
import models.OwnerRevenue;
import dto.UserDTO;

public class TransactionService {
    private final TransactionDAO transactionDAO;

    public TransactionService() {
        this.transactionDAO = new TransactionDAO();
    }

    public List<Transaction> getTransactionList() {
        return transactionDAO.getTransactionList();
    }

    public Map<String, Double> getDailyRevenue() {
        return transactionDAO.getDailyRevenue();
    }

    public List<OwnerRevenue> getOwnerRevenueDetailsByEmail(String ownerEmail, String timePeriod) {
        return transactionDAO.getOwnerRevenueDetailsByEmail(ownerEmail, timePeriod);
    }

    public UserDTO getOwnerProfileByEmail(String ownerEmail) {
        return transactionDAO.getOwnerProfileByEmail(ownerEmail);
    }

    public Map<String, Double> getOwnerRevenueChartData(String ownerEmail, String timePeriod) {
        return transactionDAO.getOwnerRevenueChartData(ownerEmail, timePeriod);
    }

    public String getHighestRevenueOwnerEmail() {
        return transactionDAO.getHighestRevenueOwnerEmail();
    }
}