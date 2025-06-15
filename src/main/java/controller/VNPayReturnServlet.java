// File: controller/VNPayReturnServlet.java

package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import vnpay.config.VnPayConfig;

@WebServlet(name = "VNPayReturnServlet", urlPatterns = {"/VNPayReturnServlet"})
public class VNPayReturnServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Lấy tất cả các tham số trả về
            Map<String, String> fields = new HashMap<>();
            for (Iterator<String> itr = request.getParameterNames().asIterator(); itr.hasNext(); ) {
                String fieldName = itr.next();
                String fieldValue = request.getParameter(fieldName);
                if ((fieldValue != null) && (fieldValue.length() > 0)) {
                    fields.put(fieldName, fieldValue);
                }
            }

            String vnp_SecureHash = request.getParameter("vnp_SecureHash");
            fields.remove("vnp_SecureHashType");
            fields.remove("vnp_SecureHash");

            // Xác thực chữ ký
            String signValue = VnPayConfig.hashAllFields(fields);
            if (signValue.equals(vnp_SecureHash)) {
                String vnp_ResponseCode = request.getParameter("vnp_ResponseCode");
                String vnp_TransactionStatus = request.getParameter("vnp_TransactionStatus");

                if ("00".equals(vnp_ResponseCode) && "00".equals(vnp_TransactionStatus)) {
                    // THÀNH CÔNG
                    request.setAttribute("status", "success");
                    request.setAttribute("message", "Giao dịch được thực hiện thành công!");
                } else {
                    // THẤT BẠI hoặc BỊ HỦY
                    request.setAttribute("status", "fail");
                    request.setAttribute("message", "Giao dịch thất bại hoặc đã bị hủy.");
                }
                request.setAttribute("orderId", request.getParameter("vnp_TxnRef"));

            } else {
                // Chữ ký không hợp lệ
                request.setAttribute("status", "error");
                request.setAttribute("message", "Lỗi: Chữ ký không hợp lệ!");
            }
            
            // Chuyển hướng đến trang kết quả
            request.getRequestDispatcher("/pages/PaymentResult.jsp").forward(request, response);

        } catch (Exception e) {
            // Ghi lại lỗi nếu có để dễ dàng debug
            e.printStackTrace();
            request.setAttribute("status", "error");
            request.setAttribute("message", "Đã xảy ra lỗi không mong muốn.");
            request.getRequestDispatcher("/pages/PaymentResult.jsp").forward(request, response);
        }
    }
}