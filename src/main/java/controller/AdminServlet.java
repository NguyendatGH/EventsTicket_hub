package controller;

import java.io.IOException;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
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

@WebServlet(name = "AdminServlet", urlPatterns = { "/admin-servlet/*" })
public class AdminServlet extends HttpServlet {

    private static final Logger logger = Logger.getLogger(AdminServlet.class.getName());

    // Khai báo các Servlet con (được ủy quyền)
    private UserManagementServlet userManagementServlet;
    private EventManagementServlet eventManagementServlet;
    private SupportCenterServlet supportCenterServlet;
    private DashboardServlet dashboardServlet;
    private TransactionServlet transactionServlet;
    private UserService userService; // Instance của UserService

    @Override
    public void init() throws ServletException {
        super.init();
        // Khởi tạo các Servlet con và UserService
        userManagementServlet = new UserManagementServlet();
        eventManagementServlet = new EventManagementServlet();
        supportCenterServlet = new SupportCenterServlet();
        dashboardServlet = new DashboardServlet();
        transactionServlet = new TransactionServlet();
        userService = new UserService();
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


        // --- Bắt đầu kiểm tra quyền admin ---
        UserDTO loggedInUser = null;
        if (session != null) {
            loggedInUser = (UserDTO) session.getAttribute("user");
        }

        // Kiểm tra xem người dùng đã đăng nhập chưa và có phải là admin không
        if (loggedInUser == null || !("admin".equalsIgnoreCase(loggedInUser.getRole()))) {
            logger.warning("Truy cập trái phép vào AdminServlet. User: " + 
                           (loggedInUser != null ? loggedInUser.getEmail() + " (Role: " + loggedInUser.getRole() + ")" : "Không đăng nhập"));
            
            // Chuyển hướng về trang đăng nhập hoặc trang lỗi quyền truy cập
            response.sendRedirect(request.getContextPath() + "/login"); // Hoặc một trang lỗi/thông báo không có quyền
            return; // Ngừng xử lý yêu cầu
        }
        // --- Kết thúc kiểm tra quyền admin ---


        String pathInfo = request.getPathInfo();
        logger.info("Processing admin request for path: " + pathInfo);
        
        // ủy quyền yêu cầu và phản hồi cho các Servlet con.
        // Các Servlet con cần có phương thức handleRequest(HttpServletRequest, HttpServletResponse)
        // hoặc bạn phải gọi trực tiếp doGet/doPost của chúng.
        try {
            if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/dashboard")) {
                dashboardServlet.handleRequest(request, response);
            } else if (pathInfo.startsWith("/user-management")) {
                userManagementServlet.handleRequest(request, response);
            } else if (pathInfo.startsWith("/event-management")) {
                eventManagementServlet.handleRequest(request, response);
            } else if (pathInfo.startsWith("/support-center")) {
                // Chuyển tiếp request đến AdminSupportServlet
                request.getRequestDispatcher("/admin/support").forward(request, response);
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
        logger.info("POST request received, delegating to doGet");
        // Đối với AdminServlet, thường thì các hành động POST cũng được định tuyến bởi pathInfo.
        // Do đó, delegating to doGet có thể không phải lúc nào cũng tối ưu, 
        // tùy thuộc vào cách các servlet con xử lý POST.
        // Nếu các servlet con có xử lý POST riêng, bạn nên điều chỉnh logic dưới đây.
        
        // Kiểm tra quyền admin trước khi ủy quyền cho POST requests
        HttpSession session = request.getSession(false);
        UserDTO loggedInUser = null;
        if (session != null) {
            loggedInUser = (UserDTO) session.getAttribute("user");
        }

        if (loggedInUser == null || !("admin".equalsIgnoreCase(loggedInUser.getRole()))) {
            logger.warning("Truy cập POST trái phép vào AdminServlet. User: " + 
                           (loggedInUser != null ? loggedInUser.getEmail() + " (Role: " + loggedInUser.getRole() + ")" : "Không đăng nhập"));
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String pathInfo = request.getPathInfo();
        logger.info("Processing admin POST request for path: " + pathInfo);

        try {
            if (pathInfo != null) {
                if (pathInfo.startsWith("/user-management")) {
                    userManagementServlet.handleRequest(request, response); // hoặc .doPost(request, response)
                } else if (pathInfo.startsWith("/event-management")) {
                    eventManagementServlet.handleRequest(request, response); // hoặc .doPost(request, response)
                } 
                // Thêm các trường hợp xử lý POST cho các Servlet con khác
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

    @Override
    public String getServletInfo() {
        return "Admin Servlet for managing admin dashboard, user accounts, events, and support center";
    }
}