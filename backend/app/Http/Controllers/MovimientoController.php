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

        $movimiento = Movimiento::create([
            'nombre'     => $request->nombre,
            'cantidad'   => $request->cantidad,
            'fecha'      => $request->fecha,
            'es_gasto'   => $request->es_gasto,
            'user_id'    => $request->user()->id, 
        ]);
        return response()->json($movimiento, 201); 
    }

        public function destroy($id)
    {
        $movimiento = Movimiento::find($id);

        if ($movimiento) {
            $movimiento->delete();
            return response()->json(['mensaje' => 'Evento borrado correctamente'], 200);
        }
        return response()->json(['error' => 'No encontrado'], 404);
    }
}
