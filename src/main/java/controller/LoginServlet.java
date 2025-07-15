package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

import dto.UserDTO;
import service.UserService;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("authentication/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        UserDTO user = userService.login(email, password);
        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            String getRole = "";
            try {

                getRole = userService.whoisLoggedin(user.getId());

            } catch (SQLException e) {
                e.printStackTrace();
            }
            if (getRole.equalsIgnoreCase("admin")) {
                response.sendRedirect(request.getContextPath() + "/admin-servlet");
                return;
            } else if (getRole.equalsIgnoreCase("event_owner")) {
                response.sendRedirect(request.getContextPath() + "/organizer-servlet");
                return;>>>>>>> main
            } else {
                String redirectURL = request.getParameter("redirect");
                if (redirectURL != null && !redirectURL.isEmpty()) {
                    response.sendRedirect(redirectURL);
                } else {
                    response.sendRedirect(request.getContextPath() + "/");
                }
            }
        } else {

            request.setAttribute("error", "Email hoặc mật khẩu không đúng!");
            request.getRequestDispatcher("authentication/login.jsp").forward(request, response);
        }
    }
}