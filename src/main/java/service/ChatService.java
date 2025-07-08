package service;

import java.util.List;

import dao.ChatDAO;
import models.Conversation;
import models.FileAttachment;
import models.Message;

public class ChatService {
    private final ChatDAO chatDAO;

    public ChatService() {
        this.chatDAO = new ChatDAO();
    }

    public List<Conversation> getUserConversations(int userId) {
        return chatDAO.getUserConversations(userId);
    }

    public String getConversationName(int conversationId, int currentUserId) {
        return chatDAO.getConversationName(conversationId, currentUserId);
    }

    public Conversation createConversation(int customerId, int eventOwnerId, int eventId, int createdBy) {
        return chatDAO.createConversation(customerId, eventOwnerId, eventId, createdBy);
    }

    public Conversation getConversationById(int conversationId) {
        return chatDAO.getConversationById(conversationId);
    }

    public int saveMessage(Message message, int conversationId) {
        return chatDAO.saveMessage(message, conversationId);
    }

    public List<Message> getMessagesByConversation(int conversationId, int limit) {
        return chatDAO.getMessagesByConversation(conversationId, limit);
    }

    public FileAttachment saveFileAttachment(FileAttachment attachment) {
        return chatDAO.saveFileAttachment(attachment);
    }

      public List<FileAttachment> getAttachmentsByMessageId(int messageId) {
        return chatDAO.getAttachmentsByMessageId(messageId);
      }
}
