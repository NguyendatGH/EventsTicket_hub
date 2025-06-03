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
import java.sql.Date;
import java.time.LocalDateTime;
import models.User;

@WebServlet("/updateProfile")
public class UpdateProfileServlet extends HttpServlet {

    private final IUserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("userPage/updateProfile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        try {
            String gender = request.getParameter("gender");
            String birthdayStr = request.getParameter("birthday");
            String phoneNumber = request.getParameter("phoneNumber");
            String address = request.getParameter("address");
            String avatar = request.getParameter("avatar");

            user.setGender(gender);
            user.setBirthday(Date.valueOf(birthdayStr));
            user.setPhoneNumber(phoneNumber);
            user.setAddress(address);
            user.setAvatar(avatar);
            user.setUpdatedAt(LocalDateTime.now());

            boolean updated = userDAO.updateProfile(user);
            if (updated) {
                session.setAttribute("user", user); 
                request.setAttribute("success", "Cập nhật thành công.");
            } else {
                request.setAttribute("error", "Cập nhật thất bại.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Dữ liệu không hợp lệ.");
        }

        request.getRequestDispatcher("userPage/updateProfile.jsp").forward(request, response);
    }
}
