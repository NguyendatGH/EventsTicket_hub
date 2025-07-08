package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.*;
import utils.ResponseMessage;
import models.Conversation;
import models.Message;
import models.FileAttachment;
import service.ChatService;
import service.EventService;
import com.fasterxml.jackson.databind.ObjectMapper;
import dto.UserDTO;

import java.io.File;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.logging.Logger;
import java.util.Date;

@WebServlet({ "/chat/*", "/init-chat" })
@MultipartConfig(fileSizeThreshold = 1024 * 1024, // 1MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class ChatServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(ChatServlet.class.getName());
    private ObjectMapper objectMapper = new ObjectMapper();
    private static final String UPLOAD_DIR = "Uploads";
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

        // LOGGER.info("Current user: " + user.toString());   debug

        String eventIdParam = request.getParameter("eventId");
        if (eventIdParam == null || eventIdParam.trim().isEmpty()) {
            LOGGER.warning("EventId parameter is missing or empty");
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Event ID is required");
            return;
        }

        // LOGGER.info("Event id: " + eventIdParam);  debug

        try {
            int eventId = Integer.parseInt(eventIdParam);
            UserDTO owner = eventService.getEventOwnerId(eventId);
            LOGGER.info("Event owner id: " + owner.getId());
            String servletPath = request.getServletPath();
            LOGGER.info("Current Servlet path: " + servletPath);

            // Check if user is trying to chat with themselves
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
                // LOGGER.info("Found existing conversation with ID: " + existingConv.getConversationID());  debug
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
                // LOGGER.info("Created new conversation with ID: " + conversationId);   debug
            }
            // debug
            // LOGGER.info("User ID: " + user.getId());
            // LOGGER.info("Conversation ID: " + conversationId);
            // LOGGER.info("Number of conversations: " + conversations.size());

            List<Message> messages = new ArrayList<>();
            if (conversationId != -1) {
                try {
                    messages = chatService.getMessagesByConversation(conversationId, 50);
                    LOGGER.info("Number of messages loaded: " + messages.size());

                    // Debug messages
                    // for (Message msg : messages) {
                    //     LOGGER.info("Message: " + msg.toString());
                    // }
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

            // Forward to chat page instead of redirecting
            // LOGGER.info("Forwarding to chat page with conversationId: " + conversationId + ", userId: " + user.getId());
            request.getRequestDispatcher("/pages/Chat.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            LOGGER.severe("Invalid eventId format: " + request.getParameter("eventId"));
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid event ID");
        } catch (Exception e) {
            LOGGER.severe("Error in doGet method: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "An unexpected error occurred. Please try again later.");
            request.getRequestDispatcher("/pages/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // LOGGER.info("Received POST request to /chat");  debug
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

        // Create message
        Message message = new Message();
        message.setSenderID(user.getId());
        message.setMessageContent(content != null ? content : "");
        message.setCreatedAt(new Date());
        message.setUpdatedAt(new Date());
        message.setMessageType("text");

        // Save message to database
        int messageId = chatService.saveMessage(message, conversationId);
        if (messageId == -1) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"status\": \"error\", \"message\": \"Failed to save message\"}");
            return;
        }
        message.setMessageID(messageId);

        // Handle file attachments
        List<FileAttachment> attachments = new ArrayList<>();
        String applicationPath = request.getServletContext().getRealPath("");
        String uploadPath = applicationPath + File.separator + UPLOAD_DIR;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        for (Part part : request.getParts()) {
            if (part.getName().equals("attachment") && part.getSize() > 0) {
                String originalFilename = part.getSubmittedFileName();
                String storedFilename = UUID.randomUUID().toString() + "_" + originalFilename;
                String filePath = "/" + UPLOAD_DIR + "/" + storedFilename;

                // Save file to disk
                part.write(uploadPath + File.separator + storedFilename);

                // Create FileAttachment
                FileAttachment attachment = new FileAttachment();
                attachment.setMessageID(messageId);
                attachment.setOriginalFilename(originalFilename);
                attachment.setStoredFilename(storedFilename);
                attachment.setFilePath(filePath);
                attachment.setFileSize(part.getSize());
                attachment.setMimeType(part.getContentType());
                attachment.setUploadedAt(new Date());

                // Save attachment to database
                FileAttachment savedAttachment = chatService.saveFileAttachment(attachment);
                if (savedAttachment != null) {
                    attachments.add(savedAttachment);
                }
            }
        }

        message.setAttachments(attachments);

        try {
            ChatWebSocket.broadcastMessage(message, conversationId);
            response.getWriter().write("{\"status\": \"success\", \"message\": \"Message sent\"}");
        } catch (Exception e) {
            LOGGER.severe("Error broadcasting message: " + e.getMessage());
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"status\": \"error\", \"message\": \"Failed to broadcast message\"}");
        }
    }

}