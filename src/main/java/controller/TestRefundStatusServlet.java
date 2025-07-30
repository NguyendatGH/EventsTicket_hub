package controller;

import dao.OrderDAO;
import dto.UserDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/test-refund-status")
public class TestRefundStatusServlet extends HttpServlet {
    
    private OrderDAO orderDAO;
    
    @Override
    public void init() throws ServletException {
        orderDAO = new OrderDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        
        try {
            HttpSession session = request.getSession(false);
            UserDTO currentUser = (session != null) ? (UserDTO) session.getAttribute("user") : null;
            
            if (currentUser == null) {
                response.getWriter().println("<h1>❌ Error: User not logged in</h1>");
                return;
            }
            
            response.getWriter().println("<h1>🔧 Test Refund Status for User: " + currentUser.getId() + "</h1>");
            
            // Lấy danh sách đơn hàng với thông tin refund
            List<Map<String, Object>> orders = orderDAO.getSimpleOrdersByUserId(currentUser.getId());
            
            response.getWriter().println("<h2>Orders with Refund Status:</h2>");
            response.getWriter().println("<table border='1' style='border-collapse: collapse; width: 100%;'>");
            response.getWriter().println("<tr style='background-color: #f0f0f0;'>");
            response.getWriter().println("<th>Order ID</th>");
            response.getWriter().println("<th>Event Name</th>");
            response.getWriter().println("<th>Total Amount</th>");
            response.getWriter().println("<th>Can Refund</th>");
            response.getWriter().println("<th>Refund Status</th>");
            response.getWriter().println("<th>Refund Info</th>");
            response.getWriter().println("<th>Refund Amount</th>");
            response.getWriter().println("</tr>");
            
            for (Map<String, Object> order : orders) {
                response.getWriter().println("<tr>");
                response.getWriter().println("<td>" + order.get("orderId") + "</td>");
                response.getWriter().println("<td>" + order.get("eventName") + "</td>");
                response.getWriter().println("<td>" + order.get("totalAmount") + "đ</td>");
                response.getWriter().println("<td>" + order.get("canRefund") + "</td>");
                response.getWriter().println("<td>" + order.get("refundStatus") + "</td>");
                response.getWriter().println("<td>" + order.get("refundInfo") + "</td>");
                response.getWriter().println("<td>" + order.get("refundAmount") + "</td>");
                response.getWriter().println("</tr>");
            }
            
            response.getWriter().println("</table>");
            
            response.getWriter().println("<br><h2>✅ Test Completed</h2>");
            response.getWriter().println("<p>If you can see the table above, the refund status integration is working correctly!</p>");
            
        } catch (Exception e) {
            System.err.println("Error testing refund status: " + e.getMessage());
            e.printStackTrace();
            response.getWriter().println("<h1>❌ Error</h1>");
            response.getWriter().println("<p>Error: " + e.getMessage() + "</p>");
            response.getWriter().println("<pre>" + e.getStackTrace() + "</pre>");
        }
    }
} 