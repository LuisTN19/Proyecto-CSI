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

  //Errores
  String mensaje_de_error = "";
  String? _errorNombre;
  String? _errorEmail;
  String? _errorPassword;
  String? _errorConfirmPassword;

  //----------------------------------------------------------------------------

  void _registrarse() async {
    String nombre = _nombreController.text;
    String email = _emailController.text;
    String pass1 = _passwordController.text;
    String pass2 = _confirmPasswordController.text;

    setState(() {
      _errorNombre = null;
      _errorEmail = null;
      _errorPassword = null;
      _errorConfirmPassword = null;
      mensaje_de_error = "";
    });

    bool hayErrorLocal = false;


    if (nombre.isEmpty) {                 //vacio
      _errorNombre = "Introduce un nombre.";
      hayErrorLocal = true;
    }

    if (email.isEmpty) {                //vacio
      _errorEmail = "Introduce un correo electrónico.";
      hayErrorLocal = true;
    } else{                   //formato de correo mal
      if (!email.contains('@') || !email.contains('.') || email.startsWith('@') || email.startsWith('.') || email.endsWith('@') || email.endsWith('.')) {
        _errorEmail = "Introduce un correo electrónico válido.";
        hayErrorLocal = true;
      }if (email.indexOf('.') < email.indexOf('@')) {
        _errorEmail = "Introduce un correo electrónico válido.";
        hayErrorLocal = true;
      }
    }

    if (pass1.isEmpty) {        //vacio
      _errorPassword = "Introduce una contraseña.";
      hayErrorLocal = true;
    }else if (pass1.length < 8) { //minimo 8 caracteres
      _errorPassword = "La contraseña debe tener al menos 8 caracteres.";
      hayErrorLocal = true;
    }


    if (pass2.isEmpty) {              //vacio
      _errorConfirmPassword = "Repite la contraseña.";
      hayErrorLocal = true;
    } else if (pass1 != pass2) {      // no coinciden
      _errorConfirmPassword = "Las contraseñas no coinciden.";
      hayErrorLocal = true;
      if (pass1.isNotEmpty) {
        _errorPassword = "Las contraseñas no coinciden.";
      }
    }

    if (hayErrorLocal) {
      setState(() {});
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
      setState(() { mensaje_de_error = "El correo eléctronico ya está registrado o se ha producido un error"; });
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

              CampoTextoWidget(controller: _nombreController, label: "Nombre", icon: Icons.person, error: _errorNombre,),
              const SizedBox(height: 16),
              CampoTextoWidget(controller: _emailController, label: "Correo Electrónico", icon: Icons.email, error: _errorEmail,),
              const SizedBox(height: 16),
              CampoTextoWidget(controller: _passwordController, label: "Contraseña", icon: Icons.lock, esSecreto: true, error: _errorPassword,),
              const SizedBox(height: 16),
              CampoTextoWidget(controller: _confirmPasswordController, label: "Confirmar Contraseña", icon: Icons.lock_outline, esSecreto: true, error: _errorConfirmPassword,),
              const SizedBox(height: 16),

              if (mensaje_de_error.isNotEmpty)
                Column(
                  children: [
                    const SizedBox(height: 20), // Espacio entre campo y error
                    Container(
                      padding: const EdgeInsets.all(10),
                      width: double.infinity,
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                      child: Text(
                          mensaje_de_error,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)
                      ),
                    ),
                    const SizedBox(height: 20), // Espacio entre error y botón
                  ],
                )
              else
                const SizedBox(height: 2),

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
            ],
          ),
        ),
      ),
    );
  }
}
