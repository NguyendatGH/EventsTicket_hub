package models;

import java.util.Date;

public class User {
    private String username;
    private String email;
    private String password;
    private String createdDate;

    public User(String username, String email, String password, String createdDate) {
        this.username = username;
        this.email = email;
        this.password = password;
        this.createdDate = createdDate;
    }

    // Getters
    public String getUsername() {
        return username;
    }

    public String getEmail() {
        return email;
    }

    public String getPassword() {
        return password;
    }

    public String getCreatedDate() {
        return createdDate;
    }

    // Setters (optional, included for completeness)
    public void setUsername(String username) {
        this.username = username;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public void setCreatedDate(String createdDate) {
        this.createdDate = createdDate;
    }
}