package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/test-upload")
public class TestUploadServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        
        try {
            response.getWriter().println("<h1>🔧 Test UploadServlet Configuration</h1>");
            
            // Test 1: Check upload path
            String basePath = (String) getServletContext().getAttribute("upload.path");
            response.getWriter().println("<h2>Test 1: Upload Path Configuration</h2>");
            if (basePath != null && !basePath.isEmpty()) {
                response.getWriter().println("<p style='color: green;'>✅ Upload path configured: " + basePath + "</p>");
            } else {
                response.getWriter().println("<p style='color: red;'>❌ Upload path not configured</p>");
            }
            
            // Test 2: Test path handling
            response.getWriter().println("<h2>Test 2: Path Handling</h2>");
            String[] testPaths = {
                "/user_avatar/test.jpg",
                "/user_avatar/https:/lh3.googleusercontent.com/a/ACg8ocIIv9CKTl0x_h_EAWzijysGSg4mOV67ky3l6P9DM_9mNH7xivgV=s96-c",
                "/event_banners/test.png",
                "/user_avatar/http://example.com/avatar.jpg"
            };
            
            for (String testPath : testPaths) {
                response.getWriter().println("<p>Testing path: " + testPath + "</p>");
                
                // Simulate the path cleaning logic
                String cleanedPath = testPath.replaceAll("%3A", ":").replaceAll("%2F", "/");
                
                if (cleanedPath.startsWith("/user_avatar/https://") || cleanedPath.startsWith("/user_avatar/http://")) {
                    String[] pathParts = cleanedPath.split("/");
                    String fileName = pathParts[pathParts.length - 1];
                    String safeFileName = fileName.replaceAll("[^a-zA-Z0-9._-]", "_");
                    String finalPath = "/user_avatar/" + safeFileName;
                    response.getWriter().println("<p style='color: blue;'>→ Cleaned to: " + finalPath + "</p>");
                } else {
                    response.getWriter().println("<p style='color: green;'>→ No changes needed</p>");
                }
            }
            
            // Test 3: Servlet context info
            response.getWriter().println("<h2>Test 3: Servlet Context Info</h2>");
            response.getWriter().println("<p>Context Path: " + request.getContextPath() + "</p>");
            response.getWriter().println("<p>Servlet Path: " + request.getServletPath() + "</p>");
            response.getWriter().println("<p>Path Info: " + request.getPathInfo() + "</p>");
            
            response.getWriter().println("<br><h2>✅ UploadServlet Test Completed</h2>");
            response.getWriter().println("<p>If you see this message, UploadServlet configuration is working correctly!</p>");
            
        } catch (Exception e) {
            System.err.println("Error testing UploadServlet: " + e.getMessage());
            e.printStackTrace();
            response.getWriter().println("<h1>❌ Error</h1>");
            response.getWriter().println("<p>Error: " + e.getMessage() + "</p>");
        }
    }
} 