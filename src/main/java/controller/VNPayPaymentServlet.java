package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;
import java.util.TimeZone;
import models.Order;
import vnpay.config.VnPayConfig;

@WebServlet(name = "VNPayPaymentServlet", urlPatterns = {"/VNPayPaymentServlet"})
public class VNPayPaymentServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("order") == null) {
            resp.sendRedirect(req.getContextPath() + "/");
            return;
        }
        Order order = (Order) session.getAttribute("order");

        System.out.println("--- VNPAY DEBUG START ---");
        System.out.println("TmnCode Gửi Đi: '" + VnPayConfig.vnp_TmnCode + "'");
        System.out.println("HashSecret Dùng Để Ký: '" + VnPayConfig.vnp_HashSecret + "'");
        System.out.println("--- VNPAY DEBUG END ---");

        String vnp_TxnRef = String.valueOf(System.currentTimeMillis());
        String vnp_OrderInfo = "Thanh toan don hang " + vnp_TxnRef;
        long amount = order.getTotalAmount().longValue() * 100;

        Map<String, String> vnp_Params = new HashMap<>();
        vnp_Params.put("vnp_Version", VnPayConfig.vnp_Version);
        vnp_Params.put("vnp_Command", VnPayConfig.vnp_Command);
        vnp_Params.put("vnp_TmnCode", VnPayConfig.vnp_TmnCode);
        vnp_Params.put("vnp_Amount", String.valueOf(amount));
        vnp_Params.put("vnp_CurrCode", "VND");
        vnp_Params.put("vnp_TxnRef", vnp_TxnRef);
        vnp_Params.put("vnp_OrderInfo", vnp_OrderInfo);
        vnp_Params.put("vnp_OrderType", VnPayConfig.vnp_OrderType);
        vnp_Params.put("vnp_Locale", "vn");
        vnp_Params.put("vnp_ReturnUrl", VnPayConfig.vnp_ReturnUrl);
        vnp_Params.put("vnp_IpAddr", VnPayConfig.getIpAddress(req));

        Calendar cld = Calendar.getInstance(TimeZone.getTimeZone("Etc/GMT+7"));
        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
        String vnp_CreateDate = formatter.format(cld.getTime());
        vnp_Params.put("vnp_CreateDate", vnp_CreateDate);

        cld.add(Calendar.MINUTE, 15);
        String vnp_ExpireDate = formatter.format(cld.getTime());
        vnp_Params.put("vnp_ExpireDate", vnp_ExpireDate);

        String vnp_SecureHash = VnPayConfig.hashAllFields(vnp_Params);
        vnp_Params.put("vnp_SecureHash", vnp_SecureHash);

        StringBuilder queryUrl = new StringBuilder();
        for (Map.Entry<String, String> entry : vnp_Params.entrySet()) {
            if (entry.getValue() != null && !entry.getValue().isEmpty()) {
                queryUrl.append(URLEncoder.encode(entry.getKey(), StandardCharsets.UTF_8.toString()));
                queryUrl.append('=');
                queryUrl.append(URLEncoder.encode(entry.getValue(), StandardCharsets.UTF_8.toString()));
                queryUrl.append('&');
            }
        }
        
        if (queryUrl.length() > 0) {
            queryUrl.setLength(queryUrl.length() - 1);
        }

        String paymentUrl = VnPayConfig.vnp_PayUrl + "?" + queryUrl.toString();
        resp.sendRedirect(paymentUrl);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }
}