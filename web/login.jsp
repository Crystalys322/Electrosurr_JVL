<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Portal de Permisos - Electrosur</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
    <link rel="stylesheet" href="css/estilos.css">
</head>
<body class="d-flex align-items-center py-5">
<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-6 col-lg-5">
            <div class="card brand-card shadow-soft p-4">
                <div class="text-center mb-4">
                    <h1 class="h3 fw-semibold text-uppercase text-primary">Electrosur</h1>
                    <p class="text-muted mb-0">Portal de gestión de permisos</p>
                </div>
                <% String mensaje = (String) request.getAttribute("mensaje");
                   if (mensaje != null) { %>
                <div class="alert alert-brand alert-dismissible fade show" role="alert">
                    <%= mensaje %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Cerrar"></button>
                </div>
                <% } %>
                <form action="PermisoController" method="post" class="needs-validation" novalidate>
                    <input type="hidden" name="accion" value="login"/>
                    <div class="mb-3">
                        <label for="usuario" class="form-label">Usuario (correo institucional)</label>
                        <input type="email" class="form-control form-control-lg" id="usuario" name="usuario" placeholder="usuario@electrosur.com" required>
                        <div class="invalid-feedback">Ingrese su correo corporativo.</div>
                    </div>
                    <div class="mb-4">
                        <label for="password" class="form-label">Contraseña</label>
                        <input type="password" class="form-control form-control-lg" id="password" name="password" placeholder="••••••••" required>
                        <div class="invalid-feedback">La contraseña es obligatoria.</div>
                    </div>
                    <div class="d-grid gap-2">
                        <button type="submit" class="btn btn-primary btn-lg">Ingresar</button>
                        <span class="small text-muted">Acceso exclusivo para colaboradores de Electrosur.</span>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL" crossorigin="anonymous"></script>
<script>
    (() => {
        const forms = document.querySelectorAll('.needs-validation');
        Array.from(forms).forEach(form => {
            form.addEventListener('submit', event => {
                if (!form.checkValidity()) {
                    event.preventDefault();
                    event.stopPropagation();
                }
                form.classList.add('was-validated');
            }, false);
        });
    })();
</script>
</body>
</html>
