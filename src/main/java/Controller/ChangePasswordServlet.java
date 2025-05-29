/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Controller;

import userDAO.UserDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/ChangePasswordServlet")
public class ChangePasswordServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String oldPass = request.getParameter("oldPass");
        String newPass = request.getParameter("newPass");

        UserDAO dao = new UserDAO();

        boolean isValid = dao.checkLogin(email, oldPass);
        String message;

        if (isValid) {
            boolean updated = dao.updatePassword(email, newPass);
            message = updated ? "Password changed successfully." : "Failed to update password.";
        } else {
            message = "Old password is incorrect.";
        }

        request.setAttribute("message", message);
        request.getRequestDispatcher("change_password.jsp").forward(request, response);
    }
}

