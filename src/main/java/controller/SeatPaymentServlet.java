/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.EventDAO;
import dao.SeatDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import models.Event;
import models.Order;
import models.OrderItem;
import models.Seat;
import models.User;

/**
 *
 * @author admin
 */
@WebServlet(name = "SeatPaymentServlet", urlPatterns = {"/SeatPaymentServlet"})
public class SeatPaymentServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet SeatPaymentServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet SeatPaymentServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        HttpSession session = request.getSession();
//        User currentUser = (User) session.getAttribute("user");
//
//        // 1. Kiểm tra đăng nhập
//        if (currentUser == null) {
//            response.sendRedirect(request.getContextPath() + "/login");
//            return;
//        }
//
//        try {
//            // 2. Lấy các tham số từ URL
//            int eventId = Integer.parseInt(request.getParameter("eventId"));
//            String[] seatIdsStr = request.getParameter("seatIds").split(",");
//
//            EventDAO eventDAO = new EventDAO();
//            SeatDAO seatDAO = new SeatDAO();
//
//            Event event = eventDAO.getEventById(eventId);
//
//            List<OrderItem> orderItems = new ArrayList<>();
//            BigDecimal totalAmount = BigDecimal.ZERO;
//
//            
//            for (String seatIdStr : seatIdsStr) {
//                int seatId = Integer.parseInt(seatIdStr.trim());
//
//                // Bạn cần tạo phương thức này trong SeatDAO
//                Seat seat = seatDAO.getSeatById(seatId);
//
//                // Chỉ xử lý nếu ghế tồn tại và đang ở trạng thái "available"
//                if (seat != null && "available".equalsIgnoreCase(seat.getSeatStatus())) {
//                    OrderItem item = new OrderItem();
//                    item.setSeatId(seat.getSeatId()); 
//                    item.setQuantity(1); 
//                    item.setUnitPrice(seat.getPrice().doubleValue()); 
//                    item.setEventName(event.getName());
//                    item.setTicketTypeName("Ghế " + seat.getSeatRow() + seat.getSeatNumber() + " (" + seat.getSeatSection() + ")");
//
//                    orderItems.add(item);
//                    totalAmount = totalAmount.add(seat.getPrice()); 
//            }
//
//            // Nếu không có ghế nào hợp lệ (ví dụ: đã bị người khác mua mất)
//            if (orderItems.isEmpty()) {
//                response.sendRedirect(request.getContextPath() + "/book-chair?eventId=" + eventId + "&error=seat_taken");
//                return;
//            }
//
//            // 5. Tạo đối tượng Order để hiển thị trên trang xác nhận
//            Order order = new Order();
//            order.setUserId(currentUser.getId());
//            order.setEvent(event); // Gán đối tượng Event vào Order
//            order.setItems(orderItems);
//            order.setTotalAmount(totalAmount);
//            order.setOrderStatus("PENDING_PAYMENT"); // Trạng thái chờ thanh toán
//            order.setCreatedAt(new Date());
//
//            // 6. Lưu đơn hàng tạm thời vào session để các bước sau (như VNPay) có thể lấy ra
//            session.setAttribute("currentOrder", order);
//
//            // 7. Gửi đơn hàng đến trang JSP để hiển thị
//            request.setAttribute("order", order);
//            request.getRequestDispatcher("/pages/Payment.jsp").forward(request, response);
//
//        } catch (Exception e) {
//            e.printStackTrace();
//            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi khi tạo đơn hàng.");
//        }
//    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
