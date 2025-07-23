package controller;

import Interfaces.IUserDAO;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import models.User;
import utils.GoogleUtils;
import utils.HashUtil; // Sử dụng HashUtil của bạn

import com.google.api.services.oauth2.model.Userinfo;
import dao.EventDAO;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Random; // Import lớp Random
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

            User user = userDAO.getUserByEmail(email);

            if (user == null) {
                System.out.println("DEBUG: Creating new user from Google account");
                // Người dùng mới
                user = new User();
                user.setEmail(email);
                user.setGoogleId(googleId);
                user.setName(name != null && !name.isEmpty() ? name : email);
                user.setAvatar(avatarUrl);
                user.setRole("customer");
                user.setCreatedAt(LocalDateTime.now());
                user.setUpdatedAt(LocalDateTime.now());
                user.setIsLocked(false);

                // Tạo mật khẩu ngẫu nhiên
                String randomPassword = generateRandomPassword(12);
                user.setPasswordHash(HashUtil.sha256(randomPassword));

                boolean insertSuccess = userDAO.insertUserFromGoogle(user);
                System.out.println("DEBUG: Insert new user success: " + insertSuccess);
                
                if (!insertSuccess) {
                    throw new Exception("Không thể thêm người dùng Google mới vào cơ sở dữ liệu.");
                }
                
                // Lấy lại user từ DB để có ID
                user = userDAO.getUserByEmail(email);
                if (user == null) {
                    throw new Exception("Không thể lấy lại thông tin người dùng sau khi tạo mới");
                }
                System.out.println("DEBUG: Retrieved new user with ID: " + user.getId());

            } else {
                System.out.println("DEBUG: Updating existing user - ID: " + user.getId());
                // Người dùng đã tồn tại
                boolean needUpdate = false;
                
                // Cập nhật LastLoginAt
                user.setLastLoginAt(LocalDateTime.now());
                needUpdate = true;
                
                // Cập nhật GoogleId nếu chưa có
                if (user.getGoogleId() == null || user.getGoogleId().isEmpty()) {
                    user.setGoogleId(googleId);
                    needUpdate = true;
                }
                
                // Cập nhật tên nếu cần
                if ((user.getName() == null || user.getName().isEmpty() || user.getName().equals(user.getEmail())) 
                    && name != null && !name.isEmpty()) {
                    user.setName(name);
                    needUpdate = true;
                }
                
                // Cập nhật avatar nếu chưa có
                if (user.getAvatar() == null || user.getAvatar().isEmpty()) {
                    user.setAvatar(avatarUrl);
                    needUpdate = true;
                }
                
                if (needUpdate) {
                    boolean updateSuccess = userDAO.updateUserInfo(user);
                    System.out.println("DEBUG: Update existing user success: " + updateSuccess);
                    if (!updateSuccess) {
                        System.err.println("Cảnh báo: Không thể cập nhật thông tin người dùng " + user.getEmail());
                    }
                }
            }

            if (user.getIsLocked()) {
                System.out.println("DEBUG: User account is locked");
                response.sendRedirect("authentication/login.jsp?error=Tài khoản của bạn đã bị khóa. Vui lòng liên hệ quản trị viên.");
                return;
            }
            
            System.out.println("DEBUG: Setting user session and redirecting to home page");
            
            // Thiết lập session
            HttpSession session = request.getSession();
            session.setAttribute("user", user);

            // Chuẩn bị dữ liệu cho trang chủ
            EventDAO eventDAO = new EventDAO();
            List<Event> events = eventDAO.getAllApprovedEvents();
            request.setAttribute("events", events);

            // Chuyển hướng về trang chủ
            request.getRequestDispatcher("userPage/userHomePage.jsp").forward(request, response);

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