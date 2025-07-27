package controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.websocket.OnClose;
import jakarta.websocket.OnOpen;
import jakarta.websocket.Session;
import jakarta.websocket.server.ServerEndpoint;
import models.Notification;
import java.io.IOException;
import java.util.Set;
import java.util.concurrent.CopyOnWriteArraySet;

@ServerEndpoint("/websocket/admin-notification")
public class AdminNotificationWebSocket {
    private static final Set<Session> adminSessions = new CopyOnWriteArraySet<>();
    private static final ObjectMapper objectMapper = new ObjectMapper();

    @OnOpen
    public void onOpen(Session session) {
        adminSessions.add(session);
    }

    @OnClose
    public void onClose(Session session) {
        adminSessions.remove(session);
    }

    public static void sendToAllAdmins(Notification notification) {
        try {
            String json = objectMapper.writeValueAsString(notification);
            for (Session session : adminSessions) {
                if (session.isOpen()) {
                    session.getAsyncRemote().sendText(json);
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
} 