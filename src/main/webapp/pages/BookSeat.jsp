<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>EventTicketHub - Chọn ghế cho: ${event.name}</title>
        <style>
            body {
                margin: 0;
                background: radial-gradient(ellipse at left, #0a1836 60%, #2a1a3a 100%);
                font-family: 'Segoe UI', Arial, sans-serif;
                color: #fff;
                padding: 20px;
                min-height: 100vh;
                display: flex;
                flex-direction: column;
            }
            .header {
                display: flex;
                align-items: center;
                justify-content: space-between;
                padding: 20px;
                background: rgba(35, 38, 58, 0.8);
                border-radius: 12px;
                margin-bottom: 20px;
            }
            .header-left {
                font-size: 1.8rem;
                font-weight: 700;
            }
            .header-right {
                display: flex;
                align-items: center;
                gap: 16px;
            }
            .header-right .account {
                background: #2e3147;
                border: 1px solid #5e5e7a;
                border-radius: 8px;
                padding: 8px 16px;
                font-size: 0.95rem;
                cursor: pointer;
                transition: background 0.3s;
            }
            .header-right .account:hover {
                background: #3a3e5c;
            }
            .back-link {
                color: #1ed090;
                text-decoration: none;
                font-size: 1rem;
                margin-bottom: 20px;
                display: inline-block;
                transition: color 0.3s;
            }
            .back-link:hover {
                color: #26f0a0;
            }
            .main-content {
                display: flex;
                justify-content: center;
                align-items: flex-start;
                gap: 24px;
                flex-grow: 1;
                max-width: 1200px;
                margin: 0 auto;
            }
            .left-panel {
                flex: 2;
                display: flex;
                flex-direction: column;
                align-items: center;
            }
            .right-panel {
                flex: 1;
                background: #23263a;
                border-radius: 16px;
                padding: 24px;
                min-width: 280px;
                max-width: 340px;
                box-shadow: 0 4px 16px rgba(0, 0, 0, 0.3);
                position: sticky;
                top: 20px;
            }
            .seating-area {
                background: #181c2f;
                border-radius: 16px;
                padding: 24px;
                box-shadow: 0 4px 16px rgba(0, 0, 0, 0.3);
                width: 100%;
                max-width: 800px;
                display: flex;
                flex-direction: column;
                align-items: center;
            }
            .stage {
                width: 80%;
                max-width: 500px;
                background: #d1d5db;
                color: #1f2937;
                text-align: center;
                border-radius: 8px;
                padding: 12px 0;
                font-weight: 600;
                font-size: 1.1rem;
                margin-bottom: 20px;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.2);
            }
            .event-title {
                font-size: 1.3rem;
                font-weight: 700;
                margin-bottom: 16px;
            }
            .event-info {
                display: flex;
                align-items: center;
                gap: 8px;
                margin-bottom: 12px;
                color: #d1d5db;
                font-size: 0.95rem;
            }
            .selected-tickets {
                margin: 20px 0;
            }
            .section-header {
                font-weight: 600;
                font-size: 1rem;
                margin-bottom: 10px;
                color: #e5e7eb;
            }
            #available-seats-info, #selected-seats-info {
                min-height: 60px;
                color: #d1d5db;
                font-size: 0.9rem;
                line-height: 1.5;
                transition: all 0.3s;
            }
            .ticket-selection {
                margin: 20px 0;
            }
            #zoneSelect, #seatQuantity {
                border: 1px solid #5e5e7a;
                border-radius: 8px;
                background: #181c2f;
                color: #fff;
                width: 100%;
                padding: 10px;
                font-size: 0.95rem;
                margin-bottom: 12px;
                transition: border-color 0.3s;
            }
            #zoneSelect:focus, #seatQuantity:focus {
                border-color: #1ed090;
                outline: none;
            }
            .continue-btn {
                width: 100%;
                background: #393e5c;
                color: #888;
                border: none;
                border-radius: 10px;
                padding: 14px 0;
                font-size: 1rem;
                margin-top: 24px;
                cursor: not-allowed;
                text-align: center;
                transition: background 0.3s, color 0.3s;
            }
            .continue-btn.active {
                background: #1ed090;
                color: #fff;
                cursor: pointer;
            }
            .continue-btn.active:hover {
                background: #26f0a0;
            }
            #event-map {
                width: 100%;
                max-width: 800px;
                height: 500px;
                border: 1px solid #5e5e7a;
                border-radius: 8px;
                background: #1f2937;
            }
            @media (max-width: 768px) {
                .main-content {
                    flex-direction: column;
                    align-items: center;
                    gap: 16px;
                }
                .left-panel, .right-panel {
                    width: 100%;
                    max-width: none;
                }
                .seating-area {
                    padding: 16px;
                }
                .stage {
                    width: 90%;
                    font-size: 1rem;
                }
                #event-map {
                    height: 400px;
                }
            }
        </style>
    </head>
    <body>
        <div class="header">
            <div class="header-left">EventTicketHub</div>
            <div class="header-right">
                <div class="account">${sessionScope.user.email}</div>
            </div>
        </div>
        <a href="${pageContext.request.contextPath}/HomePageServlet" class="back-link">
                <i class="fas fa-arrow-left"></i> 
                Quay lại
            </a>
        <div class="main-content">
            <div class="left-panel">
                <div class="seating-area">
                    <div class="stage">SÂN KHẤU</div>
                    <canvas id="event-map"></canvas>
                </div>
            </div>
            <div class="right-panel">
                <div class="event-title">${event.name}</div>
                <div class="event-info"><i>🕒</i> <span><fmt:formatDate value="${event.startTime}" pattern="HH:mm, EEE, dd/MM/yyyy"/></span></div>
                <div class="event-info"><i>📍</i> <span>${event.physicalLocation}</span></div>
                <div class="selected-tickets">
                    <div class="section-header">Tổng số ghế trống theo khu vực</div>
                    <div id="available-seats-info">
                        <p>Đang tải danh sách ghế...</p>
                    </div>
                </div>
                <div class="ticket-selection">
                    <div class="section-header">Chọn khu vực</div>
                    <select id="zoneSelect">
                        <option value="">-- Chọn khu vực --</option>
                        <c:forEach var="zone" items="${zones}">
                            <option value="${zone.id}">${zone.name} (${zone.totalSeats} ghế)</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="ticket-selection">
                    <div class="section-header">Chọn số lượng ghế</div>
                    <input type="number" id="seatQuantity" min="1" value="1">
                </div>
                <div class="selected-tickets">
                    <div class="section-header">Ghế đã chọn</div>
                    <div id="selected-seats-info">
                        <p>Vui lòng chọn khu vực và số lượng ghế.</p>
                    </div>
                </div>
                <button class="continue-btn" id="continueBtn">Tiếp tục >></button>
            </div>
        </div>
        <script>
            console.log('[DEBUG-JS] Initializing BookSeatWithChart.jsp');
            const zones = ${zonesJson};
            const seats = ${seatsJson};
            const eventData = ${eventJson};
            console.log('[DEBUG-JS] Zones:', JSON.stringify(zones, null, 2));
            console.log('[DEBUG-JS] Seats:', JSON.stringify(seats, null, 2));
            console.log('[DEBUG-JS] Event Data:', JSON.stringify(eventData, null, 2));

            const canvas = document.getElementById('event-map');
            const ctx = canvas.getContext('2d');
            let selectedSeats = [];
            const availableSeatsInfo = document.getElementById('available-seats-info');
            const selectedSeatsInfo = document.getElementById('selected-seats-info');
            const continueBtn = document.getElementById('continueBtn');
            const zoneSelect = document.getElementById('zoneSelect');
            const seatQuantityInput = document.getElementById('seatQuantity');

            // Ensure canvas has explicit dimensions
            canvas.width = 800;
            canvas.height = 500;
            console.log('[DEBUG-JS] Canvas initialized with width:', canvas.width, 'height:', canvas.height);

            // Calculate scaling to fit zones within canvas
            function calculateBounds() {
                let minX = Infinity, maxX = -Infinity, minY = Infinity, maxY = -Infinity;
                zones.forEach(zone => {
                    if (zone.shape === 'rectangle' && Array.isArray(zone.vertices)) {
                        zone.vertices.forEach(v => {
                            const x = zone.x + (v.x || 0);
                            const y = zone.y + (v.y || 0);
                            minX = Math.min(minX, x);
                            maxX = Math.max(maxX, x);
                            minY = Math.min(minY, y);
                            maxY = Math.max(maxY, y);
                        });
                    } else if (zone.shape === 'circle') {
                        minX = Math.min(minX, zone.x - (zone.radiusX || 50));
                        maxX = Math.max(maxX, zone.x + (zone.radiusX || 50));
                        minY = Math.min(minY, zone.y - (zone.radiusY || 50));
                        maxY = Math.max(maxY, zone.y + (zone.radiusY || 50));
                    }
                });
                if (minX === Infinity || maxX === -Infinity) { minX = 0; maxX = canvas.width; }
                if (minY === Infinity || maxY === -Infinity) { minY = 0; maxY = canvas.height; }
                return { minX, maxX, minY, maxY };
            }

            function drawEventMap() {
                try {
                    console.log('[DEBUG-JS] Drawing event map');
                    ctx.clearRect(0, 0, canvas.width, canvas.height);

                    const bounds = calculateBounds();
                    console.log('[DEBUG-JS] Bounds:', JSON.stringify(bounds));
                    const width = bounds.maxX - bounds.minX;
                    const height = bounds.maxY - bounds.minY;
                    const scale = Math.min(canvas.width / (width || 1), canvas.height / (height || 1)) * 0.9;
                    const offsetX = (canvas.width - width * scale) / 2 - bounds.minX * scale;
                    const offsetY = (canvas.height - height * scale) / 2 - bounds.minY * scale;
                    console.log('[DEBUG-JS] Scale:', scale, 'OffsetX:', offsetX, 'OffsetY:', offsetY);

                    zones.forEach((zone, index) => {
                        console.log('[DEBUG-JS] Drawing zone:', zone.id, zone.name);
                        if (!zone.color || zone.x === undefined || zone.y === undefined) {
                            console.error('[ERROR-JS] Invalid zone data at index', index, ':', JSON.stringify(zone));
                            return;
                        }
                        ctx.fillStyle = zone.color;
                        ctx.strokeStyle = '#fff';
                        ctx.lineWidth = 1;
                        ctx.save();
                        ctx.translate(offsetX + zone.x * scale, offsetY + zone.y * scale);
                        ctx.rotate((zone.rotation * Math.PI) / 180);

                        if (zone.shape === 'rectangle' && Array.isArray(zone.vertices) && zone.vertices.length >= 3) {
                            console.log('[DEBUG-JS] Drawing rectangle zone with vertices:', JSON.stringify(zone.vertices));
                            ctx.beginPath();
                            ctx.moveTo((zone.vertices[0].x || 0) * scale, (zone.vertices[0].y || 0) * scale);
                            for (let i = 1; i < zone.vertices.length; i++) {
                                ctx.lineTo((zone.vertices[i].x || 0) * scale, (zone.vertices[i].y || 0) * scale);
                            }
                            ctx.closePath();
                            ctx.fill();
                            ctx.stroke();
                        } else if (zone.shape === 'circle') {
                            console.log('[DEBUG-JS] Drawing circle zone with radiusX:', zone.radiusX, 'radiusY:', zone.radiusY);
                            ctx.beginPath();
                            ctx.ellipse(0, 0, (zone.radiusX || 50) * scale, (zone.radiusY || 50) * scale, 0, 0, 2 * Math.PI);
                            ctx.fill();
                            ctx.stroke();
                        }
                        ctx.restore();

                        ctx.fillStyle = '#fff';
                        ctx.font = '14px Arial';
                        ctx.textAlign = 'center';
                        ctx.fillText(zone.name || 'Unnamed', offsetX + zone.x * scale, offsetY + zone.y * scale - 10);
                    });
                    console.log('[DEBUG-JS] Finished drawing event map');
                } catch (error) {
                    console.error('[ERROR-JS] Error in drawEventMap:', error);
                }
            }

            function updateAvailableSeats() {
                const availableSeatsByZone = {};
                seats.forEach(seat => {
                    if (seat.status === 'available') {
                        if (!availableSeatsByZone[seat.zoneId]) {
                            availableSeatsByZone[seat.zoneId] = 0;
                        }
                        availableSeatsByZone[seat.zoneId]++;
                    }
                });

                let html = '<ul>';
                zones.forEach(zone => {
                    const availableCount = availableSeatsByZone[zone.id] || 0;
                    if (availableCount > 0) {
                        html += `<li>${zone.name}: ${availableCount} ghế trống</li>`;
                    }
                });
                html += '</ul>';
                availableSeatsInfo.innerHTML = Object.keys(availableSeatsByZone).length > 0 ? html : '<p>Không còn ghế trống.</p>';
            }

            function assignSeats() {
                const zoneId = parseInt(zoneSelect.value);
                const quantity = parseInt(seatQuantityInput.value) || 1;

                if (!zoneId || quantity <= 0) {
                    selectedSeats = [];
                    selectedSeatsInfo.innerHTML = '<p>Vui lòng chọn khu vực và số lượng ghế.</p>';
                    continueBtn.classList.remove('active');
                    continueBtn.onclick = null;
                    return;
                }

                const availableSeats = seats.filter(seat => seat.zoneId === zoneId && seat.status === 'available');
                availableSeats.sort((a, b) => a.seatId - b.seatId); // Sắp xếp theo seatId tăng dần
                if (availableSeats.length >= quantity) {
                    selectedSeats = availableSeats.slice(0, quantity);
                    let summaryHtml = '<ul>';
                    selectedSeats.forEach(seat => {
                        const matchedZone = zones.find(z => z.id === seat.zoneId);
                        const zoneName = matchedZone ? matchedZone.name : 'Unknown';
                        summaryHtml += `<li>Ghế ${seat.seatId} (Khu vực: ${zoneName}, Giá: ${seat.seatPrice.toLocaleString('vi-VN')} VND)</li>`;
                    });
                    summaryHtml += '</ul>';
                    selectedSeatsInfo.innerHTML = summaryHtml;
                    continueBtn.classList.add('active');
                    continueBtn.onclick = proceedToPayment;
                } else {
                    selectedSeats = [];
                    const selectedZone = zones.find(z => z.id === zoneId);
                    const zoneName = selectedZone ? selectedZone.name : 'Unknown';
                    selectedSeatsInfo.innerHTML = `<p>Chỉ còn ${availableSeats.length} ghế trống trong khu vực ${zoneName}. Vui lòng chọn số lượng nhỏ hơn.</p>`;
                    continueBtn.classList.remove('active');
                    continueBtn.onclick = null;
                }
            }

            function proceedToPayment() {
                try {
                    if (selectedSeats.length === 0) {
                        console.log('[DEBUG-JS] No seats selected, showing alert');
                        alert('Vui lòng chọn khu vực và số lượng ghế!');
                        return;
                    }
                    const seatIds = selectedSeats.map(s => s.seatId).join(',');
                    console.log('[DEBUG-JS] Proceeding to payment with seatIds:', seatIds);
                    window.location.href = '${pageContext.request.contextPath}/SeatPaymentServlet?eventId=' + eventData.eventID + '&seatIds=' + seatIds;
                } catch (error) {
                    console.error('[ERROR-JS] Error in proceedToPayment:', error);
                }
            }

            // Initialize canvas and draw map
            try {
                console.log('[DEBUG-JS] Initializing page');
                drawEventMap();
                updateAvailableSeats(); // Hiển thị tổng số ghế trống theo zone

                // Thêm event listener cho zoneSelect và seatQuantity
                zoneSelect.addEventListener('change', assignSeats);
                seatQuantityInput.addEventListener('change', assignSeats);
                // Gọi assignSeats khi trang load với giá trị mặc định
                if (zones.length > 0) {
                    zoneSelect.value = zones[0].id; // Chọn zone đầu tiên mặc định
                    assignSeats();
                }
            } catch (error) {
                console.error('[ERROR-JS] Error during initialization:', error);
            }
        </script>
    </body>
</html>