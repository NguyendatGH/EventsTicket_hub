package controller;

import dao.EventDAO;
import dao.TicketInfoDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.Event;
import models.TicketInfo;

@WebServlet(name = "TicketInfoServlet", urlPatterns = {"/TicketInfoServlet"})
public class TicketInfoServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String eventIdParam = request.getParameter("eventId");

        if (eventIdParam == null || eventIdParam.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Event ID is required.");
            return;
        }

        try {
            int eventId = Integer.parseInt(eventIdParam);

            EventDAO eventDAO = new EventDAO();
            TicketInfoDAO ticketDAO = new TicketInfoDAO();

            Event event = eventDAO.getEventById(eventId);

            if (event == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Event not found.");
                return;
            }

            List<TicketInfo> listTicket = ticketDAO.getTicketInfosByEventID(eventId);

            request.setAttribute("event", event);
            request.setAttribute("listTicket", listTicket);

            // >>> SỬA LỖI Ở ĐÂY: Đảm bảo forward đến đúng file JSP hiển thị vé.
            // Tôi giả định tên file là "TicketDetail.jsp". Nếu bạn đặt tên khác, hãy thay đổi ở đây.
            request.getRequestDispatcher("/pages/TicketInfor.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid Event ID format.");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "An unexpected error occurred.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}