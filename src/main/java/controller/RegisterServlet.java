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

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String gender = request.getParameter("gender");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String phone = request.getParameter("phone");
        String dobStr = request.getParameter("dob");
        String country = request.getParameter("country");
        String language = request.getParameter("language");
        String address = request.getParameter("address");

        // Validation
        if (name == null || name.trim().isEmpty()) {
            request.setAttribute("error", "Họ và tên không được để trống.");
            request.getRequestDispatcher("authentication/registerUser.jsp").forward(request, response);
            return;
        }
        
        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("error", "Email không được để trống.");
            request.getRequestDispatcher("authentication/registerUser.jsp").forward(request, response);
            return;
        }
        
        if (password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Mật khẩu không được để trống.");
            request.getRequestDispatcher("authentication/registerUser.jsp").forward(request, response);
            return;
        }
        
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp.");
            request.getRequestDispatcher("authentication/registerUser.jsp").forward(request, response);
            return;
        }
        
        if (phone == null || phone.trim().isEmpty()) {
            request.setAttribute("error", "Số điện thoại không được để trống.");
            request.getRequestDispatcher("authentication/registerUser.jsp").forward(request, response);
            return;
        }
        
        if (country == null || country.trim().isEmpty()) {
            request.setAttribute("error", "Quốc gia không được để trống.");
            request.getRequestDispatcher("authentication/registerUser.jsp").forward(request, response);
            return;
        }
        
        if (language == null || language.trim().isEmpty()) {
            request.setAttribute("error", "Ngôn ngữ không được để trống.");
            request.getRequestDispatcher("authentication/registerUser.jsp").forward(request, response);
            return;
        }

        Date birthday = null;
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
            sdf.setLenient(false);
            birthday = sdf.parse(dobStr);
        } catch (ParseException e) {
            request.setAttribute("error", "Ngày sinh không hợp lệ. Định dạng đúng là dd/MM/yyyy.");
            request.getRequestDispatcher("authentication/registerUser.jsp").forward(request, response);
            return;
        }

        String passwordHash = HashUtil.sha256(password);

        User user = new User();
        user.setName(name);
        user.setEmail(email);
        user.setPasswordHash(passwordHash);
        // Fix gender case to match database constraint
        user.setGender(gender != null ? gender.substring(0, 1).toUpperCase() + gender.substring(1).toLowerCase() : "Male");
        user.setPhoneNumber(phone);
        user.setBirthday(birthday);
        user.setAddress(address);
        user.setAvatar(null);
        user.setRole("customer");
        user.setCreatedAt(LocalDateTime.now());
        user.setUpdatedAt(LocalDateTime.now());
        user.setIsLocked(false);
        user.setGoogleId(null);
        user.setLastLoginAt(null);

       
        // Generate OTP
        String otp = String.valueOf((int) (Math.random() * 900000) + 100000);

        // For testing, you can bypass email sending
        boolean bypassEmail = "true".equals(request.getParameter("bypassEmail"));
        
        if (!bypassEmail) {
            try {
                utils.EmailUtil.sendEmail(email, "Mã xác minh đăng ký", "Mã xác minh của bạn là: " + otp);
            } catch (Exception e) {
                System.err.println("Email sending error: " + e.getMessage());
                e.printStackTrace();
                request.setAttribute("error", "Không gửi được email xác minh. Kiểm tra lại địa chỉ email hoặc thử lại sau.");
                request.getRequestDispatcher("authentication/registerUser.jsp").forward(request, response);
                return;
            }
        } else {
            System.out.println("Bypassing email verification. OTP: " + otp);
        }

       
        HttpSession session = request.getSession();
        session.setAttribute("otp", otp);
        session.setAttribute("pendingUser", user);

        response.sendRedirect(request.getContextPath() + "/authentication/verify.jsp");
    }
}
