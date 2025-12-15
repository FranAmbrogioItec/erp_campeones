import { useEffect, useState } from 'react';
import axios from 'axios';
import { useAuth } from '../context/AuthContext';
import {
    BarChart3, Calendar, DollarSign, Users,
    CreditCard, TrendingUp, Award, Search, Maximize2
} from 'lucide-react';
import toast, { Toaster } from 'react-hot-toast';
import ProductStatsModal from '../components/ProductStatsModal'; // <--- IMPORTANTE: Tu nuevo modal
import { api } from '../context/AuthContext';

const StatsPage = () => {
    const { token } = useAuth();
    const [loading, setLoading] = useState(false);

    // Fechas por defecto: Primer día del mes actual hasta hoy
    const today = new Date().toISOString().split('T')[0];
    const firstDay = new Date(new Date().getFullYear(), new Date().getMonth(), 1).toISOString().split('T')[0];

    const [dateRange, setDateRange] = useState({ start: firstDay, end: today });

    // Datos del Dashboard General
    const [data, setData] = useState({
        summary: { ingresos: 0, tickets: 0, promedio: 0 },
        by_method: [],
        top_products: []
    });

    // Estados para el Modal de Detalle
    const [isProductModalOpen, setIsProductModalOpen] = useState(false);
    const [detailedProducts, setDetailedProducts] = useState([]);
    const [loadingDetails, setLoadingDetails] = useState(false);

    // 1. Cargar Estadísticas Generales
    const fetchStats = async () => {
        setLoading(true);
        try {
            const res = await api.post('/sales/stats/period', {
                start_date: dateRange.start,
                end_date: dateRange.end
            }, { headers: { Authorization: `Bearer ${token}` } });

            setData(res.data);
        } catch (e) {
            console.error(e);
            toast.error("Error cargando estadísticas");
        } finally {
            setLoading(false);
        }
    };

    // 2. Cargar Detalle Completo para el Modal
    const openProductDetails = async () => {
        setLoadingDetails(true);
        try {
            const res = await api.post('/sales/stats/products-detail', {
                start_date: dateRange.start,
                end_date: dateRange.end
            }, { headers: { Authorization: `Bearer ${token}` } });

            setDetailedProducts(res.data);
            setIsProductModalOpen(true);
        } catch (e) {
            toast.error("Error al cargar detalles de productos");
        } finally {
            setLoadingDetails(false);
        }
    };

    useEffect(() => { fetchStats(); }, [token]);

    return (
        <div className="p-6 max-w-7xl mx-auto space-y-8">
            <Toaster position="top-center" />

            {/* --- MODAL DE ANÁLISIS --- */}
            <ProductStatsModal
                isOpen={isProductModalOpen}
                onClose={() => setIsProductModalOpen(false)}
                data={detailedProducts}
                dateRange={dateRange}
            />

            {/* HEADER Y FILTROS */}
            <div className="flex flex-col md:flex-row justify-between items-end gap-4 border-b pb-6">
                <div>
                    <h1 className="text-2xl font-bold text-gray-800 flex items-center">
                        <BarChart3 className="mr-2 text-blue-600" /> Reportes y Estadísticas
                    </h1>
                    <p className="text-gray-500 text-sm">Analiza el rendimiento de tu negocio.</p>
                </div>

                <div className="bg-white p-2 rounded-xl shadow-sm border border-gray-200 flex gap-2 items-center">
                    <div className="flex flex-col">
                        <span className="text-[10px] font-bold text-gray-400 ml-1 uppercase">Desde</span>
                        <input type="date" className="border rounded-lg p-1 text-sm outline-none focus:ring-2 focus:ring-blue-500"
                            value={dateRange.start} onChange={e => setDateRange({ ...dateRange, start: e.target.value })} />
                    </div>
                    <div className="flex flex-col">
                        <span className="text-[10px] font-bold text-gray-400 ml-1 uppercase">Hasta</span>
                        <input type="date" className="border rounded-lg p-1 text-sm outline-none focus:ring-2 focus:ring-blue-500"
                            value={dateRange.end} onChange={e => setDateRange({ ...dateRange, end: e.target.value })} />
                    </div>
                    <button onClick={fetchStats} className="bg-blue-600 text-white p-3 rounded-lg hover:bg-blue-700 transition-colors ml-2 shadow-md">
                        <Search size={20} />
                    </button>
                </div>
            </div>

            {loading ? (
                <div className="p-20 text-center text-gray-400 animate-pulse">Calculando métricas...</div>
            ) : (
                <>
                    {/* 1. KPIs PRINCIPALES */}
                    <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
                        <div className="bg-white p-6 rounded-2xl shadow-lg border-l-8 border-green-500 flex flex-col justify-between">
                            <div>
                                <p className="text-sm font-bold text-gray-400 uppercase">Ingresos Totales</p>
                                <h2 className="text-4xl font-black text-gray-800 mt-2">$ {data.summary.ingresos.toLocaleString()}</h2>
                            </div>
                            <div className="mt-4 flex items-center text-green-600 text-sm font-bold">
                                <DollarSign size={16} className="mr-1" /> Facturación Bruta
                            </div>
                        </div>

                        <div className="bg-white p-6 rounded-2xl shadow-lg border-l-8 border-blue-500 flex flex-col justify-between">
                            <div>
                                <p className="text-sm font-bold text-gray-400 uppercase">Cantidad Ventas</p>
                                <h2 className="text-4xl font-black text-gray-800 mt-2">{data.summary.tickets}</h2>
                            </div>
                            <div className="mt-4 flex items-center text-blue-600 text-sm font-bold">
                                <Users size={16} className="mr-1" /> Clientes atendidos
                            </div>
                        </div>

                        <div className="bg-white p-6 rounded-2xl shadow-lg border-l-8 border-purple-500 flex flex-col justify-between">
                            <div>
                                <p className="text-sm font-bold text-gray-400 uppercase">Ticket Promedio</p>
                                <h2 className="text-4xl font-black text-gray-800 mt-2">$ {data.summary.promedio.toLocaleString()}</h2>
                            </div>
                            <div className="mt-4 flex items-center text-purple-600 text-sm font-bold">
                                <TrendingUp size={16} className="mr-1" /> Gasto por cliente
                            </div>
                        </div>
                    </div>

                    <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">

                        {/* 2. MEDIOS DE PAGO (Gráfico de Barras CSS) */}
                        <div className="bg-white p-6 rounded-2xl shadow-sm border border-gray-100">
                            <h3 className="font-bold text-gray-800 mb-6 flex items-center">
                                <CreditCard className="mr-2 text-slate-500" /> Ingresos por Medio de Pago
                            </h3>
                            <div className="space-y-4">
                                {data.by_method.map((m, i) => {
                                    // Calculamos porcentaje visual
                                    const percent = data.summary.ingresos > 0
                                        ? (m.total / data.summary.ingresos) * 100
                                        : 0;

                                    return (
                                        <div key={i}>
                                            <div className="flex justify-between text-sm mb-1">
                                                <span className="font-bold text-gray-700">{m.nombre}</span>
                                                <span className="text-gray-500 font-mono">$ {m.total.toLocaleString()}</span>
                                            </div>
                                            <div className="w-full bg-gray-100 rounded-full h-3 overflow-hidden">
                                                <div
                                                    className="bg-blue-500 h-3 rounded-full transition-all duration-1000"
                                                    style={{ width: `${percent}%` }}
                                                ></div>
                                            </div>
                                            <p className="text-[10px] text-right text-gray-400 mt-1">{m.count} transacciones ({percent.toFixed(1)}%)</p>
                                        </div>
                                    )
                                })}
                                {data.by_method.length === 0 && <p className="text-gray-400 text-center">Sin datos</p>}
                            </div>
                        </div>

                        {/* 3. PRODUCTOS ESTRELLA */}
                        <div className="bg-white p-6 rounded-2xl shadow-sm border border-gray-100 h-full flex flex-col">
                            <div className="flex justify-between items-center mb-6">
                                <h3 className="font-bold text-gray-800 flex items-center">
                                    <Award className="mr-2 text-yellow-500" /> Top Productos
                                </h3>
                                <button
                                    onClick={openProductDetails}
                                    disabled={loadingDetails}
                                    className="text-xs flex items-center bg-blue-50 text-blue-600 px-3 py-1.5 rounded-lg hover:bg-blue-100 font-bold transition-colors disabled:opacity-50"
                                >
                                    {loadingDetails ? 'Cargando...' : <><Maximize2 size={14} className="mr-1" /> Ver Todo / Filtrar</>}
                                </button>
                            </div>

                            <div className="overflow-hidden flex-1">
                                <table className="w-full text-sm text-left">
                                    <thead className="bg-gray-50 text-gray-500 uppercase text-xs">
                                        <tr>
                                            <th className="p-3 rounded-l-lg">#</th>
                                            <th className="p-3">Producto</th>
                                            <th className="p-3 text-right">Cant.</th>
                                            <th className="p-3 text-right rounded-r-lg">Total</th>
                                        </tr>
                                    </thead>
                                    <tbody className="divide-y divide-gray-50">
                                        {data.top_products.map((p, index) => (
                                            <tr key={index} className="hover:bg-yellow-50/30 transition-colors">
                                                <td className="p-3">
                                                    <span className={`flex items-center justify-center w-6 h-6 rounded-full text-xs font-bold ${index === 0 ? 'bg-yellow-100 text-yellow-700' :
                                                        index === 1 ? 'bg-gray-200 text-gray-700' :
                                                            index === 2 ? 'bg-orange-100 text-orange-800' : 'text-gray-400'
                                                        }`}>
                                                        {index + 1}
                                                    </span>
                                                </td>
                                                <td className="p-3 font-medium text-gray-700 truncate max-w-[150px]" title={p.nombre}>{p.nombre}</td>
                                                <td className="p-3 text-right">{p.unidades}</td>
                                                <td className="p-3 text-right font-black text-gray-800">$ {p.recaudado.toLocaleString()}</td>
                                            </tr>
                                        ))}
                                    </tbody>
                                </table>
                                {data.top_products.length === 0 && <p className="text-gray-400 text-center mt-10">Sin ventas en este período.</p>}
                            </div>
                        </div>

                    </div>
                </>
            )}
        </div>
    );
};

export default StatsPage;