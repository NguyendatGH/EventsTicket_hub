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
import utils.HashUtil;

/**
 *
 * @author Huy Nguyen
 */
@WebServlet("/resetPassword")
public class ResetPasswordServlet extends HttpServlet {
    private final IUserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String inputOtp = request.getParameter("otp");
        String newPassword = request.getParameter("newPassword");

        HttpSession session = request.getSession();
        String sessionOtp = (String) session.getAttribute("otp");
        String email = (String) session.getAttribute("emailForReset");

        if (!inputOtp.equals(sessionOtp)) {
            request.setAttribute("error", "Mã OTP không đúng.");
            request.getRequestDispatcher("authentication/resetPassword.jsp").forward(request, response);
            return;
        }

        String hashed = HashUtil.sha256(newPassword);
        boolean updated = userDAO.updatePasswordByEmail(email, hashed);

        session.removeAttribute("otp");
        session.removeAttribute("emailForReset");

        if (updated) {
            response.sendRedirect("authentication/login.jsp");
        } else {
            request.setAttribute("error", "Đặt lại mật khẩu thất bại.");
            request.getRequestDispatcher("authentication/resetPassword.jsp").forward(request, response);
        }
    }
}