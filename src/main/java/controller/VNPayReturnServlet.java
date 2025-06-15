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

            String signValue = VnPayConfig.hashAllFields(fields);
            if (signValue.equals(vnp_SecureHash)) {
                String vnp_ResponseCode = request.getParameter("vnp_ResponseCode");
                String vnp_TransactionStatus = request.getParameter("vnp_TransactionStatus");

                if ("00".equals(vnp_ResponseCode) && "00".equals(vnp_TransactionStatus)) {
                    request.setAttribute("status", "success");
                    request.setAttribute("message", "Giao dịch được thực hiện thành công!");
                } else {
                    request.setAttribute("status", "fail");
                    request.setAttribute("message", "Giao dịch thất bại hoặc đã bị hủy.");
                }
                request.setAttribute("orderId", request.getParameter("vnp_TxnRef"));

            } else {
                request.setAttribute("status", "error");
                request.setAttribute("message", "Lỗi: Chữ ký không hợp lệ!");
            }
            
            request.getRequestDispatcher("/pages/PaymentResult.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("status", "error");
            request.setAttribute("message", "Đã xảy ra lỗi không mong muốn.");
            request.getRequestDispatcher("/pages/PaymentResult.jsp").forward(request, response);
        }
    }
}