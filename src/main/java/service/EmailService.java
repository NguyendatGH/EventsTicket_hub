package service;

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

    private static final String EMAIL_USERNAME = "lephuochat@gmail.com";
    private static final String EMAIL_PASSWORD = "hmwc apqt hnrp wffg";
    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "587";

    public void sendOrderConfirmationEmail(User user, Order order) {

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", SMTP_PORT);

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(EMAIL_USERNAME, EMAIL_PASSWORD);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(EMAIL_USERNAME));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(user.getEmail()));
            message.setSubject("Xác nhận đơn hàng #" + order.getOrderNumber() + " từ MasterTicket");

            String htmlContent = buildHtmlEmailContent(user, order);
            message.setContent(htmlContent, "text/html; charset=utf-8");

            Transport.send(message);

            System.out.println("Đã gửi email xác nhận thành công tới " + user.getEmail());

        } catch (MessagingException e) {
            e.printStackTrace();
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
        sb.append("<p><strong>Mã đơn hàng:</strong> ").append(order.getOrderNumber()).append("</p>");
        sb.append("<p><strong>Ngày đặt:</strong> ").append(order.getCreatedAt().format(formatter)).append("</p>");
        sb.append("<p><strong>Tổng tiền:</strong> <span style='color: #ff4da6; font-weight: bold;'>")
          .append(currencyFormatter.format(order.getTotalAmount())).append("</span></p>");
        sb.append("<hr>");

        sb.append("<h3>Chi tiết vé</h3>");
        sb.append("<table style='width:100%; border-collapse: collapse;'>");
        sb.append("<tr><th style='border-bottom: 1px solid #ccc; text-align: left;'>Loại vé</th>");
        sb.append("<th style='border-bottom: 1px solid #ccc; text-align: right;'>Số lượng</th>");
        sb.append("<th style='border-bottom: 1px solid #ccc; text-align: right;'>Đơn giá</th></tr>");

        for (OrderItem item : order.getItems()) {
            sb.append("<tr>");
            sb.append("<td>").append(item.getTicketTypeName()).append("</td>");
            sb.append("<td style='text-align: right;'>").append(item.getQuantity()).append("</td>");
            sb.append("<td style='text-align: right;'>").append(currencyFormatter.format(item.getUnitPrice())).append("</td>");
            sb.append("</tr>");
        }
        sb.append("</table>");

        sb.append("<hr>");
        sb.append("<p>Bạn có thể xem lại vé và mã QR tại mục <a href='URL_TO_PURCHASED_TICKETS_PAGE'>Vé đã mua</a> trên trang web của chúng tôi.</p>");
        sb.append("<p>Trân trọng,<br>Đội ngũ MasterTicket</p>");
        sb.append("</div></body></html>");

        return sb.toString();
    }
}
