import { useEffect, useState, useRef } from 'react';
import axios from 'axios';
import { useAuth } from '../context/AuthContext';
import { useReactToPrint } from 'react-to-print';
import Ticket from '../components/Ticket';
import toast, { Toaster } from 'react-hot-toast';
import {
  Calendar, DollarSign, CreditCard, ShoppingBag,
  Printer, Eye, X, Package
} from 'lucide-react';
import { api } from '../context/AuthContext';

const SalesHistoryPage = () => {
  const { token } = useAuth();
  const [sales, setSales] = useState([]);
  const [summary, setSummary] = useState({ total: 0, count: 0 });
  const [loading, setLoading] = useState(true);

  // --- ESTADOS PARA MODALES ---
  const [viewingSale, setViewingSale] = useState(null); // Para el modal de detalle
  const [ticketData, setTicketData] = useState(null);   // Para imprimir

  // --- IMPRESIÓN ---
  const ticketRef = useRef(null);
  const reactToPrintFn = useReactToPrint({
    contentRef: ticketRef,
  });

  const prepareAndPrint = (venta) => {
    const dataForTicket = {
      id_venta: venta.id,
      fecha: venta.fecha,
      items: venta.items_detail || [],
      total: venta.total,
      cliente: "Consumidor Final"
    };
    setTicketData(dataForTicket);
    setTimeout(() => { if (reactToPrintFn) reactToPrintFn(); }, 150);
  };

  // --- CARGA DE DATOS ---
  useEffect(() => {
    const fetchHistory = async () => {
      try {
        const res = await api.get('/sales/history');
        setSales(res.data.history);
        setSummary(res.data.today_summary);
      } catch (error) {
        console.error(error);
        toast.error('Error al cargar historial');
      } finally {
        setLoading(false);
      }
    };
    if (token) fetchHistory();
  }, [token]);

  if (loading) return <div className="p-8 text-center text-gray-500">Cargando historial...</div>;

  return (
    <div className="space-y-6 h-full flex flex-col">
      <Toaster position="top-center" />

      {/* Ticket oculto para impresión */}
      <div style={{ position: 'absolute', left: '-9999px', top: '0' }}>
        <div ref={ticketRef}><Ticket saleData={ticketData} /></div>
      </div>

      {/* --- MODAL DE DETALLE DE VENTA --- */}
      {viewingSale && (
        <div className="fixed inset-0 bg-black/60 backdrop-blur-sm z-50 flex items-center justify-center p-4 animate-fade-in">
          <div className="bg-white rounded-xl shadow-2xl w-full max-w-2xl overflow-hidden flex flex-col max-h-[90vh]">

            {/* Header Modal */}
            <div className="bg-slate-50 p-5 border-b flex justify-between items-center">
              <div>
                <h3 className="font-bold text-xl text-gray-800">Detalle de Venta #{viewingSale.id}</h3>
                <p className="text-sm text-gray-500">{viewingSale.fecha} • {viewingSale.metodo}</p>
              </div>
              <button onClick={() => setViewingSale(null)} className="text-gray-400 hover:text-red-500 bg-white rounded-full p-1 shadow-sm">
                <X size={24} />
              </button>
            </div>

            {/* Body Modal (Tabla Scrollable) */}
            <div className="p-0 overflow-y-auto flex-1">
              <table className="w-full text-sm text-left">
                <thead className="bg-gray-100 text-gray-500 uppercase text-xs sticky top-0">
                  <tr>
                    <th className="p-4">Producto / Talle</th>
                    <th className="p-4 text-center">Cant.</th>
                    <th className="p-4 text-right">Precio Unit.</th>
                    <th className="p-4 text-right">Subtotal</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-gray-100">
                  {viewingSale.items_detail?.map((item, idx) => (
                    <tr key={idx} className="hover:bg-blue-50/30">
                      <td className="p-4">
                        <p className="font-bold text-gray-800">{item.nombre}</p>
                        <span className="text-xs bg-gray-100 px-2 py-0.5 rounded text-gray-600 border">Talle: {item.talle}</span>
                      </td>
                      <td className="p-4 text-center font-medium">{item.cantidad}</td>
                      <td className="p-4 text-right text-gray-500">$ {item.precio.toLocaleString()}</td>
                      <td className="p-4 text-right font-bold text-gray-800">$ {item.subtotal.toLocaleString()}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>

            {/* Footer Modal */}
            <div className="p-5 bg-slate-50 border-t flex justify-between items-center">
              <button
                onClick={() => prepareAndPrint(viewingSale)}
                className="flex items-center text-blue-600 hover:bg-blue-100 px-4 py-2 rounded-lg font-bold text-sm transition-colors"
              >
                <Printer size={18} className="mr-2" /> Reimprimir Ticket
              </button>
              <div className="text-right">
                <span className="text-gray-500 text-sm mr-4 uppercase font-bold">Total Venta</span>
                <span className="text-2xl font-black text-gray-900">$ {viewingSale.total.toLocaleString()}</span>
              </div>
            </div>
          </div>
        </div>
      )}

      {/* HEADER DE PÁGINA */}
      <div className="flex justify-between items-center shrink-0">
        <div>
          <h1 className="text-2xl font-bold text-gray-800 flex items-center">
            <Calendar className="mr-2 text-blue-600" /> Historial de Ventas
          </h1>
          <p className="text-sm text-gray-500">Registro de operaciones recientes</p>
        </div>
      </div>

      {/* TARJETAS KPI */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-4 shrink-0">
        <div className="bg-white p-6 rounded-xl shadow-sm border border-blue-100 flex items-center">
          <div className="p-3 rounded-full bg-green-100 text-green-600 mr-4"><DollarSign size={24} /></div>
          <div><p className="text-xs font-bold text-gray-500 uppercase">Vendido Hoy</p><p className="text-2xl font-black text-gray-800">$ {summary.total.toLocaleString()}</p></div>
        </div>
        <div className="bg-white p-6 rounded-xl shadow-sm border border-blue-100 flex items-center">
          <div className="p-3 rounded-full bg-blue-100 text-blue-600 mr-4"><ShoppingBag size={24} /></div>
          <div><p className="text-xs font-bold text-gray-500 uppercase">Tickets Hoy</p><p className="text-2xl font-black text-gray-800">{summary.count}</p></div>
        </div>
        <div className="bg-white p-6 rounded-xl shadow-sm border border-blue-100 flex items-center">
          <div className="p-3 rounded-full bg-purple-100 text-purple-600 mr-4"><CreditCard size={24} /></div>
          <div><p className="text-xs font-bold text-gray-500 uppercase">Ticket Promedio</p><p className="text-2xl font-black text-gray-800">$ {summary.count > 0 ? (summary.total / summary.count).toFixed(0) : 0}</p></div>
        </div>
      </div>

      {/* TABLA PRINCIPAL */}
      <div className="bg-white rounded-xl shadow-sm border border-gray-200 flex-1 flex flex-col overflow-hidden">
        <div className="overflow-auto flex-1">
          <table className="min-w-full divide-y divide-gray-200">
            <thead className="bg-gray-50 sticky top-0 z-10">
              <tr>
                <th className="px-6 py-3 text-left text-xs font-bold text-gray-500 uppercase">ID</th>
                <th className="px-6 py-3 text-left text-xs font-bold text-gray-500 uppercase">Fecha</th>
                <th className="px-6 py-3 text-left text-xs font-bold text-gray-500 uppercase">Resumen Items</th>
                <th className="px-6 py-3 text-left text-xs font-bold text-gray-500 uppercase">Método</th>
                <th className="px-6 py-3 text-left text-xs font-bold text-gray-500 uppercase">Total</th>
                <th className="px-6 py-3 text-right text-xs font-bold text-gray-500 uppercase">Acciones</th>
              </tr>
            </thead>

            <tbody className="divide-y divide-gray-200">
              {sales.map(venta => (
                <tr key={venta.id} className="hover:bg-gray-50 transition-colors">
                  <td className="px-6 py-4 font-bold text-gray-900">#{venta.id}</td>
                  <td className="px-6 py-4 text-xs text-gray-500 whitespace-nowrap">{venta.fecha}</td>

                  {/* Resumen de Items (Con tooltip) */}
                  <td className="px-6 py-4">
                    <div className="flex items-center text-sm text-gray-700 max-w-xs">
                      <Package size={16} className="text-gray-400 mr-2 flex-shrink-0" />
                      <p className="truncate" title={venta.items}>{venta.items}</p>
                    </div>
                  </td>

                  <td className="px-6 py-4 whitespace-nowrap">
                    <span className={`px-2 py-1 rounded text-[10px] font-bold border uppercase ${(venta.metodo || '').includes('Efectivo') ? 'bg-green-50 text-green-700 border-green-200' :
                      (venta.metodo || '').includes('Tarjeta') ? 'bg-blue-50 text-blue-700 border-blue-200' :
                        'bg-gray-50 text-gray-700 border-gray-200'
                      }`}>
                      {venta.metodo}
                    </span>
                  </td>

                  <td className="px-6 py-4 whitespace-nowrap font-black text-gray-800">
                    $ {venta.total.toLocaleString()}
                  </td>

                  <td className="px-6 py-4 text-right whitespace-nowrap">
                    {/* BOTÓN VER DETALLE (Ojo) */}
                    <button
                      onClick={() => setViewingSale(venta)}
                      className="text-gray-400 hover:text-blue-600 p-2 hover:bg-blue-50 rounded-full transition-all mr-1"
                      title="Ver detalle completo"
                    >
                      <Eye size={18} />
                    </button>

                    {/* BOTÓN IMPRIMIR */}
                    <button
                      onClick={() => prepareAndPrint(venta)}
                      className="text-gray-400 hover:text-green-600 p-2 hover:bg-green-50 rounded-full transition-all"
                      title="Reimprimir Ticket"
                    >
                      <Printer size={18} />
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
};

export default SalesHistoryPage;