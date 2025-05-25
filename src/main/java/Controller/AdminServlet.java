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

            // Handle null, empty, or "?action=" cases
            if (action == null || action.trim().isEmpty() || action.equalsIgnoreCase("adminDashboard")) {
                System.out.println("[AdminServlet] Action is null or empty, forwarding to AdminDashboard.jsp");
                targetJsp = "managerPage/AdminDashboard.jsp";
            } else if ("manageUserAccount".equalsIgnoreCase(action)) {
                System.out.println("[AdminServlet] Action is manageUserAccount, preparing user data");

                // Create sample user data
                List<User> userList = new ArrayList<>();
                userList.add(new User("Nguyen Van A", "aimablet@gmail.com", "password123", "22/02/2025"));
                userList.add(new User("Nguyen Van B", "user2@gmail.com", "pass456", "22/02/2025"));
                userList.add(new User("Nguyen Van C", "user3@gmail.com", "secure789", "22/02/2025"));
                userList.add(new User("Nguyen Van D", "user4@gmail.com", "mypassword", "22/02/2025"));
                userList.add(new User("Nguyen Van E", "user5@gmail.com", "testpass", "22/02/2025"));

                // Set userList as a request attribute
                request.setAttribute("userList", userList);

                System.out.println("[AdminServlet] User list size: " + userList.size());
                targetJsp = "managerPage/AdminUserManagement.jsp"; // Point to your JSP
            } else {
                System.out.println("[AdminServlet] Unknown action: '" + action + "', defaulting to AdminDashboard.jsp");
                targetJsp = "managerPage/AdminDashboard.jsp";
            }

            System.out.println("[AdminServlet] Attempting to get RequestDispatcher for: " + targetJsp);
            dispatcher = request.getRequestDispatcher(targetJsp);
            if (dispatcher == null) {
                System.err.println("[AdminServlet] RequestDispatcher is null for: " + targetJsp);
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "JSP file not found: " + targetJsp);
                return;
            }

            System.out.println("[AdminServlet] Forwarding to: " + targetJsp);
            dispatcher.forward(request, response);
            System.out.println("[AdminServlet] Successfully forwarded to: " + targetJsp);

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