package controller;

import dao.EventDAO;
import dao.TicketInforDAO;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Event;
import models.OrderItem;
import models.TicketInfor;
import models.User;

@WebServlet(name = "PaymentServlet", urlPatterns = {"/PaymentServlet"})
public class PaymentServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        User currentUser = (User) session.getAttribute("account");
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/authentication/login.jsp");
            return;
        }

        List<OrderItem> cart = new ArrayList<>();
        double totalAmount = 0;

        String[] ticketIds = request.getParameterValues("ticketId");
        TicketInforDAO ticketDAO = new TicketInforDAO();

        if (ticketIds != null) {
            for (String ticketIdStr : ticketIds) {
                try {
                    int ticketId = Integer.parseInt(ticketIdStr);
                    int quantity = Integer.parseInt(request.getParameter("quantity_" + ticketId));

                    if (quantity > 0) {
                        TicketInfor ticket = ticketDAO.getTicketInfoById(ticketId);
                        if (ticket != null) {
                            OrderItem item = new OrderItem();
                            item.setTicketInfoId(ticket.getTicketInforID());
                            item.setQuantity(quantity);

                            // Sử dụng đúng phương thức setUnitPrice
                            item.setUnitPrice(ticket.getPrice().doubleValue());

                            item.setTicketTypeName(ticket.getTicketName());
                            item.setEventName(ticket.getTicketName());

                            cart.add(item);

                            // Sử dụng đúng phương thức getUnitPrice
                            totalAmount += item.getUnitPrice() * quantity;
                        }
                    }
                } catch (NumberFormatException e) {
                    System.err.println("Invalid number format in payment processing: " + e.getMessage());
                }
            }
        }

        if (cart.isEmpty()) {
            response.sendRedirect(request.getHeader("referer") + "?error=no_tickets_selected");
            return;
        }

        session.setAttribute("cart", cart);
        session.setAttribute("totalAmount", totalAmount);

        int eventId = Integer.parseInt(request.getParameter("eventId"));
        EventDAO eventDAO = new EventDAO();
        Event event = eventDAO.getEventById(eventId);

        request.setAttribute("event", event);
        request.setAttribute("user", currentUser);

        request.getRequestDispatcher("/pages/Payment.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Không cho phép truy cập GET, chuyển hướng về trang chủ
        response.sendRedirect("HomePageServlet");
    }
}
