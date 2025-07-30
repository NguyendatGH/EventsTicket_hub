package dao;

import context.DBConnection;
import models.Zone;
import org.json.JSONArray;
import org.json.JSONObject;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ZoneDAO {

    public List<Zone> getZonesByEventId(int eventId) {
        System.out.println("[DEBUG-DAO] ZoneDAO: Fetching zones for EventID = " + eventId);
        List<Zone> zoneList = new ArrayList<>();
        String sql = "SELECT id, event_id, name, shape, color, rows, seats_per_row, total_seats, x, y, rotation, ticket_price, vertices " +
                     "FROM Zones WHERE event_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Zone zone = new Zone();
                    zone.setId(rs.getInt("id"));
                    zone.setName(rs.getString("name"));
                    zone.setShape(rs.getString("shape"));
                    zone.setColor(rs.getString("color"));
                    zone.setRows(rs.getInt("rows"));
                    zone.setSeatsPerRow(rs.getInt("seats_per_row"));
                    zone.setTotalSeats(rs.getInt("total_seats"));
                    zone.setX(rs.getInt("x"));
                    zone.setY(rs.getInt("y"));
                    zone.setRotation(rs.getInt("rotation"));
                    zone.setTicketPrice(rs.getDouble("ticket_price"));
                    
                    String verticesJson = rs.getString("vertices");
                    if (verticesJson != null && !verticesJson.isEmpty()) {
                        JSONArray verticesArray = new JSONArray(verticesJson);
                        List<Zone.Coordinate> vertices = new ArrayList<>();
                        for (int i = 0; i < verticesArray.length(); i++) {
                            JSONObject vertex = verticesArray.getJSONObject(i);
                            vertices.add(new Zone.Coordinate(vertex.getInt("x"), vertex.getInt("y")));
                        }
                        zone.setVertices(vertices);
                    }
                    zoneList.add(zone);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        System.out.println("[DEBUG-DAO] ZoneDAO: Found " + zoneList.size() + " zones.");
        return zoneList;
    }
}