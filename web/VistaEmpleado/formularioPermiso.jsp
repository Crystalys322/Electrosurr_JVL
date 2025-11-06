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
    <title>Solicitud de Permiso</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
    <link rel="stylesheet" href="../css/estilos.css">
</head>
<body>
<nav class="navbar navbar-expand-lg brand-navbar shadow-sm">
    <div class="container">
        <a class="navbar-brand fw-semibold text-uppercase" href="dashboard.jsp">Electrosur</a>
        <form action="../PermisoController" method="post" class="d-inline ms-auto">
            <input type="hidden" name="accion" value="logout">
            <button type="submit" class="btn btn-light btn-sm text-primary">Cerrar sesión</button>
        </form>
    </div>
</nav>
<section class="container py-5">
    <div class="row justify-content-center">
        <div class="col-lg-9">
            <div class="card brand-card p-4">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h2 class="brand-section-title mb-1">Nueva solicitud</h2>
                        <p class="text-muted mb-0">Completa la información para enviar la boleta de permiso.</p>
                    </div>
                    <a href="dashboard.jsp" class="link-muted">&larr; Volver al panel</a>
                </div>
                <% String mensaje = (String) request.getAttribute("mensaje");
                   if (mensaje != null) { %>
                <div class="alert alert-brand" role="alert">
                    <%= mensaje %>
                </div>
                <% } %>
                <form action="../PermisoController" method="post" class="row g-4">
                    <input type="hidden" name="accion" value="registrarPermiso">
                    <div class="col-12">
                        <h3 class="h6 text-uppercase text-secondary">Datos del colaborador</h3>
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label text-muted">Nombre completo</label>
                                <div class="form-control bg-light"><%= empleado.getNombres() %> <%= empleado.getApellidos() %></div>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label text-muted">Documento</label>
                                <div class="form-control bg-light"><%= empleado.getDocumento() %></div>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label text-muted">Área</label>
                                <div class="form-control bg-light">#<%= empleado.getAreaId() %></div>
                            </div>
                        </div>
                    </div>
                    <div class="col-12">
                        <h3 class="h6 text-uppercase text-secondary">Detalle del permiso</h3>
                        <div class="row g-3">
                            <div class="col-md-3">
                                <label for="fechaPermiso" class="form-label">Fecha de permiso</label>
                                <input type="date" class="form-control" id="fechaPermiso" name="fechaPermiso" required>
                            </div>
                            <div class="col-md-3">
                                <label for="horaSalida" class="form-label">Hora de salida</label>
                                <input type="time" class="form-control" id="horaSalida" name="horaSalida" required>
                            </div>
                            <div class="col-md-3">
                                <label for="fechaRetorno" class="form-label">Fecha de retorno</label>
                                <input type="date" class="form-control" id="fechaRetorno" name="fechaRetorno" required>
                            </div>
                            <div class="col-md-3">
                                <label for="horaRetorno" class="form-label">Hora de retorno</label>
                                <input type="time" class="form-control" id="horaRetorno" name="horaRetorno" required>
                            </div>
                            <div class="col-12">
                                <label for="motivo" class="form-label">Motivo del permiso</label>
                                <textarea class="form-control" id="motivo" name="motivo" rows="4" placeholder="Describe claramente el motivo y las actividades previstas" required></textarea>
                            </div>
                        </div>
                    </div>
                    <div class="col-12 d-flex justify-content-between align-items-center">
                        <span class="text-muted small">Se notificará automáticamente al jefe de área correspondiente.</span>
                        <button type="submit" class="btn btn-primary btn-lg">Enviar solicitud</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</section>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL" crossorigin="anonymous"></script>
</body>
</html>
