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
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String rawCode = request.getParameter("promoCode");
        String promoCode = (rawCode != null) ? rawCode.trim().toUpperCase() : "";

        HttpSession session = request.getSession();
        Order order = (Order) session.getAttribute("currentOrder");

        System.out.println("\n========== [APPLY PROMOTION SERVLET] ==========");
        System.out.println("📥 Mã nhập: " + promoCode);
        System.out.println("🧾 currentOrder.eventID = " + order.getEvent().getEventID());
        System.out.println("🧾 Có đơn hàng trong session không? " + (order != null));

        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        ObjectMapper mapper = new ObjectMapper();
        Map<String, Object> result = new HashMap<>();

        try {
            if (order == null) {
                result.put("valid", false);
                result.put("message", "Đơn hàng không tồn tại hoặc đã hết phiên làm việc.");
                out.print(mapper.writeValueAsString(result));
                return;
            }

// ✅ Nếu đã có mã khuyến mãi, từ chối áp dụng lại
            if (order.getPromotionCode() != null && !order.getPromotionCode().isEmpty()) {
                System.out.println("⚠️ Mã đã được áp dụng: " + order.getPromotionCode());

                result.put("valid", false);
                result.put("message", "⚠️ Mã khuyến mãi đã được áp dụng cho đơn hàng này.");
                out.print(mapper.writeValueAsString(result));
                return;
            }

            System.out.println("✅ Bắt đầu áp dụng mã cho đơn hàng có tổng: " + order.getTotalAmount());

            PromotionDAO promotionDAO = new PromotionDAO();
            BigDecimal discount = promotionDAO.calculateDiscount(promoCode, order);

            if (discount != null && discount.compareTo(BigDecimal.ZERO) > 0) {
                BigDecimal newTotal = order.getTotalAmount().subtract(discount);
                System.out.println("✅ Giảm giá hợp lệ: " + discount);
                System.out.println("🧮 Tổng mới sau giảm: " + newTotal);

                result.put("valid", true);
                result.put("discountAmount", discount);
                result.put("discountFormatted", formatCurrency(discount));
                result.put("newTotalFormatted", formatCurrency(newTotal));

                order.setPromotionCode(promoCode);
                order.setDiscountAmount(discount);
                order.setTotalAmount(newTotal);
                session.setAttribute("currentOrder", order);
            } else {
                System.out.println("❌ Không đủ điều kiện áp dụng mã.");
                result.put("valid", false);
                result.put("message", "⚠️ Mã không hợp lệ, đã hết hạn, không đúng sự kiện hoặc không đủ điều kiện áp dụng.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            result.put("valid", false);
            result.put("message", "Lỗi hệ thống khi xử lý mã giảm giá.");
        }

        out.print(mapper.writeValueAsString(result));
        out.flush();
        System.out.println("===============================================\n");
    }

    private String formatCurrency(BigDecimal amount) {
        Locale localeVN = new Locale("vi", "VN");
        NumberFormat currencyFormatter = NumberFormat.getCurrencyInstance(localeVN);
        return currencyFormatter.format(amount);
    }
}
