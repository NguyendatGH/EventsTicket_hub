/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package Interfaces;

import models.User;

public interface IUserDAO {
    User login(String email, String password);
    
    boolean insertUser(User user);
    boolean isEmailTaken(String email);
}

