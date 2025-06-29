//package controller;
//
//import com.vnpay.common.Config;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.HttpServlet;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import jakarta.servlet.http.HttpSession;
//import models.Order;
//
//import java.io.IOException;
//import java.net.URLEncoder;
//import java.nio.charset.StandardCharsets;
//import java.text.SimpleDateFormat;
//import java.util.*;
//
//@WebServlet(name = "VNPayPaymentServlet", urlPatterns = {"/VNPayPaymentServlet"})
//public class VNPayPaymentServlet extends HttpServlet {
//
//    @Override
//    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
//        HttpSession session = req.getSession(false);
//        Order order = (session != null) ? (Order) session.getAttribute("currentOrder") : null;
//
//        if (order == null || order.getTotalAmount() == null || order.getTotalAmount().longValue() <= 0) {
//            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Đơn hàng không hợp lệ.");
//            return;
//        }
//
//        Map<String, String> vnp_Params = new HashMap<>();
//        vnp_Params.put("vnp_Version", Config.vnp_Version);
//        vnp_Params.put("vnp_Command", "pay");
//        vnp_Params.put("vnp_TmnCode", Config.vnp_TmnCode);
//        vnp_Params.put("vnp_Amount", String.valueOf(order.getTotalAmount().longValue() * 100));
//        vnp_Params.put("vnp_CurrCode", "VND");
//        vnp_Params.put("vnp_TxnRef", String.valueOf(System.currentTimeMillis()));
//        vnp_Params.put("vnp_OrderInfo", "Thanh toan don hang " + vnp_Params.get("vnp_TxnRef"));
//        vnp_Params.put("vnp_OrderType", "other");
//        vnp_Params.put("vnp_Locale", "vn");
//        vnp_Params.put("vnp_ReturnUrl", Config.vnp_ReturnUrl);
//        vnp_Params.put("vnp_IpAddr", Config.getIpAddress(req));
//
//        Calendar cld = Calendar.getInstance(TimeZone.getTimeZone("Etc/GMT+7"));
//        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
//        vnp_Params.put("vnp_CreateDate", formatter.format(cld.getTime()));
//        cld.add(Calendar.MINUTE, 15);
//        vnp_Params.put("vnp_ExpireDate", formatter.format(cld.getTime()));
//
//        // Lấy chuỗi dữ liệu chuẩn để ký
//        String hashData = Config.getDataToSign(vnp_Params);
//        String vnp_SecureHash = Config.hmacSHA512(Config.vnp_HashSecret, hashData);
//
//        // --- SỬA LỖI LOGIC TẠI ĐÂY ---
//        // Sắp xếp các trường trước khi xây dựng query string
//        List<String> fieldNames = new ArrayList<>(vnp_Params.keySet());
//        Collections.sort(fieldNames);
//
//        StringBuilder queryUrl = new StringBuilder();
//        for (String fieldName : fieldNames) {
//            String fieldValue = vnp_Params.get(fieldName);
//            if ((fieldValue != null) && (!fieldValue.isEmpty())) {
//                if (queryUrl.length() > 0) {
//                    queryUrl.append('&');
//                }
//                queryUrl.append(URLEncoder.encode(fieldName, StandardCharsets.UTF_8));
//                queryUrl.append('=');
//                queryUrl.append(URLEncoder.encode(fieldValue, StandardCharsets.UTF_8));
//            }
//        }
//        
//        // Thêm chữ ký vào cuối URL
//        queryUrl.append("&vnp_SecureHash=").append(vnp_SecureHash);
//
//        String paymentUrl = Config.vnp_PayUrl + "?" + queryUrl.toString();
//        resp.sendRedirect(paymentUrl);
//    }
//}