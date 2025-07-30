<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Test Notifications - MasterTicket</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(to bottom, #161b22, #0d1117);
            color: white;
            min-height: 100vh;
            padding: 2rem;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
        }

        h1 {
            text-align: center;
            margin-bottom: 2rem;
            color: #64f3ff;
        }

        .notification-grid {
            display: grid;
            gap: 1rem;
            margin-bottom: 2rem;
        }

        .notification-card {
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 10px;
            padding: 1.5rem;
            transition: all 0.3s ease;
        }

        .notification-card:hover {
            background: rgba(255, 255, 255, 0.1);
            transform: translateY(-2px);
        }

        .notification-card.unread {
            border-left: 4px solid #64f3ff;
            background: rgba(100, 243, 255, 0.1);
        }

        .notification-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
        }

        .notification-title {
            font-size: 1.2rem;
            font-weight: 600;
            color: white;
        }

        .notification-time {
            font-size: 0.9rem;
            color: #94a3b8;
        }

        .notification-content {
            color: #ccc;
            line-height: 1.6;
            margin-bottom: 1rem;
        }

        .notification-meta {
            display: flex;
            gap: 1rem;
            font-size: 0.8rem;
            color: #64748b;
        }

        .notification-type {
            background: rgba(100, 243, 255, 0.2);
            color: #64f3ff;
            padding: 0.25rem 0.5rem;
            border-radius: 4px;
        }

        .notification-priority {
            background: rgba(255, 107, 107, 0.2);
            color: #ff6b6b;
            padding: 0.25rem 0.5rem;
            border-radius: 4px;
        }

        .notification-id {
            background: rgba(255, 193, 7, 0.2);
            color: #ffc107;
            padding: 0.25rem 0.5rem;
            border-radius: 4px;
        }

        .controls {
            display: flex;
            gap: 1rem;
            margin-bottom: 2rem;
            justify-content: center;
        }

        .btn {
            background: linear-gradient(to right, #64f3ff, #e74cfa);
            border: none;
            color: white;
            padding: 0.75rem 1.5rem;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(100, 243, 255, 0.3);
        }

        .stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin-bottom: 2rem;
        }

        .stat-card {
            background: rgba(255, 255, 255, 0.05);
            border-radius: 10px;
            padding: 1.5rem;
            text-align: center;
        }

        .stat-value {
            font-size: 2rem;
            font-weight: bold;
            color: #64f3ff;
        }

        .stat-label {
            color: #94a3b8;
            margin-top: 0.5rem;
        }

        .error-message {
            background: rgba(255, 107, 107, 0.2);
            border: 1px solid #ff6b6b;
            color: #ff6b6b;
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 1rem;
        }

        .loading {
            text-align: center;
            color: #94a3b8;
            font-size: 1.2rem;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🔔 Test Notifications for Admin (User ID: 1)</h1>
        
        <div class="controls">
            <button class="btn" onclick="loadNotifications()">Load Admin Notifications</button>
            <button class="btn" onclick="createTestNotification()">Create Admin Notification</button>
            <button class="btn" onclick="createUserNotifications()">Create User Notifications</button>
            <button class="btn" onclick="clearNotifications()">Clear Display</button>
        </div>

        <div id="stats" class="stats" style="display: none;">
            <div class="stat-card">
                <div class="stat-value" id="totalCount">0</div>
                <div class="stat-label">Total Notifications</div>
            </div>
            <div class="stat-card">
                <div class="stat-value" id="unreadCount">0</div>
                <div class="stat-label">Unread Notifications</div>
            </div>
            <div class="stat-card">
                <div class="stat-value" id="readCount">0</div>
                <div class="stat-label">Read Notifications</div>
            </div>
        </div>

        <div id="errorMessage" class="error-message" style="display: none;"></div>
        <div id="loading" class="loading" style="display: none;">Loading notifications...</div>
        <div id="notificationGrid" class="notification-grid"></div>
    </div>

    <script>
        function loadNotifications() {
            const loading = document.getElementById('loading');
            const errorMessage = document.getElementById('errorMessage');
            const notificationGrid = document.getElementById('notificationGrid');
            const stats = document.getElementById('stats');

            // Show loading
            loading.style.display = 'block';
            errorMessage.style.display = 'none';
            notificationGrid.innerHTML = '';

            fetch('${pageContext.request.contextPath}/admin-notifications')
                .then(response => {
                    console.log('Response status:', response.status);
                    if (!response.ok) {
                        throw new Error(`HTTP error! status: ${response.status}`);
                    }
                    return response.json();
                })
                .then(data => {
                    console.log('Loaded notifications:', data);
                    loading.style.display = 'none';

                    if (Array.isArray(data)) {
                        displayNotifications(data);
                        updateStats(data);
                        stats.style.display = 'grid';
                    } else if (data.error) {
                        showError('Server error: ' + data.error);
                    } else {
                        showError('Unexpected data format: ' + JSON.stringify(data));
                    }
                })
                .catch(error => {
                    console.error('Error loading notifications:', error);
                    loading.style.display = 'none';
                    showError('Failed to load notifications: ' + error.message);
                });
        }

        function displayNotifications(notifications) {
            const grid = document.getElementById('notificationGrid');
            
            if (!notifications || notifications.length === 0) {
                grid.innerHTML = '<div style="text-align: center; color: #94a3b8; font-size: 1.2rem;">No notifications found</div>';
                return;
            }

            grid.innerHTML = '';
            notifications.forEach(notification => {
                const card = document.createElement('div');
                card.className = `notification-card ${!notification.isRead ? 'unread' : ''}`;
                
                const timeAgo = formatTimeAgo(notification.createdAt);
                
                card.innerHTML = `
                    <div class="notification-header">
                        <div class="notification-title">${notification.title || 'No Title'}</div>
                        <div class="notification-time">${timeAgo}</div>
                    </div>
                    <div class="notification-content">${notification.content || 'No Content'}</div>
                    <div class="notification-meta">
                        <span class="notification-id">ID: ${notification.notificationID}</span>
                        <span class="notification-type">Type: ${notification.notificationType || 'N/A'}</span>
                        <span class="notification-priority">Priority: ${notification.priority || 'N/A'}</span>
                        <span>User ID: ${notification.userID}</span>
                        <span>Read: ${notification.isRead ? 'Yes' : 'No'}</span>
                    </div>
                `;
                
                grid.appendChild(card);
            });
        }

        function updateStats(notifications) {
            const total = notifications.length;
            const unread = notifications.filter(n => !n.isRead).length;
            const read = total - unread;

            document.getElementById('totalCount').textContent = total;
            document.getElementById('unreadCount').textContent = unread;
            document.getElementById('readCount').textContent = read;
        }

        function createTestNotification() {
            fetch('${pageContext.request.contextPath}/test-notification')
                .then(response => response.text())
                .then(data => {
                    console.log('Admin notification created:', data);
                    alert('Admin notification created! Check the page for details.');
                    loadNotifications(); // Reload to show new notification
                })
                .catch(error => {
                    console.error('Error creating admin notification:', error);
                    alert('Failed to create admin notification: ' + error.message);
                });
        }

        function createUserNotifications() {
            fetch('${pageContext.request.contextPath}/test-user-notification')
                .then(response => response.text())
                .then(data => {
                    console.log('User notifications created:', data);
                    alert('User notifications created! Admin should only see admin notifications.');
                    loadNotifications(); // Reload to show admin notifications only
                })
                .catch(error => {
                    console.error('Error creating user notifications:', error);
                    alert('Failed to create user notifications: ' + error.message);
                });
        }

        function clearNotifications() {
            document.getElementById('notificationGrid').innerHTML = '';
            document.getElementById('stats').style.display = 'none';
            document.getElementById('errorMessage').style.display = 'none';
        }

        function showError(message) {
            const errorMessage = document.getElementById('errorMessage');
            errorMessage.textContent = message;
            errorMessage.style.display = 'block';
        }

        function formatTimeAgo(dateString) {
            if (!dateString) return 'Unknown time';
            
            const date = new Date(dateString);
            const now = new Date();
            const diffInSeconds = Math.floor((now - date) / 1000);
            
            if (diffInSeconds < 60) {
                return 'Just now';
            } else if (diffInSeconds < 3600) {
                const minutes = Math.floor(diffInSeconds / 60);
                return `${minutes} minutes ago`;
            } else if (diffInSeconds < 86400) {
                const hours = Math.floor(diffInSeconds / 3600);
                return `${hours} hours ago`;
            } else {
                const days = Math.floor(diffInSeconds / 86400);
                return `${days} days ago`;
            }
        }

        // Load notifications on page load
        document.addEventListener('DOMContentLoaded', function() {
            loadNotifications();
        });
    </script>
</body>
</html> 