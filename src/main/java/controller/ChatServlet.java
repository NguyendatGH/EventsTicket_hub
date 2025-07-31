package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.*;
import models.Conversation;
import models.Message;
import models.FileAttachment;
import service.ChatService;
import service.EventService;
import service.UserService;

import com.fasterxml.jackson.databind.ObjectMapper;
import dto.UserDTO;

import java.io.File;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.logging.Logger;
import java.util.HashMap;

@WebServlet({ "/chat/*", "/init-chat" })
@MultipartConfig(fileSizeThreshold = 1024 * 1024, // 1MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class ChatServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(ChatServlet.class.getName());
    private ObjectMapper objectMapper = new ObjectMapper();
    private static final String UPLOAD_DIR = "uploads/message_assets";
    private static final UserService userService = new UserService();
    private static final ChatService chatService = new ChatService();
    private static final EventService eventService = new EventService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        UserDTO user = (UserDTO) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        String role;
        try {
            role = userService.whoisLoggedin(user.getId());
            System.out.println("[--]logged in with role : " + role);
        } catch (SQLException e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error checking user role");
            return;
        }

        if ("event_owner".equals(role)) {
            Map<Integer, Map<String, Object>> groupedConversations = chatService
                    .getGroupedConversationsForEventOwner(user.getId());
            request.setAttribute("groupedConversations", groupedConversations);

            LOGGER.info("Fetching grouped conversations for EventOwnerID: " + user.getId());
            LOGGER.info("Number of customer groups: " + groupedConversations.size());

            if (groupedConversations.isEmpty()) {
                LOGGER.info("No conversations found for EventOwnerID: " + user.getId());
            } else {
                groupedConversations.forEach((customerId, customerData) -> {
                    LOGGER.info("CustomerID: " + customerId);
                    LOGGER.info("  CustomerName: " + customerData.get("customerName"));
                    List<Conversation> conversations = (List<Conversation>) customerData.get("conversations");
                    Map<Integer, String> lastMessages = (Map<Integer, String>) customerData.get("lastMessages");
                    LOGGER.info("  Number of conversations: " + (conversations != null ? conversations.size() : 0));
                    if (conversations != null) {
                        conversations.forEach(conv -> {
                            LOGGER.info("    ConversationID: " + conv.getConversationID() + ", Subject: "
                                    + conv.getSubject() +
                                    ", EventID: " + conv.getEventID() + ", LastMessageAt: " + conv.getLastMessageAt());
                            String lastMessage = lastMessages != null ? lastMessages.get(conv.getConversationID())
                                    : "No message";
                            LOGGER.info("LastMessage: " + lastMessage);
                        });
                    }
                });
            }
            request.setAttribute("groupedConversations", groupedConversations);
            request.setAttribute("currentUserId", user.getId());
            request.setAttribute("user", user);

            String conversationIdParam = request.getParameter("conversation_id");
            Integer conversationId = conversationIdParam != null ? Integer.parseInt(conversationIdParam) : null;
            LOGGER.info("Current conversation ID: " + conversationId);
            request.setAttribute("currentConversationId", conversationId);

            if (conversationId != null) {
                List<Message> messages = chatService.getMessagesByConversation(conversationId, 50);

                LOGGER.info("Loaded " + messages.size() + " messages for ConversationID: " + conversationId);
                messages.forEach(m -> LOGGER.info("MessageID: " + m.getMessageID() + ", SenderID: " + m.getSenderID() +
                        ", Content: " + (m.getMessageContent() != null ? m.getMessageContent() : "No content")));

                request.setAttribute("messages", messages);

                Conversation conv = chatService.getConversationById(conversationId);
                if (conv != null) {
                    UserDTO customer = chatService.getCustomerFromConversation(conv.getEventID());
                    if (customer != null) {
                        LOGGER.info(
                                "Customer for ConversationID: " + conversationId + ", CustomerID: " + customer.getId() +
                                        ", Name: " + customer.getName());
                        request.setAttribute("customer", customer);
                    } else {
                        LOGGER.warning("No customer found for EventID: " + conv.getEventID());
                        request.setAttribute("customer", null);
                    }
                    UserDTO eventOwner = userService.findDTOUserID(conv.getEventOwnerID());
                    if (eventOwner != null) {
                        LOGGER.info("EventOwner for ConversationID: " + conversationId + ", EventOwnerID: "
                                + eventOwner.getId() +
                                ", Name: " + eventOwner.getName());
                        request.setAttribute("eventOwner", eventOwner);
                    } else {
                        LOGGER.warning("No event owner found for EventOwnerID: " + conv.getEventOwnerID());
                        request.setAttribute("eventOwner", null);
                    }
                } else {
                    LOGGER.warning("No conversation found for ConversationID: " + conversationId);
                    request.setAttribute("customer", null);
                    request.setAttribute("eventOwner", null);
                }
            } else {
                request.setAttribute("messages", null);
                request.setAttribute("customer", null);
                request.setAttribute("eventOwner", null);
            }

            request.getRequestDispatcher("pages/OwnerChat.jsp").forward(request, response);
        } else if ("customer".equals(role)) {
            String eventIdParam = request.getParameter("eventId");
            LOGGER.info("Event id: " + eventIdParam);

            if (eventIdParam == null || eventIdParam.trim().isEmpty()) {
                LOGGER.warning("EventId parameter is missing or empty");
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Event ID is required");
                return;
            }
            try {
                int eventId = Integer.parseInt(eventIdParam);
                UserDTO owner = eventService.getEventOwnerId(eventId);
                LOGGER.info("Event owner id: " + owner.getId());
                String servletPath = request.getServletPath();
                LOGGER.info("Current Servlet path: " + servletPath);

                if (user.getId() == owner.getId()) {
                    LOGGER.warning(
                            "User (ID: " + user.getId() + ") attempted to start chat with themselves for eventId: "
                                    + eventId);
                    response.sendError(HttpServletResponse.SC_FORBIDDEN, "You cannot start a chat with yourself");
                    return;
                }

                List<Conversation> conversations = chatService.getUserConversations(user.getId());
                Conversation existingConv = conversations.stream()
                        .filter(c -> c.getEventID() != null && c.getEventID() == eventId &&
                                ((c.getCustomerID() == user.getId() && c.getEventOwnerID() == owner.getId()) ||
                                        (c.getCustomerID() == owner.getId() && c.getEventOwnerID() == user.getId())))
                        .findFirst()
                        .orElse(null);

                int conversationId = -1;
                if (existingConv != null) {
                    conversationId = existingConv.getConversationID();
                } else {
                    LOGGER.info("No existing conversation found. Creating new conversation for eventId: " + eventId);
                    Conversation conversation = chatService.createConversation(
                            user.getId(), // customer ID (current user)
                            owner.getId(), // event owner ID
                            eventId, // event ID
                            user.getId() // initiator ID (current user)
                    );

                    if (conversation == null) {
                        LOGGER.severe(
                                "Failed to create conversation for userId: " + user.getId() + ", eventId: " + eventId);
                        request.setAttribute("errorMessage", "Unable to start chat. Please try again later.");
                        request.getRequestDispatcher("/pages/error.jsp").forward(request, response);
                        return;
                    }

                    conversationId = conversation.getConversationID();
                }

                List<Message> messages = new ArrayList<>();
                if (conversationId != -1) {
                    try {
                        messages = chatService.getMessagesByConversation(conversationId, 50);
                        LOGGER.info("Number of messages loaded: " + messages.size());

                    } catch (Exception e) {
                        LOGGER.warning("Error loading messages for conversation ID: " + conversationId + ", Error: "
                                + e.getMessage());
                    }
                } else {
                    LOGGER.warning("Invalid conversation ID: " + conversationId);
                    request.setAttribute("errorMessage", "Unable to access chat. Please try again later.");
                    request.getRequestDispatcher("/pages/error.jsp").forward(request, response);
                    return;
                }

                request.setAttribute("messages", messages);
                request.setAttribute("conversations", conversations);
                request.setAttribute("currentConversationId", conversationId);
                request.setAttribute("eventId", eventId);
                request.setAttribute("eventOwner", owner);
                request.setAttribute("currentUserId", user.getId());

                LOGGER.info("Forwarding to chat page with conversationId: " + conversationId
                        + ", userId: " + user.getId());
                request.getRequestDispatcher("/pages/CustomerChat.jsp").forward(request, response);

            } catch (NumberFormatException e) {
                LOGGER.severe("Invalid eventId format: " + request.getParameter("eventId"));
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid event ID");
            } catch (Exception e) {
                LOGGER.severe("Error in doGet method: " + e.getMessage());
                e.printStackTrace();
                request.setAttribute("errorMessage", "An unexpected error occurred. Please try again later.");
                request.getRequestDispatcher("/pages/error.jsp").forward(request, response);
            }
        } else {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "invalid user role!");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        HttpSession session = request.getSession(false);
        UserDTO user = (session != null) ? (UserDTO) session.getAttribute("user") : null;

        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"status\": \"error\", \"message\": \"User not logged in\"}");
            return;
        }

        String conversationIdStr = request.getParameter("conversation_id");
        String content = request.getParameter("messageContent");

        if (conversationIdStr == null || conversationIdStr.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"status\": \"error\", \"message\": \"Conversation ID is required\"}");
            return;
        }

        int conversationId;
        try {
            conversationId = Integer.parseInt(conversationIdStr);
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"status\": \"error\", \"message\": \"Invalid conversation ID\"}");
            return;
        }

        // Create message object
        Message message = new Message();
        message.setSenderID(user.getId());
        message.setConversationID(conversationId);
        message.setMessageContent(content != null ? content : "");
        message.setMessageType("text");
        message.setCreatedAt(new Date());
        message.setUpdatedAt(new Date());

        // Process file uploads
        List<FileAttachment> attachments = new ArrayList<>();
        String applicationPath = request.getServletContext().getRealPath("");
        String uploadPath = applicationPath + File.separator + UPLOAD_DIR;
        File uploadDir = new File(uploadPath);

        // Create upload directory if it doesn't exist
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        // Process each file part
        for (Part part : request.getParts()) {
            if (part.getName().equals("attachment") && part.getSize() > 0) {
                String originalFilename = part.getSubmittedFileName();
                String fileExtension = originalFilename.substring(originalFilename.lastIndexOf("."));
                String storedFilename = UUID.randomUUID().toString() + fileExtension;
                String filePath = "/" + UPLOAD_DIR.replace(File.separator, "/") + "/" + storedFilename;

                // Validate file size
                if (part.getSize() > 10 * 1024 * 1024) { // 10MB limit
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter()
                            .write("{\"status\": \"error\", \"message\": \"File size exceeds 10MB limit\"}");
                    return;
                }

                // Save file to server
                part.write(uploadPath + File.separator + storedFilename);

                // Create attachment object
                FileAttachment attachment = new FileAttachment();
                attachment.setOriginalFilename(originalFilename);
                attachment.setStoredFilename(storedFilename);
                attachment.setFilePath(filePath);
                attachment.setFileSize(part.getSize());
                attachment.setMimeType(part.getContentType());
                attachment.setUploadedAt(new Date());

                attachments.add(attachment);
            }
        }

        // Save message to database
        int messageId = chatService.saveMessage(message, conversationId);
        if (messageId == -1) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"status\": \"error\", \"message\": \"Failed to save message\"}");
            return;
        }
        message.setMessageID(messageId);

        // Save attachments to database
        List<FileAttachment> savedAttachments = new ArrayList<>();
        for (FileAttachment attachment : attachments) {
            attachment.setMessageID(messageId);
            FileAttachment savedAttachment = chatService.saveFileAttachment(attachment);
            if (savedAttachment != null) {
                savedAttachments.add(savedAttachment);
            }
        }
        message.setAttachments(savedAttachments);

        try {
            // Broadcast message to WebSocket
            ChatWebSocket.broadcastMessage(message, conversationId);

            // Prepare response
            Map<String, Object> responseData = new HashMap<>();
            responseData.put("status", "success");
            responseData.put("message", "Message sent successfully");
            responseData.put("messageId", messageId);

            if (!savedAttachments.isEmpty()) {
                List<Map<String, Object>> attachmentsData = new ArrayList<>();
                for (FileAttachment attachment : savedAttachments) {
                    Map<String, Object> attachmentData = new HashMap<>();
                    attachmentData.put("originalFilename", attachment.getOriginalFilename());
                    attachmentData.put("filePath", attachment.getFilePath());
                    attachmentData.put("fileSize", attachment.getFileSize());
                    attachmentData.put("mimeType", attachment.getMimeType());
                    attachmentsData.add(attachmentData);
                }
                responseData.put("attachments", attachmentsData);
            }

            response.getWriter().write(objectMapper.writeValueAsString(responseData));
        } catch (Exception e) {
            LOGGER.severe("Error broadcasting message: " + e.getMessage());
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"status\": \"error\", \"message\": \"Failed to broadcast message\"}");
        }
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        HttpSession session = request.getSession(false);
        UserDTO user = (session != null) ? (UserDTO) session.getAttribute("user") : null;

        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"status\": \"error\", \"message\": \"User not logged in\"}");
            return;
        }

        String conversationIdStr = request.getParameter("conversation_id");
        if (conversationIdStr == null || conversationIdStr.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"status\": \"error\", \"message\": \"Conversation ID is required\"}");
            return;
        }

        int conversationId;
        try {
            conversationId = Integer.parseInt(conversationIdStr);
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"status\": \"error\", \"message\": \"Invalid conversation ID\"}");
            return;
        }

        String role;
        try {
            role = userService.whoisLoggedin(user.getId());
        } catch (SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"status\": \"error\", \"message\": \"Error checking user role\"}");
            return;
        }

        boolean isCustomer = "customer".equals(role);
        boolean success = chatService.softDeleteConversation(conversationId, user.getId(), isCustomer);

        if (success) {
            // Broadcast deletion notification via WebSocket
            Message deletionMessage = new Message();
            deletionMessage.setConversationID(conversationId);
            deletionMessage.setSenderID(user.getId());
            deletionMessage.setMessageContent("Conversation deleted by " + (isCustomer ? "customer" : "event owner"));
            deletionMessage.setMessageType("system");
            deletionMessage.setCreatedAt(new Date());
            deletionMessage.setUpdatedAt(new Date());

            int messageId = chatService.saveMessage(deletionMessage, conversationId);
            if (messageId != -1) {
                deletionMessage.setMessageID(messageId);
                ChatWebSocket.broadcastMessage(deletionMessage, conversationId);
            }

            response.getWriter().write("{\"status\": \"success\", \"message\": \"Conversation deleted successfully\"}");
        } else {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"status\": \"error\", \"message\": \"Failed to delete conversation\"}");
        }
    }
}