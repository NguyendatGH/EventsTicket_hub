/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.*;

import Interfaces.IUserDAO;
import models.User;
import context.DBConnection;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import utils.HashUtil;

public class UserDAO implements IUserDAO {

    @Override
    public User login(String email, String password) {
        User user = null;
        String sql = "SELECT * FROM Users WHERE Email = ? AND PasswordHash = ? AND IsDeleted = 0";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            String hashedPassword = HashUtil.sha256(password);
            stmt.setString(1, email);
            stmt.setString(2, hashedPassword);

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                user = new User();
                user.setId(rs.getInt("Id"));
                user.setEmail(rs.getString("Email"));
                user.setPasswordHash(rs.getString("PasswordHash"));
                user.setRole(rs.getString("Role"));

                Timestamp created = rs.getTimestamp("CreatedAt");
                if (created != null) {
                    user.setCreatedAt(created.toLocalDateTime());
                }

                Timestamp updated = rs.getTimestamp("UpdatedAt");
                if (updated != null) {
                    user.setUpdatedAt(updated.toLocalDateTime());
                }

                user.setGender(rs.getString("Gender"));
                user.setBirthday(rs.getDate("Birthday"));
                user.setPhoneNumber(rs.getString("PhoneNumber"));
                user.setAddress(rs.getString("Address"));
                user.setAvatar(rs.getString("Avatar"));
                user.setIsDeleted(rs.getBoolean("IsDeleted"));

                Timestamp lastLogin = rs.getTimestamp("LastLoginAt");
                if (lastLogin != null) {
                    user.setLastLoginAt(lastLogin.toLocalDateTime());
                }

                user.setGoogleId(rs.getString("GoogleId"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return user;
    }

    //Thêm người dùng là khách
    @Override
    public boolean insertUser(User user) {
        String sql = "INSERT INTO Users (Email, PasswordHash, Role, CreatedAt, UpdatedAt, Gender, Birthday, PhoneNumber, Address, IsDeleted) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, user.getEmail());
            stmt.setString(2, user.getPasswordHash());
            stmt.setString(3, user.getRole());
            stmt.setTimestamp(4, Timestamp.valueOf(user.getCreatedAt()));
            stmt.setTimestamp(5, Timestamp.valueOf(user.getUpdatedAt()));
            stmt.setString(6, user.getGender());
            stmt.setDate(7, new java.sql.Date(user.getBirthday().getTime()));
            stmt.setString(8, user.getPhoneNumber());
            stmt.setString(9, user.getAddress());
            stmt.setBoolean(10, user.getIsDeleted());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }


    @Override
    public boolean isEmailTaken(String email) {
        String sql = "SELECT 1 FROM Users WHERE Email = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
            return true;
        }
    }

}
