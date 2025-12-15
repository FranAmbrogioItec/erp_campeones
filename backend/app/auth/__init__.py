from flask import Blueprint

# Definimos el Blueprint 'auth'
bp = Blueprint('auth', __name__)

# Importamos las rutas al final para evitar referencias circulares
from app.auth import routes