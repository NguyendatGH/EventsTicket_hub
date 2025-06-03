package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;

@WebServlet("/images/*") 
public class ImageServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String imagePath = request.getPathInfo(); 
        System.out.println("DEBUG ImageServlet: Request path info: " + imagePath);

        if (imagePath == null || imagePath.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Image path is missing.");
            return;
        }


        if (imagePath.startsWith("/")) {
            imagePath = imagePath.substring(1);
        }
        System.out.println("DEBUG ImageServlet: Absolute image path: " + imagePath);

        File imageFile = new File(imagePath);

 
        if (!imageFile.exists() || !imageFile.isFile()) {
            System.err.println("ERROR ImageServlet: Image file not found or is not a file: " + imagePath);
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Image not found.");
            return;
        }


        String contentType = getServletContext().getMimeType(imageFile.getName());
        if (contentType == null) {

            contentType = "application/octet-stream";
        }
        response.setContentType(contentType);
        response.setContentLength((int) imageFile.length());

        try (FileInputStream in = new FileInputStream(imageFile); OutputStream out = response.getOutputStream()) {

            byte[] buffer = new byte[4096];
            int bytesRead;
            while ((bytesRead = in.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
            }
            System.out.println("DEBUG ImageServlet: Image served successfully: " + imagePath);

        } catch (IOException e) {
            System.err.println("ERROR ImageServlet: Error serving image " + imagePath + ": " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error serving image.");
        }
    }
}
