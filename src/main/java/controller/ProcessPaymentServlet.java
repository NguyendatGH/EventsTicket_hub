package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "ProcessPaymentServlet", urlPatterns = {"/ProcessPaymentServlet"})
public class ProcessPaymentServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        // Kiểm tra xem người dùng đã đăng nhập và có đơn hàng trong session chưa
        if (session == null || session.getAttribute("user") == null || session.getAttribute("currentOrder") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String paymentMethod = request.getParameter("paymethod");

        // Kiểm tra xem phương thức thanh toán có phải là PAYOS không
        if ("PAYOS".equals(paymentMethod)) {
            // Nếu đúng, chuyển hướng đến servlet xử lý của PayOS
            response.sendRedirect(request.getContextPath() + "/PayOSPaymentServlet");
        } else {
            // Nếu không chọn hoặc chọn phương thức khác (trường hợp sau này thêm vào), báo lỗi
            request.setAttribute("errorMessage", "Vui lòng chọn phương thức thanh toán hợp lệ.");
            request.getRequestDispatcher("/pages/Payment.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Chuyển hướng về trang chủ nếu truy cập bằng phương thức GET
        response.sendRedirect(request.getContextPath() + "/");
    }
}
