<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Tạo Sơ Đồ Ghế</title>
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
    .controls {
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
      cursor: default;
    }
    canvas.draggable {
      cursor: pointer;
    }
    canvas.resizable {
      cursor: crosshair;
    }
    .form-group {
      margin-bottom: 15px;
    }
    label {
      display: block;
      margin-bottom: 5px;
    }
    input, select, button {
      width: 100%;
      padding: 8px;
      margin-bottom: 10px;
      border: 1px solid #ccc;
      border-radius: 4px;
    }
    button {
      background-color: #28a745;
      color: white;
      border: none;
      cursor: pointer;
    }
    button:hover {
      background-color: #218838;
    }
    button.delete {
      background-color: #dc3545;
    }
    button.delete:hover {
      background-color: #c82333;
    }
    #zoneList {
      max-height: 300px;
      overflow-y: auto;
      border: 1px solid #ccc;
      padding: 10px;
      border-radius: 4px;
    }
    .zone-item {
      padding: 5px;
      cursor: pointer;
      border-bottom: 1px solid #eee;
    }
    .zone-item:hover {
      background-color: #f0f0f0;
    }
    .zone-item.selected {
      background-color: #d1e7dd;
    }
  </style>
</head>
<body>
  <h1>Thiết kế Sơ đồ Ghế</h1>
  <div class="container">
    <div class="controls">
      <div class="form-group">
        <label>Tên Zone:</label>
        <input type="text" id="zoneName" value="Zone${zones.length + 1}">
      </div>
      <div class="form-group">
        <label>Loại hình khối:</label>
        <select id="shapeType">
          <option value="rectangle">Hình chữ nhật</option>
          <%-- <option value="circle">Hình tròn</option> --%>
        </select>
      </div>
      <div id="rectangleInputs" class="form-group">
        <label>Chiều rộng (px):</label>
        <input type="number" id="width" value="100">
        <label>Chiều cao (px):</label>
        <input type="number" id="height" value="100">
      </div>
      <div id="circleInputs" class="form-group" style="display: none;">
        <label>Bán kính X (px):</label>
        <input type="number" id="radiusX" value="50">
        <label>Bán kính Y (px):</label>
        <input type="number" id="radiusY" value="50">
      </div>
      <div class="form-group">
        <label>Màu sắc:</label>
        <input type="color" id="zoneColor" value="#ff0000">
      </div>
      <div class="form-group">
        <label>Số hàng:</label>
        <input type="number" id="rows" value="5">
      </div>
      <div class="form-group">
        <label>Ghế mỗi hàng:</label>
        <input type="number" id="seatsPerRow" value="10">
      </div>
       <div class="form-group">
        <label>Giá vé (VND):</label>
        <input type="number" id="ticketPrice" value="100000" step="1000">
      </div>
      <button onclick="addZone()">Thêm hình khối</button>
      <button onclick="updateZone()" id="updateButton" disabled>Cập nhật hình khối</button>
      <button onclick="deleteZone()" id="deleteButton" disabled>Xóa khối</button>
      <button onclick="submitSeating()">Tiếp tục</button>
      <button onclick="clearAll()">Xóa tất cả</button>
      <h3>Danh sách Zone</h3>
      <div id="zoneList"></div>
    </div>
    <div class="canvas-container">
      <canvas id="canvas"></canvas>
    </div>
  </div>
  <form id="seatMapForm" action="${pageContext.request.contextPath}/organizer-servlet" method="post" style="display: none;">
    <input type="hidden" name="action" value="createMap">
    <input type="hidden" name="seatMapData" id="seatMapData">
  </form>
  <script>
    const canvas = document.getElementById('canvas');
    const ctx = canvas.getContext('2d');
    canvas.width = 800;
    canvas.height = 500;

    const zones = [];
    let selectedZoneIndex = -1;
    let isDragging = false;
    let draggedZoneIndex = -1;
    let dragOffsetX = 0;
    let dragOffsetY = 0;
    let resizingCorner = -1;
    let lastWidth = 100;
    let lastHeight = 100;
    let lastRadiusX = 50;
    let lastRadiusY = 50;
    let lastMouseX = 0;
    let lastMouseY = 0;

    document.getElementById('shapeType').addEventListener('change', function() {
      const shape = this.value;
      document.getElementById('rectangleInputs').style.display = shape === 'rectangle' ? 'block' : 'none';
      document.getElementById('circleInputs').style.display = shape === 'circle' ? 'block' : 'none';
    });

    
    function addZone() {
      const shape = document.getElementById('shapeType').value;
      const name = document.getElementById('zoneName').value.trim() || `Zone${zones.length + 1}`;
      const color = document.getElementById('zoneColor').value;
      const rows = parseInt(document.getElementById('rows').value);
      const seatsPerRow = parseInt(document.getElementById('seatsPerRow').value);
      const totalSeats = rows * seatsPerRow;
     const ticketPrice = parseFloat(document.getElementById('ticketPrice').value);

      if (isNaN(ticketPrice) || ticketPrice <= 0) {
        alert('Vui lòng nhập giá vé hợp lệ (lớn hơn 0).');
        return;
      }

      let zone = {
        id: zones.length + 1,
        name: name,
        shape: shape,
        color: color,
        rows: rows,
        seatsPerRow: seatsPerRow,
        totalSeats: totalSeats,
        x: 50 + zones.length * 20,
        y: 50 + zones.length * 20,
        rotation: 0,
        ticketPrice: ticketPrice
      };

      if (shape === 'rectangle') {
        zone.vertices = [
          { x: 0, y: 0 },
          { x: parseInt(document.getElementById('width').value), y: 0 },
          { x: parseInt(document.getElementById('width').value), y: parseInt(document.getElementById('height').value) },
          { x: 0, y: parseInt(document.getElementById('height').value) }
        ];
        lastWidth = parseInt(document.getElementById('width').value);
        lastHeight = parseInt(document.getElementById('height').value);
      } else {
        zone.radiusX = parseInt(document.getElementById('radiusX').value);
        zone.radiusY = parseInt(document.getElementById('radiusY').value);
        lastRadiusX = zone.radiusX;
        lastRadiusY = zone.radiusY;
      }

      zones.push(zone);
      document.getElementById('zoneName').value = `Zone${zones.length + 1}`;
      updateZoneList();
      drawCanvas();
    }

    function updateZone() {
      if (selectedZoneIndex === -1) return;

      const zone = zones[selectedZoneIndex];
      zone.name = document.getElementById('zoneName').value.trim() || `Zone${selectedZoneIndex + 1}`;
      zone.color = document.getElementById('zoneColor').value;
      zone.rows = parseInt(document.getElementById('rows').value);
      zone.seatsPerRow = parseInt(document.getElementById('seatsPerRow').value);
      zone.totalSeats = zone.rows * zone.seatsPerRow;
      zone.ticketPrice = parseInt(document.getElementById('ticketPrice').value);

      if (zone.shape === 'rectangle') {
        const newWidth = parseInt(document.getElementById('width').value);
        const newHeight = parseInt(document.getElementById('height').value);
        if (newWidth !== lastWidth || newHeight !== lastHeight) {
          zone.vertices = [
            { x: 0, y: 0 },
            { x: newWidth, y: 0 },
            { x: newWidth, y: newHeight },
            { x: 0, y: newHeight }
          ];
          lastWidth = newWidth;
          lastHeight = newHeight;
        }
      } else {
        const newRadiusX = parseInt(document.getElementById('radiusX').value);
        const newRadiusY = parseInt(document.getElementById('radiusY').value);
        if (newRadiusX !== lastRadiusX || newRadiusY !== lastRadiusY) {
          zone.radiusX = newRadiusX;
          zone.radiusY = newRadiusY;
          lastRadiusX = newRadiusX;
          lastRadiusY = newRadiusY;
        }
      }

      updateZoneList();
      drawCanvas();
      selectZone(selectedZoneIndex);
    }

    function deleteZone() {
      if (selectedZoneIndex === -1) return;
      zones.splice(selectedZoneIndex, 1);
      selectedZoneIndex = -1;
      draggedZoneIndex = -1;
      isDragging = false;
      resizingCorner = -1;
      updateZoneList();
      drawCanvas();
    }

    function updateZoneList() {
    const zoneList = document.getElementById('zoneList');
    zoneList.innerHTML = '';
    zones.forEach((zone, index) => {
        const div = document.createElement('div');
        div.className = 'zone-item';
        div.textContent = `${zone.name} (${zone.shape}, ${zone.totalSeats} ghế, ${zone.color}, ${zone.ticketPrice} VND)`;
        div.onclick = () => selectZone(index);
        if (index === selectedZoneIndex) div.classList.add('selected');
        zoneList.appendChild(div);
    });
    document.getElementById('updateButton').disabled = selectedZoneIndex === -1;
    document.getElementById('deleteButton').disabled = selectedZoneIndex === -1;
    }
      // document.getElementById('ticketPrice').value = zone.ticketPrice;

    function selectZone(index) {
      selectedZoneIndex = index;
      const zone = zones[index];
      document.getElementById('zoneName').value = zone.name;
      document.getElementById('shapeType').value = zone.shape;
      document.getElementById('zoneColor').value = zone.color;
      document.getElementById('rows').value = zone.rows;
      document.getElementById('seatsPerRow').value = zone.seatsPerRow;
       document.getElementById('ticketPrice').value = zone.ticketPrice;

      document.getElementById('rectangleInputs').style.display = zone.shape === 'rectangle' ? 'block' : 'none';
      document.getElementById('circleInputs').style.display = zone.shape === 'circle' ? 'block' : 'none';

      if (zone.shape === 'rectangle') {
        const width = Math.max(...zone.vertices.map(v => v.x)) - Math.min(...zone.vertices.map(v => v.x));
        const height = Math.max(...zone.vertices.map(v => v.y)) - Math.min(...zone.vertices.map(v => v.y));
        document.getElementById('width').value = width;
        document.getElementById('height').value = height;
        lastWidth = width;
        lastHeight = height;
      } else {
        document.getElementById('radiusX').value = zone.radiusX;
        document.getElementById('radiusY').value = zone.radiusY;
        lastRadiusX = zone.radiusX;
        lastRadiusY = zone.radiusY;
      }

      updateZoneList();
      drawCanvas();
    }

    function drawCanvas() {
      ctx.clearRect(0, 0, canvas.width, canvas.height);
      zones.forEach((zone, index) => {
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
        if (index === selectedZoneIndex || index === draggedZoneIndex) {
          ctx.strokeStyle = '#000';
          ctx.lineWidth = 2;
          ctx.stroke();
          if (index === selectedZoneIndex) {
            if (zone.shape === 'rectangle') {
              zone.vertices.forEach((v, i) => {
                ctx.beginPath();
                ctx.arc(zone.x + v.x, zone.y + v.y, 8, 0, Math.PI * 2);
                ctx.fillStyle = isPointNearControlPoint(zone, i, canvas) ? '#ff0000' : '#000';
                ctx.fill();
              });
            } else {
              ctx.beginPath();
              ctx.arc(zone.x - zone.radiusX, zone.y, 8, 0, Math.PI * 2);
              ctx.fillStyle = isPointNearControlPoint(zone, 4, canvas) ? '#ff0000' : '#000';
              ctx.fill();
              ctx.beginPath();
              ctx.arc(zone.x, zone.y - zone.radiusY, 8, 0, Math.PI * 2);
              ctx.fillStyle = isPointNearControlPoint(zone, 5, canvas) ? '#ff0000' : '#000';
              ctx.fill();
            }
          }
        }
      });
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

    function isPointNearControlPoint(zone, cornerIndex, canvasElement) {
      const rect = canvasElement.getBoundingClientRect();
      const x = (event.clientX || lastMouseX) - rect.left;
      const y = (event.clientY || lastMouseY) - rect.top;
      if (zone.shape === 'rectangle') {
        const vx = zone.x + zone.vertices[cornerIndex].x;
        const vy = zone.y + zone.vertices[cornerIndex].y;
        return Math.hypot(x - vx, y - vy) < 15;
      } else {
        if (cornerIndex === 4) return Math.hypot(x - (zone.x - zone.radiusX), y - zone.y) < 15;
        if (cornerIndex === 5) return Math.hypot(x - zone.x, y - (zone.y - zone.radiusY)) < 15;
      }
      return false;
    }

    function getControlPoint(x, y, zone) {
      if (zone.shape === 'rectangle') {
        for (let i = 0; i < zone.vertices.length; i++) {
          const vx = zone.x + zone.vertices[i].x;
          const vy = zone.y + zone.vertices[i].y;
          if (Math.hypot(x - vx, y - vy) < 15) {
            return i;
          }
        }
      } else {
        if (Math.hypot(x - (zone.x - zone.radiusX), y - zone.y) < 15) return 4;
        if (Math.hypot(x - zone.x, y - (zone.y - zone.radiusY)) < 15) return 5;
      }
      return -1;
    }

    canvas.addEventListener('mousedown', (e) => {
      const rect = canvas.getBoundingClientRect();
      const x = e.clientX - rect.left;
      const y = e.clientY - rect.top;

      for (let i = zones.length - 1; i >= 0; i--) {
        if (i === selectedZoneIndex) {
          const zone = zones[i];
          resizingCorner = getControlPoint(x, y, zone);
          if (resizingCorner !== -1) {
            draggedZoneIndex = i;
            isDragging = true;
            return;
          }
        }
      }

      for (let i = zones.length - 1; i >= 0; i--) {
        if (isPointInZone(x, y, zones[i])) {
          draggedZoneIndex = i;
          selectZone(i);
          dragOffsetX = x - zones[i].x;
          dragOffsetY = y - zones[i].y;
          isDragging = true;
          resizingCorner = -1;
          break;
        }
      }
    });

    canvas.addEventListener('mousemove', (e) => {
      const rect = canvas.getBoundingClientRect();
      lastMouseX = e.clientX;
      lastMouseY = e.clientY;
      const x = e.clientX - rect.left;
      const y = e.clientY - rect.top;
      let cursor = 'default';

      for (let i = zones.length - 1; i >= 0; i--) {
        if (i === selectedZoneIndex) {
          const zone = zones[i];
          if (zone.shape === 'rectangle') {
            for (let j = 0; j < zone.vertices.length; j++) {
              if (isPointNearControlPoint(zone, j, canvas)) {
                cursor = 'crosshair';
                break;
              }
            }
          } else {
            if (isPointNearControlPoint(zone, 4, canvas) || isPointNearControlPoint(zone, 5, canvas)) {
              cursor = 'crosshair';
            }
          }
        }
        if (cursor === 'default' && isPointInZone(x, y, zones[i])) {
          cursor = 'pointer';
        }
        if (cursor !== 'default') break;
      }
      canvas.className = cursor === 'crosshair' ? 'resizable' : cursor === 'pointer' ? 'draggable' : '';
      if (!isDragging) drawCanvas();

      if (isDragging && draggedZoneIndex !== -1) {
        const zone = zones[draggedZoneIndex];
        if (resizingCorner !== -1) {
          if (zone.shape === 'rectangle') {
            zone.vertices[resizingCorner].x = x - zone.x;
            zone.vertices[resizingCorner].y = y - zone.y;
          } else {
            if (resizingCorner === 4) zone.radiusX = Math.abs(zone.x - x);
            if (resizingCorner === 5) zone.radiusY = Math.abs(zone.y - y);
          }
        } else {
          zone.x = x - dragOffsetX;
          zone.y = y - dragOffsetY;
        }
        drawCanvas();
      }
    });

    canvas.addEventListener('mouseup', () => {
      isDragging = false;
      draggedZoneIndex = -1;
      resizingCorner = -1;
      canvas.className = '';
      drawCanvas();
    });

    canvas.addEventListener('mouseleave', () => {
      isDragging = false;
      draggedZoneIndex = -1;
      resizingCorner = -1;
      canvas.className = '';
      drawCanvas();
    });

    function submitSeating() {
      if (zones.length === 0) {
        alert('Vui lòng thêm ít nhất một zone trước khi tiếp tục.');
        return;
      }
      const json = JSON.stringify({ zones: zones });
      console.log('Submitting seatMapData:', json);
      document.getElementById('seatMapData').value = json;
      document.getElementById('seatMapForm').submit();
    }

    function clearAll() {
      zones.length = 0;
      selectedZoneIndex = -1;
      draggedZoneIndex = -1;
      isDragging = false;
      resizingCorner = -1;
      document.getElementById('zoneName').value = `Zone1`;
      updateZoneList();
      drawCanvas();
    }
  </script>
</body>
</html>