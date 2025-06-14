/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
package context;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DBConnection {

    private static final String DRIVER_NAME = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
    private static final String DB_URL = "jdbc:sqlserver://localhost:1433;databaseName=EventTicketDB3;encrypt=true;trustServerCertificate=true";
    private static final String USER_DB = "sa"; //your username 

    private static final String PASS_DB = "12345"; //your password



    private static final Logger LOGGER = Logger.getLogger(DBConnection.class.getName());

    public static Connection getConnection() {
        Connection con = null;
        try {
            Class.forName(DRIVER_NAME);
            con = DriverManager.getConnection(DB_URL, USER_DB, PASS_DB);
        } catch (ClassNotFoundException | SQLException ex) {
            LOGGER.log(Level.SEVERE, "Database connection error", ex);
        }
        return con;
    }

    public static void main(String[] args) {
        try (Connection con = getConnection()) {
            if (con != null) {
                System.out.println("Connected to xxxxx successfully!");
            } else {
                System.out.println("Failed to connect to xxxxx.");
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Connection attempt failed", ex);
        }
    }
}
