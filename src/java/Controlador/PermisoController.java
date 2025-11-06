package Controlador;

import Interfaces.IEmpleadoDAO;
import Interfaces.IPermisoDAO;
import Modelo.Empleado;
import Modelo.Permiso;
import ModeloDAO.EmpleadoDAO;
import ModeloDAO.PermisoDAO;
import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.sql.Time;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "PermisoController", urlPatterns = {"/PermisoController"})
public class PermisoController extends HttpServlet {

    private final IEmpleadoDAO empleadoDAO = new EmpleadoDAO();
    private final IPermisoDAO permisoDAO = new PermisoDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    private void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accion = request.getParameter("accion");
        if (accion == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        switch (accion) {
            case "login":
                manejarLogin(request, response);
                break;
            case "logout":
                manejarLogout(request, response);
                break;
            case "registrarPermiso":
                manejarRegistroPermiso(request, response);
                break;
            case "listarMisPermisos":
                mostrarPermisosEmpleado(request, response);
                break;
            case "listarPendientesArea":
                mostrarPendientesJefeArea(request, response);
                break;
            case "aprobarArea":
                manejarAprobacionArea(request, response);
                break;
            case "denegarArea":
                manejarDenegacionArea(request, response);
                break;
            case "listarPendientesRRHH":
                mostrarPendientesRRHH(request, response);
                break;
            case "aprobarRRHH":
                manejarAprobacionRRHH(request, response);
                break;
            case "denegarRRHH":
                manejarDenegacionRRHH(request, response);
                break;
            case "registrarEjecucion":
                manejarRegistroEjecucion(request, response);
                break;
            default:
                response.sendRedirect("login.jsp");
        }
    }

    private void manejarLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String usuario = request.getParameter("usuario");
        String password = request.getParameter("password");
        try {
            Empleado empleado = empleadoDAO.validarCredenciales(usuario, password);
            if (empleado != null) {
                HttpSession session = request.getSession(true);
                session.setAttribute("empleado", empleado);
                redirigirPorRol(empleado, request, response);
            } else {
                request.setAttribute("mensaje", "Credenciales inválidas");
                reenviar(request, response, "login.jsp");
            }
        } catch (SQLException ex) {
            request.setAttribute("mensaje", "Error al validar usuario: " + ex.getMessage());
            reenviar(request, response, "login.jsp");
        }
    }

    private void manejarLogout(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        response.sendRedirect("login.jsp");
    }

    private void manejarRegistroPermiso(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Empleado empleado = session != null ? (Empleado) session.getAttribute("empleado") : null;
        if (empleado == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        try {
            Permiso permiso = new Permiso();
            permiso.setEmpleado(empleado);
            permiso.setFechaPermiso(Date.valueOf(request.getParameter("fechaPermiso")));
            permiso.setHoraSalida(Time.valueOf(request.getParameter("horaSalida") + ":00"));
            permiso.setFechaRetorno(Date.valueOf(request.getParameter("fechaRetorno")));
            permiso.setHoraRetorno(Time.valueOf(request.getParameter("horaRetorno") + ":00"));
            permiso.setMotivo(request.getParameter("motivo"));
            permiso.setEstado("PENDIENTE_JEFE");
            permisoDAO.registrarPermiso(permiso);
            request.setAttribute("mensaje", "Permiso enviado correctamente");
            mostrarPermisosEmpleado(request, response);
        } catch (IllegalArgumentException | SQLException ex) {
            request.setAttribute("mensaje", "Error al registrar el permiso: " + ex.getMessage());
            reenviar(request, response, "VistaEmpleado/formularioPermiso.jsp");
        }
    }

    private void mostrarPermisosEmpleado(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Empleado empleado = session != null ? (Empleado) session.getAttribute("empleado") : null;
        if (empleado == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        try {
            List<Permiso> permisos = permisoDAO.listarPorEmpleado(empleado.getId());
            request.setAttribute("permisos", permisos);
            reenviar(request, response, "VistaEmpleado/misPermisos.jsp");
        } catch (SQLException ex) {
            request.setAttribute("mensaje", "No se pudieron obtener los permisos: " + ex.getMessage());
            reenviar(request, response, "VistaEmpleado/dashboard.jsp");
        }
    }

    private void mostrarPendientesJefeArea(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Empleado jefe = obtenerUsuarioSesion(request);
        if (jefe == null || !"JEFE_AREA".equalsIgnoreCase(jefe.getRol())) {
            response.sendRedirect("login.jsp");
            return;
        }
        try {
            List<Permiso> permisos = permisoDAO.listarPendientesPorJefeArea(jefe.getId());
            request.setAttribute("permisosPendientes", permisos);
            reenviar(request, response, "VistaJefeArea/pendientes.jsp");
        } catch (SQLException ex) {
            request.setAttribute("mensaje", "No se pudieron cargar los permisos: " + ex.getMessage());
            reenviar(request, response, "VistaJefeArea/pendientes.jsp");
        }
    }

    private void manejarAprobacionArea(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        procesarDecisionJefeArea(request, response, "APROBADO_JEFE");
    }

    private void manejarDenegacionArea(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        procesarDecisionJefeArea(request, response, "DENEGADO_JEFE");
    }

    private void procesarDecisionJefeArea(HttpServletRequest request, HttpServletResponse response, String estado)
            throws ServletException, IOException {
        Empleado jefe = obtenerUsuarioSesion(request);
        if (jefe == null || !"JEFE_AREA".equalsIgnoreCase(jefe.getRol())) {
            response.sendRedirect("login.jsp");
            return;
        }
        String observaciones = request.getParameter("observaciones");
        if (observaciones == null) {
            observaciones = "";
        }
        try {
            int permisoId = Integer.parseInt(request.getParameter("permisoId"));
            permisoDAO.actualizarEstadoPorJefeArea(permisoId, estado, observaciones, jefe.getId());
            request.setAttribute("mensaje", "Permiso actualizado");
        } catch (NumberFormatException | SQLException ex) {
            request.setAttribute("mensaje", "No se pudo actualizar el permiso: " + ex.getMessage());
        }
        mostrarPendientesJefeArea(request, response);
    }

    private void mostrarPendientesRRHH(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Empleado jefeRRHH = obtenerUsuarioSesion(request);
        if (jefeRRHH == null || !"JEFE_RRHH".equalsIgnoreCase(jefeRRHH.getRol())) {
            response.sendRedirect("login.jsp");
            return;
        }
        try {
            List<Permiso> permisos = permisoDAO.listarPendientesRRHH();
            request.setAttribute("permisosPendientes", permisos);
            reenviar(request, response, "VistaRecursosHumanos/pendientes.jsp");
        } catch (SQLException ex) {
            request.setAttribute("mensaje", "Error al cargar los permisos: " + ex.getMessage());
            reenviar(request, response, "VistaRecursosHumanos/pendientes.jsp");
        }
    }

    private void manejarAprobacionRRHH(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        procesarDecisionRRHH(request, response, "APROBADO_RRHH");
    }

    private void manejarDenegacionRRHH(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        procesarDecisionRRHH(request, response, "DENEGADO_RRHH");
    }

    private void procesarDecisionRRHH(HttpServletRequest request, HttpServletResponse response, String estado)
            throws ServletException, IOException {
        Empleado jefeRRHH = obtenerUsuarioSesion(request);
        if (jefeRRHH == null || !"JEFE_RRHH".equalsIgnoreCase(jefeRRHH.getRol())) {
            response.sendRedirect("login.jsp");
            return;
        }
        try {
            int permisoId = Integer.parseInt(request.getParameter("permisoId"));
            Permiso permiso = permisoDAO.obtenerPorId(permisoId);
            if (permiso != null && permiso.getEmpleado().getHorasAcumuladas() > 50 && "APROBADO_RRHH".equals(estado)) {
                request.setAttribute("mensaje", "El empleado supera las 50 horas acumuladas");
            } else {
                permisoDAO.actualizarEstadoRRHH(permisoId, estado, jefeRRHH.getId());
                request.setAttribute("mensaje", "Permiso actualizado por RRHH");
            }
        } catch (NumberFormatException | SQLException ex) {
            request.setAttribute("mensaje", "No se pudo actualizar el permiso: " + ex.getMessage());
        }
        mostrarPendientesRRHH(request, response);
    }

    private void manejarRegistroEjecucion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Empleado jefeRRHH = obtenerUsuarioSesion(request);
        if (jefeRRHH == null || !"JEFE_RRHH".equalsIgnoreCase(jefeRRHH.getRol())) {
            response.sendRedirect("login.jsp");
            return;
        }
        try {
            int permisoId = Integer.parseInt(request.getParameter("permisoId"));
            boolean cumplioHorario = Boolean.parseBoolean(request.getParameter("cumplioHorario"));
            permisoDAO.registrarEjecucion(permisoId, cumplioHorario);
            if (!cumplioHorario) {
                permisoDAO.actualizarEstadoRRHH(permisoId, "RECHAZADO_EJECUCION", jefeRRHH.getId());
            }
            request.setAttribute("mensaje", "Ejecución registrada");
        } catch (NumberFormatException | SQLException ex) {
            request.setAttribute("mensaje", "No se pudo registrar la ejecución: " + ex.getMessage());
        }
        mostrarPendientesRRHH(request, response);
    }

    private void redirigirPorRol(Empleado empleado, HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if ("JEFE_AREA".equalsIgnoreCase(empleado.getRol())) {
            mostrarPendientesJefeArea(request, response);
        } else if ("JEFE_RRHH".equalsIgnoreCase(empleado.getRol())) {
            mostrarPendientesRRHH(request, response);
        } else {
            reenviar(request, response, "VistaEmpleado/dashboard.jsp");
        }
    }

    private void reenviar(HttpServletRequest request, HttpServletResponse response, String vista)
            throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher(vista);
        dispatcher.forward(request, response);
    }

    private Empleado obtenerUsuarioSesion(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session != null ? (Empleado) session.getAttribute("empleado") : null;
    }
}
