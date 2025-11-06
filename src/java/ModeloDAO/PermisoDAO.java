package ModeloDAO;

import Config.ClsConexion;
import Interfaces.IPermisoDAO;
import Modelo.Empleado;
import Modelo.Permiso;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class PermisoDAO implements IPermisoDAO {

    private final ClsConexion conexion;

    private static final String SQL_INSERT =
            "INSERT INTO permiso (empleado_id, fecha_permiso, hora_salida, fecha_retorno, hora_retorno, motivo, estado, observaciones, firmado_jefe_area, firmado_rrhh, marcado_reincidente) " +
            "VALUES (?, ?, ?, ?, ?, ?, 'PENDIENTE_JEFE', '', 0, 0, 0)";

    private static final String SQL_SELECT_BY_EMPLEADO =
            "SELECT p.id, p.empleado_id, p.fecha_permiso, p.hora_salida, p.fecha_retorno, p.hora_retorno, p.motivo, p.estado, p.observaciones, p.firmado_jefe_area, p.firmado_rrhh, p.marcado_reincidente, " +
            "e.nombres, e.apellidos, e.documento, e.correo, e.password, e.rol, e.area_id, e.horas_acumuladas, e.reincidente " +
            "FROM permiso p INNER JOIN empleado e ON p.empleado_id = e.id WHERE e.id = ? ORDER BY p.fecha_permiso DESC";

    private static final String SQL_SELECT_PENDIENTES_JEFE =
            "SELECT p.id, p.empleado_id, p.fecha_permiso, p.hora_salida, p.fecha_retorno, p.hora_retorno, p.motivo, p.estado, p.observaciones, p.firmado_jefe_area, p.firmado_rrhh, p.marcado_reincidente, " +
            "e.nombres, e.apellidos, e.documento, e.correo, e.password, e.rol, e.area_id, e.horas_acumuladas, e.reincidente " +
            "FROM permiso p INNER JOIN empleado e ON p.empleado_id = e.id INNER JOIN area a ON e.area_id = a.id " +
            "WHERE a.jefe_area_id = ? AND p.estado = 'PENDIENTE_JEFE'";


    private static final String SQL_FIND_BY_ID =
            "SELECT p.id, p.empleado_id, p.fecha_permiso, p.hora_salida, p.fecha_retorno, p.hora_retorno, p.motivo, p.estado, p.observaciones, p.firmado_jefe_area, p.firmado_rrhh, p.marcado_reincidente, " +
            "e.nombres, e.apellidos, e.documento, e.correo, e.password, e.rol, e.area_id, e.horas_acumuladas, e.reincidente " +
            "FROM permiso p INNER JOIN empleado e ON p.empleado_id = e.id WHERE p.id = ?";
    private static final String SQL_SELECT_PENDIENTES_RRHH =
            "SELECT p.id, p.empleado_id, p.fecha_permiso, p.hora_salida, p.fecha_retorno, p.hora_retorno, p.motivo, p.estado, p.observaciones, p.firmado_jefe_area, p.firmado_rrhh, p.marcado_reincidente, " +
            "e.nombres, e.apellidos, e.documento, e.correo, e.password, e.rol, e.area_id, e.horas_acumuladas, e.reincidente " +
            "FROM permiso p INNER JOIN empleado e ON p.empleado_id = e.id WHERE p.estado IN ('PENDIENTE_RRHH', 'APROBADO_JEFE')";

    private static final String SQL_UPDATE_JEFE =
            "UPDATE permiso SET estado = ?, observaciones = ?, firmado_jefe_area = 1 WHERE id = ?";

    private static final String SQL_UPDATE_RRHH =
            "UPDATE permiso SET estado = ?, firmado_rrhh = 1 WHERE id = ?";

    private static final String SQL_UPDATE_EJECUCION =
            "UPDATE permiso SET marcado_reincidente = ?, estado = CASE WHEN ? = 1 THEN 'RECHAZADO_EJECUCION' ELSE estado END WHERE id = ?";

    public PermisoDAO() {
        this.conexion = new ClsConexion();
    }

    @Override
    public boolean registrarPermiso(Permiso permiso) throws SQLException {
        Connection con = conexion.getConnection();
        if (con == null) {
            return false;
        }
        try (PreparedStatement ps = con.prepareStatement(SQL_INSERT, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, permiso.getEmpleado().getId());
            ps.setDate(2, permiso.getFechaPermiso());
            ps.setTime(3, permiso.getHoraSalida());
            ps.setDate(4, permiso.getFechaRetorno());
            ps.setTime(5, permiso.getHoraRetorno());
            ps.setString(6, permiso.getMotivo());
            int filas = ps.executeUpdate();
            if (filas > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        permiso.setId(rs.getInt(1));
                    }
                }
            }
            return filas > 0;
        } finally {
            con.close();
        }
    }

    @Override
    public List<Permiso> listarPorEmpleado(int empleadoId) throws SQLException {
        List<Permiso> permisos = new ArrayList<>();
        Connection con = conexion.getConnection();
        if (con == null) {
            return permisos;
        }
        try (PreparedStatement ps = con.prepareStatement(SQL_SELECT_BY_EMPLEADO)) {
            ps.setInt(1, empleadoId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    permisos.add(mapearPermiso(rs));
                }
            }
        } finally {
            con.close();
        }
        return permisos;
    }

    @Override
    public List<Permiso> listarPendientesPorJefeArea(int jefeAreaId) throws SQLException {
        List<Permiso> permisos = new ArrayList<>();
        Connection con = conexion.getConnection();
        if (con == null) {
            return permisos;
        }
        try (PreparedStatement ps = con.prepareStatement(SQL_SELECT_PENDIENTES_JEFE)) {
            ps.setInt(1, jefeAreaId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    permisos.add(mapearPermiso(rs));
                }
            }
        } finally {
            con.close();
        }
        return permisos;
    }

    @Override
    public List<Permiso> listarPendientesRRHH() throws SQLException {
        List<Permiso> permisos = new ArrayList<>();
        Connection con = conexion.getConnection();
        if (con == null) {
            return permisos;
        }
        try (PreparedStatement ps = con.prepareStatement(SQL_SELECT_PENDIENTES_RRHH);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                permisos.add(mapearPermiso(rs));
            }
        } finally {
            con.close();
        }
        return permisos;
    }


    @Override
    public Permiso obtenerPorId(int permisoId) throws SQLException {
        Connection con = conexion.getConnection();
        if (con == null) {
            return null;
        }
        try (PreparedStatement ps = con.prepareStatement(SQL_FIND_BY_ID)) {
            ps.setInt(1, permisoId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapearPermiso(rs);
                }
            }
        } finally {
            con.close();
        }
        return null;
    }

    @Override
    public void actualizarEstadoPorJefeArea(int permisoId, String estado, String observaciones, int jefeAreaId) throws SQLException {
        Connection con = conexion.getConnection();
        if (con == null) {
            return;
        }
        try (PreparedStatement ps = con.prepareStatement(SQL_UPDATE_JEFE)) {
            ps.setString(1, estado);
            ps.setString(2, observaciones);
            ps.setInt(3, permisoId);
            ps.executeUpdate();
        } finally {
            con.close();
        }
    }

    @Override
    public void actualizarEstadoRRHH(int permisoId, String estado, int jefeRRHHId) throws SQLException {
        Connection con = conexion.getConnection();
        if (con == null) {
            return;
        }
        try (PreparedStatement ps = con.prepareStatement(SQL_UPDATE_RRHH)) {
            ps.setString(1, estado);
            ps.setInt(2, permisoId);
            ps.executeUpdate();
        } finally {
            con.close();
        }
    }

    @Override
    public void registrarEjecucion(int permisoId, boolean cumplioHorario) throws SQLException {
        Connection con = conexion.getConnection();
        if (con == null) {
            return;
        }
        try (PreparedStatement ps = con.prepareStatement(SQL_UPDATE_EJECUCION)) {
            ps.setBoolean(1, !cumplioHorario);
            ps.setBoolean(2, !cumplioHorario);
            ps.setInt(3, permisoId);
            ps.executeUpdate();
        } finally {
            con.close();
        }
    }

    private Permiso mapearPermiso(ResultSet rs) throws SQLException {
        Permiso permiso = new Permiso();
        Empleado empleado = new Empleado();
        permiso.setId(rs.getInt("id"));
        empleado.setId(rs.getInt("empleado_id"));
        empleado.setNombres(rs.getString("nombres"));
        empleado.setApellidos(rs.getString("apellidos"));
        empleado.setDocumento(rs.getString("documento"));
        empleado.setCorreo(rs.getString("correo"));
        empleado.setPassword(rs.getString("password"));
        empleado.setRol(rs.getString("rol"));
        empleado.setAreaId(rs.getInt("area_id"));
        empleado.setHorasAcumuladas(rs.getDouble("horas_acumuladas"));
        empleado.setReincidente(rs.getBoolean("reincidente"));
        permiso.setEmpleado(empleado);
        permiso.setFechaPermiso(rs.getDate("fecha_permiso"));
        permiso.setHoraSalida(rs.getTime("hora_salida"));
        permiso.setFechaRetorno(rs.getDate("fecha_retorno"));
        permiso.setHoraRetorno(rs.getTime("hora_retorno"));
        permiso.setMotivo(rs.getString("motivo"));
        permiso.setEstado(rs.getString("estado"));
        permiso.setObservaciones(rs.getString("observaciones"));
        permiso.setFirmadoJefeArea(rs.getBoolean("firmado_jefe_area"));
        permiso.setFirmadoRecursosHumanos(rs.getBoolean("firmado_rrhh"));
        permiso.setMarcadoReincidente(rs.getBoolean("marcado_reincidente"));
        return permiso;
    }
}
