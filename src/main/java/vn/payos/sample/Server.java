//package vn.payos.sample;
//
//import static spark.Spark.post;
//import static spark.Spark.port;
//import static spark.Spark.staticFiles;
//import static spark.Spark.get; // THÊM DÒNG NÀY để có thể sử dụng get() cho các route
//
//import java.nio.file.Paths;
//import java.util.ArrayList;
//import java.util.List;
//
//import com.google.gson.Gson;
//import com.google.gson.JsonSyntaxException;
//
//import org.json.JSONObject; // Import thư viện JSON
//
//import vn.payos.PayOS;
//import vn.payos.type.CheckoutResponseData;
//import vn.payos.type.ItemData;
//import vn.payos.type.PaymentData;
//
//public class Server {
//
//
//
//    public static void main(String[] args) {
//        port(3000);
//
//        final PayOS payOS = new PayOS(YOUR_CLIENT_ID, YOUR_API_KEY, YOUR_CHECKSUM_KEY);
//
//        // Cấu hình thư mục chứa các tệp tĩnh
//        // Đảm bảo bạn có thư mục "public" ở cùng cấp với thư mục src/main/java
//        staticFiles.externalLocation(Paths.get("public").toAbsolutePath().toString());
//
//        // --- API Endpoint để tạo liên kết thanh toán nhúng ---
//        post("/create-payment-link", (request, response) -> {
//            response.type("application/json");
//
//            try {
//                JSONObject requestBody = new JSONObject(request.body());
//
//                String eventName = requestBody.getString("eventName");
//                int ticketPrice = requestBody.getInt("ticketPrice");
//                int quantity = requestBody.getInt("quantity");
//                String description = requestBody.getString("description");
//
//                // Tính toán tổng số tiền
//                int totalAmount = ticketPrice * quantity;
//
//                Long orderCode = System.currentTimeMillis() / 1000;
//
//                String domain = "http://localhost:3000";
//
//                List<ItemData> items = new ArrayList<>();
//                items.add(ItemData.builder()
//                                .name(eventName + " - " + quantity + " vé")
//                                .quantity(quantity)
//                                .price(ticketPrice)
//                                .build());
//
//                // Tạo PaymentData object
//                PaymentData paymentData = PaymentData.builder()
//                        .orderCode(orderCode)
//                        .amount(totalAmount)
//                        .description(description)
//                        .returnUrl(domain + "/success") // URL khi thanh toán thành công
//                        .cancelUrl(domain + "/cancel") // URL khi thanh toán bị hủy
//                        .items(items) // RẤT QUAN TRỌNG: Phải thêm danh sách items vào đây
//                        .build();
//
//                CheckoutResponseData result = payOS.createPaymentLink(paymentData);
//
//                return new Gson().toJson(result);
//
//            } catch (JsonSyntaxException e) {
//                response.status(400); // Bad Request
//                return new Gson().toJson(new ErrorResponse("Invalid JSON format in request body."));
//            } catch (Exception e) {
//                e.printStackTrace();
//                response.status(500); // Internal Server Error
//                return new Gson().toJson(new ErrorResponse("Failed to create payment link: " + e.getMessage()));
//            }
//        });
//
//        // --- Các route cho trang tĩnh (ví dụ: trang thành công/thất bại) ---
//        // SỬA LỖI: Sử dụng 'get' thay vì 'staticFiles.get'
//        get("/", (request, response) -> {
//            response.redirect("index.html");
//            return null;
//        });
//
//        get("/success", (request, response) -> {
//            response.redirect("success.html");
//            return null;
//        });
//
//        get("/cancel", (request, response) -> {
//            response.redirect("cancel.html");
//            return null;
//        });
//
//        System.out.println("Server started on port 3000. Access http://localhost:3000");
//        System.out.println("Endpoint to create payment link: POST http://localhost:3000/create-payment-link");
//    }
//
//    static class ErrorResponse {
//        private String message;
//
//        public ErrorResponse(String message) {
//            this.message = message;
//        }
//    }
//}