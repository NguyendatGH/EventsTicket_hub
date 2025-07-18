package controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import dao.EventDAO;
import dao.GenreDAO;
import dao.PromotionDAO;
import dto.TransactionDTO;
import dto.UserDTO;
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
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import models.Event;
import models.Genre;
import models.Promotion;
import models.TicketInfo;
import models.TicketInventory;
import models.TicketType;
import service.EventService;
import utils.ToggleEvent;

@WebServlet("/organizer-servlet")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, maxFileSize = 1024 * 1024 * 16, maxRequestSize = 1024 * 1024 * 50)
public class EventOwnerServlet extends HttpServlet {

    private EventService eventServive;
    private EventDAO eventDao;
    private GenreDAO genreDAO;

    @Override
    public void init() throws ServletException {
        eventDao = new EventDAO();
        genreDAO = new GenreDAO();
        eventServive = new EventService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        UserDTO u = (UserDTO) session.getAttribute("user");
        if (u == null) {
            response.sendRedirect(request.getContextPath() + "/authentication/login.jsp");
            return;
        }
        String action = request.getParameter("action");
        if (action == null || "dashboard".equals(action)) {
            showDashboard(request, response);
        } else if ("createForm".equals(action)) {
            showCreateEventForm(request, response);
        } else {
            switch (action) {
                case "list":
                    listEvents(request, response);
                    break;
                case "edit":
                    System.out.println("do edit");
                    editEvent(request, response);
                    break;
                case "delete":
                    deleteEvent(request, response);
                    break;
                case "view":
                    viewEvent(request, response);
                    break;
                case "step1":
                    showStep1Form(request, response);
                case "step2":
                    System.out.println("show step2");
                    showStep2Form(request, response);
                    break;
                case "step3":
                    showStep3Form(request, response);
                    break;
                case "step4":
                    showStep4Form(request, response);
                    break;
                default:
                    showDashboard(request, response);
            }
        }

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("user") == null) {
            System.out.println("User not logged in, redirecting to login page");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        }
        switch (action) {
            case "step1":
                processStep1(request, response);
                break;
            case "step2":
                System.out.println("process to step2");
                processStep2(request, response);
                break;
            case "step3":
                processStep3(request, response);
                break;
            case "edit":
                System.out.println("process to edit");
                editEvent(request, response);
                break;
            case "create":
                createEvent(request, response);
                break;
            case "delete":
                deleteEvent(request, response);
                break;
            case "update":
                updateEvent(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/organizer-servlet");
                break;
        }
    }

    private void showTransactions(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        UserDTO user = (UserDTO) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/authentication/login.jsp");
            return;
        }

        // Pagination
        int page = 1;
        int pageSize = 10;

        try {
            page = Integer.parseInt(request.getParameter("page"));
        } catch (NumberFormatException e) {
            page = 1;
        }

        List<TransactionDTO> transactions = eventDao.getTransactionsByOwner(user.getId(), page, pageSize);
        int totalCount = eventDao.getTransactionCountByOwner(user.getId());
        int totalPages = (int) Math.ceil((double) totalCount / pageSize);

        // Summary data
        BigDecimal totalSales = eventDao.getTotalRevenueByOwner(user.getId());
        int totalTickets = eventDao.getTotalTicketsSoldByOwner(user.getId());
        int refundRequests = eventDao.getRefundRequestsCountByOwner(user.getId());

        request.setAttribute("transactions", transactions);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("totalSales", totalSales);
        request.setAttribute("totalTickets", totalTickets);
        request.setAttribute("refundRequests", refundRequests);

        request.getRequestDispatcher("/ticketTransaction.jsp").forward(request, response);
    }

    // Pagination parameters
    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        UserDTO u = (UserDTO) session.getAttribute("user");

        List<Event> activeEvents = eventServive.getActiveEvents();
        List<Event> myEvents = eventServive.getAllMyEvent(u.getId());

        // Log kiểm tra
        if (myEvents.isEmpty()) {
            System.out.println("No events found for user ID: " + u.getId());
        } else {
            System.out.println("Found " + myEvents.size() + " events for user ID: " + u.getId());
        }

        // Thiết lập phân trang cho activeEvents
        int pageSize = 5;
        int currentPage = 1;
        try {
            currentPage = Integer.parseInt(request.getParameter("page"));
        } catch (NumberFormatException e) {
            currentPage = 1;
        }
        int totalPages = (int) Math.ceil((double) activeEvents.size() / pageSize);

        // Thiết lập phân trang cho myEvents
        int myEventsCurrentPage = 1;
        try {
            myEventsCurrentPage = Integer.parseInt(request.getParameter("myEventsPage"));
        } catch (NumberFormatException e) {
            myEventsCurrentPage = 1;
        }
        int myEventsTotalPages = (int) Math.ceil((double) myEvents.size() / pageSize);

        // Đặt các thuộc tính vào request
        request.setAttribute("activeEvents", activeEvents);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalEventsNumber", eventServive.getTotalEventsCount());

        // Thêm các thuộc tính cho myEvents
        request.setAttribute("myEvents", myEvents);
        request.setAttribute("myEventsCurrentPage", myEventsCurrentPage);
        request.setAttribute("myEventsPageSize", pageSize);
        request.setAttribute("myEventsTotalPages", myEventsTotalPages);

        request.getRequestDispatcher("/createEvent/dashBoard.jsp").forward(request, response);
    }

    private void showCreateEventForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Genre> genres = genreDAO.getAllGenres();
        request.setAttribute("genres", genres);
        System.out.println("Genres for CreateEvent.jsp: " + (genres != null ? genres.size() : "null"));
        request.getRequestDispatcher("/createEvent/CreateEvent.jsp").forward(request, response);
    }

    private void showStep1Form(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Genre> genres = genreDAO.getAllGenres();
        request.setAttribute("genres", genres);
        Event event = (Event) request.getSession().getAttribute("event");
        if (event == null) {
            event = new Event();
        }
        request.setAttribute("event", event);
        request.getRequestDispatcher("/createEvent/CreateEvent.jsp").forward(request, response);
    }

    private void showStep2Form(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Event event = (Event) request.getSession().getAttribute("event");
        if (event == null) {
            event = new Event();
        }
        request.setAttribute("event", event);
        request.getRequestDispatcher("/createEvent/TimeAndType.jsp").forward(request, response);
    }

    private void showStep3Form(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Event event = (Event) request.getSession().getAttribute("event");
        if (event == null) {
            event = new Event();
        }
        request.setAttribute("event", event);
        request.getRequestDispatcher("/createEvent/Settings.jsp").forward(request, response);
    }

    private void showStep4Form(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Event event = (Event) request.getSession().getAttribute("event");
        if (event == null) {
            event = new Event();
        }
        request.setAttribute("event", event);
        request.getRequestDispatcher("/createEvent/Payment.jsp").forward(request, response);
    }

    private void processStep1(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Event event = (Event) session.getAttribute("event");
        if (event == null) {
            event = new Event();
        }
        event.setName(request.getParameter("name"));
        event.setPhysicalLocation(request.getParameter("physicalLocation"));
        try {
            event.setGenreID(Integer.parseInt(request.getParameter("genreID")));
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid genre selection");
            showStep1Form(request, response);
            return;
        }
        event.setDescription(request.getParameter("description"));
         event.setImageURL(request.getParameter("imageURL"));
         System.out.println("event data : " +event.getImageURL());
        session.setAttribute("event", event);
        response.sendRedirect(request.getContextPath() + "/organizer-servlet?action=step2");
    }

    private void processStep2(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Event event = (Event) session.getAttribute("event");
        if (event == null) {
            event = new Event();
        }
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
            event.setStartTime(sdf.parse(request.getParameter("startTime")));
            event.setEndTime(sdf.parse(request.getParameter("endTime")));
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Invalid date format");
            showStep2Form(request, response);
            return;
        }
        session.setAttribute("event", event);
        response.sendRedirect(request.getContextPath() + "/organizer-servlet?action=step3");
    }

    private void processStep3(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Event event = (Event) session.getAttribute("event");
        if (event == null) {
            event = new Event();
        }
        event.setHasSeatingChart("true".equals(request.getParameter("hasSeatingChart")));
        event.setStatus(request.getParameter("status"));
        session.setAttribute("event", event);
        response.sendRedirect(request.getContextPath() + "/organizer-servlet?action=step4");
    }

    private void createEvent(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        UserDTO u = (UserDTO) session.getAttribute("user");
        Event event = (Event) session.getAttribute("event");
        if (event == null) {
            event = new Event();
        }
        int totalTicketCount;
        try {
            totalTicketCount = Integer.parseInt(request.getParameter("totalTicketCount"));
            // event.setTotalTicketCount(Integer.parseInt(request.getParameter("totalTicketCount")));
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid ticket count");
            showStep4Form(request, response);
            return;
        }
        List<TicketType> ticketTypes = new ArrayList<>();
        String[] ticketNames = request.getParameterValues("ticketName[]");
        String[] ticketPrices = request.getParameterValues("ticketPrice[]");
        String[] ticketQuantities = request.getParameterValues("ticketQuantity[]");
        if (ticketNames == null || ticketPrices == null || ticketQuantities == null
                || ticketNames.length != ticketPrices.length || ticketNames.length != ticketQuantities.length) {
            request.setAttribute("errorMessage", "Invalid ticket type data");
            showStep4Form(request, response);
            return;
        }

        int totalQuantity = 0;
        for (int i = 0; i < ticketNames.length; i++) {
            try {
                String name = ticketNames[i].trim();
                BigDecimal price = new BigDecimal(ticketPrices[i]);
                int quantity = Integer.parseInt(ticketQuantities[i]);
                if (name.isEmpty() || price.compareTo(BigDecimal.ZERO) < 0 || quantity <= 0) {
                    request.setAttribute("errorMessage",
                            "Invalid ticket name, price, or quantity for ticket type " + (i + 1));
                    showStep4Form(request, response);
                    return;
                }
                ticketTypes.add(new TicketType(name, price, quantity));
                totalQuantity += quantity;
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid price or quantity format for ticket type " + (i + 1));
                showStep4Form(request, response);
                return;
            }
        }

        if (totalQuantity != totalTicketCount) {
            request.setAttribute("errorMessage", "Sum of ticket quantities must equal total ticket count");
            showStep4Form(request, response);
            return;
        }

        event.setTotalTicketCount(totalTicketCount);
        event.setEventID(0); // Assume database generates eventID
        event.setOwnerID(u.getId());
        event.setIsApproved(false);
        event.setIsDeleted(false);
        event.setCreatedAt(new Date());
        event.setUpdatedAt(new Date());
        event.setRanking(0L);
        System.out.println("Creating event with details: "
                + "name=" + event.getName()
                + ", description=" + event.getDescription()
                + ", physicalLocation=" + event.getPhysicalLocation()
                + ", startTime=" + event.getStartTime()
                + ", endTime=" + event.getEndTime()
                + ", totalTicketCount=" + event.getTotalTicketCount()
                + ", isApproved=" + event.getIsApproved()
                + ", status=" + event.getStatus()
                + ", genreID=" + event.getGenreID()
                + ", ownerID=" + event.getOwnerID()
                + ", imageURL=" + event.getImageURL()
                + ", hasSeatingChart=" + event.getHasSeatingChart()
                + ", isDeleted=" + event.getIsDeleted()
                + ", createdAt=" + event.getCreatedAt()
                + ", updatedAt=" + event.getUpdatedAt()
                + ", ticketTypes=" + ticketTypes.size());

        ToggleEvent result;
        try {
            result = eventDao.createEvent(event, ticketTypes);
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Failed to create event: " + e.getMessage());
            request.getRequestDispatcher("/createEvent/Payment.jsp").forward(request, response);
            return;
        }
        if (result.isSuccess()) {
            session.removeAttribute("event");
            request.setAttribute("successMessage", result.getMessage()); // Set success message for Payment.jsp
            request.getRequestDispatcher("/createEvent/Payment.jsp").forward(request, response);
        } else {
            request.setAttribute("errorMessage", result.getMessage());
            showStep4Form(request, response);
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

    private void updateEvent(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("Processing update event request");
        String eventIDStr = request.getParameter("eventID");
        System.out.println("event Id for updating: " + eventIDStr);
        int eventID;
        try {
            eventID = Integer.parseInt(eventIDStr);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID sự kiện không hợp lệ");
            request.setAttribute("editMode", true);
            request.getRequestDispatcher("/createEvent/EditEventPage.jsp").forward(request, response);
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
            request.getRequestDispatcher("/createEvent/EditEventPage.jsp").forward(request, response);
            return;
        }

        try {
            event.setTotalTicketCount(Integer.parseInt(request.getParameter("totalTicketCount")));
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Số lượng vé không hợp lệ");
            request.setAttribute("event", event);
            request.setAttribute("editMode", true);
            request.getRequestDispatcher("/createEvent/EditEventPage.jsp").forward(request, response);
            return;
        }

        System.out.println("Event update: " + event);

        ToggleEvent updateResult = eventServive.updateEvent(event);
        if (updateResult.isSuccess()) {
            request.setAttribute("success", updateResult.getMessage());
            request.setAttribute("event", eventServive.getEventById(eventID)); // Refresh event data
            request.setAttribute("editMode", true);
            request.getRequestDispatcher("/createEvent/EditEventPage.jsp").forward(request, response);
        } else {
            request.setAttribute("error", updateResult.getMessage());
            request.setAttribute("event", event);
            request.setAttribute("editMode", true);
            request.getRequestDispatcher("/createEvent/EditEventPage.jsp").forward(request, response);
        }
    }

    private void editEvent(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String eventIDStr = request.getParameter("eventID");
        System.out.println("Edit Event - Parameters received: " +eventIDStr);

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

        Event event = eventServive.getEventById(eventID);
        if (event == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy sự kiện");
            return;
        }
        System.out.println("evvent to edit " +event);

        request.setAttribute("event", event);
        //request.setAttribute("editMode", true);
        request.getRequestDispatcher("/createEvent/EditEventPage.jsp").forward(request, response);
    }

//    private void editEvent(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        int eventID = Integer.parseInt(request.getParameter("eventID"));
//        Event event = eventDao.getEventById(eventID);
//        if (event != null) {
//            HttpSession session = request.getSession();
//            UserDTO user = (UserDTO) session.getAttribute("user");
//
//            // Kiểm tra quyền sở hữu
//            if (user == null || user.getId() != event.getOwnerID()) {
//                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
//                return;
//            }
//
//            // Đặt dữ liệu sự kiện vào request
//            request.setAttribute("event", event);
//
//            // Chuyển hướng đến trang edit
//            request.getRequestDispatcher("/createEvent/EditEventPage.jsp").forward(request, response);
//        } else {
//            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Event not found");
//        }
//    }
//
//    private void updateEvent(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        HttpSession session = request.getSession();
//        Integer userID = (Integer) session.getAttribute("userID");
//        if (userID == null) {
//            response.sendRedirect(request.getContextPath() + "/login.jsp");
//            return;
//        }
//
//        int eventID = Integer.parseInt(request.getParameter("eventID"));
//        Event event = eventDao.getEventById(eventID);
//        if (event == null || userID != event.getOwnerID()) {
//            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied or event not found");
//            return;
//        }
//
//        event.setName(request.getParameter("eventName"));
//        event.setDescription(request.getParameter("eventDescription"));
//        event.setPhysicalLocation(request.getParameter("physicalLocation"));
//        String startTimeStr = request.getParameter("startTime");
//        String endTimeStr = request.getParameter("endTime");
//        if (startTimeStr != null && !startTimeStr.isEmpty()) {
//            event.setStartTime(Timestamp.valueOf(startTimeStr.replace("T", " ") + ":00"));
//        }
//        if (endTimeStr != null && !endTimeStr.isEmpty()) {
//            event.setEndTime(Timestamp.valueOf(endTimeStr.replace("T", " ") + ":00"));
//        }
//        String totalTicketCountStr = request.getParameter("totalTicketCount");
//        if (totalTicketCountStr != null && !totalTicketCountStr.isEmpty()) {
//            event.setTotalTicketCount(Integer.parseInt(totalTicketCountStr));
//        }
//        String genreIDStr = request.getParameter("genreID");
//        if (genreIDStr != null && !genreIDStr.isEmpty()) {
//            event.setGenreID(Integer.parseInt(genreIDStr));
//        }
//        event.setHasSeatingChart("true".equals(request.getParameter("hasSeatingChart")));
//        // event.setUpdatedAt(LocalDateTime.now());
//
//        Part imagePart = request.getPart("imageUrl");
//        if (imagePart != null && imagePart.getSize() > 0) {
//            String uploadPath = getServletContext().getRealPath("/") + "uploads";
//            // event.setImageUrl(handleFileUpload(imagePart, uploadPath));
//        }
//
//        if (eventDao.updateEvent(event).isSuccess()) {
//            session.setAttribute("successMessage", "Event updated successfully!");
//            response.sendRedirect(request.getContextPath() + "/createEvent?action=list");
//        } else {
//            request.setAttribute("errorMessage", "Failed to update event.");
//            editEvent(request, response);
//        }
//    }
    private void deleteEvent(HttpServletRequest request, HttpServletResponse response)
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
            System.out.println("eventid :" + eventID);
        } catch (NumberFormatException e) {
            responseMap.put("success", false);
            responseMap.put("message", "ID sự kiện không hợp lệ");
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            mapper.writeValue(response.getWriter(), responseMap);
            return;
        }

        ToggleEvent deleteResult = eventServive.deleteEvent(eventID);
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

    private String handleFileUpload(Part filePart, String uploadPath) throws IOException {
        if (filePart == null || filePart.getSize() == 0) {
            return null;
        }
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
        String fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
        filePart.write(uploadPath + File.separator + fileName);
        return "uploads/" + fileName;
    }
}
