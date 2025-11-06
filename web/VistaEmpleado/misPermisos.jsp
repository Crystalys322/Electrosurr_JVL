<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page import="java.util.List" %>
<%@ page import="Modelo.Permiso" %>
<%@ page import="Modelo.Empleado" %>
<%
    HttpSession session = request.getSession(false);
    Empleado empleado = session != null ? (Empleado) session.getAttribute("empleado") : null;
    if (empleado == null) {
        response.sendRedirect("../login.jsp");
        return;
    }
    List<Permiso> permisos = (List<Permiso>) request.getAttribute("permisos");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Mis permisos</title>
    <link rel="stylesheet" href="../css/estilos.css">
</head>
<body>
<h2>Mis solicitudes de permiso</h2>
<a href="dashboard.jsp">Volver al panel</a>
<% String mensaje = (String) request.getAttribute("mensaje");
   if (mensaje != null) { %>
    <div class="alerta"><%= mensaje %></div>
<% } %>
<table border="1" cellpadding="5">
    <thead>
    <tr>
        <th>Fecha permiso</th>
        <th>Hora salida</th>
        <th>Fecha retorno</th>
        <th>Hora retorno</th>
        <th>Motivo</th>
        <th>Estado</th>
        <th>Observaciones</th>
    </tr>
    </thead>
    <tbody>
    <% if (permisos != null && !permisos.isEmpty()) {
           for (Permiso permiso : permisos) { %>
        <tr>
            <td><%= permiso.getFechaPermiso() %></td>
            <td><%= permiso.getHoraSalida() %></td>
            <td><%= permiso.getFechaRetorno() %></td>
            <td><%= permiso.getHoraRetorno() %></td>
            <td><%= permiso.getMotivo() %></td>
            <td><%= permiso.getEstado() %></td>
            <td><%= permiso.getObservaciones() != null ? permiso.getObservaciones() : "" %></td>
        </tr>
    <%   }
       } else { %>
        <tr>
            <td colspan="7">No tienes solicitudes registradas.</td>
        </tr>
    <% } %>
    </tbody>
</table>
</body>
</html>
