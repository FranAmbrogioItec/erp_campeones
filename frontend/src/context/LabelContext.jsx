import { createContext, useState, useContext, useEffect } from 'react';
import toast from 'react-hot-toast';

const LabelContext = createContext();

export const LabelProvider = ({ children }) => {
  // Intentamos cargar del localStorage para no perder la lista si refresca
  const [printQueue, setPrintQueue] = useState(() => {
      const saved = localStorage.getItem('printQueue');
      return saved ? JSON.parse(saved) : [];
  });

  useEffect(() => {
      localStorage.setItem('printQueue', JSON.stringify(printQueue));
  }, [printQueue]);

  const addToQueue = (product, variant) => {
      setPrintQueue(prev => {
          // Si ya existe ese SKU, no lo duplicamos, avisamos
          const exists = prev.find(p => p.sku === (variant.sku || `GEN-${variant.id_variante}`));
          if (exists) {
              toast("Este artículo ya está en la cola de impresión", { icon: '⚠️' });
              return prev;
          }
          
          toast.success("Agregado a cola de etiquetas");
          return [...prev, {
              sku: variant.sku || `GEN-${variant.id_variante}`,
              nombre: product.nombre,
              talle: variant.talle,
              precio: product.precio,
              cantidad: 1 // Empieza con 1 etiqueta por defecto
          }];
      });
  };

  const updateQuantity = (sku, qty) => {
      setPrintQueue(prev => prev.map(item => item.sku === sku ? { ...item, cantidad: parseInt(qty) || 1 } : item));
  };

  const removeFromQueue = (sku) => {
      setPrintQueue(prev => prev.filter(item => item.sku !== sku));
  };

  const clearQueue = () => setPrintQueue([]);

  return (
    <LabelContext.Provider value={{ printQueue, addToQueue, updateQuantity, removeFromQueue, clearQueue }}>
      {children}
    </LabelContext.Provider>
  );
};

export const useLabelQueue = () => useContext(LabelContext);