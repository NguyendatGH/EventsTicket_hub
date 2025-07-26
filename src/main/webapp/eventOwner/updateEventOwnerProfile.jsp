<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.User" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    // Kiểm tra và lưu session
    Object userObj = session.getAttribute("user");
    if (userObj == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    
    String role = null;
    models.User user = null;
    dto.UserDTO userDTO = null;
    
    if (userObj instanceof models.User) {
        user = (models.User) userObj;
        role = user.getRole();
    } else if (userObj instanceof dto.UserDTO) {
        userDTO = (dto.UserDTO) userObj;
        role = userDTO.getRole();
    }
    
    if (!"event_owner".equals(role)) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    
    // Lưu session nếu chưa có
    if (user != null) {
        session.setAttribute("user", user);
        session.setAttribute("userRole", role);
        session.setAttribute("userId", user.getId());
        session.setAttribute("userName", user.getName());
        session.setAttribute("userEmail", user.getEmail());
    } else if (userDTO != null) {
        session.setAttribute("user", userDTO);
        session.setAttribute("userRole", role);
        session.setAttribute("userId", userDTO.getId());
        session.setAttribute("userName", userDTO.getName());
        session.setAttribute("userEmail", userDTO.getEmail());
    }
    
    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
    String contextPath = request.getContextPath();
    
    // Lấy thông tin user để hiển thị
    String userName = (String) session.getAttribute("userName");
    String userEmail = (String) session.getAttribute("userEmail");
    if (userName == null || userName.isEmpty()) {
        userName = user != null ? user.getName() : (userDTO != null ? userDTO.getName() : "");
    }
    if (userEmail == null || userEmail.isEmpty()) {
        userEmail = user != null ? user.getEmail() : (userDTO != null ? userDTO.getEmail() : "");
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ban Tổ Chức - MasterTicket</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: radial-gradient(ellipse at top left, #0f1123 60%, #1f1d40 100%), linear-gradient(135deg, #5e1763 0%, #1f1d40 100%);
            background-repeat: no-repeat;
            background-size: cover;
            color: #fff;
            min-height: 100vh;
            position: relative;
            overflow-x: hidden;
        }

        /* Background dots effect */
        body::before {
            content: '';
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-image: 
                radial-gradient(circle at 20% 30%, rgba(255, 105, 180, 0.1) 2px, transparent 2px),
                radial-gradient(circle at 80% 20%, rgba(255, 105, 180, 0.08) 1px, transparent 1px),
                radial-gradient(circle at 40% 70%, rgba(255, 105, 180, 0.12) 3px, transparent 3px),
                radial-gradient(circle at 90% 80%, rgba(255, 105, 180, 0.06) 1.5px, transparent 1.5px),
                radial-gradient(circle at 10% 90%, rgba(255, 105, 180, 0.1) 2.5px, transparent 2.5px),
                radial-gradient(circle at 70% 10%, rgba(255, 105, 180, 0.08) 1px, transparent 1px);
            background-size: 200px 200px, 150px 150px, 300px 300px, 100px 100px, 250px 250px, 120px 120px;
            pointer-events: none;
            z-index: 0;
        }

        .header {
            width: 100%;
            background: rgba(15, 17, 35, 0.95);
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 18px 60px 10px 60px;
            position: relative;
            z-index: 10;
        }

        .header .logo {
            color: #fff;
            font-size: 1.6rem;
            font-weight: 700;
            letter-spacing: 1px;
        }

        .header .search-bar {
            display: flex;
            align-items: center;
            background: #23243a;
            border-radius: 8px;
            padding: 2px 8px;
        }

        .header .search-bar input {
            background: transparent;
            border: none;
            color: #fff;
            padding: 8px 10px;
            outline: none;
            width: 220px;
        }

        .header .search-bar button {
            background: #444;
            color: #fff;
            border: none;
            border-radius: 6px;
            padding: 7px 18px;
            margin-left: 6px;
            cursor: pointer;
        }

        .header .menu {
            display: flex;
            gap: 28px;
            margin-left: 40px;
        }

        .header .menu a {
            color: #bdbdfc;
            text-decoration: none;
            font-size: 1rem;
            font-weight: 500;
            transition: color 0.2s;
        }

        .header .menu a.active, .header .menu a:hover {
            color: #a259f7;
        }

        .header .user-info {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .header .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: linear-gradient(45deg, #a259f7, #4facfe);
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            color: #fff;
            border: 2px solid rgba(255, 255, 255, 0.2);
        }

        .header .user-avatar img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 50%;
        }

        .header .user-details {
            display: flex;
            flex-direction: column;
        }

        .header .user-name {
            font-weight: 600;
            color: #fff;
            font-size: 0.9rem;
        }

        .header .user-role {
            color: #bdbdfc;
            font-size: 0.8rem;
        }

        .header .logout-btn {
            background: linear-gradient(90deg, #ff6b6b, #ee5a24);
            color: #fff;
            border: none;
            border-radius: 8px;
            padding: 8px 16px;
            font-size: 0.9rem;
            cursor: pointer;
            transition: all 0.3s;
        }

        .header .logout-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(255, 107, 107, 0.3);
        }

        .main-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 40px 20px;
            position: relative;
            z-index: 1;
        }

        .page-title {
            font-size: 2.5rem;
            font-weight: 700;
            color: #fff;
            margin-bottom: 30px;
            position: relative;
        }

        .page-title::after {
            content: '';
            position: absolute;
            bottom: -10px;
            left: 0;
            width: 100px;
            height: 4px;
            background: linear-gradient(90deg, #a259f7, #4facfe);
            border-radius: 2px;
        }

        .dashboard-layout {
            display: flex;
            gap: 30px;
            margin-top: 40px;
        }

        .sidebar {
            width: 300px;
            flex-shrink: 0;
        }

        .profile-card {
            background: rgba(36, 19, 54, 0.85);
            border-radius: 22px;
            padding: 40px;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            display: flex;
            flex-direction: column;
            align-items: center;
            text-align: center;
            position: relative;
            margin-bottom: 20px;
        }

        .profile-avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            background: linear-gradient(45deg, #a259f7, #4facfe);
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 20px;
            font-size: 3rem;
            color: #fff;
            border: 4px solid rgba(255, 255, 255, 0.2);
        }

        .profile-avatar img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 50%;
        }

        .profile-name {
            font-size: 1.8rem;
            font-weight: 700;
            color: #fff;
            margin-bottom: 10px;
        }

        .profile-bio {
            color: #bdbdfc;
            font-size: 1rem;
            line-height: 1.5;
            margin-bottom: 30px;
        }

        .export-btn {
            background: linear-gradient(90deg, #a259f7, #4facfe);
            color: #fff;
            border: none;
            border-radius: 12px;
            padding: 12px 24px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            position: absolute;
            bottom: 20px;
            right: 20px;
        }

        .export-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(162, 89, 247, 0.4);
        }

        .options-panel {
            background: rgba(36, 19, 54, 0.85);
            border-radius: 22px;
            padding: 30px;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        .options-title {
            font-size: 1.5rem;
            font-weight: 700;
            color: #fff;
            margin-bottom: 25px;
        }

        .options-list {
            list-style: none;
        }

        .options-list li {
            margin-bottom: 15px;
        }

        .options-list a {
            color: #bdbdfc;
            text-decoration: none;
            font-size: 1rem;
            padding: 12px 16px;
            display: block;
            border-radius: 8px;
            transition: all 0.3s;
            cursor: pointer;
        }

        .options-list a:hover,
        .options-list a.active {
            background: rgba(162, 89, 247, 0.2);
            color: #fff;
        }

        .main-content {
            flex: 1;
            min-width: 0;
        }

        .content-area {
            background: rgba(36, 19, 54, 0.85);
            border-radius: 22px;
            padding: 30px;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            min-height: 500px;
        }

        .content-section {
            display: none;
        }

        .content-section.active {
            display: block;
        }

        .section-title {
            font-size: 1.8rem;
            font-weight: 700;
            color: #fff;
            margin-bottom: 25px;
            position: relative;
        }

        .section-title::after {
            content: '';
            position: absolute;
            bottom: -8px;
            left: 0;
            width: 60px;
            height: 3px;
            background: linear-gradient(90deg, #a259f7, #4facfe);
            border-radius: 2px;
        }

        /* Edit Profile Form Styles */
        .edit-form {
            max-width: 800px;
            margin: 0 auto;
        }

        .avatar-section {
            text-align: center;
            margin-bottom: 40px;
            padding: 30px;
            background: rgba(255, 255, 255, 0.03);
            border-radius: 16px;
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        .avatar-preview {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            background: linear-gradient(45deg, #a259f7, #4facfe);
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            font-size: 3rem;
            color: #fff;
            border: 4px solid rgba(255, 255, 255, 0.2);
            position: relative;
            overflow: hidden;
            box-shadow: 0 8px 32px rgba(162, 89, 247, 0.3);
        }

        .avatar-preview img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 50%;
        }

        .avatar-upload {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 15px;
            flex-wrap: wrap;
        }

        .avatar-upload input[type="file"] {
            display: none;
        }

        .avatar-upload label {
            background: linear-gradient(90deg, #a259f7, #4facfe);
            color: #fff;
            padding: 12px 24px;
            border-radius: 12px;
            cursor: pointer;
            transition: all 0.3s;
            font-weight: 600;
            font-size: 1rem;
            display: flex;
            align-items: center;
            gap: 8px;
            box-shadow: 0 4px 15px rgba(162, 89, 247, 0.3);
        }

        .avatar-upload label:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(162, 89, 247, 0.4);
        }

        .avatar-upload span {
            color: #bdbdfc;
            font-size: 0.9rem;
            background: rgba(255, 255, 255, 0.05);
            padding: 8px 12px;
            border-radius: 8px;
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        .form-section {
            background: rgba(255, 255, 255, 0.03);
            border-radius: 16px;
            padding: 30px;
            border: 1px solid rgba(255, 255, 255, 0.1);
            margin-bottom: 30px;
        }

        .form-section-title {
            font-size: 1.3rem;
            font-weight: 600;
            color: #fff;
            margin-bottom: 25px;
            padding-bottom: 10px;
            border-bottom: 2px solid rgba(162, 89, 247, 0.3);
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 25px;
            margin-bottom: 25px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
        }

        .form-group.full-width {
            grid-column: 1 / -1;
        }

        .form-group label {
            margin-bottom: 10px;
            font-weight: 600;
            color: #fff;
            font-size: 0.95rem;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .form-group label::before {
            content: '';
            width: 4px;
            height: 4px;
            background: linear-gradient(90deg, #a259f7, #4facfe);
            border-radius: 50%;
        }

        .form-group input,
        .form-group select,
        .form-group textarea {
            padding: 14px 16px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 12px;
            background: rgba(255, 255, 255, 0.08);
            color: #fff;
            font-size: 1rem;
            transition: all 0.3s;
            backdrop-filter: blur(10px);
        }

        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #a259f7;
            box-shadow: 0 0 0 3px rgba(162, 89, 247, 0.2);
            background: rgba(255, 255, 255, 0.12);
        }

        .form-group input::placeholder,
        .form-group textarea::placeholder {
            color: #bdbdfc;
        }

        .form-group input[readonly] {
            opacity: 0.7;
            background: rgba(255, 255, 255, 0.05);
            cursor: not-allowed;
        }

        .form-group select option {
            background: #1f1d40;
            color: #fff;
        }

        .form-group textarea {
            resize: vertical;
            min-height: 100px;
            line-height: 1.5;
        }

        .button-group {
            display: flex;
            gap: 15px;
            justify-content: center;
            margin-top: 30px;
            padding-top: 25px;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
        }

        .btn {
            padding: 14px 32px;
            border: none;
            border-radius: 12px;
            font-weight: 600;
            font-size: 1rem;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            min-width: 160px;
            justify-content: center;
        }

        .btn-primary {
            background: linear-gradient(90deg, #a259f7, #4facfe);
            color: #fff;
            box-shadow: 0 4px 15px rgba(162, 89, 247, 0.3);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(162, 89, 247, 0.4);
        }

        .btn-secondary {
            background: transparent;
            color: #fff;
            border: 2px solid rgba(255, 255, 255, 0.3);
        }

        .btn-secondary:hover {
            background: rgba(255, 255, 255, 0.1);
            border-color: #a259f7;
            transform: translateY(-2px);
        }

        .message {
            padding: 16px;
            border-radius: 12px;
            margin-bottom: 25px;
            text-align: center;
            font-weight: 500;
            font-size: 0.95rem;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }

        .message.success {
            background: rgba(76, 175, 80, 0.15);
            border: 1px solid rgba(76, 175, 80, 0.3);
            color: #4CAF50;
        }

        .message.error {
            background: rgba(244, 67, 54, 0.15);
            border: 1px solid rgba(244, 67, 54, 0.3);
            color: #f44336;
        }

        /* Event Management Styles */
        .event-list {
            display: grid;
            gap: 15px;
        }

        .event-item {
            background: rgba(255, 255, 255, 0.05);
            border-radius: 12px;
            padding: 20px;
            border: 1px solid rgba(255, 255, 255, 0.1);
            transition: all 0.3s;
        }

        .event-item:hover {
            background: rgba(255, 255, 255, 0.08);
            transform: translateY(-2px);
        }

        .event-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 15px;
        }

        .event-title {
            font-size: 1.2rem;
            font-weight: 600;
            color: #fff;
            margin-bottom: 5px;
        }

        .event-date {
            color: #bdbdfc;
            font-size: 0.9rem;
        }

        .event-actions {
            display: flex;
            gap: 8px;
        }

        .action-btn {
            padding: 6px 12px;
            border-radius: 6px;
            font-size: 0.8rem;
            cursor: pointer;
            transition: all 0.3s;
            border: none;
        }

        .action-btn.edit {
            background: rgba(255, 193, 7, 0.2);
            color: #ffc107;
            border: 1px solid #ffc107;
        }

        .action-btn.edit:hover {
            background: rgba(255, 193, 7, 0.3);
        }

        .action-btn.delete {
            background: rgba(244, 67, 54, 0.2);
            color: #f44336;
            border: 1px solid #f44336;
        }

        .action-btn.delete:hover {
            background: rgba(244, 67, 54, 0.3);
        }

        /* History Styles */
        .history-item {
            background: rgba(255, 255, 255, 0.05);
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 15px;
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        .history-date {
            color: #a259f7;
            font-weight: 600;
            margin-bottom: 8px;
        }

        .history-action {
            color: #fff;
            margin-bottom: 5px;
        }

        .history-details {
            color: #bdbdfc;
            font-size: 0.9rem;
        }

        /* Delete History Styles */
        .delete-warning {
            background: rgba(244, 67, 54, 0.1);
            border: 1px solid rgba(244, 67, 54, 0.3);
            border-radius: 12px;
            padding: 20px;
            text-align: center;
            margin-bottom: 20px;
        }

        .delete-warning i {
            font-size: 3rem;
            color: #f44336;
            margin-bottom: 15px;
        }

        .delete-warning h3 {
            color: #f44336;
            margin-bottom: 10px;
        }

        .delete-warning p {
            color: #bdbdfc;
            margin-bottom: 20px;
        }

        .delete-btn {
            background: linear-gradient(90deg, #f44336, #d32f2f);
            color: #fff;
            border: none;
            border-radius: 8px;
            padding: 12px 24px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
        }

        .delete-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(244, 67, 54, 0.4);
        }

        .stats-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }

        .stat-card {
            background: rgba(36, 19, 54, 0.85);
            border-radius: 22px;
            padding: 30px;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        .stat-title {
            font-size: 1.2rem;
            font-weight: 600;
            color: #fff;
            margin-bottom: 20px;
        }

        .stat-value {
            font-size: 2rem;
            font-weight: 700;
            color: #a259f7;
            margin-bottom: 10px;
        }

        .top-sellers-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }

        .top-sellers-table th,
        .top-sellers-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }

        .top-sellers-table th {
            font-weight: 600;
            color: #bdbdfc;
        }

        .popularity-bar {
            width: 100px;
            height: 8px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 4px;
            overflow: hidden;
        }

        .popularity-fill {
            height: 100%;
            border-radius: 4px;
        }

        .popularity-orange { background: #ff6b35; }
        .popularity-blue { background: #4facfe; }
        .popularity-lightblue { background: #00d4ff; }
        .popularity-pink { background: #ff6b9d; }

        .products-sold-card {
            text-align: center;
        }

        .products-icon {
            font-size: 3rem;
            color: #a259f7;
            margin-bottom: 15px;
        }

        .products-count {
            font-size: 2.5rem;
            font-weight: 700;
            color: #fff;
            margin-bottom: 10px;
        }

        .products-label {
            color: #bdbdfc;
            font-size: 1rem;
        }

        .footer {
            width: 100%;
            background: rgba(15, 17, 35, 0.95);
            color: #bdbdbd;
            padding: 38px 0 18px 0;
            margin-top: 40px;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .footer-content {
            width: 90%;
            max-width: 1200px;
            display: flex;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 30px;
        }

        .footer-col {
            min-width: 200px;
            flex: 1;
        }

        .footer-col h4 {
            color: #fff;
            margin-bottom: 16px;
            font-size: 1.1rem;
        }

        .footer-col ul {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .footer-col ul li {
            margin-bottom: 10px;
        }

        .footer-col ul li a {
            color: #bdbdbd;
            text-decoration: none;
            font-size: 1rem;
        }

        .footer-col ul li a:hover {
            color: #a259f7;
        }

        .footer .subscribe {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-top: 8px;
        }

        .footer .subscribe input {
            padding: 8px 12px;
            border-radius: 8px 0 0 8px;
            border: none;
            outline: none;
            background: #23243a;
            color: #fff;
        }

        .footer .subscribe button {
            padding: 8px 16px;
            border-radius: 0 8px 8px 0;
            border: none;
            background: #a259f7;
            color: #fff;
            cursor: pointer;
        }

        .footer .lang-flags {
            display: flex;
            gap: 8px;
            margin-top: 8px;
        }

        .footer .lang-flags img {
            width: 28px;
            height: 20px;
            border-radius: 3px;
            border: 1px solid #444;
        }

        .footer .social {
            display: flex;
            gap: 12px;
            margin-top: 10px;
        }

        .footer .social a {
            color: #fff;
            font-size: 1.3rem;
            transition: color 0.2s;
        }

        .footer .social a:hover {
            color: #a259f7;
        }

        @media (max-width: 1200px) {
            .dashboard-layout {
                flex-direction: column;
                gap: 20px;
            }
            
            .sidebar {
                width: 100%;
            }
            
            .stats-grid {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 768px) {
            .header {
                padding: 15px 20px;
                flex-direction: column;
                gap: 15px;
            }

            .header .menu {
                margin-left: 0;
                gap: 15px;
            }

            .main-container {
                padding: 20px 15px;
            }

            .page-title {
                font-size: 2rem;
            }

            .dashboard-layout {
                flex-direction: column;
                gap: 15px;
            }

            .sidebar {
                width: 100%;
            }

            .profile-card {
                padding: 30px 20px;
            }

            .options-panel {
                padding: 20px;
            }

            .content-area {
                padding: 20px;
            }

            .form-grid {
                grid-template-columns: 1fr;
            }

            .button-group {
                flex-direction: column;
            }

            .avatar-upload {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="logo">MasterTicket</div>
        <form class="search-bar" action="#" method="get">
            <input type="text" placeholder="Bạn tìm gì hôm nay ?" />
            <button type="submit">Tìm kiếm</button>
        </form>
        <nav class="menu">
            <a href="${pageContext.request.contextPath}/eventOwner/dashBoard.jsp" class="active">Trang Chủ</a>
            <a href="#">Các sự kiện hot</a>
            <a href="#">Săn voucher giảm giá</a>
            <a href="#">Tạo sự kiện</a>
            <a href="#">Hỗ trợ</a>
        </nav>
        <div class="user-info">
            <div class="user-avatar">
                <% if (user != null && user.getAvatar() != null && !user.getAvatar().isEmpty()) { %>
                    <img src="${pageContext.request.contextPath}/uploads/user_avatar/<%= user.getAvatar() %>" alt="Avatar">
                <% } else { %>
                    <%= userName != null && !userName.isEmpty() ? userName.substring(0, 1).toUpperCase() : "U" %>
                <% } %>
            </div>
            <div class="user-details">
                <div class="user-name"><%= userName != null ? userName : "User" %></div>
                <div class="user-role">Event Owner</div>
            </div>
            <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Đăng xuất</a>
        </div>
    </div>

    <div class="main-container">
        <h1 class="page-title">Ban Tổ Chức</h1>

        <div class="dashboard-layout">
            <!-- Sidebar -->
            <div class="sidebar">
                <div class="profile-card">
                    <div class="profile-avatar">
                        <% if (user != null && user.getAvatar() != null && !user.getAvatar().isEmpty()) { %>
                            <img src="${pageContext.request.contextPath}/uploads/user_avatar/<%= user.getAvatar() %>" alt="Avatar">
                        <% } else { %>
                            <i class="fas fa-building"></i>
                        <% } %>
                    </div>
                    <div class="profile-name"><%= userName != null ? userName : "Mây Lang Thang" %></div>
                    <div class="profile-bio">Tiểu sử: Nơi âm nhạc và cảm xúc thăng hoa</div>
                    <button class="export-btn">Xuất dữ liệu</button>
                </div>

                <div class="options-panel">
                    <h3 class="options-title">Tùy chọn</h3>
                    <ul class="options-list">
                        <li><a href="#overview" class="active" data-target="overview-section"><i class="fas fa-chart-line"></i> Tổng quan</a></li>
                        <li><a href="#edit-profile" data-target="edit-profile-section"><i class="fas fa-user-edit"></i> Cập nhật thông tin cá nhân</a></li>
                        <li><a href="#event-management" data-target="event-management-section"><i class="fas fa-calendar-alt"></i> Cập nhật thông tin sự kiện</a></li>
                        <li><a href="#history" data-target="history-section"><i class="fas fa-history"></i> Lịch sử sự kiện đã tạo</a></li>
                        <li><a href="#delete-history" data-target="delete-history-section"><i class="fas fa-trash"></i> Xóa toàn bộ lịch sử</a></li>
                    </ul>
                </div>
            </div>

            <!-- Main Content -->
            <div class="main-content">
                <!-- Overview Section -->
                <div class="content-section active" id="overview-section">
                    <h2 class="section-title">Tổng quan</h2>
                    <p style="color: #bdbdfc; margin-bottom: 25px;">Bạn đang xem trang tổng quan của Ban Tổ Chức. Ở đây, bạn có thể thấy các thông tin chung về sự kiện và doanh thu của bạn.</p>
                    <div class="stats-grid">
                        <div class="stat-card">
                            <h3 class="stat-title">Tổng doanh thu:</h3>
                            <div class="stat-value">30.000.000 vnd</div>
                        </div>

                        <div class="stat-card">
                            <h3 class="stat-title">Top Bán Chạy</h3>
                            <table class="top-sellers-table">
                                <thead>
                                    <tr>
                                        <th>#</th>
                                        <th>Name</th>
                                        <th>Popularity</th>
                                        <th>Sales</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>01</td>
                                        <td>Home Decore Range</td>
                                        <td>
                                            <div class="popularity-bar">
                                                <div class="popularity-fill popularity-orange" style="width: 80%;"></div>
                                            </div>
                                        </td>
                                        <td>46%</td>
                                    </tr>
                                    <tr>
                                        <td>02</td>
                                        <td>Disney Princess Dress</td>
                                        <td>
                                            <div class="popularity-bar">
                                                <div class="popularity-fill popularity-blue" style="width: 60%;"></div>
                                            </div>
                                        </td>
                                        <td>17%</td>
                                    </tr>
                                    <tr>
                                        <td>03</td>
                                        <td>Bathroom Essentials</td>
                                        <td>
                                            <div class="popularity-bar">
                                                <div class="popularity-fill popularity-lightblue" style="width: 70%;"></div>
                                            </div>
                                        </td>
                                        <td>19%</td>
                                    </tr>
                                    <tr>
                                        <td>04</td>
                                        <td>Apple Smartwatch</td>
                                        <td>
                                            <div class="popularity-bar">
                                                <div class="popularity-fill popularity-pink" style="width: 50%;"></div>
                                            </div>
                                        </td>
                                        <td>29%</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <div class="stat-card products-sold-card">
                            <div class="products-icon">
                                <i class="fas fa-shopping-bag"></i>
                                <i class="fas fa-arrow-down" style="font-size: 1rem; margin-left: 5px;"></i>
                            </div>
                            <div class="products-count">120</div>
                            <div class="products-label">Sản phẩm được bán</div>
                        </div>
                    </div>
                </div>

                <!-- Edit Profile Section -->
                <div class="content-section" id="edit-profile-section">
                    <h2 class="section-title">Cập nhật thông tin cá nhân</h2>
                    <form class="edit-form" method="post" action="${pageContext.request.contextPath}/updateEventOwnerProfile" enctype="multipart/form-data">
                        <div class="avatar-section">
                            <div class="avatar-preview" id="avatarPreview">
                                <% if (user != null && user.getAvatar() != null && !user.getAvatar().isEmpty()) { %>
                                    <img src="${pageContext.request.contextPath}/uploads/user_avatar/<%= user.getAvatar() %>" alt="Avatar Preview">
                                <% } else { %>
                                    <%= userName != null && !userName.isEmpty() ? userName.substring(0, 1).toUpperCase() : "U" %>
                                <% } %>
                            </div>
                            <div class="avatar-upload">
                                <input type="file" id="avatar" name="avatar" accept="image/*">
                                <label for="avatar">
                                    <i class="fas fa-camera"></i> Chọn ảnh
                                </label>
                                <span>JPG, PNG hoặc GIF (tối đa 5MB)</span>
                            </div>
                        </div>

                        <div class="form-section">
                            <h3 class="form-section-title">Thông tin cá nhân</h3>
                            <div class="form-grid">
                                <div class="form-group">
                                    <label for="name">Tên chủ sự kiện *</label>
                                    <input type="text" id="name" name="name" value="<%= user != null ? user.getName() : (userDTO != null ? userDTO.getName() : "") %>" placeholder="Nhập tên của bạn" required>
                                </div>

                                <div class="form-group">
                                    <label for="email">Email *</label>
                                    <input type="email" id="email" name="email" value="<%= user != null ? user.getEmail() : (userDTO != null ? userDTO.getEmail() : "") %>" placeholder="Nhập email" readonly>
                                </div>

                                <div class="form-group">
                                    <label for="gender">Giới tính *</label>
                                    <select id="gender" name="gender" required>
                                        <option value="">-- Chọn giới tính --</option>
                                        <option value="Male" <%= (user != null && "Male".equals(user.getGender())) || (userDTO != null && "Male".equals(userDTO.getGender())) ? "selected" : "" %>>Nam</option>
                                        <option value="Female" <%= (user != null && "Female".equals(user.getGender())) || (userDTO != null && "Female".equals(userDTO.getGender())) ? "selected" : "" %>>Nữ</option>
                                        <option value="Other" <%= (user != null && "Other".equals(user.getGender())) || (userDTO != null && "Other".equals(userDTO.getGender())) ? "selected" : "" %>>Khác</option>
                                    </select>
                                </div>

                                <div class="form-group">
                                    <label for="birthday">Ngày sinh *</label>
                                    <input type="date" id="birthday" name="birthday" value="<%= user != null ? dateFormat.format(user.getBirthday()) : (userDTO != null ? dateFormat.format(userDTO.getBirthday()) : "") %>" required>
                                </div>

                                <div class="form-group">
                                    <label for="phoneNumber">Số điện thoại *</label>
                                    <input type="tel" id="phoneNumber" name="phoneNumber" value="<%= user != null ? user.getPhoneNumber() : (userDTO != null ? userDTO.getPhoneNumber() : "") %>" placeholder="Nhập số điện thoại" required>
                                </div>

                                <div class="form-group">
                                    <label for="address">Địa chỉ *</label>
                                    <input type="text" id="address" name="address" value="<%= user != null ? user.getAddress() : (userDTO != null ? userDTO.getAddress() : "") %>" placeholder="Nhập địa chỉ đầy đủ" required>
                                </div>


                            </div>
                        </div>

                        <!-- Messages -->
                        <% if (request.getAttribute("success") != null) { %>
                            <div class="message success">
                                <i class="fas fa-check-circle"></i> <%= request.getAttribute("success") %>
                            </div>
                        <% } else if (request.getAttribute("error") != null) { %>
                            <div class="message error">
                                <i class="fas fa-exclamation-circle"></i> <%= request.getAttribute("error") %>
                            </div>
                        <% } %>

                        <div class="button-group">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save"></i> Lưu thay đổi
                            </button>
                            <a href="${pageContext.request.contextPath}/changePassword" class="btn btn-secondary">
                                <i class="fas fa-key"></i> Đổi mật khẩu
                            </a>
                        </div>
                    </form>
                </div>

                <!-- Event Management Section -->
                <div class="content-section" id="event-management-section">
                    <h2 class="section-title">Quản lý sự kiện</h2>
                    <div class="event-list">
                        <c:choose>
                            <c:when test="${not empty myEvents}">
                                <c:forEach var="event" items="${myEvents}">
                                    <div class="event-item">
                                        <div class="event-header">
                                            <div>
                                                <h3 class="event-title">${event.name}</h3>
                                                <span class="event-date">
                                                    <fmt:formatDate value="${event.startTime}" pattern="dd/MM/yyyy" />
                                                </span>
                                            </div>
                                            <div class="event-actions">
                                                <button class="action-btn edit" onclick="editEvent(${event.eventID})">
                                                    <i class="fas fa-edit"></i> Chỉnh sửa
                                                </button>
                                                <button class="action-btn delete" onclick="deleteEvent(${event.eventID})">
                                                    <i class="fas fa-trash"></i> Xóa
                                                </button>
                                            </div>
                                        </div>
                                        <p>${event.description}</p>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="event-item">
                                    <p style="text-align: center; color: #bdbdfc;">Bạn chưa có sự kiện nào. Hãy tạo sự kiện đầu tiên!</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div style="text-align: center; margin-top: 20px;">
                        <a href="${pageContext.request.contextPath}/eventOwner/createEvent/CreateEvent.jsp" class="btn btn-primary">
                            <i class="fas fa-plus"></i> Tạo sự kiện mới
                        </a>
                    </div>
                </div>

                <!-- History Section -->
                <div class="content-section" id="history-section">
                    <h2 class="section-title">Lịch sử sự kiện đã tạo</h2>
                    <div class="history-item">
                        <div class="history-date">20/10/2023</div>
                        <div class="history-action">Tạo sự kiện: Concert Mùa Thu</div>
                        <div class="history-details">
                            <p>Tên sự kiện: Concert Mùa Thu</p>
                            <p>Ngày bắt đầu: 20/10/2023</p>
                            <p>Ngày kết thúc: 25/10/2023</p>
                            <p>Địa điểm: Nhà hát Lớn Hà Nội</p>
                        </div>
                    </div>
                    <div class="history-item">
                        <div class="history-date">15/11/2023</div>
                        <div class="history-action">Tạo sự kiện: Workshop Marketing</div>
                        <div class="history-details">
                            <p>Tên sự kiện: Workshop Marketing</p>
                            <p>Ngày bắt đầu: 15/11/2023</p>
                            <p>Ngày kết thúc: 20/11/2023</p>
                            <p>Địa điểm: Trung tâm Hội nghị Quốc gia</p>
                        </div>
                    </div>
                    <div class="history-item">
                        <div class="history-date">05/12/2023</div>
                        <div class="history-action">Tạo sự kiện: Tech Conference 2023</div>
                        <div class="history-details">
                            <p>Tên sự kiện: Tech Conference 2023</p>
                            <p>Ngày bắt đầu: 05/12/2023</p>
                            <p>Ngày kết thúc: 10/12/2023</p>
                            <p>Địa điểm: Saigon Exhibition & Convention Center</p>
                        </div>
                    </div>
                </div>

                <!-- Delete History Section -->
                <div class="content-section" id="delete-history-section">
                    <h2 class="section-title">Xóa toàn bộ lịch sử</h2>
                    <div class="delete-warning">
                        <i class="fas fa-exclamation-triangle"></i>
                        <h3>Cảnh báo: Xóa toàn bộ lịch sử sự kiện</h3>
                        <p>Bạn có chắc chắn muốn xóa toàn bộ lịch sử sự kiện đã tạo không? Điều này sẽ xóa vĩnh viễn tất cả các sự kiện trong lịch sử của bạn và không thể khôi phục lại.</p>
                        <p style="color: #ff6b6b; font-weight: 600;">Hành động này không thể hoàn tác!</p>
                        <button class="delete-btn" onclick="confirmDeleteHistory()">
                            <i class="fas fa-trash"></i> Xóa toàn bộ lịch sử
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <footer class="footer">
        <div class="footer-content">
            <div class="footer-col">
                <h4>Customer Services</h4>
                <ul>
                    <li><a href="#">FAQS</a></li>
                    <li><a href="#">Contact us</a></li>
                    <li><a href="#">Pricy Policy</a></li>
                    <li><a href="#">Terms of Service</a></li>
                </ul>
                <div style="margin-top: 10px;">
                    Email: <a href="mailto:support@masterTicket.vn" style="color:#7fffd4;"><i class="fa fa-envelope"></i> support@masterTicket.vn</a>
                </div>
            </div>
            <div class="footer-col">
                <h4>SiteMap</h4>
                <ul>
                    <li><a href="#">Create Account</a></li>
                    <li><a href="#">News</a></li>
                    <li><a href="#">Top-Rated Event</a></li>
                </ul>
            </div>
            <div class="footer-col">
                <h4>Subscribe for event updates.</h4>
                <form class="subscribe" action="#" method="post" onsubmit="return false;">
                    <input type="email" placeholder="Your email..." required value="<%= userEmail != null ? userEmail : "" %>" />
                    <button type="submit"><i class="fa fa-envelope"></i></button>
                </form>
                <div style="margin-top: 18px;">
                    Language:
                    <span class="lang-flags">
                        <img src="https://cdn.jsdelivr.net/gh/hjnilsson/country-flags/svg/vn.svg" alt="VN" />
                        <img src="https://cdn.jsdelivr.net/gh/hjnilsson/country-flags/svg/gb.svg" alt="EN" />
                    </span>
                </div>
            </div>
            <div class="footer-col">
                <h4>Follow us:</h4>
                <div class="social">
                    <a href="#"><i class="fab fa-facebook"></i></a>
                    <a href="#"><i class="fab fa-instagram"></i></a>
                    <a href="#"><i class="fab fa-tiktok"></i></a>
                </div>
            </div>
        </div>
    </footer>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Get all option links and content sections
            const optionLinks = document.querySelectorAll('.options-list a');
            const contentSections = document.querySelectorAll('.content-section');
            const avatarInput = document.getElementById('avatar');
            const avatarPreview = document.getElementById('avatarPreview');

            // Function to switch between sections
            function switchSection(targetId) {
                // Remove active class from all sections and links
                contentSections.forEach(section => {
                    section.classList.remove('active');
                });
                optionLinks.forEach(link => {
                    link.classList.remove('active');
                });

                // Add active class to target section and link
                const targetSection = document.getElementById(targetId);
                const targetLink = document.querySelector(`[data-target="${targetId}"]`);
                
                if (targetSection) {
                    targetSection.classList.add('active');
                }
                if (targetLink) {
                    targetLink.classList.add('active');
                }
            }

            // Add click event listeners to option links
            optionLinks.forEach(link => {
                link.addEventListener('click', function(e) {
                    e.preventDefault();
                    const targetId = this.getAttribute('data-target');
                    switchSection(targetId);
                });
            });

            // Avatar preview functionality
            if (avatarInput) {
                avatarInput.addEventListener('change', function(e) {
                    const file = e.target.files[0];
                    if (file) {
                        const reader = new FileReader();
                        reader.onload = function(e) {
                            avatarPreview.innerHTML = '';
                            const img = document.createElement('img');
                            img.src = e.target.result;
                            img.alt = 'Avatar Preview';
                            img.style.width = '100%';
                            img.style.height = '100%';
                            img.style.objectFit = 'cover';
                            img.style.borderRadius = '50%';
                            avatarPreview.appendChild(img);
                        };
                        reader.readAsDataURL(file);
                    }
                });
            }

            // Form validation
            const editForm = document.querySelector('.edit-form');
            if (editForm) {
                editForm.addEventListener('submit', function(e) {
                    const name = document.getElementById('name').value.trim();
                    const phone = document.getElementById('phoneNumber').value.trim();
                    const address = document.getElementById('address').value.trim();
                    
                    if (!name || !phone || !address) {
                        e.preventDefault();
                        alert('Vui lòng điền đầy đủ thông tin bắt buộc!');
                        return false;
                    }
                    
                    // Phone validation
                    const phoneRegex = /^[0-9+\-\s()]+$/;
                    if (!phoneRegex.test(phone)) {
                        e.preventDefault();
                        alert('Số điện thoại không hợp lệ!');
                        return false;
                    }
                });
            }
        });

        // Function to edit event
        function editEvent(eventId) {
            if (confirm('Bạn có muốn chỉnh sửa sự kiện này không?')) {
                window.location.href = '${pageContext.request.contextPath}/eventOwner/EditEventPage.jsp?eventId=' + eventId;
            }
        }

        // Function to delete event
        function deleteEvent(eventId) {
            if (confirm('Bạn có chắc chắn muốn xóa sự kiện này không? Hành động này không thể hoàn tác!')) {
                fetch('${pageContext.request.contextPath}/eventOwner/updateEventOwnerProfile', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'action=deleteEvent&eventId=' + eventId
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        alert('Xóa sự kiện thành công!');
                        location.reload();
                    } else {
                        alert('Xóa sự kiện thất bại: ' + data.message);
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Có lỗi xảy ra khi xóa sự kiện.');
                });
            }
        }

        // Function to confirm delete history
        function confirmDeleteHistory() {
            if (confirm('Bạn có chắc chắn muốn xóa toàn bộ lịch sử sự kiện đã tạo không? Điều này sẽ xóa vĩnh viễn tất cả các sự kiện trong lịch sử của bạn và không thể khôi phục lại.')) {
                fetch('${pageContext.request.contextPath}/eventOwner/updateEventOwnerProfile', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'action=deleteHistory&userID=<%= user != null ? user.getId() : (userDTO != null ? userDTO.getId() : "") %>'
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        alert('Xóa lịch sử thành công!');
                        location.reload();
                    } else {
                        alert('Xóa lịch sử thất bại: ' + data.message);
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Có lỗi xảy ra khi xóa lịch sử.');
                });
            }
        }
    </script>
</body>
</html>