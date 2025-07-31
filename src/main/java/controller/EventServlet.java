package controller;

import dao.EventDAO;
import dao.FeedbackDAO;
import dao.TicketInfoDAO;
import models.Event;
import models.Feedback;
import models.TicketInfo;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "EventServlet", urlPatterns = {"/EventServlet"})
public class EventServlet extends HttpServlet {

    private EventDAO eventDAO;
    private TicketInfoDAO ticketInfoDAO;
    private FeedbackDAO feedbackDAO;

    @Override
    public void init() throws ServletException {
        eventDAO = new EventDAO();
        ticketInfoDAO = new TicketInfoDAO();
        feedbackDAO = new FeedbackDAO();
        feedbackDAO.approveAllFeedback();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        String pageParam = request.getParameter("page");

        if (idParam == null || idParam.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu ID sự kiện.");
            return;
        }

        try {
            int eventId = Integer.parseInt(idParam);
            Event event = eventDAO.getEventById(eventId);

            if (event == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy sự kiện.");
                return;
            }

            int currentPage = 1;
            if (pageParam != null && !pageParam.isEmpty()) {
                try {
                    currentPage = Integer.parseInt(pageParam);
                    if (currentPage < 1 || currentPage > 5) {
                        currentPage = 1;
                    }
                } catch (NumberFormatException e) {
                    currentPage = 1;
                }
            }

            int starFilter = 6 - currentPage;
            if (starFilter < 1 || starFilter > 5) {
                starFilter = 5;
            }


            List<TicketInfo> ticketList = ticketInfoDAO.getTicketInfosByEventID(eventId);
            List<Event> suggestedEvents = eventDAO.getSuggestedEvents(eventId);
            List<Feedback> feedbackList = feedbackDAO.getApprovedFeedbackByEventAndRating(eventId, starFilter);

            request.setAttribute("event", event);
            request.setAttribute("ticketList", ticketList);
            request.setAttribute("suggestedEvents", suggestedEvents);
            request.setAttribute("feedbackList", feedbackList);
            request.setAttribute("eventId", eventId);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("currentStar", starFilter);

            request.getRequestDispatcher("/pages/EventDetail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID sự kiện không hợp lệ.");
        }
    }
}
