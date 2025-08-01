package controller;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.OwnerRevenue;
import dto.UserDTO;
import service.TransactionService;
import utils.ForwardJspUtils;

public class OwnerRevenueServletManagement implements AdminSubServlet {
    private static final Logger logger = Logger.getLogger(OwnerRevenueServletManagement.class.getName());
    private static final String OWNER_REVENUE_JSP = "managerPage/OwnerRevenue.jsp";
    private TransactionService transactionService;
    private ForwardJspUtils forwardUtils;

    public OwnerRevenueServletManagement() {
        this.transactionService = new TransactionService();
        this.forwardUtils = new ForwardJspUtils();
    }

    @Override
    public void handleRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String ownerEmail = request.getParameter("ownerEmail");
            String timePeriod = request.getParameter("timePeriod");
            timePeriod = (timePeriod == null || timePeriod.trim().isEmpty()) ? "all" : timePeriod;

            if (ownerEmail == null || ownerEmail.trim().isEmpty()) {
                // Default to the owner with the highest revenue
                ownerEmail = transactionService.getHighestRevenueOwnerEmail();
            }

            List<OwnerRevenue> ownerRevenues = transactionService.getOwnerRevenueDetailsByEmail(ownerEmail, timePeriod);
            UserDTO ownerProfile = transactionService.getOwnerProfileByEmail(ownerEmail);
            System.out.println("owner: " +ownerProfile);
            Map<String, Double> revenueData = transactionService.getOwnerRevenueChartData(ownerEmail, timePeriod);
            
            double totalRevenue = ownerRevenues.stream().mapToDouble(OwnerRevenue::getEventRevenue).sum();
            int eventCount = (int) ownerRevenues.stream().map(OwnerRevenue::getEventId).distinct().count();
            int totalTicketsSold = ownerRevenues.stream().mapToInt(OwnerRevenue::getTotalTicketsSold).sum();
            int orderCount = ownerRevenues.stream().mapToInt(OwnerRevenue::getOrderCount).sum();
            boolean ownerNotFound = ownerEmail != null && !ownerEmail.trim().isEmpty() && ownerRevenues.isEmpty() && ownerProfile == null;

            request.setAttribute("ownerRevenues", ownerRevenues);
            request.setAttribute("totalRevenue", totalRevenue);
            request.setAttribute("ownerEmail", ownerEmail);
            request.setAttribute("timePeriod", timePeriod);
            request.setAttribute("ownerProfile", ownerProfile);
            request.setAttribute("revenueData", revenueData);
            request.setAttribute("eventCount", eventCount);
            request.setAttribute("totalTicketsSold", totalTicketsSold);
            request.setAttribute("orderCount", orderCount);
            request.setAttribute("ownerNotFound", ownerNotFound);

            forwardUtils.toJsp(request, response, OWNER_REVENUE_JSP);

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error loading owner revenue data", e);
            throw new ServletException("Failed to load owner revenue data", e);
        }
    }
}