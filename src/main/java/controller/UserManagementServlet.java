package controller;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.fasterxml.jackson.databind.ObjectMapper;

import dto.UserDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import service.UserService;
import utils.ForwardJspUtils;

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,    // 1MB
    maxFileSize = 1024 * 1024 * 10,     // 10MB
    maxRequestSize = 1024 * 1024 * 50   // 50MB
)
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

    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");
    ObjectMapper mapper = new ObjectMapper();
    Map<String, Object> responseData = new HashMap<>();

    if (userIdParam == null || actionParam == null) {
        responseData.put("success", false);
        responseData.put("message", "Missing user ID or action");
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        mapper.writeValue(response.getWriter(), responseData);
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
            responseData.put("success", true);
            responseData.put("message", "Trạng thái tài khoản đã được cập nhật!");
            response.setStatus(HttpServletResponse.SC_OK);
        } else {
            responseData.put("success", false);
            responseData.put("message", "Lỗi khi cập nhật trạng thái");
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    } catch (NumberFormatException e) {
        logger.severe("invalid user id: " + userIdParam);
        responseData.put("success", false);
        responseData.put("message", "ID không hợp lệ");
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
    } catch (Exception e) {
        logger.severe("Error updating user status: " + e.getMessage());
        responseData.put("success", false);
        responseData.put("message", "An error occurred while updating user status");
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
    }

    mapper.writeValue(response.getWriter(), responseData);
}

    private void handleEditInfo(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        // Debug logging
        logger.info("Entering handleEditInfo - Method: " + request.getMethod());
        logger.info("Content-Type: " + request.getContentType());

        // Handle both regular and multipart requests
        HttpServletRequest processedRequest = request;
        if (request.getContentType() != null &&
                request.getContentType().startsWith("multipart/form-data")) {
            try {
                processedRequest = new MultipartRequestWrapper(request);
                logger.info("Processed as multipart request");
            } catch (Exception e) {
                logger.log(Level.SEVERE, "Error processing multipart request", e);
                request.getSession().setAttribute("message", "Error processing request");
                request.getSession().setAttribute("messageType", "error");
                response.sendRedirect(request.getContextPath() + "/admin-servlet/user-management");
                return;
            }
        }

        // Get user ID from both possible sources
        String userIdParam = processedRequest.getParameter("userId");
        logger.info("User ID parameter: " + userIdParam);

        if (userIdParam == null || userIdParam.isEmpty()) {
            logger.warning("Missing user ID parameter");
            request.getSession().setAttribute("message", "Missing user ID");
            request.getSession().setAttribute("messageType", "error");
            response.sendRedirect(request.getContextPath() + "/admin-servlet/user-management");
            return;
        }

        try {
            int userId = Integer.parseInt(userIdParam);
            logger.info("Processing user ID: " + userId);

            if ("GET".equalsIgnoreCase(processedRequest.getMethod())) {
                // Handle GET request - show edit form
                UserDTO user = userService.findDTOUserID(userId);
                if (user == null) {
                    logger.warning("User not found with ID: " + userId);
                    request.getSession().setAttribute("message", "User not found");
                    request.getSession().setAttribute("messageType", "error");
                    response.sendRedirect(request.getContextPath() + "/admin-servlet/user-management");
                    return;
                }
                request.setAttribute("user", user);
                request.getRequestDispatcher("/managerPage/updateUserProfileAdmin.jsp").forward(request, response);
            } else if ("POST".equalsIgnoreCase(processedRequest.getMethod())) {
                // Handle POST request - update user
                UserDTO userToUpdate = userService.findDTOUserID(userId);
                if (userToUpdate == null) {
                    logger.warning("User not found for update: " + userId);
                    request.getSession().setAttribute("message", "User not found");
                    request.getSession().setAttribute("messageType", "error");
                    response.sendRedirect(request.getContextPath() + "/admin-servlet/user-management");
                    return;
                }

                // Process file upload if present
                if (processedRequest instanceof MultipartRequestWrapper) {
                    Part filePart = request.getPart("avatarFile");
                    if (filePart != null && filePart.getSize() > 0) {
                        // Validate file type
                        if (!filePart.getContentType().startsWith("image/")) {
                            logger.warning("Invalid file type uploaded");
                            request.getSession().setAttribute("message", "Only image files are allowed");
                            request.getSession().setAttribute("messageType", "error");
                            response.sendRedirect(request.getContextPath()
                                    + "/admin-servlet/user-management/edit-user?userId=" + userId);
                            return;
                        }

                        // Generate unique filename
                        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                        String fileExtension = fileName.substring(fileName.lastIndexOf("."));
                        String uniqueFileName = "user_" + userId + "_" + System.currentTimeMillis() + fileExtension;

                        // Save file
                        String uploadPath = (String) request.getServletContext().getAttribute("upload.path");
                        File uploadDir = new File(uploadPath);
                        if (!uploadDir.exists()) {
                            uploadDir.mkdirs();
                        }

                        String filePath = uploadPath + File.separator + uniqueFileName;
                        try (InputStream fileContent = filePart.getInputStream()) {
                            Files.copy(fileContent, Paths.get(filePath), StandardCopyOption.REPLACE_EXISTING);
                        }

                        // Update avatar path
                        userToUpdate.setAvatar("/uploads/" + uniqueFileName);
                        logger.info("Saved new avatar: " + filePath);
                    }
                }

                // Update other user fields
                userToUpdate.setName(processedRequest.getParameter("name"));
                userToUpdate.setEmail(processedRequest.getParameter("email"));
                userToUpdate.setGender(processedRequest.getParameter("gender"));
                userToUpdate.setPhoneNumber(processedRequest.getParameter("phoneNumber"));
                userToUpdate.setAddress(processedRequest.getParameter("address"));

                // Handle birthday
                String birthdayStr = processedRequest.getParameter("birthday");
                if (birthdayStr != null && !birthdayStr.isEmpty()) {
                    try {
                        userToUpdate.setBirthday(java.sql.Date.valueOf(birthdayStr));
                    } catch (IllegalArgumentException e) {
                        logger.warning("Invalid birthday format: " + birthdayStr);
                        // Continue without updating birthday
                    }
                }

                // Save changes
                boolean success = userService.updateProfile(userToUpdate);
                if (success) {
                    logger.info("Successfully updated user: " + userId);
                    request.getSession().setAttribute("message", "User updated successfully");
                    request.getSession().setAttribute("messageType", "success");
                } else {
                    logger.warning("Failed to update user: " + userId);
                    request.getSession().setAttribute("message", "Failed to update user");
                    request.getSession().setAttribute("messageType", "error");
                }

                response.sendRedirect(request.getContextPath() + "/admin-servlet/user-management");
            }
        } catch (NumberFormatException e) {
            logger.log(Level.SEVERE, "Invalid user ID format: " + userIdParam, e);
            request.getSession().setAttribute("message", "Invalid user ID");
            request.getSession().setAttribute("messageType", "error");
            response.sendRedirect(request.getContextPath() + "/admin-servlet/user-management");
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error in handleEditInfo", e);
            request.getSession().setAttribute("message", "An error occurred");
            request.getSession().setAttribute("messageType", "error");
            response.sendRedirect(request.getContextPath() + "/admin-servlet/user-management");
        }
    }

}
// private void handleEditInfo(HttpServletRequest request, HttpServletResponse
// response)
// throws IOException, ServletException {
// String userIdParam = request.getParameter("userId");

// if (userIdParam == null) {
// request.getSession().setAttribute("message", "Missing user ID");
// request.getSession().setAttribute("messageType", "error");
// response.sendRedirect(request.getContextPath() +
// "/admin-servlet/user-management");
// return;
// }

// try {
// int userId = Integer.parseInt(userIdParam);
// logger.info("User to edit: " + userIdParam);

// if ("GET".equalsIgnoreCase(request.getMethod())) {
// // Display edit form
// UserDTO user = userService.findDTOUserID(userId);
// if (user == null) {
// request.getSession().setAttribute("message", "User not found");
// request.getSession().setAttribute("messageType", "error");
// response.sendRedirect(request.getContextPath() +
// "/admin-servlet/user-management");
// return;
// }
// request.setAttribute("user", user);
// forwardUtils.toJsp(request, response, UPDATE_USER_PROFILE_JSP);
// } else if ("POST".equalsIgnoreCase(request.getMethod())) {
// // Process form submission
// String name = request.getParameter("name");
// String email = request.getParameter("email");
// String gender = request.getParameter("gender");
// String birthdayStr = request.getParameter("birthday");
// String phoneNumber = request.getParameter("phoneNumber");
// String address = request.getParameter("address");
// String avatar = request.getParameter("avatar");

// UserDTO userDTO = new UserDTO();
// userDTO.setId(userId);
// userDTO.setName(name);
// userDTO.setEmail(email);
// userDTO.setGender(gender);
// userDTO.setPhoneNumber(phoneNumber);
// userDTO.setAddress(address);
// userDTO.setAvatar(avatar);

// if (birthdayStr != null && !birthdayStr.isEmpty()) {
// try {
// userDTO.setBirthday(java.sql.Date.valueOf(birthdayStr));
// } catch (IllegalArgumentException e) {
// logger.severe("Invalid birthday format: " + birthdayStr);
// request.getSession().setAttribute("message", "Ngày sinh không hợp lệ");
// request.getSession().setAttribute("messageType", "error");
// response.sendRedirect(request.getContextPath() +
// "/admin-servlet/user-management");
// return;
// }
// }

// // Check if email is taken by another user
// UserDTO existingUser = userService.getUserByEmail(email);
// if (existingUser != null && existingUser.getId() != userId) {
// request.getSession().setAttribute("message", "Email đã được sử dụng bởi người
// dùng khác");
// request.getSession().setAttribute("messageType", "error");
// response.sendRedirect(
// request.getContextPath() + "/admin-servlet/user-management/edit-user?userId="
// + userId);
// return;
// }
// System.out.println("user infor to update: " + userDTO);
// boolean success = userService.updateProfile(userDTO);
// if (success) {
// request.getSession().setAttribute("message", "Thông tin tài khoản đã được cập
// nhật!");
// request.getSession().setAttribute("messageType", "success");
// } else {
// request.getSession().setAttribute("message", "Lỗi khi cập nhật thông tin tài
// khoản");
// request.getSession().setAttribute("messageType", "error");
// }
// response.sendRedirect(request.getContextPath() +
// "/admin-servlet/user-management");
// }
// } catch (NumberFormatException e) {
// logger.severe("Invalid user ID: " + userIdParam);
// request.getSession().setAttribute("message", "ID không hợp lệ");
// request.getSession().setAttribute("messageType", "error");
// response.sendRedirect(request.getContextPath() +
// "/admin-servlet/user-management");
// } catch (Exception e) {
// logger.severe("Error updating user profile: " + e.getMessage());
// request.getSession().setAttribute("message", "An error occurred while
// updating user profile");
// request.getSession().setAttribute("messageType", "error");
// response.sendRedirect(request.getContextPath() +
// "/admin-servlet/user-management");
// }
// }
// }
