package controller;

import dao.EventDAO;
import dao.GenreDAO;
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
import java.io.InputStream;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.UUID;
import java.util.logging.Logger;

import models.Event;
import models.Genre;
import models.TicketInfo;
import models.Zone;

import org.json.JSONArray;
import org.json.JSONObject;

import com.fasterxml.jackson.databind.ObjectMapper;

import service.EventService;
import utils.ToggleEvent;

@MultipartConfig(fileSizeThreshold = 1024 * 1024, // 1MB
        maxFileSize = 5 * 1024 * 1024, // 5MB
        maxRequestSize = 10 * 1024 * 1024 // 10MB
)
@WebServlet("/organizer-servlet")
public class EventOwnerServlet extends HttpServlet {
    private EventDAO eventDao;
    private GenreDAO genreDAO;
    private EventService eventService;
    private static final String UPLOAD_DIR = "uploads/event_banners";
    private static final Logger logger = Logger.getLogger(EventOwnerServlet.class.getName());

    @Override
    public void init() throws ServletException {
        eventDao = new EventDAO();
        eventService = new EventService();
        genreDAO = new GenreDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        System.out.println("received action: (doget)" + action);
        HttpSession session = request.getSession();
        Event event = (Event) session.getAttribute("event");
        if ("step4".equals(action) && event != null && event.getHasSeatingChart()) {
            if (session.getAttribute("ticketNames") == null) {
                logger.warning("Attempted to access step4 without ticketNames, redirecting to customizeSeats");
                response.sendRedirect(request.getContextPath() + "/organizer-servlet?action=customizeSeats");
                return;
            }
        }
        if (action == null || "dashboard".equals(action)) {
            showDashboard(request, response);
        } else if ("createForm".equals(action)) {
            showCreateEventForm(request, response);
        } else {
            switch (action) {
                case "edit":
                    editEvent(request, response);
                    break;
                case "delete":
                    deleteEvent(request, response);
                    break;
                case "step1":
                    showStep1Form(request, response);
                    break;
                case "step2":
                    showStep2Form(request, response);
                    break;
                case "step3":
                    showStep3Form(request, response);
                    break;
                case "createMap":
                    showCreateMapForm(request, response);
                    break;
                case "previewMap":
                    showPreviewMapForm(request, response);
                    break;
                case "customizeSeats":
                    showCustomizeSeatsForm(request, response);
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
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        if (action == null)
            action = "";
        switch (action) {
            case "step1":
                processStep1(request, response);
                break;
            case "step2":
                processStep2(request, response);
                break;
            case "step3":
                processStep3(request, response);
                break;
            case "createMap":
                processCreateMap(request, response);
                break;
            case "previewMap":
                processPreviewMap(request, response);
                break;
            case "customizeSeats":
                processCustomizeSeats(request, response);
                break;
            case "create":
                createEvent(request, response);
                break;
            case "update":
                updateEvent(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/organizer-servlet");
                break;
        }
    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        UserDTO user = (UserDTO) session.getAttribute("user");

        if (user == null) {
            logger.info("User not logged in, redirecting to login page");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Lấy userID của người dùng hiện tại
        int userID = user.getId();

        // Lấy tham số phân trang từ request
        int pageSize = 5; // Số lượng sự kiện mỗi trang
        int currentPage = 1;
        String pageParam = request.getParameter("myEventsPage");
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                currentPage = Integer.parseInt(pageParam);
                System.out.println("CURRENT PAGE: " +currentPage);
            } catch (NumberFormatException e) {
                System.out.println("Invalid page parameter: " + pageParam);
            }
        }

        // Lấy danh sách sự kiện của người dùng
        List<Event> myEvents = eventDao.getAllMyEvent(userID);
        
//        System.out.println("event of owner2: " +myEvents);
        // Tính toán phân trang
        int totalEvents = myEvents.size();
        int totalPages = (int) Math.ceil((double) totalEvents / pageSize);

        // Đảm bảo currentPage hợp lệ
        if (currentPage < 1) {
            currentPage = 1;
        } else if (currentPage > totalPages && totalPages > 0) {
            currentPage = totalPages;
        }

        // Lấy danh sách sự kiện cho trang hiện tại
        int start = (currentPage - 1) * pageSize;
        int end = Math.min(start + pageSize, totalEvents);
        List<Event> eventsForPage = myEvents.subList(start, end);
        session.setAttribute("eventsForPage", eventsForPage);
        for(Event e: eventsForPage){
            System.out.println("" + e);
        }
                
        // Lấy danh sách thể loại
        List<Genre> genres = genreDAO.getAllGenres();

        // Lấy thống kê sự kiện
        int totalTicketsSold = eventDao.getTotalTicketsSoldByOwner(userID);
//        BigDecimal totalRevenue = eventDao.getTotalRevenueByOwner(userID);

        // Đặt các thuộc tính để hiển thị trên JSP
        session.setAttribute("genres", genres);
        session.setAttribute("myEvents", eventsForPage);
        session.setAttribute("myEventsCurrentPage", currentPage);
        session.setAttribute("myEventsTotalPages", totalPages);
        session.setAttribute("myEventsPageSize", pageSize);
        session.setAttribute("totalEvents", totalEvents);
        session.setAttribute("totalTicketsSold", totalTicketsSold);
        session.setAttribute("totalRevenue", 123);

        // Xử lý thông báo thành công
        String successMessage = (String) session.getAttribute("successMessage");
        if (successMessage != null) {
            request.setAttribute("successMessage", successMessage);
            session.removeAttribute("successMessage");
        }

        // Chuyển hướng đến trang dashboard
        request.getRequestDispatcher("/eventOwner/dashBoard.jsp").forward(request, response);
    }

    private void showCreateEventForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Genre> genres = genreDAO.getAllGenres();
        request.setAttribute("genres", genres);
        request.getRequestDispatcher("/eventOwner/createEvent/CreateEvent.jsp").forward(request, response);
    }

    private void showStep1Form(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Genre> genres = genreDAO.getAllGenres();
        request.setAttribute("genres", genres);
        Event event = (Event) request.getSession().getAttribute("event");
        if (event == null)
            event = new Event();
        request.setAttribute("event", event);
        request.getRequestDispatcher("/eventOwner/createEvent/CreateEvent.jsp").forward(request, response);
    }

    private void showStep2Form(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Event event = (Event) request.getSession().getAttribute("event");
        if (event == null)
            event = new Event();
        request.setAttribute("event", event);
        request.getRequestDispatcher("/eventOwner/createEvent/TimeAndType.jsp").forward(request, response);
    }

    private void showStep3Form(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Event event = (Event) request.getSession().getAttribute("event");
        if (event == null)
            event = new Event();
        request.setAttribute("event", event);
        request.getRequestDispatcher("/eventOwner/createEvent/Settings.jsp").forward(request, response);
    }

    private void showCreateMapForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Event event = (Event) request.getSession().getAttribute("event");
        if (event == null || !event.getHasSeatingChart()) {
            response.sendRedirect(request.getContextPath() + "/organizer-servlet?action=step3");
            return;
        }
        request.setAttribute("event", event);
        request.getRequestDispatcher("/eventOwner/createEvent/createMapEvent.jsp").forward(request, response);
    }

    private void showPreviewMapForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();

        Event event = (Event) session.getAttribute("event");
        if (event == null || !event.getHasSeatingChart()) {
            response.sendRedirect(request.getContextPath() + "/organizer-servlet?action=step3");
            return;
        }
        String seatMapData = (String) session.getAttribute("seatMapData");
        if (seatMapData == null) {
            response.sendRedirect(request.getContextPath() + "/organizer-servlet?action=createMap");
            return;
        }
        System.out.println("Session ID in showPreviewMapForm: " + session.getId());
        System.out.println("Retrieved seatMapData from session: " + seatMapData);
        List<Zone> zones = new ArrayList<>();
        try {
            JSONObject json = new JSONObject(seatMapData);
            JSONArray zonesArray = json.getJSONArray("zones");
            for (int i = 0; i < zonesArray.length(); i++) {
                zones.add(new Zone(zonesArray.getJSONObject(i)));
            }
            request.setAttribute("zones", zones);
            request.setAttribute("seatMapData", seatMapData);
            request.setAttribute("event", event);
            System.out.println("Zones set as attribute: " + zones.size());
        } catch (Exception e) {
            System.out.println("Error parsing seatMapData in showPreviewMapForm: " + e.getMessage());
            request.setAttribute("errorMessage", "Invalid seating chart data: " + e.getMessage());
        }

        request.getRequestDispatcher("/eventOwner/createEvent/previewMapEvent.jsp").forward(request, response);
    }

    private void showCustomizeSeatsForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Event event = (Event) session.getAttribute("event");
        if (event == null || !event.getHasSeatingChart()) {
            response.sendRedirect(request.getContextPath() + "/organizer-servlet?action=step3");
            return;
        }
        String seatMapData = (String) session.getAttribute("seatMapData");
        if (seatMapData == null) {
            System.out.println("in showCustomize seats form method, seat map data is null");
            response.sendRedirect(request.getContextPath() + "/organizer-servlet?action=createMap");
            return;
        }
        List<Zone> zones = new ArrayList<>();
        try {
            JSONObject json = new JSONObject(seatMapData);
            JSONArray zonesArray = json.getJSONArray("zones");
            for (int i = 0; i < zonesArray.length(); i++) {
                zones.add(new Zone(zonesArray.getJSONObject(i)));
            }

            request.setAttribute("zones", zones);
            request.setAttribute("event", event);
        } catch (Exception e) {
            logger.severe("Error parsing seatMapData in showCustomizeSeatsForm: " + e.getMessage());
            request.setAttribute("errorMessage", "Invalid seating chart data: " + e.getMessage());
        }
        request.getRequestDispatcher("/eventOwner/createEvent/CustomizeSeats.jsp").forward(request, response);
    }

    private void showStep4Form(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Event event = (Event) session.getAttribute("event");
        if (event == null) {
            event = new Event();
            response.sendRedirect(request.getContextPath() + "/organizer-servlet?action=step1");
            return;
        }
        String seatMapData = (String) session.getAttribute("seatMapData");

        // Check for required session attributes first
        if (event.getHasSeatingChart()) {
            if (seatMapData == null) {
                logger.warning("seatMapData is null, redirecting to createMap");
                response.sendRedirect(request.getContextPath() + "/organizer-servlet?action=createMap");
                return;
            }
            JSONArray ticketNames = (JSONArray) session.getAttribute("ticketNames");
            if (ticketNames == null) {
                logger.warning("ticketNames is null, redirecting to customizeSeats");
                request.setAttribute("errorMessage", "Please customize seat names before proceeding.");
                response.sendRedirect(request.getContextPath() + "/organizer-servlet?action=customizeSeats");
                return;
            }
        }

        // Process seatMapData only after validation
        if (event.getHasSeatingChart()) {
            try {
                JSONObject json = new JSONObject(seatMapData);
                JSONArray zonesArray = json.getJSONArray("zones");
                JSONArray ticketNames = (JSONArray) session.getAttribute("ticketNames"); // Already checked for null
                if (ticketNames.isEmpty()) {
                    logger.info("ticketNames is empty");
                }
                Map<String, TicketInfo> ticketInfo = new HashMap<>();
                for (int i = 0; i < zonesArray.length(); i++) {
                    JSONObject zone = zonesArray.getJSONObject(i);
                    String zoneName = zone.getString("name");
                    int zoneSeats = zone.getInt("totalSeats");
                    BigDecimal price = BigDecimal.valueOf(zone.getDouble("ticketPrice"));
                    String ticketName = ticketNames != null && i < ticketNames.length() ? ticketNames.getString(i)
                            : zoneName;
                    TicketInfo info = new TicketInfo(ticketName, price, zoneSeats);
                    info.setCategory(zoneName);
                    ticketInfo.put(zoneName, info);
                }
                if (ticketInfo.isEmpty()) {
                    logger.info("ticketInfo is empty");
                }
                request.setAttribute("ticketInfo", ticketInfo);
            } catch (Exception e) {
                logger.severe("Error parsing seatMapData in showStep4Form: " + e.getMessage());
                request.setAttribute("errorMessage", "Invalid seating chart data: " + e.getMessage());
            }
        }
        request.setAttribute("event", event);
        request.getRequestDispatcher("/eventOwner/createEvent/TicketInfoSetting.jsp").forward(request, response);
    }

    private void processStep1(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Event event = (Event) session.getAttribute("event");
        if (event == null)
            event = new Event();
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
        String eventURL = request.getParameter("imageURL");
        event.setImageURL(eventURL);
        session.setAttribute("event", event);
        response.sendRedirect(request.getContextPath() + "/organizer-servlet?action=step2");
    }

    private void processStep2(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Event event = (Event) session.getAttribute("event");
        if (event == null)
            event = new Event();
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
        if (event == null)
            event = new Event();
        event.setHasSeatingChart("true".equals(request.getParameter("hasSeatingChart")));
        event.setStatus("pending");
        session.setAttribute("event", event);
        if (event.getHasSeatingChart()) {
            response.sendRedirect(request.getContextPath() + "/organizer-servlet?action=createMap");
        } else {
            response.sendRedirect(request.getContextPath() + "/organizer-servlet?action=step4");
        }
    }

    private void processCreateMap(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Event event = (Event) session.getAttribute("event");
        if (event == null || !event.getHasSeatingChart()) {
            response.sendRedirect(request.getContextPath() + "/organizer-servlet?action=step4");
            return;
        }
        String seatMapData = request.getParameter("seatMapData");
        logger.info("Received seatMapData: " + seatMapData);
        if (seatMapData == null || seatMapData.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Seating chart data is required");
            showCreateMapForm(request, response);
            return;
        }
        try {
            JSONObject json = new JSONObject(seatMapData);
            JSONArray zones = json.getJSONArray("zones");
            for (int i = 0; i < zones.length(); i++) {
                JSONObject zone = zones.getJSONObject(i);
                if (!zone.has("name") || !zone.has("shape") || !zone.has("color") ||
                        !zone.has("rows") || !zone.has("seatsPerRow") || !zone.has("totalSeats") ||
                        !zone.has("x") || !zone.has("y")) {
                    request.setAttribute("errorMessage", "Invalid zone data format");
                    showCreateMapForm(request, response);
                    return;
                }
                String shape = zone.getString("shape");
                if (shape.equals("rectangle") && !zone.has("vertices")) {
                    request.setAttribute("errorMessage", "Rectangle zones must have vertices");
                    showCreateMapForm(request, response);
                    return;
                }
                if (shape.equals("circle") && (!zone.has("radiusX") || !zone.has("radiusY"))) {
                    request.setAttribute("errorMessage", "Circle zones must have radiusX and radiusY");
                    showCreateMapForm(request, response);
                    return;
                }
                double ticketPrice = zone.getDouble("ticketPrice");
                if (ticketPrice <= 0) {
                    request.setAttribute("errorMessage", "Ticket price must be greater than 0");
                    showCreateMapForm(request, response);
                    return;
                }
            }
            session.setAttribute("seatMapData", seatMapData);
            logger.info("Stored seatMapData in session, redirecting to previewMap");
            response.sendRedirect(request.getContextPath() + "/organizer-servlet?action=previewMap");
        } catch (Exception e) {
            System.out.println("error : " + e);
            logger.severe("Error processing seatMapData: " + e.getMessage());
            request.setAttribute("errorMessage", "Invalid seating chart data format: " + e.getMessage());
            showCreateMapForm(request, response);
        }
    }

    private void processPreviewMap(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("call process preview map");
        HttpSession session = request.getSession();
        Event event = (Event) session.getAttribute("event");
        if (event == null || !event.getHasSeatingChart()) {
            response.sendRedirect(request.getContextPath() + "/organizer-servlet?action=step3");
            return;
        }
        String seatMapData = request.getParameter("seatMapData");
        logger.info("Received seatMapData in processPreviewMap: " + seatMapData);
        if (seatMapData == null || seatMapData.trim().isEmpty()) {
            seatMapData = (String) session.getAttribute("seatMapData");
            if (seatMapData == null) {
                response.sendRedirect(request.getContextPath() + "/organizer-servlet?action=createMap");
                return;
            }

            showPreviewMapForm(request, response);
            return;
        }
        try {
            JSONObject json = new JSONObject(seatMapData);
            JSONArray zones = json.getJSONArray("zones");
            JSONArray seats = json.getJSONArray("seats");
            Set<Integer> zoneIds = new HashSet<>();
            for (int i = 0; i < zones.length(); i++) {
                JSONObject zone = zones.getJSONObject(i);
                zoneIds.add(zone.getInt("id"));
                if (!zone.has("name") || !zone.has("shape") || !zone.has("totalSeats") ||
                        !zone.has("color") || !zone.has("rows") || !zone.has("seatsPerRow") ||
                        !zone.has("x") || !zone.has("y") || !zone.has("ticketPrice")) {
                    request.setAttribute("errorMessage", "Invalid zone data format");
                    showPreviewMapForm(request, response);
                    return;
                }
                double ticketPrice = zone.getDouble("ticketPrice");
                if (ticketPrice <= 0) {
                    request.setAttribute("errorMessage", "Ticket price must be greater than 0");
                    showPreviewMapForm(request, response);
                    return;
                }
            }
            for (int i = 0; i < seats.length(); i++) {
                JSONObject seat = seats.getJSONObject(i);
                if (!seat.has("zoneId") || !seat.has("label") || !seat.has("price") ||
                        !seat.has("color") || !seat.has("x") || !seat.has("y") ||
                        !seat.has("relativeX") || !seat.has("relativeY") || !seat.has("status")) {
                    request.setAttribute("errorMessage", "Invalid seat data format");
                    showPreviewMapForm(request, response);
                    return;
                }
                int zoneId = seat.getInt("zoneId");
                if (!zoneIds.contains(zoneId)) {
                    request.setAttribute("errorMessage", "Invalid zoneId in seat: " + zoneId);
                    showPreviewMapForm(request, response);
                    return;
                }
                String status = seat.getString("status");
                if (!status.equals("available") && !status.equals("reserved") && !status.equals("sold")) {
                    request.setAttribute("errorMessage", "Invalid seat status: " + status);
                    showPreviewMapForm(request, response);
                    return;
                }
            }
            int totalTicketCount = seats.length();
            event.setTotalTicketCount(totalTicketCount);
            session.setAttribute("seatMapData", seatMapData);
            session.setAttribute("seatMapDataConfirmed", true);
            logger.info("Validated seatMapData with seats: " + seatMapData);
            response.sendRedirect(request.getContextPath() + "/organizer-servlet?action=customizeSeats");
        } catch (Exception e) {
            logger.severe("Error processing seatMapData with seats: " + e.getMessage());
            request.setAttribute("errorMessage", "Invalid seating chart data: " + e.getMessage());
            showPreviewMapForm(request, response);
        }
    }

    private void processCustomizeSeats(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Event event = (Event) session.getAttribute("event");
        if (event == null || !event.getHasSeatingChart()) {
            logger.warning("Event is null or no seating chart, redirecting to step3");
            response.sendRedirect(request.getContextPath() + "/organizer-servlet?action=step3");
            return;
        }
        String seatMapData = (String) session.getAttribute("seatMapData");
        if (seatMapData == null) {
            logger.warning("seatMapData is null, redirecting to createMap");
            response.sendRedirect(request.getContextPath() + "/organizer-servlet?action=createMap");
            return;
        }
        String[] ticketNames = request.getParameterValues("ticketNames[]");
        String[] zoneIds = request.getParameterValues("zoneIds[]");
        if (ticketNames == null || zoneIds == null || ticketNames.length != zoneIds.length) {
            logger.warning("Invalid ticket name data: ticketNames=" + Arrays.toString(ticketNames) +
                    ", zoneIds=" + Arrays.toString(zoneIds));
            request.setAttribute("errorMessage", "Invalid ticket name data");
            showCustomizeSeatsForm(request, response);
            return;
        }
        try {
            JSONArray ticketNamesArray = new JSONArray();
            for (String ticketName : ticketNames) {
                if (ticketName.trim().isEmpty()) {
                    logger.warning("Empty ticket name detected");
                    request.setAttribute("errorMessage", "Ticket names cannot be empty");
                    showCustomizeSeatsForm(request, response);
                    return;
                }
                ticketNamesArray.put(ticketName.trim());
            }
            session.setAttribute("ticketNames", ticketNamesArray);
            logger.info("Successfully set ticketNames: " + ticketNamesArray.toString());
            logger.info("current seat map data: " + seatMapData);

            response.sendRedirect(request.getContextPath() + "/organizer-servlet?action=step4");
        } catch (Exception e) {
            logger.severe("Error processing ticket names: " + e.getMessage());
            request.setAttribute("errorMessage", "Error processing ticket names: " + e.getMessage());
            showCustomizeSeatsForm(request, response);
        }
    }

    private void createEvent(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        UserDTO u = (UserDTO) session.getAttribute("user");
        Event event = (Event) session.getAttribute("event");
        if (event == null)
            event = new Event();
        int totalTicketCount;
        try {
            totalTicketCount = Integer.parseInt(request.getParameter("totalTicketCount"));
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid ticket count");
            showStep4Form(request, response);
            return;
        }
        List<TicketInfo> ticketInfos = new ArrayList<>();
        if (!event.getHasSeatingChart()) {
            String[] ticketNames = request.getParameterValues("ticketName[]");
            String[] ticketPrices = request.getParameterValues("ticketPrice[]");
            String[] ticketQuantities = request.getParameterValues("ticketQuantity[]");
            if (ticketNames == null || ticketPrices == null || ticketQuantities == null ||
                    ticketNames.length != ticketPrices.length || ticketNames.length != ticketQuantities.length) {
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
                    if (name.isEmpty() || price.compareTo(BigDecimal.ZERO) <= 0 || quantity <= 0) {
                        request.setAttribute("errorMessage",
                                "Invalid ticket name, price, or quantity for ticket type " + (i + 1));
                        showStep4Form(request, response);
                        return;
                    }
                    TicketInfo ticketInfo = new TicketInfo(name, price, quantity);
                    ticketInfo.setCategory("General");
                    ticketInfo.setActive(true);
                    ticketInfo.setCreatedAt(LocalDateTime.now());
                    ticketInfo.setUpdatedAt(LocalDateTime.now());
                    ticketInfos.add(ticketInfo);
                    totalQuantity += quantity;
                } catch (NumberFormatException e) {
                    request.setAttribute("errorMessage", "Invalid price or quantity format for ticket type " + (i + 1));
                    showStep4Form(request, response);
                    return;
                }
            }
            for (TicketInfo t : ticketInfos)
                System.out.println("ticket infor: " + t);
            if (totalQuantity != totalTicketCount) {
                request.setAttribute("errorMessage", "Sum of ticket quantities must equal total ticket count");
                showStep4Form(request, response);
                return;
            }
        } else {
            String seatMapData = (String) session.getAttribute("seatMapData");
            Boolean seatMapDataConfirmed = (Boolean) session.getAttribute("seatMapDataConfirmed");
            if (seatMapData == null || seatMapDataConfirmed == null || !seatMapDataConfirmed) {
                request.setAttribute("errorMessage",
                        "Seating chart data not confirmed. Please preview and confirm the seating chart.");
                showCreateMapForm(request, response);
                return;
            }
            try {
                JSONObject json = new JSONObject(seatMapData);
                JSONArray seats = json.getJSONArray("seats");
                if (seats.length() != totalTicketCount) {
                    request.setAttribute("errorMessage", "Number of seats must match total ticket count");
                    showStep4Form(request, response);
                    return;
                }
                JSONArray zones = json.getJSONArray("zones");
                JSONArray ticketNames = (JSONArray) session.getAttribute("ticketNames");
                for (int i = 0; i < zones.length(); i++) {
                    JSONObject zone = zones.getJSONObject(i);
                    String zoneName = zone.getString("name");
                    int zoneSeats = zone.getInt("totalSeats");
                    BigDecimal price = BigDecimal.valueOf(zone.getDouble("ticketPrice"));
                    String ticketName = ticketNames != null && i < ticketNames.length() ? ticketNames.getString(i)
                            : zoneName;
                    TicketInfo ticketInfo = new TicketInfo(ticketName, price, zoneSeats);
                    ticketInfo.setCategory(zoneName);
                    ticketInfo.setActive(true);
                    ticketInfo.setCreatedAt(LocalDateTime.now());
                    ticketInfo.setUpdatedAt(LocalDateTime.now());
                    ticketInfos.add(ticketInfo);
                }
            } catch (Exception e) {
                request.setAttribute("errorMessage", "Invalid seating chart data: " + e.getMessage());
                showStep4Form(request, response);
                return;
            }
        }

        event.setTotalTicketCount(totalTicketCount);
        event.setEventID(0);
        event.setOwnerID(u.getId());
        event.setIsApproved(false);
        event.setIsDeleted(false);
        event.setCreatedAt(new Date());
        event.setUpdatedAt(new Date());
        event.setRanking(0L);

        logger.info("Creating event with details: " +
                "name=" + event.getName() +
                ", description=" + event.getDescription() +
                ", physicalLocation=" + event.getPhysicalLocation() +
                ", startTime=" + event.getStartTime() +
                ", endTime=" + event.getEndTime() +
                ", totalTicketCount=" + event.getTotalTicketCount() +
                ", isApproved=" + event.getIsApproved() +
                ", status=" + event.getStatus() +
                ", genreID=" + event.getGenreID() +
                ", ownerID=" + event.getOwnerID() +
                ", imageURL=" + event.getImageURL() +
                ", hasSeatingChart=" + event.getHasSeatingChart() +
                ", isDeleted=" + event.getIsDeleted() +
                ", createdAt=" + event.getCreatedAt() +
                ", updatedAt=" + event.getUpdatedAt() +
                ", ticketInfos=" + ticketInfos.size());

        ToggleEvent result;
        try {
            result = eventDao.createEvent(event, ticketInfos);
            if (event.getHasSeatingChart()) {
                System.out.println("create seat & zone data for event");
                String seatMapData = (String) session.getAttribute("seatMapData");
                if (seatMapData != null) {
                    JSONObject json = new JSONObject(seatMapData);
                    System.out.println("save seat and zone data: " + json);
                    JSONArray ticketNames = (JSONArray) session.getAttribute("ticketNames");
                    ToggleEvent seatResult = eventDao.saveSeats(result.getEventId(), json, result.getTicketInfoIdMap(),
                            ticketNames);
                    if (!seatResult.isSuccess()) {
                        request.setAttribute("errorMessage", seatResult.getMessage());
                        showStep4Form(request, response);
                        return;
                    }
                } else {
                    request.setAttribute("errorMessage", "No seating chart data found in session");
                    showStep4Form(request, response);
                    return;
                }
            }
        } catch (Exception e) {
            logger.severe("Error creating event: " + e.getMessage());
            request.setAttribute("errorMessage", "Failed to create event: " + e.getMessage());
            showStep4Form(request, response);
            return;
        }
        if (result.isSuccess()) {
            // Gửi notification cho admin khi có event mới
            try {
                // Giả sử admin có userID = 1 (hoặc lấy danh sách admin từ DB nếu cần gửi cho
                // nhiều admin)
                int adminUserId = 1;
                models.Notification notification = new models.Notification();
                notification.setUserID(adminUserId);
                notification.setTitle("🎫 Sự kiện mới được tạo");
                notification.setContent("Event Owner: " + u.getName() + 
                                    " | Sự kiện: " + event.getName() + 
                                    " | Địa điểm: " + event.getPhysicalLocation() + 
                                    " | Thời gian: " + event.getStartTime());
                notification.setNotificationType("event");
                notification.setRelatedID(result.getEventId());
                notification.setIsRead(false);
                notification.setCreatedAt(java.time.LocalDateTime.now());
                notification.setPriority("high");
                dao.NotificationDAO notificationDAO = new dao.NotificationDAO();
                notificationDAO.insertNotification(notification);
                

            } catch (Exception ex) {
                logger.warning("Không thể gửi notification cho admin: " + ex.getMessage());
            }
            session.removeAttribute("event");
            session.removeAttribute("seatMapData");
            session.removeAttribute("seatMapDataConfirmed");
            session.removeAttribute("ticketNames");
            session.setAttribute("successMessage", "Event created successfully: " + result.getMessage());
            response.sendRedirect(request.getContextPath() + "/organizer-servlet?action=dashboard");
        } else {
            request.setAttribute("errorMessage", result.getMessage());
            showStep4Form(request, response);
        }
    }

    private void updateEvent(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        logger.info("Processing update event request");
        if (!request.getContentType().startsWith("multipart/form-data")) {
            request.setAttribute("error", "Invalid form content type");
            request.getRequestDispatcher("/eventOwner/dashBoard.jsp").forward(request, response);
            return;
        }
        String eventIDStr = request.getParameter("eventID");
        System.out.println("event Id for updating: " + eventIDStr);
        int eventID;
        try {
            eventID = Integer.parseInt(eventIDStr);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID sự kiện không hợp lệ");
            request.setAttribute("editMode", true);
            request.getRequestDispatcher("/eventOwner/dashBoard.jsp").forward(request, response);
            return;
        }

        String imageFileName = null;
        try {
            Part filePart = request.getPart("imageFile");
            if (filePart != null && filePart.getSize() > 0) {
                // Tạo thư mục upload nếu chưa tồn tại
                String uploadPath = getUploadPath(request);
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                // Tạo tên file duy nhất
                String originalFileName = getFileName(filePart);
                String fileExtension = originalFileName.substring(originalFileName.lastIndexOf("."));
                String uniqueFileName = UUID.randomUUID().toString() + fileExtension;

                // Lưu file
                File file = new File(uploadPath + File.separator + uniqueFileName);
                try (InputStream fileContent = filePart.getInputStream()) {
                    Files.copy(fileContent, file.toPath(), StandardCopyOption.REPLACE_EXISTING);
                }

                imageFileName = uniqueFileName;
            }
        } catch (Exception e) {
            logger.severe("Error uploading file: " + e.getMessage());
            request.setAttribute("error", "Lỗi khi tải lên ảnh: " + e.getMessage());
            request.getRequestDispatcher("/eventOwner/dashBoard.jsp").forward(request, response);
            return;
        }

        Event event = new Event();
        event.setEventID(eventID);
        event.setName(request.getParameter("name"));
        event.setDescription(request.getParameter("description"));
        event.setPhysicalLocation(request.getParameter("physicalLocation"));
        event.setStatus(request.getParameter("status"));
        event.setUpdatedAt(new Date());
        if (imageFileName != null) {
            event.setImageURL(imageFileName);
        }

        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
            event.setStartTime(sdf.parse(request.getParameter("startTime")));
            event.setEndTime(sdf.parse(request.getParameter("endTime")));
        } catch (Exception e) {
            request.setAttribute("error", "Định dạng thời gian không hợp lệ");
            request.setAttribute("event", event);
            request.setAttribute("editMode", true);
            request.getRequestDispatcher("/eventOwner/dashBoard.jsp").forward(request, response);
            return;
        }

        try {
            event.setTotalTicketCount(Integer.parseInt(request.getParameter("totalTicketCount")));
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Số lượng vé không hợp lệ");
            request.setAttribute("event", event);
            request.setAttribute("editMode", true);
            request.getRequestDispatcher("/eventOwner/dashBoard.jsp").forward(request, response);
            return;
        }

        System.out.println("Event update: " + event);

        ToggleEvent updateResult = eventService.updateEvent(event);
        if (updateResult.isSuccess()) {
            request.setAttribute("success", updateResult.getMessage());
            request.setAttribute("event", eventService.getEventById(eventID)); // Refresh event data
            request.setAttribute("editMode", true);
            request.getRequestDispatcher("/eventOwner/dashBoard.jsp").forward(request, response);
        } else {
            request.setAttribute("error", updateResult.getMessage());
            request.setAttribute("event", event);
            request.setAttribute("editMode", true);
            request.getRequestDispatcher("/eventOwner/dashBoard.jsp").forward(request, response);
        }
    }

    private void editEvent(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String eventIDStr = request.getParameter("eventID");
        System.out.println("Edit Event - Parameters received: " + eventIDStr);

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

        Event event = eventService.getEventById(eventID);
        if (event == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy sự kiện");
            return;
        }
        System.out.println("event to edit " + event);

        request.setAttribute("event", event);
        // request.setAttribute("editMode", true);
        request.getRequestDispatcher("/eventOwner/EditEventPage.jsp").forward(request, response);
    }

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

        ToggleEvent deleteResult = eventService.deleteEvent(eventID);
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

    private String getUploadPath(HttpServletRequest request) {
        // Lấy đường dẫn tuyệt đối đến thư mục gốc của webapp
        String appPath = request.getServletContext().getRealPath("");
        // Trả về đường dẫn đến thư mục upload
        return appPath + File.separator + UPLOAD_DIR;
    }

    private String getFileName(final Part part) {
        final String partHeader = part.getHeader("content-disposition");
        for (String content : partHeader.split(";")) {
            if (content.trim().startsWith("filename")) {
                return content.substring(content.indexOf('=') + 1).trim().replace("\"", "");
            }
        }
        return null;
    }
}