package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

import dao.UserDAO;
import Interfaces.IUserDAO;
import models.User;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final IUserDAO userDAO = new UserDAO();

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

        User user = userDAO.login(email, password);

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