<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Habito;

class HabitoController extends Controller
{
    // 1. VER TODOS (GET)
    public function index()
    {
        return Habito::all();
    }

    // 2. CREAR UNO NUEVO (POST)
    public function store(Request $request)
    {
        $request->validate(['nombre' => 'required']);
        $habito = Habito::create([
            'nombre' => $request->nombre,
            'completado' => false,
        ]);
        return response()->json($habito, 201);
    }

    // 3. MARCAR/DESMARCAR (PUT)
    public function update(Request $request, $id)
    {
        $habito = Habito::find($id);
        
        if ($habito) {
            $habito->completado = $request->completado;
            $habito->save();
            return response()->json($habito, 200);
        }
        return response()->json(['error' => 'No encontrado'], 404);
    }

    public function destroy($id)
    {
        $habito = Habito::find($id);

        if ($habito) {
            $habito->delete();
            return response()->json(['mensaje' => 'Hábito borrado correctamente'], 200);
        }
        return response()->json(['error' => 'No encontrado'], 404);
    }
}
