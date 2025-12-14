import'package:flutter/material.dart';

import '../widgets/fondo_degradado_scaffold.dart';
import '../widgets/campo_texto_widget.dart';

import 'menu_principal_view.dart';
import 'registro_view.dart';

import '../services/login_service.dart';


class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}


class _LoginViewState extends State<LoginView> {

  final TextEditingController _emailController = TextEditingController(); //controller en flutter -> guardar en texto en memoria para q se vea en la cajita
  final TextEditingController _passwordController = TextEditingController();
  String mensaje_de_error = "";
  String? _errorEmail;
  String? _errorPassword;


  void _iniciarSesion() async {
    String email = _emailController.text;
    String contrasena = _passwordController.text;

    setState(() {
      _errorEmail = null;
      _errorPassword = null;
      mensaje_de_error = ""; // Limpiamos el error global
    });

    bool hayErrorLocal = false;

    if (email.isEmpty) {          //campo email vacio
      _errorEmail = "Introduce el correo electrónico.";
      hayErrorLocal = true;
    } else if (!email.contains('@') || !email.contains('.')) {      //formato email incorrecto
      _errorEmail = "Introduce un correo electrónico válido.";
      hayErrorLocal = true;
    }

    if (contrasena.isEmpty) {     //campo contrase♦a vacio
      _errorPassword = "Introduce la contraseña.";
      hayErrorLocal = true;
    }

    if (hayErrorLocal) {
      setState(() {});
      return;
    }

    //llamamos al servicio
    bool esCorrecto = await LoginService().login(email, contrasena); //espera hasta q el servicio contesta

    if (esCorrecto) {
      if (mounted) { //mounted seguro, como await es asincrono, por si cierras la pantalla antes q la app no explote
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


              CampoTextoWidget(controller: _emailController, label: "Correo Electrónico", icon: Icons.email, error: _errorEmail,),
              const SizedBox(height: 24),
              CampoTextoWidget(controller: _passwordController, label: "Contraseña", icon: Icons.lock, esSecreto: true, error: _errorPassword,),
              const SizedBox(height: 24),

              if (mensaje_de_error.isNotEmpty)
                Column(
                  children: [
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
            ],
          ),
        ),
      ),
    );
  }
}