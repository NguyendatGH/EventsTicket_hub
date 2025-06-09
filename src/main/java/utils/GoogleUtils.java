/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package utils;

import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier;
import com.google.api.client.googleapis.auth.oauth2.GoogleTokenResponse;
import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeTokenRequest;
import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeFlow;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.jackson2.JacksonFactory;
import com.google.api.services.oauth2.model.Userinfo;
import com.google.api.services.oauth2.Oauth2;

import java.io.IOException;
import java.security.GeneralSecurityException;
import java.util.Collections;

public class GoogleUtils {

    private static final String CLIENT_ID = "Your Client ID";
    private static final String CLIENT_SECRET = "Your Client Secret";
    private static final String REDIRECT_URI = "http://localhost:8080/OnlineSellingTicketEvents/login-google";

    public static String getRedirectUrl() {
        return "https://accounts.google.com/o/oauth2/auth?"
                + "scope=email%20profile"
                + "&redirect_uri=" + REDIRECT_URI
                + "&response_type=code"
                + "&client_id=" + CLIENT_ID
                + "&approval_prompt=force"
                + "&access_type=offline";
    }

    public static Userinfo getUserInfo(String code) throws IOException, GeneralSecurityException {
        GoogleTokenResponse response = new GoogleAuthorizationCodeTokenRequest(
                new NetHttpTransport(),
                JacksonFactory.getDefaultInstance(),
                "https://oauth2.googleapis.com/token",
                CLIENT_ID,
                CLIENT_SECRET,
                code,
                REDIRECT_URI)
                .execute();

        GoogleIdToken idToken = response.parseIdToken();
        GoogleIdToken.Payload payload = idToken.getPayload();

        Oauth2 oauth2 = new Oauth2.Builder(
                new NetHttpTransport(), JacksonFactory.getDefaultInstance(), null)
                .setApplicationName("Google Login")
                .build();

        return oauth2.userinfo().get().setOauthToken(response.getAccessToken()).execute();
    }
}
