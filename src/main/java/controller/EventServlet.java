package controller;

import dao.EventDAO;
import dao.FeedbackDAO;
import dao.TicketInfoDAO; 
import models.Event;
import models.TicketInfo;   
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import models.Feedback;

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
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");

        if (idParam == null || idParam.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Yêu cầu thiếu ID sự kiện.");
            return;
        }

        try {
            int eventId = Integer.parseInt(idParam);
            Event event = eventDAO.getEventById(eventId);
            List<Feedback> feedbackList = feedbackDAO.getApprovedFeedbackByEvent(eventId);

            if (event != null) {

                List<TicketInfo> ticketList = ticketInfoDAO.getTicketInfosByEventID(eventId);
                List<Event> suggestedEvents = eventDAO.getSuggestedEvents(eventId);

                request.setAttribute("event", event);
                request.setAttribute("ticketList", ticketList);
                request.setAttribute("suggestedEvents", suggestedEvents);
                request.setAttribute("feedbackList", feedbackList);
                System.out.println("Feedback size for eventId " + eventId + ": " + feedbackList.size());

                request.getRequestDispatcher("/pages/EventDetail.jsp").forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy sự kiện với ID = " + eventId);
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Định dạng ID sự kiện không hợp lệ.");
        }
    }
}
