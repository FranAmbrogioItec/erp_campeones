import { createContext, useState, useEffect, useContext } from 'react';
import axios from 'axios';
import { jwtDecode } from "jwt-decode";

const AuthContext = createContext();

// Creamos una instancia de axios con la baseURL configurada
const baseURL = import.meta.env.VITE_API_URL || 'http://localhost:5000/api';

export const api = axios.create({
  baseURL: baseURL,
});

export const AuthProvider = ({ children }) => {
  const [user, setUser] = useState(null);
  const [token, setToken] = useState(localStorage.getItem('token') || '');
  const [loading, setLoading] = useState(true);

  // Interceptor: Cada vez que axios haga una petición, inyecta el token
  api.interceptors.request.use((config) => {
    const savedToken = localStorage.getItem('token');
    if (savedToken) {
      config.headers.Authorization = `Bearer ${savedToken}`;
    }
    return config;
  });

  // Verificar sesión al cargar la app
  useEffect(() => {
    const savedToken = localStorage.getItem('token');
    if (savedToken) {
      try {
        const decoded = jwtDecode(savedToken);
        // Opcional: Verificar expiración aquí
        setUser({
          id: decoded.sub,
          rol: decoded.rol,
          nombre: decoded.nombre
        });
      } catch (error) {
        logout();
      }
    }
    setLoading(false);
  }, []);

  const login = async (email, password) => {
    try {
      const res = await api.post('/auth/login', { email, password });

      const newToken = res.data.access_token;
      localStorage.setItem('token', newToken);
      setToken(newToken);

      // Decodificamos el token para actualizar el estado del usuario inmediatamente
      const decoded = jwtDecode(newToken);
      setUser({
        id: decoded.sub,
        rol: decoded.rol,
        nombre: decoded.nombre
      });

      return { success: true };
    } catch (error) {
      return {
        success: false,
        message: error.response?.data?.msg || "Error de conexión"
      };
    }
  };

  const logout = () => {
    localStorage.removeItem('token');
    setToken('');
    setUser(null);
  };

  return (
    <AuthContext.Provider value={{ user, login, logout, loading, token }}>
      {!loading && children}
    </AuthContext.Provider>
  );
};

// Hook personalizado para usar el contexto más fácil
export const useAuth = () => useContext(AuthContext);