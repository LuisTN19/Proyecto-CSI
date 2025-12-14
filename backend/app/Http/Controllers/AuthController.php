<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
   
use Illuminate\Support\Facades\Auth;                                                // Portero
use Illuminate\Support\Facades\Hash;                                                // Encriptador

use App\Models\User; 

class AuthController extends Controller
{

    // LOGIN
    public function login(Request $request)
    {
        // El Portero (Auth) intenta entrar (attempt)
        if (!Auth::attempt($request->only('email', 'password'))) {
            return response()->json(['exito' => false], 401);;
        }

        // Si el portero dice OK, buscamos al usuario en la BD
        $user = User::where('email', $request->email)->firstOrFail();
        //$user = Auth::user();   //los guarda en la variable user

        // SANCTUM: Crea un token nuevo
        $token = $user->createToken('movil')->plainTextToken;

        return response()->json([
            'exito' => true,
            'usuario' => $user,
            'token' => $token
        ], 200);
    }



    // REGISTRO 
    public function register(Request $request)
    {
        $request->validate([
            'name' => 'required',
            'email' => 'required|email|unique:users',   //obligatorio| formato de correo | no este ya en la BD            
            'password' => 'required|min:8',             //LA CONTRASEÑAA DEBE TENER MINIMO 8 CARACTERES
        ]);

        $user = User::create([
            'name' => $request->name,
            'email' => $request->email,
            'password' => Hash::make($request->password),
        ]);

        $token = $user->createToken('movil')->plainTextToken;

        return response()->json([
            'exito' => true,
            'usuario' => $user,
            'token' => $token
        ], 201);
    }

    
}
