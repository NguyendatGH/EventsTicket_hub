package controller;

import dao.EventDAO; 
import dao.GenreDAO; // Vẫn giữ nếu bạn có các thao tác khác liên quan đến Genre
import models.Event;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import models.Genre; 
import models.User; 

@WebServlet("/")
public class HomePageServlet extends HttpServlet {

    private static final int RECORDS_PER_PAGE = 10; // Đã thay đổi thành 10 sự kiện trên mỗi trang

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Khởi tạo EventDAO - mỗi phương thức trong DAO sẽ tự động lấy và đóng kết nối
        EventDAO eventDAO = new EventDAO();
        // Nếu bạn có các thao tác liên quan đến GenreDAO và nó cũng sử dụng DBConnection tương tự,
        // bạn sẽ khởi tạo nó ở đây:
        // GenreDAO genreDAO = new GenreDAO(); 

        try {
            int currentPage = 1;
            if (request.getParameter("page") != null) {
                try {
                    currentPage = Integer.parseInt(request.getParameter("page"));
                    if (currentPage < 1) currentPage = 1; 
                } catch (NumberFormatException e) {
                    currentPage = 1;
                }
            }

            int offset = (currentPage - 1) * RECORDS_PER_PAGE;
            
            // Gọi các phương thức của EventDAO để lấy dữ liệu phân trang
            List<Event> events = eventDAO.getApprovedEventsPaginated(offset, RECORDS_PER_PAGE);
            int totalEvents = eventDAO.getTotalApprovedEventsCount();
            int noOfPages = (int) Math.ceil(totalEvents * 1.0 / RECORDS_PER_PAGE);

            // Đặt các thuộc tính vào request để JSP có thể truy cập
            request.setAttribute("events", events);
            request.setAttribute("noOfPages", noOfPages);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalEvents", totalEvents);

            // Chuyển tiếp request đến JSP để hiển thị
            request.getRequestDispatcher("/pages/homePage.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace(); // In lỗi ra console để gỡ lỗi
            // Gửi lỗi 500 cho client
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Có lỗi xảy ra khi tải sự kiện: " + e.getMessage());
        }
        // KHÔNG cần đóng kết nối ở đây vì mỗi phương thức DAO đã tự động đóng kết nối của nó.
    }
}