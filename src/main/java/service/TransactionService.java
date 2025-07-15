package service;

import java.util.List;
import java.util.Map;

import dao.TransactionDAO;
import models.Transaction;

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
}
