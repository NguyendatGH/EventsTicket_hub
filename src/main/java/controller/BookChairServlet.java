// package controller;

// // [FIX #1] Thêm các import cần thiết cho Jackson và Java 8 Time
// import com.fasterxml.jackson.databind.ObjectMapper;
// import com.fasterxml.jackson.databind.SerializationFeature;
// import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;

// import dao.EventDAO;
// import dao.SeatDAO;
// import models.Event;
// import models.Seat;
// import jakarta.servlet.ServletException;
// import jakarta.servlet.annotation.WebServlet;
// import jakarta.servlet.http.HttpServlet;
// import jakarta.servlet.http.HttpServletRequest;
// import jakarta.servlet.http.HttpServletResponse;
// import java.io.IOException;
// import java.util.Collections;
// import java.util.List;
// import java.util.Map;
// import java.util.stream.Collectors;


// @WebServlet(name = "BookChairServlet", urlPatterns = {"/BookChairServlet"})
// public class BookChairServlet extends HttpServlet {

//     private EventDAO eventDAO;
//     private SeatDAO seatDAO;
//     private ObjectMapper objectMapper;

//     @Override
//     public void init() {
//         eventDAO = new EventDAO();
//         seatDAO = new SeatDAO();
//         objectMapper = new ObjectMapper();
//         objectMapper.registerModule(new JavaTimeModule());
//         objectMapper.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);
//     }

//     @Override
//     protected void doGet(HttpServletRequest request, HttpServletResponse response) 
//             throws ServletException, IOException {
        
//         if (request.getSession().getAttribute("user") == null) {
//             response.sendRedirect(request.getContextPath() + "/login");
//             return;
//         }
//         String eventIdStr = request.getParameter("eventId");
//         if (eventIdStr == null || eventIdStr.trim().isEmpty() || eventIdStr.equals("undefined")) {
//             response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Yêu cầu thiếu tham số 'eventId' hợp lệ.");
//             return;
//         }

//         try {
// //            String eventIdStr = request.getParameter("eventId");
//             if (eventIdStr == null || eventIdStr.trim().isEmpty()) {
//                 response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Yêu cầu thiếu tham số 'eventId'.");
//                 return;
//             }
//             int eventId = Integer.parseInt(eventIdStr);
            
//             Event event = eventDAO.getEventById(eventId);
//             if (event == null) {
//                 response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy sự kiện.");
//                 return;
//             }

//             List<Seat> allSeats = seatDAO.getSeatsByEventId(eventId);
//             Map<String, List<Seat>> seatsBySection = allSeats.stream()
//                 .collect(Collectors.groupingBy(Seat::getSeatSection));

//             // [SỬA ĐỔI] Chuyển đổi tất cả dữ liệu cần thiết sang JSON
//             String seatsJson = objectMapper.writeValueAsString(seatsBySection);
//             String eventJson = objectMapper.writeValueAsString(event);

//             request.setAttribute("event", event); // Vẫn gửi để JSTL dùng
//             request.setAttribute("seatsJson", seatsJson);
//             request.setAttribute("eventJson", eventJson); // Gửi cho JavaScript

//             request.getRequestDispatcher("/pages/BookChair.jsp").forward(request, response);

//         } catch (NumberFormatException e) {
//             response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Định dạng Event ID không hợp lệ.");
//         } catch (Exception e) {
//             e.printStackTrace();
//             response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Đã có lỗi xảy ra.");
//         }
//     }
// }