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
  //Errores
  String mensaje_de_error = "";
  String? _errorEmail;
  String? _errorPassword;


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
              //ICONO
              const Icon(Icons.emoji_people, size: 100, color: Colors.white),
              const SizedBox(height: 32),

              //TEXTO
              const Text(
                "¡Hola de nuevo!",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 48),

              //CAMPOS A RELLENAR
              CampoTextoWidget(controller: _emailController, label: "Correo Electrónico", icon: Icons.email, error: _errorEmail,),
              const SizedBox(height: 24),
              CampoTextoWidget(controller: _passwordController, label: "Contraseña", icon: Icons.lock, esSecreto: true, error: _errorPassword,),
              const SizedBox(height: 24),

              //MENSAJE DE ERROR
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
                    const SizedBox(height: 20),
                  ],
                )
              else
                const SizedBox(height: 2),

              //BOTÓN INICIAR SESIÓN
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

              const SizedBox(height: 36),

              //contraseña  olvidada
              TextButton(
                onPressed: _mostrarAlertaRecuperar,
                child: const Text(
                  "¿Has olvidado tu contraseña?",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),

              //para registrarse
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
                    child: const Text("Regístrate aquí", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                  ),
                ],
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  //----------------------------------------------------------------------------

  void _iniciarSesion() async {
    String email = _emailController.text;
    String contrasena = _passwordController.text;

    setState(() {
      _errorEmail = null;
      _errorPassword = null;
      mensaje_de_error = "";
    });

    bool hayErrorLocal = false;

    if (email.isEmpty) {          //campo email vacio
      _errorEmail = "Introduce el correo electrónico.";
      hayErrorLocal = true;
    } else if (!email.contains('@') || !email.contains('.')) {      //formato email incorrecto
      _errorEmail = "Introduce un correo electrónico válido.";
      hayErrorLocal = true;
    }

    if (contrasena.isEmpty) {     //campo contraseña vacio
      _errorPassword = "Introduce la contraseña.";
      hayErrorLocal = true;
    }

    if (hayErrorLocal) {
      setState(() {});
      return;
    }

    //llamamos al servicio
    Map<String, dynamic> respuesta = await LoginService().login(email, contrasena);


    if (respuesta['exito'] == true) {
      //CASO: CORRECTO
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MenuPrincipal()),
        );
      }
    } else if (respuesta['status'] == 'unverified') {
      // CASO: falta verificar correo -> ALERTA
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Verifica tu correo"),
          content: const Text("Aún no has confirmado tu cuenta. Por favor, revisa tu bandeja de entrada (o spam) y pulsa el enlace."),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context), // Cerrar alerta
                child: const Text("Entendido")
            )
          ],
        ),
      );
    } else {
      setState(() {
        mensaje_de_error = "Usuario o contraseña incorrectos";
      });
    }
  }

  //----------------------------------------------------------------------------

  void _mostrarAlertaRecuperar() {
    final emailRecuperarController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Recuperar Contraseña"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Introduce tu correo y te enviaremos un enlace para restablecerla."),
              const SizedBox(height: 10),
              TextField(
                controller: emailRecuperarController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: "ejemplo@correo.com",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () async {
                FocusScope.of(context).unfocus();
                Navigator.pop(dialogContext);

                final service = LoginService();
                final email = emailRecuperarController.text.trim();

                if (email.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Por favor, escribe un correo."))
                  );
                  return;
                }

                bool enviado = await service.recuperarContrasena(email);      //servicio

                if (!mounted) return;

                if (enviado) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("¡Correo enviado! Revisa tu bandeja de entrada."),
                      backgroundColor: Colors.white,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Error: No encontramos ese correo o no está verificado."),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text("Enviar"),
            ),
          ],
        );
      },
    );
  }

}