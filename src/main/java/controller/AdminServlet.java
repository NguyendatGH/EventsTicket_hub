package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.RequestDispatcher;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;
import java.util.logging.Level;

import dao.EventDAO;
import dao.UserDAO;
import models.IssueItem;
import models.User;
import models.Event;

@WebServlet(name = "admin-servlet", urlPatterns = { "/admin-servlet" })
public class AdminServlet extends HttpServlet {

    private static final Logger logger = Logger.getLogger(AdminServlet.class.getName());

    // Constants
    private static final String ADMIN_DASHBOARD_JSP = "managerPage/AdminDashboard.jsp";
    private static final String USER_MANAGEMENT_JSP = "managerPage/AdminUserManagement.jsp";
    private static final String EVENT_MANAGEMENT_JSP = "managerPage/AdminEventManagement.jsp";
    private static final String EVENT_OPTIONS_JSP = "managerPage/EventOptions.jsp";
    private static final String SUPPORT_CENTER_JSP = "supportCenter/supportCenter_admin.jsp";

    private static final String ACTION_ADMIN_DASHBOARD = "admindashboard";
    private static final String ACTION_MANAGE_USER = "manageuseraccount";
    private static final String ACTION_MANAGE_EVENTS = "manageevents";
    private static final String ACTION_VIEW_EVENT_DETAIL = "vieweventdetail";
    private static final String ACTION_SUPPORT_CENTER = "supportcenter";

    private UserDAO userDAO;
    private EventDAO eventDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        this.userDAO = new UserDAO();
        this.eventDAO = new EventDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = getActionParameter(request);
        logger.info("Processing admin action: " + action);

        try {
            String targetJsp = processAction(action, request);
            forwardToJsp(request, response, targetJsp);

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error processing admin request", e);
            handleError(response, e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        logger.info("POST request received, delegating to doGet");
        doGet(request, response);
    }

    private String getActionParameter(HttpServletRequest request) {
        String action = request.getParameter("action");

        if (action == null || action.trim().isEmpty()) {
            action = ACTION_ADMIN_DASHBOARD;
        }

        return action.toLowerCase().trim();
    }

    // handle action - navigate btw web
    private String processAction(String action, HttpServletRequest request) {
        switch (action) {
            case ACTION_ADMIN_DASHBOARD:
                return handleAdminDashboard(request);

            case ACTION_MANAGE_USER:
                return handleUserManagement(request);

            case ACTION_MANAGE_EVENTS:
                return handleEventManagement(request);

            case ACTION_VIEW_EVENT_DETAIL:
                return handleEventDetail(request);

            case ACTION_SUPPORT_CENTER:
                return handleSupportCenter(request);

            default:
                logger.warning("Unknown action: " + action + ", defaulting to dashboard");
                return handleAdminDashboard(request);
        }
    }

    private String handleAdminDashboard(HttpServletRequest request) {
        try {
            int totalUsers = userDAO.getNumOfUser();
            int eventsThisMonth = eventDAO.getAllEventCreatedThisMonthNums();
            List<Event> topEvents = eventDAO.getListTopEvents();
            List<Event> pendingEvents = eventDAO.getPendingEvents();

            logPendingEvents(pendingEvents);

            // Set request attributes
            setDashboardAttributes(request, totalUsers, eventsThisMonth, topEvents, pendingEvents);

            return ADMIN_DASHBOARD_JSP;

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error loading dashboard data", e);
            throw new RuntimeException("Failed to load dashboard data", e);
        }
    }

    private String handleUserManagement(HttpServletRequest request) {
        List<User> allUsers = userDAO.getAllUserAccount();
        logAllUser(allUsers);
        setUserManagementPageAttribute(request, allUsers);
        return USER_MANAGEMENT_JSP;
    }

    private String handleEventManagement(HttpServletRequest request) {

        return EVENT_MANAGEMENT_JSP;
    }

    private String handleEventDetail(HttpServletRequest request) {
        return EVENT_OPTIONS_JSP;
    }

    private String handleSupportCenter(HttpServletRequest request) {
        try {
            List<IssueItem> issueList = createMockIssueList();
            logIssueItems(issueList);

            request.setAttribute("issueList", issueList);

            return SUPPORT_CENTER_JSP;

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error loading support center data", e);
            throw new RuntimeException("Failed to load support center data", e);
        }
    }

    private void setDashboardAttributes(HttpServletRequest request, int totalUsers,
            int eventsThisMonth, List<Event> topEvents, List<Event> pendingEvents) {

        request.setAttribute("totalUser", totalUsers);
        request.setAttribute("eventThisMonth", eventsThisMonth);
        request.setAttribute("events", topEvents);
        request.setAttribute("pendingList", pendingEvents);
    }

    private List<IssueItem> createMockIssueList() {
        List<IssueItem> issueList = new ArrayList<>();

        return issueList;
    }

    private void logPendingEvents(List<Event> pendingEvents) {
        if (pendingEvents != null && !pendingEvents.isEmpty()) {
            logger.info("Found " + pendingEvents.size() + " pending events");
            for (Event event : pendingEvents) {
                logger.fine("Pending event: " + event.toString());
            }
        } else {
            logger.info("No pending events found");
        }
    }

    private void logIssueItems(List<IssueItem> issueList) {
        if (issueList != null && !issueList.isEmpty()) {
            logger.info("Found " + issueList.size() + " issue items");
            for (IssueItem item : issueList) {
                logger.fine("Issue item: " + item.toString());
            }
        }
    }

    private void logAllUser(List<User> users) {
        if (users != null && !users.isEmpty()) {
            logger.info("Found " + users.size() + "accounts");
            for (User u : users) {
                logger.fine("user: " + u.toString());
            }
        }
    }

    private void setUserManagementPageAttribute(HttpServletRequest request, List<User> users) {
        request.setAttribute("users", users);
    }

    private void forwardToJsp(HttpServletRequest request, HttpServletResponse response,
            String targetJsp) throws ServletException, IOException {

        RequestDispatcher dispatcher = request.getRequestDispatcher(targetJsp);

        if (dispatcher == null) {
            String errorMsg = "JSP file not found: " + targetJsp;
            logger.severe(errorMsg);
            response.sendError(HttpServletResponse.SC_NOT_FOUND, errorMsg);
            return;
        }

        logger.info("Forwarding to JSP: " + targetJsp);
        dispatcher.forward(request, response);
    }

    private void handleError(HttpServletResponse response, Exception e) throws IOException {
        String errorMessage = "Unable to process request: " +
                (e.getMessage() != null ? e.getMessage() : "Unknown error");

        response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, errorMessage);
    }

    @Override
    public String getServletInfo() {
        return "Admin Servlet for managing admin dashboard, user accounts, events, and support center";
    }
}