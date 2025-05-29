package context;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBContext {

    private static final String URL = "jdbc:sqlserver://localhost:1433;databaseName=EvensTicketDB;encrypt=true;trustServerCertificate=true;";
    private static final String USER = "EventDB";
    private static final String PASSWORD = "123";

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            return DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (ClassNotFoundException | SQLException e) {
            throw new SQLException("Lỗi kết nối CSDL!", e);
        }
    }

    public static void main(String[] args) {
        
        String url = "jdbc:sqlserver://localhost:1433;databaseName=EvensTicketDB;encrypt=true;trustServerCertificate=true;";

        String user = "EventDB";
        String password = "123"; 

        try {
            
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");

          
            Connection conn = DriverManager.getConnection(url, user, password);
            System.out.println("✅ Kết nối database thành công!");

            conn.close();
        } catch (ClassNotFoundException e) {
            System.out.println("❌ Không tìm thấy driver SQL Server!");
            e.printStackTrace();
        } catch (SQLException e) {
            System.out.println("❌ Kết nối database thất bại!");
            e.printStackTrace();
        }
    }
}

