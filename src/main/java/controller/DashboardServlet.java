package controller;

import java.io.IOException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import dao.EventDAO;
import dao.UserDAO;
import models.Event;

import utils.ForwardJspUtils;

public class DashboardServlet implements AdminSubServlet{

    private static final Logger logger = Logger.getLogger(DashboardServlet.class.getName());
    private static final String ADMIN_DASHBOARD_JSP = "managerPage/AdminDashboard.jsp";
    private UserDAO userDAO;
    private EventDAO eventDAO;
    private ForwardJspUtils forwardUtils;

    public DashboardServlet(){
        this.userDAO = new UserDAO();
        this.eventDAO = new EventDAO();
        this.forwardUtils = new ForwardJspUtils();
    }   

    @Override
     public void handleRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int totalUsers = userDAO.getNumOfUser();
            int eventsThisMonth = eventDAO.getAllEventCreatedThisMonthNums();
            List<Event> topEvents = eventDAO.getListTopEvents();
            List<Event> pendingEvents = eventDAO.getPendingEvents();

            logPendingEvents(pendingEvents);

            // Set request attributes
            request.setAttribute("totalUser", totalUsers);
            request.setAttribute("eventThisMonth", eventsThisMonth);
            request.setAttribute("events", topEvents);
            request.setAttribute("pendingList", pendingEvents);

            forwardUtils.toJsp(request, response, ADMIN_DASHBOARD_JSP);

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error loading dashboard data", e);
            throw new ServletException("Failed to load dashboard data", e);
        }
    }

    private void logPendingEvents(List<Event> pendingEvents) {
        if(pendingEvents != null && !pendingEvents.isEmpty()){
            logger.info("Found " + pendingEvents.size() + "pending events");
        }else{
            logger.info("no pending events found");
        }
    }


}
