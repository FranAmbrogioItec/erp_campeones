import { useEffect, useState } from 'react';
import axios from 'axios';
import { useAuth } from '../context/AuthContext';
import { FileText, Download, Calendar, ChevronDown, ChevronRight } from 'lucide-react';
import { api } from '../context/AuthContext';

const CashHistoryPage = () => {
    const { token } = useAuth();
    const [loading, setLoading] = useState(true);
    const [groupedSessions, setGroupedSessions] = useState({});
    const [expandedMonths, setExpandedMonths] = useState({});

    useEffect(() => {
        const fetchHistory = async () => {
            try {
                const res = await api.get('/sales/caja/list');

                // Agrupar por Mes/Año (Ej: "11/2025")
                const groups = res.data.reduce((acc, session) => {
                    // Asumiendo formato DD/MM/YYYY HH:MM
                    // Extraemos MM/YYYY. Ajusta según tu formato de fecha real
                    const datePart = session.cierre.split(' ')[0]; // DD/MM/YYYY
                    const parts = datePart.split('/');
                    const monthKey = `${parts[1]}/${parts[2]}`; // MM/YYYY

                    if (!acc[monthKey]) acc[monthKey] = [];
                    acc[monthKey].push(session);
                    return acc;
                }, {});

                setGroupedSessions(groups);
                // Expandir el primer mes por defecto
                const firstKey = Object.keys(groups)[0];
                if (firstKey) setExpandedMonths({ [firstKey]: true });

            } catch (error) {
                console.error(error);
            } finally {
                setLoading(false);
            }
        };
        if (token) fetchHistory();
    }, [token]);

    const toggleMonth = (month) => {
        setExpandedMonths(prev => ({ ...prev, [month]: !prev[month] }));
    };

    if (loading) return <div className="p-8 text-center">Cargando histórico...</div>;

    return (
        <div className="p-6 max-w-5xl mx-auto">
            <div className="flex items-center mb-8">
                <div className="p-3 bg-blue-100 text-blue-600 rounded-full mr-4">
                    <FileText size={32} />
                </div>
                <div>
                    <h1 className="text-2xl font-bold text-gray-800">Historial de Cierres</h1>
                    <p className="text-gray-500 text-sm">Auditoría de cajas pasadas organizada por mes.</p>
                </div>
            </div>

            <div className="space-y-6">
                {Object.keys(groupedSessions).length === 0 ? (
                    <div className="text-center p-10 bg-white rounded-xl shadow border border-gray-200 text-gray-400">
                        No hay registros de cajas cerradas aún.
                    </div>
                ) : (
                    Object.keys(groupedSessions).map(monthKey => (
                        <div key={monthKey} className="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
                            {/* Cabecera del Mes */}
                            <div
                                onClick={() => toggleMonth(monthKey)}
                                className="p-4 bg-gray-50 flex justify-between items-center cursor-pointer hover:bg-gray-100 transition-colors"
                            >
                                <div className="flex items-center font-bold text-gray-700">
                                    <Calendar className="mr-2 text-blue-500" size={20} />
                                    <span>Período: {monthKey}</span>
                                    <span className="ml-3 bg-gray-200 text-gray-600 text-xs px-2 py-1 rounded-full">
                                        {groupedSessions[monthKey].length} cierres
                                    </span>
                                </div>
                                {expandedMonths[monthKey] ? <ChevronDown size={20} /> : <ChevronRight size={20} />}
                            </div>

                            {/* Tabla de Cierres (Colapsable) */}
                            {expandedMonths[monthKey] && (
                                <div className="overflow-x-auto">
                                    <table className="w-full text-sm text-left">
                                        <thead className="bg-white border-b border-gray-200 text-gray-500 uppercase text-xs">
                                            <tr>
                                                <th className="p-4">Fecha Cierre</th>
                                                <th className="p-4">Apertura</th>
                                                <th className="p-4">Ventas (Sistema)</th>
                                                <th className="p-4">Diferencia</th>
                                                <th className="p-4 text-right">Reporte</th>
                                            </tr>
                                        </thead>
                                        <tbody className="divide-y divide-gray-100">
                                            {groupedSessions[monthKey].map(session => (
                                                <tr key={session.id} className="hover:bg-blue-50/30 transition-colors">
                                                    <td className="p-4 font-bold text-gray-800">{session.cierre}</td>
                                                    <td className="p-4 text-gray-500">{session.apertura}</td>
                                                    <td className="p-4 font-mono font-medium text-blue-600">$ {session.ventas.toLocaleString()}</td>
                                                    <td className="p-4">
                                                        <span className={`px-2 py-1 rounded text-xs font-bold ${session.diferencia === 0
                                                            ? 'bg-green-100 text-green-700'
                                                            : session.diferencia > 0
                                                                ? 'bg-blue-100 text-blue-700'
                                                                : 'bg-red-100 text-red-700'
                                                            }`}>
                                                            {session.diferencia > 0 ? '+' : ''}{session.diferencia.toLocaleString()}
                                                        </span>
                                                    </td>
                                                    <td className="p-4 text-right">
                                                        <a
                                                            href={`/api/sales/caja/${session.id}/export`}
                                                            target="_blank"
                                                            rel="noreferrer"
                                                            className="text-gray-400 hover:text-green-600 p-2 rounded-full hover:bg-green-50 inline-flex items-center transition-all"
                                                            title="Descargar Excel"
                                                        >
                                                            <Download size={18} />
                                                        </a>
                                                    </td>
                                                </tr>
                                            ))}
                                        </tbody>
                                    </table>
                                </div>
                            )}
                        </div>
                    ))
                )}
            </div>
        </div>
    );
};

export default CashHistoryPage;