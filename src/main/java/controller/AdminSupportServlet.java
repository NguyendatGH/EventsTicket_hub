package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
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

@WebServlet("/admin/support")
public class AdminSupportServlet extends HttpServlet {
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
        
        if (user == null || !"admin".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        
        if ("view-detail".equals(action)) {
            viewSupportDetail(request, response);
        } else if ("download".equals(action)) {
            downloadAttachment(request, response, user);
        } else if ("view".equals(action)) {
            viewAttachment(request, response, user);
        } else {
            // Hiển thị danh sách tất cả yêu cầu hỗ trợ
            showSupportList(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        UserDTO user = (UserDTO) session.getAttribute("user");
        
        if (user == null || !"admin".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        
        if ("reply".equals(action)) {
            replyToSupport(request, response, user);
        } else if ("resolve".equals(action)) {
            resolveSupport(request, response, user);
        } else if ("close".equals(action)) {
            closeSupport(request, response, user);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/support");
        }
    }

    private void showSupportList(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<SupportItem> allRequests = supportService.getAllSupportRequests();
        List<SupportItem> pendingRequests = supportService.getSupportRequestsByStatus("PENDING");
        
        request.setAttribute("allRequests", allRequests);
        request.setAttribute("pendingRequests", pendingRequests);
        
        request.getRequestDispatcher("/supportCenter/supportCenter_admin.jsp").forward(request, response);
    }

    private void viewSupportDetail(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String supportIdStr = request.getParameter("id");
        if (supportIdStr == null || supportIdStr.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Support ID is required");
            return;
        }

        try {
            int supportId = Integer.parseInt(supportIdStr);
            SupportItem supportItem = supportService.getSupportRequestById(supportId);
            
            if (supportItem == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Support request not found");
                return;
            }

            request.setAttribute("supportItem", supportItem);
            request.getRequestDispatcher("/supportCenter/supportCenter_admin_detail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid support ID");
        }
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

    private void replyToSupport(HttpServletRequest request, HttpServletResponse response, UserDTO user) 
            throws ServletException, IOException {
        
        String supportIdStr = request.getParameter("supportId");
        String adminResponse = request.getParameter("adminResponse");
        
        if (supportIdStr == null || adminResponse == null || adminResponse.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng điền đầy đủ thông tin!");
            response.sendRedirect(request.getContextPath() + "/admin/support?action=view-detail&id=" + supportIdStr);
            return;
        }

        try {
            int supportId = Integer.parseInt(supportIdStr);
            boolean success = supportService.replyToSupportRequest(supportId, adminResponse, user.getEmail());
            
            if (success) {
                request.setAttribute("success", "Đã phản hồi yêu cầu hỗ trợ thành công!");
            } else {
                request.setAttribute("error", "Có lỗi xảy ra khi phản hồi yêu cầu hỗ trợ!");
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID yêu cầu hỗ trợ không hợp lệ!");
        }

        response.sendRedirect(request.getContextPath() + "/admin/support?action=view-detail&id=" + supportIdStr);
    }

    private void resolveSupport(HttpServletRequest request, HttpServletResponse response, UserDTO user) 
            throws ServletException, IOException {
        
        String supportIdStr = request.getParameter("supportId");
        String adminResponse = request.getParameter("adminResponse");
        
        if (supportIdStr == null || adminResponse == null || adminResponse.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng điền đầy đủ thông tin!");
            response.sendRedirect(request.getContextPath() + "/admin/support?action=view-detail&id=" + supportIdStr);
            return;
        }

        try {
            int supportId = Integer.parseInt(supportIdStr);
            boolean success = supportService.resolveSupportRequest(supportId, adminResponse, user.getEmail());
            
            if (success) {
                request.setAttribute("success", "Đã giải quyết yêu cầu hỗ trợ thành công!");
            } else {
                request.setAttribute("error", "Có lỗi xảy ra khi giải quyết yêu cầu hỗ trợ!");
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID yêu cầu hỗ trợ không hợp lệ!");
        }

        response.sendRedirect(request.getContextPath() + "/admin/support?action=view-detail&id=" + supportIdStr);
    }

    private void closeSupport(HttpServletRequest request, HttpServletResponse response, UserDTO user) 
            throws ServletException, IOException {
        
        String supportIdStr = request.getParameter("supportId");
        String adminResponse = request.getParameter("adminResponse");
        
        if (supportIdStr == null || adminResponse == null || adminResponse.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng điền đầy đủ thông tin!");
            response.sendRedirect(request.getContextPath() + "/admin/support?action=view-detail&id=" + supportIdStr);
            return;
        }

        try {
            int supportId = Integer.parseInt(supportIdStr);
            boolean success = supportService.closeSupportRequest(supportId, adminResponse, user.getEmail());
            
            if (success) {
                request.setAttribute("success", "Đã đóng yêu cầu hỗ trợ thành công!");
            } else {
                request.setAttribute("error", "Có lỗi xảy ra khi đóng yêu cầu hỗ trợ!");
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID yêu cầu hỗ trợ không hợp lệ!");
        }

        response.sendRedirect(request.getContextPath() + "/admin/support?action=view-detail&id=" + supportIdStr);
    }
} 