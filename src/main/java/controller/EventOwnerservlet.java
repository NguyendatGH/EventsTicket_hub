package controller;


import context.DatabaseConnection;
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
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.List;
import model.Event;
import model.Genre;
import model.Promotion;
import utils.FileUploadUtil;

@WebServlet("/createEvent")
@MultipartConfig(maxFileSize = 16177215) // 16MB
public class EventServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if (action == null) {
            // Show create form
            showCreateForm(request, response);
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
                    showCreateForm(request, response);
            }
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if (action == null || action.equals("create")) {
            createEvent(request, response);
        } else if (action.equals("update")) {
            updateEvent(request, response);
        }
    }
    
    // CREATE - Show create form
    private void showCreateForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try (Connection conn = DatabaseConnection.getConnection()) {
            GenreDAO genreDAO = new GenreDAO(conn);
            List<GenreDAO> genres = genreDAO.getAllGenres();
            request.setAttribute("genres", genres);
            
            request.getRequestDispatcher("/WEB-INF/CreateEvent.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error");
        }
    }
    
    // CREATE - Handle form submission
    private void createEvent(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try (Connection conn = DatabaseConnection.getConnection()) {
            // Get user ID from session
            HttpSession session = request.getSession();
            Integer userId = (Integer) session.getAttribute("userId");
            if (userId == null) {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }
            
            // Create Event object from form data
            Event event = createEventFromRequest(request, userId);
            
            // Handle file uploads
            handleFileUploads(request, event);
            
            // Save to database
            EventDAO eventDAO = new EventDAO(conn);
            boolean success = eventDAO.createEvent(event);
            
            if (success) {
                // Handle promotion if enabled
                handlePromotion(request, event.getEventID(), conn);
                
                session.setAttribute("successMessage", "Event created successfully!");
                response.sendRedirect(request.getContextPath() + "/createEvent?action=list");
            } else {
                request.setAttribute("errorMessage", "Failed to create event. Please try again.");
                showCreateForm(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error: " + e.getMessage());
            showCreateForm(request, response);
        }
    }
    
    // READ - List all events
    private void listEvents(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try (Connection conn = DatabaseConnection.getConnection()) {
            HttpSession session = request.getSession();
            Integer userId = (Integer) session.getAttribute("userId");
            
            EventDAO eventDAO = new EventDAO(conn);
            List<Event> events;
            
            if (userId != null) {
                events = eventDAO.getEventsByUserId(userId);
            } else {
                events = eventDAO.getAllActiveEvents();
            }
            
            request.setAttribute("events", events);
            request.getRequestDispatcher("/WEB-INF/views/event-list.jsp").forward(request, response);
            
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error");
        }
    }
    
    // READ - View single event
    private void viewEvent(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            int eventId = Integer.parseInt(request.getParameter("id"));
            
            try (Connection conn = DatabaseConnection.getConnection()) {
                EventDAO eventDAO = new EventDAO(conn);
                Event event = eventDAO.getEventById(eventId);
                
                if (event != null) {
                    // Get promotions for this event
                    PromotionDAO promotionDAO = new PromotionDAO(conn);
                    List<Promotion> promotions = promotionDAO.getPromotionsByEventId(eventId);
                    
                    request.setAttribute("event", event);
                    request.setAttribute("promotions", promotions);
                    request.getRequestDispatcher("/WEB-INF/views/event-view.jsp").forward(request, response);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Event not found");
                }
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid event ID");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error");
        }
    }
    
// UPDATE - Show edit form
private void editEvent(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {

    try {
        int eventId = Integer.parseInt(request.getParameter("id"));

        try (Connection conn = DatabaseConnection.getConnection()) {
            EventDAO eventDAO = new EventDAO(conn);
            Event event = eventDAO.getEventById(eventId);

            if (event != null) {
                // Check if user owns this event
                HttpSession session = request.getSession();
                Integer userId = (Integer) session.getAttribute("userId");

                if (userId == null || !userId.equals(event.getUserID())) {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
                    return;
                }

                // Get genres for dropdown
                GenreDAO genreDAO = new GenreDAO(conn);
                List<GenreDAO> genres = genreDAO.getAllGenres();

                request.setAttribute("event", event);
                request.setAttribute("genres", genres);
                request.getRequestDispatcher("/WEB-INF/views/edit-event.jsp").forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Event not found");
            }
        }
    } catch (NumberFormatException e) {
        response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid event ID");
    } catch (SQLException e) {
        e.printStackTrace();
        response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error");
    }
}

    
    // UPDATE - Handle update form submission
    private void updateEvent(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            int eventId = Integer.parseInt(request.getParameter("eventId"));
            
            try (Connection conn = DatabaseConnection.getConnection()) {
                EventDAO eventDAO = new EventDAO(conn);
                Event existingEvent = eventDAO.getEventById(eventId);
                
                if (existingEvent != null) {
                    // Check ownership
                    HttpSession session = request.getSession();
                    Integer userId = (Integer) session.getAttribute("userId");
                    
                    if (userId == null || !userId.equals(existingEvent.getUserID())) {
                        response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
                        return;
                    }
                    
                    // Update event data
                    Event updatedEvent = createEventFromRequest(request, userId);
                    updatedEvent.setEventID(eventId);
                    
                    // Handle file uploads (keep existing images if no new ones uploaded)
                    handleFileUploadsForUpdate(request, updatedEvent, existingEvent);
                    
                    boolean success = eventDAO.updateEvent(updatedEvent);
                    
                    if (success) {
                        session.setAttribute("successMessage", "Event updated successfully!");
                        response.sendRedirect(request.getContextPath() + "/createEvent?action=view&id=" + eventId);
                    } else {
                        request.setAttribute("errorMessage", "Failed to update event.");
                        editEvent(request, response);
                    }
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Event not found");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error: " + e.getMessage());
            editEvent(request, response);
        }
    }
    
    // DELETE - Delete event
    private void deleteEvent(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            int eventId = Integer.parseInt(request.getParameter("id"));
            
            try (Connection conn = DatabaseConnection.getConnection()) {
                EventDAO eventDAO = new EventDAO(conn);
                Event event = eventDAO.getEventById(eventId);
                
                if (event != null) {
                    // Check ownership
                    HttpSession session = request.getSession();
                    Integer userId = (Integer) session.getAttribute("userId");
                    
                    if (userId == null || !userId.equals(event.getUserID())) {
                        response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
                        return;
                    }
                    
                    boolean success = eventDAO.deleteEvent(eventId);
                    
                    if (success) {
                        session.setAttribute("successMessage", "Event deleted successfully!");
                    } else {
                        session.setAttribute("errorMessage", "Failed to delete event.");
                    }
                    
                    response.sendRedirect(request.getContextPath() + "/createEvent?action=list");
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Event not found");
                }
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid event ID");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error");
        }
    }
    
    // Helper method to create Event object from request parameters
    private Event createEventFromRequest(HttpServletRequest request, int userId) {
        Event event = new Event();
        
        event.setEventName(request.getParameter("eventName"));
        event.setEventInfo(request.getParameter("eventInfo"));
        event.setEventType(request.getParameter("eventType"));
        event.setLocationName(request.getParameter("locationName"));
        event.setProvince(request.getParameter("province"));
        event.setDistrict(request.getParameter("district"));
        event.setWard(request.getParameter("ward"));
        event.setStreetNumber(request.getParameter("streetNumber"));
        event.setFullAddress(request.getParameter("fullAddress"));
        
        // Handle datetime inputs
        String startTime = request.getParameter("startTime");
        String endTime = request.getParameter("endTime");
        
        if (startTime != null && !startTime.isEmpty()) {
            event.setStartTime(Timestamp.valueOf(startTime.replace("T", " ") + ":00"));
        }
        if (endTime != null && !endTime.isEmpty()) {
            event.setEndTime(Timestamp.valueOf(endTime.replace("T", " ") + ":00"));
        }
        
        event.setHasSeat("true".equals(request.getParameter("hasSeat")));
        
        String totalTickets = request.getParameter("totalTickets");
        if (totalTickets != null && !totalTickets.isEmpty()) {
            event.setTotalTickets(Integer.parseInt(totalTickets));
        }
        
        event.setOrganizerName(request.getParameter("organizerName"));
        event.setOrganizerInfo(request.getParameter("organizerInfo"));
        
        String genreId = request.getParameter("genreId");
        if (genreId != null && !genreId.isEmpty()) {
            event.setGenreID(Integer.parseInt(genreId));
        }
        
        event.setUserID(userId);
        
        return event;
    }
    
    // Handle file uploads for new events
    private void handleFileUploads(HttpServletRequest request, Event event) throws Exception {
        String uploadPath = getServletContext().getRealPath("/") + "uploads";
        
        Part logoPart = request.getPart("logoImage");
        Part backgroundPart = request.getPart("backgroundImage");
        Part sponsorPart = request.getPart("sponsorImage");
        
        if (logoPart != null && logoPart.getSize() > 0) {
            String logoFileName = utils.FileUploadUtil.saveFile(logoPart, uploadPath);
            event.setLogoImage(logoFileName);
        }
        
        if (backgroundPart != null && backgroundPart.getSize() > 0) {
            String backgroundFileName = FileUploadUtil.saveFile(backgroundPart, uploadPath);
            event.setBackgroundImage(backgroundFileName);
        }
        
        if (sponsorPart != null && sponsorPart.getSize() > 0) {
            String sponsorFileName = FileUploadUtil.saveFile(sponsorPart, uploadPath);
            event.setSponsorImage(sponsorFileName);
        }
    }
    
    // Handle file uploads for event updates
    private void handleFileUploadsForUpdate(HttpServletRequest request, Event updatedEvent, Event existingEvent) throws Exception {
        String uploadPath = getServletContext().getRealPath("/") + "uploads";
        
        Part logoPart = request.getPart("logoImage");
        Part backgroundPart = request.getPart("backgroundImage");
        Part sponsorPart = request.getPart("sponsorImage");
        
        // Logo image
        if (logoPart != null && logoPart.getSize() > 0) {
            String logoFileName = FileUploadUtil.saveFile(logoPart, uploadPath);
            updatedEvent.setLogoImage(logoFileName);
        } else {
            updatedEvent.setLogoImage(existingEvent.getLogoImage());
        }
        
        // Background image
        if (backgroundPart != null && backgroundPart.getSize() > 0) {
            String backgroundFileName = FileUploadUtil.saveFile(backgroundPart, uploadPath);
            updatedEvent.setBackgroundImage(backgroundFileName);
        } else {
            updatedEvent.setBackgroundImage(existingEvent.getBackgroundImage());
        }
        
        // Sponsor image
        if (sponsorPart != null && sponsorPart.getSize() > 0) {
            String sponsorFileName = FileUploadUtil.saveFile(sponsorPart, uploadPath);
            updatedEvent.setSponsorImage(sponsorFileName);
        } else {
            updatedEvent.setSponsorImage(existingEvent.getSponsorImage());
        }
    }
    
    // Handle promotion creation
    private void handlePromotion(HttpServletRequest request, int eventId, Connection conn) {
        String enablePromotion = request.getParameter("enablePromotion");
        
        if ("true".equals(enablePromotion)) {
            String promotionName = request.getParameter("promotionName");
            String promotionCode = request.getParameter("promotionCode");
            String promotionStartTime = request.getParameter("promotionStartTime");
            String promotionEndTime = request.getParameter("promotionEndTime");
            
            if (promotionName != null && !promotionName.isEmpty() && 
                promotionCode != null && !promotionCode.isEmpty()) {
                
                Promotion promotion = new Promotion();
                promotion.setEventID(eventId);
                promotion.setPromotionName(promotionName);
                promotion.setPromotionCode(promotionCode);
                promotion.setActive(true);
                
                if (promotionStartTime != null && !promotionStartTime.isEmpty()) {
                    promotion.setStartTime(Timestamp.valueOf(promotionStartTime.replace("T", " ") + ":00"));
                }
                if (promotionEndTime != null && !promotionEndTime.isEmpty()) {
                    promotion.setEndTime(Timestamp.valueOf(promotionEndTime.replace("T", " ") + ":00"));
                }
                
                PromotionDAO promotionDAO = new PromotionDAO(conn);
                promotionDAO.createPromotion(promotion);
            }
        }
    }
}
