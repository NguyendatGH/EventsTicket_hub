package controller;

import dao.EventDAO;
import dao.TicketInforDAO; // THAY ĐỔI IMPORT
import models.Event;
import models.TicketInfor;    // THAY ĐỔI IMPORT
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
    private TicketInforDAO ticketInforDAO; // THAY ĐỔI Tên DAO

    @Override
    public void init() throws ServletException {
        eventDAO = new EventDAO();
        ticketInforDAO = new TicketInforDAO(); // THAY ĐỔI Khởi tạo
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
                List<TicketInfor> ticketList = ticketInforDAO.getTicketInfosByEventID(eventId);
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
