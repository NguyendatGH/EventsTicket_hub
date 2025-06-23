//package controller;
//
//import com.vnpay.common.Config;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.HttpServlet;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//
//import java.io.IOException;
//import java.util.ArrayList;
//import java.util.Collections;
//import java.util.HashMap;
//import java.util.List;
//import java.util.Map;
//
//@WebServlet(name = "VNPayReturnServlet", urlPatterns = {"/VNPayReturnServlet"})
//public class VNPayReturnServlet extends HttpServlet {
//
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        Map<String, String> fields = new HashMap<>();
//        for (Map.Entry<String, String[]> entry : request.getParameterMap().entrySet()) {
//            fields.put(entry.getKey(), entry.getValue()[0]);
//        }
//
//        String vnp_SecureHash_received = fields.remove("vnp_SecureHash");
//        if (fields.containsKey("vnp_SecureHashType")) {
//            fields.remove("vnp_SecureHashType");
//        }
//
//        String hashData_recreated = Config.getDataToSign(fields);
//        String signValue_recreated = Config.hmacSHA512(Config.vnp_HashSecret, hashData_recreated);
//
//        // --- IN LOG DEBUG ---
//        System.out.println("\n================== VNPAY DEBUG - NHẬN PHẢN HỒI ================");
//        System.out.println("Dữ liệu gốc tái tạo để kiểm tra chữ ký (raw hashData):");
//        System.out.println(hashData_recreated);
//        System.out.println("Chữ ký tái tạo (của bạn):");
//        System.out.println(signValue_recreated);
//        System.out.println("Chữ ký nhận được (của VNPAY):");
//        System.out.println(vnp_SecureHash_received);
//        System.out.println("--- Chi tiết các tham số nhận được ---");
//        List<String> fieldNames = new ArrayList<>(fields.keySet());
//        Collections.sort(fieldNames);
//        for(String fieldName : fieldNames) {
//            System.out.println(fieldName + "=" + fields.get(fieldName));
//        }
//        System.out.println("================================================================");
//        // --- KẾT THÚC IN LOG ---
//
//        if (signValue_recreated.equals(vnp_SecureHash_received)) {
//            // ... xử lý logic thành công/thất bại như cũ
//        } else {
//            request.setAttribute("status", "error");
//            request.setAttribute("message", "Lỗi: Chữ ký không hợp lệ!");
//        }
//        request.getRequestDispatcher("/pages/PaymentResult.jsp").forward(request, response);
//    }
//}