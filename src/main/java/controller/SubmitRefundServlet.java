/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dao.RefundDAO;
import dao.OrderDAO;
import dto.UserDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Refund;
import models.Notification;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;


@WebServlet("/SubmitRefundServlet")
public class SubmitRefundServlet extends HttpServlet {
   
    private final RefundDAO refundDAO = new RefundDAO();
    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/TicketOrderHistoryServlet");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        UserDTO currentUser = (UserDTO) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String orderIdParam = request.getParameter("orderId");
        String refundReason = request.getParameter("refundReason");

        // Validate input
        if (orderIdParam == null || orderIdParam.trim().isEmpty() || 
            refundReason == null || refundReason.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Vui lòng điền đầy đủ thông tin!");
            request.setAttribute("orderId", orderIdParam);
            request.setAttribute("refundReason", refundReason);
            request.getRequestDispatcher("/pages/RequestRefund.jsp").forward(request, response);
            return;
        }

        try {
            int orderId = Integer.parseInt(orderIdParam);
            
            // Kiểm tra xem có thể hoàn tiền không
            if (!refundDAO.checkCanRefund(orderId, currentUser.getId())) {
                request.setAttribute("errorMessage", "Vé đã quá hạn hoàn trả hoặc không hợp lệ.");
                request.setAttribute("orderId", orderId);
                request.setAttribute("refundReason", refundReason);
                request.getRequestDispatcher("/pages/RequestRefund.jsp").forward(request, response);
                return;
            }

            // Lấy thông tin đơn hàng để tính số tiền hoàn
//            BigDecimal orderAmount = orderDAO.getOrderAmount(orderId);
//            if (orderAmount == null) {
//                request.setAttribute("errorMessage", "Không tìm thấy thông tin đơn hàng.");
//                request.setAttribute("orderId", orderId);
//                request.setAttribute("refundReason", refundReason);
//                request.getRequestDispatcher("/pages/RequestRefund.jsp").forward(request, response);
//                return;
//            }

            // Tạo yêu cầu hoàn tiền
            Refund refund = new Refund();
            refund.setOrderId(orderId);
            refund.setUserId(currentUser.getId());
//            refund.setRefundAmount(orderAmount);
            refund.setRefundReason(refundReason.trim());
            refund.setRefundStatus("pending");
            refund.setRefundRequestDate(LocalDateTime.now());
            refund.setCreatedAt(LocalDateTime.now());
            refund.setUpdatedAt(LocalDateTime.now());

            boolean success = refundDAO.insertRefund(refund);

            if (success) {
                // Thông báo đã được tạo tự động trong RefundDAO.insertRefund()
                session.setAttribute("flashMessage_success", "Yêu cầu hoàn tiền đã được gửi thành công! Chúng tôi sẽ xử lý trong thời gian sớm nhất.");
                response.sendRedirect(request.getContextPath() + "/TicketOrderHistoryServlet");
            } else {
                request.setAttribute("errorMessage", "Có lỗi xảy ra khi gửi yêu cầu hoàn tiền. Vui lòng thử lại!");
                request.setAttribute("orderId", orderId);
                request.setAttribute("refundReason", refundReason);
                request.getRequestDispatcher("/pages/RequestRefund.jsp").forward(request, response);
            }

        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Mã đơn hàng không hợp lệ.");
            request.setAttribute("orderId", orderIdParam);
            request.setAttribute("refundReason", refundReason);
            request.getRequestDispatcher("/pages/RequestRefund.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Có lỗi xảy ra. Vui lòng thử lại sau!");
            request.setAttribute("orderId", orderIdParam);
            request.setAttribute("refundReason", refundReason);
            request.getRequestDispatcher("/pages/RequestRefund.jsp").forward(request, response);
        }
    }
}
