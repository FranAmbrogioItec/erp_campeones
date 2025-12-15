import { useEffect, useState } from 'react';
import axios from 'axios';
import { useAuth } from '../context/AuthContext';
import { Tags, Plus, Trash2, Edit2, Save, X, Layers } from 'lucide-react';
import toast, { Toaster } from 'react-hot-toast';
import { api } from '../context/AuthContext';

const CategoriesPage = () => {
    const { token } = useAuth();

    // Estados
    const [generalCats, setGeneralCats] = useState([]);
    const [specificCats, setSpecificCats] = useState([]);
    const [loading, setLoading] = useState(true);

    // Inputs para crear
    const [newGeneral, setNewGeneral] = useState('');
    const [newSpecific, setNewSpecific] = useState('');

    // Estado para edición { id: 1, type: 'general', value: 'Nombre' }
    const [editing, setEditing] = useState(null);

    // --- CARGA DE DATOS ---
    const fetchData = async () => {
        try {
            const config = { headers: { Authorization: `Bearer ${token}` } };
            const [resGen, resSpec] = await Promise.all([
                api.get('/products/categories', config),
                api.get('/products/specific-categories', config)
            ]);
            setGeneralCats(resGen.data);
            setSpecificCats(resSpec.data);
        } catch (e) { toast.error("Error cargando datos"); }
        finally { setLoading(false); }
    };

    useEffect(() => { if (token) fetchData(); }, [token]);

    // --- ACCIONES GENERALES ---
    const handleCreate = async (type) => {
        const isGeneral = type === 'general';
        const value = isGeneral ? newGeneral : newSpecific;
        const endpoint = isGeneral ? 'categories' : 'specific-categories';

        if (!value.trim()) return toast.error("El nombre no puede estar vacío");

        try {
            await api.post(`/products/${endpoint}`, { nombre: value }, { headers: { Authorization: `Bearer ${token}` } });
            toast.success("Creado correctamente");
            if (isGeneral) setNewGeneral(''); else setNewSpecific('');
            fetchData();
        } catch (e) { toast.error("Error al crear"); }
    };

    const handleDelete = async (id, type) => {
        if (!window.confirm("¿Seguro que deseas eliminar? Si hay productos usándola, fallará.")) return;
        const endpoint = type === 'general' ? 'categories' : 'specific-categories';

        try {
            await api.delete(`/products/${endpoint}/${id}`, { headers: { Authorization: `Bearer ${token}` } });
            toast.success("Eliminado");
            fetchData();
        } catch (e) { toast.error(e.response?.data?.msg || "No se puede eliminar (en uso)"); }
    };

    const handleUpdate = async () => {
        if (!editing || !editing.value.trim()) return;
        const endpoint = editing.type === 'general' ? 'categories' : 'specific-categories';

        try {
            await api.put(`/products/${endpoint}/${editing.id}`, { nombre: editing.value }, { headers: { Authorization: `Bearer ${token}` } });
            toast.success("Actualizado");
            setEditing(null);
            fetchData();
        } catch (e) { toast.error("Error al actualizar"); }
    };

    // --- RENDERIZADOR DE LISTA ---
    const renderList = (items, type) => (
        <div className="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
            <ul className="divide-y divide-gray-100">
                {items.map(item => (
                    <li key={item.id} className="p-4 flex justify-between items-center hover:bg-gray-50 group">
                        {editing?.id === item.id && editing?.type === type ? (
                            <div className="flex gap-2 flex-1 mr-4">
                                <input
                                    autoFocus
                                    className="border p-1 rounded w-full text-sm"
                                    value={editing.value}
                                    onChange={e => setEditing({ ...editing, value: e.target.value })}
                                />
                                <button onClick={handleUpdate} className="text-green-600 bg-green-100 p-1 rounded"><Save size={16} /></button>
                                <button onClick={() => setEditing(null)} className="text-gray-500 bg-gray-100 p-1 rounded"><X size={16} /></button>
                            </div>
                        ) : (
                            <span className="font-medium text-gray-700">{item.nombre}</span>
                        )}

                        {(!editing || editing.id !== item.id) && (
                            <div className="flex gap-2 opacity-0 group-hover:opacity-100 transition-opacity">
                                <button onClick={() => setEditing({ id: item.id, type, value: item.nombre })} className="text-blue-400 hover:text-blue-600 p-1"><Edit2 size={16} /></button>
                                <button onClick={() => handleDelete(item.id, type)} className="text-red-400 hover:text-red-600 p-1"><Trash2 size={16} /></button>
                            </div>
                        )}
                    </li>
                ))}
                {items.length === 0 && <li className="p-4 text-center text-gray-400 text-sm">Lista vacía.</li>}
            </ul>
        </div>
    );

    if (loading) return <div className="p-10">Cargando configuraciones...</div>;

    return (
        <div className="p-6 max-w-5xl mx-auto space-y-8">
            <Toaster position="top-center" />

            <div className="flex items-center">
                <div className="p-3 bg-purple-100 text-purple-600 rounded-full mr-4"><Tags size={32} /></div>
                <div>
                    <h1 className="text-2xl font-bold text-gray-800">Gestión de Categorías</h1>
                    <p className="text-gray-500 text-sm">Administra las etiquetas y ligas de tus productos.</p>
                </div>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-8">

                {/* PANEL 1: CATEGORÍAS GENERALES */}
                <div>
                    <div className="flex justify-between items-center mb-4">
                        <h2 className="text-lg font-bold text-gray-700 flex items-center"><Layers className="mr-2 text-blue-500" size={20} /> Categorías Generales</h2>
                    </div>

                    {/* Form Crear */}
                    <div className="flex gap-2 mb-4">
                        <input
                            placeholder="Nueva Categoría (Ej: Buzos)"
                            className="flex-1 border p-2 rounded-lg shadow-sm focus:ring-2 focus:ring-blue-500 outline-none"
                            value={newGeneral} onChange={e => setNewGeneral(e.target.value)}
                        />
                        <button onClick={() => handleCreate('general')} className="bg-blue-600 text-white p-2 rounded-lg hover:bg-blue-700 shadow"><Plus /></button>
                    </div>

                    {renderList(generalCats, 'general')}
                </div>

                {/* PANEL 2: LIGAS / ESPECÍFICAS */}
                <div>
                    <div className="flex justify-between items-center mb-4">
                        <h2 className="text-lg font-bold text-gray-700 flex items-center"><Tags className="mr-2 text-purple-500" size={20} /> Ligas / Específicas</h2>
                    </div>

                    {/* Form Crear */}
                    <div className="flex gap-2 mb-4">
                        <input
                            placeholder="Nueva Liga (Ej: Bundesliga)"
                            className="flex-1 border p-2 rounded-lg shadow-sm focus:ring-2 focus:ring-purple-500 outline-none"
                            value={newSpecific} onChange={e => setNewSpecific(e.target.value)}
                        />
                        <button onClick={() => handleCreate('specific')} className="bg-purple-600 text-white p-2 rounded-lg hover:bg-purple-700 shadow"><Plus /></button>
                    </div>

                    {renderList(specificCats, 'specific')}
                </div>

            </div>
        </div>
    );
};

export default CategoriesPage;