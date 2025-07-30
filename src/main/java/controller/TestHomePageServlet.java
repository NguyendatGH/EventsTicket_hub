package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/test-homepage")
public class TestHomePageServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        
        try {
            response.getWriter().println("<h1>🏠 Test Homepage Link</h1>");
            
            String contextPath = request.getContextPath();
            String homePageUrl = contextPath + "/homePage";
            
            response.getWriter().println("<h2>Context Path: " + contextPath + "</h2>");
            response.getWriter().println("<h2>Homepage URL: " + homePageUrl + "</h2>");
            
            response.getWriter().println("<br><h2>✅ Test Completed</h2>");
            response.getWriter().println("<p>The homepage link should work correctly now!</p>");
            response.getWriter().println("<p><a href='" + homePageUrl + "'>Click here to go to homepage</a></p>");
            
        } catch (Exception e) {
            System.err.println("Error testing homepage: " + e.getMessage());
            e.printStackTrace();
            response.getWriter().println("<h1>❌ Error</h1>");
            response.getWriter().println("<p>Error: " + e.getMessage() + "</p>");
        }
    }
} 