package controller;

import dao.EventDAO;
import dao.SeatDAO;
import dao.TicketInfoDAO;
import dto.UserDTO;
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
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

import models.Event;
import models.Order;
import models.OrderItem;
import models.Seat;
import models.TicketInfo;

@WebServlet(name = "PaymentServlet", urlPatterns = { "/PaymentServlet" })
public class PaymentServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(PaymentServlet.class.getName());
    private static final EventDAO eventDAO = new EventDAO();
    private static final SeatDAO seatDAO = new SeatDAO();
    private static final TicketInfoDAO ticketInfoDAO = new TicketInfoDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        UserDTO currentUser = (UserDTO) session.getAttribute("user");

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            int eventId = Integer.parseInt(request.getParameter("eventId"));
            EventDAO eventDAO = new EventDAO();
            Event event = eventDAO.getEventById(eventId);
            TicketInfoDAO ticketDAO = new TicketInfoDAO();

            List<OrderItem> orderItems = new ArrayList<>();
            Map<String, String[]> parameterMap = request.getParameterMap();

            BigDecimal totalAmount = BigDecimal.ZERO;
            System.out.println("totalAmount  = " + totalAmount);
            for (OrderItem o : orderItems)
                System.out.println("ordders: " + o);

            for (Map.Entry<String, String[]> entry : parameterMap.entrySet()) {
                if (entry.getKey().startsWith("quantity_")) {
                    int quantity;
                    try {
                        quantity = Integer.parseInt(entry.getValue()[0]);
                    } catch (NumberFormatException e) {
                        continue;
                    }

                    if (quantity > 0) {
                        int ticketId = Integer.parseInt(entry.getKey().substring("quantity_".length()));
                        TicketInfo ticket = ticketDAO.getTicketInfoById(ticketId);

                        if (ticket != null) {
                            OrderItem item = new OrderItem();
                            item.setTicketInfoId(ticket.getTicketInfoID());
                            item.setQuantity(quantity);
                            item.setUnitPrice(ticket.getPrice());
                            item.setEventName(event.getName());
                            item.setTicketTypeName(ticket.getTicketName());

                            item.setEventId(event.getEventID());

                            orderItems.add(item);
                            totalAmount = totalAmount.add(ticket.getPrice().multiply(new BigDecimal(quantity)));
                        }
                    }
                }
            }

            if (orderItems.isEmpty()) {
                response.sendRedirect(request.getHeader("Referer"));
                return;
            }

            Order order = new Order();
            order.setUserId(currentUser.getId());
            order.setContactEmail(currentUser.getEmail());
            order.setEvent(event);
            order.setItems(orderItems);
            order.setTotalAmount(totalAmount);
            order.setOrderStatus("PENDING_PAYMENT");
            order.setCreatedAt(LocalDateTime.now());
            session.setAttribute("currentOrder", order);

            response.sendRedirect(request.getContextPath() + "/pages/Payment.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi khi chuẩn bị đơn hàng.");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        UserDTO currentUser = (UserDTO) session.getAttribute("user");

        if (currentUser == null) {
            System.out.println("current user is null");
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        Order currentOrder = (Order) session.getAttribute("currentOrder");

        if (currentOrder == null) {
            System.out.println("current order is null");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        try {
            int eventId = Integer.parseInt(request.getParameter("eventId"));
            String seatIdsStr = request.getParameter("seatIds");
            if (seatIdsStr == null || seatIdsStr.trim().isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Yêu cầu thiếu tham số 'seatIds' hợp lệ.");
                return;
            }

            Event event = eventDAO.getEventById(eventId);
            if (event == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy sự kiện.");
                return;
            }

            // Chuyển seatIds thành danh sách
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

            // Lấy thông tin ghế từ database
            List<Seat> seats = seatDAO.getSeatsByIds(seatIds); // Giả sử có phương thức này
            if (seats == null || seats.isEmpty()) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy ghế.");
                return;
            }

            // Tạo OrderItems từ ghế
            List<OrderItem> orderItems = new ArrayList<>();
            BigDecimal totalAmount = BigDecimal.ZERO;
            for (Seat seat : seats) {
                // Giả sử mỗi ghế có TicketInfo liên kết (cần điều chỉnh logic tùy database)
                TicketInfo ticket = ticketInfoDAO.getTicketInfoBySeat(seat.getSeatId()); // Giả sử có phương thức này
                System.out.println("Tickeet: " + ticket);
                if (ticket != null) {
                    OrderItem item = new OrderItem();
                    item.setTicketInfoId(ticket.getTicketInfoID());
                    item.setQuantity(1); // Mỗi ghế là 1 vé
                    item.setUnitPrice(ticket.getPrice());
                    item.setEventName(event.getName());
                    item.setTicketTypeName(ticket.getTicketName());
                    item.setEventId(event.getEventID());

                    orderItems.add(item);
                    totalAmount = totalAmount.add(ticket.getPrice());
                }
            }

            if (orderItems.isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Không thể tạo đơn hàng từ ghế.");
                return;
            }

            // Tạo và lưu Order
            Order order = new Order();
            order.setUserId(currentUser.getId());
            order.setContactEmail(currentUser.getEmail());
            order.setEvent(event);
            order.setItems(orderItems);
            order.setTotalAmount(totalAmount);
            order.setOrderStatus("PENDING_PAYMENT");
            order.setCreatedAt(LocalDateTime.now());

            session.setAttribute("currentOrder", order);
            // Chuyển hướng đến PayOSPaymentServlet để xử lý thanh toán
            response.sendRedirect(request.getContextPath() + "/PayOSPaymentServlet");

        } catch (NumberFormatException e) {
            LOGGER.log(Level.SEVERE, "Định dạng tham số không hợp lệ", e);
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Định dạng tham số không hợp lệ.");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi xử lý thanh toán (GET)", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Đã có lỗi xảy ra.");
        }

        request.getRequestDispatcher("/pages/Payment.jsp").forward(request, response);
    }

}
