/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class TicketInventoryDAO {

    // ... các phương thức khác như getInventoryByTicketInfoId, addInventory ...
    /**
     * Cập nhật giảm số lượng vé trong kho sau khi một đơn hàng được bán. PHƯƠNG
     * THỨC NÀY ĐÃ ĐƯỢC ĐẶT Ở ĐÚNG NƠI.
     *
     * @param ticketInfoId ID của loại vé
     * @param quantitySold Số lượng vé đã bán
     * @param conn Connection có sẵn để đảm bảo chạy trong cùng transaction
     * @return true nếu cập nhật thành công, false nếu thất bại (hết vé)
     * @throws SQLException
     */
    public boolean updateInventoryAfterSale(int ticketInfoId, int quantitySold, Connection conn) throws SQLException {
        // Câu lệnh UPDATE kiểm tra số lượng có sẵn để tránh bán vé âm
        String sql = "UPDATE dbo.TicketInventory SET SoldQuantity = SoldQuantity + ? WHERE TicketInfoID = ? AND (TotalQuantity - SoldQuantity - ReservedQuantity) >= ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quantitySold);
            ps.setInt(2, ticketInfoId);
            ps.setInt(3, quantitySold);

            int affectedRows = ps.executeUpdate();

            // Nếu không có dòng nào được cập nhật, nghĩa là không đủ vé -> trả về false
            return affectedRows > 0;
        }
    }
}
