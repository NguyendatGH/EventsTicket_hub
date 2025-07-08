package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

import dto.UserDTO;
import service.UserService;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Chỉ cần hiển thị trang login
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
            if (user.getId() == 1) {
                response.sendRedirect(request.getContextPath() + "/admin-servlet");
                return;
            }
            String redirectURL = request.getParameter("redirect");
            if (redirectURL != null && !redirectURL.isEmpty()) {
                response.sendRedirect(redirectURL);
            } else {
                response.sendRedirect(request.getContextPath() + "/");
            }

        } else {

            request.setAttribute("error", "Email hoặc mật khẩu không đúng!");
            request.getRequestDispatcher("authentication/login.jsp").forward(request, response);
        }
    }
}