package service;

import dao.SupportDAO;
import models.SupportItem;
import java.util.List;

public class SupportService {
    private final SupportDAO supportDAO;

    public SupportService() {
        this.supportDAO = new SupportDAO();
    }

    public boolean createSupportRequest(SupportItem supportItem) {
        return supportDAO.createSupportRequest(supportItem);
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
} 