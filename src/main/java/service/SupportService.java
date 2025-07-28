package service;

import dao.SupportDAO;
import dao.SupportAttachmentDAO;
import models.SupportItem;
import models.SupportAttachment;
import java.util.List;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

public class SupportService {
    private final SupportDAO supportDAO;

    public SupportService() {
        this.supportDAO = new SupportDAO();
    }

    public boolean createSupportRequest(SupportItem supportItem) {
        return supportDAO.createSupportRequest(supportItem);
    }

    public boolean createSupportRequestWithAttachments(SupportItem supportItem, List<SupportAttachment> attachments) {
        boolean success = supportDAO.createSupportRequest(supportItem);
        if (success && attachments != null && !attachments.isEmpty()) {
            SupportAttachmentDAO attachmentDAO = new SupportAttachmentDAO();
            for (SupportAttachment attachment : attachments) {
                attachment.setSupportId(supportItem.getSupportId());
                attachmentDAO.createAttachment(attachment);
            }
        }
        return success;
    }

    public List<SupportItem> getAllSupportRequests() {
        return supportDAO.getAllSupportRequests();
    }

    public List<SupportItem> getSupportRequestsByStatus(String status) {
        return supportDAO.getSupportRequestsByStatus(status);
    }

    public SupportItem getSupportRequestById(int supportId) {
        return supportDAO.getSupportRequestById(supportId);
    }

    public boolean updateSupportRequest(SupportItem supportItem) {
        return supportDAO.updateSupportRequest(supportItem);
    }

    public List<SupportItem> getSupportRequestsByUserEmail(String userEmail) {
        return supportDAO.getSupportRequestsByUserEmail(userEmail);
    }

    public int getPendingSupportRequestsCount() {
        return supportDAO.getPendingSupportRequestsCount();
    }

    public boolean replyToSupportRequest(int supportId, String adminResponse, String assignedAdmin) {
        SupportItem supportItem = supportDAO.getSupportRequestById(supportId);
        if (supportItem != null) {
            supportItem.setAdminResponse(adminResponse);
            supportItem.setAssignedAdmin(assignedAdmin);
            supportItem.markAsReplied();
            return supportDAO.updateSupportRequest(supportItem);
        }
        return false;
    }

    public boolean resolveSupportRequest(int supportId, String adminResponse, String assignedAdmin) {
        SupportItem supportItem = supportDAO.getSupportRequestById(supportId);
        if (supportItem != null) {
            supportItem.setAdminResponse(adminResponse);
            supportItem.setAssignedAdmin(assignedAdmin);
            supportItem.markAsResolved();
            return supportDAO.updateSupportRequest(supportItem);
        }
        return false;
    }

    public boolean closeSupportRequest(int supportId, String adminResponse, String assignedAdmin) {
        SupportItem supportItem = supportDAO.getSupportRequestById(supportId);
        if (supportItem != null) {
            supportItem.setAdminResponse(adminResponse);
            supportItem.setAssignedAdmin(assignedAdmin);
            supportItem.markAsClosed();
            return supportDAO.updateSupportRequest(supportItem);
        }
        return false;
    }

    public SupportAttachment saveUploadedFile(jakarta.servlet.http.Part filePart, String uploadPath) throws IOException {
        System.out.println("Debug: saveUploadedFile called with filePart: " + (filePart != null ? filePart.getSubmittedFileName() : "null"));
        
        if (filePart == null || filePart.getSize() == 0) {
            System.out.println("Debug: FilePart is null or empty");
            return null;
        }

        // Create upload directory if it doesn't exist
        File uploadDir = new File(uploadPath);
        System.out.println("Debug: Upload directory: " + uploadPath);
        System.out.println("Debug: Directory exists: " + uploadDir.exists());
        
        if (!uploadDir.exists()) {
            boolean created = uploadDir.mkdirs();
            System.out.println("Debug: Directory created: " + created);
        }

        // Generate unique filename
        String originalFileName = filePart.getSubmittedFileName();
        String fileExtension = "";
        if (originalFileName != null && originalFileName.contains(".")) {
            fileExtension = originalFileName.substring(originalFileName.lastIndexOf("."));
        }
        
        String uniqueFileName = UUID.randomUUID().toString() + fileExtension;
        String filePath = uploadPath + File.separator + uniqueFileName;
        
        System.out.println("Debug: Original filename: " + originalFileName);
        System.out.println("Debug: Unique filename: " + uniqueFileName);
        System.out.println("Debug: File path: " + filePath);

        try {
            // Save file
            Path path = Paths.get(filePath);
            Files.copy(filePart.getInputStream(), path, StandardCopyOption.REPLACE_EXISTING);
            System.out.println("Debug: File saved successfully");

            // Create attachment object using constructor that sets dates automatically
            SupportAttachment attachment = new SupportAttachment(0, uniqueFileName, originalFileName, 
                                                              filePath, filePart.getContentType(), filePart.getSize());
            
            System.out.println("Debug: Attachment created with size: " + attachment.getFileSize());
            System.out.println("Debug: Attachment file path: " + attachment.getFilePath());
            System.out.println("Debug: Attachment original name: " + attachment.getOriginalFileName());
            System.out.println("Debug: Attachment file type: " + attachment.getFileType());
            System.out.println("Debug: Attachment upload date: " + attachment.getUploadDate());
            System.out.println("Debug: Attachment upload timestamp: " + attachment.getUploadTimestamp());
            return attachment;
        } catch (Exception e) {
            System.err.println("Debug: Error saving file: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    public SupportAttachment getAttachmentById(int attachmentId) {
        SupportAttachmentDAO attachmentDAO = new SupportAttachmentDAO();
        return attachmentDAO.getAttachmentById(attachmentId);
    }
} 