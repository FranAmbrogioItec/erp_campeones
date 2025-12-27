from flask import Blueprint, jsonify, request
from app.extensions import db
from app.returns.models import NotaCredito
from app.products.models import ProductoVariante, Inventario
from app.sales.models import SesionCaja, MovimientoCaja
from flask_jwt_extended import jwt_required
from app.services.tiendanube_service import tn_service

bp = Blueprint('returns', __name__)

@bp.route('/process', methods=['POST'])
@jwt_required()
def process_returns():
    data = request.get_json()
    items_in = data.get('items_in', [])   # Productos que ENTRAN (Devolución)
    items_out = data.get('items_out', []) # Productos que SALEN (Cambio)

    try:
        # 1. PROCESAR ENTRADAS (Devolver al stock)
        # ========================================
        total_in = 0
        for item in items_in:
            variante = ProductoVariante.query.get(item['id_variante'])
            if variante and variante.inventario:
                # A. Actualizar Local
                variante.inventario.stock_actual += 1
                total_in += float(variante.producto.precio)

                # B. Sincronizar con TIENDA NUBE (Entrada) ☁️
                if variante.tiendanube_variant_id and variante.producto.tiendanube_id:
                    print(f"🔄 Devolución: Aumentando stock TN para {variante.codigo_sku}...")
                    tn_service.update_variant_stock(
                        tn_product_id=variante.producto.tiendanube_id,
                        tn_variant_id=variante.tiendanube_variant_id,
                        new_stock=variante.inventario.stock_actual
                    )

        # 2. PROCESAR SALIDAS (Restar del stock)
        # ======================================
        total_out = 0
        for item in items_out:
            variante = ProductoVariante.query.get(item['id_variante'])
            if variante and variante.inventario:
                # Validar stock negativo si es necesario
                if variante.inventario.stock_actual < 1:
                    db.session.rollback()
                    return jsonify({"msg": f"Sin stock para cambio: {variante.producto.nombre}"}), 400

                # A. Actualizar Local
                variante.inventario.stock_actual -= 1
                total_out += float(variante.producto.precio)

                # B. Sincronizar con TIENDA NUBE (Salida) ☁️
                if variante.tiendanube_variant_id and variante.producto.tiendanube_id:
                    print(f"🔄 Cambio: Descontando stock TN para {variante.codigo_sku}...")
                    tn_service.update_variant_stock(
                        tn_product_id=variante.producto.tiendanube_id,
                        tn_variant_id=variante.tiendanube_variant_id,
                        new_stock=variante.inventario.stock_actual
                    )

        # 3. LÓGICA DE SALDO / NOTA DE CRÉDITO
        # ====================================
        balance = total_out - total_in
        nota_credito = None

        # Si el balance es negativo (El cliente devuelve más valor del que lleva), generar Nota de Crédito
        if balance < 0:
            # Aquí va tu lógica existente de creación de Nota de Crédito...
            # Ejemplo:
            codigo_nc = f"NC-{int(datetime.now().timestamp())}"
            # crear_nota_credito(monto=abs(balance), codigo=codigo_nc) ...
            nota_credito = {
                "codigo": codigo_nc,
                "monto": abs(balance)
            }
        
        # Si el balance es positivo, asumimos que pagó la diferencia en caja (podrías registrar el movimiento si quisieras)

        db.session.commit()
        
        return jsonify({
            "msg": "Cambio procesado y stock sincronizado", 
            "nota_credito": nota_credito
        }), 200

    except Exception as e:
        db.session.rollback()
        print(f"❌ Error en cambio: {e}")
        return jsonify({"msg": "Error al procesar el cambio", "error": str(e)}), 500