
function initWebSocket(conversationId, userId, currentUserName, otherUserName, isOwner = false) {
    let socket = null;
    
    if (conversationId && conversationId !== 'null' && conversationId !== '') {
        const wsProtocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
        const wsUrl = wsProtocol + "//" + window.location.host + "${pageContext.request.contextPath}/websocket/chat?conversation_id=" + conversationId + "&user_id=" + userId;
        console.log('Connecting to WebSocket:', wsUrl);

        socket = new WebSocket(wsUrl);

        socket.onopen = function(event) {
            console.log('WebSocket connection opened for UserID:', userId);
        };

        socket.onmessage = function(event) {
            console.log('Received message:', event.data);
            try {
                const message = JSON.parse(event.data);
                const isCurrentUser = message.senderID == userId;
                addMessage(
                    message.senderID,
                    isCurrentUser ? currentUserName : otherUserName,
                    message.messageContent,
                    message.createdAt,
                    message.conversationID,
                    isCurrentUser,
                    message.attachments || []
                );
                
                if (isOwner) {
                    updateConversationPreview(message.conversationID, message.messageContent, message.createdAt);
                }
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
    }
    
    return socket;
}

function sendMessageWithFiles(conversationId, userId, userName) {
    const content = document.getElementById('messageInput').value.trim();
    const fileInput = document.getElementById('fileInput');
    const selectedFiles = Array.from(fileInput.files);
    
    if ((!content && selectedFiles.length === 0) || !conversationId) {
        return Promise.resolve(false);
    }
    
    const formData = new FormData();
    formData.append('conversation_id', conversationId);
    formData.append('messageContent', content);
    
    selectedFiles.forEach(file => {
        formData.append('attachment', file);
    });
    
    return fetch('${pageContext.request.contextPath}/chat', {
        method: 'POST',
        body: formData
    })
    .then(response => response.json())
    .then(data => {
        if (data.status === 'success') {
            document.getElementById('messageInput').value = '';
            fileInput.value = '';
            document.getElementById('messageInput').placeholder = "Nhập tin nhắn...";
            
            if (content) {
                addMessage(
                    userId, 
                    userName, 
                    content, 
                    new Date().toISOString(), 
                    conversationId, 
                    true
                );
            }
            return true;
        }
        return false;
    })
    .catch(error => {
        console.error('Error sending message:', error);
        return false;
    });
}

function addMessage(userId, username, content, timestamp, msgConversationId, isCurrentUser, attachments = []) {
    const messagesContainer = document.getElementById('messagesContainer');
    const currentConversationId = '${currentConversationId}';
    
    if (parseInt(msgConversationId) !== parseInt(currentConversationId)) {
        return;
    }
    
    const messageDiv = document.createElement('div');
    messageDiv.className = 'message ' + (isCurrentUser ? 'sent' : 'received');
    
    // Thêm người gửi (chỉ Owner có)
    if (document.querySelector('.message-sender')) {
        const messageSender = document.createElement('div');
        messageSender.className = 'message-sender';
        messageSender.textContent = username;
        messageDiv.appendChild(messageSender);
    }
    
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
            attachmentLink.textContent = '📎 ' + attachment.originalFilename + ' (' + attachment.formattedFileSize + ')';
            attachmentLink.target = '_blank';
            attachmentLink.className = 'attachment-link';
            attachmentDiv.appendChild(attachmentLink);
        });
        messageContent.appendChild(attachmentDiv);
    }
    
    const messageTime = document.createElement('div');
    messageTime.className = 'message-time';
    messageTime.textContent = new Date(timestamp).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
    
    messageBubble.appendChild(messageContent);
    messageBubble.appendChild(messageTime);
    messageDiv.appendChild(messageBubble);
    
    messagesContainer.appendChild(messageDiv);
    scrollToBottom();
}

function scrollToBottom() {
    const messagesContainer = document.getElementById('messagesContainer');
    messagesContainer.scrollTop = messagesContainer.scrollHeight;
}

function handleFileSelect() {
    const fileInput = document.getElementById('fileInput');
    const selectedFiles = Array.from(fileInput.files);
    const messageInput = document.getElementById('messageInput');
    
    if (selectedFiles.length > 0) {
        const fileNames = selectedFiles.map(f => f.name).join(', ');
        messageInput.placeholder = `Đã chọn file: ${fileNames}`;
    } else {
        messageInput.placeholder = "Nhập tin nhắn...";
    }
}

function updateConversationTime() {
    const timeElements = document.querySelectorAll('.conversation-time');
    timeElements.forEach(element => {
        const lastMessageAt = element.getAttribute('data-last-message-at');
        if (lastMessageAt && lastMessageAt !== 'null' && lastMessageAt !== '') {
            try {
                const lastMessageTime = new Date(lastMessageAt);
                if (!isNaN(lastMessageTime.getTime())) {
                    const now = new Date();
                    const diffInMinutes = Math.floor((now - lastMessageTime) / (1000 * 60));
                    element.textContent = diffInMinutes > 0 ? `${diffInMinutes} phút trước` : 'Vừa xong';
                } else {
                    element.textContent = 'Không xác định';
                }
            } catch (e) {
                console.error('Error parsing lastMessageAt:', e);
                element.textContent = 'Không xác định';
            }
        } else {
            element.textContent = 'Chưa có tin nhắn';
        }
    });
}

function toggleThreads(header) {
    const threadsListId = header.getAttribute('data-toggle-target');
    const threadsList = document.getElementById(threadsListId);
    if (threadsList) {
        threadsList.classList.toggle('active');
        const toggleIcon = header.querySelector('.toggle-icon');
        toggleIcon.textContent = threadsList.classList.contains('active') ? '▼' : '▶';
    }
}

function updateConversationPreview(conversationId, content, timestamp) {
    const conversationElements = document.querySelectorAll('.conversation');
    conversationElements.forEach(element => {
        const onclick = element.getAttribute('onclick');
        if (onclick && onclick.includes(`conversation_id=${conversationId}`)) {
            const preview = element.querySelector('.conversation-preview');
            if (preview) {
                preview.textContent = content.length > 30 ? content.substring(0, 27) + '...' : content;
            }
            const timeElement = element.querySelector('.conversation-time');
            if (timeElement) {
                timeElement.setAttribute('data-last-message-at', timestamp);
            }
        }
    });
    updateConversationTime();
}

// Hàm khởi tạo chung
function initChatCommon() {
    // Xử lý sự kiện nhấn Enter
    document.getElementById('messageInput')?.addEventListener('keypress', function(event) {
        if (event.key === 'Enter') {
            const sendButton = document.getElementById('sendButton');
            if (sendButton && !sendButton.disabled) {
                sendButton.click();
            }
        }
    });
    
    // Cập nhật thời gian tin nhắn định kỳ
    setInterval(updateConversationTime, 60000);
    
    // Cuộn xuống dưới cùng khi tải trang
    window.addEventListener('load', function() {
        scrollToBottom();
        updateConversationTime();
    });
    
    // Xử lý toggle threads (nếu có)
    document.querySelectorAll('.customer-header').forEach(header => {
        header.addEventListener('click', function() {
            toggleThreads(this);
        });
    });
}