import io
import os
from werkzeug.utils import secure_filename
from flask import jsonify, request, send_file, current_app
from app.products import bp
# IMPORTAMOS DESDE EL ARCHIVO DE PRODUCTOS
from app.products.models import Producto, ProductoVariante, Categoria, CategoriaEspecifica, Inventario
from app.extensions import db
from flask_jwt_extended import jwt_required
import barcode
from barcode.writer import ImageWriter
from sqlalchemy import or_
from reportlab.graphics.barcode import code128
from reportlab.graphics import renderPDF
from reportlab.pdfgen import canvas
from reportlab.lib.units import mm
from reportlab.lib.pagesizes import A4


# ==========================================
# 1. CRUD DE CATEGORÍAS
# ==========================================

@bp.route('/categories', methods=['GET'])
@jwt_required()
def get_categories():
    cats = Categoria.query.all()
    return jsonify([{"id": c.id_categoria, "nombre": c.nombre} for c in cats]), 200

@bp.route('/categories', methods=['POST'])
@jwt_required()
def create_category():
    data = request.get_json()
    if not data.get('nombre'): return jsonify({"msg": "Nombre requerido"}), 400
    
    new_cat = Categoria(nombre=data['nombre'])
    db.session.add(new_cat)
    db.session.commit()
    return jsonify({"msg": "Categoría creada", "id": new_cat.id_categoria}), 201

@bp.route('/categories/<int:id>', methods=['PUT'])
@jwt_required()
def update_category(id):
    cat = Categoria.query.get_or_404(id)
    data = request.get_json()
    cat.nombre = data.get('nombre', cat.nombre)
    db.session.commit()
    return jsonify({"msg": "Categoría actualizada"}), 200

@bp.route('/categories/<int:id>', methods=['DELETE'])
@jwt_required()
def delete_category(id):
    cat = Categoria.query.get_or_404(id)
    try:
        db.session.delete(cat)
        db.session.commit()
        return jsonify({"msg": "Categoría eliminada"}), 200
    except Exception:
        db.session.rollback()
        return jsonify({"msg": "No se puede eliminar: Hay productos usando esta categoría"}), 400

# ==========================================
# 3. CRUD DE CATEGORÍAS ESPECÍFICAS (LIGAS)
# ==========================================

@bp.route('/specific-categories', methods=['GET'])
@jwt_required()
def get_specific_categories():
    specs = CategoriaEspecifica.query.all()
    return jsonify([{"id": c.id_categoria_especifica, "nombre": c.nombre} for c in specs]), 200

@bp.route('/specific-categories', methods=['POST'])
@jwt_required()
def create_specific_category():
    data = request.get_json()
    if not data.get('nombre'): return jsonify({"msg": "Nombre requerido"}), 400
    
    new_spec = CategoriaEspecifica(nombre=data['nombre'])
    db.session.add(new_spec)
    db.session.commit()
    return jsonify({"msg": "Liga/Tipo creado", "id": new_spec.id_categoria_especifica}), 201

@bp.route('/specific-categories/<int:id>', methods=['PUT'])
@jwt_required()
def update_specific_category(id):
    spec = CategoriaEspecifica.query.get_or_404(id)
    data = request.get_json()
    spec.nombre = data.get('nombre', spec.nombre)
    db.session.commit()
    return jsonify({"msg": "Actualizado correctamente"}), 200

@bp.route('/specific-categories/<int:id>', methods=['DELETE'])
@jwt_required()
def delete_specific_category(id):
    spec = CategoriaEspecifica.query.get_or_404(id)
    try:
        db.session.delete(spec)
        db.session.commit()
        return jsonify({"msg": "Eliminado correctamente"}), 200
    except Exception:
        db.session.rollback()
        return jsonify({"msg": "No se puede eliminar: Hay productos asociados"}), 400

# ==========================================
# 3. Obtener lista de productos
# ==========================================
@bp.route('', methods=['GET'])
@jwt_required()
def get_products():
    # 1. Parámetros
    page = request.args.get('page', 1, type=int)
    per_page = request.args.get('limit', 20, type=int)
    search = request.args.get('search', '', type=str)
    
    # Filtros
    cat_id = request.args.get('category_id')
    spec_id = request.args.get('specific_id')
    min_price = request.args.get('min_price', type=float)
    max_price = request.args.get('max_price', type=float)

    # 2. Query Base (Unimos tablas relacionadas siempre)
    query = Producto.query.outerjoin(Categoria).outerjoin(CategoriaEspecifica)

    # 3. Aplicar Filtros
    if search:
        search_term = f"%{search}%"
        # IMPORTANTE: Unimos con variantes explícitamente para buscar por SKU
        query = query.join(ProductoVariante)
        
        query = query.filter(
            or_(
                Producto.nombre.ilike(search_term),
                Categoria.nombre.ilike(search_term),
                ProductoVariante.codigo_sku.ilike(search_term)
            )
        )
        # IMPORTANTE: Agrupamos por ID de producto para evitar duplicados
        # Si un producto tiene 5 variantes que coinciden, solo devuelve 1 fila
        query = query.group_by(Producto.id_producto)
    
    if cat_id:
        query = query.filter(Producto.id_categoria == cat_id)
    
    if spec_id:
        query = query.filter(Producto.id_categoria_especifica == spec_id)
        
    if min_price is not None:
        query = query.filter(Producto.precio >= min_price)
        
    if max_price is not None and max_price > 0:
        query = query.filter(Producto.precio <= max_price)

    # 4. Paginación
    # Usamos count=False en paginate si group_by da problemas de conteo, 
    # pero generalmente con SQLAlchemy moderno funciona bien.
    paginated_data = query.order_by(Producto.id_producto.desc()).paginate(page=page, per_page=per_page, error_out=False)

    resultado = []
    for prod in paginated_data.items:
        stock_total = 0
        lista_variantes = []
        
        for var in prod.variantes:
            cantidad = var.inventario.stock_actual if var.inventario else 0
            stock_total += cantidad
            lista_variantes.append({
                "id_variante": var.id_variante,
                "talle": var.talla,
                "sku": var.codigo_sku,
                "stock": cantidad
            })
        
        resultado.append({
            "id": prod.id_producto,
            "nombre": prod.nombre,
            "precio": float(prod.precio),
            "stock_total": stock_total,
            "imagen": prod.imagen,
            "categoria_id": prod.id_categoria,
            "categoria_especifica_id": prod.id_categoria_especifica,
            "categoria": prod.categoria.nombre if prod.categoria else "-", 
            "liga": prod.categoria_especifica.nombre if prod.categoria_especifica else "-", 
            "variantes": lista_variantes
        })

    return jsonify({
        "products": resultado,
        "meta": {
            "total_items": paginated_data.total,
            "total_pages": paginated_data.pages,
            "current_page": paginated_data.page,

        }
    }), 200


# ==========================================
# 5. Crear producto
# ==========================================
@bp.route('', methods=['POST'])
@jwt_required()
def create_product():
    # NOTA: Al enviar archivos, ya no usamos request.get_json()
    # Usamos request.form para textos y request.files para archivos
    
    try:
        # 1. Validar datos obligatorios
        if not request.form.get('nombre') or not request.form.get('precio'):
             return jsonify({"msg": "Faltan datos obligatorios"}), 400

        # 2. Procesar la Imagen (Si viene)
        nombre_imagen = None
        if 'imagen' in request.files:
            file = request.files['imagen']
            if file.filename != '':
                # Limpiamos el nombre (ej: "foto boca.jpg" -> "foto_boca.jpg")
                filename = secure_filename(file.filename)
                # Guardamos en la carpeta static/uploads
                file.save(os.path.join(current_app.config['UPLOAD_FOLDER'], filename))
                nombre_imagen = filename

        # 3. Crear Producto Base
        nuevo_prod = Producto(
            nombre=request.form['nombre'], # Usamos request.form['key']
            descripcion=request.form.get('descripcion', ''),
            precio=request.form['precio'],
            id_categoria=request.form.get('categoria_id'),
            id_categoria_especifica=request.form.get('categoria_especifica_id'),
            imagen=nombre_imagen # <--- Guardamos el nombre del archivo
        )
        db.session.add(nuevo_prod)
        db.session.flush()

        # 4. Crear Variante Inicial
        talle = request.form.get('talle', 'U')
        sku = request.form.get('sku') or f"P{nuevo_prod.id_producto}-{talle}"

        nueva_variante = ProductoVariante(
            id_producto=nuevo_prod.id_producto,
            talla=talle,
            codigo_sku=sku,
            color=request.form.get('color', 'Standard')
        )
        db.session.add(nueva_variante)
        db.session.flush()

        # 5. Crear Inventario
        nuevo_inv = Inventario(
            id_variante=nueva_variante.id_variante,
            stock_actual=int(request.form.get('stock', 0)),
            stock_minimo=2
        )
        db.session.add(nuevo_inv)

        db.session.commit()
        return jsonify({"msg": "Producto creado con imagen"}), 201

    except Exception as e:
        db.session.rollback()
        print(f"ERROR SUBIDA: {e}")
        return jsonify({"msg": str(e)}), 500



# ==========================================
# 6. Borrar producto
# ==========================================
@bp.route('/<int:id>', methods=['DELETE'])
@jwt_required()
def delete_product(id):
    try:
        prod = Producto.query.get(id)
        if not prod:
            return jsonify({"msg": "No encontrado"}), 404
        
        # Al borrar producto, el 'cascade' de SQLAlchemy debería borrar variantes e inventario
        # Si no tienes cascade configurado en models, fallará. 
        # Intentamos borrarlo manual por seguridad:
        for var in prod.variantes:
            if var.inventario: db.session.delete(var.inventario)
            db.session.delete(var)
            
        db.session.delete(prod)
        db.session.commit()
        return jsonify({"msg": "Producto eliminado"}), 200
    except Exception as e:
        db.session.rollback()
        return jsonify({"msg": str(e)}), 500


# ==========================================
# 7. Generar código de barras
# ==========================================
@bp.route('/barcode/<string:sku>', methods=['GET'])
def generate_barcode(sku):
    try:
        EAN = barcode.get_barcode_class('code128')
        my_barcode = EAN(sku, writer=ImageWriter())
        fp = io.BytesIO()
        my_barcode.write(fp)
        fp.seek(0)
        return send_file(fp, mimetype='image/png')
    except Exception as e:
        return jsonify({"error": str(e)}), 500


# ==========================================
# 8. Editar producto (datos generales + imagen)
# ==========================================
@bp.route('/<int:id>', methods=['PUT'])
@jwt_required()
def update_product(id):
    prod = Producto.query.get(id)
    if not prod: return jsonify({"msg": "Producto no encontrado"}), 404
    
    try:
        # NOTA: Ahora usamos request.form y request.files porque el frontend enviará FormData
        
        # 1. Actualizar datos de texto si vienen
        if 'nombre' in request.form: prod.nombre = request.form['nombre']
        if 'precio' in request.form: prod.precio = request.form['precio']
        # Si el select envía cadena vacía "", lo convertimos a None para la DB
        if 'categoria_id' in request.form: 
            prod.id_categoria = request.form['categoria_id'] or None
        if 'categoria_especifica_id' in request.form:
            prod.id_categoria_especifica = request.form['categoria_especifica_id'] or None

        # 2. Procesar NUEVA Imagen si viene
        if 'imagen' in request.files:
            file = request.files['imagen']
            if file.filename != '':
                # a. Borrar imagen vieja si existía (Opcional, para ahorrar espacio)
                if prod.imagen:
                    ruta_vieja = os.path.join(current_app.config['UPLOAD_FOLDER'], prod.imagen)
                    if os.path.exists(ruta_vieja):
                        os.remove(ruta_vieja)
                
                # b. Guardar imagen nueva
                filename = secure_filename(file.filename)
                file.save(os.path.join(current_app.config['UPLOAD_FOLDER'], filename))
                
                # c. Actualizar base de datos
                prod.imagen = filename

        db.session.commit()
        return jsonify({"msg": "Producto actualizado correctamente"}), 200
    except Exception as e:
        db.session.rollback()
        print(f"Error update: {e}")
        return jsonify({"msg": str(e)}), 500


# ==========================================
# 9. Editar stock y SKU de una variante
# ==========================================
@bp.route('/variants/<int:id>', methods=['PUT'])
@jwt_required()
def update_variant(id):
    var = ProductoVariante.query.get(id)
    if not var: return jsonify({"msg": "Variante no encontrada"}), 404
    
    data = request.get_json()
    try:
        # Actualizar SKU si viene
        if 'sku' in data: var.codigo_sku = data['sku']
        
        # Actualizar STOCK (Tabla Inventario)
        if 'stock' in data:
            if not var.inventario:
                # Si por error no tenía inventario, lo creamos
                nuevo_inv = Inventario(id_variante=var.id_variante, stock_actual=int(data['stock']))
                db.session.add(nuevo_inv)
            else:
                var.inventario.stock_actual = int(data['stock'])
        
        db.session.commit()
        return jsonify({"msg": "Variante actualizada"}), 200
    except Exception as e:
        db.session.rollback()
        return jsonify({"msg": str(e)}), 500


# ==========================================
# 10. Agregar una nueva variante (talle)
# ==========================================
@bp.route('/variants', methods=['POST'])
@jwt_required()
def add_variant():
    data = request.get_json()
    try:
        prod_id = data.get('id_producto')
        talla = data.get('talla')
        
        # Verificar duplicados
        existe = ProductoVariante.query.filter_by(id_producto=prod_id, talla=talla).first()
        if existe: return jsonify({"msg": "Ese talle ya existe"}), 400

        # Crear Variante
        nueva_var = ProductoVariante(
            id_producto=prod_id,
            talla=talla,
            codigo_sku=data.get('sku') or f"P{prod_id}-{talla}",
            color='Standard'
        )
        db.session.add(nueva_var)
        db.session.flush()

        # Crear su Inventario
        nuevo_inv = Inventario(
            id_variante=nueva_var.id_variante,
            stock_actual=int(data.get('stock', 0))
        )
        db.session.add(nuevo_inv)
        
        db.session.commit()
        return jsonify({"msg": "Variante agregada"}), 201
    except Exception as e:
        db.session.rollback()
        return jsonify({"msg": str(e)}), 500

# ==========================================
# 11. Borrar variante
# ==========================================
@bp.route('/variants/<int:id>', methods=['DELETE'])
@jwt_required()
def delete_variant(id):
    try:
        var = ProductoVariante.query.get(id)
        if not var: return jsonify({"msg": "No encontrada"}), 404
        
        # Borrar inventario asociado primero
        if var.inventario: db.session.delete(var.inventario)
        db.session.delete(var)
        
        db.session.commit()
        return jsonify({"msg": "Variante eliminada"}), 200
    except Exception as e:
        db.session.rollback()
        return jsonify({"msg": str(e)}), 500

@bp.route('/bulk-update-price', methods=['POST'])
@jwt_required()
def bulk_update_price():
    data = request.get_json()
    
    # 1. Filtros: ¿Qué productos vamos a tocar?
    target_type = data.get('target_type') # 'all', 'category', 'specific_category'
    target_id = data.get('target_id')     # ID de la categoría seleccionada
    
    # 2. Acción: ¿Qué les vamos a hacer?
    action = data.get('action') # 'percent_inc' (%), 'fixed_inc' (+), 'set_value' (=)
    value = float(data.get('value', 0))

    if not action or value < 0:
        return jsonify({"msg": "Datos inválidos"}), 400

    try:
        # Construir la Query
        query = Producto.query
        
        if target_type == 'category':
            query = query.filter_by(id_categoria=target_id)
        elif target_type == 'specific_category':
            query = query.filter_by(id_categoria_especifica=target_id)
        # Si es 'all', no filtramos nada
        
        products = query.all()
        count = 0

        # Aplicar cambios
        for prod in products:
            current_price = float(prod.precio)
            
            if action == 'percent_inc':
                # Ejemplo: 10000 + 10% = 11000
                new_price = current_price * (1 + value / 100)
            elif action == 'fixed_inc':
                # Ejemplo: 10000 + 500 = 10500
                new_price = current_price + value
            elif action == 'set_value':
                # Ejemplo: = 20000
                new_price = value
            else:
                continue

            # Redondear (opcional, para evitar decimales feos)
            prod.precio = round(new_price, 2)
            count += 1

        db.session.commit()
        return jsonify({"msg": f"Precios actualizados en {count} productos"}), 200

    except Exception as e:
        db.session.rollback()
        return jsonify({"msg": str(e)}), 500


# ==========================================
# 12. Actualizar stock en masa
# ==========================================
@bp.route('/stock/bulk-update', methods=['POST'])
@jwt_required()
def bulk_stock_update():
    data = request.get_json()
    items = data.get('items', []) # Lista de { sku: '...', cantidad: 10 }
    
    if not items: return jsonify({"msg": "Lista vacía"}), 400

    try:
        updated_count = 0
        for item in items:
            # Buscamos por SKU
            variante = ProductoVariante.query.filter_by(codigo_sku=item['sku']).first()
            
            if variante and variante.inventario:
                # OPCIÓN A: Reemplazar stock (lo que contaste es la verdad absoluta)
                variante.inventario.stock_actual = int(item['cantidad'])
                
                # OPCIÓN B: Sumar al stock (si estás agregando mercadería nueva)
                # variante.inventario.stock_actual += int(item['cantidad'])
                
                updated_count += 1
        
        db.session.commit()
        return jsonify({"msg": f"Stock actualizado en {updated_count} productos"}), 200

    except Exception as e:
        db.session.rollback()
        return jsonify({"msg": str(e)}), 500


# ==========================================
# 13. Generar PDF de etiquetas en masa
# ==========================================
@bp.route('/labels/batch-pdf', methods=['POST'])
@jwt_required()
def generate_batch_labels_pdf():
    """
    Recibe una lista de { sku, nombre, talle, precio, cantidad }
    Genera un PDF con todas las etiquetas secuenciales.
    Configurado para impresora térmica (ej: 50mm x 25mm).
    """
    data = request.get_json()
    items = data.get('items', [])

    if not items:
        return jsonify({"msg": "Lista vacía"}), 400

    # Configuración de Etiqueta (Ajustar según tu rollo de etiquetas)
    # Ejemplo estándar: 50mm ancho x 25mm alto
    LABEL_WIDTH = 50 * mm
    LABEL_HEIGHT = 25 * mm
    
    # Buffer en memoria
    buffer = io.BytesIO()
    
    # Creamos el canvas con el tamaño exacto de la etiqueta
    c = canvas.Canvas(buffer, pagesize=(LABEL_WIDTH, LABEL_HEIGHT))

    for item in items:
        cantidad = int(item.get('cantidad', 1))
        
        # Repetimos la etiqueta según la cantidad solicitada
        for _ in range(cantidad):
            # 1. Nombre del Producto (Arriba, pequeño)
            c.setFont("Helvetica-Bold", 6)
            c.drawCentredString(LABEL_WIDTH / 2, LABEL_HEIGHT - 5*mm, f"{item['nombre'][:25]}") # Recortar nombre largo
            c.setFont("Helvetica", 6)
            c.drawCentredString(LABEL_WIDTH / 2, LABEL_HEIGHT - 7.5*mm, f"Talle: {item['talle']} - $ {float(item['precio']):,.0f}")

            # 2. Código de Barras (Centro)
            barcode = code128.Code128(item['sku'], barHeight=8*mm, barWidth=0.9) # Ajustar barWidth para densidad
            
            # Dibujamos el código
            barcode.drawOn(c, 2*mm, 3*mm) # Posición X, Y
            
            # 3. Texto del SKU (Abajo)
            c.setFont("Helvetica", 5)
            c.drawCentredString(LABEL_WIDTH / 2, 1*mm, item['sku'])

            c.showPage() # Termina esta etiqueta y pasa a la siguiente (corte de página)

    c.save()
    buffer.seek(0)
    
    return send_file(
        buffer, 
        mimetype='application/pdf', 
        as_attachment=True, 
        download_name='etiquetas_lote.pdf'
    )

