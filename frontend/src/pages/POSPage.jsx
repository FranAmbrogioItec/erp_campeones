import { useState, useRef, useEffect } from 'react';
import { useAuth } from '../context/AuthContext';
import { Link } from 'react-router-dom';
import { useReactToPrint } from 'react-to-print';
import Ticket from '../components/Ticket';
import toast, { Toaster } from 'react-hot-toast';
import ConfirmModal from '../components/ConfirmModal';
import {
  ShoppingCart, Trash2, Plus, Minus, ScanBarcode, Banknote,
  CreditCard, Smartphone, Lock, ArrowRight, Edit, Printer, Clock, Receipt, Search, Shirt
} from 'lucide-react';
import { api } from '../context/AuthContext';

const POSPage = () => {
  const { token } = useAuth();

  // Estados POS
  const [isRegisterOpen, setIsRegisterOpen] = useState(null);
  const [skuInput, setSkuInput] = useState('');
  const [cart, setCart] = useState([]);
  const [isLoading, setIsLoading] = useState(false);

  // --- NUEVO: ESTADOS DE BÚSQUEDA MANUAL ---
  const [isSearchMode, setIsSearchMode] = useState(false); // Toggle Escáner/Buscador
  const [manualTerm, setManualTerm] = useState('');
  const [manualResults, setManualResults] = useState([]);
  const searchInputRef = useRef(null);

  // Estados Pagos y Precios
  const [paymentMethods, setPaymentMethods] = useState([]);
  const [selectedMethod, setSelectedMethod] = useState(null);
  const [customTotal, setCustomTotal] = useState(null);
  const [isEditingPrice, setIsEditingPrice] = useState(false);

  // Estados Historial Rápido
  const [recentSales, setRecentSales] = useState([]);

  // Modal
  const [isConfirmModalOpen, setIsConfirmModalOpen] = useState(false);

  // Impresión (Mantenemos TU lógica exacta)
  const [ticketData, setTicketData] = useState(null);
  const ticketRef = useRef(null);
  const reactToPrintFn = useReactToPrint({
    contentRef: ticketRef,
  });

  const inputRef = useRef(null);

  // Cálculos
  const subtotalCalculado = cart.reduce((sum, item) => sum + item.subtotal, 0);
  const totalFinal = customTotal !== null && customTotal !== '' ? parseFloat(customTotal) : subtotalCalculado;
  const descuentoVisual = subtotalCalculado - totalFinal;

  // --- CARGA DE DATOS ---
  const fetchRecentSales = async () => {
    try {
      const res = await api.get('/sales/history', {
        params: { current_session: true }
      });
      setRecentSales(res.data.history);
    } catch (error) {
      console.error("Error cargando historial reciente", error);
    }
  };

  useEffect(() => {
    const init = async () => {
      if (!token) return;
      try {
        const [resStatus, resMethods] = await Promise.all([
          api.get('/sales/caja/status'),
          api.get('/sales/payment-methods')
        ]);

        const isOpen = resStatus.data.estado === 'abierta';
        setIsRegisterOpen(isOpen);
        setPaymentMethods(resMethods.data);

        if (isOpen) {
          fetchRecentSales();
        }

      } catch (error) {
        console.error(error);
        toast.error("Error de conexión");
      }
    };
    init();
  }, [token]);

  // Foco inteligente (Incluye el buscador nuevo)
  useEffect(() => {
    if (isRegisterOpen && !isEditingPrice && !isConfirmModalOpen) {
      if (isSearchMode) {
        searchInputRef.current?.focus();
      } else {
        inputRef.current?.focus();
      }
    }
  }, [cart, isRegisterOpen, isEditingPrice, isConfirmModalOpen, isSearchMode]);

  // --- NUEVO: LÓGICA DE BÚSQUEDA MANUAL ---
  useEffect(() => {
    const delaySearch = setTimeout(async () => {
      if (!manualTerm.trim() || !isSearchMode) {
        setManualResults([]);
        return;
      }
      try {
        // Usamos limit=5 para que sea rápido y no llene la pantalla
        const res = await api.get('/products', {
          params: { search: manualTerm, limit: 5 }
        });
        setManualResults(res.data.products || []);
      } catch (error) { console.error(error); }
    }, 400); // Debounce

    return () => clearTimeout(delaySearch);
  }, [manualTerm, isSearchMode, token]);

  const handleManualAdd = (product, variant) => {
    // Convertimos al formato que espera el carrito
    const itemFormatted = {
      id_variante: variant.id_variante,
      sku: variant.sku,
      nombre: product.nombre,
      talle: variant.talle,
      precio: product.precio,
      stock_actual: variant.stock
    };

    addToCart(itemFormatted);
    toast.success(`${product.nombre} (${variant.talle}) agregado`);
    setManualTerm('');
    setManualResults([]);
  };

  // --- Lógica Carrito (Escáner) ---
  const handleScan = async (e) => {
    e.preventDefault();
    if (!skuInput.trim()) return;
    setIsLoading(true);
    try {
      const res = await api.get(`/sales/scan/${skuInput}`);
      const data = res.data;

      if (data.found) {
        addToCart(data.product);
        toast.success(`${data.product.nombre} agregado`, { position: 'bottom-left', duration: 2000 });
        setSkuInput('');
      }
    } catch (error) {
      toast.error("Producto no encontrado", { position: 'bottom-left' });
      setSkuInput('');
    } finally {
      setIsLoading(false);
    }
  };

  const addToCart = (product) => {
    setCustomTotal(null);
    setCart((prevCart) => {
      const existingItem = prevCart.find(item => item.id_variante === product.id_variante);
      if (existingItem) {
        if (existingItem.cantidad + 1 > product.stock_actual) {
          toast.error(`Stock insuficiente (${product.stock_actual} disp)`, { id: 'stock-error' });
          return prevCart;
        }
        return prevCart.map(item =>
          item.id_variante === product.id_variante
            ? { ...item, cantidad: item.cantidad + 1, subtotal: (item.cantidad + 1) * item.precio }
            : item
        );
      } else {
        if (product.stock_actual < 1) {
          toast.error("Producto sin stock disponible");
          return prevCart;
        }
        return [...prevCart, { ...product, cantidad: 1, subtotal: product.precio }];
      }
    });
  };

  const updateQuantity = (id_variante, delta) => {
    setCustomTotal(null);
    setCart(prevCart => prevCart.map(item => {
      if (item.id_variante === id_variante) {
        const newQty = item.cantidad + delta;
        if (newQty < 1) return item;
        if (newQty > item.stock_actual) {
          toast.error(`Máximo alcanzado (${item.stock_actual} u.)`, { id: 'max-stock' });
          return item;
        }
        return { ...item, cantidad: newQty, subtotal: newQty * item.precio };
      }
      return item;
    }));
  };

  const removeFromCart = (id) => {
    setCustomTotal(null);
    setCart(prev => prev.filter(i => i.id_variante !== id));
  };

  // --- IMPRESIÓN (TU LÓGICA) ---
  const prepareAndPrint = (venta) => {
    const dataForTicket = {
      id_venta: venta.id,
      fecha: venta.fecha,
      items: venta.items_detail || [],
      total: venta.total,
      cliente: "Consumidor Final"
    };
    setTicketData(dataForTicket);
    setTimeout(() => {
      if (reactToPrintFn) reactToPrintFn();
    }, 150);
  };

  // --- Flujo de Venta ---
  const handleCheckoutClick = () => {
    if (cart.length === 0) return;
    if (!selectedMethod) {
      toast.error("⚠️ Selecciona un medio de pago");
      return;
    }
    setIsConfirmModalOpen(true);
  };

  const processSale = async () => {
    const toastId = toast.loading("Procesando venta...");
    setIsConfirmModalOpen(false);

    try {
      const payload = {
        items: cart,
        subtotal_calculado: subtotalCalculado,
        total_final: totalFinal,
        metodo_pago_id: selectedMethod.id
      };

      const res = await api.post('/sales/checkout', payload);
      const data = res.data;

      toast.success(`¡Venta #${data.id} Exitosa!`, { id: toastId });

      // Limpieza
      setCart([]);
      setSkuInput('');
      setManualTerm(''); // Limpiar también búsqueda manual
      setSelectedMethod(null);
      setCustomTotal(null);

      // Actualizar historial
      fetchRecentSales();

    } catch (error) {
      console.error('Error procesando venta:', error);
      toast.error("Error al procesar venta", { id: toastId });
    }
  };

  const getPaymentIcon = (n) => {
    if (n.toLowerCase().includes('tarjeta')) return <CreditCard size={20} />;
    if (n.toLowerCase().includes('transferencia')) return <Smartphone size={20} />;
    return <Banknote size={20} />;
  };

  if (isRegisterOpen === null) {
    return <div className="p-10 text-center text-gray-500">Verificando caja...</div>;
  }

  if (isRegisterOpen === false) {
    return (
      <div className="h-[80vh] flex flex-col items-center justify-center p-6 text-center animate-fade-in-down">
        <div className="bg-red-100 p-6 rounded-full text-red-500 mb-6">
          <Lock size={64} />
        </div>
        <h1 className="text-3xl font-bold text-gray-800 mb-2">Caja Cerrada</h1>
        <Link
          to="/caja-control"
          className="bg-blue-600 text-white px-8 py-3 rounded-xl font-bold hover:bg-blue-700 flex items-center mt-4"
        >
          <ArrowRight className="mr-2" /> Abrir Caja
        </Link>
      </div>
    );
  }

  return (
    <div className="flex flex-col md:flex-row h-[calc(100vh-4rem)] gap-4 p-2">
      <Toaster position="top-center" reverseOrder={false} />

      {/* Ticket oculto para impresión - TU LÓGICA */}
      <div style={{ position: 'absolute', left: '-9999px', top: '0' }}>
        <div ref={ticketRef}>
          <Ticket saleData={ticketData} />
        </div>
      </div>

      {/* Modal de Confirmación */}
      <ConfirmModal
        isOpen={isConfirmModalOpen}
        onClose={() => setIsConfirmModalOpen(false)}
        onConfirm={processSale}
        title="Confirmar Venta"
        message={`¿Estás seguro de cobrar $${totalFinal.toLocaleString()} con ${selectedMethod?.nombre}?`}
        confirmText="Sí, Cobrar"
        cancelText="Volver"
      />

      {/* COLUMNA IZQUIERDA */}
      <div className="w-full md:w-2/3 flex flex-col gap-4">

        {/* --- PANEL DE ENTRADA (ESCÁNER / BÚSQUEDA) --- */}
        <div className="bg-white p-6 rounded-xl shadow-sm border border-blue-100 relative z-50">
          <div className="flex justify-between items-center mb-3">
            <h2 className="text-lg font-bold text-gray-700 flex items-center">
              {isSearchMode ? <Search className="mr-2 text-purple-600" /> : <ScanBarcode className="mr-2 text-blue-600" />}
              {isSearchMode ? "Buscador con Fotos" : "Escanear Código"}
            </h2>

            {/* Botón Toggle */}
            <button
              onClick={() => { setIsSearchMode(!isSearchMode); setManualTerm(''); setManualResults([]); }}
              className={`text-xs px-3 py-1.5 rounded-lg border font-bold flex items-center transition-all ${isSearchMode ? 'bg-blue-50 text-blue-600 border-blue-200' : 'bg-purple-50 text-purple-600 border-purple-200'
                }`}
            >
              {isSearchMode ? <><ScanBarcode size={14} className="mr-2" /> Usar Escáner</> : <><Search size={14} className="mr-2" /> Buscar por Nombre</>}
            </button>
          </div>

          {isSearchMode ? (
            // --- MODO BÚSQUEDA MANUAL ---
            <div className="relative">
              <input
                ref={searchInputRef}
                value={manualTerm}
                onChange={(e) => setManualTerm(e.target.value)}
                placeholder="Escribe: 'Boca', 'Short', 'Camiseta'..."
                className="w-full p-4 border-2 border-purple-300 rounded-lg focus:outline-none focus:ring-4 focus:ring-purple-100"
                autoFocus
              />

              {/* RESULTADOS FLOTANTES CON IMAGEN */}
              {manualResults.length > 0 && (
                <div className="absolute top-full left-0 right-0 bg-white border border-gray-200 shadow-xl rounded-b-lg mt-1 max-h-[400px] overflow-y-auto">
                  {manualResults.map(prod => (
                    <div key={prod.id} className="p-3 border-b last:border-0 hover:bg-gray-50 flex gap-3 animate-fade-in">

                      {/* IMAGEN DEL PRODUCTO */}
                      <div className="w-16 h-16 bg-gray-100 rounded-lg overflow-hidden shrink-0 border border-gray-200 flex items-center justify-center">
                        {prod.imagen ? (
                          <img
                            src={`${api.defaults.baseURL}/static/uploads/${prod.imagen}`}
                            alt={prod.nombre}
                            className="w-full h-full object-cover"
                          />
                        ) : (
                          <Shirt className="text-gray-300" size={24} />
                        )}
                      </div>

                      {/* INFO Y VARIANTES */}
                      <div className="flex-1">
                        <div className="flex justify-between items-start mb-2">
                          <span className="font-bold text-gray-800 text-sm">{prod.nombre}</span>
                          <span className="font-mono font-bold text-gray-600 text-sm whitespace-nowrap ml-2">$ {prod.precio.toLocaleString()}</span>
                        </div>

                        <div className="flex flex-wrap gap-2">
                          {prod.variantes.map(v => (
                            <button
                              key={v.id_variante}
                              onClick={() => handleManualAdd(prod, v)}
                              disabled={v.stock === 0}
                              className={`text-xs px-2 py-1.5 rounded border flex items-center shadow-sm transition-all active:scale-95 ${v.stock > 0
                                ? 'bg-white border-purple-200 text-purple-700 hover:bg-purple-600 hover:text-white'
                                : 'bg-gray-100 text-gray-400 cursor-not-allowed border-transparent'
                                }`}
                            >
                              <span className="font-bold mr-1">{v.talle}</span>
                              <span className={`text-[10px] ${v.stock > 0 ? 'opacity-70' : ''}`}>({v.stock})</span>
                            </button>
                          ))}
                          {prod.variantes.length === 0 && <span className="text-xs text-red-400 italic">Sin stock cargado</span>}
                        </div>
                      </div>
                    </div>
                  ))}
                </div>
              )}
            </div>
          ) : (
            // --- MODO ESCÁNER (CLÁSICO) ---
            <form onSubmit={handleScan} className="relative">
              <input
                ref={inputRef}
                value={skuInput}
                onChange={(e) => setSkuInput(e.target.value)}
                placeholder="Escanea el código de barras aquí..."
                className="w-full text-2xl p-4 border-2 border-blue-500 rounded-lg focus:outline-none focus:ring-4 focus:ring-blue-200 uppercase"
                autoFocus
                disabled={isEditingPrice || isConfirmModalOpen}
              />
              <button
                type="submit"
                className="absolute right-2 top-2 bottom-2 bg-blue-600 text-white px-6 rounded-md hover:bg-blue-700 font-bold"
              >
                ENTER
              </button>
            </form>
          )}
        </div>

        {/* LISTA DE VENTAS DE LA SESIÓN */}
        <div className="flex-1 bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden flex flex-col relative z-0">
          <div className="p-3 bg-gray-50 border-b border-gray-200 flex justify-between items-center">
            <h3 className="text-sm font-bold text-gray-700 flex items-center">
              <Clock size={16} className="mr-2 text-blue-500" /> Ventas de esta Caja
            </h3>
            <span className="text-xs bg-blue-100 text-blue-700 px-2 py-0.5 rounded-full font-bold">
              {recentSales.length} op.
            </span>
          </div>

          <div className="flex-1 overflow-y-auto p-0">
            {recentSales.length === 0 ? (
              <div className="h-full flex flex-col items-center justify-center text-gray-400">
                <Receipt size={32} className="mb-2 opacity-20" />
                <p className="text-sm">Aún no hay ventas en este turno.</p>
              </div>
            ) : (
              <table className="w-full text-xs text-left">
                <thead className="bg-white sticky top-0 text-gray-500 font-medium border-b">
                  <tr>
                    <th className="p-3">Hora</th>
                    <th className="p-3">Detalle</th>
                    <th className="p-3">Total</th>
                    <th className="p-3 text-right"></th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-gray-100">
                  {recentSales.map((v) => (
                    <tr key={v.id} className="hover:bg-blue-50 transition-colors group">
                      <td className="p-3 text-gray-500 font-mono">
                        {v.fecha.split(' ')[1]}
                      </td>
                      <td className="p-3 truncate max-w-[200px] text-gray-700" title={v.items}>
                        {v.items}
                      </td>
                      <td className="p-3 font-bold text-gray-900">
                        $ {v.total.toLocaleString()}
                      </td>
                      <td className="p-3 text-right">
                        <button
                          onClick={() => prepareAndPrint(v)}
                          className="text-gray-300 hover:text-blue-600 p-1.5 rounded hover:bg-blue-100 transition-all"
                          title="Reimprimir"
                        >
                          <Printer size={14} />
                        </button>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            )}
          </div>
        </div>
      </div>

      {/* COLUMNA DERECHA: TICKET ACTUAL */}
      <div className="w-full md:w-1/3 bg-white flex flex-col rounded-xl shadow-lg border border-gray-200 overflow-hidden">
        <div className="p-4 bg-slate-800 text-white flex justify-between items-center shadow-md z-10">
          <h3 className="font-bold text-lg flex items-center">
            <ShoppingCart className="mr-2" /> Ticket Actual
          </h3>
          <span className="bg-slate-700 px-2 py-1 rounded text-xs font-bold">
            {cart.length}
          </span>
        </div>

        <div className="flex-1 overflow-y-auto p-3 space-y-2 bg-slate-50">
          {cart.length === 0 ? (
            <div className="text-center text-gray-400 mt-10">Carrito vacío</div>
          ) : (
            cart.map(item => (
              <div key={item.id_variante} className="bg-white p-3 rounded shadow-sm border border-gray-200">
                <div className="flex justify-between mb-1">
                  <span className="font-bold text-sm w-3/4 truncate text-gray-800">
                    {item.nombre}
                  </span>
                  <span className="font-bold text-green-700 text-sm">
                    ${item.subtotal.toLocaleString()}
                  </span>
                </div>
                <div className="text-xs text-gray-500 mb-2">
                  Talle: <b>{item.talle}</b> | SKU: {item.sku}
                </div>
                <div className="flex justify-between items-center bg-gray-50 p-1 rounded">
                  <div className="flex items-center gap-2">
                    <button
                      onClick={() => updateQuantity(item.id_variante, -1)}
                      className="p-1 bg-white border rounded hover:bg-gray-200"
                    >
                      <Minus size={12} />
                    </button>
                    <span className="font-bold text-gray-800 w-6 text-center text-sm">
                      {item.cantidad}
                    </span>
                    <button
                      onClick={() => updateQuantity(item.id_variante, 1)}
                      className="p-1 bg-white border rounded hover:bg-gray-200"
                    >
                      <Plus size={12} />
                    </button>
                  </div>
                  <button
                    onClick={() => removeFromCart(item.id_variante)}
                    className="text-red-400 hover:text-red-600 p-1"
                  >
                    <Trash2 size={16} />
                  </button>
                </div>
              </div>
            ))
          )}
        </div>

        <div className="p-4 bg-white border-t shadow-[0_-4px_6px_-1px_rgba(0,0,0,0.1)] z-20">
          <div className="mb-4">
            <p className="text-xs font-bold text-gray-500 mb-2 uppercase">Medio de Pago</p>
            <div className="grid grid-cols-3 gap-2">
              {paymentMethods.map(m => (
                <button
                  key={m.id}
                  onClick={() => setSelectedMethod(m)}
                  className={`flex flex-col items-center justify-center p-2 rounded-lg border transition-all ${selectedMethod?.id === m.id
                    ? 'bg-blue-600 text-white border-blue-600 shadow-md'
                    : 'bg-white text-gray-600 border-gray-200 hover:bg-gray-50'
                    }`}
                >
                  {getPaymentIcon(m.nombre)}
                  <span className="text-[10px] font-bold mt-1 uppercase">
                    {m.nombre}
                  </span>
                </button>
              ))}
            </div>
          </div>

          <div className="flex justify-between items-end mb-4 border-b pb-2 border-dashed">
            <div>
              <span className="text-gray-500 font-medium block">Total a Pagar</span>
              {descuentoVisual !== 0 && (
                <div className="text-xs text-gray-400 line-through">
                  Orig: ${subtotalCalculado.toLocaleString()}
                </div>
              )}
              {descuentoVisual > 0 && (
                <div className="text-xs text-green-600 font-bold">
                  Desc: -${descuentoVisual.toLocaleString()}
                </div>
              )}
            </div>
            <div className="flex items-center">
              {isEditingPrice ? (
                <div className="flex flex-col items-end animate-fade-in-down">
                  <input
                    type="number"
                    autoFocus
                    className="text-3xl font-black text-right w-40 border-b-2 border-blue-500 outline-none bg-transparent text-gray-800"
                    value={customTotal === null ? subtotalCalculado : customTotal}
                    onChange={e => setCustomTotal(e.target.value)}
                    onBlur={() => setIsEditingPrice(false)}
                    onKeyDown={e => {
                      if (e.key === 'Enter') setIsEditingPrice(false);
                      if (e.key === 'Escape') {
                        setCustomTotal(null);
                        setIsEditingPrice(false);
                      }
                    }}
                  />
                  <span className="text-[10px] text-blue-500">Enter para fijar</span>
                </div>
              ) : (
                <div
                  onClick={() => setIsEditingPrice(true)}
                  className="cursor-pointer flex items-center group"
                  title="Clic para editar precio"
                >
                  <span className={`text-3xl font-black tracking-tight mr-2 ${descuentoVisual !== 0 ? 'text-blue-600' : 'text-gray-900'
                    }`}>
                    $ {totalFinal.toLocaleString()}
                  </span>
                  <Edit size={18} className="text-gray-300 group-hover:text-blue-500 transition-colors" />
                </div>
              )}
            </div>
          </div>

          <button
            onClick={handleCheckoutClick}
            disabled={cart.length === 0}
            className={`w-full py-4 rounded-xl font-bold text-lg flex justify-center items-center shadow-lg transition-transform active:scale-95 ${cart.length > 0 && selectedMethod
              ? 'bg-green-600 text-white hover:bg-green-700'
              : 'bg-gray-200 text-gray-400 cursor-not-allowed'
              }`}
          >
            {cart.length === 0 ? 'CARRITO VACÍO' : !selectedMethod ? 'SELECCIONA PAGO' : 'COBRAR (F12)'}
          </button>
        </div>
      </div>
    </div>
  );
};

export default POSPage;