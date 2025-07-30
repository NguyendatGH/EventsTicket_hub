package controller;

import dao.EventDAO;
import models.Event;
import dto.UserDTO; 
import models.Notification; 
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
import dao.GenreDAO;
import models.Genre;


@WebServlet({"/", "/home"})
public class HomePageServlet extends HttpServlet {

    private EventDAO eventDAO;
    private NotificationService notificationService;
    private static final int RECORDS_PER_PAGE = 12; 

    @Override
    public void init() throws ServletException {
        super.init();
        eventDAO = new EventDAO();
        notificationService = new NotificationService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        EventDAO eventDAO = new EventDAO();

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


        try {
            String search = request.getParameter("search");
            String location = request.getParameter("location");
            String categoryParam = request.getParameter("category");
            Integer genreId = null;
            if (categoryParam != null && !categoryParam.isEmpty()) {
                try {
                    genreId = Integer.parseInt(categoryParam);
                } catch (NumberFormatException e) {
                    genreId = null;
                }
            }


            List<String> locations = eventDAO.getAvailableLocations();
            request.setAttribute("locations", locations);
            GenreDAO genreDAO = new GenreDAO();
            List<Genre> genres = genreDAO.getAllGenres();
            request.setAttribute("genres", genres);

            if ((search != null && !search.trim().isEmpty()) || (location != null && !location.trim().isEmpty()) || (genreId != null && genreId > 0)) {
                List<Event> events = eventDAO.searchEvents(search, location, genreId);
                request.setAttribute("events", events);
                request.setAttribute("search", search);
                request.setAttribute("location", location);
                request.setAttribute("category", genreId);
                request.setAttribute("noOfPages", 1);
                request.setAttribute("currentPage", 1);
                request.setAttribute("totalEvents", events.size());
                request.getRequestDispatcher("/pages/homePage.jsp").forward(request, response);
                return;
            }

            int currentPage = 1;
            if (request.getParameter("page") != null) {
                try {
                    currentPage = Integer.parseInt(request.getParameter("page"));
                    if (currentPage < 1)
                        currentPage = 1;
                } catch (NumberFormatException e) {
                    currentPage = 1; 
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