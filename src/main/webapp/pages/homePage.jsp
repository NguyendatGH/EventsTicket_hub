<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="models.Event"%>
<%@page import="dto.UserDTO"%>
<%@page import="models.Notification"%>
<%@page import="service.NotificationService"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>MasterTicket - Trang Chủ</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: linear-gradient(to bottom, #161b22, #0d1117);
                color: var(--text-light);
                min-height: 100vh;
                position: relative;
                overflow-x: hidden;
            }

            /* Background circles */
            body::before {
                content: '';
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                z-index: -1;
                background: 
                    radial-gradient(circle at 20% 20%, rgba(102, 122, 255, 0.15) 0%, transparent 60%),
                    radial-gradient(circle at 80% 40%, rgba(224, 107, 206, 0.12) 0%, transparent 60%),
                    radial-gradient(circle at 40% 80%, rgba(102, 122, 255, 0.1) 0%, transparent 60%),
                    radial-gradient(circle at 90% 10%, rgba(224, 107, 206, 0.08) 0%, transparent 60%),
                    radial-gradient(circle at 10% 90%, rgba(102, 122, 255, 0.12) 0%, transparent 60%),
                    radial-gradient(circle at 70% 70%, rgba(224, 107, 206, 0.09) 0%, transparent 60%);
                pointer-events: none;
                animation: float 20s ease-in-out infinite;
            }

            @keyframes float {
                0%, 100% {
                    transform: translateY(0px) rotate(0deg);
                }
                33% {
                    transform: translateY(-20px) rotate(1deg);
                }
                66% {
                    transform: translateY(10px) rotate(-1deg);
                }
            }

            /* Additional background elements */
            body::after {
                content: '';
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                z-index: -2;
                background: 
                    radial-gradient(circle at 30% 60%, rgba(102, 122, 255, 0.08) 0%, transparent 40%),
                    radial-gradient(circle at 85% 25%, rgba(224, 107, 206, 0.06) 0%, transparent 40%),
                    radial-gradient(circle at 15% 75%, rgba(102, 122, 255, 0.05) 0%, transparent 40%);
                pointer-events: none;
                animation: float 25s ease-in-out infinite reverse;
            }

            /* Color Scheme */
            :root {
                --primary: #667aff;      /* Primary color */
                --secondary: #e06bce;    /* Secondary color */
                --dark-bg: #161b22;      /* Gradient start */
                --darker-bg: #0d1117;    /* Gradient end */
                --card-bg: #21262d;      /* Card background */
                --border-color: #30363d; /* Border color */
                --text-light: #e6edf3;   /* Main text color */
                --text-muted: #8b949e;   /* Muted text color */
                --success: #00cc66;      /* Success/price color */
                --warning: #ffcc00;      /* Warning color */
                --danger: #ff3333;       /* Error color */
            }

            /* Header */
            .header {
                background: var(--darker-bg);
                padding: 1rem 2rem;
                position: sticky;
                top: 0;
                z-index: 100;
                border-bottom: 1px solid var(--border-color);
            }

            .nav {
                display: flex;
                justify-content: space-between;
                align-items: center;
                max-width: 1400px;
                margin: 0 auto;
                flex-wrap: nowrap;
            }

                    .logo {
            font-size: 1.5rem;
            font-weight: bold;
            color: var(--primary);
            text-decoration: none;
            flex-shrink: 0;
            margin-left: 1rem;
        }

            /* Container for middle content */
            .nav-center-content {
                display: flex;
                align-items: center;
                flex-grow: 1;
                justify-content: center;
                gap: 1rem;
                flex-wrap: nowrap;
            }

            .nav-links {
                display: flex;
                gap: 1.5rem;
                list-style: none;
                flex-wrap: nowrap;
            }

            .nav-links a {
                color: var(--text-light);
                text-decoration: none;
                transition: color 0.3s;
                display: flex;
                align-items: center;
                gap: 5px;
                white-space: nowrap;
            }

            .nav-links a:hover {
                color: var(--primary);
            }

            /* Toggle Buttons for Mobile */
            .nav-toggle, .search-filter-toggle {
                background: none;
                border: none;
                color: var(--text-light);
                font-size: 1.5rem;
                cursor: pointer;
                padding: 0.5rem;
                display: none; 
            }

            /* Search and Filter Container - Form version from main */
            .search-filter-container {
                display: flex;
                flex-direction: row;
                flex-wrap: nowrap;
                gap: 10px;
                flex-grow: 1;
                max-width: 600px;
                min-width: 300px;
                align-items: center;
            }

            .search-box, .filter-input {
                flex: 1;
                min-width: 100px;
                padding: 0.75rem 1rem;
                background: var(--card-bg);
                border: 1px solid var(--border-color);
                border-radius: 25px;
                color: var(--text-light);
                outline: none;
                transition: all 0.3s;
            }

            .search-box::placeholder, .filter-input::placeholder {
                color: var(--text-muted);
            }

            .search-box:focus, .filter-input:focus {
                background: rgba(255, 255, 255, 0.1);
                border-color: var(--primary);
            }

            /* Style for select dropdown */
            select.filter-input {
                cursor: pointer;
                appearance: none;
                background-image: url("data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%238b949e' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3e%3cpolyline points='6,9 12,15 18,9'%3e%3c/polyline%3e%3c/svg%3e");
                background-repeat: no-repeat;
                background-position: right 12px center;
                background-size: 16px;
                padding-right: 40px;
            }

            select.filter-input option {
                background: var(--card-bg);
                color: var(--text-light);
                padding: 8px;
            }

            .auth-buttons {
                display: flex;
                gap: 0.75rem;
                align-items: center;
                flex-shrink: 0;
                margin-left: 1rem;
                position: relative;
            }

            .btn {
                padding: 0.6rem 1.8rem;
                border: none;
                border-radius: 25px;
                cursor: pointer;
                font-weight: 500;
                font-size: 0.9rem;
                transition: all 0.3s;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                min-width: 100px;
                color: var(--text-light);
            }

            .btn-outline {
                background: transparent;
                border: 1px solid var(--border-color);
            }

            .btn-outline:hover {
                background: rgba(102, 122, 255, 0.2);
                color: var(--primary);
                border-color: var(--primary);
            }

            .btn-primary {
                background: var(--primary);
            }

            .btn-primary:hover {
                background: #5566dd;
                transform: translateY(-2px);
            }

            /* User Menu & Notification Styles */
            .user-menu {
                display: flex;
                align-items: center;
                gap: 1rem;
                position: relative;
            }

            .user-info {
                display: flex;
                align-items: center;
                gap: 0.5rem;
                cursor: pointer;
                padding: 0.5rem 1rem;
                border-radius: 25px;
                background: rgba(255, 255, 255, 0.1);
                transition: all 0.3s;
            }

            .user-info:hover {
                background: rgba(255, 255, 255, 0.15);
            }

            .user-avatar {
                width: 35px;
                height: 35px;
                border-radius: 50%;
                background-size: cover;
                background-position: center;
                border: 1px solid rgba(255, 255, 255, 0.3);
                display: flex;
                align-items: center;
                justify-content: center;
                font-weight: bold;
                font-size: 0.9rem;
                background: linear-gradient(45deg, var(--primary), var(--secondary));
                color: white;
            }

            .user-avatar img {
                width: 100%;
                height: 100%;
                object-fit: cover;
                border-radius: 50%;
            }

            .user-dropdown {
                position: absolute;
                top: calc(100% + 10px);
                right: 0;
                background: var(--darker-bg);
                backdrop-filter: blur(10px);
                border-radius: 10px;
                padding: 1rem;
                min-width: 200px;
                border: 1px solid var(--border-color);
                opacity: 0;
                visibility: hidden;
                transform: translateY(-10px);
                transition: all 0.3s ease-in-out;
                z-index: 101;
            }

            .user-dropdown.show {
                opacity: 1;
                visibility: visible;
                transform: translateY(0);
            }

            .dropdown-item {
                display: block;
                color: var(--text-light);
                text-decoration: none;
                padding: 0.75rem 0.5rem;
                border-bottom: 1px solid var(--border-color);
                transition: background 0.3s, color 0.3s;
            }

            .dropdown-item:last-child {
                border-bottom: none;
            }

            .dropdown-item:hover {
                background: rgba(102, 122, 255, 0.2);
                color: var(--primary);
            }

            /* Notification styles */
            .notification-icon-container {
                position: relative;
                margin-right: 1.5rem;
            }

            .notification-icon {
                cursor: pointer;
                font-size: 1.5rem;
                padding: 0.5rem;
                color: var(--text-muted);
                transition: color 0.3s;
            }

            .notification-icon:hover {
                color: var(--text-light);
            }

            .notification-badge {
                position: absolute;
                top: 0;
                right: 0;
                background-color: var(--danger);
                color: white;
                border-radius: 50%;
                padding: 0.2rem 0.5rem;
                font-size: 0.7rem;
                font-weight: bold;
                line-height: 1;
                min-width: 1.5rem;
                text-align: center;
                transform: translate(50%, -50%);
                opacity: 0;
                transition: opacity 0.3s;
            }

            .notification-badge.show {
                opacity: 1;
            }

            .notification-dropdown {
                position: absolute;
                top: calc(100% + 10px);
                right: 0;
                background: var(--darker-bg);
                backdrop-filter: blur(10px);
                border-radius: 10px;
                padding: 0.5rem;
                min-width: 300px;
                max-height: 400px;
                overflow-y: auto;
                border: 1px solid var(--border-color);
                opacity: 0;
                visibility: hidden;
                transform: translateY(-10px);
                transition: all 0.3s ease-in-out;
                z-index: 102;
            }

            .notification-dropdown.show {
                opacity: 1;
                visibility: visible;
                transform: translateY(0);
            }

            .notification-item {
                padding: 0.75rem;
                border-bottom: 1px solid rgba(255, 255, 255, 0.05);
                display: flex;
                flex-direction: column;
                cursor: pointer;
                transition: background-color 0.2s;
            }

            .notification-item:last-child {
                border-bottom: none;
            }

            .notification-item:hover {
                background-color: rgba(255, 255, 255, 0.05);
            }

            .notification-item.unread {
                background-color: rgba(255, 51, 51, 0.1);
                font-weight: bold;
            }

            .notification-item.unread:hover {
                background-color: rgba(255, 51, 51, 0.2);
            }

            .notification-title {
                font-size: 0.95rem;
                color: var(--text-light);
                margin-bottom: 0.2rem;
            }

            .notification-content {
                font-size: 0.85rem;
                color: var(--text-muted);
                margin-bottom: 0.2rem;
            }

            .notification-time {
                font-size: 0.75rem;
                color: rgba(255, 255, 255, 0.5);
                align-self: flex-end;
            }

            .no-notifications {
                padding: 1rem;
                text-align: center;
                color: var(--text-muted);
                font-style: italic;
            }

            /* Main Content */
            .container {
                max-width: 1400px;
                margin: 0 auto;
                padding: 2rem;
            }

            /* Hero Carousel */
            .hero-carousel {
                position: relative;
                height: 400px;
                border-radius: 16px;
                overflow: hidden;
                margin-bottom: 3rem;
                box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
            }

            .carousel-slide {
                position: absolute;
                width: 100%;
                height: 100%;
                background: linear-gradient(to right, var(--primary) 40%, var(--secondary) 100%);
                background-image: url('https://images.unsplash.com/photo-1514525253161-7a46d19cd819?ixlib=rb-4.0.3&auto=format&fit=crop&w=1400&q=80');
                background-size: cover;
                background-position: center;
                display: flex;
                align-items: center;
                justify-content: space-between;
                padding: 2rem;
                opacity: 0;
                transition: opacity 0.5s;
            }

            .carousel-slide::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0, 0, 0, 0.3);
                z-index: 1;
            }

            .carousel-slide.active {
                opacity: 1;
            }

            .carousel-content {
                position: relative;
                background: rgba(0, 0, 0, 0.5);
                padding: 1.5rem;
                border-radius: 10px;
                max-width: 50%;
                z-index: 2;
            }

            .carousel-content h2 {
                font-size: clamp(1.8rem, 5vw, 2.5rem);
                margin-bottom: 1rem;
                color: var(--text-light);
                text-shadow: 0 2px 4px rgba(0, 0, 0, 0.5);
            }

            .carousel-content p {
                font-size: clamp(1rem, 3vw, 1.2rem);
                margin-bottom: 2rem;
                color: var(--text-light);
                text-shadow: 0 1px 2px rgba(0, 0, 0, 0.3);
            }

            .carousel-indicators {
                position: absolute;
                bottom: 20px;
                left: 50%;
                transform: translateX(-50%);
                display: flex;
                gap: 10px;
                z-index: 2;
            }

            .indicator {
                width: 12px;
                height: 12px;
                border-radius: 50%;
                background: var(--text-muted);
                cursor: pointer;
                transition: all 0.3s;
            }

            .indicator.active {
                background: var(--text-light);
                transform: scale(1.2);
            }

            /* Section Headers */
            .section-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin: 3rem 0 2rem;
            }

            .section-title {
                font-size: 1.8rem;
                font-weight: bold;
                color: var(--primary);
            }

            .view-all {
                color: var(--primary);
                text-decoration: none;
                font-weight: 500;
                transition: color 0.3s;
            }

            .view-all:hover {
                color: #5566dd;
            }

            /* Event Grid */
            .event-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
                gap: 2rem;
                margin-bottom: 3rem;
            }

            .event-card {
                background: var(--card-bg);
                border-radius: 15px;
                overflow: hidden;
                transition: all 0.3s;
                border: 1px solid var(--border-color);
                cursor: pointer;
            }

            .event-card:hover {
                transform: translateY(-10px);
                box-shadow: 0 20px 40px rgba(0, 0, 0, 0.3);
                background: rgba(255, 255, 255, 0.08);
                border-color: var(--primary);
            }

            .event-image {
                width: 100%;
                height: 200px;
                object-fit: cover;
                background: linear-gradient(45deg, var(--primary), var(--secondary));
                display: flex;
                align-items: center;
                justify-content: center;
                color: var(--text-light);
            }

            .event-image img {
                width: 100%;
                height: 100%;
                object-fit: cover;
            }

            .event-info {
                padding: 1.5rem;
            }

            .event-title {
                font-size: 1.2rem;
                font-weight: bold;
                margin-bottom: 0.5rem;
                color: var(--text-light);
            }

            .event-date {
                color: var(--primary);
                font-size: 0.9rem;
                margin-bottom: 0.5rem;
            }

            .event-location {
                color: var(--text-muted);
                font-size: 0.9rem;
                margin-bottom: 1rem;
            }

            .event-description {
                color: var(--text-muted);
                font-size: 0.85rem;
                line-height: 1.4;
                margin-bottom: 1rem;
                display: -webkit-box;
                -webkit-line-clamp: 2;
                -webkit-box-orient: vertical;
                overflow: hidden;
            }

            .event-price {
                font-size: 1.1rem;
                font-weight: bold;
                color: var(--success);
            }

            /* Ticket Purchase Section */
            .ticket-section {
                background: linear-gradient(135deg, var(--primary), var(--secondary));
                border-radius: 20px;
                padding: 2rem;
                margin: 3rem 0;
                text-align: center;
                position: relative;
                overflow: hidden;
            }

            .ticket-section::before {
                content: '';
                position: absolute;
                top: -50%;
                left: -50%;
                width: 200%;
                height: 200%;
                background: radial-gradient(circle, rgba(255, 255, 255, 0.1) 0%, transparent 70%);
                animation: rotate 20s linear infinite;
            }

            @keyframes rotate {
                0% {
                    transform: rotate(0deg);
                }
                100% {
                    transform: rotate(360deg);
                }
            }

            .ticket-content {
                position: relative;
                z-index: 1;
            }

            .ticket-title {
                font-size: clamp(1.8rem, 5vw, 2.5rem);
                margin-bottom: 1rem;
                color: var(--text-light);
            }

            .ticket-subtitle {
                font-size: clamp(1rem, 3vw, 1.2rem);
                margin-bottom: 2rem;
                color: var(--text-muted);
            }

            /* No Events Message */
            .no-events {
                text-align: center;
                padding: 4rem 2rem;
                color: var(--text-muted);
            }

            .no-events h2 {
                font-size: 2rem;
                margin-bottom: 1rem;
                color: var(--danger);
            }

            /* Footer */
            .footer {
                background: var(--darker-bg);
                padding: 3rem 2rem;
                margin-top: 4rem;
                border-top: 1px solid var(--border-color);
            }

            .footer-content {
                max-width: 1400px;
                margin: 0 auto;
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                gap: 2rem;
            }

            .footer-section h3 {
                color: var(--primary);
                margin-bottom: 1rem;
                font-size: 1.2rem;
            }

            .footer-section ul {
                list-style: none;
            }

            .footer-section ul li {
                margin-bottom: 0.5rem;
            }

            .footer-section ul li a {
                color: var(--text-muted);
                text-decoration: none;
                transition: color 0.3s;
            }

            .footer-section ul li a:hover {
                color: var(--text-light);
            }

            .subscribe-box {
                display: flex;
                gap: 0.5rem;
                margin-top: 1rem;
                border: 2px solid var(--primary);
                border-radius: 8px;
                padding: 5px;
                background: var(--card-bg);
            }

            .subscribe-box input {
                flex: 1;
                padding: 0.75rem;
                border: none;
                border-radius: 25px;
                background: transparent;
                color: var(--text-light);
                outline: none;
            }

            .subscribe-box input::placeholder {
                color: var(--text-muted);
            }

            .subscribe-box button {
                padding: 0.75rem 1rem;
                border: none;
                border-radius: 25px;
                background: var(--primary);
                color: var(--text-light);
                cursor: pointer;
                transition: background 0.3s;
            }

            .subscribe-box button:hover {
                background: #5566dd;
            }

            .language {
                display: flex;
                align-items: center;
                gap: 0.5rem;
                margin-top: 1rem;
            }

            .language img {
                width: 24px;
                height: 16px;
                cursor: pointer;
                transition: transform 0.3s;
            }

            .language img:hover {
                transform: scale(1.1);
            }

            .social-icons {
                display: flex;
                align-items: center;
                gap: 0.5rem;
                margin-top: 1rem;
            }

            .social-images img {
                width: 24px;
                height: 24px;
                cursor: pointer;
                transition: transform 0.3s;
            }

            .social-images img:hover {
                transform: scale(1.1);
            }

            /* Flash Messages */
            .flash-message {
                padding: 15px;
                margin: 0 auto 20px auto;
                border-radius: 8px;
                max-width: 1200px;
                font-weight: 500;
                text-align: center;
            }

            .flash-success {
                background-color: #28a745;
                color: white;
            }

            .flash-error, .flash-fail {
                background-color: #dc3545;
                color: white;
            }

            /* Pagination Controls */
            .pagination-controls {
                display: flex;
                justify-content: center;
                align-items: center;
                gap: 10px;
                margin-top: 3rem;
                padding-bottom: 2rem;
            }

            .pagination-controls a,
            .pagination-controls span {
                text-decoration: none;
                color: var(--text-light);
                background-color: var(--card-bg);
                border: 1px solid var(--border-color);
                border-radius: 8px;
                padding: 0.7rem 1.2rem;
                transition: all 0.3s ease;
                min-width: 40px;
                text-align: center;
                font-weight: 500;
            }

            .pagination-controls a:hover {
                background-color: var(--primary);
                border-color: var(--primary);
                color: white;
                transform: translateY(-2px);
            }

            .pagination-controls .current-page {
                background-color: var(--primary);
                border-color: var(--primary);
                color: white;
                font-weight: bold;
                pointer-events: none;
            }

            .pagination-controls .disabled {
                opacity: 0.5;
                pointer-events: none;
            }

            /* Responsive Design */
            @media (min-width: 993px) {
                .nav {
                    flex-wrap: nowrap;
                    justify-content: space-between;
                }
                .nav-center-content {
                    flex-grow: 1;
                    flex-wrap: nowrap;
                    justify-content: center;
                }
                .search-filter-container {
                    flex-grow: 1;
                    flex-wrap: nowrap;
                    max-width: 600px;
                }
                .nav-links {
                    margin-left: 1rem;
                }
                .auth-buttons {
                    margin-left: 1rem;
                }
                .nav-toggle, .search-filter-toggle {
                    display: none;
                }
            }

            @media (max-width: 992px) {
                .nav {
                    flex-wrap: wrap;
                    justify-content: flex-start;
                }
                .logo {
                    margin-right: 1rem;
                }
                .nav-center-content {
                    flex-basis: 100%;
                    order: 3;
                    margin-top: 1rem;
                    justify-content: flex-start;
                    gap: 1rem;
                    flex-wrap: wrap;
                }
                .search-filter-container {
                    flex-basis: 100%;
                    flex-wrap: wrap;
                    max-width: unset;
                }
                .nav-links {
                    flex-basis: 100%;
                    margin-left: 0;
                    margin-top: 1rem;
                    justify-content: flex-start;
                    flex-wrap: wrap;
                }
                .auth-buttons {
                    margin-left: auto;
                    order: 2;
                }
                .search-filter-toggle, .nav-toggle {
                    display: block;
                    order: 1;
                    margin-left: 0.5rem;
                }
                .nav-toggle {
                    margin-left: 0;
                }
            }

            @media (max-width: 768px) {
                .nav {
                    flex-direction: column;
                    align-items: flex-start;
                }
                .logo {
                    width: 100%;
                    text-align: center;
                    margin-bottom: 1rem;
                    margin-right: 0;
                }
                .nav-center-content {
                    order: unset;
                    flex-direction: column;
                    width: 100%;
                    margin-top: 0;
                    gap: 0;
                }
                .nav-links, .search-filter-container {
                    display: none;
                    flex-direction: column;
                    width: 100%;
                    padding: 1rem 0;
                    border-top: none;
                    box-shadow: none;
                    background: transparent;
                }
                .nav-links.active, .search-filter-container.active {
                    display: flex;
                }
                .search-filter-toggle, .nav-toggle {
                    order: unset;
                    margin-left: auto;
                }
                .nav > .search-filter-toggle {
                    margin-left: auto;
                    margin-right: 0.5rem;
                }
                .nav > .nav-toggle {
                    margin-left: 0;
                }
                .auth-buttons {
                    order: unset;
                    width: 100%;
                    justify-content: center;
                    margin-left: 0;
                    margin-top: 1rem;
                }
            }

            @media (max-width: 480px) {
                .container {
                    padding: 1rem;
                }
                .hero-carousel {
                    height: 300px;
                }
                .section-title {
                    font-size: 1.5rem;
                }
                .event-card {
                    min-width: 100%;
                }
                .btn {
                    min-width: 80px;
                    padding: 0.5rem 1rem;
                }
                .carousel-content {
                    max-width: 90%;
                    padding: 1rem;
                }
                .carousel-content h2 {
                    font-size: 1.5rem;
                }
                .carousel-content p {
                    font-size: 0.9rem;
                }
            }
        </style>
    </head>
    <body>
        <%
            // Retrieve UserDTO object from session
            UserDTO user = (UserDTO) session.getAttribute("user");

            // --- Notification Logic ---
            // Initialize notification service and lists
            NotificationService notificationService = new NotificationService();
            List<Notification> notifications = new ArrayList<>();
            int unreadCount = 0;

            // Handle redirection for logged-in users with specific roles
            if (user != null) {
                // If 'user' has a getRole() method and the role is 'event_owner', redirect them.
                if ("event_owner".equals(user.getRole())) {
                    response.sendRedirect(request.getContextPath() + "/eventOwnerPage/eventOwnerHomePage");
                    return; // VERY IMPORTANT: Stop further processing of THIS JSP
                }
                // Fetch notifications ONLY if a user is logged in (and not an owner, after redirection)
                notifications = notificationService.getUserNotifications(user.getId());
                unreadCount = notificationService.getUnreadNotificationsCount(user.getId());
            }

            // Retrieve events and pagination attributes from request
            List<Event> events = (List<Event>) request.getAttribute("events");
            Integer currentPageObj = (Integer) request.getAttribute("currentPage");
            Integer noOfPagesObj = (Integer) request.getAttribute("noOfPages");
            Integer totalEventsObj = (Integer) request.getAttribute("totalEvents");

            int currentPage = (currentPageObj != null) ? currentPageObj : 1;
            int noOfPages = (noOfPagesObj != null) ? noOfPagesObj : 1;
            int totalEvents = (totalEventsObj != null) ? totalEventsObj : 0;

            SimpleDateFormat dateFormat = new SimpleDateFormat("EEE, dd/MM/yyyy HH:mm");
        %>

        <header class="header">
            <nav class="nav">
                <a href="${pageContext.request.contextPath}/home" class="logo">MasterTicket</a>

                <button class="search-filter-toggle" id="searchFilterToggle" aria-label="Toggle search and filters">
                    <i class="fas fa-search"></i>
                </button>
                <button class="nav-toggle" id="navToggle" aria-label="Toggle navigation menu">
                    <i class="fas fa-bars"></i>
                </button>

                <div class="nav-center-content">
                    <form action="${pageContext.request.contextPath}/home" method="get" class="search-filter-container" id="searchFilterContainer">
                        <input type="text" name="search" class="search-box" placeholder="Tìm sự kiện..." value="${fn:escapeXml(param.search)}" />
                        <select name="location" class="filter-input">
                            <option value="">Tất cả địa điểm</option>
                            <c:forEach var="loc" items="${locations}">
                                <option value="${loc}" <c:if test="${param.location == loc}">selected</c:if>>${loc}</option>
                            </c:forEach>
                        </select>
                        <select name="category" class="filter-input">
                            <option value="">Tất cả thể loại</option>
                            <c:forEach var="genre" items="${genres}">
                                <option value="${genre.genreID}" <c:if test="${param.category == genre.genreID}">selected</c:if>>${genre.genreName}</option>
                            </c:forEach>
                        </select>
                        <button type="submit" class="btn btn-primary">Tìm kiếm</button>
                    </form>

                    <ul class="nav-links" id="navLinks">
                        <li><a href="${pageContext.request.contextPath}/home"><i class="fas fa-home"></i> Trang chủ</a></li>
                        <li><a href="#hot-events"><i class="fas fa-fire"></i> Sự kiện hot</a></li>
                        <li><a href="#vouchers"><i class="fas fa-tags"></i> Săn voucher</a></li>
                        <li><a href="${pageContext.request.contextPath}/support"><i class="fas fa-question-circle"></i> Hỗ trợ</a></li>
                    </ul>
                </div>

                <%-- User Profile and Notifications Section --%>
                <div class="auth-buttons">
                    <c:choose>
                        <c:when test="${sessionScope.user != null}">
                            <%-- Notification Icon and Dropdown --%>
                            <div class="notification-icon-container">
                                <span class="notification-icon" onclick="toggleNotificationDropdown()">
                                    🔔
                                    <span class="notification-badge <%= unreadCount > 0 ? "show" : "" %>" id="notificationBadge">
                                        <%= unreadCount > 0 ? unreadCount : "" %>
                                    </span>
                                </span>
                                <div class="notification-dropdown" id="notificationDropdown">
                                    <% if (notifications.isEmpty()) { %>
                                        <div class="no-notifications">Bạn không có thông báo nào.</div>
                                    <% } else { %>
                                        <% for (Notification notification : notifications) { %>
                                            <div class="notification-item <%= !notification.isIsRead() ? "unread" : "" %>"
                                                 onclick="handleNotificationClick(<%= notification.getNotificationID() %>, '<%= notification.getNotificationType() %>', <%= notification.getRelatedID() != null ? notification.getRelatedID() : "null" %>)">
                                                <span class="notification-title"><%= notification.getTitle() %></span>
                                                <span class="notification-content"><%= notification.getContent() %></span>
                                                <span class="notification-time"><%= new SimpleDateFormat("HH:mm dd/MM").format(java.sql.Timestamp.valueOf(notification.getCreatedAt())) %></span>
                                            </div>
                                        <% } %>
                                    <% } %>
                                </div>
                            </div>

                            <div class="user-menu">
                                <div class="user-info" onclick="toggleUserDropdown()">
                                    <%-- Display User Avatar --%>
                                    <div class="user-avatar">
                                        <% if (user.getAvatar() != null && !user.getAvatar().isEmpty()) { %>
                                            <img src="${pageContext.request.contextPath}/uploads/user_avatar/<%= user.getAvatar() %>" alt="Avatar">
                                        <% } else { %>
                                            <%= user.getEmail().substring(0, 1).toUpperCase() %>
                                        <% } %>
                                    </div>
                                    Xin chào, <%= user.getName() != null && !user.getName().isEmpty() ? user.getName() : user.getEmail() %> <span style="margin-left: 0.5rem;">▼</span>
                                </div>
                                <div class="user-dropdown" id="userDropdown">
                                    <a href="${pageContext.request.contextPath}/updateProfile" class="dropdown-item">👤 Thông tin cá nhân</a>
                                    <a href="${pageContext.request.contextPath}/myTickets" class="dropdown-item">🎫 Vé đã mua</a>
                                    <a href="${pageContext.request.contextPath}/favoriteEvents" class="dropdown-item">❤️ Sự kiện yêu thích</a>
                                    <a href="${pageContext.request.contextPath}/settings" class="dropdown-item">⚙️ Cài đặt</a>
                                    <hr style="border: none; border-top: 1px solid var(--border-color); margin: 0.5rem 0;">
                                    <a href="${pageContext.request.contextPath}/logout" class="dropdown-item" style="color: var(--danger);">🚪 Đăng xuất</a>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <%-- Show Login/Register buttons if user is not logged in --%>
                            <a href="${pageContext.request.contextPath}/login" class="btn btn-outline">Đăng nhập</a>
                            <a href="${pageContext.request.contextPath}/register" class="btn btn-primary">Đăng ký</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </nav>
        </header>

        <main class="container">
            <div class="hero-carousel">
                <div class="carousel-slide active" style="background-image: url('https://images.unsplash.com/photo-1514525253161-7a46d19cd819?ixlib=rb-4.0.3&auto=format&fit=crop&w=1400&q=80');">
                    <div class="carousel-content">
                        <h2>Chào mừng đến với MasterTicket</h2>
                        <p>Khám phá hàng ngàn sự kiện thú vị và đặt vé ngay hôm nay!</p>
                        <a href="#events" class="btn btn-primary">Khám phá ngay</a>
                    </div>
                </div>
                <div class="carousel-slide" style="background-image: url('https://images.unsplash.com/photo-1505373877845-8c2aace4d817?ixlib=rb-4.0.3&auto=format&fit=crop&w=1400&q=80');">
                    <div class="carousel-content">
                        <h2>Sự kiện âm nhạc đỉnh cao</h2>
                        <p>Đừng bỏ lỡ những đêm nhạc sống động với các nghệ sĩ hàng đầu!</p>
                        <a href="#events" class="btn btn-primary">Xem chi tiết</a>
                    </div>
                </div>
                <div class="carousel-slide" style="background-image: url('https://images.unsplash.com/photo-1607962837350-ed6062031177?ixlib=rb-4.0.3&auto=format&fit=crop&w=1400&q=80');">
                    <div class="carousel-content">
                        <h2>Sự kiện văn hóa và nghệ thuật</h2>
                        <p>Đắm chìm vào thế giới nghệ thuật với các triển lãm và biểu diễn độc đáo.</p>
                        <a href="#events" class="btn btn-primary">Tìm hiểu thêm</a>
                    </div>
                </div>
                <div class="carousel-indicators">
                    <div class="indicator active"></div>
                    <div class="indicator"></div>
                    <div class="indicator"></div>
                </div>
            </div>

            <% if (events == null || events.isEmpty()) { %>
            <div class="no-events">
                <h2>Không có sự kiện nào!</h2>
                <p>Hiện tại chưa có sự kiện nào được tổ chức. Vui lòng quay lại sau!</p>
            </div>
            <% } else { %>

            <div class="section-header">
                <h2 class="section-title" id="hot-events">Sự kiện nổi bật</h2>
                <a href="${pageContext.request.contextPath}/home?page=1" class="view-all">Xem tất cả</a>
            </div>

            <div class="event-grid">
                <%  
                    for (Event event : events) {
                %>
                <div class="event-card" 
                     data-event-id="<%= event.getEventID() %>"
                     onclick="navigateToEventDetail(this.getAttribute('data-event-id'))">
                    <div class="event-image">
                        <% if (event.getImageURL() != null && !event.getImageURL().trim().isEmpty()) { %>
                            <img src="${pageContext.request.contextPath}/uploads/event_banners/<%= event.getImageURL() %>" alt="<%= event.getName() %>" />
                        <% } else { %>
                            <span style="font-size: 50px; display: flex; justify-content: center; align-items: center; height: 100%; background-color: var(--card-bg);">🎫</span>
                        <% } %>
                    </div>
                    <div class="event-info">
                        <div class="event-title"><%= event.getName()%></div>
                        <div class="event-date">
                            <% if (event.getStartTime() != null && event.getEndTime() != null) {%>
                            🗓️ <%= dateFormat.format(event.getStartTime())%> - <%= dateFormat.format(event.getEndTime())%>
                            <% } else { %>
                            🗓️ Thời gian không xác định
                            <% }%>
                        </div>
                        <div class="event-location">📍 <%= event.getPhysicalLocation() != null ? event.getPhysicalLocation() : "Địa điểm không xác định"%></div>
                        <div class="event-description">
                            <%= event.getDescription() != null ? event.getDescription() : ""%>
                        </div>
                        <div class="event-price">Từ 150,000 VNĐ</div>
                    </div>
                </div>
                <% } %>
            </div>

            <div class="pagination-controls">
                <a href="${pageContext.request.contextPath}/home?page=<%= currentPage - 1 %>&search=${fn:escapeXml(param.search)}&location=${fn:escapeXml(param.location)}&category=${fn:escapeXml(param.category)}" 
                   class="<%= (currentPage == 1) ? "disabled" : "" %>">Trước</a>

                <%  
                    // Display page numbers
                    int startPage = Math.max(1, currentPage - 2);
                    int endPage = Math.min(noOfPages, currentPage + 2);

                    if (startPage > 1) {
                        %><a href="${pageContext.request.contextPath}/home?page=1&search=${fn:escapeXml(param.search)}&location=${fn:escapeXml(param.location)}&category=${fn:escapeXml(param.category)}">1</a><%
                        if (startPage > 2) {
                            %><span>...</span><%
                        }
                    }

                    for (int i = startPage; i <= endPage; i++) {
                        if (i == currentPage) {
                            %><span class="current-page"><%= i %></span><%
                        } else {
                            %><a href="${pageContext.request.contextPath}/home?page=<%= i %>&search=${fn:escapeXml(param.search)}&location=${fn:escapeXml(param.location)}&category=${fn:escapeXml(param.category)}"><%= i %></a><%
                        }
                    }

                    if (endPage < noOfPages) {
                        if (endPage < noOfPages - 1) {
                            %><span>...</span><%
                        }
                        %><a href="${pageContext.request.contextPath}/home?page=<%= noOfPages %>&search=${fn:escapeXml(param.search)}&location=${fn:escapeXml(param.location)}&category=${fn:escapeXml(param.category)}"><%= noOfPages %></a><%
                    }
                %>

                <a href="${pageContext.request.contextPath}/home?page=<%= currentPage + 1 %>&search=${fn:escapeXml(param.search)}&location=${fn:escapeXml(param.location)}&category=${fn:escapeXml(param.category)}" 
                   class="<%= (currentPage == noOfPages) ? "disabled" : "" %>">Sau</a>
            </div>

            <% } %>

            <div class="ticket-section">
                <div class="ticket-content">
                    <h2 class="ticket-title">Mua vé của bạn</h2>
                    <p class="ticket-subtitle">Đơn giản, nhanh chóng và an toàn</p>
                    <a href="${pageContext.request.contextPath}/login" class="btn btn-primary">Bắt đầu mua vé</a>
                </div>
            </div>
        </main>

        <footer class="footer">
            <div class="footer-content">
                <div class="footer-section">
                    <h3>Dịch vụ khách hàng</h3>
                    <ul>
                        <li><a href="#">FAQ</a></li>
                        <li><a href="#">Liên hệ</a></li>
                        <li><a href="#">Chính sách bảo mật</a></li>
                        <li><a href="#">Điều khoản dịch vụ</a></li>
                    </ul>
                    <p><a href="mailto:support@masterticket.vn">support@masterticket.vn</a></p>
                </div>
                <div class="footer-section">
                    <h3>Sơ đồ trang</h3>
                    <ul>
                        <li><a href="#">Tạo tài khoản</a></li>
                        <li><a href="#">Tin tức</a></li>
                        <li><a href="#">Sự kiện nổi bật</a></li>
                    </ul>
                </div>
                <div class="footer-section">
                    <h3>Đăng ký nhận thông tin</h3>
                    <form class="subscribe-box">
                        <input type="email" placeholder="Email của bạn..." required value="<%=(user != null ? user.getEmail() : "")%>"/>
                        <button type="submit">Gửi</button>
                    </form>
                    <div class="language">
                        <p>Ngôn ngữ:</p>
                        <img src="https://flagcdn.com/w40/vn.png" alt="Tiếng Việt" />
                        <img src="https://flagcdn.com/w40/gb.png" alt="English" />
                    </div>
                    <div class="social-icons">
                        <p>Theo dõi chúng tôi:</p>
                        <div class="social-images">
                            <img src="https://cdn-icons-png.flaticon.com/512/733/733547.png" alt="Facebook" />
                            <img src="https://cdn-icons-png.flaticon.com/512/2111/2111463.png" alt="Instagram" />
                            <img src="https://cdn-icons-png.flaticon.com/512/3046/3046120.png" alt="TikTok" />
                        </div>
                    </div>
                </div>
            </div>
        </footer>

        <script>
            // --- Common Dropdown Toggling ---
            function toggleUserDropdown() {
                const dropdown = document.getElementById("userDropdown");
                if (dropdown) {
                    dropdown.classList.toggle("show");
                    // Close notifications dropdown if open
                    const notificationDropdown = document.getElementById("notificationDropdown");
                    if (notificationDropdown && notificationDropdown.classList.contains('show')) {
                        notificationDropdown.classList.remove('show');
                    }
                }
            }

            function toggleNotificationDropdown() {
                const dropdown = document.getElementById("notificationDropdown");
                if (dropdown) {
                    dropdown.classList.toggle("show");
                    // Close user dropdown if open
                    const userDropdown = document.getElementById("userDropdown");
                    if (userDropdown && userDropdown.classList.contains('show')) {
                        userDropdown.classList.remove('show');
                    }

                    // Mark all notifications as read when the dropdown is opened
                    if (dropdown.classList.contains('show')) {
                        markAllNotificationsAsRead();
                    }
                }
            }

            // Close all dropdowns if click outside
            window.addEventListener("click", function (e) {
                const userInfo = document.querySelector(".user-info");
                const userDropdown = document.getElementById("userDropdown");
                const notificationIconContainer = document.querySelector(".notification-icon-container");
                const notificationDropdown = document.getElementById("notificationDropdown");

                // Check if click is outside user-info and user-dropdown
                if (userDropdown && userInfo && !userInfo.contains(e.target) && !userDropdown.contains(e.target)) {
                    userDropdown.classList.remove("show");
                }
                // Check if click is outside notification-icon-container and notification-dropdown
                if (notificationDropdown && notificationIconContainer && !notificationIconContainer.contains(e.target) && !notificationDropdown.contains(e.target)) {
                    notificationDropdown.classList.remove("show");
                }
            });

            // Navigate to event detail
            function navigateToEventDetail(eventId) {
                if (eventId) {
                    window.location.href = "${pageContext.request.contextPath}/EventServlet?id=" + eventId;
                } else {
                    console.error("Event ID is missing.");
                }
            }

            // Carousel functionality
            function setupCarousel() {
                const slides = document.querySelectorAll('.carousel-slide');
                const indicators = document.querySelectorAll('.indicator');
                let currentSlide = 0;

                if (slides.length > 0 && indicators.length > 0) {
                    function showSlide(index) {
                        slides.forEach(slide => slide.classList.remove('active'));
                        indicators.forEach(indicator => indicator.classList.remove('active'));

                        slides[index].classList.add('active');
                        indicators[index].classList.add('active');
                    }

                    function nextSlide() {
                        currentSlide = (currentSlide + 1) % slides.length;
                        showSlide(currentSlide);
                    }

                    indicators.forEach((indicator, index) => {
                        indicator.addEventListener('click', () => {
                            currentSlide = index;
                            showSlide(currentSlide);
                        });
                    });

                    // Start auto-play only if there are multiple slides
                    if (slides.length > 1) {
                        setInterval(nextSlide, 5000);
                    }
                    showSlide(currentSlide);
                }
            }

            // Toggle for navigation links on small screens
            function setupNavToggle() {
                const navToggle = document.getElementById('navToggle');
                const navLinks = document.getElementById('navLinks');
                const searchFilterContainer = document.getElementById('searchFilterContainer');

                if (navToggle && navLinks) {
                    navToggle.addEventListener('click', () => {
                        navLinks.classList.toggle('active');
                        // Ensure search/filter container is hidden when nav links are shown
                        if (searchFilterContainer) {
                            searchFilterContainer.classList.remove('active');
                        }
                    });
                }
            }

            // Toggle for search and filter inputs on small screens
            function setupSearchFilterToggle() {
                const searchFilterToggle = document.getElementById('searchFilterToggle');
                const searchFilterContainer = document.getElementById('searchFilterContainer');
                const navLinks = document.getElementById('navLinks');

                if (searchFilterToggle && searchFilterContainer) {
                    searchFilterToggle.addEventListener('click', () => {
                        searchFilterContainer.classList.toggle('active');
                        // Ensure nav links are hidden when search/filter are shown
                        if (navLinks) {
                            navLinks.classList.remove('active');
                        }
                    });
                }
            }

            // Initialize page on DOM content loaded
            document.addEventListener('DOMContentLoaded', () => {
                setupCarousel();
                setupNavToggle();
                setupSearchFilterToggle();
            });

            // Smooth scrolling for navigation links
            document.querySelectorAll('a[href^="#"]').forEach(anchor => {
                anchor.addEventListener('click', function (e) {
                    e.preventDefault();
                    const targetId = this.getAttribute('href').substring(1);
                    const target = document.getElementById(targetId);
                    if (target) {
                        target.scrollIntoView({
                            behavior: 'smooth',
                            block: 'start'
                        });
                    }
                });
            });

            // --- Notification JavaScript Functions ---
            function handleNotificationClick(notificationID, notificationType, relatedID) {
                // Mark notification as read
                markNotificationAsRead(notificationID);

                // Optionally, redirect based on notification type
                let redirectUrl = null;
                const contextPath = '<%= request.getContextPath() %>';

                // Check for "null" string as well, because JSP might render null as string "null"
                if (notificationType === 'order' && relatedID !== null && relatedID !== 'null') {
                    redirectUrl = contextPath + '/order-details?orderId=' + relatedID;
                } else if (notificationType === 'event' && relatedID !== null && relatedID !== 'null') {
                    redirectUrl = contextPath + '/EventServlet?id=' + relatedID;
                } else if (notificationType === 'promotion') {
                    redirectUrl = contextPath + '/promotions';
                }

                if (redirectUrl) {
                    // Short delay to allow UI update before redirecting
                    setTimeout(() => {
                        window.location.href = redirectUrl;
                    }, 100);
                } else {
                    // If no specific redirect, just close the dropdown
                    toggleNotificationDropdown();
                }
            }

            function markNotificationAsRead(notificationID) {
                fetch('${pageContext.request.contextPath}/notification-servlet?action=markRead&notificationID=' + notificationID, {
                    method: 'POST'
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        const notificationItem = document.querySelector(`.notification-item[onclick*='${notificationID}']`);
                        if (notificationItem) {
                            notificationItem.classList.remove('unread');
                        }
                        const badge = document.getElementById('notificationBadge');
                        let currentCount = parseInt(badge.textContent || '0');
                        if (currentCount > 0) {
                            currentCount--;
                            badge.textContent = currentCount > 0 ? currentCount : '';
                            if (currentCount === 0) {
                                badge.classList.remove('show');
                            }
                        }
                    } else {
                        console.error('Failed to mark notification as read:', data.message);
                    }
                })
                .catch(error => console.error('Error marking notification as read:', error));
            }

            function markAllNotificationsAsRead() {
                fetch('${pageContext.request.contextPath}/notification-servlet?action=markAllRead', {
                    method: 'POST'
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        document.querySelectorAll('.notification-item.unread').forEach(item => {
                            item.classList.remove('unread');
                        });
                        const badge = document.getElementById('notificationBadge');
                        badge.textContent = '';
                        badge.classList.remove('show');
                    } else {
                        console.error('Failed to mark all notifications as read:', data.message);
                    }
                })
                .catch(error => console.error('Error marking all notifications as read:', error));
            }
        </script>

        <%-- Flash messages --%>
        <% String flashMessageSuccess = (String)session.getAttribute("flashMessage_success"); %>
        <% if (flashMessageSuccess != null && !flashMessageSuccess.isEmpty()) { %>
        <div class="flash-message flash-success" id="successPopup">
            <%= flashMessageSuccess %>
        </div>
        <script>
            document.addEventListener("DOMContentLoaded", function () {
                const popup = document.getElementById("successPopup");
                if (popup) {
                    popup.style.display = "flex";
                    setTimeout(() => {
                        popup.style.display = "none";
                    }, 5000);
                }
            });
        </script>
        <% session.removeAttribute("flashMessage_success"); %>
        <% } %>

        <% String flashMessageError = (String)session.getAttribute("flashMessage_error"); %>
        <% if (flashMessageError != null && !flashMessageError.isEmpty()) { %>
        <div class="flash-message flash-error" id="errorPopup">
            <%= flashMessageError %>
        </div>
        <script>
            document.addEventListener("DOMContentLoaded", function () {
                const popup = document.getElementById("errorPopup");
                if (popup) {
                    popup.style.display = "flex";
                    setTimeout(() => {
                        popup.style.display = "none";
                    }, 5000);
                }
            });
        </script>
        <% session.removeAttribute("flashMessage_error"); %>
        <% } %>

    </body>
</html>