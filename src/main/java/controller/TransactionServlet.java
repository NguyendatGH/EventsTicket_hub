package controller;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.Transaction;
import service.TransactionService;
import utils.ForwardJspUtils;

public class TransactionServlet implements AdminSubServlet {
    private static final Logger logger = Logger.getLogger(TransactionServlet.class.getName());
    private static final String TRANSACTION_JSP = "managerPage/TransactionList.jsp";
    private TransactionService transactionService;
    private ForwardJspUtils forwardUtils;

    public TransactionServlet() {
        this.transactionService = new TransactionService();
        this.forwardUtils = new ForwardJspUtils();
    }

    @Override
    public void handleRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Fetch transaction list and daily revenue
            List<Transaction> transactions = transactionService.getTransactionList();
            Map<String, Double> dailyRevenue = transactionService.getDailyRevenue();

            // Set transaction and daily revenue attributes
            request.setAttribute("transactions", transactions);
            request.setAttribute("dailyRevenue", dailyRevenue);

            // Forward to TransactionList.jsp
            forwardUtils.toJsp(request, response, TRANSACTION_JSP);

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error loading transaction data", e);
            throw new ServletException("Failed to load transaction data", e);
        }
    }
}