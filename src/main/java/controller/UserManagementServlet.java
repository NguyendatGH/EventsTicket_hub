package controller;

import java.io.IOException;
import java.util.List;
import java.util.logging.Logger;

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
    public UserManagementServlet(){
        this.userDAO = new UserDAO();
        this.forwardUtils = new ForwardJspUtils();
    }

    @Override
    public void handleRequest(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException{
        List<User> allUsers = userDAO.getAllUserAccount();
        logAllUsers(allUsers);
        request.setAttribute("users", allUsers);
        forwardUtils.toJsp(request, response, USER_MANAGEMENT_JSP);
    }
     private void logAllUsers(List<User> users) {
        if (users != null && !users.isEmpty()) {
            logger.info("Found " + users.size() + " accounts");
            for (User u : users) {
                logger.fine("User: " + u.toString());
            }
        }
    }

}
