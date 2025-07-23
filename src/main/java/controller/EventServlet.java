package controller;

import dao.EventDAO;
import dao.TicketInfoDAO; // SỬA: Import DAO đúng
import models.Event;
import models.TicketInfo;   // SỬA: Import Model đúng
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

    @Override
    public void init() throws ServletException {
        eventDAO = new EventDAO();
        ticketInfoDAO = new TicketInfoDAO(); 
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

            if (event != null) {
                
                List<TicketInfo> ticketList = ticketInfoDAO.getTicketInfosByEventID(eventId);
                List<Event> suggestedEvents = eventDAO.getSuggestedEvents(eventId);

                request.setAttribute("event", event);
                request.setAttribute("ticketList", ticketList);
                request.setAttribute("suggestedEvents", suggestedEvents);

                request.getRequestDispatcher("/pages/EventDetail.jsp").forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy sự kiện với ID = " + eventId);
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Định dạng ID sự kiện không hợp lệ.");
        }
    }
}