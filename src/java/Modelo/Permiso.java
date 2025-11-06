package Modelo;

import java.sql.Date;
import java.sql.Time;

public class Permiso {
    private int id;
    private Empleado empleado;
    private Date fechaPermiso;
    private Time horaSalida;
    private Date fechaRetorno;
    private Time horaRetorno;
    private String motivo;
    private String estado;
    private String observaciones;
    private boolean firmadoJefeArea;
    private boolean firmadoRecursosHumanos;
    private boolean marcadoReincidente;

    public Permiso() {
    }

    public Permiso(int id, Empleado empleado, Date fechaPermiso, Time horaSalida, Date fechaRetorno,
                   Time horaRetorno, String motivo, String estado, String observaciones,
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

    public Date getFechaPermiso() {
        return fechaPermiso;
    }

    public void setFechaPermiso(Date fechaPermiso) {
        this.fechaPermiso = fechaPermiso;
    }

    public Time getHoraSalida() {
        return horaSalida;
    }

    public void setHoraSalida(Time horaSalida) {
        this.horaSalida = horaSalida;
    }

    public Date getFechaRetorno() {
        return fechaRetorno;
    }

    public void setFechaRetorno(Date fechaRetorno) {
        this.fechaRetorno = fechaRetorno;
    }

    public Time getHoraRetorno() {
        return horaRetorno;
    }

    public void setHoraRetorno(Time horaRetorno) {
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
}
