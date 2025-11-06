package Modelo;

public class Empleado {
    private int id;
    private String nombres;
    private String apellidos;
    private String documento;
    private String correo;
    private String password;
    private String rol;
    private int areaId;
    private double horasAcumuladas;
    private boolean reincidente;

    public Empleado() {
    }

    public Empleado(int id, String nombres, String apellidos, String documento, String correo,
                    String password, String rol, int areaId, double horasAcumuladas, boolean reincidente) {
        this.id = id;
        this.nombres = nombres;
        this.apellidos = apellidos;
        this.documento = documento;
        this.correo = correo;
        this.password = password;
        this.rol = rol;
        this.areaId = areaId;
        this.horasAcumuladas = horasAcumuladas;
        this.reincidente = reincidente;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getNombres() {
        return nombres;
    }

    public void setNombres(String nombres) {
        this.nombres = nombres;
    }

    public String getApellidos() {
        return apellidos;
    }

    public void setApellidos(String apellidos) {
        this.apellidos = apellidos;
    }

    public String getDocumento() {
        return documento;
    }

    public void setDocumento(String documento) {
        this.documento = documento;
    }

    public String getCorreo() {
        return correo;
    }

    public void setCorreo(String correo) {
        this.correo = correo;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getRol() {
        return rol;
    }

    public void setRol(String rol) {
        this.rol = rol;
    }

    public int getAreaId() {
        return areaId;
    }

    public void setAreaId(int areaId) {
        this.areaId = areaId;
    }

    public double getHorasAcumuladas() {
        return horasAcumuladas;
    }

    public void setHorasAcumuladas(double horasAcumuladas) {
        this.horasAcumuladas = horasAcumuladas;
    }

    public boolean isReincidente() {
        return reincidente;
    }

    public void setReincidente(boolean reincidente) {
        this.reincidente = reincidente;
    }
}
