import { useState, useRef, useEffect } from 'react';
import axios from 'axios';
import { useAuth } from '../context/AuthContext';
import { ScanBarcode, Save, Trash2, RotateCcw, PackageCheck } from 'lucide-react';
import toast, { Toaster } from 'react-hot-toast';
import { api } from '../context/AuthContext';

const StockTakePage = () => {
    const { token } = useAuth();

    const [skuInput, setSkuInput] = useState('');
    const [scannedItems, setScannedItems] = useState([]); // Lista temporal del recuento
    const inputRef = useRef(null);

    // Mantener el foco siempre en el input
    useEffect(() => {
        const focusInterval = setInterval(() => {
            if (document.activeElement !== inputRef.current) {
                inputRef.current?.focus();
            }
        }, 2000); // Re-enfocar cada 2 segundos por si acaso
        return () => clearInterval(focusInterval);
    }, []);

    // 1. Manejar el escaneo
    const handleScan = (e) => {
        e.preventDefault();
        if (!skuInput.trim()) return;

        // Buscamos si ya lo escaneamos en esta sesión
        const existingIndex = scannedItems.findIndex(i => i.sku === skuInput.trim());

        if (existingIndex >= 0) {
            // Si ya está, sumamos 1
            const newList = [...scannedItems];
            newList[existingIndex].cantidad += 1;
            setScannedItems(newList);
            toast.success(`+1 (Total: ${newList[existingIndex].cantidad})`, { position: 'bottom-right', duration: 1000 });
        } else {
            // Si es nuevo en la lista, preguntamos al backend qué es (para mostrar el nombre)
            checkAndAddItem(skuInput.trim());
        }
        setSkuInput('');
    };

    // 2. Verificar producto y agregar
    const checkAndAddItem = async (sku) => {
        try {
            const res = await api.get(`/products?search=${sku}`, {
                headers: { Authorization: `Bearer ${token}` }
            });

            // La búsqueda devuelve paginación, buscamos coincidencia exacta de SKU en los resultados
            // Nota: Esto asume que tu endpoint de búsqueda puede encontrar por SKU o Nombre.
            // Si tu endpoint de búsqueda actual solo busca por nombre, 
            // quizás necesites usar el endpoint /sales/scan/{sku} que ya busca exacto.

            const resScan = await api.get(`/sales/scan/${sku}`, {
                headers: { Authorization: `Bearer ${token}` }
            });

            if (resScan.data.found) {
                const prod = resScan.data.product;
                setScannedItems(prev => [
                    {
                        sku: prod.sku,
                        nombre: prod.nombre,
                        talle: prod.talle,
                        cantidad: 1, // Empieza en 1
                        stock_sistema: prod.stock_actual // Para comparar visualmente
                    },
                    ...prev // Agregamos al principio
                ]);
                toast.success("Producto agregado");
            } else {
                toast.error("Producto no encontrado. ¿Está cargado?");
            }
        } catch (error) {
            toast.error("Error al buscar SKU");
        }
    };

    // 3. Modificar cantidad manual
    const updateQuantity = (sku, newQty) => {
        setScannedItems(prev => prev.map(item => item.sku === sku ? { ...item, cantidad: parseInt(newQty) || 0 } : item));
    };

    // 4. Guardar todo en la Base de Datos
    const handleSaveStock = async () => {
        if (scannedItems.length === 0) return;
        if (!window.confirm("¿Confirmar actualización de stock? Esto reemplazará el stock actual de estos productos.")) return;

        try {
            await api.post('/products/stock/bulk-update', {
                items: scannedItems
            }, { headers: { Authorization: `Bearer ${token}` } });

            toast.success("¡Inventario Actualizado!");
            setScannedItems([]); // Limpiar lista
        } catch (error) {
            toast.error("Error al guardar");
        }
    };

    return (
        <div className="p-6 max-w-5xl mx-auto">
            <Toaster />

            <div className="flex justify-between items-center mb-6">
                <div>
                    <h1 className="text-2xl font-bold text-gray-800 flex items-center">
                        <PackageCheck className="mr-2 text-blue-600" /> Toma de Inventario
                    </h1>
                    <p className="text-gray-500 text-sm">Escanea los productos para actualizar el stock real.</p>
                </div>
                <button onClick={() => setScannedItems([])} className="text-red-500 hover:bg-red-50 px-3 py-2 rounded flex items-center text-sm">
                    <RotateCcw size={16} className="mr-2" /> Reiniciar Lista
                </button>
            </div>

            {/* INPUT GIGANTE */}
            <div className="bg-white p-6 rounded-xl shadow-sm border border-blue-200 mb-6">
                <form onSubmit={handleScan} className="flex gap-4">
                    <div className="relative flex-1">
                        <ScanBarcode className="absolute left-4 top-4 text-gray-400" />
                        <input
                            ref={inputRef}
                            value={skuInput}
                            onChange={e => setSkuInput(e.target.value)}
                            placeholder="Escanea aquí..."
                            className="w-full pl-12 p-3 text-xl border-2 border-blue-500 rounded-lg outline-none focus:ring-4 focus:ring-blue-100 uppercase font-mono"
                            autoFocus
                        />
                    </div>
                    <button type="submit" className="bg-blue-600 text-white px-8 rounded-lg font-bold text-lg hover:bg-blue-700">
                        ENTER
                    </button>
                </form>
            </div>

            {/* LISTA DE RECUENTO */}
            <div className="bg-white rounded-xl shadow-lg border overflow-hidden">
                <div className="p-4 bg-gray-50 border-b flex justify-between items-center">
                    <span className="font-bold text-gray-700">Ítems Escaneados: {scannedItems.length}</span>
                    <span className="text-sm text-gray-500">Total Unidades: {scannedItems.reduce((acc, i) => acc + i.cantidad, 0)}</span>
                </div>

                <div className="max-h-[500px] overflow-y-auto">
                    <table className="w-full text-left">
                        <thead className="bg-gray-100 text-xs uppercase text-gray-500 sticky top-0">
                            <tr>
                                <th className="p-3">Producto</th>
                                <th className="p-3">SKU</th>
                                <th className="p-3 text-center">Stock Sist.</th>
                                <th className="p-3 text-center w-32">Conteo Real</th>
                                <th className="p-3"></th>
                            </tr>
                        </thead>
                        <tbody className="divide-y">
                            {scannedItems.map((item) => (
                                <tr key={item.sku} className="hover:bg-blue-50">
                                    <td className="p-3">
                                        <p className="font-bold text-gray-800">{item.nombre}</p>
                                        <p className="text-xs text-gray-500">Talle: {item.talle}</p>
                                    </td>
                                    <td className="p-3 font-mono text-xs">{item.sku}</td>
                                    <td className="p-3 text-center text-gray-400">{item.stock_sistema}</td>
                                    <td className="p-3 text-center">
                                        <input
                                            type="number"
                                            value={item.cantidad}
                                            onChange={(e) => updateQuantity(item.sku, e.target.value)}
                                            className="w-20 p-2 border-2 border-blue-200 rounded text-center font-bold text-lg focus:border-blue-500 outline-none"
                                        />
                                    </td>
                                    <td className="p-3 text-right">
                                        <button onClick={() => setScannedItems(prev => prev.filter(i => i.sku !== item.sku))} className="text-red-400 hover:text-red-600">
                                            <Trash2 size={18} />
                                        </button>
                                    </td>
                                </tr>
                            ))}
                            {scannedItems.length === 0 && (
                                <tr><td colSpan="5" className="p-10 text-center text-gray-400">Escanea productos para comenzar el recuento...</td></tr>
                            )}
                        </tbody>
                    </table>
                </div>

                <div className="p-4 border-t bg-gray-50 flex justify-end">
                    <button
                        onClick={handleSaveStock}
                        disabled={scannedItems.length === 0}
                        className="bg-green-600 text-white px-8 py-3 rounded-lg font-bold text-lg hover:bg-green-700 disabled:bg-gray-300 disabled:cursor-not-allowed flex items-center shadow-lg"
                    >
                        <Save size={20} className="mr-2" /> ACTUALIZAR STOCK
                    </button>
                </div>
            </div>
        </div>
    );
};

export default StockTakePage;