from app.extensions import db
from datetime import datetime

class RolEmpleado(db.Model):
    __tablename__ = 'roles_empleados' # Tu nombre exacto de tabla

    id_rol = db.Column(db.Integer, primary_key=True)
    nombre = db.Column(db.String(50), nullable=False)
    descripcion = db.Column(db.String(255))

    # Relación inversa (para poder acceder desde el rol a sus empleados si fuera necesario)
    empleados = db.relationship('Empleado', backref='rol', lazy=True)

    def __repr__(self):
        return f'<Rol {self.nombre}>'

class Empleado(db.Model):
    __tablename__ = 'empleados' # Tu nombre exacto de tabla

    id_empleado = db.Column(db.Integer, primary_key=True)
    nombre = db.Column(db.String(100), nullable=False)
    apellido = db.Column(db.String(100), nullable=False)
    email = db.Column(db.String(120), unique=True, nullable=False)
    password_hash = db.Column(db.String(255), nullable=False) # La columna nueva
    id_rol = db.Column(db.Integer, db.ForeignKey('roles_empleados.id_rol'), nullable=False)
    fecha_ingreso = db.Column(db.DateTime, default=datetime.utcnow)
    
    # Propiedad extra para desactivar usuarios (aunque no está en tu DB, es útil en el código)
    # Si quieres persistirlo, deberías agregar la columna 'is_active' a tu tabla también.
    # Por ahora lo dejaremos como True por defecto en la lógica.

    def __repr__(self):
        return f'<Empleado {self.email}>'   