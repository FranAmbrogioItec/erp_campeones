import { Navigate, Outlet } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';

const ProtectedRoute = () => {
  const { user, loading } = useAuth();

  // 1. Mientras verificamos el token, mostramos un "Cargando..."
  if (loading) return <div className="p-10 text-center">Cargando sistema...</div>;

  // 2. Si terminó de cargar y no hay usuario, patada al Login
  if (!user) return <Navigate to="/login" replace />;

  // 3. Si hay usuario, deja pasar a las rutas hijas (Outlet)
  return <Outlet />;
};

export default ProtectedRoute;