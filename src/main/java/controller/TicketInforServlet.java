package controller;

import dao.EventDAO; // Thêm import cho EventDAO
import dao.TicketInforDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.Event; // Thêm import cho model Event
import models.TicketInfor;

@WebServlet(name = "TicketInforServlet", urlPatterns = {"/TicketInforServlet"})
public class TicketInforServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Sửa Lỗi 1: Lấy đúng tên tham số "eventId"
        String eventIdParam = request.getParameter("eventId");

        // Kiểm tra nếu không có eventId
        if (eventIdParam == null || eventIdParam.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Event ID is required.");
            return;
        }

        try {
            int eventId = Integer.parseInt(eventIdParam);
            
            // Sửa Lỗi 2: Khởi tạo DAO và lấy dữ liệu Event và Ticket
            EventDAO eventDAO = new EventDAO();
            TicketInforDAO ticketDAO = new TicketInforDAO();

            // Lấy đối tượng Event
            Event event = eventDAO.getEventById(eventId);

            // Rất quan trọng: Kiểm tra Event có tồn tại không
            if (event == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Event not found.");
                return;
            }

            // Lấy danh sách các loại vé của Event đó
            List<TicketInfor> listTicket = ticketDAO.getTicketInfosByEventID(eventId); // Giả sử bạn có phương thức này

            // Đặt cả hai đối tượng vào request để JSP sử dụng
            request.setAttribute("event", event); // Gửi đối tượng Event
            request.setAttribute("listTicket", listTicket); // Gửi danh sách vé

            // Chuyển tiếp đến JSP
            request.getRequestDispatcher("/pages/TicketInfor.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid Event ID format.");
        } catch (Exception e) {
            e.printStackTrace(); // In lỗi ra log để debug
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "An unexpected error occurred.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Hiện tại, doPost có thể để trống hoặc gọi doGet nếu cần
        doGet(request, response);
    }
}