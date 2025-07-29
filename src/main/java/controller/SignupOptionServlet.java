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
        // Handle GET requests by redirecting to the register page
        response.sendRedirect(request.getContextPath() + "/authentication/register.jsp");
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String role = request.getParameter("role");
        
        System.out.println("SignupOptionServlet - Role: " + role);
        System.out.println("Context Path: " + request.getContextPath());

        if ("user".equals(role)) {
            String redirectUrl = request.getContextPath() + "/authentication/registerUser.jsp";
            System.out.println("Redirecting to: " + redirectUrl);
            response.sendRedirect(redirectUrl);
        } else if ("organizer".equals(role)) {
            String redirectUrl = request.getContextPath() + "/authentication/registerOrganizer.jsp";
            System.out.println("Redirecting to: " + redirectUrl);
            response.sendRedirect(redirectUrl);
        } else {
            String redirectUrl = request.getContextPath() + "/authentication/register.jsp";
            System.out.println("Redirecting to: " + redirectUrl);
            response.sendRedirect(redirectUrl);
        }
    }
}