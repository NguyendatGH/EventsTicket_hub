package controller;

import dao.FeedbackDAO;
import dto.UserDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.Feedback;

import java.io.IOException;
import java.time.LocalDateTime;

@WebServlet(urlPatterns = {"/UpdateFeedbackServlet"})
public class UpdateFeedbackServlet extends HttpServlet {

    private FeedbackDAO feedbackDAO;

    @Override
    public void init() throws ServletException {
        feedbackDAO = new FeedbackDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int feedbackID = Integer.parseInt(request.getParameter("feedbackID"));
            int newRating = Integer.parseInt(request.getParameter("rating"));
            String newContent = request.getParameter("content");

            UserDTO currentUser = (UserDTO) request.getSession().getAttribute("user");

            Feedback fb = feedbackDAO.getFeedbackById(feedbackID);
            if (fb == null || currentUser == null || currentUser.getId() != fb.getUserID()) {
                response.sendRedirect("access-denied.jsp");
                return;
            }

            feedbackDAO.updateFeedbackContentAndRating(feedbackID, newContent, newRating, LocalDateTime.now());

            response.sendRedirect("EventServlet?id=" + fb.getEventID() + "&page=1&updated=true");


        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }
}
