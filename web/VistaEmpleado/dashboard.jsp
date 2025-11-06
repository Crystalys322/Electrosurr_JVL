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
    <title>Panel del Empleado</title>
    <link rel="stylesheet" href="../css/estilos.css">
</head>
<body>
<h2>Bienvenido, <%= empleado.getNombres() %> <%= empleado.getApellidos() %></h2>
<nav>
    <a href="formularioPermiso.jsp">Solicitar permiso</a>
    <form action="../PermisoController" method="post" style="display:inline;">
        <input type="hidden" name="accion" value="listarMisPermisos">
        <button type="submit">Mis permisos</button>
    </form>
    <form action="../PermisoController" method="post" style="display:inline;">
        <input type="hidden" name="accion" value="logout">
        <button type="submit">Cerrar sesión</button>
    </form>
</nav>
<% String mensaje = (String) request.getAttribute("mensaje");
   if (mensaje != null) { %>
    <div class="alerta"><%= mensaje %></div>
<% } %>
<section>
    <p>Horas acumuladas: <strong><%= empleado.getHorasAcumuladas() %></strong></p>
    <p>Estado reincidente: <strong><%= empleado.isReincidente() ? "Sí" : "No" %></strong></p>
</section>
</body>
</html>
