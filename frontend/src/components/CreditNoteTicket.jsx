import React from 'react';

export const CreditNoteTicket = React.forwardRef(({ data }, ref) => {

  const safeData = data || {
    codigo: "----",
    monto: 0,
    fecha: new Date().toLocaleString()
  };

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
            .cn-ticket-content, .cn-ticket-content * { visibility: visible; }
            .cn-ticket-content { 
              position: absolute; 
              left: 0; 
              top: 0; 
              width: 100%; 
            }
          }
        `}
      </style>

      <div className="cn-ticket-content flex flex-col items-center text-center pb-8">
        
        <h1 className="text-xl font-black uppercase mb-1">CAMPEONES</h1>
        <p className="text-[10px] uppercase mb-4">Indumentaria Deportiva</p>

        <div className="w-full border-b border-black border-dashed mb-4"></div>

        <h2 className="text-lg font-bold uppercase mb-2">NOTA DE CRÉDITO</h2>
        <p className="mb-4">Fecha: {safeData.fecha}</p>

        <div className="border-2 border-black p-2 mb-4 w-full">
          <p className="text-[10px] uppercase mb-1">Código de Canje</p>
          <p className="text-2xl font-black tracking-widest">{safeData.codigo}</p>
        </div>

        <div className="w-full flex justify-between text-lg font-bold mb-4">
          <span>SALDO A FAVOR:</span>
          <span>$ {parseFloat(safeData.monto).toLocaleString()}</span>
        </div>

        <div className="w-full border-b border-black border-dashed mb-2"></div>

        <p className="mb-1 text-[10px]">Presente este comprobante en su próxima compra.</p>
        <p className="text-[10px] font-bold">Válido por 30 días.</p>
      </div>
    </div>
  );
});

CreditNoteTicket.displayName = 'CreditNoteTicket';
export default CreditNoteTicket;
