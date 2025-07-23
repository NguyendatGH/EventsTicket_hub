/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import Interfaces.IUserDAO;
import dao.UserDAO;
import dto.UserDTO;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.sql.Date;
import java.time.LocalDateTime;
import java.util.UUID;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import service.UserService;

@WebServlet("/updateProfile")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 1, // 1 MB
        maxFileSize = 1024 * 1024 * 10, // 10 MB
        maxRequestSize = 1024 * 1024 * 15 // 15 MB
)
public class UpdateProfileServlet extends HttpServlet {
    private static final UserService UserService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("userPage/updateProfile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        UserDTO user = (UserDTO) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        try {
            String gender = request.getParameter("gender");
            String birthdayStr = request.getParameter("birthday");
            String phoneNumber = request.getParameter("phoneNumber");
            String address = request.getParameter("address");

            user.setGender(gender);

            if (birthdayStr != null && !birthdayStr.isEmpty()) {
                user.setBirthday(Date.valueOf(birthdayStr));
            } else {
                user.setBirthday(null);
            }
            user.setPhoneNumber(phoneNumber);
            user.setAddress(address);
            updateAvatarIfProvided(request, user);

            boolean updated = UserService.updateProfile(user);
            if (updated) {
                session.setAttribute("user", user);
                request.setAttribute("success", "Cập nhật thành công.");
            } else {
                request.setAttribute("error", "Cập nhật thất bại.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi khi cập nhật hồ sơ: " + e.getMessage());
        }

        request.getRequestDispatcher("userPage/updateProfile.jsp").forward(request, response);
    }

    private void updateAvatarIfProvided(HttpServletRequest request, UserDTO user) throws IOException, ServletException {
        Part filePart = request.getPart("avatar");

        if (filePart == null || filePart.getSize() == 0) {
            return; // No file uploaded, keep existing avatar
        }

        String submittedFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        String fileExtension = submittedFileName.substring(submittedFileName.lastIndexOf('.'));
        String uniqueFileName = UUID.randomUUID().toString() + fileExtension;

        String uploadPath = request.getServletContext().getAttribute("upload.path") + "/user_avatar/";
        File uploadDir = new File(uploadPath);

        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        String filePath = uploadPath + uniqueFileName;
        System.out.println("file path: " +filePath);    
        filePart.write(filePath);

        // Store only the filename in the database (as per sample SQL)
        user.setAvatar(uniqueFileName);
    }
}