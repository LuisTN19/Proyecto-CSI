import 'package:flutter/material.dart';


class EventoCardWidget extends StatelessWidget {

  final String titulo;
  final String fecha;
  final Color colorFondo;

  const EventoCardWidget({
    super.key,
    required this.titulo,
    required this.fecha,
    required this.colorFondo,
  });


  @override
  Widget build(BuildContext context) {

    return Card(

      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      elevation: 4,
      color: colorFondo,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),

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
    );
  }
}