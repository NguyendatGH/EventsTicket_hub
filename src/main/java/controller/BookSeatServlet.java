package controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import dao.EventDAO;
import dao.SeatDAO;
import dao.ZoneDAO;
import models.Event;
import models.Seat;
import models.Zone;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "BookSeatServlet", urlPatterns = { "/BookSeatServlet" })
public class BookSeatServlet extends HttpServlet {

    private EventDAO eventDAO;
    private SeatDAO seatDAO;
    private ZoneDAO zoneDAO;
    private ObjectMapper objectMapper;

    @Override
    public void init() {
        eventDAO = new EventDAO();
        seatDAO = new SeatDAO();
        zoneDAO = new ZoneDAO();
        objectMapper = new ObjectMapper();
        objectMapper.registerModule(new JavaTimeModule());
        objectMapper.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (request.getSession().getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String eventIdStr = request.getParameter("eventId");
        if (eventIdStr == null || eventIdStr.trim().isEmpty() || eventIdStr.equals("undefined")) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Yêu cầu thiếu tham số 'eventId' hợp lệ.");
            return;
        }

        try {
            int eventId = Integer.parseInt(eventIdStr);
            Event event = eventDAO.getEventById(eventId);
            if (event == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy sự kiện.");
                return;
            }

            List<Zone> zones = zoneDAO.getZonesByEventId(eventId);
            List<Seat> seats = seatDAO.getSeatsByEventId(eventId);

            String zonesJson = objectMapper.writeValueAsString(zones);
            String seatsJson = objectMapper.writeValueAsString(seats);
            String eventJson = objectMapper.writeValueAsString(event);

            System.out.println("zones: " +zones);
            System.out.println("seats: " +seats);

            request.setAttribute("event", event);
            request.setAttribute("zones", zones); // Thêm dòng này
            request.setAttribute("zonesJson", zonesJson);
            request.setAttribute("seatsJson", seatsJson);
            request.setAttribute("eventJson", eventJson);

            request.getRequestDispatcher("/pages/BookSeat.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Định dạng Event ID không hợp lệ.");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Đã có lỗi xảy ra.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
      
    }
}