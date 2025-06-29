<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>MasterTicket - Chọn ghế cho: ${event.name}</title>
        <style>
            body {
                margin: 0;
                background: radial-gradient(ellipse at left, #0a1836 60%, #2a1a3a 100%);
                font-family: 'Segoe UI', Arial, sans-serif;
                color: #fff;
                padding: 20px;
            }
            .header {
                display: flex;
                align-items: center;
                justify-content: space-between;
                padding: 24px 20px 16px 20px;
            }
            .header-left {
                font-size: 2rem;
                font-weight: bold;
            }
            .header-right {
                display: flex;
                align-items: center;
                gap: 18px;
            }
            .header-right button, .header-right .account {
                background: #23263a;
                color: #fff;
                border: 1px solid #5e5e7a;
                border-radius: 8px;
                padding: 8px 18px;
                font-size: 1rem;
                cursor: pointer;
            }

            .main-content {
                display: flex;
                justify-content: center;
                align-items: flex-start;
                gap: 32px;
                margin-top: 10px;
            }
            .left-panel {
                flex: 3;
            }
            .right-panel {
                flex: 1;
                background: #23263a;
                border-radius: 24px;
                padding: 32px;
                min-width: 320px;
                max-width: 350px;
                box-shadow: 0 8px 32px 0 rgba(0,0,0,0.25);
                position: sticky;
                top: 20px;
            }

            .seating-area {
                background: #181c2f;
                border-radius: 32px;
                padding: 32px;
                box-shadow: 0 8px 32px 0 rgba(0,0,0,0.25);
                min-height: 200px;
            }
            .stage {
                margin: 0 auto 24px auto;
                width: 60%;
                background: #eee;
                color: #222;
                text-align: center;
                border-radius: 5px;
                padding: 10px 0;
                font-weight: bold;
                font-size: 1.2em;
            }
            .legend {
                display: flex;
                gap: 24px;
                margin: 18px auto;
                justify-content: center;
            }
            .legend-item {
                display: flex;
                align-items: center;
                gap: 8px;
            }
            .legend-dot {
                width: 16px;
                height: 16px;
                border-radius: 4px;
            }
            .legend-dot.available {
                background: #fff;
            }
            .legend-dot.choosing {
                background: #1ed090;
            }
            .legend-dot.sold {
                background: #e74c3c;
            }

            .seats-container {
                display: flex;
                flex-direction: column;
                align-items: center;
                gap: 20px;
            }
            .section-title {
                font-size: 1.1em;
                color: #1ed090;
                text-align: center;
                margin-bottom: 15px;
                width: 100%;
                border-bottom: 1px solid #393e5c;
                padding-bottom: 8px;
            }
            .row {
                display: flex;
                gap: 10px;
                justify-content: center;
            }
            .seat {
                width: 22px;
                height: 22px;
                border-radius: 6px;
                border: 2px solid #ccc;
                background: #fff;
                cursor: pointer;
                transition: all 0.2s;
            }
            .seat.sold, .seat.reserved {
                background: #e74c3c;
                border-color: #e74c3c;
                cursor: not-allowed;
            }
            .seat.choosing {
                background: #1ed090;
                border-color: #1ed090;
                transform: scale(1.1);
            }

            .event-title {
                font-size: 1.25rem;
                font-weight: bold;
                margin-bottom: 18px;
            }
            .event-info {
                display: flex;
                align-items: center;
                gap: 10px;
                margin-bottom: 8px;
                color: #bdbdbd;
            }
            .selected-tickets {
                margin: 24px 0 18px 0;
            }
            .section-header {
                font-weight: bold;
                margin-bottom: 12px;
            }
            #selected-seats-info {
                min-height: 50px;
                transition: all 0.3s;
            }
            .continue-btn {
                width: 100%;
                background: #393e5c;
                color: #888;
                border: none;
                border-radius: 12px;
                padding: 16px 0;
                font-size: 1.1rem;
                margin-top: 32px;
                cursor: not-allowed;
                text-align: center;
                transition: all 0.2s;
            }
            .continue-btn.active {
                background: #1ed090;
                color: #fff;
                cursor: pointer;
            }
            .no-seats-message {
                color: #888;
                text-align: center;
                padding: 50px 20px;
                font-size: 1.2em;
            }
        </style>
    </head>
    <body>
        <div class="header">
            <div class="header-left">MasterTicket</div>
            <div class="header-right">
                <div class="account">${sessionScope.user.email}</div>
            </div>
        </div>

        <div class="main-content">
            <div class="left-panel">
                <div class="legend">
                    <div class="legend-item"><div class="legend-dot available"></div>Available</div>
                    <div class="legend-item"><div class="legend-dot choosing"></div>Choosing</div>
                    <div class="legend-item"><div class="legend-dot sold"></div>Sold</div>
                </div>
                <div class="seating-area">
                    <div class="stage">SÂN KHẤU</div>
                    <div class="seats-container" id="seats-container">
                        <%-- JavaScript sẽ vẽ ghế vào đây --%>
                    </div>
                </div>
            </div>
            <div class="right-panel">
                <div class="event-title">${event.name}</div>
                <div class="event-info"><i>🕒</i> <span><fmt:formatDate value="${event.startTime}" pattern="HH:mm, EEE, dd/MM/yyyy"/></span></div>
                <div class="event-info"><i>📍</i> <span>${event.physicalLocation}</span></div>

                <div class="selected-tickets">
                    <div class="section-header">Ghế đã chọn</div>
                    <div id="selected-seats-info">
                        <p>Vui lòng chọn ghế của bạn.</p>
                    </div>
                </div>

                <button class="continue-btn" id="continueBtn" onclick="processSelection()">Tiếp tục &gt;&gt;</button>
            </div>
        </div>

        <script>
            const seatsBySection = ${seatsJson};
            const eventData = ${eventJson};

            const seatsContainer = document.getElementById('seats-container');
            let selectedSeats = [];

            if (seatsContainer && Object.keys(seatsBySection).length > 0) {
                for (const sectionName in seatsBySection) {
                    if (seatsBySection.hasOwnProperty(sectionName)) {
                        const sectionDiv = document.createElement('div');
                        const title = document.createElement('h4');
                        title.className = 'section-title';
                        title.textContent = `Khu vực: ${sectionName == 'null' ? 'Khác' : sectionName}`;
                        sectionDiv.appendChild(title);

                        const seatingChart = document.createElement('div');
                        seatingChart.className = 'seating-chart';

                        let seatsByRow = {};
                        seatsBySection[sectionName].forEach(seat => {
                            const rowKey = seat.seatRow || 'General';
                            if (!seatsByRow[rowKey])
                                seatsByRow[rowKey] = [];
                            seatsByRow[rowKey].push(seat);
                        });

                        for (const rowName in seatsByRow) {
                            if (seatsByRow.hasOwnProperty(rowName)) {
                                const rowDiv = document.createElement('div');
                                rowDiv.className = 'row';
                                seatsByRow[rowName].forEach(seatData => {
                                    const seat = document.createElement('div');
                                    seat.className = `seat ${seatData.seatStatus.toLowerCase()}`;
                                    seat.dataset.seatId = seatData.seatID;
                                    seat.dataset.seatLabel = (seatData.seatRow || '') + seatData.seatNumber;

                                    if (seatData.seatStatus.toLowerCase() === 'available') {
                                        seat.onclick = () => handleSeatClick(seat, seatData);
                                    }
                                    rowDiv.appendChild(seat);
                                });
                                seatingChart.appendChild(rowDiv);
                            }
                        }
                        sectionDiv.appendChild(seatingChart);
                        seatsContainer.appendChild(sectionDiv);
                    }
                }
            } else {
                seatsContainer.innerHTML = "<p class='no-seats-message'>Sự kiện này hiện chưa có sơ đồ ghế hoặc đã bán hết vé.</p>";
            }

            function handleSeatClick(seatElement, seatData) {
                seatElement.classList.toggle('choosing');

                const seatId = seatData.seatID;
                const isSelected = seatElement.classList.contains('choosing');

                if (isSelected) {
                    selectedSeats.push(seatData); // Thêm đối tượng ghế
                } else {
                    selectedSeats = selectedSeats.filter(s => s.seatID !== seatId); // Bỏ ghế khỏi mảng
                }
                updateSummary(); // Gọi hàm cập nhật
            }

            // [FIXED] Sửa lại hàm này để chỉ đọc từ mảng selectedSeats
            function updateSummary() {
                const selectedSeatsInfo = document.getElementById('selected-seats-info');
                const continueBtn = document.getElementById('continueBtn');

                if (selectedSeats.length > 0) {
                    let summaryHtml = '<ul>';
                    selectedSeats.forEach(seat => {
                        summaryHtml += `<li>Ghế ${seat.seatRow}${seat.seatNumber} (Khu vực: <strong>${seat.seatSection}</strong>)</li>`;
                    });
                    summaryHtml += '</ul>';
                    selectedSeatsInfo.innerHTML = summaryHtml;
                    continueBtn.classList.add('active');
                } else {
                    selectedSeatsInfo.innerHTML = '<p>Vui lòng chọn ghế của bạn.</p>';
                    continueBtn.classList.remove('active');
                }
            }

            // [NEW] Hàm xử lý khi nhấn "Tiếp tục"
            function proceedToPayment() {
                if (selectedSeats.length === 0) {
                    alert('Vui lòng chọn ít nhất một ghế!');
                    return;
                }
                const seatIds = selectedSeats.map(s => s.seatID).join(',');

                // Chuyển hướng đến servlet Payment mới để xác nhận đơn hàng
                window.location.href = '${pageContext.request.contextPath}/payment?eventId=' + eventData.eventID + '&seatIds=' + seatIds;
            }

            // Gán lại sự kiện click cho nút
            document.getElementById('continueBtn').onclick = proceedToPayment;
        </script>
    </body>
</html>