<%-- File: src/main/webapp/TicketDetail.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%-- Import các lớp Java bạn cần, lưu ý đúng package --%>
<%@ page import="java.util.List" %>
<%@ page import="Models.TicketInfor" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Ticketbox - Chọn vé</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <style>
            
            
            :root {
                --primary: #4a4aff;
                --secondary: #ff4da6;
                --dark-bg: #0f0f1a;
                --darker-bg: #000015;
                --card-bg: #1a1a2e;
                --text-light: #ffffff;
                --text-muted: #aaaaaa;
                --success: #00cc66;
                --warning: #ffcc00;
                --danger: #ff3333;
            }
            
            
            body {
                font-family: Arial, sans-serif;
                margin: 0;
                background-color: #1a1a1a; /* Dark background */
                color: #f0f0f0; /* Light text */
                display: flex;
                flex-direction: column;
                min-height: 100vh;
            }

            .header-container {
                display: flex;
                justify-content: center;
                background-color: var(--dark-bg);
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.3);
            }

            .header {
                max-width: 1300px;
                width: 100%;
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 15px 40px;
            }

            .logo {
                font-size: 24px;
                font-weight: bold;
                color: #4a4aff;
            }

            .search {
                display: flex;
                align-items: center;
            }

            .search input {
                padding: 10px 15px;
                border-radius: 25px;
                border: 1px solid #333344;
                width: 300px;
                background-color: #1a1a2e;
                color: white;
                font-size: 14px;
            }

            .search button {
                padding: 10px 15px;
                margin-left: 10px;
                background-color: var(--primary);
                border: none;
                border-radius: 25px;
                color: white;
                cursor: pointer;
                font-weight: bold;
                transition: all 0.2s;
            }

            .search button:hover {
                background-color: #3a3add;
            }

            .actions {
                display: flex;
                align-items: center;
                gap: 20px;
            }

            .primary-btn {
                background-color: var(--secondary);
                border: none;
                padding: 10px 20px;
                color: white;
                border-radius: 25px;
                cursor: pointer;
                font-weight: bold;
                transition: all 0.2s;
            }

            .primary-btn:hover {
                background-color: #e04496;
            }

            .link {
                color: var(--text-light);
                text-decoration: none;
                font-weight: 500;
                padding: 8px 12px;
                border-radius: 5px;
                transition: all 0.2s;
            }

            .link:hover {
                background-color: rgba(255, 255, 255, 0.1);
            }

            .account {
                background-color: #333344;
                padding: 8px 16px;
                border-radius: 25px;
                font-weight: 500;
                cursor: pointer;
                transition: all 0.2s;
            }

            .account:hover {
                background-color: #444455;
            }

            .container {
                display: flex;
                flex: 1;
            }

            .left-panel {
                width: 200px;
                background-color: #000; /* Black panel */
                padding: 30px;
            }

            .back-link {
                color: #28a745;
                text-decoration: none;
                font-size: 18px;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .main-content {
                flex: 1;
                background-color: #000; /* Black content area */
                padding: 30px;
                border-left: 1px solid #333;
                border-right: 1px solid #333;
            }

            .section-title {
                color: #28a745; /* Green title */
                margin-bottom: 30px;
                font-size: 24px;
            }

            .ticket-selection {
                border-bottom: 1px solid #333;
                padding-bottom: 20px;
                margin-bottom: 20px;
            }

            .ticket-header {
                display: flex;
                justify-content: space-between;
                padding-bottom: 15px;
                border-bottom: 1px solid #333;
                margin-bottom: 15px;
                color: #aaa;
                font-size: 14px;
                text-transform: uppercase;
            }

            .ticket-item {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 15px 0;
                border-bottom: 1px solid #333;
            }

            .ticket-item:last-child {
                border-bottom: none;
            }

            .ticket-info {
                display: flex;
                flex-direction: column;
            }

            .ticket-name {
                font-weight: bold;
                font-size: 18px;
                margin-bottom: 5px;
            }

            .ticket-price {
                color: #bbb;
            }

            .quantity-control {
                display: flex;
                align-items: center;
                gap: 5px;
            }

            .quantity-btn {
                background-color: #28a745; /* Green buttons */
                color: white;
                border: none;
                border-radius: 50%;
                width: 30px;
                height: 30px;
                font-size: 20px;
                display: flex;
                justify-content: center;
                align-items: center;
                cursor: pointer;
                transition: background-color 0.2s;
            }

            .quantity-btn:hover {
                background-color: #218838;
            }

            .quantity-input {
                background-color: #333;
                color: white;
                border: 1px solid #555;
                border-radius: 5px;
                width: 40px;
                text-align: center;
                padding: 5px 0;
                font-size: 16px;
            }

            .right-panel {
                width: 350px;
                background-color: #222; /* Darker grey panel */
                padding: 30px;
                display: flex;
                flex-direction: column;
            }

            .event-details {
                margin-bottom: 30px;
                padding-bottom: 20px;
                border-bottom: 1px solid #444;
            }

            .event-details h3 {
                color: white;
                font-size: 20px;
                margin-bottom: 10px;
                line-height: 1.3;
            }

            .event-details p {
                color: #aaa;
                margin-bottom: 5px;
                font-size: 14px;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .event-details p i {
                color: #28a745; /* Green icons */
            }

            .price-summary h4 {
                color: #28a745;
                margin-bottom: 15px;
                font-size: 18px;
            }

            .summary-item {
                display: flex;
                justify-content: space-between;
                margin-bottom: 10px;
            }

            .summary-item .summary-ticket-name {
                color: #f0f0f0;
            }

            .summary-item .summary-ticket-price {
                color: #f0f0f0;
                font-weight: bold;
            }

            .continue-button {
                background-color: #28a745;
                color: white;
                border: none;
                padding: 15px 20px;
                border-radius: 5px;
                font-size: 18px;
                cursor: pointer;
                margin-top: auto; /* Pushes button to the bottom */
                transition: background-color 0.2s;
            }

            .continue-button:hover:not(:disabled) {
                background-color: #218838;
            }

            .continue-button:disabled {
                background-color: #555;
                cursor: not-allowed;
                color: #bbb;
            }
        </style>
    </head>
    <body>
        <div class="header-container">
            <header class="header">
                <div class="logo">MasterTicket</div>                
                <div class="actions">                    
                    <a href="#" class="link">Purchased Tickets</a>
                    <div class="account">Account</div>
                </div>
            </header>
        </div>

        <div class="container">
            <aside class="left-panel">
                <a href="#" class="back-link"><i class="fas fa-arrow-left"></i> Trở về</a>
            </aside>

            <main class="main-content">
                <h2 class="section-title">Chọn vé</h2>

                <div class="ticket-selection">
                    <div class="ticket-header">
                        <span class="ticket-type-label">Loại vé</span>
                        <span class="ticket-quantity-label">Số lượng</span>
                    </div>

                    <div class="ticket-item" data-price="2350000" data-name="Katy Katy">
                        <div class="ticket-info">
                            <span class="ticket-name">Katy Katy</span>
                            <span class="ticket-price">2.350.000 đ</span>
                        </div>
                        <div class="quantity-control">
                            <button class="quantity-btn decrease">-</button>
                            <input type="text" class="quantity-input" value="0" readonly>
                            <button class="quantity-btn increase">+</button>
                        </div>
                    </div>
                    <div class="ticket-item" data-price="1950000" data-name="Gót Hồng">
                        <div class="ticket-info">
                            <span class="ticket-name">Gót Hồng</span>
                            <span class="ticket-price">1.950.000 đ</span>
                        </div>
                        <div class="quantity-control">
                            <button class="quantity-btn decrease">-</button>
                            <input type="text" class="quantity-input" value="0" readonly>
                            <button class="quantity-btn increase">+</button>
                        </div>
                    </div>

                    <div class="ticket-item" data-price="1650000" data-name="Mãi Mãi">
                        <div class="ticket-info">
                            <span class="ticket-name">Mãi Mãi</span>
                            <span class="ticket-price">1.650.000 đ</span>
                        </div>
                        <div class="quantity-control">
                            <button class="quantity-btn decrease">-</button>
                            <input type="text" class="quantity-input" value="0" readonly>
                            <button class="quantity-btn increase">+</button>
                        </div>
                    </div>

                    <div class="ticket-item" data-price="1350000" data-name="Nhớ Em">
                        <div class="ticket-info">
                            <span class="ticket-name">Nhớ Em</span>
                            <span class="ticket-price">1.350.000 đ</span>
                        </div>
                        <div class="quantity-control">
                            <button class="quantity-btn decrease">-</button>
                            <input type="text" class="quantity-input" value="0" readonly>
                            <button class="quantity-btn increase">+</button>
                        </div>
                    </div>

                    <div class="ticket-item" data-price="750000" data-name="Tình Phai">
                        <div class="ticket-info">
                            <span class="ticket-name">Tình Phai</span>
                            <span class="ticket-price">750.000 đ</span>
                        </div>
                        <div class="quantity-control">
                            <button class="quantity-btn decrease">-</button>
                            <input type="text" class="quantity-input" value="0" readonly>
                            <button class="quantity-btn increase">+</button>
                        </div>
                    </div>
                </div>
            </main>

            <aside class="right-panel">
                <div class="event-details">
                    <h3>THE WHISPER #2 | "TÌNH ĐƠN PHƯỢNG" - LAM TRƯỜNG</h3>
                    <p><i class="fas fa-calendar-alt"></i> 20:00, 19 tháng 7, 2025</p>
                    <p><i class="fas fa-map-marker-alt"></i> Sài Gòn</p>
                </div>

                <div class="price-summary">
                    <h4>Giá vé</h4>
                    <div id="selected-tickets-summary">
                        <div class="summary-item" data-name="Katy Katy" data-price="2350000">
                            <span class="summary-ticket-name">Katy Katy</span>
                            <span class="summary-ticket-price">2.350.000 đ</span>
                        </div>
                        <div class="summary-item" data-name="Gót Hồng" data-price="1950000">
                            <span class="summary-ticket-name">Gót Hồng</span>
                            <span class="summary-ticket-price">1.950.000 đ</span>
                        </div>
                        <div class="summary-item" data-name="Mãi Mãi" data-price="1650000">
                            <span class="summary-ticket-name">Mãi Mãi</span>
                            <span class="summary-ticket-price">1.650.000 đ</span>
                        </div>
                        <div class="summary-item" data-name="Nhớ Em" data-price="1350000">
                            <span class="summary-ticket-name">Nhớ Em</span>
                            <span class="summary-ticket-price">1.350.000 đ</span>
                        </div>
                        <div class="summary-item" data-name="Tình Phai" data-price="750000">
                            <span class="summary-ticket-name">Tình Phai</span>
                            <span class="summary-ticket-price">750.000 đ</span>
                        </div>
                    </div>
                </div>

                <button class="continue-button" disabled>Vui lòng chọn vé</button>
            </aside>
        </div>

        <script>
            document.addEventListener('DOMContentLoaded', () => {
                const quantityControls = document.querySelectorAll('.quantity-control');
                const continueButton = document.querySelector('.continue-button');
                const selectedTicketsSummary = document.getElementById('selected-tickets-summary');

                let selectedTickets = new Map(); // Map to store selected ticket name and quantity

                // Initialize summary with all tickets, but set price to 0 initially
                document.querySelectorAll('.summary-item').forEach(item => {
                    const name = item.dataset.name;
                    const priceElement = item.querySelector('.summary-ticket-price');
                    priceElement.textContent = '0 đ'; // Set initial price to 0
                });

                function formatCurrency(amount) {
                    return new Intl.NumberFormat('vi-VN', {style: 'currency', currency: 'VND'}).format(amount);
                }

                function updateSummary() {
                    let totalSelectedQuantity = 0;

                    // Reset all summary items to 0 or hide if not selected
                    document.querySelectorAll('.summary-item').forEach(item => {
                        const name = item.dataset.name;
                        const priceElement = item.querySelector('.summary-ticket-price');
                        const quantity = selectedTickets.has(name) ? selectedTickets.get(name) : 0;
                        const originalPricePerTicket = parseFloat(item.dataset.price);

                        if (quantity > 0) {
                            const totalPriceForTicketType = quantity * originalPricePerTicket;
                            priceElement.textContent = formatCurrency(totalPriceForTicketType);
                            item.style.display = 'flex'; // Show the item
                        } else {
                            priceElement.textContent = '0 đ';
                            // item.style.display = 'none'; // Optionally hide if quantity is 0
                        }
                    });

                    // Check if any tickets are selected
                    selectedTickets.forEach(quantity => {
                        totalSelectedQuantity += quantity;
                    });

                    if (totalSelectedQuantity > 0) {
                        continueButton.disabled = false;
                        continueButton.textContent = 'Tiếp tục';
                    } else {
                        continueButton.disabled = true;
                        continueButton.textContent = 'Vui lòng chọn vé';
                    }
                }

                quantityControls.forEach(control => {
                    const decreaseBtn = control.querySelector('.decrease');
                    const increaseBtn = control.querySelector('.increase');
                    const quantityInput = control.querySelector('.quantity-input');
                    const ticketItem = control.closest('.ticket-item');
                    const ticketName = ticketItem.dataset.name;

                    decreaseBtn.addEventListener('click', () => {
                        let currentValue = parseInt(quantityInput.value);
                        if (currentValue > 0) {
                            currentValue--;
                            quantityInput.value = currentValue;
                            selectedTickets.set(ticketName, currentValue);
                            updateSummary();
                        }
                    });

                    increaseBtn.addEventListener('click', () => {
                        let currentValue = parseInt(quantityInput.value);
                        currentValue++;
                        quantityInput.value = currentValue;
                        selectedTickets.set(ticketName, currentValue);
                        updateSummary();
                    });
                });

                // Initial update to set button state and summary
                updateSummary();
            });
        </script>
    </body>
</html>