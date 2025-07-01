package dto;

import java.sql.Date;
import java.time.LocalDateTime;

public class AuthUserDTO {
    private int id;
    private String email;
    private String passwordHash;
    private String googleId;
    private LocalDateTime lastLoginAt;

    public AuthUserDTO() {
    }

    public AuthUserDTO(int id, String email, String passwordHash, String googleId, LocalDateTime lastLoginAt) {
        this.id = id;
        this.email = email;
        this.passwordHash = passwordHash;
        this.googleId = googleId;
        this.lastLoginAt = lastLoginAt;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getPasswordHash() { return passwordHash; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }
    public String getGoogleId() { return googleId; }
    public void setGoogleId(String googleId) { this.googleId = googleId; }
    public LocalDateTime getLastLoginAt() { return lastLoginAt; }
    public void setLastLoginAt(LocalDateTime lastLoginAt) { this.lastLoginAt = lastLoginAt; }
}