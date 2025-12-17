<?php

use App\Http\Controllers\ProfileController;
use Illuminate\Support\Facades\Route;
use Illuminate\Http\Request;
use App\Models\User;
//Cambiar contraseña
use Illuminate\Support\Facades\Password;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;

Route::get('/', function () {
    return view('welcome');
});


//VERIFICACIÓN DEL CORREO----------------------------------------------------------------------------------------------------------
Route::get('/email/verify/{id}/{hash}', function (Request $request, $id, $hash) {
    
    // Buscamos al usuario
    $user = User::findOrFail($id);

    // Comprobamos que el enlace sea válido y seguro (Firma digital)
    if (! hash_equals((string) $hash, sha1($user->getEmailForVerification()))) {
        abort(403, 'El enlace no es válido o está manipulado.');
    }

    if (! $request->hasValidSignature()) {
        abort(403, 'El enlace ha expirado o no es válido.');
    }

    // Verificamos, se rellena la fecha en la BD
    if (! $user->hasVerifiedEmail()) {
        $user->markEmailAsVerified();
    }

    return "<h1>¡Correo Verificado!</h1><p>Ya puedes cerrar esta ventana y entrar en la App.</p>";

})->name('verification.verify'); // Este nombre hace que Laravel use ESTA ruta en el email


//CAMBIAR CONTRASEÑA-----------------------------------------------------------------------------------------------------------

// GET: Muestra el formulario cuando hacen clic en el email ->RESET-PASSWORD.BLADE
Route::get('/reset-password/{token}', function ($token) {
    return view('reset-password', ['token' => $token]);
})->middleware('guest')->name('password.reset'); //Este nombre es el que busca Laravel

// POST: Procesa el cambio de contraseña
Route::post('/reset-password', function (Request $request) {
    $request->validate([
        'token' => 'required',
        'email' => 'required|email',
        'password' => 'required|min:8|confirmed',
    ]);

    $status = Password::reset(
        $request->only('email', 'password', 'password_confirmation', 'token'),
        function ($user, $password) {
            $user->forceFill([
                'password' => Hash::make($password)
            ])->setRememberToken(Str::random(60));
            $user->save();
            event(new Illuminate\Auth\Events\PasswordReset($user));
        }
    );

    return $status === Password::PASSWORD_RESET
        ? "<h1>¡Contraseña cambiada!</h1><p>Ya puedes volver a la App e iniciar sesión.</p>"
        : back()->withErrors(['email' => [__($status)]]);

})->middleware('guest')->name('password.update');


//-----------------------------------------------------------------------------------------------------------------------------------


Route::get('/dashboard', function () {
    return view('dashboard');
})->middleware(['auth', 'verified'])->name('dashboard');

Route::middleware('auth')->group(function () {
    Route::get('/profile', [ProfileController::class, 'edit'])->name('profile.edit');
    Route::patch('/profile', [ProfileController::class, 'update'])->name('profile.update');
    Route::delete('/profile', [ProfileController::class, 'destroy'])->name('profile.destroy');
});

require __DIR__.'/auth.php';