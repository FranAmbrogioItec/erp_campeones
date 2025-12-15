import React from 'react';

export const Ticket = React.forwardRef(({ saleData }, ref) => {
  const empty = !saleData;

  const { items = [], total = 0, fecha = "", id_venta = "", cliente = "" } = saleData || {};

  return (
    <div
      ref={ref}
      className="p-4 bg-white text-black font-mono text-xs leading-tight"
      style={{ width: '80mm', margin: '0 auto' }}
    >
      <style>
        {`
          @media print {
            @page { margin: 0; size: auto; }
            body * { visibility: hidden; }
            .ticket-content, .ticket-content * { visibility: visible; }
            .ticket-content { position: absolute; left: 0; top: 0; width: 100%; }
          }
        `}
      </style>

      <div className="ticket-content flex flex-col items-center text-center pb-8">

        <h1 className="text-xl font-black uppercase mb-1">CAMPEONES</h1>
        <p className="text-[10px] uppercase mb-4">Indumentaria & Merchandising</p>

        <div className="w-full border-b border-black border-dashed mb-2"></div>

        {!empty && (
          <>
            <div className="w-full text-left mb-2">
              <p>Fecha: {fecha}</p>
              <p>Ticket #: {id_venta}</p>
              <p>Cliente: {cliente}</p>
            </div>

            <div className="w-full border-b border-black border-dashed mb-2"></div>

            <table className="w-full text-left mb-2">
              <thead>
                <tr className="uppercase">
                  <th className="w-1/2 pb-1">Prod</th>
                  <th className="w-1/4 pb-1 text-right">Cant</th>
                  <th className="w-1/4 pb-1 text-right">$$</th>
                </tr>
              </thead>
              <tbody>
                {items.map((item, i) => (
                  <tr key={i}>
                    <td className="py-1 pr-1 truncate max-w-[120px]">
                      {item.nombre}
                      <br />
                      <span className="text-[10px]">{item.talle}</span>
                    </td>
                    <td className="py-1 text-right align-top">{item.cantidad}</td>
                    <td className="py-1 text-right align-top">
                      $ {item.subtotal?.toLocaleString()}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>

            <div className="w-full border-b border-black border-dashed mb-2"></div>

            <div className="w-full flex justify-between text-lg font-bold mb-4">
              <span>TOTAL</span>
              <span>$ {parseFloat(total).toLocaleString()}</span>
            </div>
          </>
        )}

        <p className="mb-1">¡Gracias por tu compra!</p>
        <p className="mt-2 text-[10px]">Documento no valido como factura.</p>
        <p className="mt-2 text-[10px]">www.campeonesindumentaria.com.ar</p>
        <p className="mt-2 text-[10px] font-bold text-transform: uppercase">No se aceptan cambios sin etiqueta.</p>


      </div>
    </div>
  );
});

Ticket.displayName = 'Ticket';

export default Ticket;
