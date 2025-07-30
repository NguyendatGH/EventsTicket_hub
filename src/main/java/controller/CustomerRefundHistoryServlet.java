package controller;

import dao.RefundDAO;
import dto.UserDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Refund;
import java.io.IOException;
import java.util.List;

@WebServlet("/customer/refund-history")
public class CustomerRefundHistoryServlet extends HttpServlet {
    private RefundDAO refundDAO;

    @Override
    public void init() throws ServletException {
        refundDAO = new RefundDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        UserDTO user = (UserDTO) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Lấy danh sách yêu cầu hoàn tiền của user
        List<Refund> userRefunds = refundDAO.getRefundsByUserId(user.getId());
        
        request.setAttribute("userRefunds", userRefunds);
        request.getRequestDispatcher("/pages/CustomerRefundHistory.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
} 