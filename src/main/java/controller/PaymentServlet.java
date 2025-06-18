package controller;

import dao.EventDAO;
import dao.TicketInforDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;
import models.Event;
import models.Order;
import models.OrderItem;
import models.TicketInfor;
import models.User;

@WebServlet(name = "PaymentServlet", urlPatterns = {"/PaymentServlet"})
public class PaymentServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            int eventId = Integer.parseInt(request.getParameter("eventId"));
            EventDAO eventDAO = new EventDAO();
            Event event = eventDAO.getEventById(eventId);
            TicketInforDAO ticketDAO = new TicketInforDAO();

            List<OrderItem> orderItems = new ArrayList<>();
            Map<String, String[]> parameterMap = request.getParameterMap();

            BigDecimal totalAmount = BigDecimal.ZERO;

            // Vòng lặp để lấy thông tin các vé được chọn theo số lượng
            for (Map.Entry<String, String[]> entry : parameterMap.entrySet()) {
                if (entry.getKey().startsWith("quantity_")) {
                    int quantity = 0;
                    try {
                        quantity = Integer.parseInt(entry.getValue()[0]);
                    } catch (NumberFormatException e) {
                        // Bỏ qua nếu giá trị không phải là số
                        continue;
                    }

                    if (quantity > 0) {
                        int ticketId = Integer.parseInt(entry.getKey().substring("quantity_".length()));
                        TicketInfor ticket = ticketDAO.getTicketInfoById(ticketId);

                        if (ticket != null) {
                            OrderItem item = new OrderItem();
                            item.setTicketInfoId(ticket.getTicketInforID());
                            item.setQuantity(quantity);
                            item.setUnitPrice(ticket.getPrice().doubleValue());
                            item.setEventName(event.getName());
                            item.setTicketTypeName(ticket.getTicketName());

                            orderItems.add(item);
                            totalAmount = totalAmount.add(ticket.getPrice().multiply(new BigDecimal(quantity)));
                        }
                    }
                }
            }

            // Nếu người dùng không chọn vé nào
            if (orderItems.isEmpty()) {
                response.sendRedirect(request.getHeader("referer") + "?error=no_tickets_selected");
                return;
            }

            // Tạo đối tượng Order
            Order order = new Order();
            order.setUserId(currentUser.getId());
            order.setContactEmail(currentUser.getEmail());
            order.setEvent(event);
            order.setItems(orderItems);
            order.setTotalAmount(totalAmount);
            order.setOrderStatus("PENDING_PAYMENT");
            order.setCreatedAt(new Date());

            // [SỬA LỖI CỐT LÕI] Dùng key "currentOrder" để lưu vào session cho nhất quán
            session.setAttribute("currentOrder", order);
            
            // Chuyển hướng đến trang thanh toán chung
            response.sendRedirect(request.getContextPath() + "/pages/Payment.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi khi chuẩn bị đơn hàng.");
        }
    }
}