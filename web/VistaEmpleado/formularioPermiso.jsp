<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page import="Modelo.Empleado" %>
<%
    HttpSession session = request.getSession(false);
    Empleado empleado = session != null ? (Empleado) session.getAttribute("empleado") : null;
    if (empleado == null) {
        response.sendRedirect("../login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Solicitud de Permiso</title>
    <link rel="stylesheet" href="../css/estilos.css">
</head>
<body>
<h2>Solicitud de permiso</h2>
<a href="dashboard.jsp">Volver al panel</a>
<% String mensaje = (String) request.getAttribute("mensaje");
   if (mensaje != null) { %>
    <div class="alerta"><%= mensaje %></div>
<% } %>
<form action="../PermisoController" method="post">
    <input type="hidden" name="accion" value="registrarPermiso">
    <fieldset>
        <legend>Datos del empleado</legend>
        <p><strong>Nombre:</strong> <%= empleado.getNombres() %> <%= empleado.getApellidos() %></p>
        <p><strong>Documento:</strong> <%= empleado.getDocumento() %></p>
        <p><strong>Área:</strong> <%= empleado.getAreaId() %></p>
    </fieldset>
    <fieldset>
        <legend>Detalle del permiso</legend>
        <label>Fecha de permiso:
            <input type="date" name="fechaPermiso" required>
        </label>
        <label>Hora de salida:
            <input type="time" name="horaSalida" required>
        </label>
        <label>Fecha de retorno:
            <input type="date" name="fechaRetorno" required>
        </label>
        <label>Hora de retorno:
            <input type="time" name="horaRetorno" required>
        </label>
        <label>Motivo:
            <textarea name="motivo" rows="4" required></textarea>
        </label>
    </fieldset>
    <button type="submit">Enviar a aprobación</button>
</form>
</body>
</html>
