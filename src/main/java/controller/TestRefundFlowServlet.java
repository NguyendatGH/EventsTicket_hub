package controller;

import dao.RefundDAO;
import dao.OrderDAO;
import dto.UserDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Refund;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@WebServlet("/test-refund-flow")
public class TestRefundFlowServlet extends HttpServlet {
    
    private RefundDAO refundDAO;
    private OrderDAO orderDAO;
    
    @Override
    public void init() throws ServletException {
        refundDAO = new RefundDAO();
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
            
            response.getWriter().println("<h1>🔧 Test Refund Flow for User: " + currentUser.getId() + "</h1>");
            
            // Test 1: Tạo test refund request
            response.getWriter().println("<h2>Test 1: Creating Test Refund Request</h2>");
            
            // Lấy order đầu tiên của user để test
            List<Map<String, Object>> orders = orderDAO.getSimpleOrdersByUserId(currentUser.getId());
            if (orders.isEmpty()) {
                response.getWriter().println("<p style='color: orange;'>⚠️ User has no orders to test refund</p>");
                return;
            }
            
            int testOrderId = (Integer) orders.get(0).get("orderId");
            BigDecimal orderAmount = (BigDecimal) orders.get(0).get("totalAmount");
            
            response.getWriter().println("<p>Using Order ID: " + testOrderId + " with amount: " + orderAmount + "đ</p>");
            
            // Tạo refund request
            Refund testRefund = new Refund();
            testRefund.setOrderId(testOrderId);
            testRefund.setUserId(currentUser.getId());
            testRefund.setRefundAmount(orderAmount);
            testRefund.setRefundReason("Test refund request - " + LocalDateTime.now());
            testRefund.setRefundStatus("pending");
            testRefund.setRefundRequestDate(LocalDateTime.now());
            testRefund.setCreatedAt(LocalDateTime.now());
            testRefund.setUpdatedAt(LocalDateTime.now());
            
            boolean success = refundDAO.insertRefund(testRefund);
            if (success) {
                response.getWriter().println("<p style='color: green;'>✅ Test refund request created successfully</p>");
            } else {
                response.getWriter().println("<p style='color: red;'>❌ Failed to create test refund request</p>");
            }
            
            // Test 2: Kiểm tra refund status trong order list
            response.getWriter().println("<h2>Test 2: Checking Refund Status in Order List</h2>");
            List<Map<String, Object>> updatedOrders = orderDAO.getSimpleOrdersByUserId(currentUser.getId());
            
            for (Map<String, Object> order : updatedOrders) {
                if (order.get("orderId").equals(testOrderId)) {
                    response.getWriter().println("<p>Order ID: " + order.get("orderId") + "</p>");
                    response.getWriter().println("<p>Can Refund: " + order.get("canRefund") + "</p>");
                    response.getWriter().println("<p>Refund Status: " + order.get("refundStatus") + "</p>");
                    response.getWriter().println("<p>Refund Info: " + order.get("refundInfo") + "</p>");
                    break;
                }
            }
            
            // Test 3: Admin approve refund
            response.getWriter().println("<h2>Test 3: Admin Approving Refund</h2>");
            
            // Lấy refund vừa tạo
            List<Refund> userRefunds = refundDAO.getRefundsByUserId(currentUser.getId());
            if (!userRefunds.isEmpty()) {
                Refund latestRefund = userRefunds.get(0); // Lấy refund mới nhất
                
                boolean approveSuccess = refundDAO.updateRefundStatus(latestRefund.getRefundId(), "approved", 1); // Admin ID = 1
                if (approveSuccess) {
                    response.getWriter().println("<p style='color: green;'>✅ Refund approved by admin</p>");
                } else {
                    response.getWriter().println("<p style='color: red;'>❌ Failed to approve refund</p>");
                }
                
                // Test 4: Kiểm tra lại trạng thái sau khi approve
                response.getWriter().println("<h2>Test 4: Checking Status After Approval</h2>");
                List<Map<String, Object>> finalOrders = orderDAO.getSimpleOrdersByUserId(currentUser.getId());
                
                for (Map<String, Object> order : finalOrders) {
                    if (order.get("orderId").equals(testOrderId)) {
                        response.getWriter().println("<p>Order ID: " + order.get("orderId") + "</p>");
                        response.getWriter().println("<p>Can Refund: " + order.get("canRefund") + "</p>");
                        response.getWriter().println("<p>Refund Status: " + order.get("refundStatus") + "</p>");
                        response.getWriter().println("<p>Refund Info: " + order.get("refundInfo") + "</p>");
                        response.getWriter().println("<p>Refund Amount: " + order.get("refundAmount") + "</p>");
                        break;
                    }
                }
            }
            
            response.getWriter().println("<br><h2>✅ Refund Flow Test Completed</h2>");
            response.getWriter().println("<p>If you can see all the steps above, the refund flow is working correctly!</p>");
            
        } catch (Exception e) {
            System.err.println("Error testing refund flow: " + e.getMessage());
            e.printStackTrace();
            response.getWriter().println("<h1>❌ Error</h1>");
            response.getWriter().println("<p>Error: " + e.getMessage() + "</p>");
        }
    }
} 