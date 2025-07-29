package controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.logging.Logger;
import java.util.logging.Level;
import dto.UserDTO;
import service.UserService;


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
                // Gọi trực tiếp AdminSupportServlet
                adminSupportServlet.doGet(request, response);
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
                    adminSupportServlet.doPost(request, response);
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

    @Override
    public String getServletInfo() {
        return "Admin Servlet for managing admin dashboard, user accounts, events, and support center";
    }
}