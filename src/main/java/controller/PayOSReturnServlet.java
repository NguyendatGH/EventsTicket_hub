package controller;

import dao.OrderDAO;
import dto.UserDTO;
import models.Order;
import models.OrderItem;
import service.EmailService;
import service.NotificationService;
import models.Notification;
import controller.NotificationWebSocket;


import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;

@WebServlet(name = "PayOSReturnServlet", urlPatterns = {"/PayOSReturnServlet"})
public class PayOSReturnServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String statusParam = request.getParameter("status");
        String orderCode = request.getParameter("orderCode");
        String transactionId = request.getParameter("id");

        HttpSession session = request.getSession(false);

        if ("PAID".equalsIgnoreCase(statusParam)) {
            if (session != null) {
                Order currentOrder = (Order) session.getAttribute("currentOrder");
                UserDTO currentUser = (UserDTO) session.getAttribute("user");


                if (currentOrder != null && currentUser != null) {
                    try {
                        currentOrder.setUserId(currentUser.getId());
                        currentOrder.setTransactionId(transactionId);
                        currentOrder.setOrderNumber(orderCode);
                        currentOrder.setPaymentStatus("paid");
                        currentOrder.setOrderStatus("created");
                        currentOrder.setPaymentMethodId(1);
                        currentOrder.setContactEmail(currentUser.getEmail());

                        int totalQuantity = 0;
                        for (OrderItem item : currentOrder.getItems()) {
                            totalQuantity += item.getQuantity();
                        }
                        currentOrder.setTotalQuantity(totalQuantity);
                        BigDecimal finalTotal = currentOrder.getTotalAmount();
                        BigDecimal discount = currentOrder.getDiscountAmount() != null ? currentOrder.getDiscountAmount() : BigDecimal.ZERO;
                        BigDecimal subtotal = finalTotal.add(discount);

                        currentOrder.setSubtotalAmount(subtotal);
                        currentOrder.setDiscountAmount(discount);

                        OrderDAO orderDAO = new OrderDAO();
                        int newOrderId = orderDAO.createOrder(currentOrder);

                        if (newOrderId != -1) {
                            try {
                                EmailService emailService = new EmailService();
                                emailService.sendOrderConfirmationEmail(currentUser, currentOrder);
                            } catch (Exception ex) {
                                ex.printStackTrace();
                                request.setAttribute("status", "success");
                                request.setAttribute("message", "Đặt hàng thành công nhưng gửi email thất bại.");
                            }

                            // Tạo thông báo real-time cho order thành công
                            try {
                                NotificationService notificationService = new NotificationService();
                                Notification notification = new Notification();
                                notification.setUserID(currentUser.getId());
                                notification.setNotificationType("order");
                                notification.setTitle("Đặt vé thành công!");
                                notification.setContent("Bạn đã đặt vé thành công cho sự kiện: " + currentOrder.getEvent().getName());
                                notification.setRelatedID(newOrderId);
                                notification.setIsRead(false);
                                notification.setCreatedAt(java.time.LocalDateTime.now());
                                
                                boolean notificationSaved = notificationService.insertNotification(notification);
                                if (notificationSaved) {
                                    // Gửi thông báo real-time qua WebSocket
                                    NotificationWebSocket.sendNotificationToUser(currentUser.getId(), notification);
                                }
                            } catch (Exception ex) {
                                System.err.println("Lỗi khi tạo thông báo: " + ex.getMessage());
                            }

                            request.setAttribute("status", "success");
                            request.setAttribute("message", "Cảm ơn bạn đã đặt vé. Hẹn gặp bạn tại sự kiện!");
                            request.setAttribute("paymentMethod", "PayOS");
                            request.setAttribute("orderCode", orderCode);
                            request.setAttribute("transactionId", transactionId);
                        } else {
                            request.setAttribute("status", "error");
                            request.setAttribute("message", "Thanh toán thành công nhưng không thể lưu đơn hàng.");
                        }

                    } catch (Exception e) {
                        e.printStackTrace();
                        request.setAttribute("status", "error");
                        request.setAttribute("message", "Hệ thống gặp lỗi khi xử lý đơn hàng.");
                    } finally {
                        session.removeAttribute("currentOrder");
                    }
                } else {
                    request.setAttribute("status", "error");
                    request.setAttribute("message", "Không tìm thấy thông tin đơn hàng trong session.");
                }
            } else {
                request.setAttribute("status", "error");
                request.setAttribute("message", "Phiên làm việc không hợp lệ.");
            }
        } else {
            request.setAttribute("status", "fail");
            request.setAttribute("message", "Thanh toán thất bại hoặc đã bị hủy. Vui lòng thử lại.");
        }

        // Dẫn đến trang kết quả
        request.getRequestDispatcher("/pages/PaymentResult.jsp").forward(request, response);
    }
}
