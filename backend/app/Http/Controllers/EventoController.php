<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

use App\Models\Evento;

class EventoController extends Controller
{
    public function index(Request $request)
    {
        
        $userId = $request->user()->id; 

        $events = Evento::where('user_id', $userId) 
                       ->orderBy('fecha', 'asc') 
                       ->get(); 
        
        return response()->json($events);
    }

    
    public function store(Request $request)
    {
        $request->validate([
            'titulo' => 'required|string|max:255', 
            'fecha' => 'required|date',            
        ]);

        $event = Evento::create([
            'titulo' => $request->titulo,
            'fecha' => $request->fecha,
            'user_id' => $request->user()->id, 
        ]);

        return response()->json($event, 201);
    }
}
