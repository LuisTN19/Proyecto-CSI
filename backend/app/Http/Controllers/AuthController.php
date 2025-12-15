<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
   
use Illuminate\Support\Facades\Auth;                                                // Portero
use Illuminate\Support\Facades\Hash;                                                // Encriptador
use Illuminate\Auth\Events\Registered;

use App\Models\User; 

class AuthController extends Controller
{

    // LOGIN
    public function login(Request $request)
    {
        // Verifica credenciales, rechaza si fallan
        if (!Auth::attempt($request->only('email', 'password'))) {
            return response()->json(['exito' => false], 401);;
        }

        // Busca al usuario en la BD
        $user = User::where('email', $request->email)->firstOrFail();

        //Si no ha confirmado el correo bloquea el acceso
        if (! $user->hasVerifiedEmail()) {
        return response()->json([
            'exito' => false,
            'message' => 'Debes confirmar tu correo antes de entrar.',
            'status' => 'unverified' // Para que Flutter sepa cual mostrar
        ], 403); 
        }

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
            'password' => 'required|min:8',             //LA CONTRASEÑA DEBE TENER MINIMO 8 CARACTERES
        ]);

        $user = User::create([
            'name' => $request->name,
            'email' => $request->email,
            'password' => Hash::make($request->password),
        ]);

        event(new Registered($user)); //esto envia el correo automáticamente

        return response()->json([
        'exito' => true,
        'usuario' => $user,
        'message' => 'Usuario registrado. Por favor, confirma tu correo electrónico.'
    ], 201);
    }

    
}
