// Dán toàn bộ mã này để thay thế file MockLoginServlet.java của bạn
package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession; // Thêm import này
import java.io.IOException;
import java.io.PrintWriter; // Thêm import này
import models.User; // << QUAN TRỌNG: Đảm bảo đường dẫn đến lớp User của bạn là chính xác

/**
 * LƯU Ý: SERVLET NÀY CHỈ DÙNG CHO MỤC ĐÍCH PHÁT TRIỂN. XÓA HOẶC VÔ HIỆU HÓA
 * TRƯỚC KHI TRIỂN KHAI SẢN PHẨM CHÍNH THỨC.
 */
// Giữ nguyên chú thích WebServlet mà IDE của bạn đã tạo
@WebServlet(name = "MockLoginServlet", urlPatterns = {"/MockLoginServlet"})
public class MockLoginServlet extends HttpServlet {

    // Trong file controller/MockLoginServlet.java
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Tạo một đối tượng User giả định
        User mockUser = new User();

        // --- Thiết lập các giá trị dựa trên lớp User thực tế của bạn ---
        mockUser.setId(99);
        mockUser.setEmail("developer@test.com"); // Dùng setEmail thay vì setName
        mockUser.setRole("USER"); // Giả sử bạn có vai trò USER

        // 2. Lấy session và lưu đối tượng user vào đó
        HttpSession session = request.getSession();
        session.setAttribute("user", mockUser);

        // 3. Hiển thị thông báo thành công
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
            // Thay đổi ở đây: dùng getEmail()
            out.println("<p>Người dùng: <strong>" + mockUser.getEmail() + "</strong></p>");
            out.println("<p><a href='" + request.getContextPath() + "/'>Bấm vào đây để quay về trang chủ</a></p>");
            out.println("</body>");
            out.println("</html>");
        }
    }
}
