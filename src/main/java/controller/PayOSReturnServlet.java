package controller;

import dao.OrderDAO;
import models.Order;
import models.User;
import services.EmailService; // THÊM IMPORT NÀY
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "PayOSReturnServlet", urlPatterns = {"/PayOSReturnServlet"})
public class PayOSReturnServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String statusParam = request.getParameter("status");
        String orderCode = request.getParameter("orderCode");
        String transactionId = request.getParameter("id");

        if ("PAID".equalsIgnoreCase(statusParam)) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                Order currentOrder = (Order) session.getAttribute("currentOrder");
                User currentUser = (User) session.getAttribute("user");

                if (currentOrder != null && currentUser != null) {
                    try {
                        // Gán các thông tin cần thiết trước khi lưu
                        currentOrder.setUserId(currentUser.getId());
                        currentOrder.setTransactionId(transactionId);
                        currentOrder.setOrderNumber(orderCode);

                        // Lưu vào CSDL
                        OrderDAO orderDAO = new OrderDAO();
                        int generatedOrderId = orderDAO.createOrder(currentOrder); // Giả sử hàm của bạn tên là createOrder

                        if (generatedOrderId != -1) {
                            currentOrder.setOrderId(generatedOrderId); // Cập nhật ID cho đối tượng để gửi mail chính xác
                            
                            // BƯỚC QUAN TRỌNG: GỌI SERVICE ĐỂ GỬI EMAIL
                            EmailService emailService = new EmailService();
                            emailService.sendOrderConfirmationEmail(currentUser, currentOrder);
                            
                            System.out.println("Đã lưu đơn hàng và gửi email thành công cho đơn #" + generatedOrderId);
                            request.setAttribute("status", "success");
                            request.setAttribute("message", "Thanh toán thành công! Vui lòng kiểm tra email để nhận thông tin vé.");
                        } else {
                             throw new Exception("Lưu đơn hàng vào CSDL thất bại.");
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                        request.setAttribute("status", "error");
                        // Thông báo cho người dùng rằng đã thanh toán nhưng có lỗi hệ thống
                        request.setAttribute("message", "Thanh toán đã thành công nhưng hệ thống gặp lỗi khi ghi nhận đơn hàng. Vui lòng liên hệ hỗ trợ.");
                    }
                }
            }
        } else {
             request.setAttribute("status", "fail");
             request.setAttribute("message", "Giao dịch thất bại hoặc đã bị hủy.");
        }
        
        // Gửi các thuộc tính cần thiết khác cho trang kết quả
        request.setAttribute("paymentMethod", "PayOS");
        request.setAttribute("orderCode", orderCode);
        request.setAttribute("transactionId", transactionId);
        
        request.getRequestDispatcher("/pages/PaymentResult.jsp").forward(request, response);
    }
}