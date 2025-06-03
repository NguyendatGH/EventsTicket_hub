
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.InputStream;
import java.io.OutputStream;

@WebServlet("/asset/*")
public class AssetServlet extends HttpServlet {

  @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        
        // Tạo resource path
        String resourcePath = "/asset" + pathInfo;
        
        try (InputStream inputStream = getServletContext().getResourceAsStream(resourcePath)) {
            if (inputStream == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Resource not found: " + resourcePath);
                return;
            }
            
            // Set content type dựa trên file extension
            String fileName = pathInfo.substring(pathInfo.lastIndexOf('/') + 1);
            String mimeType = getMimeTypeForFile(fileName);
            response.setContentType(mimeType);
            
            // Set cache headers để tối ưu performance
            response.setHeader("Cache-Control", "public, max-age=31536000"); // Cache 1 năm
            response.setDateHeader("Expires", System.currentTimeMillis() + 31536000000L);
            
            // Copy file content to response
            try (OutputStream outputStream = response.getOutputStream()) {
                byte[] buffer = new byte[8192];
                int bytesRead;
                while ((bytesRead = inputStream.read(buffer)) != -1) {
                    outputStream.write(buffer, 0, bytesRead);
                }
            }
        } catch (IOException e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                "Error serving resource: " + e.getMessage());
        }
    }
    
    private String getMimeTypeForFile(String fileName) {
        String mimeType = getServletContext().getMimeType(fileName);
        if (mimeType != null) {
            return mimeType;
        }
        
        // Fallback cho các file type phổ biến
        String lowerCase = fileName.toLowerCase();
        if (lowerCase.endsWith(".svg")) {
            return "image/svg+xml";
        } else if (lowerCase.endsWith(".css")) {
            return "text/css";
        } else if (lowerCase.endsWith(".js")) {
            return "application/javascript";
        } else if (lowerCase.endsWith(".png")) {
            return "image/png";
        } else if (lowerCase.endsWith(".jpg") || lowerCase.endsWith(".jpeg")) {
            return "image/jpeg";
        } else if (lowerCase.endsWith(".gif")) {
            return "image/gif";
        } else if (lowerCase.endsWith(".ico")) {
            return "image/x-icon";
        } else {
            return "application/octet-stream";
        }
    }
}
