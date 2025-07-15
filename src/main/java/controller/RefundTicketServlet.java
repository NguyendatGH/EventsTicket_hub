package controller;

import dao.RefundDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "RefundTicketServlet", urlPatterns = {"/RefundTicketServlet"})
public class RefundTicketServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String orderIdParam = request.getParameter("orderId");
        HttpSession session = request.getSession();
        models.User currentUser = (models.User) session.getAttribute("user");

        if (orderIdParam == null || currentUser == null) {
            session.setAttribute("flashMessage_fail", "Không đủ thông tin để hoàn vé.");
            response.sendRedirect(request.getContextPath() + "/purchased-tickets");
            return;
        }

        try {
            int orderId = Integer.parseInt(orderIdParam);
            RefundDAO refundDAO = new RefundDAO();

            if (!refundDAO.checkCanRefund(orderId, currentUser.getId())) {
                session.setAttribute("flashMessage_fail", "Vé đã quá hạn hoàn trả hoặc không hợp lệ.");
                response.sendRedirect(request.getContextPath() + "/purchased-tickets");
                return;
            }

            request.setAttribute("orderId", orderId);
            request.getRequestDispatcher("/pages/RequestRefund.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            session.setAttribute("flashMessage_error", "Mã đơn hàng không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/purchased-tickets");
        }
    }
}
