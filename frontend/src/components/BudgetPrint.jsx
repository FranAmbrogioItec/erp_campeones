import React from 'react';

const BudgetPrint = React.forwardRef(({ data }, ref) => {
    if (!data) return null;

    return (
        <div ref={ref} className="p-8 max-w-3xl mx-auto bg-white text-black font-sans">
            {/* Encabezado */}
            <div className="flex justify-between items-center border-b pb-4 mb-6">
                <div>
                    <h1 className="text-3xl font-bold uppercase tracking-wide">Presupuesto</h1>
                    <p className="text-sm text-gray-500 mt-1">NO VÁLIDO COMO FACTURA</p>
                </div>
                <div className="text-right">
                    <h2 className="font-bold text-xl">#{data.id}</h2>
                    <p className="text-gray-600">{new Date().toLocaleDateString()}</p>
                </div>
            </div>

            {/* Datos Cliente y Empresa */}
            <div className="flex justify-between mb-8">
                <div>
                    <p className="font-bold text-gray-400 text-xs uppercase">Cliente</p>
                    <p className="font-bold text-lg">{data.cliente}</p>
                </div>
                <div className="text-right">
                    <p className="font-bold text-gray-400 text-xs uppercase">Emisor</p>
                    <p className="font-bold">Campeones Indumentaria</p>
                </div>
            </div>

            {/* Tabla */}
            <table className="w-full text-sm mb-6">
                <thead>
                    <tr className="border-b-2 border-black">
                        <th className="text-left py-2">Cant.</th>
                        <th className="text-left py-2">Descripción</th>
                        <th className="text-right py-2">Precio Unit.</th>
                        <th className="text-right py-2">Subtotal</th>
                    </tr>
                </thead>
                <tbody>
                    {data.items.map((item, index) => (
                        <tr key={index} className="border-b border-gray-200">
                            <td className="py-2 font-bold">{item.cantidad}</td>
                            <td className="py-2">
                                <span className="font-bold block">{item.nombre}</span>
                                <span className="text-xs text-gray-500">Talle: {item.talle}</span>
                            </td>
                            <td className="py-2 text-right">$ {item.precio.toLocaleString()}</td>
                            <td className="py-2 text-right">$ {item.subtotal.toLocaleString()}</td>
                        </tr>
                    ))}
                </tbody>
            </table>

            {/* Totales */}
            <div className="flex justify-end">
                <div className="w-1/2">
                    <div className="flex justify-between py-1">
                        <span className="text-gray-600">Subtotal:</span>
                        <span className="font-bold">$ {data.subtotal.toLocaleString()}</span>
                    </div>
                    {data.descuento > 0 && (
                        <div className="flex justify-between py-1 text-green-700">
                            <span>Descuento ({data.descuento}%):</span>
                            <span>- $ {data.monto_descuento.toLocaleString()}</span>
                        </div>
                    )}
                    <div className="flex justify-between py-2 border-t-2 border-black mt-2 text-xl">
                        <span className="font-black">TOTAL:</span>
                        <span className="font-black">$ {data.total.toLocaleString()}</span>
                    </div>
                </div>
            </div>

            <div className="mt-12 pt-4 border-t text-center text-xs text-gray-400">
                <p>Este presupuesto tiene una validez de 7 días.</p>
                <p>Gracias por su consulta.</p>
            </div>
        </div>
    );
});

export default BudgetPrint;