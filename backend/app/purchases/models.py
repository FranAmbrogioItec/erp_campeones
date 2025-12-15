# backend/app/purchases/models.py
from app.extensions import db
from datetime import datetime

class Proveedor(db.Model):
    __tablename__ = 'proveedores'
    __table_args__ = {'extend_existing': True}

    id_proveedor = db.Column(db.Integer, primary_key=True)
    nombre = db.Column(db.String(100), nullable=False)
    contacto = db.Column(db.String(100)) # Email o Teléfono
    cuit = db.Column(db.String(20))

class Compra(db.Model):
    __tablename__ = 'compras'
    __table_args__ = {'extend_existing': True}

    id_compra = db.Column(db.Integer, primary_key=True)
    fecha = db.Column(db.DateTime, default=datetime.now)
    total = db.Column(db.Numeric(10, 2), nullable=False)
    observaciones = db.Column(db.String(255))
    
    id_proveedor = db.Column(db.Integer, db.ForeignKey('proveedores.id_proveedor'), nullable=True)
    proveedor = db.relationship('Proveedor', backref='compras')

    # Relación con los detalles
    detalles = db.relationship('DetalleCompra', backref='compra', lazy=True, cascade="all, delete-orphan")

class DetalleCompra(db.Model):
    __tablename__ = 'detalles_compra'
    __table_args__ = {'extend_existing': True}

    id_detalle = db.Column(db.Integer, primary_key=True)
    id_compra = db.Column(db.Integer, db.ForeignKey('compras.id_compra'), nullable=False)
    
    # Vinculamos con el producto que ya existe en tu sistema
    id_variante = db.Column(db.Integer, db.ForeignKey('producto_variantes.id_variante'), nullable=False)
    
    cantidad = db.Column(db.Integer, nullable=False)
    costo_unitario = db.Column(db.Numeric(10, 2), nullable=False)
    subtotal = db.Column(db.Numeric(10, 2), nullable=False)

    # Relación para acceder a los datos del producto (Nombre, Talle)
    variante = db.relationship('app.products.models.ProductoVariante')