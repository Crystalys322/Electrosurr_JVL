package Interfaces;

import Modelo.Empleado;
import java.sql.SQLException;
import java.util.List;

public interface IEmpleadoDAO {
    Empleado validarCredenciales(String usuario, String password) throws SQLException;
    Empleado buscarPorId(int id) throws SQLException;
    List<Empleado> listarPorJefeArea(int jefeAreaId) throws SQLException;
    List<Empleado> listarTodos() throws SQLException;
    void marcarReincidente(int empleadoId) throws SQLException;
    void actualizarHorasAcumuladas(int empleadoId, double horasAcumuladas) throws SQLException;
}
