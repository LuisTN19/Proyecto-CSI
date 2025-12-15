<?php

use App\Http\Controllers\ProfileController;
use Illuminate\Support\Facades\Route;
use Illuminate\Http\Request;
use App\Models\User;

Route::get('/', function () {
    return view('welcome');
});


//RUTA PERSONALIZADA DE VERIFICACIÓN (SIN LOGIN OBLIGATORIO)
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



Route::get('/dashboard', function () {
    return view('dashboard');
})->middleware(['auth', 'verified'])->name('dashboard');

Route::middleware('auth')->group(function () {
    Route::get('/profile', [ProfileController::class, 'edit'])->name('profile.edit');
    Route::patch('/profile', [ProfileController::class, 'update'])->name('profile.update');
    Route::delete('/profile', [ProfileController::class, 'destroy'])->name('profile.destroy');
});

require __DIR__.'/auth.php';