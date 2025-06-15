package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "ProcessPaymentServlet", urlPatterns = {"/ProcessPaymentServlet"})
public class ProcessPaymentServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null || session.getAttribute("order") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String paymentMethod = request.getParameter("paymethod");

        if (paymentMethod == null || paymentMethod.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/pages/Payment.jsp?error=no_method_selected");
            return;
        }
        
        switch (paymentMethod) {
            case "VNPAY":
                response.sendRedirect(request.getContextPath() + "/VNPayPaymentServlet");
                break;
                
            case "MOMO":
                request.setAttribute("message", "Phương thức thanh toán MoMo hiện chưa được hỗ trợ.");
                request.getRequestDispatcher("/pages/PaymentResult.jsp").forward(request, response);
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/pages/Payment.jsp?error=invalid_method");
                break;
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/");
    }
}