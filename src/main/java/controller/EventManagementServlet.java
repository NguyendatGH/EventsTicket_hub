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
import utils.ForwardJspUtils;

public class EventManagementServlet implements AdminSubServlet {
    private static final Logger logger = Logger.getLogger(EventManagementServlet.class.getName());
    private static final String EVENT_MANAGEMENT_JSP = "managerPage/AdminEventManagement.jsp";
    private static final String EVENT_DETAIL_JSP = "managerPage/EventOptions.jsp";
    private ForwardJspUtils forwardUtils;
    private EventDAO eventDAO;
    private UserDAO userDAO;

    public EventManagementServlet() {
        this.forwardUtils = new ForwardJspUtils();
        this.eventDAO = new EventDAO();
        this.userDAO = new UserDAO();
    }

    @Override
    public void handleRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo() != null ? request.getPathInfo() : "";
        logger.info("Xử lý yêu cầu quản lý sự kiện cho đường dẫn: " + pathInfo);

        if (pathInfo.startsWith("/event-detail")) {
            handleEventDetailRequest(request, response);
        } else if (pathInfo.equals("/action=delete")) {
            handleDeleteEvent(request, response);
        } else {
            setEventToJsp(request, response);
            forwardUtils.toJsp(request, response, EVENT_MANAGEMENT_JSP);
        }
    }

    private void setEventToJsp(HttpServletRequest request, HttpServletResponse response) {
        List<Event> recentEvents = eventDAO.getAllApprovedEvents();

        logger.info("Sự kiện: " + recentEvents.size());

        List<TopEventOwner> topOrganizers = userDAO.getTopEventOwner();

        if (topOrganizers == null || topOrganizers.isEmpty()) {
            logger.warning("Danh sách top organizers rỗng hoặc null");
            topOrganizers = new ArrayList<>();
        } else {
            logger.info("Tổng sụ kiện: " + topOrganizers.size());
        }
        Map<String, Integer> statusStats = eventDAO.getEventByStatus();
        Map<String, Integer> genreStats = eventDAO.getEventStatsByGenre();
        List<Map<String, Object>> monthlyStats = eventDAO.getMonthlyEventStats();

        ObjectMapper mapper = new ObjectMapper();
        try {
            String statusStatsJson = mapper.writeValueAsString(statusStats != null ? statusStats : new HashMap<>());
            String genreStatsJson = mapper.writeValueAsString(genreStats != null ? genreStats : new HashMap<>());
            String monthlyStatsJson = mapper
                    .writeValueAsString(monthlyStats != null ? monthlyStats : new ArrayList<>());

            logger.info("Serialized statusStatsJson: " + statusStatsJson);
            logger.info("Serialized genreStatsJson: " + genreStatsJson);
            logger.info("Serialized monthlyStatsJson: " + monthlyStatsJson);

            request.setAttribute("events", recentEvents);
            request.setAttribute("topOrganizers", topOrganizers);
            request.setAttribute("statusStatsJson", statusStatsJson);
            request.setAttribute("genreStatsJson", genreStatsJson);
            request.setAttribute("monthlyStatsJson", monthlyStatsJson);

        } catch (Exception e) {
            logger.severe("Error serializing JSON data: " + e.getMessage());
            request.setAttribute("statusStatsJson", "{}");
            request.setAttribute("genreStatsJson", "{}");
            request.setAttribute("monthlyStatsJson", "[]");

        }
    }

    private void handleEventDetailRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String eventIDStr = request.getParameter("eventID");

        if (eventIDStr == null || eventIDStr.isEmpty()) {
            logger.warning("Thiếu ID sự kiện");
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Yêu cầu ID sự kiện");
            return;
        }

        int eventID;
        try {
            eventID = Integer.parseInt(eventIDStr);
        } catch (NumberFormatException e) {
            logger.warning("Định dạng ID sự kiện không hợp lệ: " + eventIDStr);
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID sự kiện không hợp lệ");
            return;
        }

        Event event = eventDAO.getEventById(eventID);
        if (event == null) {
            logger.warning("Không tìm thấy sự kiện với ID: " + eventID);
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy sự kiện");
            return;
        }

        request.setAttribute("event", event);
        if ("edit".equals(action)) {
            request.setAttribute("editMode", true);
            forwardUtils.toJsp(request, response, EVENT_DETAIL_JSP);
        } else {
            request.setAttribute("editMode", false);
            forwardUtils.toJsp(request, response, EVENT_DETAIL_JSP);
        }
    }

    private void handleDeleteEvent(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String eventIDStr = request.getParameter("eventID");
        if (eventIDStr == null || eventIDStr.isEmpty()) {
            logger.warning("Thiếu ID sự kiện để xóa");
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Yêu cầu ID sự kiện");
            return;
        }

        int eventID;
        try {
            eventID = Integer.parseInt(eventIDStr);
        } catch (NumberFormatException e) {
            logger.warning("Định dạng ID sự kiện không hợp lệ để xóa: " + eventIDStr);
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID sự kiện không hợp lệ");
            return;
        }

        boolean deleted = eventDAO.deleteEvent(eventID);
        if (deleted) {
            response.setStatus(HttpServletResponse.SC_OK);
        } else {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Không thể xóa sự kiện");
        }
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo() != null ? request.getPathInfo() : "";
        logger.info("Xử lý yêu cầu POST cho đường dẫn: " + pathInfo);

        if (pathInfo.startsWith("/event-detail") && "update".equals(request.getParameter("action"))) {
            handleUpdateEvent(request, response);
        } else if (pathInfo.equals("/action=delete")) {
            handleDeleteEvent(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Hành động không hợp lệ");
        }
    }

    private void handleUpdateEvent(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String eventIDStr = request.getParameter("eventID");
        int eventID;
        try {
            eventID = Integer.parseInt(eventIDStr);
        } catch (NumberFormatException e) {
            logger.warning("Định dạng ID sự kiện không hợp lệ để cập nhật: " + eventIDStr);
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID sự kiện không hợp lệ");
            return;
        }

        Event event = new Event();
        event.setEventID(eventID);
        event.setName(request.getParameter("name"));
        event.setDescription(request.getParameter("description"));
        event.setPhysicalLocation(request.getParameter("physicalLocation"));
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
            event.setStartTime(sdf.parse(request.getParameter("startTime")));
            event.setEndTime(sdf.parse(request.getParameter("endTime")));
        } catch (Exception e) {
            logger.warning("Lỗi định dạng thời gian: " + e.getMessage());
            request.setAttribute("error", "Định dạng thời gian không hợp lệ");
            request.setAttribute("event", event);
            request.setAttribute("editMode", true);
            forwardUtils.toJsp(request, response, EVENT_DETAIL_JSP);
            return;
        }
        try {
            event.setTotalTicketCount(Integer.parseInt(request.getParameter("totalTicketCount")));
        } catch (NumberFormatException e) {
            logger.warning("Số lượng vé không hợp lệ: " + request.getParameter("totalTicketCount"));
            request.setAttribute("error", "Số lượng vé không hợp lệ");
            request.setAttribute("event", event);
            request.setAttribute("editMode", true);
            forwardUtils.toJsp(request, response, EVENT_DETAIL_JSP);
            return;
        }
        String status = request.getParameter("status");
        if (!"pending".equals(status) && !"active".equals(status) && !"cancelled".equals(status)
                && !"completed".equals(status)) {
            logger.warning("Trạng thái không hợp lệ: " + status);
            request.setAttribute("error", "Trạng thái không hợp lệ");
            request.setAttribute("event", event);
            request.setAttribute("editMode", true);
            forwardUtils.toJsp(request, response, EVENT_DETAIL_JSP);
            return;
        }
        event.setStatus(status);
        event.setImageURL(request.getParameter("imageURL"));
        event.setUpdatedAt(new Date());

        // boolean updated = eventDAO.updateEvent(event);
        // if (updated) {
        // response.sendRedirect(request.getContextPath() +
        // "/admin-servlet/event-management");
        // } else {
        // request.setAttribute("error", "Không thể cập nhật sự kiện");
        // request.setAttribute("event", event);
        // request.setAttribute("editMode", true);
        // forwardUtils.toJsp(request, response, EVENT_DETAIL_JSP);
        // }
    }
}