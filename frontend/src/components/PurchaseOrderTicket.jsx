import React from 'react';

export const PurchaseOrderTicket = React.forwardRef(({ data }, ref) => {
    if (!data) return null;

    return (
        <div ref={ref} className="p-4 bg-white text-black font-mono text-xs leading-tight" style={{ width: '80mm', margin: '0 auto' }}>
            <style>
                {`
          @media print {
            @page { margin: 0; size: auto; }
            body * { visibility: hidden; }
            #po-content, #po-content * { visibility: visible; }
            #po-content { position: absolute; left: 0; top: 0; width: 100%; }
          }
        `}
            </style>

            <div id="po-content" className="flex flex-col items-center text-center pb-8">
                <h1 className="text-xl font-black uppercase mb-1">INGRESO DE STOCK</h1>
                <p className="text-[10px] uppercase mb-4">Comprobante Interno</p>

                <div className="w-full border-b border-black border-dashed mb-2"></div>

                <div className="w-full text-left mb-2">
                    <p>ID Compra: #{data.id}</p>
                    <p>Fecha: {data.fecha}</p>
                    <p>Proveedor: {data.proveedor}</p>
                </div>

                <div className="w-full border-b border-black border-dashed mb-2"></div>

                <table className="w-full text-left mb-2">
                    <thead>
                        <tr className="uppercase">
                            <th className="w-1/2 pb-1">Articulo</th>
                            <th className="w-1/4 pb-1 text-right">Cant</th>
                            <th className="w-1/4 pb-1 text-right">Costo</th>
                        </tr>
                    </thead>
                    <tbody>
                        {data.items_detail?.map((item, i) => (
                            <tr key={i}>
                                <td className="py-1 pr-1 truncate max-w-[120px]">
                                    {item.nombre} <br /> <span className="text-[10px]">T: {item.talle}</span>
                                </td>
                                <td className="py-1 text-right align-top">{item.cantidad}</td>
                                <td className="py-1 text-right align-top">$ {item.costo.toLocaleString()}</td>
                            </tr>
                        ))}
                    </tbody>
                </table>

                <div className="w-full border-b border-black border-dashed mb-2"></div>

                <div className="w-full flex justify-between text-lg font-bold mb-4">
                    <span>TOTAL COMPRA</span>
                    <span>$ {data.total.toLocaleString()}</span>
                </div>

                <p className="text-[10px] italic">Documento de control interno.</p>
            </div>
        </div>
    );
});

PurchaseOrderTicket.displayName = 'PurchaseOrderTicket';
export default PurchaseOrderTicket;