<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page import="java.util.List" %>
<%@ page import="Modelo.Permiso" %>
<%@ page import="Modelo.Empleado" %>
<%
    HttpSession session = request.getSession(false);
    Empleado jefe = session != null ? (Empleado) session.getAttribute("empleado") : null;
    if (jefe == null || !"JEFE_RRHH".equalsIgnoreCase(jefe.getRol())) {
        response.sendRedirect("../login.jsp");
        return;
    }
    List<Permiso> permisosPendientes = (List<Permiso>) request.getAttribute("permisosPendientes");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Permisos pendientes - Recursos Humanos</title>
    <link rel="stylesheet" href="../css/estilos.css">
</head>
<body>
<h2>Permisos pendientes Recursos Humanos</h2>
<form action="../PermisoController" method="post" style="display:inline;">
    <input type="hidden" name="accion" value="logout">
    <button type="submit">Cerrar sesión</button>
</form>
<% String mensaje = (String) request.getAttribute("mensaje");
   if (mensaje != null) { %>
    <div class="alerta"><%= mensaje %></div>
<% } %>
<table border="1" cellpadding="5">
    <thead>
    <tr>
        <th>Empleado</th>
        <th>Horas acumuladas</th>
        <th>Detalle</th>
        <th>Acciones</th>
    </tr>
    </thead>
    <tbody>
    <% if (permisosPendientes != null && !permisosPendientes.isEmpty()) {
           for (Permiso permiso : permisosPendientes) {
               Empleado empleadoPermiso = permiso.getEmpleado(); %>
        <tr>
            <td>
                <strong><%= empleadoPermiso.getNombres() %> <%= empleadoPermiso.getApellidos() %></strong><br>
                Documento: <%= empleadoPermiso.getDocumento() %>
            </td>
            <td><%= empleadoPermiso.getHorasAcumuladas() %></td>
            <td>
                Fecha permiso: <%= permiso.getFechaPermiso() %> - Hora salida: <%= permiso.getHoraSalida() %><br>
                Fecha retorno: <%= permiso.getFechaRetorno() %> - Hora retorno: <%= permiso.getHoraRetorno() %><br>
                Motivo: <%= permiso.getMotivo() %>
            </td>
            <td>
                <form action="../PermisoController" method="post">
                    <input type="hidden" name="accion" value="aprobarRRHH">
                    <input type="hidden" name="permisoId" value="<%= permiso.getId() %>">
                    <button type="submit">Aprobar</button>
                </form>
                <form action="../PermisoController" method="post">
                    <input type="hidden" name="accion" value="denegarRRHH">
                    <input type="hidden" name="permisoId" value="<%= permiso.getId() %>">
                    <button type="submit">Denegar</button>
                </form>
                <form action="../PermisoController" method="post">
                    <input type="hidden" name="accion" value="registrarEjecucion">
                    <input type="hidden" name="permisoId" value="<%= permiso.getId() %>">
                    <label>¿Cumplió horario?
                        <select name="cumplioHorario">
                            <option value="true">Sí</option>
                            <option value="false">No</option>
                        </select>
                    </label>
                    <button type="submit">Registrar ejecución</button>
                </form>
            </td>
        </tr>
    <%   }
       } else { %>
        <tr>
            <td colspan="4">No hay permisos pendientes.</td>
        </tr>
    <% } %>
    </tbody>
</table>
</body>
</html>
