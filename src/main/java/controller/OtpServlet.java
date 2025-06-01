/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class OtpServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String otp = request.getParameter("digit1") +
                     request.getParameter("digit2") +
                     request.getParameter("digit3") +
                     request.getParameter("digit4") +
                     request.getParameter("digit5");

        // Giả sử mã OTP đúng là "12345"
        if ("12345".equals(otp)) {
            request.getRequestDispatcher("success.jsp").forward(request, response);
        } else {
            response.getWriter().println("<h3 style='color:red;'>Mã OTP không đúng. Vui lòng thử lại!</h3>");
        }
    }
}
