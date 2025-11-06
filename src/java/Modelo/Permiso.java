package Modelo;

import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;

public class Permiso {
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    private static final DateTimeFormatter TIME_FORMATTER = DateTimeFormatter.ofPattern("HH:mm");

    private int id;
    private Empleado empleado;
    private LocalDate fechaPermiso;
    private LocalTime horaSalida;
    private LocalDate fechaRetorno;
    private LocalTime horaRetorno;
    private String motivo;
    private String estado;
    private String observaciones;
    private boolean firmadoJefeArea;
    private boolean firmadoRecursosHumanos;
    private boolean marcadoReincidente;

    public Permiso() {
    }

    public Permiso(int id, Empleado empleado, LocalDate fechaPermiso, LocalTime horaSalida, LocalDate fechaRetorno,
                   LocalTime horaRetorno, String motivo, String estado, String observaciones,
                   boolean firmadoJefeArea, boolean firmadoRecursosHumanos, boolean marcadoReincidente) {
        this.id = id;
        this.empleado = empleado;
        this.fechaPermiso = fechaPermiso;
        this.horaSalida = horaSalida;
        this.fechaRetorno = fechaRetorno;
        this.horaRetorno = horaRetorno;
        this.motivo = motivo;
        this.estado = estado;
        this.observaciones = observaciones;
        this.firmadoJefeArea = firmadoJefeArea;
        this.firmadoRecursosHumanos = firmadoRecursosHumanos;
        this.marcadoReincidente = marcadoReincidente;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Empleado getEmpleado() {
        return empleado;
    }

    public void setEmpleado(Empleado empleado) {
        this.empleado = empleado;
    }

    public LocalDate getFechaPermiso() {
        return fechaPermiso;
    }

    public void setFechaPermiso(LocalDate fechaPermiso) {
        this.fechaPermiso = fechaPermiso;
    }

    public LocalTime getHoraSalida() {
        return horaSalida;
    }

    public void setHoraSalida(LocalTime horaSalida) {
        this.horaSalida = horaSalida;
    }

    public LocalDate getFechaRetorno() {
        return fechaRetorno;
    }

    public void setFechaRetorno(LocalDate fechaRetorno) {
        this.fechaRetorno = fechaRetorno;
    }

    public LocalTime getHoraRetorno() {
        return horaRetorno;
    }

    public void setHoraRetorno(LocalTime horaRetorno) {
        this.horaRetorno = horaRetorno;
    }

    public String getMotivo() {
        return motivo;
    }

    public void setMotivo(String motivo) {
        this.motivo = motivo;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public String getObservaciones() {
        return observaciones;
    }

    public void setObservaciones(String observaciones) {
        this.observaciones = observaciones;
    }

    public boolean isFirmadoJefeArea() {
        return firmadoJefeArea;
    }

    public void setFirmadoJefeArea(boolean firmadoJefeArea) {
        this.firmadoJefeArea = firmadoJefeArea;
    }

    public boolean isFirmadoRecursosHumanos() {
        return firmadoRecursosHumanos;
    }

    public void setFirmadoRecursosHumanos(boolean firmadoRecursosHumanos) {
        this.firmadoRecursosHumanos = firmadoRecursosHumanos;
    }

    public boolean isMarcadoReincidente() {
        return marcadoReincidente;
    }

    public void setMarcadoReincidente(boolean marcadoReincidente) {
        this.marcadoReincidente = marcadoReincidente;
    }

    public String getFechaPermisoFormateada() {
        return fechaPermiso != null ? fechaPermiso.format(DATE_FORMATTER) : "";
    }

    public String getFechaRetornoFormateada() {
        return fechaRetorno != null ? fechaRetorno.format(DATE_FORMATTER) : "";
    }

    public String getHoraSalidaFormateada() {
        return horaSalida != null ? horaSalida.format(TIME_FORMATTER) : "";
    }

    public String getHoraRetornoFormateada() {
        return horaRetorno != null ? horaRetorno.format(TIME_FORMATTER) : "";
    }
}
