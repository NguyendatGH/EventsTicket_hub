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

@WebServlet("/support-owner")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1 MB
    maxFileSize = 1024 * 1024 * 10,  // 10 MB
    maxRequestSize = 1024 * 1024 * 50 // 50 MB
)
public class SupportOwnerServlet extends HttpServlet {
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
        
        String action = request.getParameter("action");
        
        if ("download".equals(action)) {
            downloadAttachment(request, response, user);
        } else if ("view".equals(action)) {
            viewAttachment(request, response, user);
        } else {
            // Load all support requests by owner email
            List<SupportItem> ownerRequests = supportService.getSupportRequestsByUserEmail(user.getEmail());
            request.setAttribute("supportRequests", ownerRequests);
            request.getRequestDispatcher("/supportCenter/supportCenter_owner.jsp").forward(request, response);
        }
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
            response.sendRedirect(request.getContextPath() + "/support-owner");
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
            doGet(request, response);
            return;
        }

        // Create support item
        SupportItem supportItem = new SupportItem(user.getId(), user.getEmail(), subject, content);
        supportItem.setCategory(category != null ? category : "GENERAL");
        supportItem.setPriority(priority != null ? priority : "MEDIUM");
        supportItem.setToEmail("admin@masterticket.com");

        // Handle file attachments
        List<SupportAttachment> attachments = new ArrayList<>();
        try {
            Collection<Part> fileParts = request.getParts();
            String uploadPath = getServletContext().getRealPath("/uploads/support_attachments");
            
            for (Part filePart : fileParts) {
                if (filePart != null && filePart.getSize() > 0 && "attachments".equals(filePart.getName())) {
                    System.out.println("Debug: Processing file: " + filePart.getSubmittedFileName());
                    
                    SupportAttachment attachment = supportService.saveUploadedFile(filePart, uploadPath);
                    if (attachment != null) {
                        attachments.add(attachment);
                        System.out.println("Debug: File saved successfully: " + attachment.getOriginalFileName());
                    }
                }
            }
        } catch (Exception e) {
            System.err.println("Debug: Error processing attachments: " + e.getMessage());
            e.printStackTrace();
        }

        // Create support request with attachments
        boolean success = supportService.createSupportRequestWithAttachments(supportItem, attachments);
        
        if (success) {
            request.setAttribute("success", "Yêu cầu hỗ trợ đã được gửi thành công! Chúng tôi sẽ phản hồi sớm nhất có thể.");
        } else {
            request.setAttribute("error", "Có lỗi xảy ra khi gửi yêu cầu hỗ trợ. Vui lòng thử lại!");
        }
        
        doGet(request, response);
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

            // Set response headers for download
            response.setContentType(attachment.getFileType());
            
            // Handle filename encoding for special characters
            String fileName = attachment.getOriginalFileName();
            String encodedFileName = java.net.URLEncoder.encode(fileName, "UTF-8").replaceAll("\\+", "%20");
            response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"; filename*=UTF-8''" + encodedFileName);
            
            response.setContentLengthLong(attachment.getFileSize());
            response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
            response.setHeader("Pragma", "no-cache");
            response.setHeader("Expires", "0");
            response.setHeader("X-Content-Type-Options", "nosniff");

            // Stream the file
            java.nio.file.Path filePath = java.nio.file.Paths.get(attachment.getFilePath());
            try (java.io.InputStream in = java.nio.file.Files.newInputStream(filePath);
                 java.io.OutputStream out = response.getOutputStream()) {
                
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

    private void viewAttachment(HttpServletRequest request, HttpServletResponse response, UserDTO user) 
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

            // Check if file is viewable in browser
            String contentType = attachment.getFileType();
            boolean isViewable = contentType.startsWith("text/") || 
                                contentType.startsWith("image/") || 
                                contentType.equals("application/pdf") ||
                                contentType.equals("application/json") ||
                                contentType.equals("application/xml");

            if (isViewable) {
                // Display in browser
                response.setContentType(contentType);
                response.setHeader("Content-Disposition", "inline; filename=\"" + attachment.getOriginalFileName() + "\"");
            } else {
                // Force download for non-viewable files
                response.setContentType(contentType);
                response.setHeader("Content-Disposition", "attachment; filename=\"" + attachment.getOriginalFileName() + "\"");
            }
            
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
            System.err.println("Error viewing attachment: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error viewing file");
        }
    }
} 