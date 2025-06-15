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
        User currentUser = (User) session.getAttribute("user"); // Giả sử key là "user"

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            int eventId = Integer.parseInt(request.getParameter("eventId"));
            EventDAO eventDAO = new EventDAO();
            Event event = eventDAO.getEventById(eventId);
            TicketInforDAO ticketDAO = new TicketInforDAO();

            List<OrderItem> orderItems = new ArrayList<>();
            Map<String, String[]> parameterMap = request.getParameterMap();

            int totalQuantity = 0;
            BigDecimal totalAmount = BigDecimal.ZERO;

            for (Map.Entry<String, String[]> entry : parameterMap.entrySet()) {
                if (entry.getKey().startsWith("quantity_")) {
                    int quantity = Integer.parseInt(entry.getValue()[0]);
                    if (quantity > 0) {
                        int ticketId = Integer.parseInt(entry.getKey().substring("quantity_".length()));
                        TicketInfor ticket = ticketDAO.getTicketInfoById(ticketId);

                        if (ticket != null) {
                            OrderItem item = new OrderItem();
                            item.setTicketInfoId(ticket.getTicketInforID());
                            item.setQuantity(quantity);
                            item.setUnitPrice(ticket.getPrice().doubleValue());
                            item.setEventName(event.getName()); // Lấy tên sự kiện
                            item.setTicketTypeName(ticket.getTicketName()); // Lấy tên loại vé

                            orderItems.add(item);
                            totalQuantity += quantity;
                            totalAmount = totalAmount.add(ticket.getPrice().multiply(new BigDecimal(quantity)));
                        }
                    }
                }
            }

            if (orderItems.isEmpty()) {
                response.sendRedirect(request.getHeader("referer") + "?error=no_tickets_selected");
                return;
            }

            // Tạo đối tượng Order để gói dữ liệu
            Order order = new Order();
            order.setUserId(currentUser.getId());
            order.setContactEmail(currentUser.getEmail());

// ✅ THÊM DÒNG NÀY ĐỂ GẮN EVENT VÀO ORDER
            order.setEvent(event);

            order.setItems(orderItems);
            order.setTotalQuantity(totalQuantity);
            order.setTotalAmount(totalAmount);
            order.setOrderStatus("PENDING_PAYMENT");
            order.setCreatedAt(new Date());

// Đặt order vào session để servlet tiếp theo có thể truy cập
            session.setAttribute("order", order);
            request.setAttribute("event", event); // Vẫn gửi event để hiển thị thêm

            request.getRequestDispatcher("/pages/Payment.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi khi chuẩn bị đơn hàng.");
        }
    }
}
