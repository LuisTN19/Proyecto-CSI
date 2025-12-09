import 'package:flutter/material.dart';


class EventoCardWidget extends StatelessWidget {

  final String titulo;
  final String fecha;
  final Color colorFondo;

  final bool es_seleccionado;
  final bool hay_seleccion_activa;
  final VoidCallback seleccionar;

  const EventoCardWidget({
    super.key,
    required this.titulo,
    required this.fecha,
    required this.colorFondo,

    required this.es_seleccionado,
    required this.hay_seleccion_activa,
    required this.seleccionar,
  });


  @override
  Widget build(BuildContext context) {

    return Card(
      //Multiselcción-----------------------------------------------------------
      color: es_seleccionado ? Colors.blue.shade100 : colorFondo,
      elevation: 2,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: es_seleccionado
            ? const BorderSide(color: Colors.blue, width: 2)
            : BorderSide.none,
      ),

      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),

      child: InkWell(
        onTap: hay_seleccion_activa
            ? seleccionar
            : () {},
        onLongPress: seleccionar,
        //----------------------------------------------------------------------
        borderRadius: BorderRadius.circular(12),

        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,

            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // TÍTULO DEL EVENTO
              Text(
                titulo,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),

              // FECHA CON ICONO
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16, color: Colors.white70),
                  const SizedBox(width: 5),
                  Text(
                    fecha,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
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