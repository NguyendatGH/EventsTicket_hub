<%-- 
    Document   : BookChair
    Created on : May 28, 2025, 10:10:14 PM
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>MasterTicket - Book Your Seat</title>
        <style>
            body {
                margin: 0;
                background: radial-gradient(ellipse at left, #0a1836 60%, #2a1a3a 100%);
                font-family: 'Segoe UI', Arial, sans-serif;
                color: #fff;
            }
            .header {
                display: flex;
                align-items: center;
                justify-content: space-between;
                padding: 24px 40px 16px 40px;
                background: transparent;
            }
            .header-left {
                font-size: 2rem;
                font-weight: bold;
                letter-spacing: 1px;
            }
            .header-center {
                flex: 1;
                display: flex;
                justify-content: center;
            }
            .search-box {
                display: flex;
                align-items: center;
                background: #23263a;
                border-radius: 8px;
                padding: 0 12px;
                width: 340px;
            }
            .search-box input {
                background: transparent;
                border: none;
                outline: none;
                color: #fff;
                font-size: 1rem;
                padding: 10px 8px;
                width: 100%;
            }
            .search-box button {
                background: #393e5c;
                border: none;
                color: #fff;
                padding: 8px 18px;
                border-radius: 6px;
                margin-left: 8px;
                cursor: pointer;
                font-size: 1rem;
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
                transition: background 0.2s;
            }
            .header-right button:hover, .header-right .account:hover {
                background: #393e5c;
            }
            .main-content {
                display: flex;
                justify-content: center;
                align-items: flex-start;
                gap: 32px;
                margin-top: 10px;
            }
            .left-panel {
                background: transparent;
                padding: 0 0 0 40px;
            }
            .back-btn {
                background: #1ed090;
                color: #fff;
                border: none;
                border-radius: 8px;
                padding: 8px 18px;
                font-size: 1rem;
                cursor: pointer;
                margin-bottom: 18px;
                font-weight: 500;
                transition: background 0.2s;
            }
            .back-btn:hover {
                background: #17b07a;
            }
            .choose-seat-btn {
                background: #1ed090;
                color: #fff;
                border: none;
                border-radius: 24px;
                padding: 12px 32px;
                font-size: 1.1rem;
                font-weight: bold;
                margin: 0 auto 18px auto;
                display: block;
                cursor: pointer;
                transition: background 0.2s;
            }
            .choose-seat-btn:disabled {
                background: #3a3a4a;
                color: #aaa;
                cursor: not-allowed;
            }
            .legend {
                display: flex;
                gap: 24px;
                margin: 18px auto 18px auto;
                justify-content: center;
            }
            .legend-item {
                display: flex;
                align-items: center;
                gap: 6px;
                font-size: 1rem;
            }
            .legend-dot {
                width: 16px;
                height: 16px;
                border-radius: 50%;
                border: 2px solid #ccc;
            }
            .legend-dot.available { background: #fff; border-color: #ccc;}
            .legend-dot.choosing { background: #1ed090; border-color: #1ed090;}
            .legend-dot.selected { background: #e74c3c; border-color: #e74c3c;}
            .seating-area {
                background: #181c2f;
                border-radius: 32px;
                padding: 32px 32px 24px 32px;
                box-shadow: 0 8px 32px 0 #0004;
                min-width: 420px;
            }
            .stage {
                margin: 0 auto 18px auto;
                width: 320px;
                background: #eee;
                color: #222;
                text-align: center;
                border-radius: 30px 30px 30px 30px;
                padding: 10px 0;
                font-weight: bold;
                font-size: 1.2em;
                letter-spacing: 1px;
            }
            .seats {
                display: flex;
                flex-direction: column;
                align-items: center;
                gap: 8px;
            }
            .row {
                display: flex;
                gap: 10px;
            }
            .seat {
                width: 22px;
                height: 22px;
                border-radius: 50%;
                border: 2px solid #ccc;
                background: #fff;
                cursor: pointer;
                transition: background 0.2s, border 0.2s;
            }
            .seat.selected {
                background: #e74c3c;
                border-color: #e74c3c;
            }
            .seat.choosing {
                background: #1ed090;
                border-color: #1ed090;
            }
            .seat.taken {
                background: #222;
                border-color: #222;
                cursor: not-allowed;
            }
            .right-panel {
                background: #23263a;
                border-radius: 24px;
                padding: 32px 32px 24px 32px;
                min-width: 340px;
                box-shadow: 0 8px 32px 0 #0004;
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
                font-size: 1rem;
            }
            .event-info i {
                font-style: normal;
                font-weight: bold;
            }
            .ticket-prices {
                margin: 24px 0 18px 0;
            }
            .ticket-prices-title {
                font-weight: bold;
                margin-bottom: 8px;
            }
            .ticket-type {
                display: flex;
                align-items: center;
                gap: 10px;
                margin-bottom: 8px;
            }
            .ticket-dot {
                width: 18px;
                height: 18px;
                border-radius: 4px;
                display: inline-block;
            }
            .ticket-dot.vip { background: #ffe0e0; border: 1px solid #e74c3c;}
            .ticket-dot.regular { background: #e0f7fa; border: 1px solid #1ed090;}
            .ticket-price {
                margin-left: auto;
                color: #1ed090;
                font-weight: bold;
            }
            .footer-btn {
                width: 100%;
                background: #393e5c;
                color: #aaa;
                border: none;
                border-radius: 12px;
                padding: 16px 0;
                font-size: 1.1rem;
                margin-top: 32px;
                cursor: not-allowed;
                text-align: center;
            }
            @media (max-width: 1100px) {
                .main-content {
                    flex-direction: column;
                    align-items: center;
                }
                .left-panel, .right-panel {
                    padding: 0;
                }
            }
        </style>
    </head>
    <body>
        <div class="header">
            <div class="header-left">MasterTicket</div>
            <div class="header-center">
                <div class="search-box">
                    <input type="text" placeholder="What are you looking for today?">
                    <button>Search</button>
                </div>
            </div>
            <div class="header-right">
                <button>Purchased Tickets</button>
                <div class="account">Account</div>
            </div>
        </div>
        <div class="main-content">
            <div class="left-panel">
                <button class="back-btn">&larr; Back</button>
                <button class="choose-seat-btn" id="chooseSeatBtn" disabled>Choose your seat</button>
                <div class="legend">
                    <div class="legend-item"><div class="legend-dot available"></div>Available</div>
                    <div class="legend-item"><div class="legend-dot choosing"></div>Selecting</div>
                    <div class="legend-item"><div class="legend-dot selected"></div>Sold</div>
                </div>
                <div class="seating-area">
                    <div class="stage">STAGE</div>
                    <div class="seats" id="seats"></div>
                </div>
            </div>
            <div class="right-panel">
                <div class="event-title">Event: Tam Cam - The Great Battle</div>
                <div class="event-info"><i>🕒</i> 19:30, June 6, 2025</div>
                <div class="event-info"><i>📍</i> IDECAF Theater</div>
                <div class="ticket-prices">
                    <div class="ticket-prices-title">Ticket Prices</div>
                    <div class="ticket-type">
                        <span class="ticket-dot vip"></span>
                        VIP (Not for children under 12)
                        <span class="ticket-price">320,000₫</span>
                    </div>
                    <div class="ticket-type">
                        <span class="ticket-dot regular"></span>
                        Regular (Not for children under 12)
                        <span class="ticket-price">270,000₫</span>
                    </div>
                </div>
                <div class="footer-btn" id="footerBtn">Please select a seat &gt;&gt;</div>
            </div>
        </div>
        <script>
            // Configuration: number of rows and seats per row
            const rows = 10;
            const seatsPerRow = 12;
            // Example of sold seats
            const takenSeats = [
                [0,1],[0,2],[0,3],[1,2],[2,5],[3,7],[4,8],[5,9],[6,10],[7,11],[8,0],[9,1],
                [0,4],[0,5],[1,3],[1,4],[2,6],[3,8],[4,9],[5,10],[6,11],[7,0],[8,1],[9,2]
            ];
            // Render seats
            const seatsDiv = document.getElementById('seats');
            let choosingSeat = null;
            for(let r=0; r<rows; r++) {
                const rowDiv = document.createElement('div');
                rowDiv.className = 'row';
                for(let s=0; s<seatsPerRow; s++) {
                    const seat = document.createElement('div');
                    seat.className = 'seat';
                    seat.dataset.row = r;
                    seat.dataset.seat = s;                  
                    if(takenSeats.some(([tr,ts]) => tr===r && ts===s)) {
                        seat.classList.add('selected');
                        seat.classList.add('taken');
                    }
                    seat.onclick = function() {
                        if(seat.classList.contains('taken')) return;                       
                        if(choosingSeat) choosingSeat.classList.remove('choosing');
                        seat.classList.add('choosing');
                        choosingSeat = seat;
                        document.getElementById('chooseSeatBtn').disabled = false;
                        document.getElementById('footerBtn').style.background = '#1ed090';
                        document.getElementById('footerBtn').style.color = '#fff';
                        document.getElementById('footerBtn').style.cursor = 'pointer';
                        document.getElementById('footerBtn').innerHTML = 'Continue &gt;&gt;';
                    }
                    rowDiv.appendChild(seat);
                }
                seatsDiv.appendChild(rowDiv);
            }
            document.getElementById('chooseSeatBtn').onclick = function() {
                if(choosingSeat) {
                    alert('You have selected seat: Row ' + (parseInt(choosingSeat.dataset.row)+1) + ', Seat ' + (parseInt(choosingSeat.dataset.seat)+1));
                }
            };
        </script>
    </body>
</html>
