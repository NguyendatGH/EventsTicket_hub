package controller;

import dao.RefundDAO;
import dto.UserDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Refund;
import models.Notification;
import controller.NotificationWebSocket;
import service.NotificationService;
import java.io.IOException;
import java.util.List;
import java.math.BigDecimal;


@WebServlet("/admin/refund")
public class AdminRefundServlet extends HttpServlet {
    private RefundDAO refundDAO;
    private static final int PAGE_SIZE = 10;

    @Override
    public void init() throws ServletException {
        refundDAO = new RefundDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            HttpSession session = request.getSession();
            UserDTO user = (UserDTO) session.getAttribute("user");
            
            // Kiểm tra quyền admin
            if (user == null || !"admin".equalsIgnoreCase(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            String action = request.getParameter("action");
            String refundIdParam = request.getParameter("refundId");

            if ("detail".equals(action) && refundIdParam != null) {
                // Hiển thị chi tiết refund
                try {
                    int refundId = Integer.parseInt(refundIdParam);
                    Refund refund = refundDAO.getRefundById(refundId);
                    
                    if (refund != null) {
                        request.setAttribute("refund", refund);
                        request.getRequestDispatcher("/managerPage/AdminRefundDetail.jsp").forward(request, response);
                    } else {
                        request.setAttribute("errorMessage", "Không tìm thấy yêu cầu hoàn tiền.");
                        showRefundList(request, response);
                    }
                } catch (NumberFormatException e) {
                    request.setAttribute("errorMessage", "ID yêu cầu hoàn tiền không hợp lệ.");
                    showRefundList(request, response);
                }
            } else {
                // Hiển thị danh sách refund với filter và phân trang
                showRefundList(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi: " + e.getMessage());
            response.getWriter().println("Error: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            HttpSession session = request.getSession();
            UserDTO user = (UserDTO) session.getAttribute("user");
            
            // Kiểm tra quyền admin
            if (user == null || !"admin".equalsIgnoreCase(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            String action = request.getParameter("action");
            String refundIdParam = request.getParameter("refundId");

            if (refundIdParam == null) {
                request.setAttribute("errorMessage", "Thiếu thông tin yêu cầu hoàn tiền.");
                showRefundList(request, response);
                return;
            }

            try {
                int refundId = Integer.parseInt(refundIdParam);
                
                // Lấy thông tin refund để gửi thông báo
                Refund refund = refundDAO.getRefundById(refundId);
                if (refund == null) {
                    request.setAttribute("errorMessage", "Không tìm thấy yêu cầu hoàn tiền.");
                    response.sendRedirect(request.getContextPath() + "/admin/refund");
                    return;
                }
                
                if ("approve".equals(action)) {
                    boolean success = refundDAO.updateRefundStatus(refundId, "approved", user.getId());
                    if (success) {
                        // Gửi thông báo real-time cho customer
                        sendCustomerRefundNotification(refund, "approved");
                        request.setAttribute("successMessage", "Đã phê duyệt yêu cầu hoàn tiền thành công.");
                    } else {
                        request.setAttribute("errorMessage", "Có lỗi xảy ra khi phê duyệt yêu cầu hoàn tiền.");
                    }
                } else if ("reject".equals(action)) {
                    boolean success = refundDAO.updateRefundStatus(refundId, "rejected", user.getId());
                    if (success) {
                        // Gửi thông báo real-time cho customer
                        sendCustomerRefundNotification(refund, "rejected");
                        request.setAttribute("successMessage", "Đã từ chối yêu cầu hoàn tiền thành công.");
                    } else {
                        request.setAttribute("errorMessage", "Có lỗi xảy ra khi từ chối yêu cầu hoàn tiền.");
                    }
                } else if ("complete".equals(action)) {
                    boolean success = refundDAO.updateRefundStatus(refundId, "completed", user.getId());
                    if (success) {
                        // Gửi thông báo real-time cho customer
                        sendCustomerRefundNotification(refund, "completed");
                        request.setAttribute("successMessage", "Đã hoàn thành xử lý yêu cầu hoàn tiền.");
                    } else {
                        request.setAttribute("errorMessage", "Có lỗi xảy ra khi hoàn thành xử lý yêu cầu hoàn tiền.");
                    }
                } else {
                    request.setAttribute("errorMessage", "Hành động không hợp lệ.");
                }
                
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "ID yêu cầu hoàn tiền không hợp lệ.");
            }

            // Chuyển hướng về trang danh sách
            response.sendRedirect(request.getContextPath() + "/admin/refund");
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi: " + e.getMessage());
            response.getWriter().println("Error: " + e.getMessage());
        }
    }

    private void showRefundList(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            // Lấy các tham số filter và tìm kiếm
            String searchTerm = request.getParameter("search");
            String statusFilter = request.getParameter("status");
            String amountFilter = request.getParameter("amount");
            String reasonFilter = request.getParameter("reason");
            
            // Lấy tham số phân trang
            String pageParam = request.getParameter("page");
            int currentPage = 1;
            if (pageParam != null && !pageParam.trim().isEmpty()) {
                try {
                    currentPage = Integer.parseInt(pageParam);
                    if (currentPage < 1) currentPage = 1;
                } catch (NumberFormatException e) {
                    currentPage = 1;
                }
            }
            
            // Lấy dữ liệu với filter và phân trang
            List<Refund> refunds = refundDAO.searchRefunds(searchTerm, statusFilter, amountFilter, reasonFilter, currentPage, PAGE_SIZE);
            int totalRefunds = refundDAO.countRefunds(searchTerm, statusFilter, amountFilter, reasonFilter);
            
            // Tính toán thống kê
            int pendingRefunds = 0;
            int approvedRefunds = 0;
            int rejectedRefunds = 0;
            int completedRefunds = 0;
            
            if (refunds != null) {
                pendingRefunds = (int) refunds.stream().filter(r -> "pending".equals(r.getRefundStatus())).count();
                approvedRefunds = (int) refunds.stream().filter(r -> "approved".equals(r.getRefundStatus())).count();
                rejectedRefunds = (int) refunds.stream().filter(r -> "rejected".equals(r.getRefundStatus())).count();
                completedRefunds = (int) refunds.stream().filter(r -> "completed".equals(r.getRefundStatus())).count();
            }
            
            // Tính toán phân trang
            int totalPages = (int) Math.ceil((double) totalRefunds / PAGE_SIZE);
            int startPage = Math.max(1, currentPage - 2);
            int endPage = Math.min(totalPages, currentPage + 2);
            
            // Debug: In ra console
            System.out.println("DEBUG: Refunds count: " + (refunds != null ? refunds.size() : "null"));
            System.out.println("DEBUG: Total refunds: " + totalRefunds);
            System.out.println("DEBUG: Current page: " + currentPage);
            System.out.println("DEBUG: Total pages: " + totalPages);
            
            request.setAttribute("refunds", refunds);
            request.setAttribute("totalRefunds", totalRefunds);
            request.setAttribute("pendingRefunds", pendingRefunds);
            request.setAttribute("approvedRefunds", approvedRefunds);
            request.setAttribute("rejectedRefunds", rejectedRefunds);
            request.setAttribute("completedRefunds", completedRefunds);
            
            // Filter parameters
            request.setAttribute("searchTerm", searchTerm);
            request.setAttribute("statusFilter", statusFilter);
            request.setAttribute("amountFilter", amountFilter);
            request.setAttribute("reasonFilter", reasonFilter);
            
            // Pagination parameters
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("startPage", startPage);
            request.setAttribute("endPage", endPage);
            request.setAttribute("pageSize", PAGE_SIZE);
            
            request.getRequestDispatcher("/managerPage/AdminRefundList.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi khi tải dữ liệu: " + e.getMessage());
            response.getWriter().println("Error loading data: " + e.getMessage());
        }
    }
    
    private void sendCustomerRefundNotification(Refund refund, String status) {
        try {
            Notification notification = new Notification();
            notification.setUserID(refund.getUserId()); // Customer ID
            notification.setNotificationType("order");
            
            String statusText = "";
            switch (status) {
                case "approved":
                    statusText = "đã được phê duyệt";
                    break;
                case "rejected":
                    statusText = "đã bị từ chối";
                    break;
                case "completed":
                    statusText = "đã được hoàn thành";
                    break;
                default:
                    statusText = "đã được cập nhật";
            }
            
            notification.setTitle("Yêu cầu hoàn tiền " + statusText);
            notification.setContent("Yêu cầu hoàn tiền của bạn với số tiền " + refund.getRefundAmount() + " VNĐ " + statusText + ".");
            notification.setRelatedID(refund.getOrderId());
            notification.setIsRead(false);
            notification.setCreatedAt(java.time.LocalDateTime.now());
            notification.setPriority("high");
            
            // Save to database
            NotificationService notificationService = new NotificationService();
            boolean saved = notificationService.insertNotification(notification);
            
            if (saved) {
                // Send real-time notification to customer
                NotificationWebSocket.sendNotificationToUser(refund.getUserId(), notification);
                System.out.println("✅ Customer refund notification sent for status: " + status);
            } else {
                System.err.println("❌ Failed to save customer refund notification to database");
            }
        } catch (Exception e) {
            System.err.println("❌ Error sending customer refund notification: " + e.getMessage());
            e.printStackTrace();
        }
    }
} 