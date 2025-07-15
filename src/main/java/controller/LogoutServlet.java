package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.logging.Logger;

@WebServlet(name = "LogoutServlet", urlPatterns = {"/logout"})
public class LogoutServlet extends HttpServlet {

    private static final Logger logger = Logger.getLogger(LogoutServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processLogout(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processLogout(request, response);
    }

    private void processLogout(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            // Get the current session, if it exists
            HttpSession session = request.getSession(false);
            if (session != null) {
                // Invalidate the session to clear all user data
                session.invalidate();
                logger.info("User session invalidated successfully.");
            }
            // Redirect to the login page
            response.sendRedirect(request.getContextPath() + "/login");
        } catch (Exception e) {
            logger.severe("Error during logout: " + e.getMessage());
            // In case of error, still redirect to login page to avoid exposing error details
            response.sendRedirect(request.getContextPath() + "/login");
        }
    }
}