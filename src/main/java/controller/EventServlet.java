

package controller;


import dao.EventDAO;
import models.Event;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import models.Event;

@WebServlet(name = "EventServlet", urlPatterns = {"/EventServlet"})
public class EventServlet extends HttpServlet {

    private EventDAO eventDAO;

    @Override
    public void init() throws ServletException {
        eventDAO = new EventDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam != null) {
            try {
                int eventId = Integer.parseInt(idParam);
                Event event = eventDAO.getEventById(eventId);
                request.setAttribute("event", event);
              
                List<Event> suggestedEvents = eventDAO.getSuggestedEvents(eventId);
                request.setAttribute("suggestedEvents", suggestedEvents);

                request.getRequestDispatcher("/pages/EventDetail.jsp").forward(request, response);
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid event ID");
            }
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing event ID");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "EventServlet for handling event details and suggestions";
    }
}
