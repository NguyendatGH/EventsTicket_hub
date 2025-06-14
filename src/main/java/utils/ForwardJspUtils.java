package utils;

import java.io.IOException;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class ForwardJspUtils {

    public void toJsp(HttpServletRequest request, HttpServletResponse response, String targetJsp)
            throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("/" + targetJsp);
        if (dispatcher == null) {
            String errorMsg = "JSP file not found: " + targetJsp;
            System.out.println("error: " + errorMsg);
            response.sendError(HttpServletResponse.SC_NOT_FOUND, errorMsg);
            return;
        }
        System.out.println("Forwarding to JSP: " + targetJsp);
        dispatcher.forward(request, response);
    }
    public static void main(String[] args) {
        System.out.println("hello world");
    }
}
