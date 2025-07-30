package controller;
/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */


import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/signupOption")
public class SignupOptionServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("=== SignupOptionServlet doGet called ===");
        System.out.println("Request Method: " + request.getMethod());
        System.out.println("Request URI: " + request.getRequestURI());
        
        // Handle GET requests by redirecting to the register page
        response.sendRedirect(request.getContextPath() + "/authentication/register.jsp");
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            System.out.println("=== SignupOptionServlet doPost called ===");
            System.out.println("Request Method: " + request.getMethod());
            System.out.println("Request URI: " + request.getRequestURI());
            System.out.println("Context Path: " + request.getContextPath());
            
            String role = request.getParameter("role");
            System.out.println("Role parameter: " + role);

            if ("user".equals(role)) {
                String redirectUrl = request.getContextPath() + "/authentication/registerUser.jsp";
                System.out.println("Redirecting to: " + redirectUrl);
                response.sendRedirect(redirectUrl);
            } else if ("organizer".equals(role)) {
                String redirectUrl = request.getContextPath() + "/authentication/registerOrganizer.jsp";
                System.out.println("Redirecting to: " + redirectUrl);
                response.sendRedirect(redirectUrl);
            } else {
                // Invalid role, redirect back to register page
                String redirectUrl = request.getContextPath() + "/authentication/register.jsp";
                System.out.println("Invalid role, redirecting to: " + redirectUrl);
                response.sendRedirect(redirectUrl);
            }
        } catch (Exception e) {
            System.err.println("Error in SignupOptionServlet: " + e.getMessage());
            e.printStackTrace();
            // Redirect to register page on error
            response.sendRedirect(request.getContextPath() + "/authentication/register.jsp");
        }
    }
}