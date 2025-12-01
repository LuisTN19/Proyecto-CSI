import 'package:flutter/material.dart';

class HabitosCardWidget extends StatelessWidget {
  final String habito;
  final bool esta_completado;
  final VoidCallback al_pulsar_check;

  final bool es_seleccionado;
  final bool hay_seleccion_activa;
  final VoidCallback seleccionar;

  const HabitosCardWidget({
    super.key,
    required this.habito,
    required this.esta_completado,
    required this.al_pulsar_check,
    required this.es_seleccionado,
    required this.hay_seleccion_activa,
    required this.seleccionar,
  });


  @override
  Widget build(BuildContext contexto) {

    return Card(
      color: es_seleccionado ? Colors.blue.shade100 : null,
      elevation: 2,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: es_seleccionado
            ? const BorderSide(color: Colors.blue, width: 2)
            : BorderSide.none,
      ),

      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),

      child: InkWell(
        onTap: hay_seleccion_activa
            ? seleccionar
            : () {},
        onLongPress: seleccionar,

        borderRadius: BorderRadius.circular(12),

        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              // TEXTO
              Text(
                habito,
                style: TextStyle(
                  fontSize: 20,
                  color: esta_completado ? Colors.green : Colors.white,
                  decoration: esta_completado
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),

              // ICONO
              es_seleccionado
                  ? const Icon(Icons.check_circle, color: Colors.blue, size: 30)
                  : IconButton(
                icon: Icon(
                  esta_completado ? Icons.check_circle : Icons.radio_button_unchecked,
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
