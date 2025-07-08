<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chat Room - Modern Chat App</title>
    <style>
        :root {
            --primary: #667aff;
            --primary-glow: rgba(102, 122, 255, 0.3);
            --secondary: #e06bce;
            --secondary-glow: rgba(224, 107, 206, 0.3);
            --accent: #00ffaa;
            --accent-glow: rgba(0, 255, 170, 0.3);
            --dark-bg: #0a0f1a;
            --darker-bg: #060912;
            --card-bg: #1a1f2e;
            --card-hover: #252b3d;
            --border-color: #2d3548;
            --text-light: #e6edf7;
            --text-muted: #8b94a5;
            --success: #00cc66;
            --warning: #ffcc00;
            --danger: #ff4757;
            --message-sent: linear-gradient(135deg, #667aff, #8b5cf6);
            --message-received: linear-gradient(135deg, #1a1f2e, #252b3d);
            --hover-bg: rgba(255, 255, 255, 0.08);
            --glass-bg: rgba(255, 255, 255, 0.05);
            --glass-border: rgba(255, 255, 255, 0.1);
            --neon-pulse: drop-shadow(0 0 10px currentColor);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: var(--dark-bg);
            color: var(--text-light);
            height: 100vh;
            overflow: hidden;
        }

        .container {
            display: flex;
            height: 100vh;
            max-width: 100vw;
        }

        /* Left Sidebar */
        .sidebar {
            width: 350px;
            background: var(--darker-bg);
            border-right: 1px solid var(--border-color);
            display: flex;
            flex-direction: column;
            overflow: hidden;
        }

        .sidebar-header {
            padding: 20px;
            border-bottom: 1px solid var(--border-color);
            background: var(--card-bg);
        }

        .sidebar-header h1 {
            color: var(--text-light);
            font-size: 1.5rem;
            font-weight: 600;
            margin-bottom: 10px;
        }

        .search-container {
            position: relative;
            margin-top: 15px;
        }

        .search-input {
            width: 100%;
            padding: 12px 20px 12px 45px;
            background: var(--dark-bg);
            border: 1px solid var(--border-color);
            border-radius: 25px;
            color: var(--text-light);
            font-size: 14px;
            outline: none;
            transition: all 0.3s ease;
        }

        .search-input:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px var(--primary-glow);
        }

        .search-icon {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-muted);
            font-size: 16px;
        }

        .conversations-list {
            flex: 1;
            overflow-y: auto;
            padding: 10px 0;
        }

        .conversation {
            display: flex;
            align-items: center;
            padding: 15px 20px;
            cursor: pointer;
            transition: all 0.3s ease;
            border-bottom: 1px solid var(--border-color);
            position: relative;
        }

        .conversation:hover {
            background: var(--hover-bg);
        }

        .conversation.active {
            background: var(--primary-glow);
            border-left: 3px solid var(--primary);
        }

        .conversation-avatar {
            width: 45px;
            height: 45px;
            border-radius: 50%;
            background: var(--primary);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
            font-size: 16px;
            margin-right: 15px;
            position: relative;
        }

        .conversation-avatar::after {
            content: '';
            position: absolute;
            bottom: 2px;
            right: 2px;
            width: 12px;
            height: 12px;
            background: var(--success);
            border-radius: 50%;
            border: 2px solid var(--darker-bg);
        }

        .conversation-info {
            flex: 1;
            min-width: 0;
        }

        .conversation-name {
            font-weight: 600;
            color: var(--text-light);
            margin-bottom: 5px;
            font-size: 14px;
        }

        .conversation-preview {
            color: var(--text-muted);
            font-size: 13px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .conversation-meta {
            display: flex;
            flex-direction: column;
            align-items: flex-end;
            gap: 5px;
        }

        .conversation-time {
            color: var(--text-muted);
            font-size: 12px;
        }

        .conversation-badge {
            background: var(--primary);
            color: white;
            border-radius: 50%;
            width: 20px;
            height: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 11px;
            font-weight: bold;
        }

        /* Main Chat Area */
        .chat-container {
            flex: 1;
            display: flex;
            flex-direction: column;
            background: var(--dark-bg);
            overflow: hidden;
        }

        .chat-header {
            background: var(--card-bg);
            padding: 15px 20px;
            border-bottom: 1px solid var(--border-color);
            display: flex;
            align-items: center;
            justify-content: space-between;
            min-height: 70px;
        }

        .chat-header-left {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .chat-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
            font-size: 14px;
            object-fit: cover;
            box-sizing: border-box;
        }

        .chat-user-info h3 {
            color: var(--text-light);
            font-size: 15px;
            font-weight: 600;
            margin-bottom: 2px;
        }

        .chat-user-status {
            color: var(--success);
            font-size: 12px;
            display: flex;
            align-items: center;
            gap: 4px;
        }

        .status-dot {
            width: 6px;
            height: 6px;
            background: var(--success);
            border-radius: 50%;
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0% { opacity: 1; }
            50% { opacity: 0.5; }
            100% { opacity: 1; }
        }

        .chat-actions {
            display: flex;
            gap: 10px;
        }

        .logout-btn {
            background: var(--danger);
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 12px;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .logout-btn:hover {
            background: #ff3742;
            transform: translateY(-1px);
        }

        /* Messages Area */
        .messages {
            flex: 1;
            padding: 15px 20px;
            overflow-y: auto;
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .messages::-webkit-scrollbar {
            width: 6px;
        }

        .messages::-webkit-scrollbar-track {
            background: var(--darker-bg);
        }

        .messages::-webkit-scrollbar-thumb {
            background: var(--border-color);
            border-radius: 3px;
        }

        .messages::-webkit-scrollbar-thumb:hover {
            background: var(--text-muted);
        }

        .message {
            max-width: 70%;
            position: relative;
            animation: messageSlide 0.3s ease-out;
            margin-bottom: 4px;
        }

        @keyframes messageSlide {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .message.sent {
            align-self: flex-end;
        }

        .message.received {
            align-self: flex-start;
        }

        .message-bubble {
            padding: 10px 15px;
            border-radius: 18px;
            position: relative;
            backdrop-filter: blur(10px);
            border: 1px solid var(--glass-border);
            font-size: 14px;
            line-height: 1.4;
            word-wrap: break-word;
        }

        .message.sent .message-bubble {
            background: var(--message-sent);
            color: white;
            border-bottom-right-radius: 6px;
        }

        .message.received .message-bubble {
            background: var(--message-received);
            color: var(--text-light);
            border-bottom-left-radius: 6px;
        }

        .message-content {
            word-wrap: break-word;
            line-height: 1.4;
        }

        .message-time {
            font-size: 10px;
            color: rgba(255, 255, 255, 0.6);
            margin-top: 4px;
            text-align: center;
        }

        .message-timestamp {
            text-align: center;
            color: var(--text-muted);
            font-size: 12px;
            margin: 15px 0;
            padding: 5px;
            background: var(--glass-bg);
            border-radius: 10px;
            width: fit-content;
            margin-left: auto;
            margin-right: auto;
        }

        .message.sent .message-time {
            text-align: right;
            color: rgba(255, 255, 255, 0.7);
        }

        .message.received .message-time {
            text-align: left;
            color: var(--text-muted);
        }

        .attachments {
            margin-top: 8px;
            padding-top: 8px;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
        }

        .attachment-link {
            display: block;
            color: var(--accent);
            text-decoration: none;
            padding: 3px 0;
            transition: color 0.3s ease;
            font-size: 12px;
        }

        .attachment-link:hover {
            color: var(--accent);
            text-decoration: underline;
        }

        /* Input Area */
        .input-area {
            padding: 15px 20px;
            background: var(--card-bg);
            border-top: 1px solid var(--border-color);
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .input-container {
            flex: 1;
            position: relative;
            display: flex;
            align-items: center;
            background: var(--dark-bg);
            border: 1px solid var(--border-color);
            border-radius: 20px;
            padding: 4px 4px 4px 15px;
            transition: all 0.3s ease;
        }

        .input-container:focus-within {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px var(--primary-glow);
        }

        #messageInput {
            flex: 1;
            background: none;
            border: none;
            color: var(--text-light);
            font-size: 14px;
            padding: 10px 0;
            outline: none;
        }

        #messageInput::placeholder {
            color: var(--text-muted);
        }

        .file-btn {
            background: none;
            border: none;
            color: var(--text-muted);
            cursor: pointer;
            padding: 6px;
            border-radius: 50%;
            margin-right: 8px;
            transition: all 0.3s ease;
            font-size: 16px;
        }

        .file-btn:hover {
            background: var(--hover-bg);
            color: var(--text-light);
        }

        #sendButton {
            background: var(--primary);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 18px;
            cursor: pointer;
            font-size: 13px;
            font-weight: 600;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        #sendButton:hover {
            background: var(--primary);
            transform: translateY(-1px);
            box-shadow: 0 5px 15px var(--primary-glow);
        }

        #sendButton:disabled {
            background: var(--text-muted);
            cursor: not-allowed;
            transform: none;
            box-shadow: none;
        }

        /* Right Sidebar */
        .right-sidebar {
            width: 300px;
            background: var(--darker-bg);
            border-left: 1px solid var(--border-color);
            display: flex;
            flex-direction: column;
            overflow: hidden;
        }

        .right-sidebar-header {
            padding: 20px;
            border-bottom: 1px solid var(--border-color);
            background: var(--card-bg);
        }

        .profile-section {
            text-align: center;
            padding: 20px;
        }

        .profile-avatar {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            background: var(--primary);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
            font-size: 24px;
            margin: 0 auto 15px;
        }

        .profile-name {
            font-size: 18px;
            font-weight: 600;
            color: var(--text-light);
            margin-bottom: 5px;
        }

        .profile-status {
            color: var(--text-muted);
            font-size: 14px;
        }

        .section-divider {
            height: 1px;
            background: var(--border-color);
            margin: 20px 0;
        }

        .section-title {
            font-size: 14px;
            font-weight: 600;
            color: var(--text-light);
            margin-bottom: 15px;
            padding: 0 20px;
        }

        .menu-item {
            padding: 12px 20px;
            display: flex;
            align-items: center;
            gap: 15px;
            cursor: pointer;
            transition: all 0.3s ease;
            color: var(--text-muted);
        }

        .menu-item:hover {
            background: var(--hover-bg);
            color: var(--text-light);
        }

        .menu-icon {
            font-size: 16px;
            width: 20px;
        }

        /* Empty state */
        .empty-state {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            height: 100%;
            color: var(--text-muted);
            text-align: center;
            padding: 40px;
        }

        .empty-state-icon {
            font-size: 48px;
            margin-bottom: 20px;
            opacity: 0.5;
        }

        .typing-indicator {
            display: flex;
            align-items: center;
            gap: 10px;
            color: var(--text-muted);
            font-style: italic;
            font-size: 14px;
            padding: 10px 20px;
        }

        .typing-dots {
            display: flex;
            gap: 3px;
        }

        .typing-dot {
            width: 6px;
            height: 6px;
            background: var(--text-muted);
            border-radius: 50%;
            animation: typing 1.4s infinite;
        }

        .typing-dot:nth-child(2) {
            animation-delay: 0.2s;
        }

        .typing-dot:nth-child(3) {
            animation-delay: 0.4s;
        }

        @keyframes typing {
            0%, 60%, 100% {
                opacity: 0.3;
            }
            30% {
                opacity: 1;
            }
        }

        /* Responsive Design */
        @media (max-width: 1024px) {
            .right-sidebar {
                display: none;
            }
        }

        @media (max-width: 768px) {
            .sidebar {
                width: 280px;
            }
            
            .container {
                flex-direction: column;
            }
            
            .sidebar {
                width: 100%;
                height: 200px;
            }
            
            .conversations-list {
                display: flex;
                overflow-x: auto;
                overflow-y: hidden;
            }
            
            .conversation {
                min-width: 200px;
                border-bottom: none;
                border-right: 1px solid var(--border-color);
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Left Sidebar -->
        <div class="sidebar">
            <div class="sidebar-header">
                <h1>Đoạn chat</h1>
                <div class="search-container">
                    <div class="search-icon">🔍</div>
                    <input type="text" class="search-input" placeholder="Tìm kiếm ">
                </div>
            </div>
            
            <div class="conversations-list">
                <c:if test="${empty conversations}">
                    <div class="empty-state">
                        <div class="empty-state-icon">💬</div>
                        <p>Chưa có cuộc trò chuyện nào !.</p>
                    </div>
                </c:if>
                
                <c:forEach items="${conversations}" var="conv">
                    <div class="conversation ${conv.conversationID == currentConversationId ? 'active' : ''}"
                         onclick="window.location.href='${pageContext.request.contextPath}/chat?conversation_id=${conv.conversationID}&eventId=${conv.eventID}'">
                        <div class="conversation-avatar">
                            ${conv.subject != null ? conv.subject.substring(0,1).toUpperCase() : 'C'}
                        </div>
                        <div class="conversation-info">
                            <div class="conversation-name">
                                ${conv.subject != null ? conv.subject : 'Conversation ' + conv.conversationID}
                            </div>
                            <div class="conversation-preview">Bấm để xem tin nhắn...</div>
                        </div>
                        <div class="conversation-meta">
                            <div class="conversation-time" data-last-message-at="${conv.lastMessageAt}"></div>
                            <div class="conversation-badge">2</div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>

        <!-- Main Chat Area -->
        <div class="chat-container">
            <div class="chat-header">
                <div class="chat-header-left">
                    <div class="chat-avatar">
                        <c:if test="${eventOwner != null}">
                             <img src="${eventOwner.avatar}" style="width: 100%; height: 100%; object-fit: cover;"/>
                        </c:if>
                    </div>
                    <div class="chat-user-info">
                        <h3>
                            <c:if test="${user != null}">
                                ${eventOwner.name}
                            </c:if>
                        </h3>
                        <div class="chat-user-status">
                            <div class="status-dot"></div>
                            Đang hoạt động
                        </div>
                    </div>
                </div>
                <div class="chat-actions">
                    <button class="logout-btn" onclick="logout()">Logout</button>
                </div>
            </div>

            <div class="messages" id="messagesContainer">
                <c:if test="${empty messages}">
                    <div class="empty-state">
                        <div class="empty-state-icon">💬</div>
                        <p>Chưa có tin nhắn nào!</p>
                        <small>Cùng nhau trao đổi thông tin với chủ sự kiện nhé bạn ơi.</small>
                    </div>
                </c:if>

                <c:set var="previousTimestamp" value="" />
                <c:forEach items="${messages}" var="message" varStatus="status">
                    <c:set var="currentTimestamp" value="${message.updatedAt}" />
                    <fmt:formatDate var="formattedTime" value="${currentTimestamp}" pattern="HH:mm" />
                    <fmt:formatDate var="formattedDate" value="${currentTimestamp}" pattern="dd/MM/yyyy" />
                    
                    <c:if test="${status.first or empty previousTimestamp}">
                          <div class="message-timestamp">
                                <fmt:formatDate value="${currentTimestamp}" pattern="dd/MM/yyyy HH:mm" />
                          </div>
                    </c:if>

                    <c:if test="${not status.first and not empty previousTimestamp}">
                        <jsp:useBean id="dateValue" class="java.util.Date" />
                        <jsp:setProperty name="dateValue" property="time" value="${currentTimestamp.time - previousTimestamp.time}" />
                        <c:if test="${dateValue.time > 1800000}"> 
                            <div class="message-timestamp">
                                <fmt:formatDate value="${currentTimestamp}" pattern="dd/MM/yyyy HH:mm" />
                            </div>
                        </c:if>
                    </c:if>

                    <div class="message ${message.senderID == user.id ? 'sent' : 'received'}">
                        <div class="message-bubble">
                            <div class="message-content">
                                ${message.messageContent}
                                <c:if test="${message.hasAttachments()}">
                                    <div class="attachments">
                                        <c:forEach items="${message.attachments}" var="attachment">
                                            <a href="${pageContext.request.contextPath}${attachment.filePath}" 
                                               target="_blank" class="attachment-link">
                                                📎 ${attachment.originalFilename} (${attachment.formattedFileSize})
                                            </a>
                                        </c:forEach>
                                    </div>
                                </c:if>
                            </div>
                            <c:if test="${status.last or (not status.last and messages[status.index + 1].senderID != message.senderID)}">
                                <div class="message-time" style="display: none;">
                                  <fmt:formatDate value="${message.updatedAt}" pattern="HH:mm" />
                                </div>
                            </c:if>

                           
                        </div>
                    </div>

                    <c:set var="previousTimestamp" value="${currentTimestamp}" />
                </c:forEach>
            </div>

            <div class="input-area">
                <input type="file" id="fileInput" multiple style="display: none;" onchange="handleFileSelect()" />
                
                <div class="input-container">
                    <button type="button" class="file-btn" onclick="document.getElementById('fileInput').click()">
                        📎
                    </button>
                    <input type="text" id="messageInput" placeholder="Type your message here..." autocomplete="off" 
                           <c:if test="${currentConversationId == null}">disabled</c:if> />
                </div>
                
                <button id="sendButton" onclick="sendMessage()" <c:if test="${currentConversationId == null}">disabled</c:if>>
                    Send 
                </button>
            </div>
        </div>

        <!-- Right Sidebar for eventowner profile-->
        <div class="right-sidebar">
            <div class="right-sidebar-header">
                <div class="profile-section">
                    <div class="profile-avatar">
                        <c:if test="${user != null}">
                           <img src="${eventOwner.avatar}" style="width: 100%; height: 100%; object-fit: cover;"/>
                        </c:if>
                    </div>
                    <div class="profile-name">
                        <c:if test="${user != null}">
                            ${eventOwner.name}
                        </c:if>
                    </div>
                    <div class="profile-status">${eventOwner.email}</div>
                </div>
            </div>
            
            <div class="section-divider"></div>
            
            <div class="section-title">Thông tin về đoạn chat</div>
            <div class="menu-item">
                <div class="menu-icon">🔍</div>
                <span>Tìm tin nhắn</span>
            </div>
            
            <div class="section-divider"></div>
            
            <div class="section-title">File phương tiện & file</div>
            <div class="menu-item">
                <div class="menu-icon">📷</div>
                <span>File phương tiện</span>
            </div>
            <div class="menu-item">
                <div class="menu-icon">📄</div>
                <span>File</span>
            </div>
            
            <div class="section-divider"></div>
        </div>
    </div>

  <script>
    // Debug user info
    console.log('User ID:', ${user.id});
    console.log('Username:', '${user.name}');
    console.log('Conversation ID:', '${currentConversationId}');

    // WebSocket connection
    const conversationId = '${currentConversationId}';
        let socket = null;

        if (conversationId && conversationId !== 'null' && conversationId !== '') {
            const wsProtocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
            const wsUrl = wsProtocol + "//" + window.location.host + "${pageContext.request.contextPath}/websocket/chat?conversation_id=" + conversationId +"&user_id=${user.id}";
            console.log('Connecting to WebSocket:', wsUrl);

            socket = new WebSocket(wsUrl);

            socket.onopen = function(event) {
                console.log('WebSocket connection opened');
            };

            socket.onmessage = function(event) {
                console.log('Received message:', event.data);
                try {
                    const payload = JSON.parse(event.data);
                    const message = payload.message;
                    const username = payload.username;
                    const isCurrentUser = message.senderID === ${currentUserId};
                    addMessage(
                        message.senderID,
                        username,
                        message.messageContent,
                        message.createdAt,
                        message.conversationID,
                        isCurrentUser,
                        message.attachments || []
                    );
                } catch (e) {
                    console.error('Error parsing message:', e);
                }
            };

            socket.onerror = function(error) {
                console.error('WebSocket Error:', error);
            };

            socket.onclose = function(event) {
                console.log('WebSocket connection closed:', event.code, event.reason);
            };
        } else {
            console.log('No conversation ID - WebSocket not connected');
        }
        
    const messagesContainer = document.getElementById('messagesContainer');
    const messageInput = document.getElementById('messageInput');
    
    function scrollToBottom() {
        messagesContainer.scrollTop = messagesContainer.scrollHeight;
    }

    function formatTimestamp(timestamp) {
        const date = new Date(timestamp);
        return date.toLocaleTimeString([], {hour: '2-digit', minute:'2-digit'});
    }

    let selectedFiles = [];


    function handleFileSelect() {
    const fileInput = document.getElementById('fileInput');
    selectedFiles = Array.from(fileInput.files);
    
    if (selectedFiles.length > 0) {
        const fileNames = selectedFiles.map(f => f.name).join(', ');
        messageInput.placeholder = `Files selected: ${fileNames}`;
    } else {
        messageInput.placeholder = "Type your message here...";
    }
}
    function sendMessage() {
        sendMessageWithFiles();
    }

    function sendMessageWithFiles() {
    const content = messageInput.value.trim();
    
    if ((!content && selectedFiles.length === 0) || !conversationId) {
        return;
    }
    
    const formData = new FormData();
    formData.append('conversation_id', conversationId);
    formData.append('messageContent', content);
    
    selectedFiles.forEach(file => {
        formData.append('attachment', file);
    });
    
    fetch('${pageContext.request.contextPath}/chat', {
        method: 'POST',
        body: formData
    })
    .then(response => response.json())
    .then(data => {
        if (data.status === 'success') {
            messageInput.value = '';
            selectedFiles = [];
            document.getElementById('fileInput').value = '';
            messageInput.placeholder = "Type your message here...";

            if (content) {
                addMessage(${user.id}, '${user.name}', content, 
                          new Date().toISOString(), conversationId, true);
            }
        }
    })
   .catch(console.error);
    }

    // Add a new message to the chat
 function addMessage(userId, username, content, timestamp, msgConversationId, isCurrentUser, attachments = []) {
    console.log('Adding message:', {userId, username, content, timestamp, msgConversationId, isCurrentUser, attachments});
    
    if (parseInt(msgConversationId) !== parseInt(conversationId)) {
        console.log('Message not for current conversation');
        return;
    }
    
    const messageDiv = document.createElement('div');
    messageDiv.className = 'message ' + (isCurrentUser ? 'sent' : 'received');
    
    const messageBubble = document.createElement('div');
    messageBubble.className = 'message-bubble';
    
    const messageContent = document.createElement('div');
    messageContent.className = 'message-content';
    messageContent.textContent = content;
    
    if (attachments && attachments.length > 0) {
        const attachmentDiv = document.createElement('div');
        attachmentDiv.className = 'attachments';
        attachments.forEach(attachment => {
            const attachmentLink = document.createElement('a');
            attachmentLink.href = '${pageContext.request.contextPath}' + attachment.filePath;
            attachmentLink.textContent = attachment.originalFilename + ' (' + attachment.formattedFileSize + ')';
            attachmentLink.target = '_blank';
            attachmentLink.className = 'attachment-link';
            attachmentDiv.appendChild(attachmentLink);
        });
        messageContent.appendChild(attachmentDiv);
    }
    
    const messageTime = document.createElement('div');
    messageTime.className = 'message-time';
    messageTime.textContent = formatTimestamp(timestamp);
    
    messageBubble.appendChild(messageContent);
    messageBubble.appendChild(messageTime);
    messageDiv.appendChild(messageBubble);
    
    messagesContainer.appendChild(messageDiv);
    scrollToBottom();
    }

  
    messageInput.addEventListener('keypress', function(event) {
        if (event.key === 'Enter') {
            sendMessage();
        }
    });

    socket.onmessage = function(event) {
    try {
        const message = JSON.parse(event.data);
            addMessage(
                message.userId, 
                message.username, 
                message.content, 
                message.timestamp, 
                message.conversationId, 
                message.userId === ${user.id},
                message.attachments || []
            );
        } catch (e) {
            console.error('Error parsing message:', e);
        }
    };

    function updateConversationTime() {
            const timeElements = document.querySelectorAll('.conversation-time');
            timeElements.forEach(element => {
                const lastMessageAt = element.getAttribute('data-last-message-at');
                console.log('Processing lastMessageAt:', lastMessageAt);
                if (lastMessageAt && lastMessageAt !== 'null' && lastMessageAt !== '') {
                    try {
                        const lastMessageTime = new Date(lastMessageAt);
                        if (isNaN(lastMessageTime.getTime())) {
                            console.error('Invalid date format for lastMessageAt:', lastMessageAt);
                            element.textContent = 'Không xác định';
                            return;
                        }
                        const now = new Date();
                        const diffInMinutes = Math.floor((now - lastMessageTime) / (1000 * 60));
                        console.log('Calculated diffInMinutes:', diffInMinutes);
                        if (isNaN(diffInMinutes) || diffInMinutes < 0) {
                            console.error('Invalid diffInMinutes:', diffInMinutes);
                            element.textContent = 'Không xác định';
                        } else {
                            element.textContent = diffInMinutes > 0 ? `${diffInMinutes} phút trước` : 'Vừa xong';
                        }
                    } catch (e) {
                        console.error('Error parsing lastMessageAt:', e);
                        element.textContent = 'Không xác định';
                    }
                } else {
                    console.log('No lastMessageAt for element');
                    element.textContent = 'Chưa có tin nhắn';
                }
            });
    }


    function logout() {
        if (socket) {
            socket.close();
        }

        window.location.href = '${pageContext.request.contextPath}/logout';
    }

    setInterval(updateConversationTime, 60000);
    window.onload = function(){
        scrollToBottom();
        updateConversationTime();
    };
</script>
</body>
</html>