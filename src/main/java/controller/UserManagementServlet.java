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

}
