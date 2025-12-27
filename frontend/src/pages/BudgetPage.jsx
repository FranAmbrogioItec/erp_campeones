import { useState, useRef, useEffect } from 'react';
import { useAuth, api } from '../context/AuthContext'; // Ajusta según tu importación de api
import { useReactToPrint } from 'react-to-print';
import BudgetPrint from '../components/BudgetPrint'; // El componente que creamos arriba
import toast, { Toaster } from 'react-hot-toast';
import {
    ShoppingCart, Trash2, Plus, Minus, Search, Shirt,
    Calculator, User, FileText, Printer, Save
} from 'lucide-react';

const BudgetPage = () => {
    const { token } = useAuth();

    // --- Estados ---
    const [cart, setCart] = useState([]);
    const [manualTerm, setManualTerm] = useState('');
    const [manualResults, setManualResults] = useState([]);

    // Datos del Presupuesto
    const [clientName, setClientName] = useState('');
    const [discountPercent, setDiscountPercent] = useState(0);

    // Impresión
    const [budgetData, setBudgetData] = useState(null);
    const printRef = useRef();
    const handlePrint = useReactToPrint({ contentRef: printRef });

    // Cálculos en tiempo real
    const subtotal = cart.reduce((sum, item) => sum + item.subtotal, 0);
    const discountAmount = subtotal * (discountPercent / 100);
    const total = subtotal - discountAmount;

    // --- Búsqueda de Productos (Igual que POS) ---
    useEffect(() => {
        const delaySearch = setTimeout(async () => {
            if (!manualTerm.trim()) {
                setManualResults([]);
                return;
            }
            try {
                const res = await api.get('/products', { params: { search: manualTerm, limit: 5 } });
                setManualResults(res.data.products || []);
            } catch (error) { console.error(error); }
        }, 400);
        return () => clearTimeout(delaySearch);
    }, [manualTerm]);

    const addToCart = (product, variant) => {
        setCart(prev => {
            const existing = prev.find(i => i.id_variante === variant.id_variante);
            if (existing) {
                return prev.map(i => i.id_variante === variant.id_variante
                    ? { ...i, cantidad: i.cantidad + 1, subtotal: (i.cantidad + 1) * i.precio }
                    : i);
            }
            return [...prev, {
                id_variante: variant.id_variante,
                sku: variant.sku,
                nombre: product.nombre,
                talle: variant.talle,
                precio: product.precio,
                cantidad: 1,
                subtotal: product.precio
            }];
        });
        setManualTerm('');
        setManualResults([]);
        toast.success("Agregado");
    };

    const updateQuantity = (id, delta) => {
        setCart(prev => prev.map(item => {
            if (item.id_variante === id) {
                const newQty = Math.max(1, item.cantidad + delta);
                return { ...item, cantidad: newQty, subtotal: newQty * item.precio };
            }
            return item;
        }));
    };

    const removeFromCart = (id) => setCart(prev => prev.filter(i => i.id_variante !== id));

    // --- Guardar Presupuesto ---
    const handleSaveBudget = async () => {
        if (cart.length === 0) return toast.error("El carrito está vacío");
        if (!clientName.trim()) return toast.error("Ingresa el nombre del cliente");

        const loadingId = toast.loading("Generando presupuesto...");
        try {
            const payload = {
                cliente: clientName,
                descuento: discountPercent,
                items: cart
            };

            const res = await api.post('/sales/presupuestos', payload);

            // Preparar datos para imprimir
            setBudgetData({
                id: res.data.id,
                cliente: clientName,
                items: cart,
                subtotal: subtotal,
                descuento: discountPercent,
                monto_descuento: discountAmount,
                total: res.data.total
            });

            // Disparar impresión tras un breve delay
            setTimeout(() => {
                handlePrint();
                toast.success("Presupuesto Generado", { id: loadingId });
                // Limpiar form
                setCart([]);
                setClientName('');
                setDiscountPercent(0);
            }, 500);

        } catch (error) {
            toast.error("Error al guardar", { id: loadingId });
        }
    };

    return (
        <div className="flex flex-col md:flex-row h-[calc(100vh-4rem)] gap-4 p-4 max-w-7xl mx-auto">
            <Toaster position="top-center" />

            {/* Componente Oculto para Impresión */}
            <div style={{ display: 'none' }}>
                <BudgetPrint ref={printRef} data={budgetData} />
            </div>

            {/* IZQUIERDA: Buscador */}
            <div className="w-full md:w-2/3 flex flex-col gap-4">
                <div className="bg-white p-6 rounded-xl shadow-sm border border-blue-100 relative z-50">
                    <h2 className="text-xl font-bold text-gray-800 mb-4 flex items-center">
                        <FileText className="mr-2 text-blue-600" /> Armador de Presupuestos
                    </h2>

                    <div className="relative">
                        <div className="flex items-center border-2 border-blue-200 rounded-lg overflow-hidden focus-within:ring-4 focus-within:ring-blue-100 transition-all">
                            <Search className="ml-3 text-gray-400" />
                            <input
                                autoFocus
                                value={manualTerm}
                                onChange={e => setManualTerm(e.target.value)}
                                placeholder="Buscar producto..."
                                className="w-full p-3 outline-none"
                            />
                        </div>

                        {/* Resultados Flotantes */}
                        {manualResults.length > 0 && (
                            <div className="absolute top-full left-0 right-0 bg-white border shadow-xl rounded-b-lg mt-1 max-h-96 overflow-y-auto">
                                {manualResults.map(p => (
                                    <div key={p.id} className="p-3 border-b hover:bg-gray-50 flex gap-3 animate-fade-in">
                                        <div className="w-12 h-12 bg-gray-100 rounded shrink-0 flex items-center justify-center">
                                            {p.imagen ? <img src={`${api.defaults.baseURL}/static/uploads/${p.imagen}`} className="w-full h-full object-cover rounded" /> : <Shirt size={20} className="text-gray-300" />}
                                        </div>
                                        <div className="flex-1">
                                            <div className="flex justify-between font-bold text-sm"><span>{p.nombre}</span><span>${p.precio}</span></div>
                                            <div className="flex flex-wrap gap-2 mt-1">
                                                {p.variantes.map(v => (
                                                    <button key={v.id_variante} onClick={() => addToCart(p, v)} className="text-xs px-2 py-1 rounded border hover:bg-blue-600 hover:text-white border-blue-200 text-blue-700">
                                                        {v.talle}
                                                    </button>
                                                ))}
                                            </div>
                                        </div>
                                    </div>
                                ))}
                            </div>
                        )}
                    </div>
                </div>

                {/* Lista de Items */}
                <div className="flex-1 bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden flex flex-col">
                    <div className="p-4 bg-gray-50 border-b font-bold text-gray-500 uppercase text-xs flex justify-between">
                        <span>Items Seleccionados</span>
                        <span>{cart.length} productos</span>
                    </div>
                    <div className="flex-1 overflow-y-auto p-4 space-y-2">
                        {cart.length === 0 ? (
                            <div className="h-full flex flex-col items-center justify-center text-gray-300">
                                <ShoppingCart size={48} className="mb-2 opacity-20" />
                                <p>Agrega productos para armar el pedido</p>
                            </div>
                        ) : (
                            cart.map(item => (
                                <div key={item.id_variante} className="flex justify-between items-center bg-white border p-3 rounded-lg shadow-sm">
                                    <div>
                                        <p className="font-bold text-gray-800">{item.nombre}</p>
                                        <p className="text-xs text-gray-500">Talle: {item.talle} | Unit: ${item.precio}</p>
                                    </div>
                                    <div className="flex items-center gap-4">
                                        <div className="flex items-center bg-gray-100 rounded-lg">
                                            <button onClick={() => updateQuantity(item.id_variante, -1)} className="p-1 hover:bg-gray-200 rounded-l"><Minus size={14} /></button>
                                            <span className="w-8 text-center font-bold text-sm">{item.cantidad}</span>
                                            <button onClick={() => updateQuantity(item.id_variante, 1)} className="p-1 hover:bg-gray-200 rounded-r"><Plus size={14} /></button>
                                        </div>
                                        <span className="font-bold w-20 text-right">${item.subtotal.toLocaleString()}</span>
                                        <button onClick={() => removeFromCart(item.id_variante)} className="text-red-400 hover:text-red-600"><Trash2 size={18} /></button>
                                    </div>
                                </div>
                            ))
                        )}
                    </div>
                </div>
            </div>

            {/* DERECHA: Configuración Presupuesto */}
            <div className="w-full md:w-1/3 bg-white rounded-xl shadow-lg border border-gray-200 flex flex-col overflow-hidden">
                <div className="bg-slate-800 text-white p-4">
                    <h3 className="font-bold text-lg flex items-center"><Calculator className="mr-2" /> Configuración</h3>
                </div>

                <div className="p-6 space-y-6 flex-1 overflow-y-auto">
                    {/* Cliente */}
                    <div>
                        <label className="block text-xs font-bold text-gray-500 uppercase mb-1">Cliente / Empresa</label>
                        <div className="relative">
                            <User className="absolute left-3 top-3 text-gray-400" size={18} />
                            <input
                                value={clientName}
                                onChange={e => setClientName(e.target.value)}
                                placeholder="Nombre del cliente..."
                                className="w-full pl-10 p-2.5 border rounded-lg focus:ring-2 focus:ring-blue-500 outline-none"
                            />
                        </div>
                    </div>

                    {/* Descuento */}
                    <div>
                        <label className="block text-xs font-bold text-gray-500 uppercase mb-1 flex justify-between">
                            <span>Descuento Global</span>
                            <span className="text-blue-600">{discountPercent}%</span>
                        </label>
                        <input
                            type="range" min="0" max="50" step="5"
                            value={discountPercent}
                            onChange={e => setDiscountPercent(parseInt(e.target.value))}
                            className="w-full accent-blue-600 h-2 bg-gray-200 rounded-lg appearance-none cursor-pointer"
                        />
                        <div className="flex justify-between text-xs text-gray-400 mt-1 px-1">
                            <span>0%</span><span>25%</span><span>50%</span>
                        </div>
                    </div>

                    <hr className="border-dashed" />

                    {/* Totales */}
                    <div className="space-y-2">
                        <div className="flex justify-between text-gray-600">
                            <span>Subtotal</span>
                            <span>$ {subtotal.toLocaleString()}</span>
                        </div>
                        {discountPercent > 0 && (
                            <div className="flex justify-between text-green-600 font-medium">
                                <span>Descuento ({discountPercent}%)</span>
                                <span>- $ {discountAmount.toLocaleString()}</span>
                            </div>
                        )}
                        <div className="flex justify-between text-3xl font-black text-gray-800 pt-2 border-t">
                            <span>Total</span>
                            <span>$ {total.toLocaleString()}</span>
                        </div>
                    </div>
                </div>

                <div className="p-4 bg-gray-50 border-t">
                    <button
                        onClick={handleSaveBudget}
                        disabled={cart.length === 0 || !clientName}
                        className="w-full bg-slate-800 text-white py-4 rounded-xl font-bold text-lg shadow-lg hover:bg-slate-900 transition-all flex items-center justify-center disabled:opacity-50 disabled:cursor-not-allowed"
                    >
                        <Printer className="mr-2" /> Generar PDF
                    </button>
                </div>
            </div>
        </div>
    );
};

export default BudgetPage;