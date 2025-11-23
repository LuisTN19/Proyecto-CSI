import 'package:flutter/material.dart';

class HabitosCardWidget extends StatelessWidget {
  final String habito;
  final bool esta_completado;

  final VoidCallback al_pulsar_check;

  const HabitosCardWidget({
    super.key,
    required this.habito,
    required this.esta_completado,
    required this.al_pulsar_check,
  });

  @override
  Widget build(BuildContext contexto) {

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),

      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Text(
                habito,
                style: TextStyle(
                  fontSize: 20,
                  color: esta_completado ? Colors.grey : Colors.white,
                  decoration: esta_completado
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),

              IconButton(
                icon: Icon(
                  esta_completado
                      ? Icons.check_circle  // s está completado, muestra el círculo lleno
                      : Icons.radio_button_unchecked, // si no, vacío

                  color: esta_completado ? Colors.green : Colors.white,
                  size: 30,
                ),


                onPressed: al_pulsar_check,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
