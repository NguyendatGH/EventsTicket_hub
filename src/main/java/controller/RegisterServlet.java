/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.time.LocalDateTime;
import java.text.SimpleDateFormat;
import java.util.Date;

import dao.UserDAO;
import Interfaces.IUserDAO;
import java.text.ParseException;
import models.User;
import utils.HashUtil;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private final IUserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("authentication/registerUser.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String gender = request.getParameter("gender");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String phone = request.getParameter("phone");
        String dobStr = request.getParameter("dob");
        String address = request.getParameter("address");

        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp.");
            request.getRequestDispatcher("authentication/registerUser.jsp").forward(request, response);
            return;
        }

        String dob = request.getParameter("dob");
        Date birthday = null;
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
            sdf.setLenient(false); 
            birthday = sdf.parse(dob);
        } catch (ParseException e) {
            request.setAttribute("error", "Ngày sinh không hợp lệ. Định dạng đúng là dd/MM/yyyy.");
            request.getRequestDispatcher("authentication/registerUser.jsp").forward(request, response);
            return;
        }

        
        String passwordHash = HashUtil.sha256(password);

        
        User user = new User();
        user.setEmail(email);
        user.setPasswordHash(passwordHash);
        user.setGender(gender);
        user.setPhoneNumber(phone);
        user.setBirthday(birthday);
        user.setAddress(address);
        user.setAvatar(null);
        user.setRole("customer");
        user.setCreatedAt(LocalDateTime.now());
        user.setUpdatedAt(LocalDateTime.now());
        user.setIsDeleted(false);
        user.setGoogleId(null);
        user.setLastLoginAt(null);

        boolean inserted = userDAO.insertUser(user);

        if (inserted) {
            response.sendRedirect("authentication/login.jsp");
        } else {
            request.setAttribute("error", "Đăng ký thất bại. Email có thể đã tồn tại.");
            request.getRequestDispatcher("authentication/registerUser.jsp").forward(request, response);
        }
    }
}
