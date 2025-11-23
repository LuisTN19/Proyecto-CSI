import 'package:flutter/material.dart';
import '../widgets/fondo_degradado_scaffold.dart';
import 'login_view.dart';

class PerfilView extends StatelessWidget {
  const PerfilView({super.key});

  @override
  Widget build(BuildContext context) {
    return FondoDegradadoScaffold(

      appBar: AppBar(
        title: const Text("Mi Perfil"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.account_circle, size: 100, color: Colors.white),
            const SizedBox(height: 20),

            const Text(
                "Nombre de Usuario",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)
            ),

            const SizedBox(height: 40),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginView()),
                      (route) => false,
                );
              },
              child: const Text("Cerrar Sesión", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}