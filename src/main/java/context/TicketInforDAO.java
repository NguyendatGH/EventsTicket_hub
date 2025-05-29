package context;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.TicketInfor;

public class TicketInforDAO {

    public List<TicketInfor> getAllTicketInfo() {
        List<TicketInfor> list = new ArrayList<>();
        String sql = "SELECT * FROM TicketInfo";

        try {
            Connection conn = new DBContext().getConnection(); // Lấy kết nối từ DBContext
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                TicketInfor ticket = new TicketInfor();
                ticket.setTicketInfoID(rs.getInt("TicketInfoID"));
                ticket.setTicketName(rs.getString("TicketName"));
                ticket.setTicketDescription(rs.getString("TicketDescription"));
                ticket.setCategory(rs.getString("Category"));
                ticket.setPrice(rs.getDouble("Price"));
                ticket.setSalesStartTime(rs.getTimestamp("SalesStartTime").toLocalDateTime());
                ticket.setSalesEndTime(rs.getTimestamp("SalesEndTime").toLocalDateTime());
                ticket.setEventID(rs.getInt("EventID"));
                ticket.setMaxQuantityPerOrder(rs.getInt("MaxQuantityPerOrder"));
                ticket.setIsActive(rs.getBoolean("IsActive"));

                list.add(ticket);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
