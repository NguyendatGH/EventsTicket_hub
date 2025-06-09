package controller;

import Interfaces.IUserDAO;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import models.User;
import utils.GoogleUtils;

import com.google.api.services.oauth2.model.Userinfo;
import dao.EventDAO;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;
import models.Event;

@WebServlet("/login-google")
public class GoogleLoginServlet extends HttpServlet {

    private final IUserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String code = request.getParameter("code");

        if (code == null || code.isEmpty()) {
            response.sendRedirect(GoogleUtils.getRedirectUrl());
            return;
        }

        try {
            Userinfo googleUser = GoogleUtils.getUserInfo(code);
            String email = googleUser.getEmail();
            String googleId = googleUser.getId();

            User user = userDAO.getUserByEmail(email);

            if (user == null) {
                user = new User();
                user.setEmail(email);
                user.setGoogleId(googleId);
                user.setRole("customer");
                user.setCreatedAt(LocalDateTime.now());
                user.setIsLocked(false);

                userDAO.insertUserFromGoogle(user);
                user = userDAO.getUserByEmail(email);
            }

            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            EventDAO eventDAO = new EventDAO();
            List<Event> events = eventDAO.getAllApprovedEvents();
            request.setAttribute("events", events);

            request.getRequestDispatcher("userPage/userHomePage.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("authentication/login.jsp?error=Google login failed");
        }
    }
}
