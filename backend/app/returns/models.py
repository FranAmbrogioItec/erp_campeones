# backend/app/returns/models.py
from app.extensions import db
from datetime import datetime
import uuid

class NotaCredito(db.Model):
    __tablename__ = 'notas_credito'
    __table_args__ = {'extend_existing': True}

    id_nota = db.Column(db.Integer, primary_key=True)
    # Generamos un código único alfanumérico (Ej: NC-A1B2)
    codigo = db.Column(db.String(50), unique=True, nullable=False)
    monto = db.Column(db.Numeric(10, 2), nullable=False)
    fecha_emision = db.Column(db.DateTime, default=datetime.now)
    estado = db.Column(db.String(20), default='valida') # 'valida', 'usada'
    
    # Opcional: Relación con la devolución original si quisieras traquearla
    observaciones = db.Column(db.String(255)) 

    def __init__(self, monto, observaciones=''):
        self.codigo = f"NC-{str(uuid.uuid4())[:8].upper()}" # Genera código auto
        self.monto = monto
        self.observaciones = observaciones