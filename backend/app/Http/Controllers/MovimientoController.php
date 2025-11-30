<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

use App\Models\Movimiento;

class MovimientoController extends Controller
{
    public function index(Request $request)
    {
        $userId = $request->user()->id;

        return Movimiento::where('user_id', $userId)
                         ->orderBy('fecha', 'desc') // Ordenar es una buena práctica para listas
                         ->get();
    }

    public function store(Request $request)
    {
        $request->validate([
            'nombre'     => 'required|string|max:150',
            'cantidad'   => 'required|numeric|min:0', 
            'fecha'      => 'required|date_format:Y-m-d', // Formato de fecha esperado: YYYY-MM-DD
            'es_gasto'   => 'required|boolean', 
        ]);

        // 2. Creación y asignación de valores
        $movimiento = Movimiento::create([
            'nombre'     => $request->nombre,
            'cantidad'   => $request->cantidad,
            'fecha'      => $request->fecha,
            'es_gasto'   => $request->es_gasto,
            
            // 💡 Asignación del usuario autenticado (igual que en Hábitos)
            'user_id'    => $request->user()->id, 
        ]);

        // 3. Respuesta a Flutter
        return response()->json($movimiento, 201); // 201 Created
    }
}
