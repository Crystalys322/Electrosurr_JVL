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
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Permisos pendientes - Recursos Humanos</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
    <link rel="stylesheet" href="../css/estilos.css">
</head>
<body>
<nav class="navbar navbar-expand-lg brand-navbar shadow-sm">
    <div class="container">
        <span class="navbar-brand fw-semibold text-uppercase">Electrosur</span>
        <span class="navbar-text ms-auto">Jefe RR.HH.: <strong><%= jefe.getNombres() %> <%= jefe.getApellidos() %></strong></span>
        <form action="../PermisoController" method="post" class="d-inline ms-3">
            <input type="hidden" name="accion" value="logout">
            <button type="submit" class="btn btn-light btn-sm text-primary">Cerrar sesión</button>
        </form>
    </div>
</nav>
<section class="container py-5">
    <div class="row justify-content-center">
        <div class="col-12">
            <div class="card brand-card p-4">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h2 class="brand-section-title mb-1">Solicitudes para validación final</h2>
                        <p class="text-muted mb-0">Controla las horas acumuladas y registra la ejecución del permiso.</p>
                    </div>
                    <span class="badge bg-light text-primary">Permisos en cola: <%= permisosPendientes != null ? permisosPendientes.size() : 0 %></span>
                </div>
                <% String mensaje = (String) request.getAttribute("mensaje");
                   if (mensaje != null) { %>
                <div class="alert alert-brand" role="alert">
                    <%= mensaje %>
                </div>
                <% } %>
                <div class="table-responsive shadow-soft table-rounded">
                    <table class="table align-middle">
                        <thead>
                        <tr>
                            <th>Colaborador</th>
                            <th>Control horario</th>
                            <th>Detalle del permiso</th>
                            <th class="text-center">Acciones</th>
                        </tr>
                        </thead>
                        <tbody>
                        <% if (permisosPendientes != null && !permisosPendientes.isEmpty()) {
                               for (Permiso permiso : permisosPendientes) {
                                   Empleado empleadoPermiso = permiso.getEmpleado();
                        %>
                        <tr>
                            <td>
                                <div class="fw-semibold"><%= empleadoPermiso.getNombres() %> <%= empleadoPermiso.getApellidos() %></div>
                                <small class="text-muted">Documento: <%= empleadoPermiso.getDocumento() %></small>
                            </td>
                            <td>
                                <div class="d-flex flex-column gap-1">
                                    <span class="badge bg-light text-dark">Horas acumuladas: <%= empleadoPermiso.getHorasAcumuladas() %></span>
                                    <span class="badge <%= empleadoPermiso.getHorasAcumuladas() > 50 ? "bg-danger" : "bg-success" %>">
                                        <%= empleadoPermiso.getHorasAcumuladas() > 50 ? "Excede límite permitido" : "Dentro del rango" %>
                                    </span>
                                </div>
                            </td>
                            <td>
                                <div><strong>Del</strong> <%= permiso.getFechaPermisoFormateada() %> <strong>al</strong> <%= permiso.getFechaRetornoFormateada() %></div>
                                <div class="small text-muted">Salida <%= permiso.getHoraSalidaFormateada() %> · Retorno <%= permiso.getHoraRetornoFormateada() %></div>
                                <div class="mt-2"><strong>Motivo:</strong> <%= permiso.getMotivo() %></div>
                            </td>
                            <td class="text-center">
                                <div class="d-flex flex-column gap-2">
                                    <form action="../PermisoController" method="post" class="d-grid gap-2">
                                        <input type="hidden" name="accion" value="aprobarRRHH">
                                        <input type="hidden" name="permisoId" value="<%= permiso.getId() %>">
                                        <button type="submit" class="btn btn-success btn-sm">Aprobar</button>
                                    </form>
                                    <form action="../PermisoController" method="post" class="d-grid gap-2">
                                        <input type="hidden" name="accion" value="denegarRRHH">
                                        <input type="hidden" name="permisoId" value="<%= permiso.getId() %>">
                                        <button type="submit" class="btn btn-outline-danger btn-sm">Denegar</button>
                                    </form>
                                    <form action="../PermisoController" method="post" class="d-grid gap-2">
                                        <input type="hidden" name="accion" value="registrarEjecucion">
                                        <input type="hidden" name="permisoId" value="<%= permiso.getId() %>">
                                        <div class="form-floating">
                                            <select class="form-select" id="cumplioHorario<%= permiso.getId() %>" name="cumplioHorario">
                                                <option value="true">Cumplió horario</option>
                                                <option value="false">Incumplimiento</option>
                                            </select>
                                            <label for="cumplioHorario<%= permiso.getId() %>">Ejecución del permiso</label>
                                        </div>
                                        <button type="submit" class="btn btn-warning btn-sm text-dark">Registrar ejecución</button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                        <%       }
                               } else { %>
                        <tr>
                            <td colspan="4" class="text-center text-muted py-4">No hay permisos pendientes para revisar.</td>
                        </tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</section>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL" crossorigin="anonymous"></script>
</body>
</html>
