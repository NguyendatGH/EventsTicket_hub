package controller;

import dao.EventDAO;
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
import models.Event;
import models.Order;
import models.OrderItem;
import models.TicketInfo;
// import models.User;

@WebServlet(name = "PaymentServlet", urlPatterns = {"/PaymentServlet"})
public class PaymentServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        UserDTO currentUser = (UserDTO) session.getAttribute("user");

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
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
        Order currentOrder = (Order) session.getAttribute("currentOrder");

        if (currentOrder == null) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        request.getRequestDispatcher("/pages/Payment.jsp").forward(request, response);
    }

}
