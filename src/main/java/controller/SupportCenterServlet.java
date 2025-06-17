package controller;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.IssueItem;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;
import java.util.logging.Level;

public class SupportCenterServlet implements AdminSubServlet {

    private static final Logger logger = Logger.getLogger(SupportCenterServlet.class.getName());
    private static final String SUPPORT_CENTER_JSP = "supportCenter/supportCenter_admin.jsp";

    @Override
    public void handleRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<IssueItem> issueList = createMockIssueList();
            logIssueItems(issueList);
            request.setAttribute("issueList", issueList);
            forwardToJsp(request, response, SUPPORT_CENTER_JSP);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error loading support center data", e);
            throw new ServletException("Failed to load support center data", e);
        }
    }

    private List<IssueItem> createMockIssueList() {
        List<IssueItem> issueList = new ArrayList<>();
        return issueList;
    }

    private void logIssueItems(List<IssueItem> issueList) {
        if (issueList != null && !issueList.isEmpty()) {
            logger.info("Found " + issueList.size() + " issue items");
            for (IssueItem item : issueList) {
                logger.fine("Issue item: " + item.toString());
            }
        }
    }

    private void forwardToJsp(HttpServletRequest request, HttpServletResponse response, String targetJsp)
            throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("/" + targetJsp);
        if (dispatcher == null) {
            String errorMsg = "JSP file not found: " + targetJsp;
            logger.severe(errorMsg);
            response.sendError(HttpServletResponse.SC_NOT_FOUND, errorMsg);
            return;
        }
        logger.info("Forwarding to JSP: " + targetJsp);
        dispatcher.forward(request, response);
    }
}