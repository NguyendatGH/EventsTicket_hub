/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.User;
import utils.HashUtil;

@WebServlet("/changePassword")
public class ChangePasswordServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("authentication/changePassword.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect("authentication/login.jsp");
            return;
        }

        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // Hash mật khẩu hiện tại nhập vào để so sánh
        String currentHash = HashUtil.sha256(currentPassword);

        if (!user.getPasswordHash().equals(currentHash)) {
            request.setAttribute("changePasswordError", "Mật khẩu hiện tại không đúng.");
            request.getRequestDispatcher("authentication/changePassword.jsp").forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("changePasswordError", "Mật khẩu mới và xác nhận không khớp.");
            request.getRequestDispatcher("authentication/changePassword.jsp").forward(request, response);
            return;
        }

        // Hash mật khẩu mới
        String newHash = HashUtil.sha256(newPassword);

        // Cập nhật vào DB
        boolean updated = userDAO.updatePassword(user.getId(), newHash);
        if (updated) {
            // Cập nhật lại mật khẩu trong session
            user.setPasswordHash(newHash);
            request.setAttribute("changePasswordMessage", "Đổi mật khẩu thành công.");
        } else {
            request.setAttribute("changePasswordError", "Có lỗi xảy ra khi cập nhật.");
        }

        request.getRequestDispatcher("authentication/changePassword.jsp").forward(request, response);
    }
}
