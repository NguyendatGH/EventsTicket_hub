package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.SupportItem;
import service.SupportService;
import dto.UserDTO;

import java.io.IOException;
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
        
        // Check if user is admin
        if (user == null || !"admin".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        
        if ("view-detail".equals(action)) {
            viewSupportDetail(request, response);
        } else {
            // Show all support requests
            List<SupportItem> allRequests = supportService.getAllSupportRequests();
            List<SupportItem> pendingRequests = supportService.getSupportRequestsByStatus("PENDING");
            int pendingCount = supportService.getPendingSupportRequestsCount();
            
            request.setAttribute("allRequests", allRequests);
            request.setAttribute("pendingRequests", pendingRequests);
            request.setAttribute("pendingCount", pendingCount);
            request.getRequestDispatcher("/supportCenter/supportCenter_admin.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        UserDTO user = (UserDTO) session.getAttribute("user");
        
        // Check if user is admin
        if (user == null || !"admin".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        
        if ("reply".equals(action)) {
            replyToSupportRequest(request, response, user);
        } else if ("resolve".equals(action)) {
            resolveSupportRequest(request, response, user);
        } else if ("close".equals(action)) {
            closeSupportRequest(request, response, user);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/support");
        }
    }

    private void viewSupportDetail(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String supportIdStr = request.getParameter("id");
        if (supportIdStr == null || supportIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/support");
            return;
        }

        try {
            int supportId = Integer.parseInt(supportIdStr);
            SupportItem supportItem = supportService.getSupportRequestById(supportId);
            
            if (supportItem != null) {
                request.setAttribute("supportItem", supportItem);
                request.getRequestDispatcher("/supportCenter/supportCenter_admin_detail.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Không tìm thấy yêu cầu hỗ trợ!");
                response.sendRedirect(request.getContextPath() + "/admin/support");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/support");
        }
    }

    private void replyToSupportRequest(HttpServletRequest request, HttpServletResponse response, UserDTO admin) 
            throws ServletException, IOException {
        
        String supportIdStr = request.getParameter("supportId");
        String adminResponse = request.getParameter("adminResponse");

        if (supportIdStr == null || adminResponse == null || adminResponse.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng điền đầy đủ thông tin!");
            response.sendRedirect(request.getContextPath() + "/admin/support");
            return;
        }

        try {
            int supportId = Integer.parseInt(supportIdStr);
            boolean success = supportService.replyToSupportRequest(supportId, adminResponse, admin.getEmail());
            
            if (success) {
                request.setAttribute("success", "Đã phản hồi yêu cầu hỗ trợ thành công!");
            } else {
                request.setAttribute("error", "Có lỗi xảy ra khi phản hồi!");
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID yêu cầu hỗ trợ không hợp lệ!");
        }

        response.sendRedirect(request.getContextPath() + "/admin/support");
    }

    private void resolveSupportRequest(HttpServletRequest request, HttpServletResponse response, UserDTO admin) 
            throws ServletException, IOException {
        
        String supportIdStr = request.getParameter("supportId");
        String adminResponse = request.getParameter("adminResponse");

        if (supportIdStr == null || adminResponse == null || adminResponse.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng điền đầy đủ thông tin!");
            response.sendRedirect(request.getContextPath() + "/admin/support");
            return;
        }

        try {
            int supportId = Integer.parseInt(supportIdStr);
            boolean success = supportService.resolveSupportRequest(supportId, adminResponse, admin.getEmail());
            
            if (success) {
                request.setAttribute("success", "Đã giải quyết yêu cầu hỗ trợ thành công!");
            } else {
                request.setAttribute("error", "Có lỗi xảy ra khi giải quyết!");
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID yêu cầu hỗ trợ không hợp lệ!");
        }

        response.sendRedirect(request.getContextPath() + "/admin/support");
    }

    private void closeSupportRequest(HttpServletRequest request, HttpServletResponse response, UserDTO admin) 
            throws ServletException, IOException {
        
        String supportIdStr = request.getParameter("supportId");
        String adminResponse = request.getParameter("adminResponse");

        if (supportIdStr == null || adminResponse == null || adminResponse.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng điền đầy đủ thông tin!");
            response.sendRedirect(request.getContextPath() + "/admin/support");
            return;
        }

        try {
            int supportId = Integer.parseInt(supportIdStr);
            boolean success = supportService.closeSupportRequest(supportId, adminResponse, admin.getEmail());
            
            if (success) {
                request.setAttribute("success", "Đã đóng yêu cầu hỗ trợ thành công!");
            } else {
                request.setAttribute("error", "Có lỗi xảy ra khi đóng yêu cầu!");
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID yêu cầu hỗ trợ không hợp lệ!");
        }

        response.sendRedirect(request.getContextPath() + "/admin/support");
    }
} 