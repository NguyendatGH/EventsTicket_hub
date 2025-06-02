/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.*;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import Interfaces.IUserDAO;
import models.User;
import context.DBConnection;
import utils.HashUtil;

public class UserDAO implements IUserDAO {
    
    
    public User login(String email, String password) {
        User user = null;
        String sql = "SELECT * FROM Users WHERE Email = ? AND PasswordHash = ? AND IsDeleted = 0";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

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
                if (created != null) user.setCreatedAt(created.toLocalDateTime());

                Timestamp updated = rs.getTimestamp("UpdatedAt");
                if (updated != null) user.setUpdatedAt(updated.toLocalDateTime());

                user.setGender(rs.getString("Gender"));
                user.setBirthday(rs.getDate("Birthday"));
                user.setPhoneNumber(rs.getString("PhoneNumber"));
                user.setAddress(rs.getString("Address"));
                user.setAvatar(rs.getString("Avatar"));
                user.setIsDeleted(rs.getBoolean("IsDeleted"));

                Timestamp lastLogin = rs.getTimestamp("LastLoginAt");
                if (lastLogin != null) user.setLastLoginAt(lastLogin.toLocalDateTime());

                user.setGoogleId(rs.getString("GoogleId"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return user;
    }

}


