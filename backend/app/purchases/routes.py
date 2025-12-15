from flask import Blueprint, jsonify, request
from app.extensions import db
from app.purchases.models import Proveedor, Compra, DetalleCompra
from app.products.models import ProductoVariante, Inventario
from flask_jwt_extended import jwt_required
from sqlalchemy import desc

bp = Blueprint('purchases', __name__)

# --- PROVEEDORES ---
@bp.route('/providers', methods=['GET'])
@jwt_required()
def get_providers():
    provs = Proveedor.query.all()
    return jsonify([{"id": p.id_proveedor, "nombre": p.nombre} for p in provs]), 200

@bp.route('/providers', methods=['POST'])
@jwt_required()
def create_provider():
    data = request.get_json()
    new_p = Proveedor(nombre=data.get('nombre'), contacto=data.get('contacto'))
    db.session.add(new_p)
    db.session.commit()
    return jsonify({"msg": "Proveedor creado", "id": new_p.id_proveedor}), 201

# --- COMPRAS ---

# 1. REGISTRAR NUEVA COMPRA (INGRESO DE STOCK)
@bp.route('', methods=['POST'])
@jwt_required()
def create_purchase():
    data = request.get_json()
    items = data.get('items', []) # Lista de { id_variante, cantidad, costo }
    
    if not items: return jsonify({"msg": "La compra está vacía"}), 400

    try:
        # A. Crear Cabecera
        nueva_compra = Compra(
            total=data.get('total', 0),
            id_proveedor=data.get('id_proveedor'),
            observaciones=data.get('observaciones', '')
        )
        db.session.add(nueva_compra)
        db.session.flush()

        # B. Procesar Ítems
        for item in items:
            # 1. Guardar Detalle
            costo = float(item.get('costo', 0))
            cantidad = int(item.get('cantidad', 0))
            
            detalle = DetalleCompra(
                id_compra=nueva_compra.id_compra,
                id_variante=item['id_variante'],
                cantidad=cantidad,
                costo_unitario=costo,
                subtotal=costo * cantidad
            )
            db.session.add(detalle)

            # 2. ACTUALIZAR STOCK (SUMAR)
            # Buscamos el inventario de esa variante
            inv = Inventario.query.filter_by(id_variante=item['id_variante']).first()
            if inv:
                inv.stock_actual += cantidad # Sumamos lo que compramos
            else:
                # Si por algún error no tenía inventario, lo creamos
                new_inv = Inventario(id_variante=item['id_variante'], stock_actual=cantidad)
                db.session.add(new_inv)

        db.session.commit()
        return jsonify({"msg": "Compra registrada y stock actualizado", "id": nueva_compra.id_compra}), 201

    except Exception as e:
        db.session.rollback()
        return jsonify({"msg": str(e)}), 500

# 2. HISTORIAL DE COMPRAS
@bp.route('/history', methods=['GET'])
@jwt_required()
def get_purchase_history():
    # Ordenamos por fecha descendente
    compras = Compra.query.options(db.joinedload(Compra.proveedor)).order_by(desc(Compra.fecha)).limit(50).all()
    
    resultado = []
    for c in compras:
        # 1. Resumen Texto
        resumen_items = f"{len(c.detalles)} productos"
        
        # 2. Detalle completo para el Modal y la Impresión
        items_detail = []
        for d in c.detalles:
            items_detail.append({
                "nombre": d.variante.producto.nombre,
                "talle": d.variante.talla,
                "sku": d.variante.codigo_sku,
                "cantidad": d.cantidad,
                "costo": float(d.costo_unitario),
                "subtotal": float(d.subtotal)
            })

        resultado.append({
            "id": c.id_compra,
            "fecha": c.fecha.strftime('%d/%m/%Y %H:%M'),
            "proveedor": c.proveedor.nombre if c.proveedor else "General",
            "total": float(c.total),
            "items_count": resumen_items,
            "items_detail": items_detail, # <--- DATO NUEVO
            "observaciones": c.observaciones
        })
        
    return jsonify(resultado), 200