<!DOCTYPE html>
<html>
<head>
    <title>Restablecer Contraseña</title>
    <style>
        body { font-family: sans-serif; display: flex; justify-content: center; padding-top: 50px; background: #f0f2f5; }
        form { background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); width: 300px; }
        input { width: 100%; padding: 10px; margin: 10px 0; box-sizing: border-box; }
        button { width: 100%; padding: 10px; background: #4CAF50; color: white; border: none; cursor: pointer; }
        .error { color: red; font-size: 0.9em; }
    </style>
</head>
<body>
    <form method="POST" action="{{ route('password.reset.submit') }}">
        @csrf
        <h2 style="text-align:center">Nueva Contraseña</h2>

        <input type="hidden" name="token" value="{{ $token }}">
        
        <label>Correo Electrónico:</label>
        <input type="email" name="email" value="{{ request()->email }}" readonly style="background-color: #e9ecef; cursor: not-allowed;">

        <label>Nueva Contraseña:</label>
        <input type="password" name="password" required placeholder="Mínimo 8 caracteres">

        <label>Confirmar Contraseña:</label>
        <input type="password" name="password_confirmation" required placeholder="Repite la contraseña">

        <button type="submit">Cambiar Contraseña</button>

        @if($errors->any())
            <div class="error">
                @foreach ($errors->all() as $error)
                    <p>{{ $error }}</p>
                @endforeach
            </div>
        @endif
    </form>
</body>
</html>