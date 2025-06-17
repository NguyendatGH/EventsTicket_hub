package controller;

import context.DBConnection;
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
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import models.Event;
import models.Genre;
import models.Promotion;
import utils.FileUploadUtil;

@WebServlet("/createEvent")
@MultipartConfig(maxFileSize = 16177215) // 16MB
public class EventOwerservlet extends HttpServlet {
    
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
            // updateEvent(request, response); todo
        }
    }
    
    // CREATE - Show create form
    private void showCreateForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try (Connection conn = DBConnection.getConnection()) {
            GenreDAO genreDAO = new GenreDAO();
            List<Genre> genres = genreDAO.getAllGenres();
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
        
        try (Connection conn = DBConnection.getConnection()) {
            // Get user ID from session
            HttpSession session = request.getSession();
            Integer userId = (Integer) session.getAttribute("userId");
            if (userId == null) {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }
            
            // Create Event object from form data
            Event event = createEventFromRequest(request, userId);
            
            // Handle file upload
            handleFileUpload(request, event);
            
            // Set additional fields required by EventDAO
            event.setCreatedAt(new Timestamp(System.currentTimeMillis()));
            event.setUpdatedAt(new Timestamp(System.currentTimeMillis()));
            event.setIsApproved(false); // Default for new events
            event.setIsDeleted(false);
            event.setStatus("pending"); // Default status
            event.setRanking(0L); // Default ranking
            
            // Save to database
            EventDAO eventDAO = new EventDAO();
            boolean success = eventDAO.createEvent(event);
            
            if (success) {
                // Handle promotion if enabled
                // handlePromotion(request, event.getEventID(), conn); need to check again
                
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
        
        try (Connection conn = DBConnection.getConnection()) {
            HttpSession session = request.getSession();
            Integer userId = (Integer) session.getAttribute("userId");
            
            EventDAO eventDAO = new EventDAO();
            List<Event> events = new ArrayList<>(); // Initialize the events list
            
            if (userId != null) {
                // events = eventDAO.getEventsByUserId(userId); // todo
            } else {
                events = eventDAO.getAllApprovedEvents();
            }
            
            request.setAttribute("events", events);
            // request.getRequestDispatcher("/WEB-INF/views/event-list.jsp").forward(request, response);  
            // need to create this file
            
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
            
            try (Connection conn = DBConnection.getConnection()) {
                EventDAO eventDAO = new EventDAO();
                Event event = eventDAO.getEventById(eventId);
                
                if (event != null) {
                    // Get promotions for this event
                    PromotionDAO promotionDAO = new PromotionDAO();
                    List<Promotion> promotions = promotionDAO.getPromotionsByEventId(eventId);
                    
                    request.setAttribute("event", event);
                    request.setAttribute("promotions", promotions);
                    // request.getRequestDispatcher("/WEB-INF/views/event-view.jsp").forward(request, response);  todo
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

            try (Connection conn = DBConnection.getConnection()) {
                EventDAO eventDAO = new EventDAO();
                Event event = eventDAO.getEventById(eventId);

                if (event != null) {
                    // Check if user owns this event
                    HttpSession session = request.getSession();
                    Integer userId = (Integer) session.getAttribute("userId");

                    if (userId == null || !userId.equals(event.getOwnerID())) {
                        response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
                        return;
                    }

                    // Get genres for dropdown
                    GenreDAO genreDAO = new GenreDAO();
                    List<Genre> genres = genreDAO.getAllGenres();

                    request.setAttribute("event", event);
                    request.setAttribute("genres", genres);
                    // request.getRequestDispatcher("/WEB-INF/views/edit-event.jsp").forward(request, response);  todo
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
    
    // DELETE - Delete event
    private void deleteEvent(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            int eventId = Integer.parseInt(request.getParameter("id"));
            
            try (Connection conn = DBConnection.getConnection()) {
                EventDAO eventDAO = new EventDAO();
                Event event = eventDAO.getEventById(eventId);
                
                if (event != null) {
                    // Check ownership
                    HttpSession session = request.getSession();
                    Integer userId = (Integer) session.getAttribute("userId");
                    
                    if (userId == null || !userId.equals(event.getOwnerID())) {
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
        
        event.setName(request.getParameter("eventName")); // Mapped to 'name' in Event.java
        event.setDescription(request.getParameter("eventInfo")); // Mapped to 'description'
        event.setPhysicalLocation(buildPhysicalLocation(request)); // Consolidated address fields
        
        // Handle datetime inputs
        String startTime = request.getParameter("startTime");
        String endTime = request.getParameter("endTime");
        
        if (startTime != null && !startTime.isEmpty()) {
            event.setStartTime(Timestamp.valueOf(startTime.replace("T", " ") + ":00"));
        }
        if (endTime != null && !endTime.isEmpty()) {
            event.setEndTime(Timestamp.valueOf(endTime.replace("T", " ") + ":00"));
        }
        
        event.setHasSeatingChart("true".equals(request.getParameter("hasSeat")));
        
        String totalTickets = request.getParameter("totalTickets");
        if (totalTickets != null && !totalTickets.isEmpty()) {
            event.setTotalTicketCount(Integer.parseInt(totalTickets));
        }
        
        // Organizer info could be part of description or stored separately
        String organizerInfo = request.getParameter("organizerName") + ": " + 
                             (request.getParameter("organizerInfo") != null ? request.getParameter("organizerInfo") : "");
        event.setDescription(event.getDescription() + "\n" + organizerInfo);
        
        String genreId = request.getParameter("genreId");
        if (genreId != null && !genreId.isEmpty()) {
            event.setGenreID(Integer.parseInt(genreId));
        }
        
        event.setOwnerID(userId);
        
        return event;
    }
    
    // Build physical location from address components
    private String buildPhysicalLocation(HttpServletRequest request) {
        StringBuilder location = new StringBuilder();
        String locationName = request.getParameter("locationName");
        String streetNumber = request.getParameter("streetNumber");
        String ward = request.getParameter("ward");
        String district = request.getParameter("district");
        String province = request.getParameter("province");
        
        if (locationName != null && !locationName.isEmpty()) {
            location.append(locationName).append(", ");
        }
        if (streetNumber != null && !streetNumber.isEmpty()) {
            location.append(streetNumber).append(", ");
        }
        if (ward != null && !ward.isEmpty()) {
            location.append(ward).append(", ");
        }
        if (district != null && !district.isEmpty()) {
            location.append(district).append(", ");
        }
        if (province != null && !province.isEmpty()) {
            location.append(province);
        }
        
        return location.toString().replaceAll(", $", "");
    }
    
    // Handle file upload for new events
    private void handleFileUpload(HttpServletRequest request, Event event) throws Exception {
        String uploadPath = getServletContext().getRealPath("/") + "uploads";
        
        Part imagePart = request.getPart("eventImage"); // Consolidated to single image field
        
        if (imagePart != null && imagePart.getSize() > 0) {
            String fileName = FileUploadUtil.saveFile(imagePart, uploadPath);
            event.setImageURL(fileName);
        }
    }
}