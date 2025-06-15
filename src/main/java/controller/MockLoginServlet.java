package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import models.User;

@WebServlet(name = "MockLoginServlet", urlPatterns = {"/MockLoginServlet"})
public class MockLoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User mockUser = new User();

        mockUser.setId(99);
        mockUser.setEmail("developer@test.com");
        mockUser.setRole("USER");

        HttpSession session = request.getSession();
        session.setAttribute("user", mockUser);

        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Mock Login</title>");
            out.println("<style>body { font-family: sans-serif; text-align: center; margin-top: 50px; }</style>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Đăng nhập giả thành công!</h1>");
            out.println("<p>Một người dùng mẫu đã được tạo và lưu vào session.</p>");
            out.println("<p>Người dùng: <strong>" + mockUser.getEmail() + "</strong></p>");
            out.println("<p><a href='" + request.getContextPath() + "/'>Bấm vào đây để quay về trang chủ</a></p>");
            out.println("</body>");
            out.println("</html>");
        }
    }
}