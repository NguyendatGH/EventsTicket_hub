package controller;

import Interfaces.IUserDAO;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import models.User;
import dto.UserDTO;
import utils.GoogleUtils;
import utils.HashUtil;

import com.google.api.services.oauth2.model.Userinfo;
import dao.EventDAO;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Random;
import models.Event;

@WebServlet("/login-google")
public class GoogleLoginServlet extends HttpServlet {

    private final IUserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String code = request.getParameter("code");
        System.out.println("DEBUG: Received authorization code: " + (code != null ? "Yes" : "No"));

        if (code == null || code.isEmpty()) {
            System.out.println("DEBUG: No code received, redirecting to Google OAuth");
            response.sendRedirect(GoogleUtils.getRedirectUrl());
            return;
        }

        try {
            System.out.println("DEBUG: Getting user info from Google...");
            Userinfo googleUser = GoogleUtils.getUserInfo(code);
            
            if (googleUser == null) {
                throw new Exception("Không thể lấy thông tin người dùng từ Google");
            }
            
            String email = googleUser.getEmail();
            String googleId = googleUser.getId();
            String name = googleUser.getName();
            String avatarUrl = googleUser.getPicture();
            
            System.out.println("DEBUG: Google user info - Email: " + email + ", Name: " + name + ", GoogleId: " + googleId);

            // Tìm user bằng DTO
            UserDTO userDTO = userDAO.getUserDTOByEmail(email);

            if (userDTO == null) {
                System.out.println("DEBUG: Creating new user from Google account");
                // Người dùng mới - tạo User object để insert
                User newUser = new User();
                newUser.setEmail(email);
                newUser.setGoogleId(googleId);
                newUser.setName(name != null && !name.isEmpty() ? name : email);
                newUser.setAvatar(avatarUrl);
                newUser.setRole("customer");
                newUser.setCreatedAt(LocalDateTime.now());
                newUser.setUpdatedAt(LocalDateTime.now());
                newUser.setIsLocked(false);

                // Tạo mật khẩu ngẫu nhiên
                String randomPassword = generateRandomPassword(12);
                newUser.setPasswordHash(HashUtil.sha256(randomPassword));

                boolean insertSuccess = userDAO.insertUserFromGoogleDTO(newUser);
                System.out.println("DEBUG: Insert new user success: " + insertSuccess);
                
                if (!insertSuccess) {
                    throw new Exception("Không thể thêm người dùng Google mới vào cơ sở dữ liệu.");
                }
                
                // Lấy lại userDTO từ DB sau khi tạo
                userDTO = userDAO.getUserDTOByEmail(email);
                if (userDTO == null) {
                    throw new Exception("Không thể lấy lại thông tin người dùng sau khi tạo mới");
                }
                System.out.println("DEBUG: Retrieved new user DTO with ID: " + userDTO.getId());

            } else {
                System.out.println("DEBUG: Updating existing user - ID: " + userDTO.getId());
                // Người dùng đã tồn tại - cập nhật thông tin
                boolean needUpdate = false;
                String updatedName = userDTO.getName();
                String updatedAvatar = userDTO.getAvatar();
                String updatedGoogleId = userDTO.getRole(); // Assuming we need to check GoogleId
                
                // Cập nhật tên nếu cần
                if ((userDTO.getName() == null || userDTO.getName().isEmpty() || userDTO.getName().equals(userDTO.getEmail())) 
                    && name != null && !name.isEmpty()) {
                    updatedName = name;
                    needUpdate = true;
                }
                
                // Cập nhật avatar nếu chưa có
                if (userDTO.getAvatar() == null || userDTO.getAvatar().isEmpty()) {
                    updatedAvatar = avatarUrl;
                    needUpdate = true;
                }
                
                // Luôn cập nhật LastLoginAt
                needUpdate = true;
                
                if (needUpdate) {
                    boolean updateSuccess = userDAO.updateUserInfoForGoogle(userDTO.getId(), updatedName, updatedAvatar, googleId);
                    System.out.println("DEBUG: Update existing user success: " + updateSuccess);
                    
                    if (updateSuccess) {
                        // Cập nhật lại userDTO với thông tin mới
                        userDTO.setName(updatedName);
                        userDTO.setAvatar(updatedAvatar);
                        userDTO.setLastLoginAt(LocalDateTime.now());
                    } else {
                        System.err.println("Cảnh báo: Không thể cập nhật thông tin người dùng " + userDTO.getEmail());
                    }
                }
            }

            // Kiểm tra trạng thái khóa
            if (userDTO.getIsLocked()) {
                System.out.println("DEBUG: User account is locked");
                response.sendRedirect("authentication/login.jsp?error=Tài khoản của bạn đã bị khóa. Vui lòng liên hệ quản trị viên.");
                return;
            }
            
            System.out.println("DEBUG: Setting user session and redirecting to home page");
            
            // Thiết lập session với UserDTO
            HttpSession session = request.getSession();
            session.setAttribute("user", userDTO); // Lưu UserDTO vào session
            session.setAttribute("userDTO", userDTO); // Thêm cả userDTO attribute nếu cần

            // Chuẩn bị dữ liệu cho trang chủ
            EventDAO eventDAO = new EventDAO();
            List<Event> events = eventDAO.getAllApprovedEvents();
            request.setAttribute("events", events);

            // Chuyển hướng về homePage
            System.out.println("DEBUG: Forwarding to homePage.jsp");
            request.getRequestDispatcher("pages/homePage.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("Lỗi trong quá trình đăng nhập Google: " + e.getMessage());
            
            // Ghi chi tiết lỗi
            String errorMsg = "Đăng nhập Google thất bại";
            if (e.getMessage() != null) {
                errorMsg += ": " + e.getMessage();
            }
            
            response.sendRedirect("authentication/login.jsp?error=" + java.net.URLEncoder.encode(errorMsg, "UTF-8"));
        }
    }

    private String generateRandomPassword(int length) {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()-_=+";
        StringBuilder sb = new StringBuilder();
        Random random = new Random();
        for (int i = 0; i < length; i++) {
            sb.append(chars.charAt(random.nextInt(chars.length())));
        }
        return sb.toString();
    }
}