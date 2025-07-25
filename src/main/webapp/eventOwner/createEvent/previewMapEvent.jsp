<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Xem trước Sơ đồ Ghế</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      display: flex;
      flex-direction: column;
      align-items: center;
      margin: 0;
      padding: 20px;
      background-color: #f4f4f4;
    }
    .container {
      display: flex;
      width: 100%;
      max-width: 1200px;
      gap: 20px;
    }
    .info {
      flex: 1;
      background: #fff;
      padding: 20px;
      border-radius: 8px;
      box-shadow: 0 0 10px rgba(0,0,0,0.1);
    }
    .canvas-container {
      flex: 2;
      background: #fff;
      padding: 20px;
      border-radius: 8px;
      box-shadow: 0 0 10px rgba(0,0,0,0.1);
    }
    canvas {
      border: 1px solid #ccc;
      width: 100%;
      height: 500px;
      cursor: pointer;
    }
    select, button {
      width: 100%;
      padding: 10px;
      margin: 10px 0;
      border: 1px solid #ccc;
      border-radius: 4px;
    }
    button {
      border: none;
      cursor: pointer;
      background-color: #28a745;
      color: white;
    }
    button:hover {
      background-color: #218838;
    }
    button.back {
      background-color: #007bff;
    }
    button.back:hover {
      background-color: #0056b3;
    }
    .zone-details {
      margin-top: 15px;
      padding: 10px;
      border: 1px solid #ccc;
      border-radius: 4px;
      display: none;
    }
    .error {
      color: red;
      margin: 10px 0;
    }
  </style>
</head>
<body>
  <h1>Xem trước Sơ đồ Ghế</h1>
  <c:if test="${not empty errorMessage}">
    <div class="error">${errorMessage}</div>
  </c:if>
  <div class="container">
    <div class="info">
      <h3>Thông tin Zone</h3>
      <select id="zoneSelect" onchange="displayZoneDetails()">
        <option value="-1">Chọn Zone</option>
        <c:forEach var="zone" items="${zones}">
          <option value="${zone.id}">${zone.name} (${zone.shape}, ${zone.totalSeats} ghế, ${zone.ticketPrice} VND)</option>
        </c:forEach>
      </select>
      <div id="zoneDetails" class="zone-details">
        <p><strong>Tên:</strong> <span id="zoneName"></span></p>
        <p><strong>Hình dạng:</strong> <span id="zoneShape"></span></p>
        <p><strong>Màu sắc:</strong> <span id="zoneColor"></span></p>
        <p><strong>Số hàng:</strong> <span id="zoneRows"></span></p>
        <p><strong>Ghế mỗi hàng:</strong> <span id="zoneSeatsPerRow"></span></p>
        <p><strong>Tổng số ghế:</strong> <span id="zoneTotalSeats"></span></p>
        <p><strong>Giá vé:</strong> <span id="zoneTicketPrice"></span> VND</p>
      </div>
      <button onclick="confirmLayout()">Xác nhận sơ đồ</button>
      <button class="back" onclick="window.location.href='${pageContext.request.contextPath}/organizer-servlet?action=createMap'">Chỉnh sửa sơ đồ</button>
    </div>
    <div class="canvas-container">
      <canvas id="canvas"></canvas>
    </div>
  </div>
  <form id="seatMapForm" action="${pageContext.request.contextPath}/organizer-servlet?action=previewMap" method="post" style="display: none;">
    <input type="hidden" name="action" value="previewMap">
    <input type="hidden" name="seatMapData" id="seatMapData">
  </form>
  <script>
    const canvas = document.getElementById('canvas');
    const ctx = canvas.getContext('2d');
    canvas.width = 800;
    canvas.height = 500;

    const zones = ${requestScope.seatMapData};
    const seats = [];
    let selectedZoneId = -1;

    // Generate seats for each zone (for submission, not display)
     zones.zones.forEach(zone => {
      const seatWidth = zone.shape === 'rectangle' ? 
        (Math.max(...zone.vertices.map(v => v.x)) - Math.min(...zone.vertices.map(v => v.x))) / zone.seatsPerRow :
        zone.radiusX * 2 / zone.seatsPerRow;
      const seatHeight = zone.shape === 'rectangle' ? 
        (Math.max(...zone.vertices.map(v => v.y)) - Math.min(...zone.vertices.map(v => v.y))) / zone.rows :
        zone.radiusY * 2 / zone.rows;

      for (let row = 0; row < zone.rows; row++) {
        for (let col = 0; col < zone.seatsPerRow; col++) {
          const seat = {
            zoneId: zone.id,
            label: `S${row + 1}-${col + 1}`,
            color: zone.color,
            price: zone.ticketPrice,
            x: zone.x + col * seatWidth + seatWidth / 2,
            y: zone.y + row * seatHeight + seatHeight / 2,
            relativeX: (col + 0.5) / zone.seatsPerRow,
            relativeY: (row + 0.5) / zone.rows,
            status: 'available'
          };
          seats.push(seat);
        }
      }
    });

    function drawCanvas() {
      ctx.clearRect(0, 0, canvas.width, canvas.height);
      zones.zones.forEach(zone => {
        ctx.fillStyle = zone.color;
        ctx.beginPath();
        if (zone.shape === 'rectangle') {
          ctx.moveTo(zone.x + zone.vertices[0].x, zone.y + zone.vertices[0].y);
          for (let i = 1; i < zone.vertices.length; i++) {
            ctx.lineTo(zone.x + zone.vertices[i].x, zone.y + zone.vertices[i].y);
          }
          ctx.closePath();
          ctx.fill();
        } else {
          ctx.ellipse(zone.x, zone.y, zone.radiusX, zone.radiusY, 0, 0, Math.PI * 2);
          ctx.fill();
        }
        ctx.fillStyle = '#000';
        ctx.textAlign = 'center';
        ctx.textBaseline = 'middle';
        ctx.fillText(zone.name, zone.x, zone.y);
        if (zone.id === selectedZoneId) {
          ctx.strokeStyle = '#000';
          ctx.lineWidth = 2;
          ctx.stroke();
        }
      });
    }

    function displayZoneDetails() {
      const select = document.getElementById('zoneSelect');
      const zoneId = parseInt(select.value);
      selectedZoneId = zoneId;
      const zoneDetails = document.getElementById('zoneDetails');
      if (zoneId === -1) {
        zoneDetails.style.display = 'none';
      } else {
        const zone = zones.zones.find(z => z.id === zoneId);
        if (zone) {
          document.getElementById('zoneName').textContent = zone.name;
          document.getElementById('zoneShape').textContent = zone.shape === 'rectangle' ? 'Hình chữ nhật' : 'Hình tròn';
          document.getElementById('zoneColor').innerHTML = `<span style="color: ${zone.color};">${zone.color}</span>`;
          document.getElementById('zoneRows').textContent = zone.rows;
          document.getElementById('zoneSeatsPerRow').textContent = zone.seatsPerRow;
          document.getElementById('zoneTotalSeats').textContent = zone.totalSeats;
          document.getElementById('zoneTicketPrice').textContent = zone.ticketPrice;
          textContent = zone.ticketPrice.toLocaleString('vi-VN');
          zoneDetails.style.display = 'block';
        }
      }
      drawCanvas();
    }

    function isPointInZone(x, y, zone) {
      if (zone.shape === 'rectangle') {
        let inside = false;
        const vertices = zone.vertices;
        for (let i = 0, j = vertices.length - 1; i < vertices.length; j = i++) {
          const xi = zone.x + vertices[i].x, yi = zone.y + vertices[i].y;
          const xj = zone.x + vertices[j].x, yj = zone.y + vertices[j].y;
          const intersect = ((yi > y) !== (yj > y)) && (x < (xj - xi) * (y - yi) / (yj - yi) + xi);
          if (intersect) inside = !inside;
        }
        return inside;
      } else {
        const dx = (x - zone.x) / zone.radiusX;
        const dy = (y - zone.y) / zone.radiusY;
        return dx * dx + dy * dy <= 1;
      }
    }

    canvas.addEventListener('click', (e) => {
      const rect = canvas.getBoundingClientRect();
      const x = e.clientX - rect.left;
      const y = e.clientY - rect.top;
      for (let i = zones.zones.length - 1; i >= 0; i--) {
        if (isPointInZone(x, y, zones.zones[i])) {
          selectedZoneId = zones.zones[i].id;
          document.getElementById('zoneSelect').value = selectedZoneId;
          displayZoneDetails();
          break;
        }
      }
    });

    function confirmLayout() {
      const seatMapData = JSON.stringify({ zones: zones.zones, seats: seats });
      console.log('Confirming seatMapData:', seatMapData);
      document.getElementById('seatMapData').value = seatMapData;
      document.getElementById('seatMapForm').submit();
    }

    drawCanvas();
  </script>
</body>
</html>