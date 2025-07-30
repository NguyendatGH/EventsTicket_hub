package controller;

import java.io.IOException;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.RequestDispatcher;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;
import java.util.logging.Level;

import dao.EventDAO;
import dao.UserDAO;
import dto.UserDTO;
import models.IssueItem;
import models.User;
import service.UserService;
import models.Event;
import models.SupportItem;
import models.SupportAttachment;
import service.SupportService;

@WebServlet(name = "AdminServlet", urlPatterns = { "/admin-servlet/*" })
@MultipartConfig(fileSizeThreshold = 1024 * 1024, // 1MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class AdminServlet extends HttpServlet {

    private static final Logger logger = Logger.getLogger(AdminServlet.class.getName());

    // Khai báo các Servlet con (được ủy quyền)
    private UserManagementServlet userManagementServlet;
    private EventManagementServlet eventManagementServlet;
    private SupportCenterServlet supportCenterServlet;
    private AdminSupportServlet adminSupportServlet;
    private DashboardServlet dashboardServlet;
    private TransactionServlet transactionServlet;
    private UserService userService; // Instance của UserService
    private SupportService supportService; // Instance của SupportService

    @Override
    public void init() throws ServletException {
        super.init();
        try {
            // Khởi tạo các Servlet con và UserService
            userManagementServlet = new UserManagementServlet();
            eventManagementServlet = new EventManagementServlet();
            supportCenterServlet = new SupportCenterServlet();
            adminSupportServlet = new AdminSupportServlet();
            adminSupportServlet.init();
            dashboardServlet = new DashboardServlet();
            transactionServlet = new TransactionServlet();
            userService = new UserService();
            supportService = new SupportService();
        } catch (Exception e) {
            logger.severe("Error initializing AdminServlet: " + e.getMessage());
            throw new ServletException("Failed to initialize AdminServlet", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String pathInfo = request.getPathInfo();
        logger.info("Processing admin request for path: " + pathInfo);
        UserDTO u = (UserDTO) session.getAttribute("user");
        if (u == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        UserDTO loggedInUser = null;
        if (session != null) {
            loggedInUser = (UserDTO) session.getAttribute("user");
        }

        if (loggedInUser == null || !("admin".equalsIgnoreCase(loggedInUser.getRole()))) {
            logger.warning("Truy cập trái phép vào AdminServlet. User: " +
                    (loggedInUser != null ? loggedInUser.getEmail() + " (Role: " + loggedInUser.getRole() + ")"
                            : "Không đăng nhập"));

            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        logger.info("Processing admin request for path: " + pathInfo);
        try {
            if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/dashboard")) {
                dashboardServlet.handleRequest(request, response);
            } else if (pathInfo.startsWith("/user-management")) {
                userManagementServlet.handleRequest(request, response);
            } else if (pathInfo.startsWith("/event-management")) {
                eventManagementServlet.handleRequest(request, response);
            } else if (pathInfo.startsWith("/support-center")) {
                // Xử lý support center trực tiếp trong AdminServlet
                handleSupportCenter(request, response);
            } else if (pathInfo.startsWith("/transaction-management")) {
                transactionServlet.handleRequest(request, response);
            } else {
                logger.warning("Unknown path for admin: " + pathInfo);
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Đường dẫn quản trị không hợp lệ.");
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Lỗi khi xử lý yêu cầu quản trị cho path: " + pathInfo, e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Không thể xử lý yêu cầu: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        logger.info("Processing POST request with content-type: " + request.getContentType());
        if (request.getContentType() != null &&
                request.getContentType().startsWith("multipart/form-data")) {
            try {
                request = new MultipartRequestWrapper(request);
            } catch (Exception e) {
                logger.log(Level.SEVERE, "Error processing multipart request", e);
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                return;
            }
        }
        HttpSession session = request.getSession(false);
        UserDTO loggedInUser = null;
        if (session != null) {
            loggedInUser = (UserDTO) session.getAttribute("user");
        }

        if (loggedInUser == null || !("admin".equalsIgnoreCase(loggedInUser.getRole()))) {
            logger.warning("Truy cập POST trái phép vào AdminServlet. User: " +
                    (loggedInUser != null ? loggedInUser.getEmail() + " (Role: " + loggedInUser.getRole() + ")"
                            : "Không đăng nhập"));
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String pathInfo = request.getPathInfo();
        logger.info("Processing admin POST request for path: " + pathInfo);

        try {
            if (pathInfo != null) {
                if (pathInfo.startsWith("/user-management")) {
                    userManagementServlet.handleRequest(request, response);
                } else if (pathInfo.startsWith("/event-management")) {
                    eventManagementServlet.handleRequest(request, response);
                } else if (pathInfo.startsWith("/support-center")) {
                    handleSupportCenterPost(request, response);
                }

                else {
                    logger.warning("Unknown POST path for admin: " + pathInfo);
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Đường dẫn quản trị POST không hợp lệ.");
                }
            } else {
                logger.warning("POST request to base admin-servlet path without specific action.");
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Yêu cầu POST không xác định.");
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Lỗi khi xử lý yêu cầu POST quản trị", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Không thể xử lý yêu cầu: " + e.getMessage());
        }
    }

    private void handleSupportCenter(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("view-detail".equals(action)) {
            viewSupportDetail(request, response);
        } else if ("download".equals(action)) {
            downloadAttachment(request, response);
        } else if ("view".equals(action)) {
            viewAttachment(request, response);
        } else {
            // Hiển thị danh sách tất cả yêu cầu hỗ trợ
            showSupportList(request, response);
        }
    }

    private void handleSupportCenterPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("reply".equals(action)) {
            replyToSupport(request, response);
        } else if ("resolve".equals(action)) {
            resolveSupport(request, response);
        } else if ("close".equals(action)) {
            closeSupport(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin-servlet/support-center");
        }
    }

    private void showSupportList(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            List<SupportItem> allRequests = supportService.getAllSupportRequests();
            List<SupportItem> pendingRequests = supportService.getSupportRequestsByStatus("PENDING");
            
            request.setAttribute("allRequests", allRequests);
            request.setAttribute("pendingRequests", pendingRequests);
            
            request.getRequestDispatcher("/supportCenter/supportCenter_admin.jsp").forward(request, response);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error showing support list", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error loading support requests");
        }
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
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error viewing support detail", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error loading support detail");
        }
    }

    private void downloadAttachment(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Implementation for downloading attachments
        // This would be similar to AdminSupportServlet's downloadAttachment method
        response.sendError(HttpServletResponse.SC_NOT_IMPLEMENTED, "Download functionality not implemented yet");
    }

    private void viewAttachment(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Implementation for viewing attachments
        // This would be similar to AdminSupportServlet's viewAttachment method
        response.sendError(HttpServletResponse.SC_NOT_IMPLEMENTED, "View functionality not implemented yet");
    }

    private void replyToSupport(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String supportIdStr = request.getParameter("supportId");
        String adminResponse = request.getParameter("adminResponse");
        
        if (supportIdStr == null || adminResponse == null || adminResponse.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng điền đầy đủ thông tin!");
            response.sendRedirect(request.getContextPath() + "/admin-servlet/support-center?action=view-detail&id=" + supportIdStr);
            return;
        }

        try {
            int supportId = Integer.parseInt(supportIdStr);
            UserDTO user = (UserDTO) request.getSession().getAttribute("user");
            boolean success = supportService.replyToSupportRequest(supportId, adminResponse, user.getEmail());
            
            if (success) {
                request.setAttribute("success", "Đã phản hồi yêu cầu hỗ trợ thành công!");
            } else {
                request.setAttribute("error", "Có lỗi xảy ra khi phản hồi yêu cầu hỗ trợ!");
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID yêu cầu hỗ trợ không hợp lệ!");
        }

        response.sendRedirect(request.getContextPath() + "/admin-servlet/support-center?action=view-detail&id=" + supportIdStr);
    }

    private void resolveSupport(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String supportIdStr = request.getParameter("supportId");
        String adminResponse = request.getParameter("adminResponse");
        
        if (supportIdStr == null || adminResponse == null || adminResponse.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng điền đầy đủ thông tin!");
            response.sendRedirect(request.getContextPath() + "/admin-servlet/support-center?action=view-detail&id=" + supportIdStr);
            return;
        }

        try {
            int supportId = Integer.parseInt(supportIdStr);
            UserDTO user = (UserDTO) request.getSession().getAttribute("user");
            boolean success = supportService.resolveSupportRequest(supportId, adminResponse, user.getEmail());
            
            if (success) {
                request.setAttribute("success", "Đã giải quyết yêu cầu hỗ trợ thành công!");
            } else {
                request.setAttribute("error", "Có lỗi xảy ra khi giải quyết yêu cầu hỗ trợ!");
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID yêu cầu hỗ trợ không hợp lệ!");
        }

        response.sendRedirect(request.getContextPath() + "/admin-servlet/support-center?action=view-detail&id=" + supportIdStr);
    }

    private void closeSupport(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String supportIdStr = request.getParameter("supportId");
        String adminResponse = request.getParameter("adminResponse");
        
        if (supportIdStr == null || adminResponse == null || adminResponse.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng điền đầy đủ thông tin!");
            response.sendRedirect(request.getContextPath() + "/admin-servlet/support-center?action=view-detail&id=" + supportIdStr);
            return;
        }

        try {
            int supportId = Integer.parseInt(supportIdStr);
            UserDTO user = (UserDTO) request.getSession().getAttribute("user");
            boolean success = supportService.closeSupportRequest(supportId, adminResponse, user.getEmail());
            
            if (success) {
                request.setAttribute("success", "Đã đóng yêu cầu hỗ trợ thành công!");
            } else {
                request.setAttribute("error", "Có lỗi xảy ra khi đóng yêu cầu hỗ trợ!");
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID yêu cầu hỗ trợ không hợp lệ!");
        }

        response.sendRedirect(request.getContextPath() + "/admin-servlet/support-center?action=view-detail&id=" + supportIdStr);
    }

    @Override
    public String getServletInfo() {
        return "Admin Servlet for managing admin dashboard, user accounts, events, and support center";
    }
}