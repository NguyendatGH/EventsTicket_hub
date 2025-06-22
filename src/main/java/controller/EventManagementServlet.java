package controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import models.TopEventOwner;
import models.Event;
import dao.EventDAO;
import dao.UserDAO;
import utils.ToggleEvent;
import utils.ForwardJspUtils;

public class EventManagementServlet implements AdminSubServlet {
    private static final Logger logger = Logger.getLogger(EventManagementServlet.class.getName());
    private static final String EVENT_MANAGEMENT_JSP = "managerPage/AdminEventManagement.jsp";
    private static final String EVENT_DETAIL_JSP = "managerPage/EventOptions.jsp";
    private final ForwardJspUtils forwardUtils;
    private final EventDAO eventDAO;
    private final UserDAO userDAO;

    public EventManagementServlet() {
        this.forwardUtils = new ForwardJspUtils();
        this.eventDAO = new EventDAO();
        this.userDAO = new UserDAO();
    }

    @Override
    public void handleRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        logger.info("Handling GET request with action: " + action);
        if ("edit-event".equals(action)) {
            handleEditEvent(request, response);
        } else if ("delete".equals(action)) {
            handleDeleteEvent(request, response);
        } else if ("update".equals(action)) {
            handleUpdateEvent(request, response);
        } else {
            setEventToJsp(request, response);
            forwardUtils.toJsp(request, response, EVENT_MANAGEMENT_JSP);
        }
    }

    private void setEventToJsp(HttpServletRequest request, HttpServletResponse response) {
        List<Event> activeEvents = eventDAO.getActiveEvents();
        List<Event> nonActiveEvents = eventDAO.getNonActiveEvents();
        List<TopEventOwner> topOrganizers = userDAO.getTopEventOwner();
        Map<String, Integer> statusStats = eventDAO.getEventByStatus();
        Map<String, Integer> genreStats = eventDAO.getEventStatsByGenre();
        List<Map<String, Object>> monthlyStats = eventDAO.getMonthlyEventStats();

        ObjectMapper mapper = new ObjectMapper();
        try {
            request.setAttribute("activeEvents", activeEvents != null ? activeEvents : new ArrayList<>());
            request.setAttribute("nonActiveEvents", nonActiveEvents != null ? nonActiveEvents : new ArrayList<>());
            request.setAttribute("topOrganizers", topOrganizers != null ? topOrganizers : new ArrayList<>());
            request.setAttribute("statusStatsJson",
                    mapper.writeValueAsString(statusStats != null ? statusStats : new HashMap<>()));
            request.setAttribute("genreStatsJson",
                    mapper.writeValueAsString(genreStats != null ? genreStats : new HashMap<>()));
            request.setAttribute("monthlyStatsJson",
                    mapper.writeValueAsString(monthlyStats != null ? monthlyStats : new ArrayList<>()));
        } catch (Exception e) {
            logger.severe("Error serializing JSON data: " + e.getMessage());
            request.setAttribute("statusStatsJson", "{}");
            request.setAttribute("genreStatsJson", "{}");
            request.setAttribute("monthlyStatsJson", "[]");
        }
    }

    private void handleDeleteEvent(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json");
        ObjectMapper mapper = new ObjectMapper();
        Map<String, Object> responseMap = new HashMap<>();

        String eventIDStr = request.getParameter("eventID");
        if (eventIDStr == null || eventIDStr.isEmpty()) {
            responseMap.put("success", false);
            responseMap.put("message", "Yêu cầu ID sự kiện");
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            mapper.writeValue(response.getWriter(), responseMap);
            return;
        }

        int eventID;
        try {
            eventID = Integer.parseInt(eventIDStr);
        } catch (NumberFormatException e) {
            responseMap.put("success", false);
            responseMap.put("message", "ID sự kiện không hợp lệ");
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            mapper.writeValue(response.getWriter(), responseMap);
            return;
        }

        ToggleEvent deleteResult = eventDAO.deleteEvent(eventID);
        responseMap.put("success", deleteResult.isSuccess());
        responseMap.put("message", deleteResult.getMessage());

        if (deleteResult.isSuccess()) {
            response.setStatus(HttpServletResponse.SC_OK);
        } else {
            response.setStatus(
                    deleteResult.getMessage().contains("Sự kiện không tồn tại") ? HttpServletResponse.SC_NOT_FOUND
                            : deleteResult.getMessage().contains("vé được bán") ? HttpServletResponse.SC_CONFLICT
                                    : HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
        mapper.writeValue(response.getWriter(), responseMap);
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        logger.info("Handling POST request with action: " + action);
        if ("update".equals(action)) {
            handleUpdateEvent(request, response);
        } else if ("delete".equals(action)) {
            handleDeleteEvent(request, response);
        } else {
            logger.warning("Invalid action: " + action);
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Hành động không hợp lệ");
        }
    }

    private void handleUpdateEvent(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        logger.info("Processing update event request");
        String eventIDStr = request.getParameter("eventID");
        System.out.println("event Id for updating: " + eventIDStr);
        int eventID;
        try {
            eventID = Integer.parseInt(eventIDStr);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID sự kiện không hợp lệ");
            request.setAttribute("editMode", true);
            forwardUtils.toJsp(request, response, EVENT_DETAIL_JSP);
            return;
        }

        Event event = new Event();
        event.setEventID(eventID);
        event.setName(request.getParameter("name"));
        event.setDescription(request.getParameter("description"));
        event.setPhysicalLocation(request.getParameter("physicalLocation"));
        event.setStatus(request.getParameter("status"));
        event.setImageURL(request.getParameter("imageURL"));
        event.setUpdatedAt(new Date());

        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
            event.setStartTime(sdf.parse(request.getParameter("startTime")));
            event.setEndTime(sdf.parse(request.getParameter("endTime")));
        } catch (Exception e) {
            request.setAttribute("error", "Định dạng thời gian không hợp lệ");
            request.setAttribute("event", event);
            request.setAttribute("editMode", true);
            forwardUtils.toJsp(request, response, EVENT_DETAIL_JSP);
            return;
        }

        try {
            event.setTotalTicketCount(Integer.parseInt(request.getParameter("totalTicketCount")));
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Số lượng vé không hợp lệ");
            request.setAttribute("event", event);
            request.setAttribute("editMode", true);
            forwardUtils.toJsp(request, response, EVENT_DETAIL_JSP);
            return;
        }

        System.out.println("Event update: " + event);

        ToggleEvent updateResult = eventDAO.updateEvent(event);
        if (updateResult.isSuccess()) {
            request.setAttribute("success", updateResult.getMessage());
            request.setAttribute("event", eventDAO.getEventById(eventID)); // Refresh event data
            request.setAttribute("editMode", true);
            forwardUtils.toJsp(request, response, EVENT_DETAIL_JSP);
        } else {
            request.setAttribute("error", updateResult.getMessage());
            request.setAttribute("event", event);
            request.setAttribute("editMode", true);
            forwardUtils.toJsp(request, response, EVENT_DETAIL_JSP);
        }
    }

    private void handleEditEvent(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String eventIDStr = request.getParameter("eventId");
        if (eventIDStr == null || eventIDStr.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Yêu cầu ID sự kiện");
            return;
        }

        int eventID;
        try {
            eventID = Integer.parseInt(eventIDStr);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID sự kiện không hợp lệ");
            return;
        }

        Event event = eventDAO.getEventById(eventID);
        if (event == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy sự kiện");
            return;
        }

        request.setAttribute("event", event);
        request.setAttribute("editMode", true);
        forwardUtils.toJsp(request, response, EVENT_DETAIL_JSP);
    }
}