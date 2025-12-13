<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

use App\Models\Plato;

class PlatoController extends Controller
{
    public function index(Request $request)
    {
        return Plato::where('user_id', $request->user()->id)->get(); //por el cast pasa los ingredientes automáticamente a array php y en el return se convierte a json
    }

    // --------------------------------------------------------------------------------------------------------------------------------------------------------------

    public function store(Request $request)
    {
        $request->validate([
            'nombre' => 'required|string',
            //'ingredientes' => 'array',    Ahora esperamos un STRING (formato JSON), no un array directo, como hemos cambiado a Multipart, ahora Flutter envía los ingredientes "empaquetados" como Texto (JSON)
            'ingredientes' => 'nullable|string',
            'imagen' => 'nullable|image',
        ]);

        $datos = $request->all();   //hoja en sucio, vamos a modificar cosas aquí antes de guardarlas definitivamente

        //Ingredientes
        if ($request->has('ingredientes') && is_string($request->ingredientes)) { //multipart lo envia todo como texto y queremos lista. ANTES sin esto lo enviabamos todo como un bloque JSON (Content-Type: application/json), y laravel solo con esto $request->ingredientes ya lo ponia todo en php
            $datos['ingredientes'] = json_decode($request->ingredientes, true); //lo convertimos ahora si a array PHP con el json_decode -> ['Pollo', 'Arroz']
                                                                                //si no lo convirtieramos a array primero, por la propiedad del casts tendría q convertir lo q viene de ingredientes a json, puesto que cree que todo es un array como definimos en el contrato, y tendriamos un string dentro de un string: "\"['Pollo', 'Sal']\""
        }

        //Foto
        if ($request->hasFile('imagen')) {
            $path = $request->file('imagen')->store('platos', 'public'); //genera un hash unico como nombre y lo guarda en el disco duro de tu servidor, dentro de la carpeta storage/app/public/platos.
            $datos['imagenUrl'] = asset('storage/' . $path); //la base de datos no quiere saber dónde está el archivo en el disco duro, quiere saber la dirección web para que el móvil pueda descargarla, asset() convierte la ruta relativa en una URL completa accesible desde internet: Entra: storage/platos/foto.jpg Sale: http://192.168.1.170:8000/storage/platos/foto.jpg//la base de datos no quiere saber dónde está el archivo en el disco duro, quiere saber la dirección web para que el móvil pueda descargarla, asset() convierte la ruta relativa en una URL completa accesible desde internet: Entra: storage/platos/foto.jpg Sale: http://10.0.2.2:8000/storage/platos/foto.jpg
        } else {
            $datos['imagenUrl'] = null;
        }


        $plato = Plato::create([ //Antes de crearlo y guaradar en la BD -> ORM -> 'ingredientes' => 'array' (CASTS), laravel lo vuelve a pasar a json solo
            'user_id' => $request->user()->id,
            'nombre' => $request->nombre,
            'descripcion' => $request->descripcion,
            'ingredientes' => $datos['ingredientes'], // Usamos el dato corregido
            'imagenUrl' => $datos['imagenUrl'],     // Usamos la URL generada
            'tiempo' => $request->tiempo,
            'calorias' => $request->calorias,
            'estrellas' => $request->estrellas ?? 0,
            'esFavorito' => false,
        ]);

        return response()->json($plato, 201); //Como por internet no pasan Arrays PHP, Laravel convierte todo a Texto JSON.
    }

    //---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    public function update(Request $request, $id)
    {
        $datos = $request->all();           //en el caso de putFAV solo vendrá con un json pequeñito: {"esFavorito": true}

        if ($request->has('ingredientes') && is_string($request->ingredientes)) {
            $datos['ingredientes'] = json_decode($request->ingredientes, true);
        }

        if ($request->hasFile('imagen')) {
             $path = $request->file('imagen')->store('platos', 'public');
             $datos['imagenUrl'] = asset('storage/' . $path);
        }

        $plato = Plato::find($id);

        if (!$plato) {
            return response()->json(['error' => 'No encontrado'], 404);
        }
        if ($plato->user_id !== $request->user()->id) {
            return response()->json(['error' => 'No autorizado'], 403);
        }

        /*$plato->update($request->all());          Al usar $request->all() al final, Laravel ignoraba tu variable $datos.Guardaba los ingredientes como texto "['A','B']" (rompiendo la app).No guardaba la URL de la imagen (porque esa URL solo existía dentro de $datos).Con este cambio ($plato->update($datos)), guardas la versión "cocinada" y correcta.*/
        $plato->update($datos);
        return response()->json($plato);
    }

    //----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    public function destroy($id)
    {
        $plato = Plato::find($id);

        if ($plato) {
            $plato->delete();
            return response()->json(['mensaje' => 'Plato borrado correctamente'], 200);
        }
        return response()->json(['error' => 'No encontrado'], 404);
    }


}
