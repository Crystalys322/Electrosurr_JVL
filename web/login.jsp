<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Portal de Permisos - Electrosur</title>
    <link rel="stylesheet" href="css/estilos.css">
</head>
<body>
<h2>Ingreso al portal</h2>
<% String mensaje = (String) request.getAttribute("mensaje");
   if (mensaje != null) { %>
    <div class="alerta"><%= mensaje %></div>
<% } %>
<form action="PermisoController" method="post">
    <input type="hidden" name="accion" value="login"/>
    <div>
        <label for="usuario">Usuario (correo):</label>
        <input type="text" id="usuario" name="usuario" required>
    </div>
    <div>
        <label for="password">Contraseña:</label>
        <input type="password" id="password" name="password" required>
    </div>
    <button type="submit">Ingresar</button>
</form>
</body>
</html>
