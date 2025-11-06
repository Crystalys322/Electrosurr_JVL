<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page import="java.util.List" %>
<%@ page import="Modelo.Permiso" %>
<%@ page import="Modelo.Empleado" %>
<%
    HttpSession session = request.getSession(false);
    Empleado jefe = session != null ? (Empleado) session.getAttribute("empleado") : null;
    if (jefe == null || !"JEFE_AREA".equalsIgnoreCase(jefe.getRol())) {
        response.sendRedirect("../login.jsp");
        return;
    }
    List<Permiso> permisosPendientes = (List<Permiso>) request.getAttribute("permisosPendientes");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Permisos pendientes - Jefe de Área</title>
    <link rel="stylesheet" href="../css/estilos.css">
</head>
<body>
<h2>Permisos pendientes de su área</h2>
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
        <th>Fechas</th>
        <th>Horas</th>
        <th>Motivo</th>
        <th>Acciones</th>
    </tr>
    </thead>
    <tbody>
    <% if (permisosPendientes != null && !permisosPendientes.isEmpty()) {
           for (Permiso permiso : permisosPendientes) { %>
        <tr>
            <td><%= permiso.getEmpleado().getNombres() %> <%= permiso.getEmpleado().getApellidos() %></td>
            <td>
                Del <%= permiso.getFechaPermiso() %> al <%= permiso.getFechaRetorno() %>
            </td>
            <td>
                Salida: <%= permiso.getHoraSalida() %><br>
                Retorno: <%= permiso.getHoraRetorno() %>
            </td>
            <td><%= permiso.getMotivo() %></td>
            <td>
                <form action="../PermisoController" method="post">
                    <input type="hidden" name="accion" value="aprobarArea">
                    <input type="hidden" name="permisoId" value="<%= permiso.getId() %>">
                    <button type="submit">Aprobar y enviar a RRHH</button>
                </form>
                <form action="../PermisoController" method="post">
                    <input type="hidden" name="accion" value="denegarArea">
                    <input type="hidden" name="permisoId" value="<%= permiso.getId() %>">
                    <label>Observaciones:
                        <textarea name="observaciones" required></textarea>
                    </label>
                    <button type="submit">Denegar</button>
                </form>
            </td>
        </tr>
    <%   }
       } else { %>
        <tr>
            <td colspan="5">No hay permisos pendientes.</td>
        </tr>
    <% } %>
    </tbody>
</table>
</body>
</html>
