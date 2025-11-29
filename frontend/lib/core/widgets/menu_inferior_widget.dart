import 'package:flutter/material.dart';

import '../views/perfil_view.dart';

class MenuInferiorWidget extends StatelessWidget {

  final Widget body;
  final PreferredSizeWidget? appBar;
  final VoidCallback? accionMas;

  // --- ¡NUEVO INGREDIENTE! ---
  final Color colorTema; // El color principal de esta sección (Rojo, Azul, Naranja...)

  const MenuInferiorWidget({
    super.key,
    required this.body,
    this.appBar,
    this.accionMas,
    // Le ponemos un valor por defecto (rojo) por si se nos olvida ponerlo
    this.colorTema = Colors.red,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: body,

      // EL BOTÓN + (Usa el color)
      floatingActionButton: accionMas != null
          ? FloatingActionButton(
        onPressed: accionMas,
        backgroundColor: colorTema, // <--- ¡AQUÍ USAMOS EL COLOR!
        child: const Icon(Icons.add, color: Colors.white),
      )
          : null,

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // LA BARRA DE ABAJO (Usa el color)
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home, size: 30, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            const SizedBox(width: 48),
            IconButton(
              icon: const Icon(Icons.person_outline, size: 30, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PerfilView()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}