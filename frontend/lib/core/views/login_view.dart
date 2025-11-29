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


  void _iniciarSesion() async {
    String email = _emailController.text;
    String contrasena = _passwordController.text;

    //LLAMAMOS AL SERVICIO
    bool esCorrecto = await LoginService().login(email, contrasena); //espera hasta q el servicio contesta

    // 2. RESULTADO
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


              CampoTextoWidget(controller: _emailController, label: "Correo Electrónico", icon: Icons.email,),
              const SizedBox(height: 24),
              CampoTextoWidget(controller: _passwordController, label: "Contraseña", icon: Icons.lock, esSecreto: true,),
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

              if (mensaje_de_error.isNotEmpty) ...[   // ... para poder meter dos cosas distintas (el espacio de separación y el mensaje de error) en la columna usando un solo if.
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



}