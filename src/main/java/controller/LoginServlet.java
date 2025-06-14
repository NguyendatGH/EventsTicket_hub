/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

import dao.UserDAO;
import Interfaces.IUserDAO;
import dao.EventDAO;
import java.util.List;
import models.Event;
import models.User;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final IUserDAO userDAO = new UserDAO();

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

        User user = userDAO.login(email, password);

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            if (user.getId() == 1) {
                response.sendRedirect(request.getContextPath() + "/admin-servlet");
                return;
            }
            EventDAO eventDAO = new EventDAO();
            List<Event> events = eventDAO.getAllApprovedEvents();
            request.setAttribute("events", events);

            request.getRequestDispatcher("userPage/userHomePage.jsp").forward(request, response);

        } else {
            request.setAttribute("error", "Email hoặc mật khẩu không đúng!");
            request.getRequestDispatcher("authentication/login.jsp").forward(request, response);
        }
    }
}
