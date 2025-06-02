// File: src/main/java/Controller/TicketInforServlet.java
package Controller;

import Dao.TicketInforDAO; // Đảm bảo đúng tên package của DAO
import Models.TicketInfor; // Đảm bảo đúng tên package của Model
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "TicketInforServlet", urlPatterns = {"/TicketInforServlet"})
public class TicketInforServlet extends HttpServlet {

    private TicketInforDAO ticketInfoDAO; // Khai báo instance của DAO

    @Override
    public void init() throws ServletException {
        // Khởi tạo DAO khi Servlet được khởi tạo
        ticketInfoDAO = new TicketInforDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy eventID từ request
        String idParam = request.getParameter("id");
        int eventID; // Khởi tạo eventID để sử dụng sau này

        if (idParam == null || idParam.isEmpty()) {
            // Nếu không có EventID, lấy tất cả các loại vé đang hoạt động
            // Đây là một cách để hiển thị mặc định nếu không có tham số ID
            // Hoặc bạn có thể chọn gửi lỗi hoặc chuyển hướng
            System.out.println("No event ID provided, fetching all active tickets.");
            List<TicketInfor> listTicket = ticketInfoDAO.getAllTicketInfo(); // Lấy tất cả vé
            request.setAttribute("listTicket", listTicket);
        } else {
            try {
                eventID = Integer.parseInt(idParam);
                List<TicketInfor> listTicket = ticketInfoDAO.getTicketInfosByEventID(eventID);
                request.setAttribute("listTicket", listTicket); // Đặt danh sách vé vào request
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid event ID format.");
                return;
            } catch (Exception e) {
                // Xử lý các lỗi khác từ DAO hoặc DB
                e.printStackTrace();
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error retrieving ticket information.");
                return;
            }
        }

        // Đặt thông tin sự kiện tĩnh (bạn có thể lấy từ DB nếu có bảng Events)
        request.setAttribute("eventName", "THE WHISPER #2 | \"TÌNH ĐƠN PHƯƠNG\" - LAM TRƯỜNG");
        request.setAttribute("eventTime", "20:00, 19 tháng 7, 2025");
        request.setAttribute("eventLocation", "Sofi"); // Địa điểm thực tế

        // Chuyển tiếp đến JSP (TicketDetail.jsp như bạn đã chỉ định)
        request.getRequestDispatcher("TicketDetail.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Hiện tại, doPost chỉ gọi doGet, bạn có thể mở rộng logic này
        // để xử lý việc người dùng gửi số lượng vé đã chọn.
        // Ví dụ: Lưu vào session hoặc gửi đến trang thanh toán.
        doGet(request, response);
    }
}
