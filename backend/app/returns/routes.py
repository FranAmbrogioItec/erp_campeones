from flask import Blueprint, jsonify, request
from app.extensions import db
from app.returns.models import NotaCredito
from app.products.models import ProductoVariante, Inventario
from app.sales.models import SesionCaja, MovimientoCaja
from flask_jwt_extended import jwt_required

bp = Blueprint('returns', __name__)

@bp.route('/process', methods=['POST'])
@jwt_required()
def process_return():
    data = request.get_json()
    items_in = data.get('items_in', [])   # Lo que devuelve el cliente
    items_out = data.get('items_out', []) # Lo que se lleva
    
    total_in = sum(item['precio'] * item.get('cantidad', 1) for item in items_in)
    total_out = sum(item['precio'] * item.get('cantidad', 1) for item in items_out)
    
    balance = total_out - total_in 
    # Balance > 0: Cliente paga diferencia.
    # Balance < 0: Saldo a favor (Nota Crédito).
    # Balance = 0: Cambio mano a mano.

    try:
        # 1. PROCESAR DEVOLUCIONES (Aumentar Stock)
        for item in items_in:
            variante = ProductoVariante.query.get(item['id_variante'])
            if variante and variante.inventario:
                variante.inventario.stock_actual += int(item.get('cantidad', 1))

        # 2. PROCESAR SALIDAS (Restar Stock)
        for item in items_out:
            variante = ProductoVariante.query.get(item['id_variante'])
            if not variante or not variante.inventario:
                return jsonify({"msg": f"Error stock: {item['nombre']}"}), 400
            if variante.inventario.stock_actual < int(item.get('cantidad', 1)):
                return jsonify({"msg": f"Sin stock para cambio: {variante.producto.nombre}"}), 400
            
            variante.inventario.stock_actual -= int(item.get('cantidad', 1))

        response_data = {"msg": "Cambio realizado", "action": "swap"}

        # 3. MANEJAR DINERO
        if balance > 0:
            # Cliente paga diferencia -> Ingreso a caja
            sesion = SesionCaja.query.filter_by(estado='abierta').first()
            if sesion:
                mov = MovimientoCaja(
                    id_sesion=sesion.id_sesion,
                    tipo='ingreso', # Tipo especial ingreso
                    monto=balance,
                    descripcion=f"Diferencia por cambio de productos"
                )
                db.session.add(mov)
                response_data["msg"] = f"Cambio exitoso. Se cobraron ${balance} de diferencia."
            else:
                return jsonify({"msg": "No se puede cobrar diferencia (Caja Cerrada)"}), 400

        elif balance < 0:
            # Saldo a favor -> Generar Nota de Crédito
            saldo_favor = abs(balance)
            nota = NotaCredito(monto=saldo_favor, observaciones="Saldo a favor por devolución")
            db.session.add(nota)
            db.session.flush() # Para generar el código
            
            response_data["msg"] = "Devolución exitosa."
            response_data["nota_credito"] = {
                "codigo": nota.codigo,
                "monto": float(nota.monto)
            }

        db.session.commit()
        return jsonify(response_data), 200

    except Exception as e:
        db.session.rollback()
        return jsonify({"msg": str(e)}), 500