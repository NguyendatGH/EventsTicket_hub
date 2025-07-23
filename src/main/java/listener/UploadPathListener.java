package listener;

import java.io.File;

import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

@WebListener
public class UploadPathListener implements ServletContextListener {
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        ServletContext context = sce.getServletContext();
        String basePath = context.getRealPath("/uploads");
        if (basePath == null) {
            basePath = new File("src/main/webapp/uploads").getAbsolutePath(); // Fallback
        }
        context.setAttribute("upload.path", basePath);
        System.out.println("DEBUG - Upload base path set to: " + basePath);
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // Cleanup if needed
    }
}