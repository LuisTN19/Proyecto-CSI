<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

use Illuminate\Auth\Events\Registered;   
use Illuminate\Support\Facades\Auth;                                                // Portero
use Illuminate\Support\Facades\Hash;                                                // Encriptador
use Illuminate\Support\Facades\Password;                                                  


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
        //Si NO HA CONFIRMADO el CORREO bloquea el acceso
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



    //CAMBIAR CONTRASEÑA
    public function cambiar(Request $request)
    {
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
        }

    
}
