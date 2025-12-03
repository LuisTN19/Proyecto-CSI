<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

use App\Models\Plato;

class PlatoController extends Controller
{
    public function index(Request $request)
    {
        //return $request->user()->platos;   lo dejaba en blanco la lista
        return Plato::where('user_id', $request->user()->id)->get();
    }

    // 2. CREAR PLATO
    public function store(Request $request)
    {
        $request->validate([
            'nombre' => 'required|string',
            'ingredientes' => 'array',
        ]);

        $plato = Plato::create([
            'user_id' => $request->user()->id,
            'nombre' => $request->nombre,
            'descripcion' => $request->descripcion,
            'imagen_url' => $request->imagen_url,
            'ingredientes' => $request->ingredientes, // Laravel lo pasa a JSON solo
            'tiempo' => $request->tiempo,
            'calorias' => $request->calorias,
            'calificacion' => $request->calificacion ?? 0,
            'favorito' => false,
        ]);

        return response()->json($plato, 201);
    }

    // 3. ACTUALIZAR (Para el Favorito o editar datos)
    public function update(Request $request, Plato $plato)
    {
        // Seguridad: Solo el dueño puede editar
        if ($plato->user_id !== $request->user()->id) {
            return response()->json(['error' => 'No autorizado'], 403);
        }

        $plato->update($request->all());

        return response()->json($plato);
    }
}
