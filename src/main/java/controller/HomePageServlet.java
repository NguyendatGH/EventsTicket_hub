/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.EventDAO;
import models.Event;
import dto.UserDTO; // Import the User model
import models.Notification; // Import the Notification model // Import the NotificationService
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession; 
import java.util.List;
import java.util.ArrayList;
import service.NotificationService;


@WebServlet("/") 
public class HomePageServlet extends HttpServlet {

    private EventDAO eventDAO;
    private NotificationService notificationService;

    @Override
    public void init() throws ServletException {
        super.init(); // Call super.init() for proper servlet initialization
        eventDAO = new EventDAO();
        notificationService = new NotificationService(); // Initialize the service
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        

        HttpSession session = request.getSession(false);
        UserDTO user = null;
        if (session != null) {
            user = (UserDTO) session.getAttribute("user");
        }


        List<Notification> notifications = new ArrayList<>();
        int unreadCount = 0;

        if (user != null) {
            notifications = notificationService.getUserNotifications(user.getId());
            unreadCount = notificationService.getUnreadNotificationsCount(user.getId());
        }
        

        request.setAttribute("notifications", notifications);
        request.setAttribute("unreadCount", unreadCount);

        List<Event> events = eventDAO.getAllApprovedEvents();
        request.setAttribute("events", events);
        request.getRequestDispatcher("/pages/homePage.jsp").forward(request, response);
    }
}
