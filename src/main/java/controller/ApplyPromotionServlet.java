package controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import dao.PromotionDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import models.Order;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.text.NumberFormat;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

@WebServlet(name = "ApplyPromotionServlet", urlPatterns = {"/ApplyPromotionServlet"})
public class ApplyPromotionServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Set response headers
        response.setContentType("application/json;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        String rawCode = request.getParameter("promoCode");
        String promoCode = (rawCode != null) ? rawCode.trim().toUpperCase() : "";

        HttpSession session = request.getSession();
        Order order = (Order) session.getAttribute("currentOrder");

        System.out.println("\n========== [APPLY PROMOTION SERVLET] ==========");
        System.out.println("🎫 Mã nhập vào: [" + promoCode + "]");
        System.out.println("📝 Order trong session: " + (order != null ? "CÓ" : "KHÔNG"));

        if (order != null) {
            System.out.println("📝 Event ID: " + order.getEvent().getEventID());
            System.out.println("📝 Tổng tiền hiện tại: " + order.getTotalAmount());
            System.out.println("📝 Mã đã áp dụng: " + order.getPromotionCode());
        }

        PrintWriter out = response.getWriter();
        ObjectMapper mapper = new ObjectMapper();
        Map<String, Object> result = new HashMap<>();

        try {
            // Kiểm tra đơn hàng có tồn tại không
            if (order == null) {
                result.put("valid", false);
                result.put("message", "Đơn hàng không tồn tại hoặc đã hết phiên làm việc.");
                writeJsonResponse(out, mapper, result);
                return;
            }

            // Trường hợp đã có mã khuyến mãi được áp dụng
            if (order.getPromotionCode() != null && !order.getPromotionCode().trim().isEmpty()) {
                String existingCode = order.getPromotionCode().trim().toUpperCase();

                System.out.println("⚠️ Đã có mã được áp dụng: [" + existingCode + "]");

                // Nếu mã yêu cầu giống với mã đã áp dụng
                if (existingCode.equals(promoCode)) {
                    System.out.println("✅ Trả về thông tin mã đã áp dụng");

                    BigDecimal discount = order.getDiscountAmount() != null
                            ? order.getDiscountAmount() : BigDecimal.ZERO;
                    BigDecimal currentTotal = order.getTotalAmount();
                    BigDecimal originalTotal = currentTotal.add(discount);

                    int percent = calculateDiscountPercentage(discount, originalTotal);

                    result.put("valid", true);
                    result.put("alreadyApplied", true);
                    result.put("promotionCode", existingCode);
                    result.put("discountAmount", discount);
                    result.put("discountFormatted", formatCurrency(discount));
                    result.put("newTotalFormatted", formatCurrency(currentTotal));
                    result.put("percent", percent);
                    result.put("message", "Mã " + existingCode + " đã được áp dụng");

                    writeJsonResponse(out, mapper, result);
                    return;
                } else {
                    // Nếu muốn áp dụng mã khác
                    result.put("valid", false);
                    result.put("message", "Đã có mã khuyến mãi [" + existingCode + "] được áp dụng. "
                            + "Vui lòng hủy mã hiện tại trước khi áp dụng mã mới.");
                    writeJsonResponse(out, mapper, result);
                    return;
                }
            }

            // Áp dụng mã mới
            System.out.println("🔄 Bắt đầu kiểm tra và áp dụng mã mới...");

            PromotionDAO promotionDAO = new PromotionDAO();
            BigDecimal discount = promotionDAO.calculateDiscount(promoCode, order);

            if (discount != null && discount.compareTo(BigDecimal.ZERO) > 0) {
                BigDecimal originalTotal = order.getTotalAmount();
                BigDecimal newTotal = originalTotal.subtract(discount);

                // Đảm bảo tổng tiền không âm
                if (newTotal.compareTo(BigDecimal.ZERO) < 0) {
                    newTotal = BigDecimal.ZERO;
                    discount = originalTotal;
                }

                System.out.println("✅ Áp dụng thành công!");
                System.out.println("💰 Giảm giá: " + discount);
                System.out.println("🧮 Tổng mới: " + newTotal);

                int percent = calculateDiscountPercentage(discount, originalTotal);

                // Cập nhật đơn hàng
                order.setPromotionCode(promoCode);
                order.setDiscountAmount(discount);
                order.setTotalAmount(newTotal);
                session.setAttribute("currentOrder", order);

                // Trả về kết quả thành công
                result.put("valid", true);
                result.put("alreadyApplied", false);
                result.put("promotionCode", promoCode);
                result.put("discountAmount", discount);
                result.put("discountFormatted", formatCurrency(discount));
                result.put("newTotalFormatted", formatCurrency(newTotal));
                result.put("percent", percent);
                result.put("message", "Áp dụng mã thành công!");

            } else {
                System.out.println("❌ Không thể áp dụng mã");
                result.put("valid", false);
                result.put("message", "Mã không hợp lệ, đã hết hạn, không áp dụng cho sự kiện này hoặc không đủ điều kiện tối thiểu.");
            }

        } catch (Exception e) {
            System.err.println("❌ Lỗi xử lý mã khuyến mãi: " + e.getMessage());
            e.printStackTrace();

            result.put("valid", false);
            result.put("message", "Lỗi hệ thống khi xử lý mã giảm giá. Vui lòng thử lại.");
        }

        writeJsonResponse(out, mapper, result);
        System.out.println("===============================================\n");
    }

    /**
     * Ghi response JSON và đảm bảo format đúng
     */
    private void writeJsonResponse(PrintWriter out, ObjectMapper mapper, Map<String, Object> result) {
        try {
            String jsonResponse = mapper.writeValueAsString(result);
            System.out.println("📤 JSON Response: " + jsonResponse);
            out.print(jsonResponse);
            out.flush();
        } catch (Exception e) {
            System.err.println("❌ Lỗi khi ghi JSON response: " + e.getMessage());
            e.printStackTrace();

            // Fallback response
            out.print("{\"valid\":false,\"message\":\"Lỗi hệ thống\"}");
            out.flush();
        }
    }

    /**
     * Tính phần trăm giảm giá
     */
    private int calculateDiscountPercentage(BigDecimal discount, BigDecimal originalTotal) {
        if (discount == null || originalTotal == null || originalTotal.compareTo(BigDecimal.ZERO) <= 0) {
            return 0;
        }

        try {
            return discount.multiply(BigDecimal.valueOf(100))
                    .divide(originalTotal, 0, BigDecimal.ROUND_HALF_UP)
                    .intValue();
        } catch (Exception e) {
            System.err.println("❌ Lỗi tính phần trăm: " + e.getMessage());
            return 0;
        }
    }

    /**
     * Format tiền tệ theo định dạng Việt Nam
     */
    private String formatCurrency(BigDecimal amount) {
        if (amount == null) {
            return "0 ₫";
        }

        try {
            // Sử dụng Locale Việt Nam
            Locale localeVN = new Locale("vi", "VN");
            NumberFormat currencyFormatter = NumberFormat.getCurrencyInstance(localeVN);

            // Tùy chỉnh format để hiển thị đúng
            currencyFormatter.setMaximumFractionDigits(0);
            currencyFormatter.setMinimumFractionDigits(0);

            String formatted = currencyFormatter.format(amount);

            // Thay thế ký hiệu tiền tệ nếu cần
            formatted = formatted.replace("₫", "₫").replace("VND", "₫");

            return formatted;
        } catch (Exception e) {
            System.err.println(" Lỗi format tiền tệ: " + e.getMessage());
            return amount.toString() + " ₫";
        }
    }
}