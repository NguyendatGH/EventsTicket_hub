package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import models.SupportItem;
import models.SupportAttachment;
import service.SupportService;
import dto.UserDTO;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.ArrayList;
import java.util.Collection;
import java.io.File;

@WebServlet("/support")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1 MB
    maxFileSize = 1024 * 1024 * 10,  // 10 MB
    maxRequestSize = 1024 * 1024 * 50 // 50 MB
)
public class SupportCenterServlet extends HttpServlet {
    private SupportService supportService;

    @Override
    public void init() throws ServletException {
        supportService = new SupportService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        UserDTO user = (UserDTO) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Luôn lấy danh sách yêu cầu hỗ trợ của người dùng
        List<SupportItem> userRequests = supportService.getSupportRequestsByUserEmail(user.getEmail());
        request.setAttribute("supportRequests", userRequests);
        
        request.getRequestDispatcher("/supportCenter/supportCenter.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        UserDTO user = (UserDTO) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        
        if ("submit-request".equals(action)) {
            submitSupportRequest(request, response, user);
        } else if ("download".equals(action)) {
            downloadAttachment(request, response, user);
        } else {
            response.sendRedirect(request.getContextPath() + "/support");
        }
    }

    private void submitSupportRequest(HttpServletRequest request, HttpServletResponse response, UserDTO user) 
            throws ServletException, IOException {
        
        System.out.println("Debug: Starting submitSupportRequest...");
        
        String subject = request.getParameter("subject");
        String content = request.getParameter("content");
        String category = request.getParameter("category");
        String priority = request.getParameter("priority");

        System.out.println("Debug: Form data - Subject: " + subject + ", Category: " + category + ", Priority: " + priority);

        // Validate input
        if (subject == null || subject.trim().isEmpty() || 
            content == null || content.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng điền đầy đủ thông tin!");
            // Lấy lại danh sách yêu cầu khi có lỗi
            List<SupportItem> userRequests = supportService.getSupportRequestsByUserEmail(user.getEmail());
            request.setAttribute("supportRequests", userRequests);
            request.getRequestDispatcher("/supportCenter/supportCenter.jsp").forward(request, response);
            return;
        }

        // Create support request
        SupportItem supportItem = new SupportItem(user.getId(), user.getEmail(), subject, content);
        supportItem.setCategory(category != null ? category : "GENERAL");
        supportItem.setPriority(priority != null ? priority : "MEDIUM");
        supportItem.setToEmail("admin@masterticket.com");

        // Handle file uploads
        List<SupportAttachment> attachments = new ArrayList<>();
        String uploadPath = getServletContext().getRealPath("/uploads/support_attachments");
        
        System.out.println("Debug: Processing file uploads...");
        System.out.println("Debug: Upload path: " + uploadPath);
        
        // Kiểm tra và tạo thư mục upload
        File uploadDir = new File(uploadPath);
        System.out.println("Debug: Upload directory exists: " + uploadDir.exists());
        System.out.println("Debug: Upload directory can write: " + uploadDir.canWrite());
        
        if (!uploadDir.exists()) {
            boolean created = uploadDir.mkdirs();
            System.out.println("Debug: Directory created: " + created);
            if (!created) {
                System.err.println("Debug: Failed to create upload directory!");
            }
        }
        
        try {
            System.out.println("Debug: Getting parts from request...");
            Collection<Part> parts = request.getParts();
            System.out.println("Debug: Total parts found: " + parts.size());
            
            // Debug tất cả các parts
            for (Part part : parts) {
                System.out.println("Debug: Part name: " + part.getName() + ", size: " + part.getSize());
                if (part.getSubmittedFileName() != null) {
                    System.out.println("Debug: Part filename: " + part.getSubmittedFileName());
                }
            }
            
            for (Part filePart : parts) {
                System.out.println("Debug: Processing part: " + filePart.getName() + ", size: " + filePart.getSize());
                if ("attachments".equals(filePart.getName()) && filePart.getSize() > 0) {
                    System.out.println("Debug: Processing attachment: " + filePart.getSubmittedFileName());
                    SupportAttachment attachment = supportService.saveUploadedFile(filePart, uploadPath);
                    if (attachment != null) {
                        attachments.add(attachment);
                        System.out.println("Debug: Attachment saved: " + attachment.getOriginalFileName());
                    } else {
                        System.out.println("Debug: Failed to save attachment");
                    }
                }
            }
            System.out.println("Debug: Total attachments processed: " + attachments.size());
        } catch (Exception e) {
            System.err.println("Error processing file uploads: " + e.getMessage());
            e.printStackTrace();
        }

        boolean success;
        if (!attachments.isEmpty()) {
            success = supportService.createSupportRequestWithAttachments(supportItem, attachments);
            System.out.println("Debug: Creating support request with " + attachments.size() + " attachments");
        } else {
            success = supportService.createSupportRequest(supportItem);
            System.out.println("Debug: Creating support request without attachments");
        }

        System.out.println("Debug: Support request creation success: " + success);
        System.out.println("Debug: Support ID: " + supportItem.getSupportId());

        if (success) {
            request.setAttribute("success", "Yêu cầu hỗ trợ đã được gửi thành công! Chúng tôi sẽ phản hồi sớm nhất có thể.");
        } else {
            request.setAttribute("error", "Có lỗi xảy ra khi gửi yêu cầu hỗ trợ. Vui lòng thử lại!");
        }

        // Lấy lại danh sách yêu cầu sau khi gửi
        List<SupportItem> userRequests = supportService.getSupportRequestsByUserEmail(user.getEmail());
        request.setAttribute("supportRequests", userRequests);
        
        request.getRequestDispatcher("/supportCenter/supportCenter.jsp").forward(request, response);
    }

    private void downloadAttachment(HttpServletRequest request, HttpServletResponse response, UserDTO user) 
            throws ServletException, IOException {
        
        String fileIdStr = request.getParameter("fileId");
        if (fileIdStr == null || fileIdStr.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "File ID is required");
            return;
        }

        try {
            int fileId = Integer.parseInt(fileIdStr);
            SupportAttachment attachment = supportService.getAttachmentById(fileId);
            
            if (attachment == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "File not found");
                return;
            }

            // Verify that the user has access to this attachment
            // (attachment belongs to a support request from this user)
            SupportItem supportItem = supportService.getSupportRequestById(attachment.getSupportId());
            if (supportItem == null || !supportItem.getFromEmail().equals(user.getEmail())) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
                return;
            }

            // Set response headers
            response.setContentType(attachment.getFileType());
            response.setHeader("Content-Disposition", "attachment; filename=\"" + attachment.getOriginalFileName() + "\"");
            response.setContentLengthLong(attachment.getFileSize());

            // Stream the file
            Path filePath = Paths.get(attachment.getFilePath());
            try (InputStream in = Files.newInputStream(filePath);
                 OutputStream out = response.getOutputStream()) {
                
                byte[] buffer = new byte[4096];
                int bytesRead;
                while ((bytesRead = in.read(buffer)) != -1) {
                    out.write(buffer, 0, bytesRead);
                }
            }

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid file ID");
        } catch (Exception e) {
            System.err.println("Error downloading attachment: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error downloading file");
        }
    }
}