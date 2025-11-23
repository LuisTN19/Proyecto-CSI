import 'package:flutter/material.dart';
import '../widgets/fondo_degradado_scaffold.dart';
import '../services/login_service.dart';
import 'menu_principal_view.dart'; // <-- Importamos el Menú

class PerfilView extends StatelessWidget {
  const PerfilView({super.key});

  @override
  Widget build(BuildContext context) {

    final String nombre = LoginService.usuarioLogueado?['name'] ?? "Usuario";
    final String email = LoginService.usuarioLogueado?['email'] ?? "Sin email";

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

            Text(
                nombre,
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)
            ),

            const SizedBox(height: 8),

            Text(
                email,
                style: const TextStyle(fontSize: 18, color: Colors.white70)
            ),

            const SizedBox(height: 40),

            // BOTÓN CERRAR SESIÓN (CORREGIDO)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              onPressed: () {
                // 1. Borramos la memoria
                LoginService.usuarioLogueado = null;

                // 2. ¡VOLVEMOS AL MENÚ PRINCIPAL! (No al login)
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const MenuPrincipal()),
                      (route) => false, // Borra el historial para que no puedas volver al perfil con "atrás"
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