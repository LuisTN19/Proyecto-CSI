import 'package:flutter/material.dart';

class CampoTextoWidget extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool esSecreto;
  final String? error;

  const CampoTextoWidget({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.esSecreto = false,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    //Error
    final Color errorColor = Theme.of(context).colorScheme.error;
    final Color borderColor = error != null ? errorColor : Colors.white70;
    final Color focusedBorderColor = error != null ? errorColor : Colors.white;

    return TextField(
      controller: controller,
      obscureText: esSecreto,
      style: const TextStyle(color: Colors.white),

      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),

        //Error
        errorText: error,
        errorStyle: TextStyle(color: errorColor, fontWeight: FontWeight.bold),

        prefixIcon: Icon(icon, color: Colors.white70),

        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor),
          borderRadius: BorderRadius.circular(12),
        ),

        // 💡 Borde enfocado: También cambia a rojo si hay error
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: focusedBorderColor, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),

        // 💡 Borde de error: Necesario para que el errorText funcione visualmente
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: errorColor, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),

        // 💡 Borde enfocado con error: Mantiene el color de error y el grosor
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: errorColor, width: 2.5),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
