package controller;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;

import com.fasterxml.jackson.databind.ObjectMapper;

import dto.UserDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import service.UserService;
import utils.ForwardJspUtils;

public class UserManagementServlet implements AdminSubServlet {
    private static final Logger logger = Logger.getLogger(UserManagementServlet.class.getName());
    private static final String USER_MANAGEMENT_JSP = "managerPage/AdminUserManagement.jsp";
    private static final String UPDATE_USER_PROFILE_JSP = "managerPage/updateUserProfileAdmin.jsp";
    private UserService userService;
    private ForwardJspUtils forwardUtils;

    public UserManagementServlet() {
        this.userService = new UserService();
        this.forwardUtils = new ForwardJspUtils();
    }

    @Override
    public void handleRequest(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        String pathInfo = request.getPathInfo() != null ? request.getPathInfo() : "";

        if (pathInfo.endsWith("/lock-user")) {
            handleLock(request, response);
            return;
        }

        if (pathInfo.endsWith("/edit-user")) {
            handleEditInfo(request, response);
            return;
        }

        List<UserDTO> allUsers = userService.getAllUserAccount();

        logger.info("all users from databases: " + allUsers.size());
        request.setAttribute("users", allUsers);

        Map<String, Integer> roleDistribution = userService.getUserRoleDistribution();
        Map<String, Map<String, Integer>> loginDistributionByMonth = new HashMap<>();
        Map<String, Integer> newUsersLogin = new HashMap<>();
        Map<String, Integer> oldUsersLogin = new HashMap<>();
        LocalDateTime threshold = LocalDateTime.now().minusMonths(3);

        for (UserDTO user : allUsers) {
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
            System.out.println("[++++++]user to modify: " + userIdParam);
            boolean success = false;

            if ("lock".equals(actionParam)) {
                success = userService.changeUserAccountStatus(userId, 0);
                logger.info("Attempting to lock user ID: " + userId);
            } else if ("unlock".equals(actionParam)) {
                success = userService.changeUserAccountStatus(userId, 1);
                logger.info("Attempting to unlock user ID: " + userId);
            }

            if (success) {
                request.getSession().setAttribute("message", "Trạng thái tài khoản đã được cập nhật!");
                request.getSession().setAttribute("messageType", "success");
            } else {
                request.getSession().setAttribute("message", "Lỗi khi cập nhật trạng thái");
                request.getSession().setAttribute("messageType", "error");
            }
        } catch (NumberFormatException e) {
            logger.severe("invalid user id: " + userIdParam);
            request.getSession().setAttribute("message", "ID không hơp lệ");
            request.getSession().setAttribute("messageType", "error");
        } catch (Exception e) {
            logger.severe("Error updating user status: " + e.getMessage());
            request.getSession().setAttribute("message", "An error occurred while updating user status");
            request.getSession().setAttribute("messageType", "error");
        }

        response.sendRedirect(request.getContextPath() + "/admin-servlet/user-management");
    }

    private void handleEditInfo(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        String userIdParam = request.getParameter("userId");

        if (userIdParam == null) {
            request.getSession().setAttribute("message", "Missing user ID");
            request.getSession().setAttribute("messageType", "error");
            response.sendRedirect(request.getContextPath() + "/admin-servlet/user-management");
            return;
        }

        try {
            int userId = Integer.parseInt(userIdParam);
            logger.info("User to edit: " + userIdParam);

            if ("GET".equalsIgnoreCase(request.getMethod())) {
                // Display edit form
                UserDTO user = userService.findDTOUserID(userId);
                if (user == null) {
                    request.getSession().setAttribute("message", "User not found");
                    request.getSession().setAttribute("messageType", "error");
                    response.sendRedirect(request.getContextPath() + "/admin-servlet/user-management");
                    return;
                }
                request.setAttribute("user", user);
                forwardUtils.toJsp(request, response, UPDATE_USER_PROFILE_JSP);
            } else if ("POST".equalsIgnoreCase(request.getMethod())) {
                // Process form submission
                String name = request.getParameter("name");
                String email = request.getParameter("email");
                String gender = request.getParameter("gender");
                String birthdayStr = request.getParameter("birthday");
                String phoneNumber = request.getParameter("phoneNumber");
                String address = request.getParameter("address");
                String avatar = request.getParameter("avatar");

                UserDTO userDTO = new UserDTO();
                userDTO.setId(userId);
                userDTO.setName(name);
                userDTO.setEmail(email);
                userDTO.setGender(gender);
                userDTO.setPhoneNumber(phoneNumber);
                userDTO.setAddress(address);
                userDTO.setAvatar(avatar);

                if (birthdayStr != null && !birthdayStr.isEmpty()) {
                    try {
                        userDTO.setBirthday(java.sql.Date.valueOf(birthdayStr));
                    } catch (IllegalArgumentException e) {
                        logger.severe("Invalid birthday format: " + birthdayStr);
                        request.getSession().setAttribute("message", "Ngày sinh không hợp lệ");
                        request.getSession().setAttribute("messageType", "error");
                        response.sendRedirect(request.getContextPath() + "/admin-servlet/user-management");
                        return;
                    }
                }

                // Check if email is taken by another user
                UserDTO existingUser = userService.getUserByEmail(email);
                if (existingUser != null && existingUser.getId() != userId) {
                    request.getSession().setAttribute("message", "Email đã được sử dụng bởi người dùng khác");
                    request.getSession().setAttribute("messageType", "error");
                    response.sendRedirect(
                            request.getContextPath() + "/admin-servlet/user-management/edit-user?userId=" + userId);
                    return;
                }
                System.out.println("user infor to update: " + userDTO);
                boolean success = userService.updateProfile(userDTO);
                if (success) {
                    request.getSession().setAttribute("message", "Thông tin tài khoản đã được cập nhật!");
                    request.getSession().setAttribute("messageType", "success");
                } else {
                    request.getSession().setAttribute("message", "Lỗi khi cập nhật thông tin tài khoản");
                    request.getSession().setAttribute("messageType", "error");
                }
                response.sendRedirect(request.getContextPath() + "/admin-servlet/user-management");
            }
        } catch (NumberFormatException e) {
            logger.severe("Invalid user ID: " + userIdParam);
            request.getSession().setAttribute("message", "ID không hợp lệ");
            request.getSession().setAttribute("messageType", "error");
            response.sendRedirect(request.getContextPath() + "/admin-servlet/user-management");
        } catch (Exception e) {
            logger.severe("Error updating user profile: " + e.getMessage());
            request.getSession().setAttribute("message", "An error occurred while updating user profile");
            request.getSession().setAttribute("messageType", "error");
            response.sendRedirect(request.getContextPath() + "/admin-servlet/user-management");
        }
    }
}
