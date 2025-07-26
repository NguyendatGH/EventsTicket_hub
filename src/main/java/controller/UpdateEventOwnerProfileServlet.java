// controller/UpdateEventOwnerProfileServlet.java
package controller;

import Interfaces.IUserDAO; // Still using IUserDAO since updateProfile takes a User object
import dao.UserDAO; // Still using UserDAO as it contains the updateProfile for the shared 'Users' table
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

import models.User;
import dto.UserDTO;

@WebServlet("/updateEventOwnerProfile")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 1, // 1 MB
        maxFileSize = 1024 * 1024 * 10, // 10 MB
        maxRequestSize = 1024 * 1024 * 15 // 15 MB
)
public class UpdateEventOwnerProfileServlet extends HttpServlet {

    private final IUserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Ensure the user is logged in and has the "event_owner" role before displaying the page
        HttpSession session = request.getSession(false);
        Object userObj = session.getAttribute("user");
        User user = null;
        IUserDAO userDAO = new UserDAO();
        if (userObj instanceof User) {
            user = (User) userObj;
        } else if (userObj instanceof dto.UserDTO) {
            String email = ((dto.UserDTO) userObj).getEmail();
            user = userDAO.getUserByEmail(email);
            session.setAttribute("user", user); 
        }
        if (user == null || !"event_owner".equals(user.getRole())) {
            response.sendRedirect("login");
            return;
        }
        // Forward đúng đường dẫn
        request.getRequestDispatcher("eventOwner/updateEventOwnerProfile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Object userObj = session.getAttribute("user");
        User user = null;
        IUserDAO userDAO = new UserDAO();
        if (userObj instanceof User) {
            user = (User) userObj;
        } else if (userObj instanceof dto.UserDTO) {
            String email = ((dto.UserDTO) userObj).getEmail();
            user = userDAO.getUserByEmail(email);
            session.setAttribute("user", user);
        }
        if (user == null || !"event_owner".equals(user.getRole())) {
            response.sendRedirect("login");
            return;
        }
        try {
            // Lấy thông tin từ form
            String name = request.getParameter("name");
            String gender = request.getParameter("gender");
            String birthdayStr = request.getParameter("birthday");
            String phoneNumber = request.getParameter("phoneNumber");
            String address = request.getParameter("address");
            
            // Validate required fields
            if (name == null || name.trim().isEmpty()) {
                request.setAttribute("error", "Tên không được để trống!");
                request.getRequestDispatcher("eventOwner/updateEventOwnerProfile.jsp").forward(request, response);
                return;
            }
            
            if (phoneNumber == null || phoneNumber.trim().isEmpty()) {
                request.setAttribute("error", "Số điện thoại không được để trống!");
                request.getRequestDispatcher("eventOwner/updateEventOwnerProfile.jsp").forward(request, response);
                return;
            }
            
            if (address == null || address.trim().isEmpty()) {
                request.setAttribute("error", "Địa chỉ không được để trống!");
                request.getRequestDispatcher("eventOwner/updateEventOwnerProfile.jsp").forward(request, response);
                return;
            }
            
            // Cập nhật thông tin user
            user.setName(name.trim());
            user.setGender(gender);
            if (birthdayStr != null && !birthdayStr.isEmpty()) {
                user.setBirthday(java.sql.Date.valueOf(birthdayStr));
            } else {
                user.setBirthday(null);
            }
            user.setPhoneNumber(phoneNumber.trim());
            user.setAddress(address.trim());
            user.setUpdatedAt(java.time.LocalDateTime.now());
            
            // Cập nhật avatar nếu có
            updateAvatarIfProvided(request, user);
            
            // Lưu vào database
            boolean updated = userDAO.updateProfile(user);
            if (updated) {
                // Cập nhật session với thông tin mới
                session.setAttribute("user", user);
                session.setAttribute("userName", user.getName());
                session.setAttribute("userEmail", user.getEmail());
                
                request.setAttribute("success", "Cập nhật thông tin cá nhân thành công!");
            } else {
                request.setAttribute("error", "Cập nhật thông tin cá nhân thất bại. Vui lòng thử lại.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi khi cập nhật thông tin cá nhân: " + e.getMessage());
        }
        request.getRequestDispatcher("eventOwner/updateEventOwnerProfile.jsp").forward(request, response);
    }

    private void updateAvatarIfProvided(HttpServletRequest request, User user) throws IOException, ServletException {
        Part filePart = request.getPart("avatar");

        if (filePart == null || filePart.getSize() == 0) {
            return;
        }

        String submittedFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        if (submittedFileName == null || submittedFileName.isEmpty()) {
            return;
        }

        String fileExtension = "";
        int dotIndex = submittedFileName.lastIndexOf('.');
        if (dotIndex > 0 && dotIndex < submittedFileName.length() - 1) {
            fileExtension = submittedFileName.substring(dotIndex);
        }
        String uniqueFileName = UUID.randomUUID().toString() + fileExtension;

        String uploadPath = "D:/uploads/avatars/";

        File uploadDir = new File(uploadPath);

        if (!uploadDir.exists()) {
            boolean created = uploadDir.mkdirs();
            if (!created) {
                String errorMessage = "ERROR: Failed to create upload directory: " + uploadPath
                        + ". Please check server permissions and disk space.";
                System.err.println(errorMessage);
                throw new IOException(errorMessage);
            }
        }

        String filePath = uploadPath + uniqueFileName;
        try {
            filePart.write(filePath);
            user.setAvatar(uniqueFileName);
        } catch (IOException e) {
            System.err.println("ERROR: Failed to write avatar file to disk at " + filePath + ": " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }
}