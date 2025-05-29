package Controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.RequestDispatcher;
import Model.User;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "AdminServlet", urlPatterns = { "/AdminServlet" })
public class AdminServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String action = request.getParameter("action");
            System.out.println("[AdminServlet] Action parameter: '" + action + "'");
            RequestDispatcher dispatcher;
            String targetJsp;
            if (action == null || action.trim().isEmpty() || action.equalsIgnoreCase("AdminDashboard")) {
                targetJsp = "managerPage/AdminDashboard.jsp";
            } else if ("manageUserAccount".equalsIgnoreCase(action)) {
                // Create sample user data
                List<User> userList = new ArrayList<>();
                userList.add(new User("Nguyen Van A", "aimablet@gmail.com", "password123", "22/02/2025"));
                userList.add(new User("Nguyen Van B", "user2@gmail.com", "pass456", "22/02/2025"));
                userList.add(new User("Nguyen Van C", "user3@gmail.com", "secure789", "22/02/2025"));
                userList.add(new User("Nguyen Van D", "user4@gmail.com", "mypassword", "22/02/2025"));
                userList.add(new User("Nguyen Van E", "user5@gmail.com", "testpass", "22/02/2025"));

                request.setAttribute("userList", userList);

                targetJsp = "managerPage/AdminUserManagement.jsp";
            } else if ("manageEvents".equalsIgnoreCase(action)) {

                targetJsp = "managerPage/AdminEventManagement.jsp";
            } else if("viewEventDetail".equals(action)){
                 targetJsp = "managerPage/EventOptions.jsp";
            }else {
                targetJsp = "managerPage/AdminDashboard.jsp";
            }

            dispatcher = request.getRequestDispatcher(targetJsp);
            if (dispatcher == null) {

                response.sendError(HttpServletResponse.SC_NOT_FOUND, "JSP file not found: " + targetJsp);
                return;
            }

            dispatcher.forward(request, response);

        } catch (Exception e) {
            System.err.println("[AdminServlet] Error in doGet: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Unable to process request: " + (e.getMessage() != null ? e.getMessage() : "Unknown error"));
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("[AdminServlet] Handling POST request, delegating to doGet");
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Admin Servlet for managing admin dashboard and user accounts";
    }
}