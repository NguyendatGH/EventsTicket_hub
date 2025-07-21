// // File: dao/SeatDAO.java
// package dao;

// import context.DBConnection;
// import models.Seat;
// import java.sql.*;
// import java.util.ArrayList;
// import java.util.List;

// public class SeatDAO {

//     public List<Seat> getSeatsByEventId(int eventId) {
//         System.out.println("[DEBUG-DAO] SeatDAO: Bắt đầu lấy ghế cho EventID = " + eventId);
//         List<Seat> seatList = new ArrayList<>();

//         // [FIXED] Sửa lại câu lệnh SQL để sắp xếp đúng với SeatNumber chứa ký tự chữ và số
//         // Logic mới: Sắp xếp theo Khu vực, Hàng, và sau đó là PHẦN SỐ của SeatNumber
//         String sql = "SELECT * FROM Seat WHERE EventID = ? "
//                 + "ORDER BY SeatSection, SeatRow, "
//                 + "TRY_CONVERT(INT, SUBSTRING(SeatNumber, PATINDEX('%[0-9]%', SeatNumber), LEN(SeatNumber)))";

//         try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

//             ps.setInt(1, eventId);
//             try (ResultSet rs = ps.executeQuery()) {
//                 while (rs.next()) {
//                     seatList.add(mapRowToSeat(rs));
//                 }
//             }
//         } catch (SQLException e) {
//             e.printStackTrace();
//         }

//         System.out.println("[DEBUG-DAO] SeatDAO: Đã tìm thấy " + seatList.size() + " ghế.");
//         return seatList;
//     }

//     private Seat mapRowToSeat(ResultSet rs) throws SQLException {
//         Seat seat = new Seat();
//         seat.setSeatId(rs.getInt("SeatID"));
//         seat.setEventId(rs.getInt("EventID"));
//         seat.setSeatNumber(rs.getString("SeatNumber"));
//         seat.setSeatRow(rs.getString("SeatRow"));
//         seat.setSeatSection(rs.getString("SeatSection"));
//         seat.setSeatStatus(rs.getString("SeatStatus"));

//         Timestamp createdAt = rs.getTimestamp("CreatedAt");
//         if (createdAt != null) {
//             seat.setCreatedAt(createdAt.toLocalDateTime());
//         }
//         return seat;
//     }

//     public Seat getSeatById(int seatId) {
//         Seat seat = null;
//         String sql = "SELECT * FROM Seat WHERE SeatID = ?";
//         try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
//             ps.setInt(1, seatId);
//             try (ResultSet rs = ps.executeQuery()) {
//                 if (rs.next()) {
//                     seat = mapRowToSeat(rs);
//                 }
//             }
//         } catch (SQLException e) {
//             e.printStackTrace();
//         }
//         return seat;
//     }
// }
