import { useState, useRef } from 'react';
import axios from 'axios';
import { useAuth } from '../context/AuthContext';
import { ArrowRightLeft, ScanBarcode, Ticket, CheckCircle, RefreshCcw, Printer, ArrowLeft } from 'lucide-react';
import toast, { Toaster } from 'react-hot-toast';
import { useReactToPrint } from 'react-to-print';
import CreditNoteTicket from '../components/CreditNoteTicket';
import { api } from '../context/AuthContext';

const ReturnsPage = () => {
    const { token } = useAuth();

    const [itemsIn, setItemsIn] = useState([]);
    const [itemsOut, setItemsOut] = useState([]);
    const [skuIn, setSkuIn] = useState('');
    const [skuOut, setSkuOut] = useState('');
    const [resultNota, setResultNota] = useState(null);

    // --- IMPRESIÓN ---
    const ticketRef = useRef(null);

    const reactToPrintFn = useReactToPrint({
        contentRef: ticketRef,
        documentTitle: `Nota_Credito_${resultNota?.codigo || 'NC'}`,
    });

    // Ticket oculto SIEMPRE renderizado
    const HiddenTicket = (
        <div style={{ position: 'absolute', left: '-9999px', top: 0 }}>
            <div ref={ticketRef}>
                <CreditNoteTicket data={resultNota} />
            </div>
        </div>
    );

    const findProduct = async (sku) => {
        try {
            const res = await api.get(`/sales/scan/${sku}`, {
                headers: { Authorization: `Bearer ${token}` }
            });
            return res.data.found ? res.data.product : null;
        } catch (e) {
            return null;
        }
    };

    const handleScanIn = async (e) => {
        e.preventDefault();
        if (!skuIn) return;
        const prod = await findProduct(skuIn);
        if (prod) {
            setItemsIn([...itemsIn, { ...prod, cantidad: 1 }]);
            setSkuIn('');
            toast.success("Agregado a Devolución");
        } else toast.error("Producto no encontrado");
    };

    const handleScanOut = async (e) => {
        e.preventDefault();
        if (!skuOut) return;
        const prod = await findProduct(skuOut);
        if (prod) {
            setItemsOut([...itemsOut, { ...prod, cantidad: 1 }]);
            setSkuOut('');
            toast.success("Agregado a Nuevo");
        } else toast.error("Producto no encontrado");
    };

    const totalIn = itemsIn.reduce((acc, i) => acc + i.precio, 0);
    const totalOut = itemsOut.reduce((acc, i) => acc + i.precio, 0);
    const balance = totalOut - totalIn;

    const handleProcess = async () => {
        if (itemsIn.length === 0 && itemsOut.length === 0) return;

        try {
            const res = await api.post('/returns/process', {
                items_in: itemsIn,
                items_out: itemsOut
            }, { headers: { Authorization: `Bearer ${token}` } });

            if (res.data.nota_credito) {
                setResultNota(res.data.nota_credito);
                toast.success("Nota de Crédito Generada");
            } else {
                toast.success(res.data.msg);
            }

            setItemsIn([]);
            setItemsOut([]);

        } catch (e) {
            toast.error(e.response?.data?.msg || "Error");
        }
    };

    // --- VISTA DE NOTA DE CRÉDITO ---
    if (resultNota) {
        return (
            <>
                {HiddenTicket}

                <div className="p-10 flex flex-col items-center justify-center h-full text-center animate-fade-in-down">

                    <div className="bg-green-100 p-4 rounded-full text-green-600 mb-4 shadow-sm">
                        <Ticket size={48} />
                    </div>

                    <h2 className="text-3xl font-bold text-gray-800">Nota de Crédito Generada</h2>

                    <div className="bg-white p-8 rounded-xl shadow-lg border-2 border-dashed border-gray-300 mt-6 w-full max-w-md relative">
                        <p className="text-sm text-gray-500 uppercase font-bold">Código de Canje</p>
                        <p className="text-5xl font-mono font-black text-blue-600 tracking-wider mb-6 mt-2 select-all">
                            {resultNota.codigo}
                        </p>

                        <div className="flex justify-between items-center border-t pt-4">
                            <span className="text-gray-500 font-medium">Saldo a Favor</span>
                            <span className="text-2xl font-bold text-gray-800">
                                $ {resultNota.monto.toLocaleString()}
                            </span>
                        </div>
                    </div>

                    <div className="flex gap-4 mt-8">
                        <button
                            onClick={reactToPrintFn}
                            className="bg-slate-800 text-white px-6 py-3 rounded-xl font-bold hover:bg-black flex items-center shadow-lg transition-transform hover:scale-105"
                        >
                            <Printer size={20} className="mr-2" /> Imprimir Comprobante
                        </button>

                        <button
                            onClick={() => setResultNota(null)}
                            className="bg-white text-gray-600 border border-gray-300 px-6 py-3 rounded-xl font-bold hover:bg-gray-50 flex items-center"
                        >
                            <ArrowLeft size={20} className="mr-2" /> Volver
                        </button>
                    </div>

                </div>
            </>
        );
    }

    // --- VISTA PRINCIPAL ---
    return (
        <div className="p-6 max-w-7xl mx-auto h-[calc(100vh-2rem)] flex flex-col">
            {HiddenTicket}
            <Toaster position="top-center" />

            <div className="flex justify-between items-center mb-6 shrink-0">
                <h1 className="text-2xl font-bold text-gray-800 flex items-center">
                    <RefreshCcw className="mr-2 text-blue-600" /> Cambios y Devoluciones
                </h1>
                <button
                    onClick={() => { setItemsIn([]); setItemsOut([]); }}
                    className="text-sm text-red-500 font-bold hover:underline bg-white px-3 py-1 rounded border border-red-100"
                >
                    Reiniciar Todo
                </button>
            </div>

            <div className="flex gap-6 flex-1 overflow-hidden">

                {/* IZQUIERDA: ENTRA */}
                <div className="flex-1 bg-red-50 border-2 border-red-100 rounded-xl p-4 flex flex-col shadow-sm">
                    <h3 className="font-bold text-red-800 flex items-center mb-4 text-sm uppercase tracking-wider">
                        <ArrowRightLeft className="mr-2" /> Devolución (Entra Stock)
                    </h3>

                    <form onSubmit={handleScanIn} className="mb-4">
                        <div className="relative">
                            <ScanBarcode className="absolute left-3 top-3 text-red-300" size={20} />
                            <input
                                className="w-full pl-10 p-3 rounded-lg border border-red-200 outline-none focus:ring-2 focus:ring-red-400 bg-white"
                                placeholder="Escanear producto..."
                                autoFocus
                                value={skuIn}
                                onChange={e => setSkuIn(e.target.value)}
                            />
                            <button
                                type="submit"
                                className="mt-2 w-full bg-red-500 text-white py-2 rounded-lg font-semibold shadow hover:bg-red-600 transition"
                            >
                                Presionar Enter ↵
                            </button>
                        </div>
                    </form>

                    <div className="flex-1 overflow-y-auto space-y-2 pr-1 custom-scrollbar">
                        {itemsIn.map((item, i) => (
                            <div key={i} className="bg-white p-3 rounded shadow-sm flex justify-between items-center border-l-4 border-red-400">
                                <div>
                                    <p className="font-bold text-sm text-gray-800">{item.nombre}</p>
                                    <p className="text-xs text-gray-500">{item.talle}</p>
                                </div>
                                <div className="text-right">
                                    <p className="font-bold text-red-600">$ {item.precio.toLocaleString()}</p>
                                </div>
                            </div>
                        ))}
                    </div>

                    <div className="mt-4 pt-4 border-t border-red-200 flex justify-between font-bold text-red-800 text-lg">
                        <span>Total Devolución:</span>
                        <span>$ {totalIn.toLocaleString()}</span>
                    </div>
                </div>

                {/* CENTRO: BALANCE */}
                <div className="w-64 flex flex-col justify-center items-center space-y-6 shrink-0 bg-white p-4 rounded-xl shadow-sm border border-gray-100">
                    <div className="text-center w-full">
                        <p className="text-gray-400 text-xs font-bold uppercase mb-2">Balance Operación</p>
                        <p className={`text-4xl font-black mb-2 ${balance > 0 ? 'text-green-600' : balance < 0 ? 'text-blue-600' : 'text-gray-400'}`}>
                            $ {Math.abs(balance).toLocaleString()}
                        </p>

                        <div className={`text-xs font-bold py-2 px-4 rounded-full inline-block w-full ${balance > 0
                            ? 'bg-green-100 text-green-800'
                            : balance < 0
                                ? 'bg-blue-100 text-blue-800'
                                : 'bg-gray-100 text-gray-500'
                            }`}>
                            {balance > 0
                                ? "CLIENTE PAGA DIFERENCIA"
                                : balance < 0
                                    ? "SE GENERA NOTA CRÉDITO"
                                    : "CAMBIO DIRECTO"}
                        </div>
                    </div>

                    <button
                        onClick={handleProcess}
                        disabled={itemsIn.length === 0 && itemsOut.length === 0}
                        className="w-full py-4 bg-slate-800 text-white rounded-xl font-bold hover:bg-black shadow-lg disabled:opacity-50 disabled:cursor-not-allowed transition-all active:scale-95"
                    >
                        CONFIRMAR CAMBIO
                    </button>
                </div>

                {/* DERECHA: SALE */}
                <div className="flex-1 bg-green-50 border-2 border-green-100 rounded-xl p-4 flex flex-col shadow-sm">
                    <h3 className="font-bold text-green-800 flex items-center mb-4 text-sm uppercase tracking-wider">
                        <CheckCircle className="mr-2" /> Nuevo Producto (Sale Stock)
                    </h3>

                    <form onSubmit={handleScanOut} className="mb-4">
                        <div className="relative">
                            <ScanBarcode className="absolute left-3 top-3 text-green-300" size={20} />
                            <input
                                className="w-full pl-10 p-3 rounded-lg border border-green-200 outline-none focus:ring-2 focus:ring-green-400 bg-white"
                                placeholder="Escanear producto nuevo..."
                                value={skuOut}
                                onChange={e => setSkuOut(e.target.value)}
                            />
                            <button
                                type="submit"
                                className="mt-2 w-full bg-green-500 text-white py-2 rounded-lg font-semibold shadow hover:bg-red-600 transition"
                            >
                                Presionar Enter ↵
                            </button>
                        </div>
                    </form>

                    <div className="flex-1 overflow-y-auto space-y-2 pr-1 custom-scrollbar">
                        {itemsOut.map((item, i) => (
                            <div key={i} className="bg-white p-3 rounded shadow-sm flex justify-between items-center border-l-4 border-green-400">
                                <div>
                                    <p className="font-bold text-sm text-gray-800">{item.nombre}</p>
                                    <p className="text-xs text-gray-500">{item.talle}</p>
                                </div>
                                <div className="text-right">
                                    <p className="font-bold text-green-600">$ {item.precio.toLocaleString()}</p>
                                </div>
                            </div>
                        ))}
                    </div>

                    <div className="mt-4 pt-4 border-t border-green-200 flex justify-between font-bold text-green-800 text-lg">
                        <span>Total Nuevo:</span>
                        <span>$ {totalOut.toLocaleString()}</span>
                    </div>
                </div>

            </div>
        </div>
    );
};

export default ReturnsPage;
