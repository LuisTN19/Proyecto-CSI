<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

use App\Http\Controllers\AuthController;
use App\Http\Controllers\HabitoController;
use App\Http\Controllers\EventoController;
use App\Http\Controllers\MovimientoController;
use App\Http\Controllers\PlatoController;
use App\Http\Controllers\CestaItemController;
use Illuminate\Support\Facades\Password; //para recuperar la contraseña


//RUTAS PÚBLICAS
Route::post('/login', [AuthController::class, 'login']);
Route::post('/registro', [AuthController::class, 'register']);


//RUTAS PRIVADAS (Necesitan Token)
//Sanctum es el motor que hay debajo funcionando para que los Tokens existan y funcionen, PAQUETE que venía con laravel ya
Route::middleware('auth:sanctum')->group(function () {  //si abres esta ruta me tienes que enseñar la llave
    
    Route::get('/user', function (Request $request) {
        return $request->user();        //Al validar el token, Sanctum busca a qué usuario pertenece y lo "inyecta" dentro de la variable $request.
    });

    Route::get('/movimientos', [MovimientoController::class, 'index']);
    Route::post('/movimientos', [MovimientoController::class, 'store']);
    Route::delete('/movimientos/{id}', [MovimientoController::class, 'destroy']);
    Route::get('/movimientos/resumen', [MovimientoController::class, 'resumen']);

    Route::get('/eventos', [EventoController::class, 'index']);
    Route::post('/eventos', [EventoController::class, 'store']);
    Route::delete('/eventos/{id}', [EventoController::class, 'destroy']);

    Route::get('/platos', [PlatoController::class, 'index']);        
    Route::post('/platos', [PlatoController::class, 'store']);       
    Route::put('/platos/{id}', [PlatoController::class, 'update']);
    Route::delete('/platos/{id}', [PlatoController::class, 'destroy']);

    Route::get('/cesta', [CestaItemController::class, 'index']);      
    Route::post('/cesta', [CestaItemController::class, 'store']);     
    Route::delete('/cesta/{id}', [CestaItemController::class, 'destroy']);

    Route::get('/habitos', [HabitoController::class, 'index']);
    Route::post('/habitos', [HabitoController::class, 'store']);
    Route::put('/habitos/{id}', [HabitoController::class, 'update']);
    Route::delete('/habitos/{id}', [HabitoController::class, 'destroy']);

});


Route::post('/cambiar-contraseña', function (Request $request) {
    
    $request->validate(['email' => 'required|email']); // Validar email

    // Buscamos al usuario manualmente primero
    $user = \App\Models\User::where('email', $request->email)->first();     //Si un hacker intenta poner en el campo de email algo como: ' OR 1=1 --, Laravel lo enviará como texto puro, no como código. La base de datos buscará literalmente un usuario cuyo email sea la frase "pepe' OR 1=1 --", no encontrará nada, y no pasará nada.

    // Si no existe o NO SE HA VERIFICADO EL CORREO -> ERROR
    if (! $user || ! $user->hasVerifiedEmail()) {
        return response()->json(['message' => 'El correo no existe o no está verificado.'], 400);
    }
    
    $status = Password::sendResetLink($request->only('email')); // Enviar enlace

    if ($status === Password::RESET_LINK_SENT) {    // Responder a Flutter
        return response()->json(['message' => 'Correo enviado']);
    }

    return response()->json(['message' => 'Error al enviar'], 400);
});
