package controller;

import dao.EventDAO;
import dao.SeatDAO;
import dao.TicketInfoDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import models.Event;
import models.Order;
import models.OrderItem;
import models.Seat;
import models.TicketInfo;
import dto.UserDTO;

@WebServlet(name = "SeatPaymentServlet", urlPatterns = {"/SeatPaymentServlet"})
public class SeatPaymentServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(SeatPaymentServlet.class.getName());
    private EventDAO eventDAO;
    private SeatDAO seatDAO;
    private TicketInfoDAO ticketInfoDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        eventDAO = new EventDAO();
        seatDAO = new SeatDAO();
        ticketInfoDAO = new TicketInfoDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        UserDTO currentUser = (UserDTO) session.getAttribute("user");

        // 1. Kiểm tra đăng nhập
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // 2. Lấy các tham số từ URL
            String eventIdStr = request.getParameter("eventId");
            String seatIdsStr = request.getParameter("seatIds");

            if (eventIdStr == null || eventIdStr.trim().isEmpty() || seatIdsStr == null || seatIdsStr.trim().isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Yêu cầu thiếu tham số 'eventId' hoặc 'seatIds' hợp lệ.");
                return;
            }

            int eventId = Integer.parseInt(eventIdStr);
            Event event = eventDAO.getEventById(eventId);
            if (event == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy sự kiện.");
                return;
            }

            // 3. Chuyển seatIds thành danh sách
            String[] seatIdArray = seatIdsStr.split(",");
            List<Integer> seatIds = new ArrayList<>();
            for (String seatId : seatIdArray) {
                try {
                    seatIds.add(Integer.parseInt(seatId.trim()));
                } catch (NumberFormatException e) {
                    LOGGER.warning("Seat ID không hợp lệ: " + seatId);
                }
            }

            if (seatIds.isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Không có ghế nào hợp lệ.");
                return;
            }

            // 4. Lấy thông tin ghế từ database
            List<Seat> seats = seatDAO.getSeatsByIds(seatIds);
            if (seats == null || seats.isEmpty()) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy ghế.");
                return;
            }

            // 5. Kiểm tra trạng thái ghế
            for (Seat seat : seats) {
                if (!"available".equalsIgnoreCase(seat.getStatus())) {
                    response.sendRedirect(request.getContextPath() + "/BookSeatServlet?eventId=" + eventId + "&error=seat_taken");
                    return;
                }
            }

            // 6. Nhóm ghế theo TicketInfo
            Map<Integer, List<Seat>> seatsByTicketInfo = new HashMap<>();
            for (Seat seat : seats) {
                TicketInfo ticket = ticketInfoDAO.getTicketInfoBySeat(seat.getSeatId());
                if (ticket == null) {
                    LOGGER.warning("Không tìm thấy TicketInfo cho seatId: " + seat.getSeatId());
                    continue;
                }
                seatsByTicketInfo.computeIfAbsent(ticket.getTicketInfoID(), k -> new ArrayList<>()).add(seat);
            }

            // 7. Tạo OrderItems từ các nhóm ghế
            List<OrderItem> orderItems = new ArrayList<>();
            BigDecimal totalAmount = BigDecimal.ZERO;
            for (Map.Entry<Integer, List<Seat>> entry : seatsByTicketInfo.entrySet()) {
                int ticketInfoId = entry.getKey();
                List<Seat> ticketSeats = entry.getValue();
                if (ticketSeats.isEmpty()) {
                    continue;
                }

                TicketInfo ticket = ticketInfoDAO.getTicketInfoById(ticketInfoId);
                if (ticket == null) {
                    LOGGER.warning("Không tìm thấy TicketInfo cho ticketInfoId: " + ticketInfoId);
                    continue;
                }

                OrderItem item = new OrderItem();
                item.setTicketInfoId(ticket.getTicketInfoID());
                item.setQuantity(ticketSeats.size()); // Số lượng là số ghế trong nhóm
                item.setUnitPrice(ticket.getPrice());
                item.setEventName(event.getName());
                item.setTicketTypeName(ticket.getTicketName());
                item.setEventId(event.getEventID());

                orderItems.add(item);
                totalAmount = totalAmount.add(ticket.getPrice().multiply(new BigDecimal(ticketSeats.size())));
            }

            if (orderItems.isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Không thể tạo đơn hàng từ ghế.");
                return;
            }

            // 8. Tạo và lưu Order
            Order order = new Order();
            order.setUserId(currentUser.getId());
            order.setContactEmail(currentUser.getEmail());
            order.setEvent(event);
            order.setItems(orderItems);
            order.setTotalAmount(totalAmount);
            order.setOrderStatus("PENDING_PAYMENT");
            order.setCreatedAt(LocalDateTime.now());

            session.setAttribute("currentOrder", order);

            request.getRequestDispatcher("/pages/Payment.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            LOGGER.log(Level.SEVERE, "Định dạng tham số không hợp lệ", e);
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Định dạng tham số không hợp lệ.");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi xử lý thanh toán (GET)", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Đã có lỗi xảy ra.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Chuyển hướng về trang chủ nếu truy cập bằng POST
        response.sendRedirect(request.getContextPath() + "/");
    }

    @Override
    public String getServletInfo() {
        return "Handles payment processing for seat-based event tickets.";
    }
}