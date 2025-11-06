package Config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ClsConexion {

    public ClsConexion() {
        // Constructor vacío (no crea la conexión de inmediato)
    }

    public Connection getConnection() {
        Connection con = null;
        try {
            // Cargar el driver de MySQL
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // Crear una nueva conexión cada vez que se llama al método
            con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/Electrosurr_jvl",
                "root",
                ""
            );
        } catch (ClassNotFoundException | SQLException e) {
            System.out.println("Error en la conexión: " + e.getMessage());
        }
        return con;
    }
}

