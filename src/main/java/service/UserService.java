package service;

import dao.UserDAO;
import dto.UserDTO;
// import dto.AuthUserDTO;
import models.TopEventOwner;
import models.User;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class UserService {
    private final UserDAO userDAO;

    public UserService() {
        this.userDAO = new UserDAO();
    }

    public UserDTO login(String email, String password) {
        User user = userDAO.login(email, password);
        if (user != null) {
            return convertToDTO(user);
        }
        return null;
    }

    public boolean insertUser(UserDTO userDTO) {
        User user = convertToEntity(userDTO);
        return userDAO.insertUser(user);
    }

    public boolean isEmailTaken(String email) {
        return userDAO.isEmailTaken(email);
    }

    public UserDTO findDTOUserID(int id) {
        return userDAO.findID(id);
    }

    public boolean updateProfile(UserDTO userDTO) {
        User _user_find = userDAO.findWithID(userDTO.getId());
        System.out.println("user find in database : " + _user_find);
        User _user = combineObject(userDTO, _user_find);
        System.out.println("user to update/ service pack: " + _user);
        return userDAO.updateProfile(_user);
    }

    public boolean updatePasswordByEmail(String email, String newPassword) {
        return userDAO.updatePasswordByEmail(email, newPassword);
    }

    public boolean changePassword(int userId, String oldPassword, String newPassword) {
        return userDAO.changePassword(userId, oldPassword, newPassword);
    }

    public UserDTO getUserByEmail(String email) {
        User user = userDAO.getUserByEmail(email);
        if (user != null) {
            return convertToDTO(user);
        }
        return null;
    }

    public boolean updatePassword(int userId, String newPasswordHash) {
        return userDAO.updatePassword(userId, newPasswordHash);
    }

    // public boolean insertUserFromGoogle(UserDTO userDTO) {
    // User user = convertToEntity(userDTO);
    // // Assuming googleId is set separately or passed via another mechanism
    // return userDAO.insertUserFromGoogle(user);
    // }

    public int getNumOfUser() {
        return userDAO.getNumOfUser();
    }

    public List<UserDTO> getAllUserAccount() {
        List<User> users = userDAO.getAllUserAccount();
        List<UserDTO> userDTOs = new ArrayList<>();
        for (User user : users) {
            userDTOs.add(convertToDTO(user));
        }
        return userDTOs;
    }

    public boolean changeUserAccountStatus(int id, int status) {
        return userDAO.changeUserAccountStatus(id, status);
    }

    public List<TopEventOwner> getTopEventOwner(int count) {
        return userDAO.getTopEventOwner(count);
    }

    public Map<String, Integer> getUserRoleDistribution() {
        return userDAO.getUserRoleDistribution();
    }

    public Map<String, Map<String, Integer>> getLoginDistributionByMonth() {
        return userDAO.getLoginDistributionByMonth();
    }

    private UserDTO convertToDTO(User user) {
        return new UserDTO(
                user.getId(),
                user.getName(),
                user.getEmail(),
                user.getGender(),
                user.getBirthday() != null ? new java.sql.Date(user.getBirthday().getTime()) : null,
                user.getPhoneNumber(),
                user.getAddress(),
                user.getAvatar(),
                user.getIsLocked(),
                user.getCreatedAt(),
                user.getUpdatedAt(),
                user.getRole(),
                user.getLastLoginAt());
    }

    private User combineObject(UserDTO userDTO, User user) {
        user.setName(userDTO.getName());
        user.setEmail(userDTO.getEmail());
        user.setGender(userDTO.getGender());
        user.setBirthday(userDTO.getBirthday());
        user.setPhoneNumber(userDTO.getPhoneNumber());
        user.setAddress(userDTO.getAddress());
        user.setAvatar(userDTO.getAvatar());
        return user;
    }

    private User convertToEntity(UserDTO userDTO) {
        User user = new User();
        user.setId(userDTO.getId());
        user.setEmail(userDTO.getEmail());
        user.setGender(userDTO.getGender());
        user.setBirthday(userDTO.getBirthday());
        user.setPhoneNumber(userDTO.getPhoneNumber());
        user.setAddress(userDTO.getAddress());
        user.setAvatar(userDTO.getAvatar());
        user.setLastLoginAt(userDTO.getLastLoginAt());
        // Sensitive fields (role, createdAt, updatedAt, isLocked, passwordHash,
        // googleId) are not set
        return user;
    }

    public String whoisLoggedin(int userId) throws IOException, SQLException {

      return userDAO.checkRole(userId);
    }
}
