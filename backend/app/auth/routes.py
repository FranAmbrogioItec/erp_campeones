from flask import request, jsonify
# CAMBIO AQUI: Usamos '.' en lugar de 'app.auth' para evitar el ciclo
from . import bp 
from app.auth.models import Empleado
from werkzeug.security import check_password_hash
from flask_jwt_extended import create_access_token, jwt_required, get_jwt_identity

@bp.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    email = data.get('email')
    password = data.get('password')

    if not email or not password:
        return jsonify({"msg": "Faltan datos (email o password)"}), 400

    user = Empleado.query.filter_by(email=email).first()

    if user and check_password_hash(user.password_hash, password):
        access_token = create_access_token(
            identity=str(user.id_empleado), 
            additional_claims={"rol": user.rol.nombre, "nombre": user.nombre}
        )

        return jsonify({
            "msg": "Login exitoso",
            "access_token": access_token,
            "user": {
                "id": user.id_empleado,
                "email": user.email,
                "nombre": user.nombre,
                "rol": user.rol.nombre
            }
        }), 200

    return jsonify({"msg": "Credenciales inválidas"}), 401

@bp.route('/me', methods=['GET'])
@jwt_required()
def me():
    current_user_id = get_jwt_identity()
    user = Empleado.query.get(current_user_id)
    
    return jsonify({
        "id": user.id_empleado,
        "email": user.email,
        "rol": user.rol.nombre
    }), 200