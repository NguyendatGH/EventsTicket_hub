/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package userDAO;

import Model.User;
import dao.DBConnection;
import java.sql.*;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class UserDAO implements IUserDAO {


    private String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashedBytes = md.digest(password.getBytes(StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder();
            for (byte b : hashedBytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean checkLogin(String email, String password) {
        String sql = "SELECT * FROM Users WHERE email = ? AND passwordHash = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setString(2, hashPassword(password));

            ResultSet rs = ps.executeQuery();
            return rs.next();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }  
    public boolean updatePassword(String email, String newPassword) {
        String sql = "UPDATE Users SET passwordHash = ? WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, hashPassword(newPassword));
            ps.setString(2, email);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    public String resetPassword(String email) {
    String newPassword = generateRandomPassword(); // VD: "Abc12345"
    String hashedPassword = hashPassword(newPassword);

    String sql = "UPDATE Users SET passwordHash = ? WHERE email = ?";
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setString(1, hashedPassword);
        ps.setString(2, email);

        int updated = ps.executeUpdate();
        if (updated > 0) {
            return newPassword; // Trả lại mật khẩu mới để hiển thị hoặc gửi email
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return null;
}

private String generateRandomPassword() {
    // Tạo mật khẩu ngẫu nhiên (8 ký tự)
    String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    StringBuilder sb = new StringBuilder();
    for (int i = 0; i < 8; i++) {
        int idx = (int) (Math.random() * chars.length());
        sb.append(chars.charAt(idx));
    }
    return sb.toString();
}

}


