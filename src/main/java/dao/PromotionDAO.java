package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import context.DBConnection;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import models.Order;
import models.Promotion;

public class PromotionDAO {

    private Connection connection;

    public PromotionDAO() {
        this.connection = DBConnection.getConnection();
    }

    public boolean createPromotion(Promotion promotion) {
        String sql = "INSERT INTO promotions (event_id, promotion_name, promotion_code, "
                + "start_time, end_time, is_active) VALUES (?, ?, ?, ?, ?, ?)";

        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setInt(1, promotion.getEventID());
            pstmt.setString(2, promotion.getPromotionName());
            pstmt.setString(3, promotion.getPromotionCode());
            pstmt.setTimestamp(4, promotion.getStartTime());
            pstmt.setTimestamp(5, promotion.getEndTime());
            pstmt.setBoolean(6, promotion.isActive());

            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Promotion> getPromotionsByEventId(int eventId) {
        List<Promotion> promotions = new ArrayList<>();
        String sql = "SELECT * FROM promotions WHERE event_id = ?";

        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setInt(1, eventId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                Promotion promotion = new Promotion();
                promotion.setPromotionID(rs.getInt("promotion_id"));
                promotion.setEventID(rs.getInt("event_id"));
                promotion.setPromotionName(rs.getString("promotion_name"));
                promotion.setPromotionCode(rs.getString("promotion_code"));
                promotion.setStartTime(rs.getTimestamp("start_time"));
                promotion.setEndTime(rs.getTimestamp("end_time"));
                promotion.setActive(rs.getBoolean("is_active"));
                promotions.add(promotion);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return promotions;
    }

    public Promotion getPromotionByCode(String code) {
        if (code == null || code.trim().isEmpty()) {
            System.out.println("❌ [getPromotionByCode] Mã truyền vào rỗng.");
            return null;
        }

        String cleanedCode = code.trim().toUpperCase();
        System.out.println("🔍 [getPromotionByCode] Mã đã nhập: [" + cleanedCode + "]");

        String sql = "SELECT * FROM Promotions WHERE UPPER(RTRIM(LTRIM(PromotionCode))) = ? AND IsActive = 1";

        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setString(1, cleanedCode);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                System.out.println("✅ [getPromotionByCode] Tìm thấy mã: " + rs.getString("PromotionCode"));
                Promotion promotion = new Promotion();
                promotion.setPromotionID(rs.getInt("PromotionID"));
                promotion.setEventID(rs.getInt("EventID"));
                promotion.setPromotionName(rs.getString("PromotionName"));
                promotion.setPromotionCode(rs.getString("PromotionCode"));
                promotion.setPromotionType(rs.getString("PromotionType"));
                promotion.setStartTime(rs.getTimestamp("StartTime"));
                promotion.setEndTime(rs.getTimestamp("EndTime"));
                promotion.setDiscountPercentage(rs.getBigDecimal("DiscountPercentage"));
                promotion.setDiscountAmount(rs.getBigDecimal("DiscountAmount"));
                promotion.setMinOrderAmount(rs.getBigDecimal("MinOrderAmount"));
                promotion.setMaxDiscountAmount(rs.getBigDecimal("MaxDiscountAmount"));
                promotion.setMaxUsageCount(rs.getInt("MaxUsageCount"));
                promotion.setCurrentUsageCount(rs.getInt("CurrentUsageCount"));
                promotion.setActive(rs.getBoolean("IsActive"));
                return promotion;
            } else {
                System.out.println("❌ [getPromotionByCode] KHÔNG tìm thấy mã trong DB: [" + cleanedCode + "]");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public BigDecimal calculateDiscount(String code, Order order) {
        System.out.println("\n================ DEBUG ÁP DỤNG MÃ GIẢM GIÁ ================");

        // 1️⃣: Truy xuất mã từ DB
        Promotion promotion = getPromotionByCode(code);
        if (promotion == null) {
            System.out.println("❌ [B1] Mã không tồn tại hoặc đã bị vô hiệu hóa.");
            return BigDecimal.ZERO;
        }
        System.out.println("✅ [B1] Mã tồn tại: " + promotion.getPromotionCode());

        // 2️⃣: So khớp Event ID
        int promoEventId = promotion.getEventID();
        int orderEventId = order.getEvent().getEventID();
        System.out.println("➡️ [B2] promotion.EventID = " + promoEventId);
        System.out.println("➡️ [B2] order.EventID     = " + orderEventId);
        if (promoEventId != orderEventId) {
            System.out.println("❌ [B2] Mã không áp dụng cho sự kiện hiện tại.");
            return BigDecimal.ZERO;
        }

        // 3️⃣: Kiểm tra thời gian hiệu lực
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime start = promotion.getStartTime().toLocalDateTime();
        LocalDateTime end = promotion.getEndTime().toLocalDateTime();
        System.out.println("🕓 [B3] Hiện tại: " + now);
        System.out.println("🗓 [B3] Hiệu lực: " + start + " → " + end);
        if (now.isBefore(start) || now.isAfter(end)) {
            System.out.println("❌ [B3] Mã đã hết hạn hoặc chưa bắt đầu.");
            return BigDecimal.ZERO;
        }

        // 4️⃣: Kiểm tra điều kiện tổng tiền tối thiểu
        BigDecimal orderAmount = order.getTotalAmount();
        BigDecimal minAmount = promotion.getMinOrderAmount();
        System.out.println("💰 [B4] Tổng tiền đơn hàng: " + orderAmount);
        System.out.println("🔒 [B4] Yêu cầu tối thiểu: " + minAmount);
        if (minAmount != null && orderAmount.compareTo(minAmount) < 0) {
            System.out.println("❌ [B4] Đơn hàng không đủ điều kiện tối thiểu.");
            return BigDecimal.ZERO;
        }

        // 5️⃣: Kiểm tra lượt sử dụng tối đa
        int current = promotion.getCurrentUsageCount();
        int max = promotion.getMaxUsageCount();
        System.out.println("🔁 [B5] Usage: " + current + "/" + max);
        if (max > 0 && current >= max) {
            System.out.println("❌ [B5] Mã đã vượt quá số lượt sử dụng.");
            return BigDecimal.ZERO;
        }

        // ✅ Tính giảm giá
        BigDecimal discount = BigDecimal.ZERO;
        switch (promotion.getPromotionType()) {
            case "percentage":
                System.out.println("📐 [TÍNH] Kiểu phần trăm: " + promotion.getDiscountPercentage());
                if (promotion.getDiscountPercentage() != null) {
                    discount = orderAmount.multiply(promotion.getDiscountPercentage())
                            .divide(new BigDecimal(100));
                    if (promotion.getMaxDiscountAmount() != null
                            && discount.compareTo(promotion.getMaxDiscountAmount()) > 0) {
                        discount = promotion.getMaxDiscountAmount();
                        System.out.println("⚠️ [TÍNH] Đạt giới hạn giảm tối đa: " + discount);
                    }
                }
                break;

            case "fixed_amount":
                System.out.println("💵 [TÍNH] Kiểu số tiền cố định: " + promotion.getDiscountAmount());
                discount = promotion.getDiscountAmount() != null ? promotion.getDiscountAmount() : BigDecimal.ZERO;
                if (discount.compareTo(orderAmount) > 0) {
                    discount = orderAmount;
                }
                break;

            case "buy_x_get_y":
                System.out.println("⚠️ [TÍNH] Chưa hỗ trợ loại buy_x_get_y.");
                break;

            default:
                System.out.println("❌ [TÍNH] Loại mã không xác định: " + promotion.getPromotionType());
                break;
        }

        System.out.println("🎉 [KẾT QUẢ] Mức giảm áp dụng: " + discount);
        System.out.println("============================================================\n");
        return discount;
    }

}
