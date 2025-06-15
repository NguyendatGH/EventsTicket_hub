/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package Interfaces;

import java.util.List;
import java.util.Map;

import models.TopEventOwner;
import models.User;

public interface IUserDAO {

    User login(String email, String password);

    boolean insertUser(User user);

    boolean isEmailTaken(String email);

    boolean updateProfile(User user);

    boolean updatePasswordByEmail(String email, String newPassword);

    boolean changePassword(int userId, String oldPassword, String newPassword);

    User getUserByEmail(String email);

    boolean updatePassword(int userId, String newPasswordHash);

    boolean insertUserFromGoogle(User user);

    int getNumOfUser();

    List<User> getAllUserAccount();

    User findWithID(int id);

    boolean deleteUser(int id);

    List<TopEventOwner> getTopEventOwner();

    Map<String, Integer> getUserRoleDistribution();

     Map<String, Map<String, Integer>> getLoginDistributionByMonth();
}
