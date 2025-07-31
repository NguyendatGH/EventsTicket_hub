<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>EventTicketHub - Chọn ghế cho: ${event.name}</title>
                <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
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
            .back-button-container {
                position: relative;
                max-width: 1400px;
                margin: 0 auto;
                padding: 0 2rem;
            }
            .back-button {
                position: absolute;
                left: -16rem;
                background: var(--glass-bg);
                backdrop-filter: blur(20px);
                border: 1px solid var(--border-color);
                color: var(--text-light);
                text-decoration: none;
                padding: 0.75rem 1.5rem;
                border-radius: 50px;
                font-size: 0.95rem;
                font-weight: 500;
                display: flex;
                align-items: center;
                gap: 0.75rem;
                transition: all 0.3s ease;
                z-index: 10;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
                animation: backButtonSlideIn 0.6s ease 0.5s both;
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
        <div class="main-content">
        <div class="back-button-container">
            <a href="javascript:history.back()" class="back-button" title="Quay lại trang trước">
                <i class="fas fa-arrow-left"></i>
                <span>Quay lại</span>
            </a>
        </div>
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
            let selectedZoneId = null; // Lưu ID của zone được chọn
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

            function isPointInPolygon(x, y, vertices, scale, zoneX, zoneY) {
                let inside = false;
                for (let i = 0, j = vertices.length - 1; i < vertices.length; j = i++) {
                    const xi = (vertices[i].x || 0) * scale + zoneX;
                    const yi = (vertices[i].y || 0) * scale + zoneY;
                    const xj = (vertices[j].x || 0) * scale + zoneX;
                    const yj = (vertices[j].y || 0) * scale + zoneY;
                    const intersect = ((yi > y) !== (yj > y)) && (x < (xj - xi) * (y - yi) / (yj - yi) + xi);
                    if (intersect) inside = !inside;
                }
                return inside;
            }

            function isPointInCircle(x, y, centerX, centerY, radiusX, radiusY, scale) {
                const dx = x - centerX;
                const dy = y - centerY;
                return (dx * dx) / (radiusX * scale * radiusX * scale) + (dy * dy) / (radiusY * scale * radiusY * scale) <= 1;
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
                        ctx.save();
                        ctx.translate(offsetX + zone.x * scale, offsetY + zone.y * scale);
                        ctx.rotate((zone.rotation * Math.PI) / 180);

                        // Tạo gradient cho hiệu ứng nổi khi zone được chọn
                        if (selectedZoneId === zone.id) {
                            const gradient = ctx.createRadialGradient(0, 0, 0, 0, 0, (zone.radiusX || 50) * scale);
                            gradient.addColorStop(0, 'rgba(111, 215, 247, 0.81)'); // Màu vàng sáng ở trung tâm
                            gradient.addColorStop(1, zone.color || '#000'); // Chuyển về màu gốc ở viền
                            ctx.fillStyle = gradient;
                        } else {
                            ctx.fillStyle = zone.color;
                        }
                        ctx.strokeStyle = selectedZoneId === zone.id ? '#ff0' : '#000000'; // Viền đen khi chọn
                        ctx.lineWidth = selectedZoneId === zone.id ? 3 : 1;

                        if (zone.shape === 'polygon' && Array.isArray(zone.vertices) && zone.vertices.length >= 3) {
                            console.log('[DEBUG-JS] Drawing polygon zone with vertices:', JSON.stringify(zone.vertices));
                            ctx.beginPath();
                            const firstVertex = zone.vertices[0];
                            ctx.moveTo((firstVertex.x || 0) * scale, (firstVertex.y || 0) * scale);
                            for (let i = 1; i < zone.vertices.length; i++) {
                                ctx.lineTo((zone.vertices[i].x || 0) * scale, (zone.vertices[i].y || 0) * scale);
                            }
                            ctx.closePath();
                            ctx.fill();
                            ctx.stroke();
                        } else if (zone.shape === 'rectangle' && Array.isArray(zone.vertices) && zone.vertices.length >= 3) {
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
                const zoneId = parseInt(zoneSelect.value) || selectedZoneId; // Sử dụng zoneId từ dropdown hoặc click
                const quantity = parseInt(seatQuantityInput.value) || 1;

                if (!zoneId || quantity <= 0) {
                    selectedSeats = [];
                    selectedSeatsInfo.innerHTML = '<p>Vui lòng chọn khu vực và số lượng ghế.</p>';
                    continueBtn.classList.remove('active');
                    continueBtn.onclick = null;
                    return;
                }

                const availableSeats = seats.filter(seat => seat.zoneId === zoneId && seat.status === 'available');
                availableSeats.sort((a, b) => a.seatId - b.seatId);
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
                drawEventMap(); // Cập nhật bản đồ để phản ánh zone được chọn
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

            // Thêm event listener cho click trên canvas
            canvas.addEventListener('click', (event) => {
                const rect = canvas.getBoundingClientRect(); // Sửa typo: getBoundingRect -> getBoundingClientRect
                const bounds = calculateBounds();
                const scale = Math.min(canvas.width / (bounds.maxX - bounds.minX || 1), canvas.height / (bounds.maxY - bounds.minY || 1)) * 0.9;
                const offsetX = (canvas.width - (bounds.maxX - bounds.minX) * scale) / 2 - bounds.minX * scale;
                const offsetY = (canvas.height - (bounds.maxY - bounds.minY) * scale) / 2 - bounds.minY * scale;
                const mouseX = (event.clientX - rect.left - offsetX) / scale;
                const mouseY = (event.clientY - rect.top - offsetY) / scale;

                let clickedZoneId = null;
                zones.forEach(zone => {
                    ctx.save();
                    ctx.translate(zone.x, zone.y);
                    ctx.rotate((zone.rotation * Math.PI) / 180);
                    let isInside = false;
                    if (zone.shape === 'polygon' && Array.isArray(zone.vertices) && zone.vertices.length >= 3) {
                        isInside = isPointInPolygon(mouseX - zone.x, mouseY - zone.y, zone.vertices, scale, 0, 0);
                    } else if (zone.shape === 'rectangle' && Array.isArray(zone.vertices) && zone.vertices.length >= 3) {
                        isInside = isPointInPolygon(mouseX - zone.x, mouseY - zone.y, zone.vertices, scale, 0, 0);
                    } else if (zone.shape === 'circle') {
                        isInside = isPointInCircle(mouseX - zone.x, mouseY - zone.y, 0, 0, zone.radiusX || 50, zone.radiusY || 50, scale);
                    }
                    ctx.restore();
                    if (isInside) {
                        clickedZoneId = zone.id;
                    }
                });

                if (clickedZoneId !== null) {
                    selectedZoneId = clickedZoneId;
                    zoneSelect.value = selectedZoneId; // Cập nhật dropdown thành zone được chọn
                    assignSeats(); // Cập nhật ghế và giao diện
                }
                drawEventMap(); // Vẽ lại bản đồ với hiệu ứng nổi
            });

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