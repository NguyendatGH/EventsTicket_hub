/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.EventDAO;
import dao.OrderDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import models.Event;
import models.Order;
import models.User;

/**
 *
 * @author admin
 */
@WebServlet(name = "TicketOrderHistoryServlet", urlPatterns = {"/TicketOrderHistoryServlet"})
public class TicketOrderHistoryServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet TicketOrderHistoryServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet TicketOrderHistoryServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;

        if (currentUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            // 1. Lấy lịch sử đơn hàng (như cũ)
            OrderDAO orderDAO = new OrderDAO();
            List<Order> orderList = orderDAO.getOrdersByUserId(currentUser.getId());
            request.setAttribute("orderHistory", orderList);

            // 2. LẤY THÊM DANH SÁCH SỰ KIỆN GỢI Ý
            EventDAO eventDAO = new EventDAO();
            List<Event> suggestedEvents = eventDAO.getUpcomingEvents(); // Giả sử có phương thức này
            request.setAttribute("suggestedEvents", suggestedEvents);

            // 3. Chuyển đến trang JSP
            request.getRequestDispatcher("/pages/TicketOrderHistory.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Không thể tải dữ liệu.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
