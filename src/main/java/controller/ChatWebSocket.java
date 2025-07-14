package controller;

import com.fasterxml.jackson.databind.ObjectMapper;

import jakarta.websocket.*;
import jakarta.websocket.server.ServerEndpoint;
import models.Message;
import service.ChatService;
import dto.UserDTO;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CopyOnWriteArraySet;
import java.util.logging.Logger;
import jakarta.servlet.http.HttpSession;

@ServerEndpoint("/websocket/chat")
public class ChatWebSocket {
    private static final Logger LOGGER = Logger.getLogger(ChatWebSocket.class.getName());
    private static final ObjectMapper objectMapper = new ObjectMapper();
    private static final ChatService chatService = new ChatService();
    private static final ConcurrentHashMap<Integer, CopyOnWriteArraySet<Session>> conversationSessions = new ConcurrentHashMap<>();

    @OnOpen
    public void onOpen(Session session, EndpointConfig config) {
        try {
            String conversationIdStr = getQueryParam(session, "conversation_id");
            String userIdStr = getQueryParam(session, "user_id");

         
            if (userIdStr.isEmpty() || userIdStr == null) {
                LOGGER.warning("Missing current userId params");
                session.close(new CloseReason(CloseReason.CloseCodes.NORMAL_CLOSURE, "User not logged in"));
                return;
            }

            LOGGER.info(
                    "WebSocket onOpen - conversation_id: " + (conversationIdStr != null ? conversationIdStr : "null"));

            if (conversationIdStr == null || conversationIdStr.isEmpty()) {
                LOGGER.warning("Missing or empty conversation_id "
                        + conversationIdStr);
                session.close(
                        new CloseReason(CloseReason.CloseCodes.NORMAL_CLOSURE, "Missing conversation_id or user_id"));
                return;
            }

            int conversationId = Integer.parseInt(conversationIdStr);
            int userId = Integer.parseInt(userIdStr);

            session.getUserProperties().put("conversation_id", conversationId);
            session.getUserProperties().put("user_id", userId);
            // session.getUserProperties().put("username", user.getName());

            conversationSessions.computeIfAbsent(conversationId, k -> new CopyOnWriteArraySet<>()).add(session);

            LOGGER.info("WebSocket connection opened for user " + userId + " in conversation " + conversationId);
            LOGGER.info("Total sessions for conversation " + conversationId + ": "
                    + conversationSessions.get(conversationId).size());
        } catch (NumberFormatException e) {
            LOGGER.severe("Invalid format for conversation_id or user_id: " + e.getMessage());
            try {
                session.close(new CloseReason(CloseReason.CloseCodes.NORMAL_CLOSURE,
                        "Invalid conversation_id or user_id format"));
            } catch (IOException ex) {
                LOGGER.severe("Error closing session: " + ex.getMessage());
            }
        } catch (IOException e) {
            LOGGER.severe("Error in onOpen: " + e.getMessage());
            try {
                session.close(new CloseReason(CloseReason.CloseCodes.UNEXPECTED_CONDITION, "Error in onOpen"));
            } catch (IOException ex) {
                LOGGER.severe("Error closing session: " + ex.getMessage());
            }
        }
    }

    @OnMessage
    public void onMessage(String messageJson, Session session) {
        try {
            Message message = objectMapper.readValue(messageJson, Message.class);
            Integer conversationId = (Integer) session.getUserProperties().get("conversation_id");
            Integer userId = (Integer) session.getUserProperties().get("user_id");
            // String username = (String) session.getUserProperties().get("username");

            if (conversationId == null || userId == null) {
                LOGGER.warning("Missing conversation_id or user_id in session");
                return;
            }
            message.setSenderID(userId);
            message.setConversationID(conversationId);
            message.setCreatedAt(new Date());
            // String username = chatService.getConversationName(conversationId, userId);
            // message.setUsername(username);

            HttpSession httpSession = (HttpSession) session.getUserProperties().get("jakarta.servlet.http.HttpSession");
            UserDTO user = (UserDTO) httpSession.getAttribute("user");

            String username = user != null ? user.getName() : "unknow";
            LOGGER.info("Received message from user " + userId + " in conversation " + conversationId + ": "
                    + message.getMessageContent());

            int messageId = chatService.saveMessage(message, conversationId);
            if (messageId == -1) {
                LOGGER.severe("Failed to save message for conversationId: " + conversationId);
                return;
            }

            message.setMessageID(messageId);
            Map<String, Object> messagePayload = new HashMap<>();
            messagePayload.put("message", message);
            messagePayload.put("username", username);
            
            broadcastMessage(message, conversationId);
        } catch (Exception e) {
            LOGGER.severe("Error processing message: " + e.getMessage());
            e.printStackTrace();
        }
    }

    @OnClose
    public void onClose(Session session, CloseReason closeReason) {
        try {
            Integer conversationId = (Integer) session.getUserProperties().get("conversation_id");
            Integer userId = (Integer) session.getUserProperties().get("user_id");
            if(userId == null ) System.out.println("user id null");
            if (conversationId != null) {
                CopyOnWriteArraySet<Session> sessions = conversationSessions.get(conversationId);
                if (sessions != null) {
                    sessions.remove(session);
                    if (sessions.isEmpty()) {
                        conversationSessions.remove(conversationId);
                    }
                }
                LOGGER.info("WebSocket connection closed for user " + userId + " in conversation " + conversationId
                        + ", reason: " + closeReason.getReasonPhrase());
            }
        } catch (Exception e) {
            LOGGER.severe("Error in onClose: " + e.getMessage());
        }
    }

    @OnError
    public void onError(Session session, Throwable throwable) {
        LOGGER.severe("WebSocket error: " + throwable.getMessage());
        throwable.printStackTrace();
    }

    private String getQueryParam(Session session, String paramName) {
        String queryString = session.getQueryString();
        if (queryString != null) {
            String[] params = queryString.split("&");
            for (String param : params) {
                String[] keyValue = param.split("=");
                if (keyValue.length == 2 && keyValue[0].equals(paramName)) {
                    return keyValue[1];
                }
            }
        }
        return null;
    }

    public static void broadcastMessage(Message message, int conversationId) throws IOException {
        CopyOnWriteArraySet<Session> sessions = conversationSessions.get(conversationId);
        if (sessions != null) {
            String broadcastMessage = objectMapper.writeValueAsString(message);
            for (Session clientSession : sessions) {
                if (clientSession.isOpen()) {
                    try {
                        clientSession.getBasicRemote().sendText(broadcastMessage);
                        LOGGER.info("Broadcasted message to session: " + clientSession.getId());
                    } catch (IOException e) {
                        LOGGER.warning(
                                "Error broadcasting to session " + clientSession.getId() + ": " + e.getMessage());
                        sessions.remove(clientSession);
                    }
                } else {
                    sessions.remove(clientSession);
                }
            }
        } else {
            LOGGER.warning("No sessions found for conversationId: " + conversationId);
        }
    }
}