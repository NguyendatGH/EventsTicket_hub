<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="models.Event"%>
<%@page import="models.User"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
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
            }

            /* Color Scheme from EventDetails.jsp */
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
                justify-content: space-between; /* Space out items */
                align-items: center;
                max-width: 1400px;
                margin: 0 auto;
                flex-wrap: nowrap; /* Prevent wrapping on desktop */
            }

            .logo {
                font-size: 1.5rem;
                font-weight: bold;
                color: var(--primary);
                text-decoration: none;
                flex-shrink: 0; /* Prevent logo from shrinking */
            }

            /* New container for middle content */
            .nav-center-content {
                display: flex;
                align-items: center;
                flex-grow: 1; /* Allow this area to take up remaining space */
                justify-content: center; /* Center items within this area */
                gap: 1rem; /* Space between search/filter and nav links */
                flex-wrap: nowrap; /* Prevent wrapping initially */
            }

            .nav-links {
                display: flex;
                gap: 1.5rem;
                list-style: none;
                flex-wrap: nowrap; /* Prevent nav links from wrapping */
            }

            .nav-links a {
                color: var(--text-light);
                text-decoration: none;
                transition: color 0.3s;
                display: flex;
                align-items: center;
                gap: 5px;
                white-space: nowrap; /* Prevent links from wrapping */
            }

            .nav-links a:hover {
                color: var(--primary);
            }

            /* Toggle Buttons for Mobile (Hidden by default on larger screens) */
            .nav-toggle, .search-filter-toggle {
                background: none;
                border: none;
                color: var(--text-light);
                font-size: 1.5rem;
                cursor: pointer;
                padding: 0.5rem;
                display: none; 
            }

            /* Search and Filter Container - Always horizontal on wider screens */
            .search-filter-container {
                display: flex; /* Use flexbox */
                flex-direction: row; /* Arrange items in a row */
                flex-wrap: nowrap; /* Prevent wrapping on wider screens */
                gap: 10px;
                flex-grow: 1; /* Allows it to grow and shrink */
                max-width: 600px; /* Max width for consistency */
                min-width: 300px; /* Minimum width to prevent crushing */
                align-items: center;
            }

            .search-box, .filter-input {
                flex: 1; /* Allows inputs to take equal available space */
                min-width: 100px; /* Adjusted min-width for better horizontal fit */
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

            .auth-buttons {
                display: flex;
                gap: 0.75rem;
                align-items: center;
                flex-shrink: 0; /* Prevent buttons from shrinking */
                margin-left: 1rem; /* Space between center content and auth buttons */
                position: relative; /* For dropdown */
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

            .user-greeting {
                color: var(--text-light);
                font-size: 0.9rem;
                margin-right: 0.75rem;
                white-space: nowrap;
                cursor: pointer; /* Make it clickable for dropdown */
            }

            .user-dropdown {
                position: absolute;
                top: 100%;
                right: 0;
                background: var(--darker-bg);
                border-radius: 10px;
                padding: 1rem;
                min-width: 200px;
                border: 1px solid var(--border-color);
                opacity: 0;
                visibility: hidden;
                transform: translateY(-10px);
                transition: all 0.3s;
                z-index: 101; /* Above header */
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
                padding: 0.5rem 0;
                border-bottom: 1px solid var(--border-color);
                transition: color 0.3s;
            }

            .dropdown-item:last-child {
                border-bottom: none;
            }

            .dropdown-item:hover {
                color: var(--primary);
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
                background: linear-gradient(to right, var(--primary) 40%, var(--secondary) 100%); /* Fallback */
                background-image: url('https://images.unsplash.com/photo-1514525253161-7a46d19cd819?ixlib=rb-4.0.3&auto=format&fit=crop&w=1400&q=80'); /* Event-related image */
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
                background: rgba(0, 0, 0, 0.3); /* Dark tint for readability */
                z-index: 1;
            }

            .carousel-slide.active {
                opacity: 1;
            }

            .carousel-content {
                position: relative;
                background: rgba(0, 0, 0, 0.5); /* Semi-transparent overlay */
                padding: 1.5rem;
                border-radius: 10px;
                max-width: 50%;
                z-index: 2; /* Above tint */
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

            /* Responsive adjustments */
            @media (min-width: 993px) { /* For larger screens, ensure everything is in one row */
                .nav {
                    flex-wrap: nowrap; /* Prevent wrapping */
                    justify-content: space-between; /* Distribute items with space */
                }
                .nav-center-content {
                    flex-grow: 1; /* Allow it to take available space */
                    flex-wrap: nowrap; /* Prevent wrapping within this section */
                    justify-content: center; /* Center search and nav links */
                }
                .search-filter-container {
                    flex-grow: 1;
                    flex-wrap: nowrap;
                    max-width: 600px; /* Constrain width for search inputs */
                }
                .nav-links {
                    margin-left: 1rem; /* Add some space if nav links are after search */
                }
                .auth-buttons {
                    margin-left: 1rem; /* Ensure space before auth buttons */
                }
                /* Hide toggle buttons on large screens */
                .nav-toggle, .search-filter-toggle {
                    display: none;
                }
            }


            @media (max-width: 992px) { /* Adjust for tablet/smaller desktop screens */
                .nav {
                    flex-wrap: wrap; /* Allow wrapping */
                    justify-content: flex-start; /* Start items from the left */
                }
                .logo {
                    margin-right: 1rem; /* Less margin */
                }
                .nav-center-content {
                    flex-basis: 100%; /* Take full width on this breakpoint */
                    order: 3; /* Push it to the next line */
                    margin-top: 1rem; /* Space from top elements */
                    justify-content: flex-start; /* Align search/nav links to start */
                    gap: 1rem;
                    flex-wrap: wrap; /* Allow its children to wrap */
                }
                .search-filter-container {
                    flex-basis: 100%; /* Take full width within nav-center-content */
                    flex-wrap: wrap; /* Allow inputs to wrap if needed */
                    max-width: unset; /* Remove max-width constraint */
                }
                .nav-links {
                    flex-basis: 100%; /* Take full width within nav-center-content */
                    margin-left: 0; /* Remove left margin */
                    margin-top: 1rem; /* Space from search inputs */
                    justify-content: flex-start; /* Align links to start */
                    flex-wrap: wrap; /* Allow individual links to wrap */
                }
                .auth-buttons {
                    margin-left: auto; /* Push to right */
                    order: 2; /* Position after toggles */
                }
                /* Show toggle buttons */
                .search-filter-toggle, .nav-toggle {
                    display: block;
                    order: 1; /* Position after logo */
                    margin-left: 0.5rem; /* Space between toggles */
                }
                .nav-toggle {
                    margin-left: auto; /* Push nav toggle to far right if space allows */
                }
                .user-greeting {
                    margin-right: 0;
                }
            }

            @media (max-width: 768px) { /* Mobile specific adjustments */
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
                    order: unset; /* Reset order */
                    flex-direction: column;
                    width: 100%;
                    margin-top: 0;
                    gap: 0;
                }
                .nav-links, .search-filter-container {
                    display: none; /* Hidden by default, toggled by JS */
                    flex-direction: column; /* Always vertical on mobile */
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
                    order: unset; /* Reset order */
                    margin-left: auto; /* Keep pushing to right */
                }
                 /* Ensure toggles are on the same line as logo */
                .nav > .search-filter-toggle { margin-left: auto; margin-right: 0.5rem; }
                .nav > .nav-toggle { margin-left: 0; }

                .auth-buttons {
                    order: unset; /* Reset order */
                    width: 100%;
                    justify-content: center;
                    margin-left: 0; /* Remove left margin */
                    margin-top: 1rem;
                }
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
                .popup-console {
                    display: none; /* mặc định ẩn */
                    position: fixed;
                    top: 0;
                    left: 0;
                    width: 100vw;
                    height: 100vh;
                    background-color: rgba(0,0,0,0.7);
                    z-index: 9999;
                    justify-content: center;
                    align-items: center;
                }

                .popup-content {
                    background: var(--card-bg);
                    padding: 2rem;
                    border-radius: 12px;
                    text-align: center;
                    box-shadow: 0 5px 30px rgba(0,0,0,0.5);
                    border: 1px solid var(--primary);
                    max-width: 400px;
                    width: 90%;
                }

                .popup-content h2 {
                    color: var(--primary);
                    margin-bottom: 1rem;
                }

                .popup-content p {
                    color: var(--text-light);
                    margin-bottom: 1.5rem;
                }

                .popup-content button {
                    padding: 0.5rem 1.5rem;
                    border: none;
                    background: var(--primary);
                    color: white;
                    border-radius: 25px;
                    cursor: pointer;
                    transition: background 0.3s;
                }

                .popup-content button:hover {
                    background: #5566dd;
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

            }
            /* Add styles for pagination controls */
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
                pointer-events: none; /* Make current page not clickable */
            }

            .pagination-controls .disabled {
                opacity: 0.5;
                pointer-events: none; /* Disable click */
            }
        </style>
    </head>
    <body>
        <%  
            // Retrieve user and events from session/request attributes
            User user = (User) session.getAttribute("user");
            List<Event> events = (List<Event>) request.getAttribute("events");
            SimpleDateFormat dateFormat = new SimpleDateFormat("EEE, dd/MM/yyyy HH:mm");

            // Pagination attributes
            Integer currentPageObj = (Integer) request.getAttribute("currentPage");
            Integer noOfPagesObj = (Integer) request.getAttribute("noOfPages");
            Integer totalEventsObj = (Integer) request.getAttribute("totalEvents");

            int currentPage = (currentPageObj != null) ? currentPageObj : 1;
            int noOfPages = (noOfPagesObj != null) ? noOfPagesObj : 1;
            int totalEvents = (totalEventsObj != null) ? totalEventsObj : 0;
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
                    <div class="search-filter-container" id="searchFilterContainer">
                        <input type="text" class="search-box" placeholder="Tìm sự kiện..." id="searchInput">
                        <input type="date" class="filter-input" id="dateInput" title="Tìm theo ngày">
                        <input type="text" class="filter-input" placeholder="Địa điểm..." id="locationInput">
                    </div>

                    <ul class="nav-links" id="navLinks">
                        <li><a href="${pageContext.request.contextPath}/home"><i class="fas fa-home"></i> Trang chủ</a></li>
                        <li><a href="#hot-events"><i class="fas fa-fire"></i> Sự kiện hot</a></li>
                        <li><a href="#vouchers"><i class="fas fa-tags"></i> Săn voucher</a></li>
                        <c:if test="${not empty sessionScope.user && sessionScope.user.roleID == 2}">
                             <li><a href="${pageContext.request.contextPath}/createEvent"><i class="fas fa-plus-circle"></i> Tạo sự kiện</a></li>
                        </c:if>
                        <li><a href="#contact"><i class="fas fa-question-circle"></i> Hỗ trợ</a></li>
                    </ul>
                </div>
                
                <div class="auth-buttons">
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <span class="user-greeting" onclick="toggleUserDropdown()">
                                Xin chào, ${sessionScope.user.email} <span style="margin-left: 0.5rem;">▼</span>
                            </span>
                            <div class="user-dropdown" id="userDropdown">
                                <a href="${pageContext.request.contextPath}/updateProfile" class="dropdown-item">👤 Thông tin cá nhân</a>
                                <a href="${pageContext.request.contextPath}/myTickets" class="dropdown-item">🎫 Vé đã mua</a>
                                <a href="${pageContext.request.contextPath}/favoriteEvents" class="dropdown-item">❤️ Sự kiện yêu thích</a>
                                <a href="${pageContext.request.contextPath}/settings" class="dropdown-item">⚙️ Cài đặt</a>
                                <hr style="border: none; border-top: 1px solid var(--border-color); margin: 0.5rem 0;">
                                <a href="${pageContext.request.contextPath}/logout" class="dropdown-item" style="color: var(--danger);">🚪 Đăng xuất</a>
                            </div>
                        </c:when>
                        <c:otherwise>
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

            <%  if (events == null || events.isEmpty()) {  %>
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
                <%  // The 'events' list from the servlet is already paginated for the current page.
                    for (Event event : events) {
                %>
                <div class="event-card searchable-event" 
                    data-event-id="<%= event.getEventID() %>"
                    data-event-name="<%= event.getName() != null ? event.getName().toLowerCase() : "" %>"
                    data-event-description="<%= event.getDescription() != null ? event.getDescription().toLowerCase() : "" %>"
                    data-event-start-time="<%= event.getStartTime() != null ? event.getStartTime().getTime() : "" %>"
                    data-event-location="<%= event.getPhysicalLocation() != null ? event.getPhysicalLocation().toLowerCase() : "" %>"
                    onclick="navigateToEventDetail(this.getAttribute('data-event-id'))">
                    <div class="event-image">
                        <% if (event.getImageURL() != null && !event.getImageURL().trim().isEmpty()) {%>
                        <img src="<%= event.getImageURL()%>" alt="<%= event.getName()%>" />
                        <% } else { %>
                        <span style="font-size: 50px; display: flex; justify-content: center; align-items: center; height: 100%; background-color: var(--card-bg);">🎫</span>
                        <% }%>
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
                        <div class="event-description" style="white-space: nowrap; overflow: hidden; text-overflow: ellipsis; max-width: 200px; max-height: 3.6em; line-height: 1.2em;">
                            <%= event.getDescription() != null ? event.getDescription() : ""%>
                        </div>
                        <div class="event-price">Từ 150,000 VNĐ</div>
                    </div>
                </div>
                <% }%>
            </div>

            <div class="pagination-controls">
                <a href="${pageContext.request.contextPath}/home?page=<%= currentPage - 1 %>" 
                   class="<%= (currentPage == 1) ? "disabled" : "" %>">Trước</a>
                
                <% 
                    // Display page numbers
                    int startPage = Math.max(1, currentPage - 2);
                    int endPage = Math.min(noOfPages, currentPage + 2);

                    if (startPage > 1) {
                        %><a href="${pageContext.request.contextPath}/home?page=1">1</a><%
                        if (startPage > 2) {
                            %><span>...</span><%
                        }
                    }

                    for (int i = startPage; i <= endPage; i++) {
                        if (i == currentPage) {
                            %><span class="current-page"><%= i %></span><%
                        } else {
                            %><a href="${pageContext.request.contextPath}/home?page=<%= i %>"><%= i %></a><%
                        }
                    }

                    if (endPage < noOfPages) {
                        if (endPage < noOfPages - 1) {
                            %><span>...</span><%
                        }
                        %><a href="${pageContext.request.contextPath}/home?page=<%= noOfPages %>"><%= noOfPages %></a><%
                    }
                %>
                
                <a href="${pageContext.request.contextPath}/home?page=<%= currentPage + 1 %>" 
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
            // Toggle for user dropdown
            function toggleUserDropdown() {
                const dropdown = document.getElementById("userDropdown");
                if (dropdown) {
                    dropdown.classList.toggle("show");
                }
            }

            // Close dropdown if click outside
            window.addEventListener("click", function (e) {
                const userGreeting = document.querySelector(".user-greeting");
                const dropdown = document.getElementById("userDropdown");

                if (userGreeting && dropdown && !userGreeting.contains(e.target) && !dropdown.contains(e.target)) {
                    dropdown.classList.remove("show");
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

            // Search and filter functionality
            function setupSearch() {
                const searchBox = document.getElementById('searchInput');
                const dateInput = document.getElementById('dateInput');
                const locationInput = document.getElementById('locationInput');
                const eventCards = document.querySelectorAll('.searchable-event');

                const applyFilters = () => {
                    const query = searchBox.value.toLowerCase();
                    const selectedDate = dateInput.value ? new Date(dateInput.value) : null;
                    const locationQuery = locationInput.value.toLowerCase();

                    eventCards.forEach(card => {
                        const eventName = card.getAttribute('data-event-name');
                        const eventDescription = card.getAttribute('data-event-description');
                        const eventLocation = card.getAttribute('data-event-location'); 
                        const eventStartTime = card.getAttribute('data-event-start-time'); 
                        
                        let isVisible = true;

                        // Filter by text query (name, description, location)
                        if (query) {
                            if (!eventName.includes(query) && !eventDescription.includes(query) && !eventLocation.includes(query)) {
                                isVisible = false;
                            }
                        }
                        
                        // Filter by location input (already included in general query, but kept for explicit filter)
                        if (locationQuery) { 
                            if (!eventLocation || !eventLocation.includes(locationQuery)) {
                                isVisible = false;
                            }
                        }

                        // Filter by selected date (match year, month, day)
                        if (selectedDate && eventStartTime) {
                            const eventDate = new Date(parseInt(eventStartTime));
                            if (eventDate.getFullYear() !== selectedDate.getFullYear() ||
                                eventDate.getMonth() !== selectedDate.getMonth() ||
                                eventDate.getDate() !== selectedDate.getDate()) {
                                isVisible = false;
                            }
                        }

                        card.style.display = isVisible ? 'block' : 'none';
                    });
                };

                searchBox.addEventListener('input', applyFilters);
                dateInput.addEventListener('change', applyFilters);
                locationInput.addEventListener('input', applyFilters);
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

            // Initialize page
            document.addEventListener('DOMContentLoaded', () => {
                setupSearch();
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

        </script>
        <% if (session.getAttribute("flashMessage_success") != null) { %>
        <script>
            document.addEventListener("DOMContentLoaded", function () {
                const popup = document.getElementById("successPopup");
                if (popup) {
                    popup.style.display = "flex";
                    // Tự động ẩn sau 5s
                    setTimeout(() => {
                        popup.style.display = "none";
                    }, 5000);
                }
            });
        </script>
        <%
            // Xóa session attribute để không hiển thị lại sau reload
            session.removeAttribute("flashMessage_success");
        %>
        <% }%>

        <% if (session.getAttribute("flashMessage_success") != null) { %>
        <script>
            document.addEventListener("DOMContentLoaded", function () {
                const popup = document.getElementById("successPopup");
                if (popup) {
                    popup.style.display = "flex";
                    // Tự động ẩn sau 5s
                    setTimeout(() => {
                        popup.style.display = "none";
                    }, 5000);
                }
            });
        </script>
        <%
            // ✅ Sau khi hiển thị, xóa flash message để không hiện lại khi reload
            session.removeAttribute("flashMessage_success");
        %>
        <% }%>
    </body>
</html>