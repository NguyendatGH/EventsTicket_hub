/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.*;

import Interfaces.IUserDAO;
import models.User;
import context.DBConnection;
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

    //Thêm người dùng là "Customer"
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

    //Update profile của "Customer"
    @Override
    public boolean updateProfile(User user) {
        String sql = "UPDATE Users SET Gender = ?, Birthday = ?, PhoneNumber = ?, Address = ?, Avatar = ?, UpdatedAt = ? WHERE Id = ?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, user.getGender());
            stmt.setDate(2, new java.sql.Date(user.getBirthday().getTime()));
            stmt.setString(3, user.getPhoneNumber());
            stmt.setString(4, user.getAddress());
            stmt.setString(5, user.getAvatar()); // Thêm dòng này để cập nhật avatar
            stmt.setTimestamp(6, Timestamp.valueOf(java.time.LocalDateTime.now()));
            stmt.setInt(7, user.getId());

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean updatePasswordByEmail(String email, String newPassword) {
        String sql = "UPDATE Users SET PasswordHash = ?, UpdatedAt = ? WHERE Email = ? AND IsDeleted = 0";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, newPassword);
            stmt.setTimestamp(2, Timestamp.valueOf(java.time.LocalDateTime.now()));
            stmt.setString(3, email);

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean changePassword(int userId, String oldPassword, String newPassword) {
        String checkSql = "SELECT PasswordHash FROM Users WHERE Id = ? AND IsDeleted = 0";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {

            checkStmt.setInt(1, userId);
            ResultSet rs = checkStmt.executeQuery();

            if (rs.next()) {
                String currentHashedPassword = rs.getString("PasswordHash");
                String oldPasswordHash = HashUtil.sha256(oldPassword);

                if (!currentHashedPassword.equals(oldPasswordHash)) {
                    return false; // Sai mật khẩu cũ
                }

                // Đúng mật khẩu cũ, cập nhật mật khẩu mới
                String updateSql = "UPDATE Users SET PasswordHash = ?, UpdatedAt = ? WHERE Id = ?";
                try (PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
                    String newPasswordHash = HashUtil.sha256(newPassword);
                    updateStmt.setString(1, newPasswordHash);
                    updateStmt.setTimestamp(2, Timestamp.valueOf(java.time.LocalDateTime.now()));
                    updateStmt.setInt(3, userId);

                    return updateStmt.executeUpdate() > 0;
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public User getUserByEmail(String email) {
        String sql = "SELECT * FROM users WHERE email = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setId(rs.getInt("id"));
                    user.setEmail(rs.getString("email"));
                    user.setPasswordHash(rs.getString("passwordHash"));
                    user.setRole(rs.getString("role"));

                    Timestamp createdAt = rs.getTimestamp("createdAt");
                    user.setCreatedAt(createdAt != null ? createdAt.toLocalDateTime() : null);

                    Timestamp updatedAt = rs.getTimestamp("updatedAt");
                    user.setUpdatedAt(updatedAt != null ? updatedAt.toLocalDateTime() : null);

                    user.setGender(rs.getString("gender"));

                    Date birthday = rs.getDate("birthday");
                    user.setBirthday(birthday);

                    user.setPhoneNumber(rs.getString("phoneNumber"));
                    user.setAddress(rs.getString("address"));
                    user.setAvatar(rs.getString("avatar"));
                    user.setIsDeleted(rs.getBoolean("isDeleted"));

                    Timestamp lastLoginAt = rs.getTimestamp("lastLoginAt");
                    user.setLastLoginAt(lastLoginAt != null ? lastLoginAt.toLocalDateTime() : null);

                    user.setGoogleId(rs.getString("googleId"));

                    return user;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public boolean updatePassword(int userId, String newPasswordHash) {
        String sql = "UPDATE Users SET PasswordHash = ?, UpdatedAt = CURRENT_TIMESTAMP WHERE Id = ? AND IsDeleted = 0";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, newPasswordHash);
            stmt.setInt(2, userId);

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean insertUserFromGoogle(User user) {
        String sql = "INSERT INTO Users (Email, Role, CreatedAt, IsDeleted, GoogleId) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getEmail());
            ps.setString(2, user.getRole());
            ps.setTimestamp(3, Timestamp.valueOf(user.getCreatedAt()));
            ps.setBoolean(4, user.getIsDeleted());
            ps.setString(5, user.getGoogleId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    
//  publ
}
