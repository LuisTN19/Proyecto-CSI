<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

use App\Http\Controllers\AuthController;
use App\Http\Controllers\HabitoController;
use App\Http\Controllers\EventoController;
use App\Http\Controllers\MovimientoController;
use App\Http\Controllers\PlatoController;
use App\Models\Evento;

//RUTAS PÚBLICAS
Route::post('/login', [AuthController::class, 'login']);
Route::post('/registro', [AuthController::class, 'register']);


//RUTAS PRIVADAS (Necesitan Token)
//Sanctum es el motor que hay debajo funcionando para que los Tokens existan y funcionen, PAQUETE que venía con laravel ya
Route::middleware('auth:sanctum')->group(function () {  //si abres esta ruta me tienes que enseñar la llave
    
    Route::get('/user', function (Request $request) {
        return $request->user();
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

    Route::get('/habitos', [HabitoController::class, 'index']);
    Route::post('/habitos', [HabitoController::class, 'store']);
    Route::put('/habitos/{id}', [HabitoController::class, 'update']);
    Route::delete('/habitos/{id}', [HabitoController::class, 'destroy']);

});
