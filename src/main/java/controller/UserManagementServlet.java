package controller;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;

import com.fasterxml.jackson.databind.ObjectMapper;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.User;

import utils.ForwardJspUtils;

public class UserManagementServlet implements AdminSubServlet {
    private static final Logger logger = Logger.getLogger(UserManagementServlet.class.getName());
    private static final String USER_MANAGEMENT_JSP = "managerPage/AdminUserManagement.jsp";

    private UserDAO userDAO;
    private ForwardJspUtils forwardUtils;

    public UserManagementServlet() {
        this.userDAO = new UserDAO();
        this.forwardUtils = new ForwardJspUtils();
    }

    @Override
    public void handleRequest(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        String pathInfo = request.getPathInfo() != null ? request.getPathInfo() : "";

        if (pathInfo.endsWith("/lock-user")) {
           logger.info("hello");
            handleLock(request, response);
            return;
        }

        List<User> allUsers = userDAO.getAllUserAccount();

        logger.info("all users from databases: " + allUsers.size());
        request.setAttribute("users", allUsers);

        Map<String, Integer> roleDistribution = userDAO.getUserRoleDistribution();
        Map<String, Map<String, Integer>> loginDistributionByMonth = new HashMap<>();
        Map<String, Integer> newUsersLogin = new HashMap<>();
        Map<String, Integer> oldUsersLogin = new HashMap<>();
        LocalDateTime threshold = LocalDateTime.now().minusMonths(3);

        for (User user : allUsers) {
            if (user.getLastLoginAt() != null) {
                String monthYear = user.getLastLoginAt().format(DateTimeFormatter.ofPattern("yyyy-MM"));
                if (user.getCreatedAt().isAfter(threshold)) {
                    newUsersLogin.merge(monthYear, 1, Integer::sum);
                } else {
                    oldUsersLogin.merge(monthYear, 1, Integer::sum);
                }
            }
        }
        loginDistributionByMonth.put("new", newUsersLogin);
        loginDistributionByMonth.put("old", oldUsersLogin);

        logger.info("Serialized roleDistribution: " + roleDistribution);
        logger.info("Login Distribution by Month: " + loginDistributionByMonth);

        System.out.println("--------------------------------------------");
        ObjectMapper mapper = new ObjectMapper();
        try {
            String roleDistributionJSON = mapper
                    .writeValueAsString(roleDistribution != null ? roleDistribution : new HashMap<>());
            String loginDistributionByMonthJson = mapper
                    .writeValueAsString(loginDistributionByMonth != null ? loginDistributionByMonth : new HashMap<>());

            logger.info("Serialized roleDistributionJSON: " + roleDistributionJSON);
            logger.info("Serialized loginDistributionByMonthJson: " + loginDistributionByMonthJson);

            request.setAttribute("roleDistributionJson", roleDistributionJSON);
            request.setAttribute("loginDistributionByMonthJson", loginDistributionByMonthJson);
        } catch (Exception e) {
            logger.severe("Error serializing JSON data: " + e.getMessage());
            request.setAttribute("roleDistributionJson", "{}");
            request.setAttribute("loginDistributionByMonthJson", "{}");
        }

        forwardUtils.toJsp(request, response, USER_MANAGEMENT_JSP);
    }

    private void handleLock(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String userIdParam = request.getParameter("userId");
        String actionParam = request.getParameter("action");

        if (userIdParam == null || actionParam == null) {
            request.getSession().setAttribute("message", "Missing user ID or action");
            request.getSession().setAttribute("messageType", "error");
            response.sendRedirect(request.getContextPath() + "/admin-servlet/user-management");
            return;
        }

        try {
            int userId = Integer.parseInt(userIdParam);
            System.out.println("[++++++]user to modify: "+userIdParam);
            boolean success = false;

            if ("lock".equals(actionParam)) {
                success = userDAO.changeUserAccountStatus(userId, 0);
                logger.info("Attempting to lock user ID: " + userId);
            } else if ("unlock".equals(actionParam)) {
                success = userDAO.changeUserAccountStatus(userId, 1);
                logger.info("Attempting to unlock user ID: " + userId);
            }

            if (success) {
                request.getSession().setAttribute("message", "user status updated success");
                request.getSession().setAttribute("messageType", "success");
            } else {
                request.getSession().setAttribute("message", "Failed to update user status");
                request.getSession().setAttribute("messageType", "error");
            }
        } catch (NumberFormatException e) {
            logger.severe("invalid user id: " + userIdParam);
            request.getSession().setAttribute("message", "invalid user id");
            request.getSession().setAttribute("messageType", "error");
        } catch (Exception e) {
            logger.severe("Error updating user status: " + e.getMessage());
            request.getSession().setAttribute("message", "An error occurred while updating user status");
            request.getSession().setAttribute("messageType", "error");
        }

        response.sendRedirect(request.getContextPath() + "/admin-servlet/user-management");
    }
}
