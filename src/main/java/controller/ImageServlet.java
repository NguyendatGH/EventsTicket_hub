package controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.file.Paths;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/avatar/*")
public class ImageServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String basePath = (String) getServletContext().getAttribute("upload.path");
        if (basePath == null || basePath.isEmpty()) {
            basePath = getServletContext().getRealPath("/uploads");
            if (basePath == null) {
                basePath = "uploads";
            }
        }
        
        String relativePath = request.getPathInfo();
        if (relativePath == null || relativePath.isEmpty()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        
        // Remove leading slash
        if (relativePath.startsWith("/")) {
            relativePath = relativePath.substring(1);
        }
        
        String filePath = basePath + File.separator + "user_avatar" + File.separator + relativePath;
        System.out.println("Serving avatar from: " + filePath);
        
        File file = new File(filePath);
        if (!file.exists()) {
            System.out.println("Avatar file not found: " + filePath);
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        
        String mimeType = getServletContext().getMimeType(file.getName());
        if (mimeType == null) {
            mimeType = "image/jpeg"; // Default to JPEG
        }
        
        response.setContentType(mimeType);
        response.setContentLength((int) file.length());
        
        try (InputStream in = new FileInputStream(file);
             OutputStream out = response.getOutputStream()) {
            byte[] buffer = new byte[1024];
            int bytesRead;
            while ((bytesRead = in.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
            }
        }
    }
}
