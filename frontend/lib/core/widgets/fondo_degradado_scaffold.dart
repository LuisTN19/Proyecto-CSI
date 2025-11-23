import 'package:flutter/material.dart';

class FondoDegradadoScaffold extends StatelessWidget {

  // 1. LOS INGREDIENTES QUE CAMBIAN
  final Widget body; // El contenido (botones, textos...)
  final PreferredSizeWidget? appBar; // La barra de arriba (opcional)

  const FondoDegradadoScaffold({
    super.key,
    required this.body, // Obligatorio
    this.appBar, // Opcional (puede ser null)
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, //para que al hacer el degradado se la pele lo de la appbar

      appBar: appBar, // Ponemos la barra que nos pasen (o ninguna)

      body: Container(
        width: double.infinity,
        height: double.infinity,
        // EL DEGRADADO
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF42A5F5), // Azul
              Color(0xFF7B1FA2), // Morado
              Color(0xFFE91E63), // Rosa
            ],
          ),
        ),

        // AQUÍ METEMOS EL CONTENIDO ESPECÍFICO DE CADA PANTALLA
        child: body,
      ),
    );
  }
}