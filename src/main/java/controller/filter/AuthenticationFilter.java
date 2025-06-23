/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

// [QUAN TRỌNG] Khai báo tất cả các URL cần đăng nhập để truy cập
@WebFilter(urlPatterns = {
    "/SeatPaymentServlet",
    "/PaymentServlet",
    "/ProcessPaymentServlet",
    "/VNPayPaymentServlet",
    "/BookChairServlet"
// Thêm các URL khác cần bảo vệ vào đây, ví dụ: "/profile/*"
})
public class AuthenticationFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false); // Lấy session, không tạo mới

        // Kiểm tra xem session có tồn tại và có chứa thuộc tính "user" không
        if (session != null && session.getAttribute("user") != null) {
            // Nếu người dùng đã đăng nhập, cho phép yêu cầu đi tiếp đến servlet đích
            chain.doFilter(request, response);
        } else {
            // Nếu người dùng chưa đăng nhập, chuyển hướng về trang đăng nhập
            res.sendRedirect(req.getContextPath() + "/login.jsp"); // Hoặc trỏ đến LoginServlet của bạn
        }
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Không cần code ở đây
    }

    @Override
    public void destroy() {
        // Không cần code ở đây
    }
}
