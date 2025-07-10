package controller;

import dao.EventDAO;
import dao.GenreDAO;
import dao.PromotionDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.List;
import models.Event;
import models.Genre;
import models.Promotion;
import models.TicketInfo;
import models.TicketInventory;

@WebServlet("/organizer-servlet")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, maxFileSize = 1024 * 1024 * 16, maxRequestSize = 1024 * 1024 * 50)
public class EventOwnerServlet extends HttpServlet {
    private EventDAO eventDao;

    @Override
    public void init() throws ServletException {
        eventDao = new EventDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            showDashboard(request, response);
        } else {
            switch (action) {
                case "list":
                    listEvents(request, response);
                    break;
                case "edit":
                    editEvent(request, response);
                    break;
                case "delete":
                    deleteEvent(request, response);
                    break;
                case "view":
                    viewEvent(request, response);
                    break;
                default:
                    showDashboard(request, response);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null || "create".equals(action)) {
            createEvent(request, response);
        } else if ("update".equals(action)) {
            updateEvent(request, response);
        }
    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        GenreDAO genreDao = new GenreDAO();
        List<Genre> genres = genreDao.getAllGenres();
        request.setAttribute("genres", genres);
        request.getRequestDispatcher("/createEvent/dashBoard.jsp").forward(request, response);
    }

    private void createEvent(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userID = (Integer) session.getAttribute("userID");
        if (userID == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            String eventName = request.getParameter("eventName");
            String eventDescription = request.getParameter("eventDescription");
            String physicalLocation = request.getParameter("physicalLocation");
            String genreIDStr = request.getParameter("genreID");
            String startTimeStr = request.getParameter("startTime");
            String endTimeStr = request.getParameter("endTime");
            String totalTicketCountStr = request.getParameter("totalTicketCount");
            String hasSeatingChartStr = request.getParameter("hasSeatingChart");
            String ticketPriceStr = request.getParameter("ticketPrice");

            if (eventName == null || eventName.trim().isEmpty() || genreIDStr == null || startTimeStr == null ||
                endTimeStr == null || totalTicketCountStr == null || ticketPriceStr == null) {
                request.setAttribute("errorMessage", "Required fields are missing.");
                showDashboard(request, response);
                return;
            }

            Timestamp startTime = Timestamp.valueOf(startTimeStr.replace("T", " ") + ":00");
            Timestamp endTime = Timestamp.valueOf(endTimeStr.replace("T", " ") + ":00");
            if (endTime.before(startTime)) {
                request.setAttribute("errorMessage", "End time must be after start time.");
                showDashboard(request, response);
                return;
            }

            int genreID = Integer.parseInt(genreIDStr);
            int totalTicketCount = Integer.parseInt(totalTicketCountStr);
            boolean hasSeatingChart = "true".equals(hasSeatingChartStr);
            BigDecimal ticketPrice = new BigDecimal(ticketPriceStr);

            Part imagePart = request.getPart("imageUrl");
            String uploadPath = getServletContext().getRealPath("/") + "uploads";
            String imageUrl = (imagePart != null && imagePart.getSize() > 0) ? handleFileUpload(imagePart, uploadPath) : null;

            Event event = new Event();
            event.setEventID(0); // Will be set by DAO
            event.setName(eventName);
            event.setDescription(eventDescription);
            event.setPhysicalLocation(physicalLocation);
            event.setStartTime(startTime);
            event.setEndTime(endTime);
            event.setTotalTicketCount(totalTicketCount);
            event.setIsApproved(false);
            event.setStatus("pending");
            event.setGenreID(genreID);
            event.setOwnerID(userID);
            // event.setImageUrl(imageUrl);
            event.setHasSeatingChart(hasSeatingChart);
            event.setIsDeleted(false);
            // event.setCreatedAt(LocalDateTime.now());
            // event.setUpdatedAt(LocalDateTime.now());

            TicketInfo ticketInfo = new TicketInfo();
            ticketInfo.setTicketInfoID(0); // Will be set by DAO
            ticketInfo.setTicketName(eventName + " Standard Ticket");
            ticketInfo.setTicketDescription("Standard admission for " + eventName);
            ticketInfo.setCategory("Standard");
            ticketInfo.setPrice(ticketPrice);
            ticketInfo.setSalesStartTime(startTime.toInstant().atZone(ZoneId.systemDefault()).toLocalDateTime());
            ticketInfo.setSalesEndTime(endTime.toInstant().atZone(ZoneId.systemDefault()).toLocalDateTime());
            ticketInfo.setMaxQuantityPerOrder(10);
            ticketInfo.setActive(true);
            ticketInfo.setAvailableQuantity(totalTicketCount);
            ticketInfo.setCreatedAt(LocalDateTime.now());
            ticketInfo.setUpdatedAt(LocalDateTime.now());

            TicketInventory ticketInventory = new TicketInventory();
            ticketInventory.setTicketInfoID(0); // Will be set by DAO
            ticketInventory.setTotalQuantity(totalTicketCount);
            ticketInventory.setSoldQuantity(0);
            ticketInventory.setReservedQuantity(0);

            Promotion promotion = null; // Can be extended with promotion form fields if needed

            // eventDao.createEvent(event, ticketInfo, ticketInventory, promotion, null);

            session.setAttribute("successMessage", "Event created successfully! Awaiting approval.");
            response.sendRedirect(request.getContextPath() + "/createEvent?action=list");
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error creating event: " + e.getMessage());
            showDashboard(request, response);
        }
    }

    private void listEvents(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userID = (Integer) session.getAttribute("userID");
        List<Event> events = (userID != null) ? new ArrayList<>() : eventDao.getAllApprovedEvents();
        request.setAttribute("events", events);
        request.getRequestDispatcher("/CreateEvent/event-list.jsp").forward(request, response);
    }

    private void viewEvent(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int eventID = Integer.parseInt(request.getParameter("eventID"));
        Event event = eventDao.getEventById(eventID);
        if (event != null) {
            request.setAttribute("event", event);
            request.getRequestDispatcher("/WEB-INF/views/event-view.jsp").forward(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Event not found");
        }
    }

    private void editEvent(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int eventID = Integer.parseInt(request.getParameter("eventID"));
        Event event = eventDao.getEventById(eventID);
        if (event != null) {
            HttpSession session = request.getSession();
            Integer userID = (Integer) session.getAttribute("userID");
            if (userID == null || userID != event.getOwnerID()) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
                return;
            }
            GenreDAO genreDao = new GenreDAO();
            List<Genre> genres = genreDao.getAllGenres();
            request.setAttribute("event", event);
            request.setAttribute("genres", genres);
            request.getRequestDispatcher("/WEB-INF/views/edit-event.jsp").forward(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Event not found");
        }
    }

    private void updateEvent(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userID = (Integer) session.getAttribute("userID");
        if (userID == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int eventID = Integer.parseInt(request.getParameter("eventID"));
        Event event = eventDao.getEventById(eventID);
        if (event == null || userID != event.getOwnerID()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied or event not found");
            return;
        }

        event.setName(request.getParameter("eventName"));
        event.setDescription(request.getParameter("eventDescription"));
        event.setPhysicalLocation(request.getParameter("physicalLocation"));
        String startTimeStr = request.getParameter("startTime");
        String endTimeStr = request.getParameter("endTime");
        if (startTimeStr != null && !startTimeStr.isEmpty()) {
            event.setStartTime(Timestamp.valueOf(startTimeStr.replace("T", " ") + ":00"));
        }
        if (endTimeStr != null && !endTimeStr.isEmpty()) {
            event.setEndTime(Timestamp.valueOf(endTimeStr.replace("T", " ") + ":00"));
        }
        String totalTicketCountStr = request.getParameter("totalTicketCount");
        if (totalTicketCountStr != null && !totalTicketCountStr.isEmpty()) {
            event.setTotalTicketCount(Integer.parseInt(totalTicketCountStr));
        }
        String genreIDStr = request.getParameter("genreID");
        if (genreIDStr != null && !genreIDStr.isEmpty()) {
            event.setGenreID(Integer.parseInt(genreIDStr));
        }
        event.setHasSeatingChart("true".equals(request.getParameter("hasSeatingChart")));
        // event.setUpdatedAt(LocalDateTime.now());

        Part imagePart = request.getPart("imageUrl");
        if (imagePart != null && imagePart.getSize() > 0) {
            String uploadPath = getServletContext().getRealPath("/") + "uploads";
            // event.setImageUrl(handleFileUpload(imagePart, uploadPath));
        }

        if (eventDao.updateEvent(event).isSuccess()) {
            session.setAttribute("successMessage", "Event updated successfully!");
            response.sendRedirect(request.getContextPath() + "/createEvent?action=list");
        } else {
            request.setAttribute("errorMessage", "Failed to update event.");
            editEvent(request, response);
        }
    }

    private void deleteEvent(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int eventID = Integer.parseInt(request.getParameter("eventID"));
        Event event = eventDao.getEventById(eventID);
        if (event != null) {
            HttpSession session = request.getSession();
            Integer userID = (Integer) session.getAttribute("userID");
            if (userID == null || userID != event.getOwnerID()) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
                return;
            }
            if (eventDao.deleteEvent(eventID).isSuccess()) {
                session.setAttribute("successMessage", "Event deleted successfully!");
            } else {
                session.setAttribute("errorMessage", "Failed to delete event.");
            }
            response.sendRedirect(request.getContextPath() + "/createEvent?action=list");
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Event not found");
        }
    }

    private String handleFileUpload(Part filePart, String uploadPath) throws IOException {
        if (filePart == null || filePart.getSize() == 0) return null;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdirs();
        String fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
        filePart.write(uploadPath + File.separator + fileName);
        return "uploads/" + fileName;
    }
}