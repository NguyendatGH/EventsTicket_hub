/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import Interfaces.IUserDAO;
import dao.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.User;


@WebServlet("/verify")
public class VerifyServlet extends HttpServlet {
    private final IUserDAO userDAO = new UserDAO();
    
    
    @Override
protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    request.getRequestDispatcher("authentication/verify.jsp").forward(request, response);
}

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String inputOtp = request.getParameter("otp");
        HttpSession session = request.getSession();

        String sessionOtp = (String) session.getAttribute("otp");
        User pendingUser = (User) session.getAttribute("pendingUser");

        if (sessionOtp == null || pendingUser == null) {
            response.sendRedirect("register");
            return;
        }

        if (!inputOtp.equals(sessionOtp)) {
            request.setAttribute("error", "Mã xác minh không chính xác.");
            request.getRequestDispatcher("authentication/verify.jsp").forward(request, response);
            return;
        }

        boolean inserted = userDAO.insertUser(pendingUser);
        session.removeAttribute("otp");
        session.removeAttribute("pendingUser");

        if (inserted) {
            response.sendRedirect("authentication/login.jsp");
        } else {
            request.setAttribute("error", "Đăng ký thất bại");
            request.getRequestDispatcher("authentication/registerUser.jsp").forward(request, response);
        }
    }
}