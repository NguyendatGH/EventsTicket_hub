/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import userDAO.UserDAO;

@WebServlet("/ForgotPasswordServlet")
public class ForgotPasswordServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        UserDAO userDAO = new UserDAO();
        String newPassword = userDAO.resetPassword(email);

        if (newPassword != null) {
            request.setAttribute("message", "Your new password is: " + newPassword);
        } else {
            request.setAttribute("error", "Email not found or update failed.");
        }
        request.getRequestDispatcher("forgot_password.jsp").forward(request, response);

    }
}
