/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import Interfaces.IUserDAO;
import dao.UserDAO;
import jakarta.mail.MessagingException;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.Random;
import models.User;
import utils.EmailUtil;

/**
 *
 * @author Huy Nguyen
 */
@WebServlet("/sendResetOTP")
public class SendResetOTPServlet extends HttpServlet {
    private final IUserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        User user = userDAO.getUserByEmail(email);

        if (user == null) {
            request.setAttribute("error", "Email không tồn tại.");
            request.getRequestDispatcher("authentication/forgotPassword.jsp").forward(request, response);
            return;
        }

        String otp = String.valueOf(new Random().nextInt(900000) + 100000);
        HttpSession session = request.getSession();
        session.setAttribute("otp", otp);
        session.setAttribute("emailForReset", email);

        try {
            EmailUtil.sendEmail(email, "Mã xác nhận đặt lại mật khẩu", "Mã xác nhận OTP của bạn là: " + otp);
            response.sendRedirect("authentication/resetPassword.jsp");
        } catch (MessagingException e) {
            request.setAttribute("error", "Gửi email thất bại.");
            request.getRequestDispatcher("authentication/forgotPassword.jsp").forward(request, response);
        }
    }
}
