/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import Interfaces.IUserDAO;
import dao.UserDAO;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.sql.Date;
import java.time.LocalDateTime;
import java.util.UUID; // Import UUID để tạo tên file duy nhất

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import models.User;

@WebServlet("/updateProfile")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 1, // 1 MB
        maxFileSize = 1024 * 1024 * 10, // 10 MB
        maxRequestSize = 1024 * 1024 * 15 // 15 MB
)
public class UpdateProfileServlet extends HttpServlet {

    private final IUserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("userPage/updateProfile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        try {
            // --- Cập nhật thông tin cơ bản ---
            String gender = request.getParameter("gender");
            String birthdayStr = request.getParameter("birthday");
            String phoneNumber = request.getParameter("phoneNumber");
            String address = request.getParameter("address");

            user.setGender(gender);
            // Kiểm tra và chuyển đổi ngày sinh
            if (birthdayStr != null && !birthdayStr.isEmpty()) {
                user.setBirthday(Date.valueOf(birthdayStr));
            } else {
                user.setBirthday(null); // Hoặc giữ giá trị cũ nếu không muốn cập nhật
            }
            user.setPhoneNumber(phoneNumber);
            user.setAddress(address);
            user.setUpdatedAt(LocalDateTime.now());

            // --- Xử lý upload và cập nhật avatar ---
            updateAvatarIfProvided(request, user);

            boolean updated = userDAO.updateProfile(user);
            if (updated) {
                session.setAttribute("user", user); // Cập nhật session với thông tin user mới
                request.setAttribute("success", "Cập nhật thành công.");
            } else {
                request.setAttribute("error", "Cập nhật thất bại.");
            }
        } catch (Exception e) {
            // In stack trace để debug chi tiết lỗi
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi khi cập nhật hồ sơ: " + e.getMessage());
        }

        request.getRequestDispatcher("userPage/updateProfile.jsp").forward(request, response);
    }

    /**
     * Xử lý upload avatar nếu người dùng có chọn file mới. Sẽ tạo tên file duy
     * nhất và lưu vào thư mục uploads/avatars/ trên ổ D. Cập nhật đường dẫn
     * avatar trong đối tượng User.
     */
    private void updateAvatarIfProvided(HttpServletRequest request, User user) throws IOException, ServletException {
        // Lấy Part của file có tên "avatar"
        Part filePart = request.getPart("avatar");

        // Debug: Kiểm tra xem filePart có nhận được file không
        System.out.println("DEBUG: filePart is null? " + (filePart == null));
        if (filePart == null) {
            System.out.println("DEBUG: No file part found for 'avatar'. This might mean the form enctype is incorrect or no file was selected.");
            return; // Không có file được gửi
        }

        // Debug: Kiểm tra kích thước file
        System.out.println("DEBUG: filePart size: " + filePart.getSize() + " bytes.");
        if (filePart.getSize() == 0) {
            System.out.println("DEBUG: filePart size is 0. No file selected or empty file.");
            return; // Không có file được chọn hoặc file rỗng
        }

        // Lấy tên file gốc từ client
        String submittedFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        System.out.println("DEBUG: Submitted file name: " + submittedFileName);

        if (submittedFileName == null || submittedFileName.isEmpty()) {
            System.out.println("DEBUG: Submitted file name is null or empty.");
            return; // Không có tên file hợp lệ
        }

        // Tạo tên file duy nhất để tránh trùng lặp
        String fileExtension = "";
        int dotIndex = submittedFileName.lastIndexOf('.');
        if (dotIndex > 0 && dotIndex < submittedFileName.length() - 1) {
            fileExtension = submittedFileName.substring(dotIndex); // Lấy phần mở rộng (ví dụ: .png, .jpg)
        }
        String uniqueFileName = UUID.randomUUID().toString() + fileExtension; // Tên file duy nhất

        // Lấy đường dẫn thực tế trên server
        // THAY ĐỔI ĐỂ LƯU VÀO Ổ D
        String uploadPath = "D:/uploads/avatars/"; // Đường dẫn cố định trên ổ D
        System.out.println("DEBUG: Calculated upload path: " + uploadPath);

        File uploadDir = new File(uploadPath);
        // Tạo thư mục nếu nó chưa tồn tại
        if (!uploadDir.exists()) {
            System.out.println("DEBUG: Upload directory does not exist. Attempting to create: " + uploadPath);
            boolean created = uploadDir.mkdirs();
            System.out.println("DEBUG: Directory created successfully? " + created);
            if (!created) {
                String errorMessage = "ERROR: Failed to create upload directory: " + uploadPath + ". Please check server permissions and disk space.";
                System.err.println(errorMessage);
                // Ném ngoại lệ để thông báo lỗi rõ ràng hơn cho người dùng
                throw new IOException(errorMessage);
            }
        } else {
            System.out.println("DEBUG: Upload directory already exists: " + uploadPath);
        }

        // Đường dẫn đầy đủ của file trên server
        String filePath = uploadPath + uniqueFileName;
        System.out.println("DEBUG: Full file path to save: " + filePath);

        try {
            // Ghi file vào server
            filePart.write(filePath);
            System.out.println("DEBUG: File successfully written to: " + filePath);

            // Cập nhật đường dẫn avatar trong đối tượng User
            // Lưu đường dẫn tuyệt đối để có thể truy cập sau này
            user.setAvatar(filePath); // Lưu đường dẫn đầy đủ (ví dụ: D:/uploads/avatars/abc.png)
            System.out.println("DEBUG: User avatar path set to: " + user.getAvatar());

        } catch (IOException e) {
            System.err.println("ERROR: Failed to write file to disk at " + filePath + ": " + e.getMessage());
            e.printStackTrace();
            // Ném lại ngoại lệ để được bắt ở phương thức doPost và hiển thị lỗi cho người dùng
            throw e;
        }
    }
}
