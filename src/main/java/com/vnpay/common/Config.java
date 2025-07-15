//package com.vnpay.common; // Hoặc com.vnpay.common tùy theo package của bạn
//
//import jakarta.servlet.http.HttpServletRequest; // <<< ĐÃ SỬA LỖI TẠI ĐÂY
//import java.nio.charset.StandardCharsets;
//import java.util.ArrayList;
//import java.util.Collections;
//import java.util.List;
//import java.util.Map;
//import javax.crypto.Mac;
//import javax.crypto.spec.SecretKeySpec;
//
//public class Config {
//
//    public static String vnp_PayUrl = "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html";
//    public static String vnp_ReturnUrl = "http://localhost:8080/OnlineSellingTicketEvents/VNPayReturnServlet"; // Nhớ kiểm tra lại Context Path
//    public static String vnp_TmnCode = "9536C0G4"; // Thay bằng TmnCode của bạn
//    public static String vnp_HashSecret = "2XI0DW8NBKM72RQU2LV5B8EWFI6ZBX8Z"; // Thay bằng Secret Key của bạn
//    public static String vnp_Version = "2.1.0";
//    public static String vnp_ApiUrl = "https://sandbox.vnpayment.vn/merchant_webapi/api/transaction";
//
//    public static String getDataToSign(Map<String, String> fields) {
//        List<String> fieldNames = new ArrayList<>(fields.keySet());
//        Collections.sort(fieldNames);
//        StringBuilder sb = new StringBuilder();
//        for (String fieldName : fieldNames) {
//            String fieldValue = fields.get(fieldName);
//            if ((fieldValue != null) && (!fieldValue.isEmpty())) {
//                if (sb.length() > 0) {
//                    sb.append('&');
//                }
//                sb.append(fieldName);
//                sb.append('=');
//                sb.append(fieldValue);
//            }
//        }
//        return sb.toString();
//    }
//
//    public static String hmacSHA512(final String key, final String data) {
//        try {
//            if (key == null || data == null) {
//                throw new NullPointerException("Key or data to hash is null");
//            }
//            final Mac hmac512 = Mac.getInstance("HmacSHA512");
//            byte[] hmacKeyBytes = key.getBytes(StandardCharsets.UTF_8);
//            final SecretKeySpec secretKey = new SecretKeySpec(hmacKeyBytes, "HmacSHA512");
//            hmac512.init(secretKey);
//            byte[] dataBytes = data.getBytes(StandardCharsets.UTF_8);
//            byte[] result = hmac512.doFinal(dataBytes);
//            StringBuilder sb = new StringBuilder(2 * result.length);
//            for (byte b : result) {
//                sb.append(String.format("%02x", b & 0xff));
//            }
//            return sb.toString();
//        } catch (Exception ex) {
//            throw new RuntimeException("Failed to generate HMAC-SHA512", ex);
//        }
//    }
//
//    public static String getIpAddress(HttpServletRequest request) { // Tham số request bây giờ đã đúng kiểu
//        String ipAddress = request.getHeader("X-FORWARDED-FOR");
//        if (ipAddress == null || ipAddress.isEmpty() || "unknown".equalsIgnoreCase(ipAddress)) {
//            ipAddress = request.getRemoteAddr();
//        }
//        return ipAddress;
//    }
//}