/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.FeedbackDAO;
import dto.UserDTO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.time.LocalDateTime;
import models.Feedback;
import models.User;

/**
 *
 * @author admin
 */
@WebServlet(name = "SubmitFeedbackServlet", urlPatterns = {"/SubmitFeedbackServlet"})
public class SubmitFeedbackServlet extends HttpServlet {

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
            out.println("<title>Servlet SubmitFeedbackServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet SubmitFeedbackServlet at " + request.getContextPath() + "</h1>");
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
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            UserDTO user = (UserDTO) request.getSession().getAttribute("user");
            if (user == null) {
                response.sendRedirect("login.jsp");
                return;
            }

            int userID = user.getId();
            String eventIDRaw = request.getParameter("eventId");
            String orderIDRaw = request.getParameter("orderId");
            String ratingRaw = request.getParameter("rating");
            String content = request.getParameter("content");

            System.out.println("eventId = " + eventIDRaw);
            System.out.println("orderId = " + orderIDRaw);
            System.out.println("rating = " + ratingRaw);
            System.out.println("content = " + content);

            if (eventIDRaw == null || orderIDRaw == null || ratingRaw == null || content == null
                    || eventIDRaw.isEmpty() || orderIDRaw.isEmpty() || ratingRaw.equals("0") || content.trim().isEmpty()) {
                request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin đánh giá.");
                request.getRequestDispatcher("/pages/FeedbackForm.jsp").forward(request, response);
                return;
            }

            int eventID = Integer.parseInt(eventIDRaw);
            int orderID = Integer.parseInt(orderIDRaw);
            int rating = Integer.parseInt(ratingRaw);

            if (rating < 1 || rating > 5) {
                request.setAttribute("error", "Điểm đánh giá phải từ 1 đến 5.");
                request.getRequestDispatcher("/pages/FeedbackForm.jsp").forward(request, response);
                return;
            }

            LocalDateTime now = LocalDateTime.now();
            Feedback feedback = new Feedback(0, userID, eventID, orderID, rating, content, false, null, now, now);

            FeedbackDAO dao = new FeedbackDAO();
            boolean success = dao.insertFeedback(feedback);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/pages/FeedbackResult.jsp?eventId=" + eventID);
            } else {
                request.setAttribute("error", "Không thể gửi phản hồi. Vui lòng thử lại.");
                request.getRequestDispatcher("/pages/FeedbackForm.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi trong quá trình xử lý phản hồi: " + e.getMessage());
            request.getRequestDispatcher("/pages/FeedbackForm.jsp").forward(request, response);
        }
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
