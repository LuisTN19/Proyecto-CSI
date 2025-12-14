<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

use App\Models\IngredienteCesta;

class IngredienteCestaController extends Controller
{
    public function index(Request $request)
    {
        $userId = $request->user()->id; 

        $items = IngredienteCesta::where('user_id', $userId)->get(); 
        
        return response()->json($items);
    }

    public function store(Request $request)
    {
        $request->validate([
            'nombre' => 'required|string|max:255',
        ]);

        $item = IngredienteCesta::create([
            'nombre' => $request->nombre,
            'user_id' => $request->user()->id, 
        ]);

        return response()->json($item, 201);
    }

    public function destroy($id)
    {
        $item = IngredienteCesta::find($id);

        if ($item) {
            $item->delete();
            return response()->json(['mensaje' => 'Ítem borrado correctamente'], 200);
        }
        
        return response()->json(['error' => 'No encontrado'], 404);
    }
}
