package controller;

import dao.EventDAO;
import dao.FeedbackDAO;
import dao.TicketInfoDAO; 
import models.Event;
import models.TicketInfo;   
import dao.TicketInfoDAO; // SỬA: Import DAO đúng
import dao.FeedbackDAO;
import models.Event;
import models.TicketInfo;   // SỬA: Import Model đúng
import models.Feedback;

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

            System.out.println("eventId: " + eventId);
            System.out.println("event: " + event);

            if (event != null) {
                List<TicketInfo> ticketList = ticketInfoDAO.getTicketInfosByEventID(eventId);
                List<Event> suggestedEvents = eventDAO.getSuggestedEvents(eventId);
                List<Feedback> feedbackList = feedbackDAO.getFeedbackByEventId(eventId);

                System.out.println("ticketList size: " + (ticketList != null ? ticketList.size() : "null"));
                System.out.println("suggestedEvents size: " + (suggestedEvents != null ? suggestedEvents.size() : "null"));
                System.out.println("feedbackList size: " + (feedbackList != null ? feedbackList.size() : "null"));

                request.setAttribute("event", event);
                request.setAttribute("ticketList", ticketList);
                request.setAttribute("suggestedEvents", suggestedEvents);
                request.setAttribute("feedbackList", feedbackList);

                System.out.println("Feedback size for eventId " + eventId + ": " + feedbackList.size());


                request.getRequestDispatcher("/pages/EventDetail.jsp").forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy sự kiện với ID = " + eventId);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("text/plain;charset=UTF-8");
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
