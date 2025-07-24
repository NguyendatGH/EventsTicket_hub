package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.SupportItem;
import service.SupportService;
import dto.UserDTO;

import java.io.IOException;
import java.util.List;

@WebServlet("/support-owner")
public class SupportOwnerServlet extends HttpServlet {
    private SupportService supportService;

    @Override
    public void init() throws ServletException {
        supportService = new SupportService();
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
        // Load all support requests by owner email
        List<SupportItem> ownerRequests = supportService.getSupportRequestsByUserEmail(user.getEmail());
        request.setAttribute("supportRequests", ownerRequests);
        request.getRequestDispatcher("/supportCenter/supportCenter_owner.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        UserDTO user = (UserDTO) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        String action = request.getParameter("action");
        if ("submit-request".equals(action)) {
            submitSupportRequest(request, response, user);
        } else {
            response.sendRedirect(request.getContextPath() + "/support-owner");
        }
    }

    private void submitSupportRequest(HttpServletRequest request, HttpServletResponse response, UserDTO user)
            throws ServletException, IOException {
        String subject = request.getParameter("subject");
        String content = request.getParameter("content");
        String category = request.getParameter("category");
        String priority = request.getParameter("priority");
        if (subject == null || subject.trim().isEmpty() ||
            content == null || content.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng điền đầy đủ thông tin!");
            doGet(request, response);
            return;
        }
        SupportItem supportItem = new SupportItem(user.getEmail(), subject, content);
        supportItem.setCategory(category != null ? category : "GENERAL");
        supportItem.setPriority(priority != null ? priority : "MEDIUM");
        supportItem.setToEmail("admin@masterticket.com");
        boolean success = supportService.createSupportRequest(supportItem);
        if (success) {
            request.setAttribute("success", "Yêu cầu hỗ trợ đã được gửi thành công! Chúng tôi sẽ phản hồi sớm nhất có thể.");
        } else {
            request.setAttribute("error", "Có lỗi xảy ra khi gửi yêu cầu hỗ trợ. Vui lòng thử lại!");
        }
        doGet(request, response);
    }
} 