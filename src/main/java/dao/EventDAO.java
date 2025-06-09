package dao;

import models.Event;
import context.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class EventDAO {

    public List<Event> getAllApprovedEvents() {
        List<Event> list = new ArrayList<>();
        String sql = "SELECT * FROM Events WHERE isDeleted = 0 AND isApproved = 1";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Event event = mapRowToEvent(rs);
                list.add(event);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public Event getEventById(int eventId) {
        Event event = null;
        String sql = "SELECT * FROM Events WHERE EventID = ? AND isDeleted = 0"; // Giả sử isDeleted = 0 là không bị xóa

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, eventId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    event = mapRowToEvent(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return event;
    }

    public List<Event> getSuggestedEvents(int currentEventId) {
        List<Event> suggestedList = new ArrayList<>();
        Event currentEvent = getEventById(currentEventId); // Lấy thông tin sự kiện hiện tại để biết GenreID

        String sql;

        // Ưu tiên gợi ý theo GenreID nếu có
        if (currentEvent != null && currentEvent.getGenreID() != null) {
            sql = "SELECT * FROM Events WHERE GenreID = ? AND EventID != ? AND isDeleted = 0 AND isApproved = 1 ORDER BY StartTime DESC LIMIT 3";
            try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, currentEvent.getGenreID());
                ps.setInt(2, currentEventId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        suggestedList.add(mapRowToEvent(rs));
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        // Nếu không có gợi ý theo GenreID (hoặc không đủ), lấy thêm các sự kiện khác
        if (suggestedList.size() < 3) {
            int limit = 3 - suggestedList.size();
            List<Integer> excludeIds = new ArrayList<>();
            excludeIds.add(currentEventId);
            for (Event e : suggestedList) {
                excludeIds.add(e.getEventID());
            }

            StringBuilder excludeClause = new StringBuilder();
            if (!excludeIds.isEmpty()) {
                excludeClause.append(" AND EventID NOT IN (");
                for (int i = 0; i < excludeIds.size(); i++) {
                    excludeClause.append("?");
                    if (i < excludeIds.size() - 1) {
                        excludeClause.append(",");
                    }
                }
                excludeClause.append(")");
            }

            sql = "SELECT * FROM Events WHERE isDeleted = 0 AND isApproved = 1"
                    + excludeClause.toString()
                    + " ORDER BY StartTime DESC LIMIT ?";

            try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

                int paramIndex = 1;
                for (Integer excludeId : excludeIds) {
                    ps.setInt(paramIndex++, excludeId);
                }
                ps.setInt(paramIndex, limit);

                // Giả sử lỗi xảy ra trong khối try-with-resources cho ResultSet này
                // Sửa 'ry' thành 'try' nếu đó là lỗi gõ phím
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        // Lấy EventID từ ResultSet ra một biến trước khi dùng trong lambda
                        final int eventIdFromRs = rs.getInt("EventID");

                        if (suggestedList.stream().noneMatch(e -> e.getEventID() == eventIdFromRs)) {
                            // mapRowToEvent(rs) vẫn có thể ném SQLException, 
                            // nhưng nó sẽ được bắt bởi khối catch (SQLException e) bên ngoài này.
                            suggestedList.add(mapRowToEvent(rs));
                            if (suggestedList.size() >= 3) {
                                break; // Đảm bảo không vượt quá 3 gợi ý tổng cộng
                            }
                        }
                    }
                } // Kết thúc try-with-resources cho ResultSet
            } catch (SQLException e) { // Khối catch này xử lý SQLException từ Connection, PreparedStatement, ResultSet
                e.printStackTrace();
            }
        }

        return suggestedList;
    }

    // Phương thức tiện ích để map một dòng ResultSet thành đối tượng Event
    // (Tách ra để tránh lặp code)
    private Event mapRowToEvent(ResultSet rs) throws SQLException {
        Event event = new Event();
        event.setEventID(rs.getInt("EventID"));
        event.setName(rs.getString("Name"));
        event.setDescription(rs.getString("Description"));
        event.setPhysicalLocation(rs.getString("PhysicalLocation"));
        event.setStartTime(rs.getTimestamp("StartTime"));
        event.setEndTime(rs.getTimestamp("EndTime"));
        // Xử lý cẩn thận các trường có thể NULL
        event.setTotalTicketCount(rs.getObject("TotalTicketCount") != null ? rs.getInt("TotalTicketCount") : null);
        event.setIsApproved(rs.getObject("IsApproved") != null ? rs.getBoolean("IsApproved") : null);
        event.setStatus(rs.getString("Status"));
        event.setGenreID(rs.getObject("GenreID") != null ? rs.getInt("GenreID") : null);
        event.setOwnerID(rs.getObject("OwnerID") != null ? rs.getInt("OwnerID") : null);
        event.setImageURL(rs.getString("ImageURL"));
        event.setHasSeatingChart(rs.getObject("HasSeatingChart") != null ? rs.getBoolean("HasSeatingChart") : null);
        event.setIsDeleted(rs.getObject("IsDeleted") != null ? rs.getBoolean("IsDeleted") : null);
        event.setCreatedAt(rs.getTimestamp("CreatedAt"));
        event.setUpdatedAt(rs.getTimestamp("UpdatedAt"));
        return event;
    }
}
