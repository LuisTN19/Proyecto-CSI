import 'package:flutter/material.dart';

import '../widgets/fondo_degradado_scaffold.dart';
import '../widgets/campo_texto_widget.dart';

import 'menu_principal_view.dart';

import '../services/login_service.dart';


class RegistroView extends StatefulWidget {
  const RegistroView({super.key});

  @override
  State<RegistroView> createState() => _RegistroViewState();
}

class _RegistroViewState extends State<RegistroView> {

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String mensaje_de_error = "";

  //----------------------------------------------------------------------------

  void _registrarse() async {
    String nombre = _nombreController.text;
    String email = _emailController.text;
    String pass1 = _passwordController.text;
    String pass2 = _confirmPasswordController.text;

    if (nombre.isEmpty || email.isEmpty || pass1.isEmpty) {
      setState(() { mensaje_de_error = "Por favor, rellena todos los campos"; });
      return;
    }
    if (pass1 != pass2) {
      setState(() { mensaje_de_error = "Las contraseñas no coinciden"; });
      return;
    }


    bool registroExitoso = await LoginService().registrar(nombre, email, pass1);


    if (registroExitoso) {
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MenuPrincipal()),
              (route) => false,
        );
      }
    } else {
      setState(() { mensaje_de_error = "Error al registrar usuario"; });
    }
  }

  //----------------------------------------------------------------------------


  @override
  Widget build(BuildContext context) {
    return FondoDegradadoScaffold(

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.person_add, size: 80, color: Colors.white),
              const SizedBox(height: 24),
              const Text("Crear Cuenta", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 40),

              CampoTextoWidget(controller: _nombreController, label: "Nombre", icon: Icons.person),
              const SizedBox(height: 16),
              CampoTextoWidget(controller: _emailController, label: "Correo Electrónico", icon: Icons.email),
              const SizedBox(height: 16),
              CampoTextoWidget(controller: _passwordController, label: "Contraseña", icon: Icons.lock, esSecreto: true),
              const SizedBox(height: 16),
              CampoTextoWidget(controller: _confirmPasswordController, label: "Confirmar Contraseña", icon: Icons.lock_outline, esSecreto: true),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _registrarse,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purpleAccent.shade700,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 5,
                  ),
                  child: const Text("Registrarse", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ),

              if (mensaje_de_error.isNotEmpty) ...[
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                  child: Text(mensaje_de_error, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
