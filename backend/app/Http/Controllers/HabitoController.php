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

        Habito::where('user_id', $userId)       //desmarcar los habitos en completados del dia anterior
            ->where('esCompletado', true)
            ->whereDate('updated_at', '<', Carbon::today()) 
            ->update(['esCompletado' => false]); 

        return Habito::where('user_id', $userId)->get(); //PHP -> SQL | COGE LOS REGISTROS DE LA BD y los transforma en una lista de objetos PHP | con el return los envia en json
    }


    // POST
    public function store(Request $request)
    {
        $request->validate(['nombre' => 'required|string|max:32']);

        $habito = Habito::create([
            //el id lo pone solo -> autoincremental
            'nombre' => $request->nombre,
            'esCompletado' => false,
            'user_id' => $request->user()->id, 
        ]);

        return response()->json($habito, 201);  //devolvemos el objeto entero por estandar, pero flutter solo se fijara en el statuscode
    }


    // PUT
    public function update(Request $request, $id)
    {
        $habito = Habito::find($id);
        
        if ($habito && $habito->user_id == $request->user()->id) {
            $habito->esCompletado = filter_var($request->esCompletado, FILTER_VALIDATE_BOOLEAN);    //convertirlo a true o false (BOOL) para q no haya conflicto dependiendo de como venga el dato ("true",1, ...) en nuestro caso se lo apsamos como 0/1
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
