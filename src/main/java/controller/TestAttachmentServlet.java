package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.SupportItem;
import models.SupportAttachment;
import service.SupportService;
import dao.SupportAttachmentDAO;

import java.io.IOException;
import java.sql.Date;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/test-attachment")
public class TestAttachmentServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            // Tạo test support request
            SupportService supportService = new SupportService();
            SupportItem testItem = new SupportItem("test@example.com", "Test Subject", "Test Content");
            testItem.setCategory("GENERAL");
            testItem.setPriority("MEDIUM");
            testItem.setToEmail("admin@masterticket.com");
            
            boolean success = supportService.createSupportRequest(testItem);
            
            if (success) {
                // Tạo test attachments
                SupportAttachmentDAO attachmentDAO = new SupportAttachmentDAO();
                
                SupportAttachment attachment1 = new SupportAttachment(
                    testItem.getSupportId(),
                    "test-file-1.jpg",
                    "test-image.jpg",
                    "/uploads/support_attachments/test-file-1.jpg",
                    "image/jpeg",
                    1024 * 1024 // 1MB
                );
                
                SupportAttachment attachment2 = new SupportAttachment(
                    testItem.getSupportId(),
                    "test-file-2.pdf",
                    "test-document.pdf",
                    "/uploads/support_attachments/test-file-2.pdf",
                    "application/pdf",
                    2048 * 1024 // 2MB
                );
                
                attachmentDAO.createAttachment(attachment1);
                attachmentDAO.createAttachment(attachment2);
                
                response.getWriter().println("Test data created successfully!");
                response.getWriter().println("Support ID: " + testItem.getSupportId());
                response.getWriter().println("Attachments: 2");
            } else {
                response.getWriter().println("Failed to create test support request");
            }
            
        } catch (Exception e) {
            response.getWriter().println("Error: " + e.getMessage());
            e.printStackTrace(response.getWriter());
        }
    }
} 