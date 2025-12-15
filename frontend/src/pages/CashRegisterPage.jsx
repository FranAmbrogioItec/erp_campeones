import { useEffect, useState } from 'react';
import { useAuth } from '../context/AuthContext';
import { Lock, Unlock, DollarSign, AlertTriangle, Save, MinusCircle, Wallet, CreditCard, Smartphone, FileText, Receipt, Download } from 'lucide-react';
import toast, { Toaster } from 'react-hot-toast';
import { api } from '../context/AuthContext';

const CashRegisterPage = () => {
    const { token } = useAuth();

    // Estados
    const [status, setStatus] = useState(null);
    const [loading, setLoading] = useState(true);
    const [sessionData, setSessionData] = useState(null);

    // Inputs
    const [montoInicial, setMontoInicial] = useState('');
    const [montoCierre, setMontoCierre] = useState('');

    // Gastos
    const [showExpenseForm, setShowExpenseForm] = useState(false);
    const [expenseData, setExpenseData] = useState({ monto: '', descripcion: '' });

    // Resultado
    const [cierreResult, setCierreResult] = useState(null);

    // --- CARGA DE DATOS ---
    const fetchData = async () => {
        try {
            const res = await api.get('/sales/caja/status');
            setStatus(res.data.estado);
            if (res.data.estado === 'abierta') setSessionData(res.data);
        } catch (error) { toast.error("Error conectando con caja"); }
        finally { setLoading(false); }
    };

    useEffect(() => {
        if (token) fetchData();
    }, [token]);

    // --- ACCIONES ---
    const handleOpen = async (e) => {
        e.preventDefault();
        if (!montoInicial || parseFloat(montoInicial) < 0) {
            toast.error("Ingresa un monto inicial válido"); return;
        }
        try {
            await api.post('/sales/caja/open',
                { monto_inicial: montoInicial });
            fetchData();
            toast.success("Caja Abierta Correctamente");
        } catch (e) { toast.error(e.response?.data?.msg || "Error"); }
    };

    const handleExpense = async (e) => {
        e.preventDefault();
        try {
            await api.post('/sales/caja/movement', {
                tipo: 'retiro',
                monto: expenseData.monto,
                descripcion: expenseData.descripcion
            });

            toast.success("Retiro registrado");
            setShowExpenseForm(false);
            setExpenseData({ monto: '', descripcion: '' });
            fetchData();
        } catch (e) { toast.error("Error registrando retiro"); }
    };

    const handleClose = async (e) => {
        e.preventDefault();
        // VALIDACIÓN PREVIA
        if (montoCierre === '' || parseFloat(montoCierre) < 0) {
            toast.error("Debes contar el dinero e ingresarlo para cerrar.");
            return;
        }

        if (!window.confirm(`¿Confirmas que hay $${parseFloat(montoCierre).toLocaleString()} EFECTIVO FÍSICO en la caja?`)) return;

        try {
            const res = await api.post('/sales/caja/close',
                { total_real: montoCierre });
            setCierreResult(res.data.resumen);
            setStatus('cerrada');
            setSessionData(null);
        } catch (e) { toast.error("Error al cerrar caja"); }
    };

    if (loading) return <div className="p-10 text-center animate-pulse">Cargando caja...</div>;

    // --- VISTA: RESULTADO DEL CIERRE ---
    if (cierreResult) {
        return (
            <div className="p-8 flex flex-col items-center justify-center h-full animate-fade-in-down">
                <div className="bg-white p-8 rounded-xl shadow-2xl border max-w-md w-full text-center">
                    <div className="bg-green-100 p-4 rounded-full inline-block mb-4 text-green-600"><Lock size={40} /></div>
                    <h2 className="text-2xl font-bold mb-6 text-gray-800">Turno Cerrado</h2>

                    <div className="space-y-4 text-left border-t border-b py-6 mb-6">
                        <div className="flex justify-between text-gray-600">
                            <span className="text-sm">Esperado (Solo Efectivo):</span>
                            <span className="font-bold">$ {cierreResult.esperado.toLocaleString()}</span>
                        </div>
                        <div className="flex justify-between text-gray-800 text-lg">
                            <span className="font-bold">Real (Tus Billetes):</span>
                            <span className="font-black text-blue-600">$ {cierreResult.real.toLocaleString()}</span>
                        </div>

                        <div className={`flex justify-between p-3 rounded-lg mt-2 ${cierreResult.diferencia === 0 ? 'bg-green-100 border border-green-200' : 'bg-red-100 border border-red-200'}`}>
                            <span className="font-bold text-sm flex items-center">Diferencia:</span>
                            <span className={`font-black ${cierreResult.diferencia === 0 ? 'text-green-700' : 'text-red-700'}`}>
                                $ {cierreResult.diferencia.toLocaleString()}
                            </span>
                        </div>
                    </div>
                    <button onClick={() => { setCierreResult(null); setMontoCierre(''); setMontoInicial(''); }} className="bg-slate-800 text-white w-full py-3 rounded-lg font-bold hover:bg-black transition-colors">Volver a Empezar</button>
                </div>
            </div>
        )
    }

    return (
        <div className="p-6 max-w-3xl mx-auto">
            <Toaster position="top-center" />

            <div className="text-center mb-8">
                <h1 className="text-3xl font-black text-gray-800 flex items-center justify-center">
                    <DollarSign className="mr-2 text-blue-600" size={32} /> Control de Caja Diario
                </h1>
                <p className="text-gray-500 mt-2">Gestión de apertura, arqueo y cierre de turno.</p>
            </div>

            {status === 'cerrada' ? (
                /* --- VISTA CAJA CERRADA --- */
                <div className="bg-white p-10 rounded-2xl shadow-xl border border-gray-100 text-center max-w-lg mx-auto">
                    <div className="bg-red-50 w-20 h-20 rounded-full flex items-center justify-center mx-auto mb-6">
                        <Lock className="text-red-500" size={40} />
                    </div>
                    <h2 className="text-2xl font-bold text-gray-800 mb-2">Caja Cerrada</h2>
                    <p className="text-gray-500 mb-8">Ingresa el cambio inicial para comenzar a operar.</p>

                    <form onSubmit={handleOpen} className="text-left bg-gray-50 p-6 rounded-xl border border-gray-200">
                        <label className="block text-xs font-bold text-gray-500 uppercase mb-2 ml-1">Dinero Inicial en Caja</label>
                        <div className="relative mb-6">
                            <span className="absolute left-4 top-3 text-gray-400 font-bold">$</span>
                            <input
                                type="number" required autoFocus
                                className="w-full pl-8 p-3 text-lg font-bold border rounded-lg focus:ring-2 focus:ring-blue-500 outline-none"
                                placeholder="0.00"
                                value={montoInicial} onChange={e => setMontoInicial(e.target.value)}
                            />
                        </div>
                        <button type="submit" className="w-full bg-blue-600 text-white py-3 rounded-lg font-bold hover:bg-blue-700 shadow-lg hover:shadow-blue-200 transition-all flex justify-center items-center">
                            <Unlock size={20} className="mr-2" /> ABRIR CAJA
                        </button>
                    </form>
                </div>
            ) : (
                /* --- VISTA CAJA ABIERTA --- */
                <div className="bg-white rounded-2xl shadow-xl border border-gray-100 overflow-hidden">
                    {/* Header Info */}
                    <div className="bg-slate-800 text-white p-6 flex justify-between items-center">
                        <div className="flex items-center">
                            <div className="p-2 bg-green-500 rounded-lg mr-4 animate-pulse"><Unlock size={24} /></div>
                            <div>
                                <h2 className="text-lg font-bold">Turno en Curso</h2>
                                <p className="text-slate-400 text-xs">Inicio: {sessionData?.fecha_apertura}</p>
                            </div>
                        </div>
                        <div className="text-right">
                            <p className="text-slate-400 text-xs uppercase font-bold">Ventas Totales</p>
                            <p className="text-2xl font-black text-green-400">$ {sessionData?.ventas_total.toLocaleString()}</p>
                        </div>
                    </div>

                    <div className="p-8">
                        {/* Resumen Financiero */}
                        <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-8">
                            <div className="bg-green-50 p-4 rounded-xl border border-green-100 relative overflow-hidden">
                                <div className="relative z-10">
                                    <p className="text-xs font-bold text-green-800 uppercase mb-1 flex items-center"><Wallet size={14} className="mr-1" /> Efectivo Teórico</p>
                                    <p className="text-2xl font-black text-green-700">$ {sessionData?.totales_esperados.efectivo_en_caja.toLocaleString()}</p>
                                </div>
                                <Wallet className="absolute -bottom-4 -right-4 text-green-200 opacity-50" size={60} />
                            </div>
                            <div className="bg-blue-50 p-4 rounded-xl border border-blue-100 relative overflow-hidden">
                                <div className="relative z-10">
                                    <p className="text-xs font-bold text-blue-800 uppercase mb-1 flex items-center"><CreditCard size={14} className="mr-1" /> Tarjetas</p>
                                    <p className="text-2xl font-black text-blue-700">$ {sessionData?.desglose.tarjeta.toLocaleString()}</p>
                                </div>
                                <CreditCard className="absolute -bottom-4 -right-4 text-blue-200 opacity-50" size={60} />
                            </div>
                            <div className="bg-purple-50 p-4 rounded-xl border border-purple-100 relative overflow-hidden">
                                <div className="relative z-10">
                                    <p className="text-xs font-bold text-purple-800 uppercase mb-1 flex items-center"><Smartphone size={14} className="mr-1" /> Transferencias</p>
                                    <p className="text-2xl font-black text-purple-700">$ {sessionData?.desglose.transferencia.toLocaleString()}</p>
                                </div>
                                <Smartphone className="absolute -bottom-4 -right-4 text-purple-200 opacity-50" size={60} />
                            </div>
                        </div>

                        {/* Sección Gastos */}
                        <div className="mb-8">
                            <div className="flex justify-between items-center mb-4">
                                <h3 className="font-bold text-gray-700">Movimientos de Caja</h3>
                                <button onClick={() => setShowExpenseForm(!showExpenseForm)} className="text-red-600 hover:bg-red-50 px-3 py-1 rounded text-xs font-bold border border-red-200 flex items-center transition-colors">
                                    <MinusCircle size={14} className="mr-1" /> REGISTRAR RETIRO
                                </button>
                            </div>

                            {showExpenseForm && (
                                <div className="bg-red-50 p-4 rounded-xl border border-red-100 animate-fade-in-down mb-4">
                                    <form onSubmit={handleExpense} className="flex gap-3 items-end">
                                        <div className="w-32">
                                            <label className="text-[10px] font-bold text-red-400 uppercase">Monto</label>
                                            <input type="number" required className="w-full p-2 text-sm border border-red-200 rounded outline-none focus:border-red-400" placeholder="$" value={expenseData.monto} onChange={e => setExpenseData({ ...expenseData, monto: e.target.value })} />
                                        </div>
                                        <div className="flex-1">
                                            <label className="text-[10px] font-bold text-red-400 uppercase">Motivo</label>
                                            <input required className="w-full p-2 text-sm border border-red-200 rounded outline-none focus:border-red-400" placeholder="Ej: Pago Proveedor" value={expenseData.descripcion} onChange={e => setExpenseData({ ...expenseData, descripcion: e.target.value })} />
                                        </div>
                                        <button type="submit" className="bg-red-500 text-white px-4 py-2 rounded font-bold text-sm hover:bg-red-600 h-10">Guardar</button>
                                    </form>
                                </div>
                            )}
                        </div>

                        <hr className="border-gray-100 mb-8" />

                        {/* --- NUEVA LISTA DE RETIROS --- */}
                        {sessionData?.movimientos?.length > 0 && (
                            <div className="mb-6 bg-red-50/50 border border-red-100 rounded-lg overflow-hidden">
                                <div className="bg-red-50 p-2 text-[10px] font-bold text-red-600 uppercase flex items-center">
                                    <Receipt size={12} className="mr-1" /> Retiros / Gastos del Turno
                                </div>
                                <div className="max-h-32 overflow-y-auto">
                                    <table className="w-full text-xs">
                                        <tbody>
                                            {sessionData.movimientos.map(m => (
                                                <tr key={m.id} className="border-b border-red-100 last:border-0 text-red-800">
                                                    <td className="p-2 w-16">{m.hora}</td>
                                                    <td className="p-2 font-medium">{m.descripcion}</td>
                                                    <td className="p-2 text-right font-bold">- ${m.monto.toLocaleString()}</td>
                                                </tr>
                                            ))}
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        )}

                        {/* Arqueo Final */}
                        <div className="bg-gray-50 p-6 rounded-xl border border-gray-200">
                            <h3 className="font-bold text-lg mb-2 text-gray-800 flex items-center">
                                <Save className="mr-2 text-slate-600" size={20} /> Cierre de Turno
                            </h3>
                            <p className="text-sm text-gray-500 mb-6">Cuenta únicamente el dinero físico (billetes) que hay en la caja.</p>

                            <form onSubmit={handleClose}>
                                <div className="mb-4">
                                    <div className="relative">
                                        <span className="absolute left-4 top-3 text-gray-400 text-xl font-bold">$</span>
                                        <input
                                            type="number" required
                                            className="w-full pl-10 p-4 text-2xl font-black border-2 border-slate-200 rounded-xl focus:border-slate-800 outline-none transition-colors"
                                            placeholder="0.00"
                                            value={montoCierre} onChange={e => setMontoCierre(e.target.value)}
                                        />
                                    </div>
                                </div>

                                <div className="bg-yellow-50 p-3 rounded-lg border border-yellow-200 mb-6 flex items-start">
                                    <AlertTriangle className="text-yellow-600 mr-2 flex-shrink-0" size={18} />
                                    <p className="text-xs text-yellow-800 leading-tight pt-0.5">
                                        Esta acción cerrará el turno actual y generará el reporte de diferencias. No se puede deshacer.
                                    </p>
                                </div>

                                <button
                                    type="submit"
                                    disabled={!montoCierre}
                                    className="w-full bg-slate-900 text-white py-4 rounded-xl font-bold hover:bg-black flex justify-center items-center shadow-lg hover:shadow-slate-300 transition-all disabled:opacity-50 disabled:cursor-not-allowed"
                                >
                                    <Lock size={18} className="mr-2" /> CONFIRMAR Y CERRAR
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            )}
        </div>
    );
};

export default CashRegisterPage;