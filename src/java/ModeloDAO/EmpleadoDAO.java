package ModeloDAO;

import Config.ClsConexion;
import Interfaces.IEmpleadoDAO;
import Modelo.Empleado;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class EmpleadoDAO implements IEmpleadoDAO {

    private final ClsConexion conexion;

    private static final String SQL_LOGIN =
            "SELECT id, nombres, apellidos, documento, correo, password, rol, area_id, horas_acumuladas, reincidente " +
            "FROM empleado WHERE correo = ? AND password = ?";

    private static final String SQL_FIND_BY_ID =
            "SELECT id, nombres, apellidos, documento, correo, password, rol, area_id, horas_acumuladas, reincidente " +
            "FROM empleado WHERE id = ?";

    private static final String SQL_LIST_ALL =
            "SELECT id, nombres, apellidos, documento, correo, password, rol, area_id, horas_acumuladas, reincidente " +
            "FROM empleado";

    private static final String SQL_LIST_BY_JEFE =
            "SELECT e.id, e.nombres, e.apellidos, e.documento, e.correo, e.password, e.rol, e.area_id, e.horas_acumuladas, e.reincidente " +
            "FROM empleado e INNER JOIN area a ON e.area_id = a.id WHERE a.jefe_area_id = ?";

    private static final String SQL_MARCAR_REINCIDENTE =
            "UPDATE empleado SET reincidente = 1 WHERE id = ?";

    private static final String SQL_ACTUALIZAR_HORAS =
            "UPDATE empleado SET horas_acumuladas = ? WHERE id = ?";

    public EmpleadoDAO() {
        this.conexion = new ClsConexion();
    }

    @Override
    public Empleado validarCredenciales(String usuario, String password) throws SQLException {
        Connection con = conexion.getConnection();
        if (con == null) {
            return null;
        }
        try (PreparedStatement ps = con.prepareStatement(SQL_LOGIN)) {
            ps.setString(1, usuario);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapearEmpleado(rs);
                }
            }
        } finally {
            con.close();
        }
        return null;
    }

    @Override
    public Empleado buscarPorId(int id) throws SQLException {
        Connection con = conexion.getConnection();
        if (con == null) {
            return null;
        }
        try (PreparedStatement ps = con.prepareStatement(SQL_FIND_BY_ID)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapearEmpleado(rs);
                }
            }
        } finally {
            con.close();
        }
        return null;
    }

    @Override
    public List<Empleado> listarPorJefeArea(int jefeAreaId) throws SQLException {
        List<Empleado> empleados = new ArrayList<>();
        Connection con = conexion.getConnection();
        if (con == null) {
            return empleados;
        }
        try (PreparedStatement ps = con.prepareStatement(SQL_LIST_BY_JEFE)) {
            ps.setInt(1, jefeAreaId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    empleados.add(mapearEmpleado(rs));
                }
            }
        } finally {
            con.close();
        }
        return empleados;
    }

    @Override
    public List<Empleado> listarTodos() throws SQLException {
        List<Empleado> empleados = new ArrayList<>();
        Connection con = conexion.getConnection();
        if (con == null) {
            return empleados;
        }
        try (PreparedStatement ps = con.prepareStatement(SQL_LIST_ALL);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                empleados.add(mapearEmpleado(rs));
            }
        } finally {
            con.close();
        }
        return empleados;
    }

    @Override
    public void marcarReincidente(int empleadoId) throws SQLException {
        Connection con = conexion.getConnection();
        if (con == null) {
            return;
        }
        try (PreparedStatement ps = con.prepareStatement(SQL_MARCAR_REINCIDENTE)) {
            ps.setInt(1, empleadoId);
            ps.executeUpdate();
        } finally {
            con.close();
        }
    }

    @Override
    public void actualizarHorasAcumuladas(int empleadoId, double horasAcumuladas) throws SQLException {
        Connection con = conexion.getConnection();
        if (con == null) {
            return;
        }
        try (PreparedStatement ps = con.prepareStatement(SQL_ACTUALIZAR_HORAS)) {
            ps.setDouble(1, horasAcumuladas);
            ps.setInt(2, empleadoId);
            ps.executeUpdate();
        } finally {
            con.close();
        }
    }

    private Empleado mapearEmpleado(ResultSet rs) throws SQLException {
        Empleado empleado = new Empleado();
        empleado.setId(rs.getInt("id"));
        empleado.setNombres(rs.getString("nombres"));
        empleado.setApellidos(rs.getString("apellidos"));
        empleado.setDocumento(rs.getString("documento"));
        empleado.setCorreo(rs.getString("correo"));
        empleado.setPassword(rs.getString("password"));
        empleado.setRol(rs.getString("rol"));
        empleado.setAreaId(rs.getInt("area_id"));
        empleado.setHorasAcumuladas(rs.getDouble("horas_acumuladas"));
        empleado.setReincidente(rs.getBoolean("reincidente"));
        return empleado;
    }
}
