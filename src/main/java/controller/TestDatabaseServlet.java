package controller;

import context.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.ResultSet;
import java.sql.Statement;

@WebServlet("/test-database")
public class TestDatabaseServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        
        try {
            Connection conn = DBConnection.getConnection();
            
            response.getWriter().println("<h1>Database Connection Test</h1>");
            response.getWriter().println("<p>✅ Database connected successfully!</p>");
            
            // Check if Notifications table exists
            DatabaseMetaData metaData = conn.getMetaData();
            ResultSet tables = metaData.getTables(null, null, "Notifications", null);
            
            if (tables.next()) {
                response.getWriter().println("<p>✅ Notifications table exists!</p>");
                
                // Count notifications
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM Notifications");
                
                if (rs.next()) {
                    int count = rs.getInt(1);
                    response.getWriter().println("<p>📊 Total notifications in database: " + count + "</p>");
                }
                
                // Show table structure
                response.getWriter().println("<h2>Table Structure:</h2>");
                ResultSet columns = metaData.getColumns(null, null, "Notifications", null);
                response.getWriter().println("<table border='1'>");
                response.getWriter().println("<tr><th>Column Name</th><th>Data Type</th><th>Nullable</th></tr>");
                
                while (columns.next()) {
                    String columnName = columns.getString("COLUMN_NAME");
                    String dataType = columns.getString("TYPE_NAME");
                    String nullable = columns.getString("IS_NULLABLE");
                    
                    response.getWriter().println("<tr>");
                    response.getWriter().println("<td>" + columnName + "</td>");
                    response.getWriter().println("<td>" + dataType + "</td>");
                    response.getWriter().println("<td>" + nullable + "</td>");
                    response.getWriter().println("</tr>");
                }
                response.getWriter().println("</table>");
                
            } else {
                response.getWriter().println("<p>❌ Notifications table does not exist!</p>");
                response.getWriter().println("<p>Please create the Notifications table first.</p>");
            }
            
            conn.close();
            
        } catch (Exception e) {
            response.getWriter().println("<h1>❌ Database Error</h1>");
            response.getWriter().println("<p>Error: " + e.getMessage() + "</p>");
            e.printStackTrace();
        }
    }
} 