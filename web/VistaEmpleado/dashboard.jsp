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
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Panel del Empleado</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
    <link rel="stylesheet" href="../css/estilos.css">
</head>
<body>
<nav class="navbar navbar-expand-lg brand-navbar shadow-sm">
    <div class="container">
        <span class="navbar-brand fw-semibold text-uppercase">Electrosur</span>
        <div class="d-flex align-items-center gap-2">
            <a class="btn btn-outline-light btn-sm" href="formularioPermiso.jsp">Solicitar permiso</a>
            <form action="../PermisoController" method="post" class="d-inline">
                <input type="hidden" name="accion" value="listarMisPermisos">
                <button type="submit" class="btn btn-outline-light btn-sm">Mis permisos</button>
            </form>
            <form action="../PermisoController" method="post" class="d-inline">
                <input type="hidden" name="accion" value="logout">
                <button type="submit" class="btn btn-light btn-sm text-primary">Cerrar sesión</button>
            </form>
        </div>
    </div>
</nav>
<section class="container py-5">
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="card brand-card p-4">
                <div class="d-flex justify-content-between align-items-start mb-4">
                    <div>
                        <h2 class="brand-section-title mb-1">Hola, <%= empleado.getNombres() %> <%= empleado.getApellidos() %></h2>
                        <p class="text-muted mb-0">Documento: <strong><%= empleado.getDocumento() %></strong></p>
                    </div>
                    <span class="badge rounded-pill bg-light text-primary">Área #<%= empleado.getAreaId() %></span>
                </div>
                <% String mensaje = (String) request.getAttribute("mensaje");
                   if (mensaje != null) { %>
                <div class="alert alert-brand mb-4" role="alert">
                    <%= mensaje %>
                </div>
                <% } %>
                <div class="row text-center">
                    <div class="col-md-6 mb-3 mb-md-0">
                        <div class="p-4 bg-light rounded-4 shadow-soft">
                            <small class="text-uppercase text-muted">Horas acumuladas</small>
                            <h3 class="mb-0 text-primary"><%= String.format("%.2f", empleado.getHorasAcumuladas()) %> h</h3>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="p-4 bg-light rounded-4 shadow-soft">
                            <small class="text-uppercase text-muted">Condición</small>
                            <h3 class="mb-0 <%= empleado.isReincidente() ? "text-danger" : "text-success" %>">
                                <%= empleado.isReincidente() ? "Reincidente" : "Óptimo" %>
                            </h3>
                        </div>
                    </div>
                </div>
                <div class="mt-5">
                    <h3 class="h5 text-secondary">Próximos pasos</h3>
                    <ul class="list-unstyled text-muted mb-0">
                        <li class="mb-2">• Revisa el historial de permisos para conocer el estado de tus solicitudes.</li>
                        <li class="mb-2">• Verifica que tus datos personales estén actualizados con Recursos Humanos.</li>
                        <li>• Recuerda cumplir estrictamente los horarios aprobados para evitar observaciones.</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</section>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL" crossorigin="anonymous"></script>
</body>
</html>
