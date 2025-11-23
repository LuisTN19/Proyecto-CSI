import 'package:flutter/material.dart';
import 'menu_principal_view.dart';
import 'registro_view.dart';
import '../services/login_service.dart';
import '../widgets/fondo_degradado_scaffold.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String mensaje_de_error = "";

  void _iniciarSesion() async {
    String email = _emailController.text;
    String clave = _passwordController.text;

    // 1. LLAMADA AL SERVICIO
    bool esCorrecto = await LoginService().validar(email, clave);

    // 2. RESULTADO
    if (esCorrecto) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MenuPrincipal()),
        );
      }
    } else {
      setState(() {
        mensaje_de_error = "Usuario o contraseña incorrectos";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // ¡USAMOS TU WIDGET MAESTRO!
    return FondoDegradadoScaffold(

      // AppBar específica del Login
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      // Contenido específico del Login
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.emoji_people, size: 100, color: Colors.white),
              const SizedBox(height: 32),

              const Text(
                "¡Hola de nuevo!",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 48),

              TextField(
                controller: _emailController,
                style: const TextStyle(color: Colors.white),
                decoration: _decoracionInput("Correo Electrónico", Icons.email),
              ),
              const SizedBox(height: 24),

              TextField(
                controller: _passwordController,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: _decoracionInput("Contraseña", Icons.lock),
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _iniciarSesion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purpleAccent.shade700,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 5,
                  ),
                  child: const Text("Iniciar Sesión", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ),

              const SizedBox(height: 32),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("¿No tienes cuenta?", style: TextStyle(color: Colors.white70)),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegistroView()),
                      );
                    },
                    child: const Text("Regístrate aquí", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),

              if (mensaje_de_error.isNotEmpty) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                  child: Text(mensaje_de_error, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }

  // Un pequeño ayudante para no repetir el estilo del input
  InputDecoration _decoracionInput(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      prefixIcon: Icon(icon, color: Colors.white70),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white70),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}