package services;

import models.Order;
import models.OrderItem;
import models.User;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

import java.math.BigDecimal;
import java.text.NumberFormat;
import java.time.format.DateTimeFormatter;
import java.util.Locale;
import java.util.Properties;

public class EmailService {

    // --- CẤU HÌNH EMAIL CỦA BẠN ---
    // Thay thế bằng thông tin email của bạn.
    // Để an toàn, những thông tin này nên được đọc từ một file config thay vì viết cứng trong code.
    private static final String EMAIL_USERNAME = "lephuochat@gmail.com"; // Email của bạn
    private static final String EMAIL_PASSWORD = "hmwc apqt hnrp wffg"; // Mật khẩu ứng dụng của Gmail
    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "587"; // Port cho TLS

    public void sendOrderConfirmationEmail(User user, Order order) {
        // Cấu hình thuộc tính cho phiên gửi mail
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true"); // Yêu cầu xác thực
        props.put("mail.smtp.starttls.enable", "true"); // Sử dụng TLS
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", SMTP_PORT);

        // Tạo một phiên (Session) với authenticator
        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(EMAIL_USERNAME, EMAIL_PASSWORD);
            }
        });

        try {
            // Tạo đối tượng MimeMessage
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(EMAIL_USERNAME));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(user.getEmail()));
            message.setSubject("Xác nhận đơn hàng #" + order.getOrderNumber() + " từ MasterTicket");

            // Tạo nội dung email bằng HTML để trông chuyên nghiệp
            String htmlContent = buildHtmlEmailContent(user, order);
            message.setContent(htmlContent, "text/html; charset=utf-8");

            // Gửi email
            Transport.send(message);

            System.out.println("Đã gửi email xác nhận thành công tới " + user.getEmail());

        } catch (MessagingException e) {
            e.printStackTrace();
            // Có thể throw một exception tùy chỉnh ở đây để xử lý ở tầng trên
            System.err.println("Gửi email thất bại: " + e.getMessage());
        }
    }

    private String buildHtmlEmailContent(User user, Order order) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HH:mm, dd/MM/yyyy");
        Locale localeVN = new Locale("vi", "VN");
        NumberFormat currencyFormatter = NumberFormat.getCurrencyInstance(localeVN);

        StringBuilder sb = new StringBuilder();
        sb.append("<html><body style='font-family: Arial, sans-serif; color: #333;'>");
        sb.append("<div style='max-width: 600px; margin: auto; border: 1px solid #ddd; padding: 20px;'>");
        sb.append("<h2 style='color: #4a4aff;'>Cảm ơn bạn đã đặt vé tại MasterTicket!</h2>");
        sb.append("<p>Chào <strong>").append(user.getEmail()).append("</strong>,</p>");
        sb.append("<p>Đơn hàng của bạn đã được xác nhận thành công. Dưới đây là thông tin chi tiết:</p>");
        sb.append("<hr>");
        sb.append("<h3>Thông tin đơn hàng</h3>");
        sb.append("<p><strong>Mã đơn hàng:</strong> ").append(order.getOrderNumber()).append("</p>");
        sb.append("<p><strong>Ngày đặt:</strong> ").append(order.getCreatedAt().format(formatter)).append("</p>");
        sb.append("<p><strong>Tổng tiền:</strong> <span style='color: #ff4da6; font-weight: bold;'>").append(currencyFormatter.format(order.getTotalAmount())).append("</span></p>");
        sb.append("<hr>");
        sb.append("<h3>Chi tiết vé</h3>");
        
        for (OrderItem item : order.getItems()) {
            sb.append("<div style='margin-bottom: 10px; padding-bottom: 10px; border-bottom: 1px solid #eee;'>");
            sb.append("<p><strong>Loại vé:</strong> ").append(item.getTicketTypeName()).append("</p>");
            sb.append("<p><strong>Số lượng:</strong> ").append(item.getQuantity()).append("</p>");
            sb.append("<p><strong>Đơn giá:</strong> ").append(currencyFormatter.format(item.getUnitPrice())).append("</p>");
            sb.append("</div>");
        }
        
        sb.append("<hr>");
        sb.append("<p>Bạn có thể xem lại vé và mã QR tại mục <a href='URL_TO_PURCHASED_TICKETS_PAGE'>Vé đã mua</a> trên trang web của chúng tôi.</p>");
        sb.append("<p>Trân trọng,<br>Đội ngũ MasterTicket</p>");
        sb.append("</div></body></html>");

        return sb.toString();
    }
}