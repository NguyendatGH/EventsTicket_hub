/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import Interfaces.IUserDAO;
import models.TopEventOwner;
import models.User;
import context.DBConnection;
import dto.UserDTO;
import utils.HashUtil;

public class UserDAO implements IUserDAO {

    @Override
    public User login(String email, String password) {
        User user = null;
        String sql = "SELECT * FROM Users WHERE Email = ? AND PasswordHash = ? AND IsLocked = 0";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            String hashedPassword = HashUtil.sha256(password);
            stmt.setString(1, email);
            stmt.setString(2, hashedPassword);

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                user = new User();
                user.setId(rs.getInt("Id"));
                user.setName(rs.getString("Username"));
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
                user.setIsLocked(rs.getBoolean("IsLocked"));

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

    // Thêm người dùng là "Customer"
    @Override
    public boolean insertUser(User user) {
        String sql = "INSERT INTO Users (Email, PasswordHash, Role, CreatedAt, UpdatedAt, Gender, Birthday, PhoneNumber, Address, IsLocked) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
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
            stmt.setBoolean(10, user.getIsLocked());

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

    @Override
    public boolean updateProfile(User user) {
        String sql = "UPDATE Users SET Username =?, Email = ?, Gender = ?, Birthday = ?, PhoneNumber = ?, Address = ?, Avatar = ?, UpdatedAt = ? WHERE Id = ?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, user.getName());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getGender());
            stmt.setDate(4, new java.sql.Date(user.getBirthday().getTime()));
            stmt.setString(5, user.getPhoneNumber());
            stmt.setString(6, user.getAddress());
            stmt.setString(7, user.getAvatar()); 
            stmt.setTimestamp(8, Timestamp.valueOf(java.time.LocalDateTime.now()));
            stmt.setInt(9, user.getId());

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean updatePasswordByEmail(String email, String newPassword) {
        String sql = "UPDATE Users SET PasswordHash = ?, UpdatedAt = ? WHERE Email = ? AND IsLocked = 0";

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
        String checkSql = "SELECT PasswordHash FROM Users WHERE Id = ? AND IsLocked = 0";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {

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
                    user.setName(rs.getString("Username"));
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
                    user.setIsLocked(rs.getBoolean("isLocked"));

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
        String sql = "UPDATE Users SET PasswordHash = ?, UpdatedAt = CURRENT_TIMESTAMP WHERE Id = ? AND IsLocked = 0";

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
        String sql = "INSERT INTO Users (Email, Role, CreatedAt, IsLocked, GoogleId) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getEmail());
            ps.setString(2, user.getRole());
            ps.setTimestamp(3, Timestamp.valueOf(user.getCreatedAt()));
            ps.setBoolean(4, user.getIsLocked());
            ps.setString(5, user.getGoogleId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public int getNumOfUser() {
        int res = 0;
        String sql = "SELECT COUNT(*) FROM Users;";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                res = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return res;
    }

    @Override
    public List<User> getAllUserAccount() {
        List<User> list = new ArrayList<>();
        String sql = "select * from users u where u.role != 'admin';";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("Id"));
                user.setName(rs.getString("Username"));
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
                user.setIsLocked(rs.getBoolean("IsLocked"));

                Timestamp lastLogin = rs.getTimestamp("LastLoginAt");
                if (lastLogin != null) {
                    user.setLastLoginAt(lastLogin.toLocalDateTime());
                }

                user.setGoogleId(rs.getString("GoogleId"));

                list.add(user);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    @Override
    public User findWithID(int id) {
        String sql = "Select * from Users where id = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("Id"));
                user.setName(rs.getString("Username"));
                user.setEmail(rs.getString("Email"));
                user.setPasswordHash(rs.getString("PasswordHash"));
                user.setRole(rs.getString("Role"));
                user.setGender(rs.getString("Gender"));
                user.setBirthday(rs.getDate("Birthday"));
                user.setPhoneNumber(rs.getString("PhoneNumber"));
                user.setAddress(rs.getString("Address"));
                user.setAvatar(rs.getString("Avatar"));
                user.setIsLocked(rs.getBoolean("IsLocked"));
                Timestamp lastLogin = rs.getTimestamp("LastLoginAt");
                if (lastLogin != null) {
                    user.setLastLoginAt(lastLogin.toLocalDateTime());
                }
                user.setGoogleId(rs.getString("GoogleId"));
                System.out.println("find core user: " + user);
                return user;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public UserDTO findID(int id) {
        String sql = "Select * from Users where id = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                UserDTO user = new UserDTO();
                user.setId(rs.getInt("Id"));
                user.setName(rs.getString("Username"));
                user.setEmail(rs.getString("Email"));

                user.setGender(rs.getString("Gender"));
                user.setBirthday(rs.getDate("Birthday"));
                user.setPhoneNumber(rs.getString("PhoneNumber"));
                user.setAddress(rs.getString("Address"));
                user.setAvatar(rs.getString("Avatar"));
                user.setIsLocked(rs.getBoolean("IsLocked"));
                Timestamp lastLogin = rs.getTimestamp("LastLoginAt");
                if (lastLogin != null) {
                    user.setLastLoginAt(lastLogin.toLocalDateTime());
                }

                // System.out.println("find user dto: " + user);
                return user;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public boolean changeUserAccountStatus(int id, int status) {
        // status = 0 -> lock, status = 1 -> unlock
        String sql = "";
        if (status == 0) {
            sql = "Update Users SET isLocked = 1 where id = ?";
        } else {
            sql = "Update Users SET isLocked = 0 where id = ?";
        }

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            int rowsUpdated = stmt.executeUpdate();

            return rowsUpdated > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean updateUserInfo(User u) {
        return true;
    }

    @Override
    public List<TopEventOwner> getTopEventOwner(int count) {
        List<TopEventOwner> list = new ArrayList<>();
        Connection conn = null;
        CallableStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            String sql = "{call GetTopEventOrganizers(?)}";
            stmt = conn.prepareCall(sql);
            stmt.setInt(1, count);

            rs = stmt.executeQuery();

            while (rs.next()) {
                TopEventOwner owner = new TopEventOwner();
                owner.setId(rs.getInt("Id"));
                owner.setName(rs.getString("Tên tổ chức"));
                owner.setNumsOfEvent(rs.getInt("Số sự kiện"));
                owner.setNumsOfTicketSelled(rs.getInt("Tổng vé đã bán"));
                owner.setTotalRevenue(rs.getDouble("Tổng doanh thu"));
                owner.setStatus(rs.getBoolean("Trạng thái tài khoản"));
                owner.setAvatarURL(rs.getString("Avatar"));
                list.add(owner);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null)
                    rs.close();
                if (stmt != null)
                    stmt.close();
                if (conn != null)
                    conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return list;
    }

    @Override
    public Map<String, Integer> getUserRoleDistribution() {
        Map<String, Integer> roleDistribution = new HashMap<>();
        String sql = "SELECT Role, COUNT(*) as count FROM Users GROUP BY Role";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                roleDistribution.put(rs.getString("Role"), rs.getInt("count"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return roleDistribution;
    }

    @Override
    public Map<String, Map<String, Integer>> getLoginDistributionByMonth() {
        Map<String, Map<String, Integer>> loginDistribution = new HashMap<>();
        Map<String, Integer> newUsersLogin = new HashMap<>();
        Map<String, Integer> oldUsersLogin = new HashMap<>();

        String sql = "SELECT FORMAT(LastLoginAt, 'yyyy-MM') as LoginMonth, " +
                "CASE WHEN CreatedAt >= DATEADD(MONTH, -3, GETDATE()) THEN 'new' ELSE 'old' END as UserType, " +
                "COUNT(*) as LoginCount " +
                "FROM Users " +
                "WHERE LastLoginAt IS NOT NULL AND Role != 'admin' " +
                "GROUP BY FORMAT(LastLoginAt, 'yyyy-MM'), " +
                "         CASE WHEN CreatedAt >= DATEADD(MONTH, -3, GETDATE()) THEN 'new' ELSE 'old' END " +
                "ORDER BY LoginMonth";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql);
                ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                String loginMonth = rs.getString("LoginMonth");
                String userType = rs.getString("UserType");
                int loginCount = rs.getInt("LoginCount");
                System.out.println("Month: " + loginMonth + ", Type: " + userType + ", Count: " + loginCount);
                if ("new".equals(userType)) {
                    newUsersLogin.put(loginMonth, loginCount);
                } else {
                    oldUsersLogin.put(loginMonth, loginCount);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        loginDistribution.put("new", newUsersLogin);
        loginDistribution.put("old", oldUsersLogin);
        return loginDistribution;
    }
    

    public String checkRole(int userId) throws IOException, SQLException {
        String res = "";
        String sql = "SELECT Role FROM Users WHERE Id = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, userId);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    res = rs.getString("Role");
                }
            }
        }

        return res;
    }
}
