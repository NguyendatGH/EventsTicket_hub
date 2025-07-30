package controller;

import models.Notification;
import service.NotificationService;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import jakarta.websocket.*;
import jakarta.websocket.server.ServerEndpoint;
import java.io.IOException;
import java.util.concurrent.ConcurrentHashMap;
import java.util.logging.Logger;
import java.util.List;
import java.util.Map;
import dao.UserDAO;
import dao.RefundDAO;
import models.Refund;
import models.User;

@ServerEndpoint("/websocket/notifications")
public class NotificationWebSocket {
    
    private static final Logger LOGGER = Logger.getLogger(NotificationWebSocket.class.getName());
    private static final ConcurrentHashMap<Integer, Session> userSessions = new ConcurrentHashMap<>();
    private static final ObjectMapper objectMapper = new ObjectMapper();
    
    static {
        objectMapper.registerModule(new JavaTimeModule());
    }
    
    @OnOpen
    public void onOpen(Session session) {
        try {
            Map<String, List<String>> params = session.getRequestParameterMap();
            List<String> userIdParams = params.get("userId");
            
            if (userIdParams == null || userIdParams.isEmpty()) {
                LOGGER.warning("⚠️ WebSocket connection attempt without userId parameter");
                session.close();
                return;
            }
            
            String userIdParam = userIdParams.get(0);
            int userId = Integer.parseInt(userIdParam);
            
            userSessions.put(userId, session);
            LOGGER.info("🔗 WebSocket connected for user " + userId);
            LOGGER.info("📊 Total active sessions: " + userSessions.size());
        } catch (Exception e) {
            LOGGER.severe("❌ Error in WebSocket onOpen: " + e.getMessage());
            try {
                session.close();
            } catch (IOException ex) {
                LOGGER.severe("❌ Error closing session: " + ex.getMessage());
            }
        }
    }
    
    @OnClose
    public void onClose(Session session) {
        try {
            Map<String, List<String>> params = session.getRequestParameterMap();
            List<String> userIdParams = params.get("userId");
            
            if (userIdParams == null || userIdParams.isEmpty()) {
                LOGGER.warning("⚠️ WebSocket close without userId parameter");
                return;
            }
            
            String userIdParam = userIdParams.get(0);
            int userId = Integer.parseInt(userIdParam);
            
            userSessions.remove(userId);
            LOGGER.info("🔌 WebSocket disconnected for user " + userId);
        } catch (Exception e) {
            LOGGER.severe("❌ Error in WebSocket onClose: " + e.getMessage());
        }
    }
    
    @OnError
    public void onError(Session session, Throwable throwable) {
        LOGGER.severe("❌ WebSocket error: " + throwable.getMessage());
        try {
            // Try to get userId for logging
            Map<String, List<String>> params = session.getRequestParameterMap();
            List<String> userIdParams = params.get("userId");
            if (userIdParams != null && !userIdParams.isEmpty()) {
                int userId = Integer.parseInt(userIdParams.get(0));
                LOGGER.severe("❌ WebSocket error for user " + userId);
            }
        } catch (Exception e) {
            LOGGER.severe("❌ Error getting userId for error logging: " + e.getMessage());
        }
    }
    
    public static void sendNotificationToUser(int userId, Notification notification) {
        Session session = userSessions.get(userId);
        if (session != null && session.isOpen()) {
            try {
                String notificationJson = objectMapper.writeValueAsString(notification);
                session.getBasicRemote().sendText(notificationJson);
                LOGGER.info("📡 Sent notification to user " + userId + ": " + notification.getTitle());
            } catch (IOException e) {
                LOGGER.severe("❌ Error sending notification to user " + userId + ": " + e.getMessage());
            }
        } else {
            LOGGER.warning("⚠️ No active session for user " + userId);
        }
    }
    
    public static void sendRefundNotification(int refundId, String refundAmount, String refundReason) {
        try {
            // Get user information for the refund request
            UserDAO userDAO = new UserDAO();
            RefundDAO refundDAO = new RefundDAO();
            
            // Get refund details to find the user
            Refund refund = refundDAO.getRefundById(refundId);
            if (refund == null) {
                LOGGER.severe("❌ Refund not found for ID: " + refundId);
                return;
            }
            
            // Get user information
            User user = userDAO.findWithID(refund.getUserId());
            String senderName = user != null ? user.getName() : "Khách hàng";
            String senderId = String.valueOf(refund.getUserId());
            
            Notification notification = new Notification();
            notification.setUserID(1); // Admin ID
            notification.setNotificationType("order");
            notification.setTitle("Yêu cầu hoàn tiền mới");
            notification.setContent("Người gửi: " + senderName + " (ID: " + senderId + ") | Lý do: " + refundReason + " | Số tiền: " + refundAmount + " VNĐ | Đơn hàng: #" + refund.getOrderId());
            notification.setRelatedID(refundId);
            notification.setIsRead(false);
            notification.setCreatedAt(java.time.LocalDateTime.now());
            notification.setPriority("high");
            
            // Save to database
            NotificationService notificationService = new NotificationService();
            boolean saved = notificationService.insertNotification(notification);
            
            if (saved) {
                sendNotificationToUser(1, notification);
                LOGGER.info("✅ Refund notification created and sent to admin");
            } else {
                LOGGER.severe("❌ Failed to save refund notification to database");
            }
        } catch (Exception e) {
            LOGGER.severe("❌ Error creating refund notification: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    public static void sendSupportNotification(int supportId, String supportSubject, String supportMessage) {
        try {
            // Get user information for the support request
            UserDAO userDAO = new UserDAO();
            dao.SupportDAO supportDAO = new dao.SupportDAO();
            
            // Get support details to find the user
            models.SupportItem support = supportDAO.getSupportById(supportId);
            if (support == null) {
                LOGGER.severe("❌ Support request not found for ID: " + supportId);
                return;
            }
            
            // Get user information
            User user = userDAO.findWithID(support.getUserId());
            String senderName = user != null ? user.getName() : "Khách hàng";
            String senderId = String.valueOf(support.getUserId());
            
            Notification notification = new Notification();
            notification.setUserID(1); // Admin ID
            notification.setNotificationType("system");
            notification.setTitle("Yêu cầu hỗ trợ mới");
            notification.setContent("Người gửi: " + senderName + " (ID: " + senderId + ") | Lý do: " + supportSubject + " | Loại hỗ trợ: " + support.getCategory() + " | Mô tả: " + supportMessage);
            notification.setRelatedID(supportId);
            notification.setIsRead(false);
            notification.setCreatedAt(java.time.LocalDateTime.now());
            notification.setPriority("medium");
            
            // Save to database
            NotificationService notificationService = new NotificationService();
            boolean saved = notificationService.insertNotification(notification);
            
            if (saved) {
                sendNotificationToUser(1, notification);
                LOGGER.info("✅ Support notification created and sent to admin");
            } else {
                LOGGER.severe("❌ Failed to save support notification to database");
            }
        } catch (Exception e) {
            LOGGER.severe("❌ Error creating support notification: " + e.getMessage());
            e.printStackTrace();
        }
    }
} 