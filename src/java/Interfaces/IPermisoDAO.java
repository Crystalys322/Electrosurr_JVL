package Interfaces;

import Modelo.Permiso;
import java.sql.SQLException;
import java.util.List;

public interface IPermisoDAO {
    boolean registrarPermiso(Permiso permiso) throws SQLException;
    List<Permiso> listarPorEmpleado(int empleadoId) throws SQLException;
    List<Permiso> listarPendientesPorJefeArea(int jefeAreaId) throws SQLException;
    List<Permiso> listarPendientesRRHH() throws SQLException;
    Permiso obtenerPorId(int permisoId) throws SQLException;
    void actualizarEstadoPorJefeArea(int permisoId, String estado, String observaciones, int jefeAreaId) throws SQLException;
    void actualizarEstadoRRHH(int permisoId, String estado, int jefeRRHHId) throws SQLException;
    void registrarEjecucion(int permisoId, boolean cumplioHorario) throws SQLException;
}
