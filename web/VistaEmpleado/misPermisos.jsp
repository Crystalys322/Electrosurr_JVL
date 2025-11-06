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
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Mis permisos</title>
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
        <div class="col-lg-10">
            <div class="card brand-card p-4">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h2 class="brand-section-title mb-1">Historial de permisos</h2>
                        <p class="text-muted mb-0">Consulta el estado de cada solicitud realizada.</p>
                    </div>
                    <a href="dashboard.jsp" class="link-muted">&larr; Volver al panel</a>
                </div>
                <% String mensaje = (String) request.getAttribute("mensaje");
                   if (mensaje != null) { %>
                <div class="alert alert-brand" role="alert">
                    <%= mensaje %>
                </div>
                <% } %>
                <div class="table-responsive shadow-soft table-rounded">
                    <table class="table align-middle mb-0">
                        <thead>
                        <tr>
                            <th>Fecha permiso</th>
                            <th>Horario</th>
                            <th>Motivo</th>
                            <th class="text-center">Estado</th>
                            <th>Observaciones</th>
                        </tr>
                        </thead>
                        <tbody>
                        <% if (permisos != null && !permisos.isEmpty()) {
                               for (Permiso permiso : permisos) {
                                   String estado = permiso.getEstado();
                                   String badgeClass = "pendiente";
                                   if ("APROBADO".equalsIgnoreCase(estado)) {
                                       badgeClass = "aprobado";
                                   } else if ("DENEGADO".equalsIgnoreCase(estado)) {
                                       badgeClass = "denegado";
                                   }
                        %>
                        <tr>
                            <td>
                                <span class="fw-semibold"><%= permiso.getFechaPermiso() %></span><br>
                                <small class="text-muted">Regreso: <%= permiso.getFechaRetorno() %></small>
                            </td>
                            <td>
                                <span class="badge bg-light text-dark">Salida <%= permiso.getHoraSalida() %></span><br>
                                <span class="badge bg-light text-dark mt-1">Retorno <%= permiso.getHoraRetorno() %></span>
                            </td>
                            <td><%= permiso.getMotivo() %></td>
                            <td class="text-center">
                                <span class="badge badge-status <%= badgeClass %>"><%= estado %></span>
                            </td>
                            <td><%= permiso.getObservaciones() != null ? permiso.getObservaciones() : "Sin observaciones" %></td>
                        </tr>
                        <%       }
                               } else { %>
                        <tr>
                            <td colspan="5" class="text-center text-muted py-4">No tienes solicitudes registradas.</td>
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
