package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import dao.NotificationDAO;
import models.Notification;
import java.time.LocalDateTime;

@WebServlet("/test-notification")
public class TestNotificationServlet extends HttpServlet {
    
    private NotificationDAO notificationDAO;
    
    @Override
    public void init() throws ServletException {
        notificationDAO = new NotificationDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            // Create a test refund notification
            Notification refundNotification = new Notification();
            refundNotification.setUserID(1); // Admin ID
            refundNotification.setNotificationType("order");
            refundNotification.setTitle("Yêu cầu hoàn tiền mới");
            refundNotification.setContent("Người gửi: Nguyễn Văn A (ID: 15) | Lý do: Vé bị hủy do sự kiện bị hoãn | Số tiền: 500,000 VNĐ | Đơn hàng: #123");
            refundNotification.setRelatedID(123);
            refundNotification.setIsRead(false);
            refundNotification.setCreatedAt(LocalDateTime.now());
            refundNotification.setPriority("high");
            
            boolean saved = notificationDAO.insertNotification(refundNotification);
            
            out.println("<html><body>");
            out.println("<h1>Test Notification Created</h1>");
            out.println("<p>Notification saved: " + saved + "</p>");
            out.println("<p>Content: " + refundNotification.getContent() + "</p>");
            out.println("<p><a href='../managerPage/AdminDashboard.jsp'>Go to Admin Dashboard</a></p>");
            out.println("</body></html>");
            
            System.out.println("🧪 Test notification created with content: " + refundNotification.getContent());
            
        } catch (Exception e) {
            out.println("<html><body>");
            out.println("<h1>Error</h1>");
            out.println("<p>Error: " + e.getMessage() + "</p>");
            out.println("</body></html>");
            e.printStackTrace();
        }
    }
} 