package controller;

import dao.EventDAO;
import models.Event;
import dto.UserDTO; // Import the User model
import models.Notification; // Import the Notification model
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import java.util.ArrayList;
import service.NotificationService;
import service.UserService; 

@WebServlet("/")
public class HomePageServlet extends HttpServlet {

    private EventDAO eventDAO;
    private NotificationService notificationService;
    private static final int RECORDS_PER_PAGE = 10; // Giữ lại hằng số phân trang

    @Override
    public void init() throws ServletException {
        super.init(); // Call super.init() for proper servlet initialization
        eventDAO = new EventDAO();
        notificationService = new NotificationService(); // Initialize the service
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Xử lý phần thông báo từ HEAD
        HttpSession session = request.getSession(false);
        UserDTO user = null;
        if (session != null) {
            user = (UserDTO) session.getAttribute("user");
        }

        List<Notification> notifications = new ArrayList<>();
        int unreadCount = 0;

        if (user != null) {
            notifications = notificationService.getUserNotifications(user.getId());
            unreadCount = notificationService.getUnreadNotificationsCount(user.getId());
        }

        request.setAttribute("notifications", notifications);
        request.setAttribute("unreadCount", unreadCount);

        // Xử lý phần phân trang từ 9dcfe0a0e6a3d478bcbf302ea9319c09e3eacdf5
        try {
            int currentPage = 1;
            if (request.getParameter("page") != null) {
                try {
                    currentPage = Integer.parseInt(request.getParameter("page"));
                    if (currentPage < 1)
                        currentPage = 1;
                } catch (NumberFormatException e) {
                    currentPage = 1; // Mặc định về trang 1 nếu lỗi
                }
            }

            int offset = (currentPage - 1) * RECORDS_PER_PAGE;

            List<Event> events = eventDAO.getApprovedEventsPaginated(offset, RECORDS_PER_PAGE);
            int totalEvents = eventDAO.getTotalApprovedEventsCount();
            int noOfPages = (int) Math.ceil(totalEvents * 1.0 / RECORDS_PER_PAGE);

            request.setAttribute("events", events);
            request.setAttribute("noOfPages", noOfPages);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalEvents", totalEvents);
            request.getRequestDispatcher("/pages/homePage.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Có lỗi xảy ra khi tải sự kiện: " + e.getMessage());
        }
    }
}