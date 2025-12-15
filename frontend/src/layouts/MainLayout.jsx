import { Outlet } from 'react-router-dom';
import Sidebar from '../components/Sidebar';

const MainLayout = () => {
  return (
    <div className="flex h-screen bg-gray-100 overflow-hidden">
      {/* Sidebar Fijo */}
      <Sidebar />

      {/* Área de Contenido Dinámico */}
      <main className="flex-1 overflow-y-auto p-8">
        {/* Aquí se renderizarán las páginas hijas (Dashboard, Productos, etc.) */}
        <Outlet />
      </main>
    </div>
  );
};

export default MainLayout;