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

@WebServlet("/uploads/*")
public class UploadServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String basePath = (String) getServletContext().getAttribute("upload.path");
        if (basePath == null || basePath.isEmpty()) {
            System.out.println("base path is null");
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Upload path not configured");
            return;
        } 
        
        String relativePath = request.getPathInfo();

        if (relativePath == null || relativePath.isEmpty()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        
        // Clean the relative path to remove any URL-encoded characters
        relativePath = relativePath.replaceAll("%3A", ":").replaceAll("%2F", "/");
        
        // Check if this is a Google avatar URL (starts with https://)
        if (relativePath.startsWith("/user_avatar/https://") || relativePath.startsWith("/user_avatar/http://")) {
            // For Google avatar URLs, we need to handle them differently
            // Extract the filename from the URL
            String[] pathParts = relativePath.split("/");
            String fileName = pathParts[pathParts.length - 1];
            
            // Create a safe filename
            String safeFileName = fileName.replaceAll("[^a-zA-Z0-9._-]", "_");
            relativePath = "/user_avatar/" + safeFileName;
        }
        
        try {
            String safePath = Paths.get(basePath, relativePath).normalize().toString();

            if (!safePath.startsWith(basePath)) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN);
                return;
            }

            File file = new File(safePath);

            if (!file.exists()) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }

            String mimeType = getServletContext().getMimeType(file.getName());
            if (mimeType == null) {
                mimeType = "application/octet-stream";
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
        } catch (Exception e) {
            System.err.println("Error serving file: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error processing file request");
        }
    }
}