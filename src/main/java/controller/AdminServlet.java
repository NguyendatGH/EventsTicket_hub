package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.RequestDispatcher;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;
import java.util.logging.Level;

import dao.EventDAO;
import dao.UserDAO;
import models.IssueItem;
import models.User;
import models.Event;

@WebServlet(name = "AdminServlet", urlPatterns = { "/admin-servlet/*" })
public class AdminServlet extends HttpServlet {

    private static final Logger logger = Logger.getLogger(AdminServlet.class.getName());

    private UserManagementServlet userManagementServlet;
    private EventManagementServlet eventManagementServlet;
    private SupportCenterServlet supportCenterServlet;
    private DashboardServlet dashboardServlet;

    @Override
    public void init() throws ServletException {
        super.init();
        userManagementServlet = new UserManagementServlet();
        eventManagementServlet = new EventManagementServlet();
        supportCenterServlet = new SupportCenterServlet();
        dashboardServlet = new DashboardServlet();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        logger.info("Processing admin request for path: " + pathInfo);

        try {
            if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/dashboard")) {
                dashboardServlet.handleRequest(request, response);
            } else if (pathInfo.startsWith("/user-management")) {
                userManagementServlet.handleRequest(request, response);
            } else if (pathInfo.startsWith("/event-management")) {
                eventManagementServlet.handleRequest(request, response);
            } else if (pathInfo.startsWith("/support-center")) {
                supportCenterServlet.handleRequest(request, response);
            } else {
                logger.warning("Unknown path: " + pathInfo);
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Invalid admin path");
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error processing admin request", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Unable to process request: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        logger.info("POST request received, delegating to doGet");
        doGet(request, response);
    }
    @Override
    public String getServletInfo() {
        return "Admin Servlet for managing admin dashboard, user accounts, events, and support center";
    }
}