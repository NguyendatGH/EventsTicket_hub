package controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.Event;
import models.Refund;
import models.TopEventOwner;
import service.EventService;
import service.UserService;
import utils.ForwardJspUtils;
import dao.RefundDAO;

public class DashboardServlet implements AdminSubServlet {

    private static final Logger logger = Logger.getLogger(DashboardServlet.class.getName());
    private static final String ADMIN_DASHBOARD_JSP = "managerPage/AdminDashboard.jsp";
    private UserService userService;
    private EventService eventService;
    private ForwardJspUtils forwardUtils;
    private RefundDAO refundDAO;

    public DashboardServlet() {
        this.userService = new UserService();
        this.eventService = new EventService();
        this.forwardUtils = new ForwardJspUtils();
        this.refundDAO = new RefundDAO();
    }

    @Override
    public void handleRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int totalUsers = userService.getNumOfUser();
            int eventsThisMonth = eventService.getAllEventCreatedThisMonthNums();
            BigDecimal totalRevenue = eventService.getTotalRevenue();
            List<TopEventOwner> topEventOrganizers = userService.getTopEventOwner(10);
            List<Event> topEvents = eventService.getListTopEvents();
            List<Event> pendingEvents = eventService.getPendingEvents();
            
            // Safely get pending refunds
            List<Refund> pendingRefunds = null;
            int pendingRefundsCount = 0;
            try {
                pendingRefunds = refundDAO.getRefundsByStatus("pending");
                pendingRefundsCount = pendingRefunds != null ? pendingRefunds.size() : 0;
            } catch (Exception e) {
                logger.log(Level.WARNING, "Error loading pending refunds", e);
                pendingRefunds = new ArrayList<>();
                pendingRefundsCount = 0;
            }

            logPendingEvents(pendingEvents);
            // Set request attributes
            request.setAttribute("totalUser", totalUsers);
            request.setAttribute("eventThisMonth", eventsThisMonth);
            request.setAttribute("totalRevenue", totalRevenue);
            request.setAttribute("topEventOrganizers", topEventOrganizers);
            request.setAttribute("events", topEvents);
            request.setAttribute("pendingList", pendingEvents);
            request.setAttribute("pendingRefundsCount", pendingRefundsCount);

            forwardUtils.toJsp(request, response, ADMIN_DASHBOARD_JSP);

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error loading dashboard data", e);
            throw new ServletException("Failed to load dashboard data", e);
        }
    }

    private void logPendingEvents(List<Event> pendingEvents) {
        if (pendingEvents != null && !pendingEvents.isEmpty()) {
            logger.info("Found " + pendingEvents.size() + "pending events");
        } else {
            logger.info("no pending events found");
        }
    }

}
