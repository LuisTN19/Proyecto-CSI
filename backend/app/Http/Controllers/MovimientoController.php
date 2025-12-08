<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

use Carbon\Carbon;
use Illuminate\Support\Facades\DB;

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


    public function resumen(Request $request)
    {
        $userId = $request->user()->id;

        $resumenMensual = Movimiento::select(
            DB::raw('YEAR(fecha) as anno'), 
            DB::raw('MONTH(fecha) as mes'),
            DB::raw('SUM(CASE WHEN es_gasto = 0 THEN cantidad ELSE 0 END) as total_ingresos'),
            DB::raw('SUM(CASE WHEN es_gasto = 1 THEN cantidad ELSE 0 END) as total_gastos')
        )
        ->where('user_id', $userId) 
        ->groupBy(DB::raw('YEAR(fecha)'), DB::raw('MONTH(fecha)')) 
        ->orderBy('anno', 'desc')
        ->orderBy('mes', 'desc')
        ->get();

        return $resumenMensual;
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
