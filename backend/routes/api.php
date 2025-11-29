<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

use App\Http\Controllers\AuthController;
use App\Http\Controllers\HabitoController;

//RUTAS PÚBLICAS
Route::post('/login', [AuthController::class, 'login']);
Route::post('/registro', [AuthController::class, 'register']);


//RUTAS PRIVADAS (Necesitan Token)
//Sanctum es el motor que hay debajo funcionando para que los Tokens existan y funcionen, PAQUETE que venía con laravel ya
Route::middleware('auth:sanctum')->group(function () {  //si abres esta ruta me tienes que enseñar la llave
    
    Route::get('/user', function (Request $request) {
        return $request->user();
    });

    Route::get('/habitos', [HabitoController::class, 'index']);
    Route::post('/habitos', [HabitoController::class, 'store']);
    Route::put('/habitos/{id}', [HabitoController::class, 'update']);
    Route::delete('/habitos/{id}', [HabitoController::class, 'destroy']);

});
