<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use App\Models\User;

// 1. REGISTRO
Route::post('/registro', function (Request $request) {
    $request->validate([
        'name' => 'required',
        'email' => 'required|email|unique:users',
        'password' => 'required|min:4',
    ]);

    $user = User::create([
        'name' => $request->name,
        'email' => $request->email,
        'password' => Hash::make($request->password),
    ]);

    return response()->json(['exito' => true, 'usuario' => $user], 201);
});

// 2. LOGIN
Route::post('/login', function (Request $request) {
    $credentials = $request->only('email', 'password');

    if (Auth::attempt($credentials)) {
        return response()->json(['exito' => true, 'usuario' => Auth::user()], 200);
    }

    return response()->json(['exito' => false, 'mensaje' => 'Error'], 401);
});




Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');
