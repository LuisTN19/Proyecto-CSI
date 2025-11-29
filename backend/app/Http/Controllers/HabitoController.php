<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Habito;

use Carbon\Carbon; //para q cuando cambie de dia el hábito se ponga en por hacer


class HabitoController extends Controller
{
    // GET
    public function index(Request $request)
    {
        $userId = $request->user()->id;

        // --- LA MAGIA DEL RESETEO ---
        // 1. Buscamos hábitos de este usuario que:
        //    - Estén completados (true)
        //    - Y su fecha de actualización sea MENOR a hoy (es decir, ayer o antes)
        Habito::where('user_id', $userId)
            ->where('completado', true)
            ->whereDate('updated_at', '<', Carbon::today()) // Si la fecha es vieja...
            ->update(['completado' => false]); // ... ¡PUM! Los reseteamos a false.
        // ----------------------------

        // 2. Ahora devolvemos la lista (que ya estará limpia)
        return Habito::where('user_id', $userId)->get();
    }

    // POST
    public function store(Request $request)
    {
        $request->validate(['nombre' => 'required']);

        $habito = Habito::create([
            'nombre' => $request->nombre,
            'completado' => false,
            // --- ¡ESTA ES LA LÍNEA QUE TE FALTA! ---
            'user_id' => $request->user()->id, // Guardamos TU id
        ]);

        return response()->json($habito, 201);
    }

    // PUT
    public function update(Request $request, $id)
    {
        $habito = Habito::find($id);
        
        // Verificamos que el hábito sea del usuario que lo pide
        if ($habito && $habito->user_id == $request->user()->id) {
            
            // Actualizamos forzando a booleano (true/false)
            $habito->completado = filter_var($request->completado, FILTER_VALIDATE_BOOLEAN);
            $habito->save();

            return response()->json($habito, 200);
        }

        return response()->json(['error' => 'No encontrado o no autorizado'], 404);
    }

    // DELETE
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
