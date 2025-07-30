
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Xem trước Sơ Đồ Ghế</title>
  <style>
    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
    }

    body {
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        background: linear-gradient(135deg, #122536 0%, #764ba2 100%);
        min-height: 100vh;
        color: #fff;
        display: flex;
        flex-direction: column;
        align-items: center;
        padding: 20px;
    }

    h1 {
        margin-bottom: 20px;
        background: linear-gradient(45deg, #4CAF50, #45a049);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
        text-align: center;
    }

    .container {
        display: flex;
        width: 100%;
        max-width: 1200px;
        gap: 20px;
        margin-top: 20px;
    }

    .info {
        flex: 1;
        background: rgba(255,255,255,0.1);
        backdrop-filter: blur(10px);
        padding: 20px;
        border-radius: 15px;
        border: 1px solid rgba(255,255,255,0.1);
    }

    .canvas-container {
        flex: 2;
        background: rgba(255,255,255,0.1);
        backdrop-filter: blur(10px);
        padding: 20px;
        border-radius: 15px;
        border: 1px solid rgba(255,255,255,0.1);
    }

    canvas {
        border: 1px solid rgba(255,255,255,0.2);
        width: 100%;
        height: 500px;
        cursor: pointer;
        background: rgba(0,0,0,0.3);
        border-radius: 10px;
    }

    select, button {
        width: 100%;
        padding: 12px;
        margin: 10px 0;
        border-radius: 8px;
        font-size: 14px;
        transition: all 0.3s;
    }

    select {
        background: rgba(255,255,255,0.1);
        border: 1px solid rgba(255,255,255,0.2);
        color: #fff;
    }

    select:focus {
        outline: none;
        border-color: #4CAF50;
    }

    button {
        border: none;
        cursor: pointer;
        background: #4CAF50;
        color: white;
        font-weight: 500;
    }

    button:hover {
        background: #45a049;
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(76, 175, 80, 0.3);
    }

    button.back {
        background: rgba(255,255,255,0.1);
        border: 1px solid rgba(255,255,255,0.2);
    }

    button.back:hover {
        background: rgba(76, 175, 80, 0.2);
        border-color: #4CAF50;
    }

    .zone-details {
        margin-top: 15px;
        padding: 15px;
        background: rgba(0,0,0,0.3);
        border-radius: 10px;
        border: 1px solid rgba(255,255,255,0.1);
        display: none;
    }

    .zone-details p {
        margin: 8px 0;
        color: rgba(255,255,255,0.8);
    }

    .zone-details strong {
        color: #4CAF50;
    }

    .error {
        color: #f44336;
        margin: 10px 0;
        padding: 10px;
        background: rgba(244, 67, 54, 0.2);
        border-radius: 5px;
        border: 1px solid rgba(244, 67, 54, 0.3);
        text-align: center;
    }
    .color{
        background-color: gray;
    }

    @media (max-width: 768px) {
        .container {
            flex-direction: column;
        }
        
        .info, .canvas-container {
            width: 100%;
        }
        
        canvas {
            height: 400px;
        }
    }
  </style>
</head>
<body>
  <h1>Xem trước Sơ Đồ Ghế</h1>
  <c:if test="${not empty errorMessage}">
    <div class="error">${errorMessage}</div>
  </c:if>
  <div class="container">
    <div class="info">
      <h3>Thông tin Zone</h3>
      <select id="zoneSelect" onchange="displayZoneDetails()">
          <option class="color" value="-1">Chọn Zone</option>
        <c:forEach var="zone" items="${zones}">
          <option class="color" value="${zone.id}">${zone.name} (Đa giác, ${zone.totalSeats} ghế, ${zone.ticketPrice} VND)</option>
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

    // Khởi tạo kích thước canvas
    function resizeCanvas() {
      const container = canvas.parentElement;
      canvas.width = container.clientWidth - 40; // Trừ padding
      canvas.height = window.innerWidth <= 768 ? 400 : 500;
    }
    resizeCanvas();
    window.addEventListener('resize', resizeCanvas);

    // Dữ liệu zones từ server
    const zones = ${requestScope.seatMapData != null ? requestScope.seatMapData : '{}'};
    const seats = [];
    let selectedZoneId = -1;

    // Tạo ghế cho mỗi zone
    if (zones.zones) {
      zones.zones.forEach(zone => {
        if (zone.isStage) return; // Bỏ qua sân khấu
        const seatWidth = (Math.max(...zone.vertices.map(v => v.x)) - Math.min(...zone.vertices.map(v => v.x))) / zone.seatsPerRow;
        const seatHeight = (Math.max(...zone.vertices.map(v => v.y)) - Math.min(...zone.vertices.map(v => v.y))) / zone.rows;

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
    } else {
      console.error('No zones data available');
    }

    function drawCanvas() {
      ctx.clearRect(0, 0, canvas.width, canvas.height);

      // Vẽ sân khấu
      const stage = zones.zones && zones.zones.find(z => z.isStage);
      if (stage) {
        ctx.fillStyle = stage.color;
        ctx.beginPath();
        ctx.moveTo(stage.x + stage.vertices[0].x, stage.y + stage.vertices[0].y);
        for (let i = 1; i < stage.vertices.length; i++) {
          ctx.lineTo(stage.x + stage.vertices[i].x, stage.y + stage.vertices[i].y);
        }
        ctx.closePath();
        ctx.fill();
        ctx.fillStyle = '#fff';
        ctx.textAlign = 'center';
        ctx.textBaseline = 'middle';
        ctx.font = 'bold 14px Arial';
        ctx.fillText(stage.name, stage.x, stage.y + 15);
      }

      // Vẽ các zone
      if (zones.zones) {
        zones.zones.forEach(zone => {
          if (zone.isStage) return; // Bỏ qua sân khấu
          ctx.fillStyle = zone.color;
          ctx.beginPath();
          ctx.moveTo(zone.x + zone.vertices[0].x, zone.y + zone.vertices[0].y);
          for (let i = 1; i < zone.vertices.length; i++) {
            ctx.lineTo(zone.x + zone.vertices[i].x, zone.y + zone.vertices[i].y);
          }
          ctx.closePath();
          ctx.fill();

          // Vẽ tên zone ở chính giữa (centroid)
          ctx.fillStyle = '#000';
          ctx.textAlign = 'center';
          ctx.textBaseline = 'middle';
          ctx.font = 'bold 14px Arial';
          let textX = zone.x;
          let textY = zone.y;
          if (zone.shape === 'polygon') {
            const sumX = zone.vertices.reduce((sum, v) => sum + v.x, 0);
            const sumY = zone.vertices.reduce((sum, v) => sum + v.y, 0);
            const count = zone.vertices.length;
            textX = zone.x + sumX / count;
            textY = zone.y + sumY / count;
          }
          ctx.fillText(zone.name, textX, textY);

          if (zone.id === selectedZoneId) {
            ctx.strokeStyle = '#000';
            ctx.lineWidth = 2;
            ctx.stroke();
          }
        });
      } else {
        console.error('No zones found in seatMapData');
      }
    }

    function displayZoneDetails() {
      const select = document.getElementById('zoneSelect');
      const zoneId = parseInt(select.value);
      selectedZoneId = zoneId;
      const zoneDetails = document.getElementById('zoneDetails');
      if (zoneId === -1) {
        zoneDetails.style.display = 'none';
      } else {
        const zone = zones.zones && zones.zones.find(z => z.id === zoneId);
        if (zone) {
          document.getElementById('zoneName').textContent = zone.name;
          document.getElementById('zoneShape').textContent = 'Đa giác';
          document.getElementById('zoneColor').innerHTML = `<span style="color: ${zone.color};">${zone.color}</span>`;
          document.getElementById('zoneRows').textContent = zone.rows;
          document.getElementById('zoneSeatsPerRow').textContent = zone.seatsPerRow;
          document.getElementById('zoneTotalSeats').textContent = zone.totalSeats;
          document.getElementById('zoneTicketPrice').textContent = zone.ticketPrice.toLocaleString('vi-VN');
          zoneDetails.style.display = 'block';
        }
      }
      drawCanvas();
    }

    function isPointInZone(x, y, zone) {
      if (zone.isStage) return false;
      let inside = false;
      const vertices = zone.vertices;
      for (let i = 0, j = vertices.length - 1; i < vertices.length; j = i++) {
        const xi = zone.x + vertices[i].x, yi = zone.y + vertices[i].y;
        const xj = zone.x + vertices[j].x, yj = zone.y + vertices[j].y;
        const intersect = ((yi > y) !== (yj > y)) && (x < (xj - xi) * (y - yi) / (yj - yi) + xi);
        if (intersect) inside = !inside;
      }
      return inside;
    }

    canvas.addEventListener('click', (e) => {
      const rect = canvas.getBoundingClientRect();
      const x = e.clientX - rect.left;
      const y = e.clientY - rect.top;
      if (zones.zones) {
        for (let i = zones.zones.length - 1; i >= 0; i--) {
          if (isPointInZone(x, y, zones.zones[i])) {
            selectedZoneId = zones.zones[i].id;
            document.getElementById('zoneSelect').value = selectedZoneId;
            displayZoneDetails();
            break;
          }
        }
      }
    });

    function confirmLayout() {
      if (!zones.zones || zones.zones.length === 0) {
        alert('Không có zone nào để xác nhận.');
        return;
      }
      const seatMapData = JSON.stringify({ zones: zones.zones, seats: seats });
      console.log('Confirming seatMapData:', seatMapData);
      document.getElementById('seatMapData').value = seatMapData;
      document.getElementById('seatMapForm').submit();
    }

    // Vẽ canvas ban đầu
    drawCanvas();
  </script>
</body>
</html>
